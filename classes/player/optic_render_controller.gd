class_name OpticRenderController
extends Node

## Local-player-only renderer for magnified and unmagnified optic lenses.
## The scope camera shares the gameplay World3D but excludes the local weapon
## render layer so the lens cannot recursively render itself or the receiver.

const VIEWPORT_SIZE := Vector2i(512, 512)
const LOCAL_WEAPON_RENDER_LAYER := 20
const MODE_PIXEL_ZOOM := "pixel_zoom"
const MODE_DUAL_CAMERA := "dual_camera"
const PIXEL_ZOOM_SHADER := """
shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float magnification = 4.0;

void fragment() {
	vec2 sample_uv = (SCREEN_UV - vec2(0.5)) / max(magnification, 1.0) + vec2(0.5);
	ALBEDO = textureLod(screen_texture, clamp(sample_uv, vec2(0.0), vec2(1.0)), 0.0).rgb;
	ALPHA = 1.0;
}
"""

var _player: BasePlayer
var _weapon_manager: WeaponManager
var _camera_controller: PlayerCameraController
var _viewport: SubViewport
var _scope_camera: Camera3D
var _optic: OpticAttachment
var _lens: MeshInstance3D
var _original_lens_material: Material
var _scope_lens_material: StandardMaterial3D
var _pixel_zoom_lens_material: ShaderMaterial
var _weapon_layers: Dictionary = {}
var _active_render_mode := MODE_DUAL_CAMERA


func initialize(
	player: BasePlayer,
	weapon_manager: WeaponManager,
	camera_controller: PlayerCameraController
) -> void:
	_player = player
	_weapon_manager = weapon_manager
	_camera_controller = camera_controller
	_create_render_nodes()
	_weapon_manager.weapon_changed.connect(_on_weapon_changed)
	_weapon_manager.weapon_stats_changed.connect(_refresh_binding)
	_weapon_manager.aiming_changed.connect(_on_aiming_changed)
	_camera_controller.camera_ready.connect(_on_camera_ready)
	_refresh_binding()


func _create_render_nodes() -> void:
	_viewport = SubViewport.new()
	_viewport.name = "OpticViewport"
	_viewport.size = VIEWPORT_SIZE
	_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	_viewport.msaa_3d = Viewport.MSAA_2X
	add_child(_viewport)

	_scope_camera = Camera3D.new()
	_scope_camera.name = "OpticCamera"
	_scope_camera.current = true
	_viewport.add_child(_scope_camera)


func _process(_delta: float) -> void:
	if not is_instance_valid(_optic) or not is_instance_valid(_lens):
		_disable_rendering()
		return
	var main_camera := _camera_controller.get_active_camera()
	var camera_anchor := _optic.get_optic_camera_anchor()
	if not is_instance_valid(main_camera) or not is_instance_valid(camera_anchor):
		_disable_rendering()
		return

	var progress := _camera_controller.get_ads_progress()
	var active := _weapon_manager.is_aiming or progress > 0.001
	_lens.visible = true
	if not active:
		_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
		_lens.material_override = _original_lens_material
		return

	var magnification := maxf(_optic.get_magnification(), 1.0)
	_active_render_mode = _resolve_render_mode(magnification)
	if _active_render_mode == MODE_PIXEL_ZOOM:
		_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
		_pixel_zoom_lens_material.set_shader_parameter("magnification", magnification)
		_lens.material_override = _pixel_zoom_lens_material
		return
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_lens.material_override = _scope_lens_material

	_scope_camera.global_transform = camera_anchor.global_transform
	_scope_camera.near = main_camera.near
	_scope_camera.far = main_camera.far
	_scope_camera.keep_aspect = main_camera.keep_aspect
	_scope_camera.attributes = main_camera.attributes
	_scope_camera.cull_mask = main_camera.cull_mask
	_scope_camera.set_cull_mask_value(LOCAL_WEAPON_RENDER_LAYER, false)
	_scope_camera.fov = rad_to_deg(
		2.0 * atan(tan(deg_to_rad(main_camera.fov) * 0.5) / magnification)
	)


