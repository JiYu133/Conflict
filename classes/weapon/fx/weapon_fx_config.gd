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

## Sequence variants. When populated, one scene is selected randomly per shot.
## The legacy single-scene fields above remain valid as fallbacks.
@export var flash_scenes_short_barrel: Array[PackedScene] = []
@export var flash_scenes_standard: Array[PackedScene] = []
@export var flash_scenes_long_barrel: Array[PackedScene] = []
@export var flash_scenes_muzzle_brake_short: Array[PackedScene] = []
@export var flash_scenes_muzzle_brake_standard: Array[PackedScene] = []
@export var flash_scenes_muzzle_brake_long: Array[PackedScene] = []
@export var flash_scenes_suppressor_short: Array[PackedScene] = []
@export var flash_scenes_suppressor_standard: Array[PackedScene] = []
@export var flash_scenes_suppressor_long: Array[PackedScene] = []

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

# ── 枪口热浪 / Heat Haze ─────────────────────────────────────
@export_group("枪口热浪 / Heat Haze")
## 可选的自定义热浪场景；留空时由 WeaponFXController 创建局部折射面
@export var heat_haze_scene: PackedScene
## 热浪噪波贴图。留空时自动尝试加载 res://assets/textures/effects/noise/noise_heat_haze.tres
@export var heat_haze_noise_texture: Texture2D
## 热浪粒子材质；核心屏幕空间扭曲使用 ShaderMaterial，留空时加载默认材质。
@export var heat_haze_material: Material
## 是否启用枪口热浪
@export var heat_haze_enabled: bool = true
## 屏幕折射强度
@export_range(0.0, 0.05, 0.001) var heat_haze_strength: float = 0.006
## 热浪透明度；它只负责扭曲背景，不负责显示枪口焰
@export_range(0.0, 1.0, 0.01) var heat_haze_opacity: float = 0.10
## 每发增加的热量。连续射击会累积，单发不会瞬间达到最大强度。
@export_range(0.01, 1.0, 0.01) var heat_haze_heat_per_shot: float = 0.12
## 停火后的冷却速度；数值越低，枪口热浪残留越久。
@export_range(0.01, 1.0, 0.01) var heat_haze_cooling_rate: float = 0.14
## 热浪节点相对 HeatHaze Marker 沿枪口方向的偏移（米）。
@export_range(0.0, 1.0, 0.01) var heat_haze_offset: float = 0.08
## 热浪达到此热量后才显示，避免冷却末尾留下几乎不可见的采样开销。
@export_range(0.0, 0.2, 0.005) var heat_haze_visibility_threshold: float = 0.01
## 热浪最大热量，限制长时间连射的强度。
@export_range(0.1, 2.0, 0.05) var heat_haze_max_heat: float = 1.0
## 热浪局部平面尺寸（宽度、沿流动方向长度）
@export var heat_haze_size: Vector2 = Vector2(0.22, 0.52)
## 噪波流动速度
@export_range(0.0, 2.0, 0.01) var heat_haze_flow_speed: float = 0.22
## 噪波采样尺度；小于 1 表示更少、更大的热浪扰动区域
@export var heat_haze_noise_scale: Vector2 = Vector2(0.65, 0.90)

## GPU 热浪粒子数量；少量粒子避免全自动射击时堆积。
@export_range(1, 8, 1) var heat_haze_particle_amount: int = 4
## 单次热浪粒子生命周期（秒）。
@export_range(0.05, 0.5, 0.01) var heat_haze_particle_lifetime: float = 0.20
## 粒子最低初速度；方向由 HeatHaze Marker 的局部 Y 轴决定。
@export var heat_haze_velocity_min: float = 0.5
## 粒子最高初速度；每个粒子在范围内随机取值。
@export var heat_haze_velocity_max: float = 1.5
## 粒子扩散角度（度）。
@export_range(0.0, 45.0, 1.0) var heat_haze_spread: float = 20.0
## 粒子初始��最终尺寸的倍率范围，由粒子 Scale Curve 驱动。
@export var heat_haze_particle_scale: Vector2 = Vector2(0.1, 3.0)


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
		"scene": _scene_for(profile, barrel_length),
		"scale": flash_base_scale * scale_mult,
		"lifetime": flash_base_lifetime * life_mult,
		"light_energy": muzzle_light_energy * light_mult,
	}


## 枪口装置类别（由 FX 控制器根据已装配件判定后传入）
enum MuzzleKind { NONE, FLASH_HIDER, BRAKE, SUPPRESSOR }


func _scene_for(profile: MuzzleProfile, barrel_length: float) -> PackedScene:
	var variants := scenes_for_profile(profile, barrel_length)
	if not variants.is_empty():
		return variants.pick_random()
	match profile:
		MuzzleProfile.SHORT_BARREL: return flash_scene_short_barrel
		MuzzleProfile.LONG_BARREL: return flash_scene_long_barrel
		MuzzleProfile.FLASH_HIDER: return flash_scene_flash_hider if flash_scene_flash_hider else flash_scene_standard
		MuzzleProfile.MUZZLE_BRAKE: return flash_scene_muzzle_brake
		MuzzleProfile.SUPPRESSOR: return flash_scene_suppressor_smoke
		_: return flash_scene_standard


func scenes_for_profile(profile: MuzzleProfile, barrel_length: float) -> Array[PackedScene]:
	var length_profile := _length_profile(barrel_length)
	var variants: Array[PackedScene] = []
	match profile:
		MuzzleProfile.SHORT_BARREL:
			variants = flash_scenes_short_barrel
		MuzzleProfile.STANDARD:
			variants = flash_scenes_standard
		MuzzleProfile.LONG_BARREL:
			variants = flash_scenes_long_barrel
		MuzzleProfile.FLASH_HIDER:
			# Flash hiders intentionally reuse the smaller standard-barrel flash.
			variants = flash_scenes_standard
		MuzzleProfile.MUZZLE_BRAKE:
			variants = _muzzle_brake_scenes_for(length_profile)
		MuzzleProfile.SUPPRESSOR:
			variants = _suppressor_scenes_for(length_profile)
	return variants


func _length_profile(barrel_length: float) -> MuzzleProfile:
	if barrel_length <= short_barrel_threshold:
		return MuzzleProfile.SHORT_BARREL
	if barrel_length >= long_barrel_threshold:
		return MuzzleProfile.LONG_BARREL
	return MuzzleProfile.STANDARD


func _muzzle_brake_scenes_for(length_profile: MuzzleProfile) -> Array[PackedScene]:
	match length_profile:
		MuzzleProfile.SHORT_BARREL: return flash_scenes_muzzle_brake_short
		MuzzleProfile.LONG_BARREL: return flash_scenes_muzzle_brake_long
		_: return flash_scenes_muzzle_brake_standard


func _suppressor_scenes_for(length_profile: MuzzleProfile) -> Array[PackedScene]:
	match length_profile:
		MuzzleProfile.SHORT_BARREL: return flash_scenes_suppressor_short
		MuzzleProfile.LONG_BARREL: return flash_scenes_suppressor_long
		_: return flash_scenes_suppressor_standard
