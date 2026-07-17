class_name AnatomyStructure
extends Resource

# ============================================================
# 内部解剖结构定义（P2）
# 功能：描述单个器官/骨骼/大血管在其所属 hitbox 局部空间中的
#       几何位置（线段 + 半径的胶囊近似）与损伤参数。
# 用法：由 AnatomyConfig 持有；AnatomySolver 用伤道线段与本结构
#       的胶囊体做相交测试，判定弹道是否伤及此结构。
# 调参：全部字段均可在编辑器 .tres 中调整；几何位置可开启
#       医疗 HUD（H 键）的碰撞体可视化进行目视校准。
# ============================================================

@export_group("标识 / Identity")
## 结构唯一 ID（如 &"heart"、&"femur_l"），用于器官状态/骨折记录
@export var structure_id: StringName = &""
## 显示名称（调试 HUD 用）
@export var display_name: String = ""
## 结构类型：器官 / 骨骼 / 大血管
@export var type: MedicalEnums.StructureType = MedicalEnums.StructureType.ORGAN
## 所属身体部位（伤情记录挂到该部位的 BodyRegion）
@export var body_part: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO
## 锚定的骨骼名（决定使用哪个 hitbox 的局部空间，如 "mixamorig_Spine2"）
@export var anchor_bone: String = ""

@export_group("几何 / Geometry（hitbox 局部空间，米）")
## 结构中轴线段起点（hitbox 局部坐标）
@export var start_point: Vector3 = Vector3.ZERO
## 结构中轴线段终点（与起点相同则退化为球体）
@export var end_point: Vector3 = Vector3.ZERO
## 结构半径（米）
@export var radius: float = 0.03

@export_group("损伤判定 / Damage Gates")
## 造成结构损伤所需的最低动能（J）。骨骼即骨折阈值；血管即破裂阈值。
## 低于此值即使伤道贯穿也不产生结构损伤（弹头失能/擦伤）。
@export var min_damage_energy: float = 50.0
## 伤道直接贯穿结构时造成损伤的概率（1.0 = 必定）
@export_range(0.0, 1.0) var direct_hit_probability: float = 1.0
## 伤道处于临时空腔边缘（未直接贯穿）时造成损伤的基础概率；
## 随距离衰减，且随动能增大（空腔更大）而更容易触及
@export_range(0.0, 1.0) var cavity_hit_probability: float = 0.35
## 无伤道信息时（爆炸冲击波、调试注入等）的盲判概率，
## 应约等于该结构在部位截面中的占比
@export_range(0.0, 1.0) var blind_hit_probability: float = 0.1

@export_group("血管参数 / Vessel（type = MAJOR_VESSEL 时生效）")
## 血管破裂后的出血等级
@export var severed_bleed: MedicalEnums.BleedRate = MedicalEnums.BleedRate.ARTERIAL
## true = 内出血（体腔内，绷带无效需填塞/手术）；false = 外部出血
@export var bleed_is_internal: bool = false

@export_group("器官参数 / Organ（type = ORGAN 时生效）")
## 累积器官损伤达到该值 → DESTROYED（0–该值之间为 DAMAGED）
@export var destroy_damage_threshold: float = 1.0
## 器官被摧毁时是否直接致死（心/脑 = true）
@export var lethal_when_destroyed: bool = false
## 器官 DAMAGED 状态产生的内出血等级
@export var internal_bleed_damaged: MedicalEnums.BleedRate = MedicalEnums.BleedRate.VENOUS
## 器官 DESTROYED 状态产生的内出血等级
@export var internal_bleed_destroyed: MedicalEnums.BleedRate = MedicalEnums.BleedRate.ARTERIAL
## 器官受损时对呼吸效率的惩罚（肺 > 0，其他 0；P3 呼吸系统消费）
@export_range(0.0, 1.0) var breathing_penalty: float = 0.0
