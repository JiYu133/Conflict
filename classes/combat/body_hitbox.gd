class_name BodyHitbox
extends Area3D

# ============================================================
# 身体部位碰撞区域（存活时）
# 功能：玩家存活时挂载到骨骼上的命中检测 Area3D。
#       布娃娃激活时销毁，切换到 PhysicalBone3D 接管。
# 用法：由 HealthSystem（P1 后期）或 ModelManager 创建并附加到骨骼。
#       使用角色物理层（与布娃娃骨骼同层），mask 为 NONE（不主动检测）。
# ============================================================

var _part_id: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO
var _debug_mesh: MeshInstance3D = null
var _anatomy_debug_meshes: Array[MeshInstance3D] = []  # P2 内部结构可视化


## 初始化本 hitbox 的部位归属和形状
## part_id: 对应的身体部位
## shape: 碰撞形状
## debug_color: 调试网格颜色
func setup(part_id: MedicalEnums.BodyPartId, shape: Shape3D = null, debug_color: Color = Color(0.0, 1.0, 0.0, 0.3)) -> void:
	_part_id = part_id
	collision_layer = PhysicsLayers.CHARACTER
	collision_mask = PhysicsLayers.NONE

	if shape:
		var col := CollisionShape3D.new()
		col.shape = shape
		add_child(col)

		# 创建调试可视化网格（默认隐藏）
		_create_debug_mesh(shape, debug_color)


## 供 HitResolver 查询部位 ID
func get_body_part_id() -> MedicalEnums.BodyPartId:
	return _part_id


## 切换碰撞体可视化（含 P2 内部结构网格）
func set_debug_visible(visible: bool) -> void:
	if _debug_mesh:
		_debug_mesh.visible = visible
	for mesh in _anatomy_debug_meshes:
		if is_instance_valid(mesh):
			mesh.visible = visible


## P2：为一个内部解剖结构（器官/骨骼/血管）添加可视化胶囊网格。
## 用于在编辑器/游戏内目视校准 AnatomyConfig 的几何位置（H 键切换显示）。
func add_anatomy_debug_mesh(start_point: Vector3, end_point: Vector3, radius: float, color: Color) -> void:
	var mesh_instance := MeshInstance3D.new()
	var seg: Vector3 = end_point - start_point
	var capsule := CapsuleMesh.new()
	capsule.radius = radius
	capsule.height = seg.length() + radius * 2.0

	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.no_depth_test = true  # 透过 hitbox 网格可见
	capsule.surface_set_material(0, material)
	mesh_instance.mesh = capsule

	# 将胶囊 Y 轴对齐到结构线段方向
	mesh_instance.position = (start_point + end_point) * 0.5
	if seg.length() > 0.0001:
		var dir: Vector3 = seg.normalized()
		if absf(dir.dot(Vector3.UP)) < 0.999:
			var axis: Vector3 = Vector3.UP.cross(dir).normalized()
			mesh_instance.basis = Basis(Quaternion(axis, Vector3.UP.angle_to(dir)))

	mesh_instance.visible = false
	add_child(mesh_instance)
	_anatomy_debug_meshes.append(mesh_instance)


## 创建半透明线框网格显示碰撞体形状
func _create_debug_mesh(shape: Shape3D, debug_color: Color) -> void:
	_debug_mesh = MeshInstance3D.new()

	# 根据形状类型创建对应网格
	if shape is SphereShape3D:
		var sphere := shape as SphereShape3D
		_debug_mesh.mesh = SphereMesh.new()
		(_debug_mesh.mesh as SphereMesh).radius = sphere.radius
		(_debug_mesh.mesh as SphereMesh).height = sphere.radius * 2.0
	elif shape is CapsuleShape3D:
		var capsule := shape as CapsuleShape3D
		_debug_mesh.mesh = CapsuleMesh.new()
		(_debug_mesh.mesh as CapsuleMesh).radius = capsule.radius
		(_debug_mesh.mesh as CapsuleMesh).height = capsule.height
	elif shape is BoxShape3D:
		var box := shape as BoxShape3D
		_debug_mesh.mesh = BoxMesh.new()
		(_debug_mesh.mesh as BoxMesh).size = box.size
	else:
		return

	# 半透明线框材质
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = debug_color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_debug_mesh.mesh.surface_set_material(0, material)

	_debug_mesh.visible = false
	add_child(_debug_mesh)
