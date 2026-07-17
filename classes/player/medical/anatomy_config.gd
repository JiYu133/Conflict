class_name AnatomyConfig
extends Resource

# ============================================================
# 解剖模型配置（P2）
# 功能：持有全身内部结构（器官/骨骼/大血管）定义 + 伤道求解参数。
# 用法：在 HealthConfig.anatomy_config 中引用编辑器创建的 .tres；
#       留空时 HealthSystem 使用 create_default() 的内置人体模板。
# 调参：内置模板的几何位置基于 HitboxConfig 默认尺寸估算，
#       换模型/改 hitbox 尺寸后请开启 H 键可视化目视校准，
#       并在编辑器中创建 .tres 覆盖。
# ============================================================

@export_group("结构列表 / Structures")
## 全身内部结构。留空 = 运行时使用 create_default() 内置模板
@export var structures: Array[AnatomyStructure] = []

@export_group("伤道求解 / Wound Channel")
## 每千焦动能的伤道长度（米/kJ）。5.45×39 满动能 ~1.3kJ → 伤道 ~0.8m（贯穿部位）
@export var penetration_m_per_kj: float = 0.6
## 伤道最小长度（米），低动能弹也至少侵彻这么深
@export var min_channel_length: float = 0.05
## 伤道最大长度（米）
@export var max_channel_length: float = 1.5
## 弹头永久伤道半径（米）
@export var channel_radius: float = 0.006
## 每千焦动能扩张的临时空腔半径（米/kJ）。高速步枪弹的空腔效应
## 使伤道附近未被直接贯穿的血管/器官也可能受损（概率性）
@export var cavity_radius_per_kj: float = 0.03

# 运行时缓存：anchor_bone → Array[AnatomyStructure]
var _bone_lookup: Dictionary = {}


## 返回锚定在指定骨骼上的全部结构（惰性建立缓存）
func get_structures_for_bone(bone_name: String) -> Array:
	if _bone_lookup.is_empty() and not structures.is_empty():
		for s in structures:
			var key: String = (s as AnatomyStructure).anchor_bone
			if not _bone_lookup.has(key):
				_bone_lookup[key] = []
			(_bone_lookup[key] as Array).append(s)
	return _bone_lookup.get(bone_name, [])


## 返回归属指定身体部位的全部结构（盲判回退路径用）
func get_structures_for_part(part: MedicalEnums.BodyPartId) -> Array:
	var result: Array = []
	for s in structures:
		if (s as AnatomyStructure).body_part == part:
			result.append(s)
	return result


# ============================================================
# 内置人体模板
# 几何坐标基于 HitboxConfig 默认尺寸（胸 r0.18/h0.35、腹 r0.16/h0.3、
# 大腿 r0.09/h0.4 等），hitbox 局部空间，胶囊主轴为 Y。
# 左右肢体结构成对生成，X 坐标镜像。
# ============================================================

