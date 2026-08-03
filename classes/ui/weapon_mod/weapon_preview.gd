class_name WeaponPreview
extends SubViewport

## 改装界面的武器 3D 预览
## 在独立 World3D 中重建一把与玩家当前武器状态一致的"展示用"武器，
## 侧视取景，并把每个挂载点（AttachmentSlot 是 Marker3D）投影回 2D，
## 供上层界面画引线标注。
##
## 之所以不直接渲染玩家手里那把：那把跟着手骨动画在动，且处于第一人称
## 遮挡层；展示用副本可以自由摆位、自由旋转，互不干扰。

const BG_COLOR := Color(0.043, 0.047, 0.055, 0.0)  # 透明，露出界面自身背景

var _camera: Camera3D
var _pivot: Node3D              # 武器挂在这下面，旋转它即可转枪
var _weapon: BaseWeapon
var _yaw: float = 0.0
var _pitch: float = 0.0
var _frame_distance: float = 1.0
var _frame_center: Vector3 = Vector3.ZERO


func _init() -> void:
	# 必须在任何 3D 子节点加入之前就位，否则子节点入树时拿不到 scenario
	world_3d = World3D.new()
	own_world_3d = true
	transparent_bg = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	size = Vector2i(1280, 720)
	msaa_3d = Viewport.MSAA_4X


func _ready() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = BG_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.62, 0.68, 0.78)
	env.ambient_light_energy = 0.65
	# 轻微泛光，让金属边缘更"展示柜"一些
	env.glow_enabled = true
	env.glow_intensity = 0.25
	env.glow_bloom = 0.05

	_camera = Camera3D.new()
	_camera.environment = env
	_camera.fov = 32.0
	add_child(_camera)

	var key := DirectionalLight3D.new()
	key.light_energy = 1.6
	key.rotation_degrees = Vector3(-28, -46, 0)
	add_child(key)

	var rim := DirectionalLight3D.new()
	rim.light_energy = 0.8
	rim.light_color = Color(0.62, 0.78, 1.0)
	rim.rotation_degrees = Vector3(14, 132, 0)
	add_child(rim)

	_pivot = Node3D.new()
	add_child(_pivot)


## 用给定配置与配件状态重建预览武器。
## attachment_state: { slot_name(String): AttachmentConfig }
func rebuild(config: WeaponConfig, attachment_state: Dictionary) -> void:
	if _weapon and is_instance_valid(_weapon):
		_weapon.queue_free()
	_weapon = null
	if not config or not config.weapon_scene:
		return

	var instance = config.weapon_scene.instantiate()
	if not (instance is BaseWeapon):
		if instance:
			instance.queue_free()
		return
	_weapon = instance as BaseWeapon
	_pivot.add_child(_weapon)
	_weapon.initialize(config)

	# 还原配件（顺序按管理器给出的槽位顺序，保证依赖槽先装）
	if _weapon.attachment_manager:
		for slot in _weapon.attachment_manager.get_slots():
			var key: String = (slot as AttachmentSlot).get_slot_key()
			if not attachment_state.has(key):
				continue
			var cfg: AttachmentConfig = attachment_state[key]
			var att := AttachmentFactory.create(cfg, _weapon)
			if att:
				_weapon.attachment_manager.equip_to_slot(att, key)

	_frame_weapon()


## 依据武器包围盒自动取景（侧视），保证不同长度的枪都能填满画面
func _frame_weapon() -> void:
	var aabb := _compute_aabb(_weapon)
	if aabb.size == Vector3.ZERO:
		aabb = AABB(Vector3(-0.4, -0.15, -0.05), Vector3(0.8, 0.3, 0.1))
	_frame_center = aabb.get_center()
	# 侧面观察：以最长边为准，留出 1.5 倍余量放标注引线
	var span: float = maxf(aabb.size.x, aabb.size.y)
	_frame_distance = maxf(span * 1.5, 0.5)
	_apply_camera()


func _apply_camera() -> void:
	if not _camera:
		return
	var basis := Basis.from_euler(Vector3(_pitch, _yaw, 0.0))
	# 默认从武器左侧看过去（-Z 方向），与玩家视角里的侧面一致
	var offset: Vector3 = basis * Vector3(0.0, 0.06, _frame_distance)
	_camera.global_transform = Transform3D(Basis.IDENTITY, _frame_center + offset)
	_camera.look_at(_frame_center, Vector3.UP)


## 自由旋转（后续可接鼠标拖拽；当前由界面按需调用）
func rotate_view(delta_yaw: float, delta_pitch: float) -> void:
	_yaw += delta_yaw
	_pitch = clampf(_pitch + delta_pitch, -PI / 3.0, PI / 3.0)
	_apply_camera()


func reset_view() -> void:
	_yaw = 0.0
	_pitch = 0.0
	_apply_camera()


func get_weapon() -> BaseWeapon:
	return _weapon


## 把某个挂载点投影到显示区域坐标系。
## display_size: 界面上预览图的实际像素尺寸（TextureRect 大小）
## 返回 Vector2；behind=true 表示该点在相机背面（应隐藏引线）
func project_slot(slot_name: String, display_size: Vector2) -> Dictionary:
	var result := { "position": Vector2.ZERO, "visible": false }
	if not _weapon or not _weapon.attachment_manager or not _camera:
		return result
	var slot: AttachmentSlot = _weapon.attachment_manager.get_slot(slot_name)
	if not slot:
		return result
	var world_pos: Vector3 = slot.global_position
	if _camera.is_position_behind(world_pos):
		return result
	var viewport_pos: Vector2 = _camera.unproject_position(world_pos)
	var scale := display_size / Vector2(size)
	result["position"] = viewport_pos * scale
	result["visible"] = true
	return result


func _compute_aabb(root: Node) -> AABB:
	var result := AABB()
	var found := false
	for node in _collect_visuals(root):
		var mi := node as VisualInstance3D
		var box := mi.get_aabb()
		# 转到武器根节点局部空间
		var xf: Transform3D = mi.global_transform
		var world_box := xf * box
		if not found:
			result = world_box
			found = true
		else:
			result = result.merge(world_box)
	return result if found else AABB()


func _collect_visuals(root: Node) -> Array:
	var out: Array = []
	if not root:
		return out
	if root is VisualInstance3D and root.visible:
		out.append(root)
	for child in root.get_children():
		out.append_array(_collect_visuals(child))
	return out
