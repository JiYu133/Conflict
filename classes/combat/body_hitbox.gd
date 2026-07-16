class_name BodyHitbox
extends Area3D

# ============================================================
# 身体部位碰撞区域（存活时）
# 功能：玩家存活时挂载到骨骼上的命中检测 Area3D。
#       布娃娃激活时销毁，切换到 PhysicalBone3D 接管。
# 用法：由 HealthSystem（P1 后期）或 ModelManager 创建并附加到骨骼。
#       碰撞层 2（与布娃娃物理骨骼同层），mask 0（不主动检测）。
# ============================================================

var _part_id: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO
var _debug_mesh: MeshInstance3D = null


## 初始化本 hitbox 的部位归属和形状
## part_id: 对应的身体部位
## shape: 碰撞形状
## debug_color: 调试网格颜色
func setup(part_id: MedicalEnums.BodyPartId, shape: Shape3D = null, debug_color: Color = Color(0.0, 1.0, 0.0, 0.3)) -> void:
	_part_id = part_id
	collision_layer = 2
	collision_mask = 0

	if shape:
		var col := CollisionShape3D.new()
		col.shape = shape
		add_child(col)

		# 创建调试可视化网格（默认隐藏）
		_create_debug_mesh(shape, debug_color)
		GlobalLogger.debug("BodyHitbox", "Setup hitbox for part: " + MedicalEnums.BodyPartId.keys()[part_id])


## 供 HitResolver 查询部位 ID
func get_body_part_id() -> MedicalEnums.BodyPartId:
	return _part_id


## 切换碰撞体可视化
func set_debug_visible(visible: bool) -> void:
	if _debug_mesh:
		_debug_mesh.visible = visible
		GlobalLogger.debug("BodyHitbox", "%s debug mesh visibility: %s" % [name, visible])


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
