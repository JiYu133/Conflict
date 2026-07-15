class_name FreeCameraController
extends Node

# 调试用自由视角，F 键切换，仅在 debug 构建下生效
# 鼠标左键 / T/Y/U 键从准星方向发射 hitscan 测试伤害系统

@export var move_speed: float = 5.0
@export var fast_speed: float = 15.0
@export var sensitivity: float = 0.003

var _active: bool = false
var _free_cam: Camera3D
var _pitch: float = 0.0
var _yaw: float = 0.0
var _player: BasePlayer
var _camera_controller: PlayerCameraController
var _was_controllable: bool = false

# 准星 UI
var _crosshair_canvas: CanvasLayer
var _label_part: Label
var _label_status: Label
var _label_alpha: float = 0.0

# 瞄准缓存
var _aimed_part: int = -1
var _aimed_health_system: HealthSystem = null

const PART_NAMES := {
	MedicalEnums.BodyPartId.HEAD:           "头部",
	MedicalEnums.BodyPartId.TORSO:          "躯干",
	MedicalEnums.BodyPartId.LEFT_UPPER_ARM: "左上臂",
	MedicalEnums.BodyPartId.LEFT_FOREARM:   "左前臂",
	MedicalEnums.BodyPartId.RIGHT_UPPER_ARM:"右上臂",
	MedicalEnums.BodyPartId.RIGHT_FOREARM:  "右前臂",
	MedicalEnums.BodyPartId.LEFT_THIGH:     "左大腿",
	MedicalEnums.BodyPartId.LEFT_CALF:      "左小腿",
	MedicalEnums.BodyPartId.RIGHT_THIGH:    "右大腿",
	MedicalEnums.BodyPartId.RIGHT_CALF:     "右小腿",
}


func initialize(player: BasePlayer, camera_controller: PlayerCameraController) -> void:
	_player = player
	_camera_controller = camera_controller
	_build_crosshair()


func _build_crosshair() -> void:
	_crosshair_canvas = CanvasLayer.new()
	_crosshair_canvas.layer = 127
	_crosshair_canvas.visible = false
	_player.add_child(_crosshair_canvas)

	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_crosshair_canvas.add_child(root)

	const SIZE  := 16
	const GAP   := 3
	const THICK := 2
	const COLOR := Color(0.0, 1.0, 0.0, 1.0)

	var h_left := ColorRect.new()
	h_left.color = COLOR
	h_left.anchor_left = 0.5;  h_left.anchor_right  = 0.5
	h_left.anchor_top  = 0.5;  h_left.anchor_bottom = 0.5
	h_left.offset_left = -(SIZE + GAP);  h_left.offset_right  = -GAP
	h_left.offset_top  = -THICK / 2.0;  h_left.offset_bottom = THICK / 2.0
	root.add_child(h_left)

	var h_right := ColorRect.new()
	h_right.color = COLOR
	h_right.anchor_left = 0.5;  h_right.anchor_right  = 0.5
	h_right.anchor_top  = 0.5;  h_right.anchor_bottom = 0.5
	h_right.offset_left = GAP;          h_right.offset_right  = SIZE + GAP
	h_right.offset_top  = -THICK / 2.0; h_right.offset_bottom = THICK / 2.0
	root.add_child(h_right)

	var v_top := ColorRect.new()
	v_top.color = COLOR
	v_top.anchor_left = 0.5;  v_top.anchor_right  = 0.5
	v_top.anchor_top  = 0.5;  v_top.anchor_bottom = 0.5
	v_top.offset_left = -THICK / 2.0;  v_top.offset_right  = THICK / 2.0
	v_top.offset_top  = -(SIZE + GAP); v_top.offset_bottom = -GAP
	root.add_child(v_top)

	var v_bot := ColorRect.new()
	v_bot.color = COLOR
	v_bot.anchor_left = 0.5;  v_bot.anchor_right  = 0.5
	v_bot.anchor_top  = 0.5;  v_bot.anchor_bottom = 0.5
	v_bot.offset_left = -THICK / 2.0; v_bot.offset_right  = THICK / 2.0
	v_bot.offset_top  = GAP;          v_bot.offset_bottom = SIZE + GAP
	root.add_child(v_bot)

	# 部位名标签
	_label_part = Label.new()
	_label_part.anchor_left = 0.5;  _label_part.anchor_right  = 0.5
	_label_part.anchor_top  = 0.5;  _label_part.anchor_bottom = 0.5
	_label_part.offset_left   = -80.0;  _label_part.offset_right  =  80.0
	_label_part.offset_top    = SIZE + GAP + 6.0
	_label_part.offset_bottom = SIZE + GAP + 22.0
	_label_part.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label_part.add_theme_font_size_override("font_size", 14)
	_label_part.add_theme_color_override("font_shadow_color", Color.BLACK)
	_label_part.add_theme_constant_override("shadow_offset_x", 1)
	_label_part.add_theme_constant_override("shadow_offset_y", 1)
	_label_part.modulate.a = 0.0
	root.add_child(_label_part)

	# 伤情状态标签
	_label_status = Label.new()
	_label_status.anchor_left = 0.5;  _label_status.anchor_right  = 0.5
	_label_status.anchor_top  = 0.5;  _label_status.anchor_bottom = 0.5
	_label_status.offset_left   = -80.0;  _label_status.offset_right  =  80.0
	_label_status.offset_top    = SIZE + GAP + 24.0
	_label_status.offset_bottom = SIZE + GAP + 38.0
	_label_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label_status.add_theme_font_size_override("font_size", 12)
	_label_status.add_theme_color_override("font_shadow_color", Color.BLACK)
	_label_status.add_theme_constant_override("shadow_offset_x", 1)
	_label_status.add_theme_constant_override("shadow_offset_y", 1)
	_label_status.modulate.a = 0.0
	root.add_child(_label_status)


