class_name ShellCasing
extends RigidBody3D

# ============================================================
# 抛出的弹壳（P0）
#
# 由 WeaponFXController 在抛壳时生成，赋予初速与翻滚角速度后交给物理引擎。
# 落地后保留在地面，可被踩踏/踢动（普通刚体，参与正常碰撞）。
# 到达寿命后淡出销毁，避免长时间战斗堆积过多刚体。
#
# 素材接口：模型由 WeaponFXConfig.shell_scene 提供；留空时使用内置占位胶囊体。
# ============================================================

## 落地撞击音效（由控制器注入，可为空）
var impact_sounds: Array[AudioStream] = []
var impact_volume_db: float = -12.0

var _lifetime: float = 20.0
var _age: float = 0.0
var _has_played_impact: bool = false
var _audio: AudioStreamPlayer3D


func setup(fx: WeaponFXConfig) -> void:
	_lifetime = fx.shell_lifetime
	impact_sounds = fx.shell_impact_sounds
	impact_volume_db = fx.shell_impact_volume_db
	mass = maxf(fx.shell_mass_kg, 0.0005)
	if fx.shell_physics_material:
		physics_material_override = fx.shell_physics_material
	else:
		# 黄铜壳默认手感：几乎不弹、摩擦中等，落地后会滚一小段
		var mat := PhysicsMaterial.new()
		mat.bounce = 0.22
		mat.friction = 0.6
		physics_material_override = mat

	# 弹壳很小很轻，用连续碰撞检测防止高速穿过地面
	continuous_cd = true
	# 阻尼：没有阻尼时黄铜壳落地后会一直原地打转（角速度无处衰减）。
	# 角阻尼给得比线阻尼大，让它落地后快速停转但仍能滚一小段。
	angular_damp = 4.5
	linear_damp = 0.35
	# 静止后允许进入睡眠，避免几十枚弹壳持续占用物理计算
	can_sleep = true
	contact_monitor = true
	max_contacts_reported = 2
	# 弹壳占用独立层，但只主动检测环境。布娃娃同时从自身掩码中
	# 排除此层，确保双方都不会建立接触约束。
	collision_layer = PhysicsLayers.SHELL_CASING
	collision_mask = PhysicsLayers.WORLD

	body_entered.connect(_on_body_entered)


## 生成碰撞体与占位网格（外部提供模型时只补碰撞体）
func build_visual(shell_scene: PackedScene) -> void:
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.0045   # 5.45mm 壳体半径量级
	capsule.height = 0.039
	shape.shape = capsule
	# 弹壳轴向沿模型 Z，旋转碰撞胶囊与之对齐
	shape.rotation_degrees = Vector3(90, 0, 0)
	add_child(shape)

	if shell_scene:
		var model := shell_scene.instantiate()
		if model:
			add_child(model)
			return

	# 占位网格：没有美术素材时也能看到抛壳，方便先调轨迹
	var mesh_instance := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.0045
	mesh.height = 0.039
	mesh.radial_segments = 6
	mesh.rings = 1
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.72, 0.55, 0.22)   # 黄铜
	mat.metallic = 0.85
	mat.roughness = 0.35
	mesh.surface_set_material(0, mat)
	mesh_instance.mesh = mesh
	mesh_instance.rotation_degrees = Vector3(90, 0, 0)
	add_child(mesh_instance)


func _ready() -> void:
	_audio = AudioStreamPlayer3D.new()
	_audio.unit_size = 3.0
	_audio.max_distance = 18.0
	add_child(_audio)


func _process(delta: float) -> void:
	if _lifetime <= 0.0:
		return
	_age += delta
	if _age < _lifetime:
		return
	# 最后 0.5 秒淡出再销毁，避免"啪"地消失
	var fade: float = clampf((_age - _lifetime) / 0.5, 0.0, 1.0)
	_set_alpha(1.0 - fade)
	if fade >= 1.0:
		queue_free()


func _on_body_entered(_body: Node) -> void:
	if _has_played_impact or impact_sounds.is_empty():
		return
	_has_played_impact = true
	if not _audio:
		return
	_audio.stream = impact_sounds[randi() % impact_sounds.size()]
	_audio.volume_db = impact_volume_db
	# 落地速度越快声音越亮，简单用音高体现
	_audio.pitch_scale = randf_range(0.92, 1.12)
	_audio.play()


func _set_alpha(alpha: float) -> void:
	for child in get_children():
		var mi := child as MeshInstance3D
		if not mi:
			continue
		var mat := mi.get_active_material(0)
		if mat is StandardMaterial3D:
			var sm := mat as StandardMaterial3D
			sm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			sm.albedo_color.a = alpha