static func create_default() -> AnatomyConfig:
	var config := AnatomyConfig.new()
	var list: Array[AnatomyStructure] = []

	# ── 头部（球形 hitbox r0.12）────────────────────────────
	list.append(_make(&"brain", "脑", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.HEAD, "mixamorig_Head",
		Vector3(0, -0.01, -0.01), Vector3(0, 0.05, -0.01), 0.07,
		{ "min_damage_energy": 60.0, "blind_hit_probability": 0.5,
		  "destroy_damage_threshold": 0.5, "lethal_when_destroyed": true,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.VENOUS,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.ARTERIAL }))
	list.append(_make(&"skull", "颅骨", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.HEAD, "mixamorig_Head",
		Vector3(0, -0.02, 0), Vector3(0, 0.05, 0), 0.10,
		{ "min_damage_energy": 300.0, "blind_hit_probability": 0.6 }))

	# ── 胸部（Spine2 胶囊 r0.18/h0.35）──────────────────────
	list.append(_make(&"heart", "心脏", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2",
		Vector3(0.02, -0.04, 0.04), Vector3(0.02, 0.05, 0.04), 0.055,
		{ "min_damage_energy": 80.0, "blind_hit_probability": 0.08,
		  "destroy_damage_threshold": 0.6, "lethal_when_destroyed": true,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.ARTERIAL,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.ARTERIAL }))
	list.append(_make(&"lung_l", "左肺", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2",
		Vector3(0.085, -0.08, 0.01), Vector3(0.085, 0.1, 0.01), 0.075,
		{ "min_damage_energy": 60.0, "blind_hit_probability": 0.18,
		  "destroy_damage_threshold": 1.2,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.VENOUS,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.VENOUS,
		  "breathing_penalty": 0.35 }))
	list.append(_make(&"lung_r", "右肺", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2",
		Vector3(-0.085, -0.08, 0.01), Vector3(-0.085, 0.1, 0.01), 0.075,
		{ "min_damage_energy": 60.0, "blind_hit_probability": 0.18,
		  "destroy_damage_threshold": 1.2,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.VENOUS,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.VENOUS,
		  "breathing_penalty": 0.35 }))
	list.append(_make(&"aorta_thoracic", "胸主动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2",
		Vector3(0, -0.12, -0.02), Vector3(0, 0.14, -0.02), 0.013,
		{ "min_damage_energy": 40.0, "blind_hit_probability": 0.03,
		  "direct_hit_probability": 0.95,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": true }))
	list.append(_make(&"spine_thoracic", "胸椎", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2",
		Vector3(0, -0.14, -0.06), Vector3(0, 0.15, -0.06), 0.022,
		{ "min_damage_energy": 500.0, "blind_hit_probability": 0.05 }))

	# ── 腹部（Spine1 胶囊 r0.16/h0.3）───────────────────────
	list.append(_make(&"liver", "肝脏", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine1",
		Vector3(-0.06, 0.02, 0.04), Vector3(-0.01, 0.08, 0.04), 0.06,
		{ "min_damage_energy": 60.0, "blind_hit_probability": 0.15,
		  "destroy_damage_threshold": 1.0,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.VENOUS,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.ARTERIAL }))
	list.append(_make(&"intestines", "肠", MedicalEnums.StructureType.ORGAN,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine1",
		Vector3(0, -0.1, 0.03), Vector3(0, 0.0, 0.03), 0.085,
		{ "min_damage_energy": 40.0, "blind_hit_probability": 0.25,
		  "destroy_damage_threshold": 1.5,
		  "internal_bleed_damaged": MedicalEnums.BleedRate.CAPILLARY,
		  "internal_bleed_destroyed": MedicalEnums.BleedRate.VENOUS }))
	list.append(_make(&"aorta_abdominal", "腹主动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine1",
		Vector3(0, -0.12, -0.02), Vector3(0, 0.12, -0.02), 0.011,
		{ "min_damage_energy": 40.0, "blind_hit_probability": 0.03,
		  "direct_hit_probability": 0.95,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": true }))
	list.append(_make(&"spine_lumbar", "腰椎", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine1",
		Vector3(0, -0.12, -0.055), Vector3(0, 0.12, -0.055), 0.022,
		{ "min_damage_energy": 450.0, "blind_hit_probability": 0.05 }))

	# ── 四肢（左右镜像成对生成）─────────────────────────────
	_append_limb_pair(list, &"femoral_artery", "股动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.LEFT_THIGH, MedicalEnums.BodyPartId.RIGHT_THIGH,
		"mixamorig_LeftUpLeg", "mixamorig_RightUpLeg",
		Vector3(0.025, 0.06, 0.025), Vector3(0.02, 0.18, 0.02), 0.007,
		{ "min_damage_energy": 30.0, "blind_hit_probability": 0.05,
		  "direct_hit_probability": 0.9,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": false })
	_append_limb_pair(list, &"femur", "股骨", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.LEFT_THIGH, MedicalEnums.BodyPartId.RIGHT_THIGH,
		"mixamorig_LeftUpLeg", "mixamorig_RightUpLeg",
		Vector3(0, -0.17, 0), Vector3(0, 0.17, 0), 0.017,
		{ "min_damage_energy": 350.0, "blind_hit_probability": 0.12 })

	_append_limb_pair(list, &"tibial_artery", "胫后动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.LEFT_CALF, MedicalEnums.BodyPartId.RIGHT_CALF,
		"mixamorig_LeftLeg", "mixamorig_RightLeg",
		Vector3(0.01, -0.17, -0.02), Vector3(0.01, 0.15, -0.025), 0.004,
		{ "min_damage_energy": 30.0, "blind_hit_probability": 0.03,
		  "direct_hit_probability": 0.85,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": false })
	_append_limb_pair(list, &"tibia", "胫骨", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.LEFT_CALF, MedicalEnums.BodyPartId.RIGHT_CALF,
		"mixamorig_LeftLeg", "mixamorig_RightLeg",
		Vector3(0, -0.17, 0.01), Vector3(0, 0.17, 0.01), 0.015,
		{ "min_damage_energy": 300.0, "blind_hit_probability": 0.12 })

	_append_limb_pair(list, &"brachial_artery", "肱动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM, MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
		"mixamorig_LeftArm", "mixamorig_RightArm",
		Vector3(0.015, -0.1, 0.015), Vector3(0.015, 0.02, 0.015), 0.005,
		{ "min_damage_energy": 30.0, "blind_hit_probability": 0.04,
		  "direct_hit_probability": 0.9,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": false })
	_append_limb_pair(list, &"humerus", "肱骨", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM, MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
		"mixamorig_LeftArm", "mixamorig_RightArm",
		Vector3(0, -0.11, 0), Vector3(0, 0.02, 0), 0.014,
		{ "min_damage_energy": 250.0, "blind_hit_probability": 0.12 })

	_append_limb_pair(list, &"radial_artery", "桡动脉", MedicalEnums.StructureType.MAJOR_VESSEL,
		MedicalEnums.BodyPartId.LEFT_FOREARM, MedicalEnums.BodyPartId.RIGHT_FOREARM,
		"mixamorig_LeftForeArm", "mixamorig_RightForeArm",
		Vector3(0.01, -0.1, 0.01), Vector3(0.01, 0.02, 0.01), 0.003,
		{ "min_damage_energy": 25.0, "blind_hit_probability": 0.02,
		  "direct_hit_probability": 0.85,
		  "severed_bleed": MedicalEnums.BleedRate.ARTERIAL, "bleed_is_internal": false })
	_append_limb_pair(list, &"forearm_bones", "尺桡骨", MedicalEnums.StructureType.BONE,
		MedicalEnums.BodyPartId.LEFT_FOREARM, MedicalEnums.BodyPartId.RIGHT_FOREARM,
		"mixamorig_LeftForeArm", "mixamorig_RightForeArm",
		Vector3(0, -0.11, 0), Vector3(0, 0.02, 0), 0.013,
		{ "min_damage_energy": 220.0, "blind_hit_probability": 0.12 })

	config.structures = list
	return config


## 构建单个结构；extra 中的键值直接写到同名属性上
static func _make(
	id: StringName, display: String, type: MedicalEnums.StructureType,
	part: MedicalEnums.BodyPartId, bone: String,
	start: Vector3, end: Vector3, r: float,
	extra: Dictionary
) -> AnatomyStructure:
	var s := AnatomyStructure.new()
	s.structure_id = id
	s.display_name = display
	s.type = type
	s.body_part = part
	s.anchor_bone = bone
	s.start_point = start
	s.end_point = end
	s.radius = r
	for key: String in extra:
		s.set(key, extra[key])
	return s


## 左右成对生成：右侧 X 坐标镜像，ID 加 _l/_r 后缀
static func _append_limb_pair(
	list: Array[AnatomyStructure],
	id: StringName, display: String, type: MedicalEnums.StructureType,
	part_l: MedicalEnums.BodyPartId, part_r: MedicalEnums.BodyPartId,
	bone_l: String, bone_r: String,
	start: Vector3, end: Vector3, r: float,
	extra: Dictionary
) -> void:
	list.append(_make(StringName(String(id) + "_l"), "左" + display, type, part_l, bone_l, start, end, r, extra))
	var mirror_start := Vector3(-start.x, start.y, start.z)
	var mirror_end := Vector3(-end.x, end.y, end.z)
	list.append(_make(StringName(String(id) + "_r"), "右" + display, type, part_r, bone_r, mirror_start, mirror_end, r, extra))