func toggle() -> void:
	if _active:
		_exit()
	else:
		_enter()


func _enter() -> void:
	_active = true
	_was_controllable = _player.controllable
	_player.set_controllable(false)

	var current_cam := _camera_controller.get_active_camera()
	_free_cam = Camera3D.new()
	_free_cam.name = "FreeCam"
	if current_cam:
		_free_cam.global_transform = current_cam.global_transform
		_pitch = current_cam.global_rotation.x
		_yaw   = current_cam.global_rotation.y
		_free_cam.fov = current_cam.fov
		_free_cam.cull_mask = current_cam.cull_mask | 2
	_player.add_child(_free_cam)
	_free_cam.current = true

	_crosshair_canvas.visible = true
	GlobalLogger.info("FreeCam", "自由视角已启用，WASD/QE 移动，Shift 加速，左键/T/Y/U 射击，F 退出")


func _exit() -> void:
	_active = false
	_crosshair_canvas.visible = false
	_label_part.text = ""
	_label_status.text = ""
	_label_alpha = 0.0
	_aimed_part = -1
	_aimed_health_system = null

	# 死亡后（布娃娃摄像机模式）不恢复原摄像机，
	# PlayerCameraController 的死亡模式会继续跟随头骨骼。
	# 存活时才切回原摄像机。
	if _player.is_alive:
		var original_cam := _camera_controller.get_active_camera()
		if original_cam:
			original_cam.current = true

	if _free_cam and is_instance_valid(_free_cam):
		_free_cam.queue_free()
	_free_cam = null

	_player.set_controllable(_was_controllable and _player.is_alive)
	GlobalLogger.info("FreeCam", "自由视角已退出")


func _input(event: InputEvent) -> void:
	if not _active or not _free_cam:
		return

	if event is InputEventMouseMotion:
		_yaw   -= event.relative.x * sensitivity
		_pitch -= event.relative.y * sensitivity
		_pitch  = clamp(_pitch, -PI / 2.0 + 0.01, PI / 2.0 - 0.01)
		_free_cam.global_rotation = Vector3(_pitch, _yaw, 0.0)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_fire_hitscan(800.0, MedicalEnums.DamageType.BULLET, null)


func debug_shoot(forced_part: MedicalEnums.BodyPartId) -> void:
	if not _active or not _free_cam:
		return
	_fire_hitscan(5000.0, MedicalEnums.DamageType.BULLET, forced_part)


func debug_shoot_explosion() -> void:
	if not _active or not _free_cam:
		return
	_fire_hitscan(8000.0, MedicalEnums.DamageType.EXPLOSION, MedicalEnums.BodyPartId.TORSO)


func _fire_hitscan(energy: float, dmg_type: MedicalEnums.DamageType, forced_part) -> void:
	var origin  := _free_cam.global_position
	var forward := -_free_cam.global_transform.basis.z

	var query := PhysicsRayQueryParameters3D.create(origin, origin + forward * 2000.0)
	query.collision_mask = 2
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [_player.get_rid()]

	var result := _player.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		GlobalLogger.debug("FreeCam", "射击未命中")
		return

	var collider: Object = result.collider
	var health_system := _find_health_system(collider)
	if not health_system:
		GlobalLogger.debug("FreeCam", "命中 %s，无 HealthSystem" % collider.name)
		return

	var info := DamageInfo.new()
	info.amount       = energy
	info.type         = dmg_type
	info.direction    = forward
	info.hit_position = result.position
	info.source       = _free_cam

	if forced_part != null:
		info.body_part = forced_part
	elif collider.has_method("get_body_part_id"):
		info.body_part = collider.get_body_part_id()
	else:
		info.body_part = MedicalEnums.BodyPartId.TORSO

	health_system.apply_damage(info)
	_spawn_hit_marker(result.position)
	GlobalLogger.info("FreeCam", "命中 %s @ %s  %.0f J" % [
		PART_NAMES.get(info.body_part, "未知"), result.position, energy
	])


