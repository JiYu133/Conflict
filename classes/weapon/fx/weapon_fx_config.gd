class_name WeaponFXConfig
extends Resource

# ============================================================
# 开火表现配置（抛壳 / 枪口焰 / 枪口光照）
#
# 设计原则（对齐《Conflict》开火系统清单）：
#   效果由物理参数动态驱动，不写死数值、不依赖固定动画。
#   枪口焰形态由「枪管长度 + 枪口装置」实时推导，见 resolve_muzzle_profile()。
#
# 素材接口：所有 PackedScene / 音频字段都可以留空。
#   留空时对应效果自动跳过（不报错、不生成节点），
#   美术补上素材后直接填进 .tres 即可生效，无需改代码。
# ============================================================

# ── 抛壳 ─────────────────────────────────────────────────────
@export_group("抛壳 / Shell Ejection")
## 弹壳模型场景（留空 = 用内置占位胶囊体）
@export var shell_scene: PackedScene
## 弹壳质量（kg）。5.45×39 空壳约 6 g
@export var shell_mass_kg: float = 0.006
## 弹壳存活时间（秒），到期淡出销毁；0 = 永不销毁（慎用）
@export var shell_lifetime: float = 20.0
## 同时存在的弹壳上限，超出后回收最早的一枚
@export var shell_max_count: int = 48
## 抛壳初速随机幅度（比例）。0.15 = ±15%，让每次抛壳轨迹不同
@export_range(0.0, 1.0) var shell_velocity_jitter: float = 0.18
## 抛壳翻滚初角速度（弧度/秒）范围
@export var shell_spin_min: float = 8.0
@export var shell_spin_max: float = 22.0
## 弹壳物理材质（弹性/摩擦）。留空 = 使用默认值
@export var shell_physics_material: PhysicsMaterial
## 弹壳落地音效（按地面材质分类由音频系统后续扩展；此处为通用回退）
@export var shell_impact_sounds: Array[AudioStream] = []
## 弹壳落地音量（dB）
@export var shell_impact_volume_db: float = -12.0

# ── 枪口焰 ───────────────────────────────────────────────────
@export_group("枪口焰 / Muzzle Flash")
## 各形态的粒子场景。留空则该形态不生成任何东西。
## 命名与清单一致：短枪管 / 标准 / 长枪管 / 消焰器 / 制退器 / 消音器
@export var flash_scene_short_barrel: PackedScene
@export var flash_scene_standard: PackedScene
@export var flash_scene_long_barrel: PackedScene
@export var flash_scene_flash_hider: PackedScene
@export var flash_scene_muzzle_brake: PackedScene
@export var flash_scene_suppressor_smoke: PackedScene

## 枪管长度分界（米）：短于 short 判为短枪管，长于 long 判为长枪管
@export var short_barrel_threshold: float = 0.32
@export var long_barrel_threshold: float = 0.50

## 枪口焰基准存活时间（秒），实际按枪管长度缩放
@export var flash_base_lifetime: float = 0.045
## 枪口焰基准尺寸倍率，实际按枪管长度缩放
@export var flash_base_scale: float = 1.0

# ── 枪口动态光照 ─────────────────────────────────────────────
@export_group("枪口光照 / Muzzle Light")
## 是否生成一次性动态光照
@export var muzzle_light_enabled: bool = true
## 光照强度（短枪管更亮，见 resolve_muzzle_profile）
@export var muzzle_light_energy: float = 3.2
## 光照范围（米）
@export var muzzle_light_range: float = 6.0
## 光照颜色
@export var muzzle_light_color: Color = Color(1.0, 0.78, 0.45)
## 光照衰减时长（秒）
@export var muzzle_light_decay: float = 0.06

# ── 烟雾 ─────────────────────────────────────────────────────
@export_group("枪口烟雾 / Muzzle Smoke")
## 开火后残留烟雾（通用素材，留空则跳过）
@export var smoke_scene: PackedScene


## 枪口形态枚举，供 FX 控制器选择素材
enum MuzzleProfile {
	SHORT_BARREL,      ## 短枪管：火焰大、不规则、带火星
	STANDARD,          ## 标准枪管：集中、时间短
	LONG_BARREL,       ## 长枪管：小而微弱
	FLASH_HIDER,       ## 消焰器：分散为多道细长火焰
	MUZZLE_BRAKE,      ## 制退器：向侧后方喷射
	SUPPRESSOR,        ## 消音器：仅淡烟
}


## 依据枪管长度与枪口装置推导枪口形态。
## barrel_length: 有效枪管长度（米）
## muzzle_kind: 枪口装置类别，见 MuzzleKind
## 返回 { profile, scene, scale, lifetime, light_energy }
func resolve_muzzle_profile(barrel_length: float, muzzle_kind: int) -> Dictionary:
	var profile: MuzzleProfile
	match muzzle_kind:
		MuzzleKind.SUPPRESSOR:
			profile = MuzzleProfile.SUPPRESSOR
		MuzzleKind.FLASH_HIDER:
			profile = MuzzleProfile.FLASH_HIDER
		MuzzleKind.BRAKE:
			profile = MuzzleProfile.MUZZLE_BRAKE
		_:
			if barrel_length <= short_barrel_threshold:
				profile = MuzzleProfile.SHORT_BARREL
			elif barrel_length >= long_barrel_threshold:
				profile = MuzzleProfile.LONG_BARREL
			else:
				profile = MuzzleProfile.STANDARD

	# 枪管越短，未燃尽火药越多 → 火焰越大越亮、持续越久
	var length_factor: float = clampf(
		inverse_lerp(long_barrel_threshold, short_barrel_threshold, barrel_length), 0.0, 1.0
	)
	var scale_mult: float = lerp(0.65, 1.6, length_factor)
	var life_mult: float = lerp(0.75, 1.45, length_factor)
	var light_mult: float = lerp(0.7, 1.5, length_factor)

	# 装置对形态的额外修正
	match profile:
		MuzzleProfile.SUPPRESSOR:
			scale_mult *= 0.35
			life_mult *= 2.2      # 烟雾飘散更久
			light_mult *= 0.12
		MuzzleProfile.FLASH_HIDER:
			scale_mult *= 0.55
			light_mult *= 0.5
		MuzzleProfile.MUZZLE_BRAKE:
			scale_mult *= 1.15
			light_mult *= 1.2

	return {
		"profile": profile,
		"scene": _scene_for(profile),
		"scale": flash_base_scale * scale_mult,
		"lifetime": flash_base_lifetime * life_mult,
		"light_energy": muzzle_light_energy * light_mult,
	}


## 枪口装置类别（由 FX 控制器根据已装配件判定后传入）
enum MuzzleKind { NONE, FLASH_HIDER, BRAKE, SUPPRESSOR }


func _scene_for(profile: MuzzleProfile) -> PackedScene:
	match profile:
		MuzzleProfile.SHORT_BARREL:  return flash_scene_short_barrel
		MuzzleProfile.LONG_BARREL:   return flash_scene_long_barrel
		MuzzleProfile.FLASH_HIDER:   return flash_scene_flash_hider
		MuzzleProfile.MUZZLE_BRAKE:  return flash_scene_muzzle_brake
		MuzzleProfile.SUPPRESSOR:    return flash_scene_suppressor_smoke
		_:                           return flash_scene_standard
