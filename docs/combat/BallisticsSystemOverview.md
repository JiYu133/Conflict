# 弹道系统概览

## 核心理念

**没有"伤害值"这个字段。** 弹头只携带质量、速度、弹道系数三个物理量；伤害是命中瞬间由动能 `KE = ½mv²` 现算出来的。因此远距离命中天然更轻、短枪管天然更弱、换更重的弹头天然更狠——这些都不是配表调出来的，是同一条公式的副产品。

**弹丸是数据，不是节点。** 所有在飞弹丸存在于 `BallisticProjectileSystem` 的一个 `Array[Dictionary]` 中，由单个 `Node` 统一推进。全自动连射时不会产生几十个场景节点，也就没有节点创建/销毁的帧率尖峰。

## 文件结构

```
classes/combat/
├── ballistic_projectile_system.gd   ← 飞行时间弹丸的统一模拟器
├── ballistics.gd                    ← 纯静态弹道数学（动能/阻力/偏流）
├── projectile.gd                    ← 瞬时 hitscan 路径（回退方案）
├── ballistic_environment_config.gd  ← 大气与仿真上限
├── ballistic_surface_config.gd      ← 表面穿透/跳弹参数
├── hit_resolver.gd                  ← 命中 → DamageInfo
├── body_hitbox.gd                   ← 存活时的身体部位命中区
├── hitbox_config.gd                 ← 各部位碰撞体形状参数
├── environment_impact_effect.gd     ← 环境命中特效
├── decal_atlas_cache.gd             ← 弹孔贴花图集缓存
└── combat_effects.gd                ← 战斗特效聚合
```

## 一发子弹的生命周期

```text
BaseWeapon._fire_one_round()
        ↓ 读取已装 BarrelConfig（初速/弹头质量/弹道系数）
BallisticProjectileSystem.spawn()
        ↓ 每物理帧
    ├── 空气阻力      dv/dt = −k·v²，k 由弹道系数推导
    ├── 重力下坠      environment_config.gravity_mps2
    ├── 风偏          wind_velocity_mps
    ├── 自转偏流      膛线方向 × 飞行时间
    └── 分段射线      本帧扫过的线段做 intersect_ray
        ↓ 命中
HitResolver.resolve()      ← 用落点实时速度算动能
        ↓ DamageInfo
HealthSystem.apply_damage()
```

关键点在最后一步之前：动能用的是**落点速度**而非枪口初速。速度已经过全程阻力与重力衰减，因此"远距离伤害衰减"不需要任何距离衰减曲线。

## 为什么不是每帧一个点

900 m/s 的弹头在 60 Hz 下每帧前进 15 米。如果只在每帧的落点做点检测，中间这 15 米里的任何目标都会被穿过去。系统改为**分段射线**：每帧对"上一帧位置 → 本帧位置"这条线段做 `intersect_ray`，速度再高也不会漏检。

`max_step_distance_m`（默认 2.0）进一步把单帧位移切成子步，`max_time_step_s`（1/240）限制单步时长——高速弹在薄目标上的命中判定因此保持稳定。

## BallisticEnvironmentConfig

| 分组 | 字段 | 默认 | 说明 |
|---|---|---|---|
| Atmosphere | `gravity_mps2` | 9.80665 | 重力加速度 |
| Atmosphere | `air_density_kg_m3` | 1.225 | 空气密度，影响阻力 |
| Atmosphere | `temperature_c` / `pressure_pa` | 15.0 / 101325 | 大气状态 |
| Atmosphere | `wind_velocity_mps` | ZERO | 风矢量，直接叠加到弹道 |
| Simulation limits | `max_range_m` | 2000.0 | 超程移除 |
| Simulation limits | `max_flight_time_s` | 8.0 | 超时移除（防泄漏兜底） |
| Simulation limits | `minimum_effective_speed_mps` | 40.0 | 低于此速视为失能弹头 |
| Simulation limits | `max_time_step_s` / `max_step_distance_m` | 1/240 / 2.0 | 子步切分精度 |
| Simulation limits | `max_penetrations_per_frame` | 4 | 单帧穿透次数上限 |

`minimum_effective_speed_mps` 的意义不是性能，而是物理：低于 40 m/s 的弹头动能已不足以形成有效伤口，继续模拟只会产生"擦伤式"的无意义命中。

## BallisticSurfaceConfig

穿透与跳弹按材质定义，不按"墙/木头"这类硬编码类型：

| 字段 | 默认 | 说明 |
|---|---|---|
| `material_name` | `hard_surface` | 材质标识 |
| `penetrable` | false | 是否可被穿透 |
| `thickness_m` | 0.1 | 厚度，参与穿透判定 |
| `hardness` | 1.0 | 硬度系数 |
| `energy_loss_factor` | 0.45 | 穿透后保留的动能比例损失 |
| `penetration_resistance_j` | 1000.0 | 穿透所需最低动能（焦耳） |
| `ricochet_angle_deg` | 15.0 | 小于此入射角时发生跳弹 |
| `ricochet_energy_retention` | 0.65 | 跳弹后保留的动能比例 |

因为阈值是**焦耳**而非"能/不能穿"的布尔，同一堵墙对手枪弹和步枪弹的表现自然不同，且穿透后的剩余动能继续参与后续命中的伤害计算。

## 命中解析的两条路径

`HitResolver` 依据被命中的碰撞体类型分流：

- **存活目标** — 命中 `BodyHitbox`（Area3D，layer 2），直接读 `get_body_part_id()`
- **尸体** — 命中布娃娃的 `PhysicalBone3D`，按骨骼名经 `BONE_PART_MAP` 映射部位

两条路径最终产出同一个 `DamageInfo`，交给同一个 `HealthSystem.apply_damage()`。存活目标还会附带伤道信息（`anchor_bone` / `local_entry` / `local_direction`），供 [医疗系统](../player/MedicalSystem.md) 的解剖求解判定是否伤及器官、骨骼或大血管。

## hitscan 回退

`WeaponConfig.use_ballistic_simulation` 关闭时走 `projectile.gd` 的瞬时射线：无飞行时间、无下坠、按枪口初速计算动能。保留这条路径是为了 A/B 对比调参，以及给不需要弹道细节的武器留出口。

## 射手自身排除

弹丸射线携带射手的碰撞体 RID 排除表（`BasePlayer` 胶囊 + 全部 `BodyHitbox`）。摄像机位于射手头部 hitbox 内部，若不排除，从摄像机出发的射线会立刻命中射手自己的头。

## 测试

`tests/ballistic_physics_check.gd` 与 `tests/environment_impact_parse_check.gd` 覆盖弹道积分与表面配置解析。