func _spawn_hit_marker(pos: Vector3) -> void:
	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.12, 0.12, 0.12)
	mesh_inst.mesh = box

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1, 0, 0, 0.45)
	mat.flags_transparent = true
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_inst.material_override = mat
	mesh_inst.global_position = pos
	_player.get_tree().current_scene.add_child(mesh_inst)

	var tween := mesh_inst.create_tween()
	tween.tween_interval(1.4)
	tween.tween_property(mat, "albedo_color:a", 0.0, 0.6)
	tween.tween_callback(mesh_inst.queue_free)


func _find_health_system(collider: Object) -> HealthSystem:
	var node := collider as Node
	while node:
		if node.has_node("HealthSystem"):
			return node.get_node("HealthSystem") as HealthSystem
		node = node.get_parent()
	return null


func _physics_process(_delta: float) -> void:
	if not _active or not _free_cam:
		return

	var origin  := _free_cam.global_position
	var forward := -_free_cam.global_transform.basis.z
	var query := PhysicsRayQueryParameters3D.create(origin, origin + forward * 2000.0)
	query.collision_mask = 2
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [_player.get_rid()]
	var space := _player.get_world_3d().direct_space_state
	if not space:
		return

	var result := space.intersect_ray(query)
	if not result.is_empty() and result.collider.has_method("get_body_part_id"):
		_aimed_part = result.collider.get_body_part_id()
		_aimed_health_system = _find_health_system(result.collider)
	else:
		_aimed_part = -1
		_aimed_health_system = null


func _process(delta: float) -> void:
	if not _active or not _free_cam:
		return

	# 淡入淡出
	if _aimed_part >= 0:
		_label_alpha = move_toward(_label_alpha, 1.0, delta * 8.0)
	else:
		_label_alpha = move_toward(_label_alpha, 0.0, delta * 5.0)

	_label_part.modulate.a = _label_alpha
	_label_status.modulate.a = _label_alpha

	# 更新文字和颜色
	if _aimed_part >= 0 and _aimed_health_system:
		var part_name : String = PART_NAMES.get(_aimed_part, "未知")
		var part_color := _get_part_color(_aimed_part)
		var region := _aimed_health_system.vitals.get_region(_aimed_part)

		_label_part.text = part_name
		_label_part.add_theme_color_override("font_color", part_color)

		if region:
			var status := _get_status_text(region)
			_label_status.text = status.text
			_label_status.add_theme_color_override("font_color", status.color)
		else:
			_label_status.text = "健康"
			_label_status.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
	else:
		_label_part.text = ""
		_label_status.text = ""

	# 移动
	var speed := fast_speed if Input.is_key_pressed(KEY_SHIFT) else move_speed
	var dir := Vector3.ZERO

	if Input.is_key_pressed(KEY_W): dir -= _free_cam.global_transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += _free_cam.global_transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= _free_cam.global_transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += _free_cam.global_transform.basis.x
	if Input.is_key_pressed(KEY_Q): dir -= _free_cam.global_transform.basis.y
	if Input.is_key_pressed(KEY_E): dir += _free_cam.global_transform.basis.y

	if dir.length_squared() > 0.0:
		_free_cam.global_position += dir.normalized() * speed * delta


func _get_part_color(part: int) -> Color:
	match part:
		MedicalEnums.BodyPartId.HEAD, MedicalEnums.BodyPartId.TORSO:
			return Color(1.0, 0.2, 0.2)
		MedicalEnums.BodyPartId.LEFT_THIGH, MedicalEnums.BodyPartId.RIGHT_THIGH:
			return Color(1.0, 0.55, 0.0)
		_:
			return Color(1.0, 0.9, 0.2)


func _get_status_text(region: BodyRegion) -> Dictionary:
	if region.wounds.is_empty():
		return {"text": "健康", "color": Color(0.5, 1.0, 0.5)}

	var has_arterial := false
	var has_venous := false
	var has_capillary := false

	for w in region.wounds:
		var wound := w as Wound
		if wound.bleed_rate == MedicalEnums.BleedRate.ARTERIAL:
			has_arterial = true
		elif wound.bleed_rate == MedicalEnums.BleedRate.VENOUS:
			has_venous = true
		elif wound.bleed_rate == MedicalEnums.BleedRate.CAPILLARY:
			has_capillary = true

	if has_arterial:
		return {"text": "⚠ 动脉出血", "color": Color(1.0, 0.2, 0.2)}
	elif has_venous:
		return {"text": "静脉出血", "color": Color(1.0, 0.55, 0.0)}
	elif has_capillary:
		return {"text": "渗血", "color": Color(1.0, 0.9, 0.2)}
	else:
		return {"text": "受伤", "color": Color(1.0, 1.0, 1.0)}