func _refresh_binding() -> void:
	_unbind_optic()
	if not is_instance_valid(_weapon_manager) or not is_instance_valid(_weapon_manager.current_weapon):
		return
	var weapon := _weapon_manager.current_weapon
	_optic = weapon.get_active_optic_attachment()
	if not is_instance_valid(_optic) or not _optic.supports_scope_rendering():
		_optic = null
		return
	_lens = _optic.get_lens_surface()
	if not is_instance_valid(_lens):
		_optic = null
		return
	_set_local_weapon_render_layer(weapon)
	_original_lens_material = _lens.material_override
	_scope_lens_material = StandardMaterial3D.new()
	_scope_lens_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_scope_lens_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_scope_lens_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_scope_lens_material.albedo_texture = _viewport.get_texture()
	var pixel_shader := Shader.new()
	pixel_shader.code = PIXEL_ZOOM_SHADER
	_pixel_zoom_lens_material = ShaderMaterial.new()
	_pixel_zoom_lens_material.shader = pixel_shader
	_lens.material_override = _original_lens_material
	_lens.visible = true


func _unbind_optic() -> void:
	_disable_rendering()
	if is_instance_valid(_lens):
		_lens.material_override = _original_lens_material
	_restore_weapon_render_layers()
	_optic = null
	_lens = null
	_original_lens_material = null
	_scope_lens_material = null
	_pixel_zoom_lens_material = null
	_active_render_mode = MODE_DUAL_CAMERA


func _resolve_render_mode(magnification: float) -> String:
	# The player choice is intentionally ignored by 1x optics. Iron sights do
	# not bind this renderer at all, so neither class changes behavior.
	if magnification <= 1.001:
		return MODE_DUAL_CAMERA
	if not is_instance_valid(_player) or not _player.settings_service:
		return MODE_PIXEL_ZOOM
	var value := String(_player.settings_service.get_value(
		"graphics/magnified_scope_mode", MODE_PIXEL_ZOOM
	))
	return value if value in [MODE_PIXEL_ZOOM, MODE_DUAL_CAMERA] else MODE_PIXEL_ZOOM


func _set_local_weapon_render_layer(weapon: BaseWeapon) -> void:
	_weapon_layers.clear()
	var meshes := weapon.find_children("*", "VisualInstance3D", true, false)
	for node in meshes:
		var visual := node as VisualInstance3D
		if not visual:
			continue
		_weapon_layers[visual] = visual.layers
		visual.layers = 0
		visual.set_layer_mask_value(LOCAL_WEAPON_RENDER_LAYER, true)


func _restore_weapon_render_layers() -> void:
	for raw_visual in _weapon_layers:
		var visual := raw_visual as VisualInstance3D
		if is_instance_valid(visual):
			visual.layers = int(_weapon_layers[raw_visual])
	_weapon_layers.clear()


func _disable_rendering() -> void:
	if is_instance_valid(_viewport):
		_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	if is_instance_valid(_lens):
		_lens.material_override = _original_lens_material


func _on_weapon_changed(_weapon: BaseWeapon) -> void:
	_refresh_binding.call_deferred()


func _on_aiming_changed(_aiming: bool) -> void:
	if not _weapon_manager.is_aiming and is_instance_valid(_lens):
		# The camera controller keeps rendering during ADS-out via its progress.
		set_process(true)


func _on_camera_ready(_camera: Camera3D) -> void:
	if is_instance_valid(_player) and is_instance_valid(_viewport):
		_viewport.world_3d = _player.get_world_3d()


func get_optic_viewport() -> SubViewport:
	return _viewport


func get_scope_camera() -> Camera3D:
	return _scope_camera


func get_bound_optic() -> OpticAttachment:
	return _optic


func get_active_render_mode() -> String:
	return _active_render_mode
