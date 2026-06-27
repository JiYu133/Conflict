# WeaponConfig

**文件路径：** `Classes/Weapon/Weapon/weapon_config.gd`
**继承自：** `Resource`

## 功能概述

武器参数的中央数据容器。所有子系统（枪机、弹药、导气、后座等）的初始化均依赖此配置。在 Godot 编辑器中创建 `.tres` 资源文件并填入数值，通过 `BaseWeapon.initialize(cfg)` 注入到武器实例。

## 配置参数（@export var）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `weapon_name` | `String` | `"Unnamed Weapon"` | 武器显示名称 |
| `weapon_type` | `String` | `"rifle"` | 武器种类标识（rifle / smg / shotgun / pistol 等） |
| `action_type` | `String` | `"gas_operated"` | 自动方式：gas_operated / blowback / bolt_action / manual |
| `open_bolt` | `bool` | `false` | true = 开膛待击（MG42），false = 闭膛待击（M4A1） |
| `cycle_rate` | `float` | `600.0` | 理论射速（RPM），实际射速受枪机循环时间制约 |
| `bolt_mass` | `float` | `0.3` | 枪机组质量（kg），越大则循环周期越长 |
| `recoil_spring_strength` | `float` | `50.0` | 复进簧刚度（N/m），影响枪机复进速度 |
| `barrel_length` | `float` | `0.415` | 枪管长度（m），影响导气延时和弹头初速 |
| `muzzle_velocity` | `float` | `900.0` | 初速（m/s），也用于计算导气孔延时 |
| `magazine_capacity` | `int` | `30` | 单弹匣容量 |
| `magazine_type` | `String` | `"detachable_box"` | 弹匣类型：detachable_box / integral / belt / tube |
| `has_last_round_hold_open` | `bool` | `true` | 是否支持空仓挂机 |
| `reserve_magazines` | `int` | `4` | 备用弹匣数量（不含枪上弹匣） |
| `fire_modes` | `Array[String]` | `["safe","semi","auto"]` | 可选射击模式列表，按循环顺序排列 |
| `default_fire_mode` | `String` | `"semi"` | 武器出生时的默认射击模式 |
| `reload_time` | `float` | `2.5` | 战术换弹时间（s），膛内有弹时使用 |
| `reload_empty_time` | `float` | `4.0` | 空仓换弹时间（s），膛内无弹时使用 |
| `recoil_vertical` | `float` | `2.0` | 每发子弹垂直后座幅度（度） |
| `recoil_horizontal` | `float` | `0.5` | 每发子弹水平后座幅度（度，左右随机方向） |
| `recoil_recovery_speed` | `float` | `5.0` | 后座回正速度（度/秒） |
| `hipfire_spread` | `float` | `3.0` | 腰射散布（度） |
| `ads_spread` | `float` | `0.1` | 机瞄散布（度） |
| `weight` | `float` | `3.5` | 武器重量（kg，含空弹匣） |
| `weight_affects_movement` | `bool` | `true` | 重量是否影响玩家移动速度 |
| `weapon_scene` | `PackedScene` | — | 武器 3D 模型场景，需含 AnimationPlayer 和挂载点 |
| `weapon_length` | `float` | `0.75` | 武器全长（m），用于顶墙收枪射线检测 |
| `supports_optic` | `bool` | `true` | 是否支持瞄具槽 |
| `supports_muzzle` | `bool` | `true` | 是否支持枪口装置 |
| `supports_underbarrel` | `bool` | `true` | 是否支持下挂导轨 |
| `supports_extended_mag` | `bool` | `true` | 是否支持扩容弹匣 |
| `caliber` | `String` | `"5.45x39mm"` | 弹药口径 |
| `origin_country` | `String` | `"Russia"` | 原产国 |
| `era` | `String` | `"Modern"` | 时代（"Cold War" / "Modern" / "Modernized"） |

## 依赖关系
- **依赖：** 无（纯数据资源）
- **被依赖：** `BaseWeapon`、`BoltComponent`、`AmmoComponent`、`FireControlComponent`、`GasComponent`、`RecoilComponent`、`EjectionComponent`、`WeaponManager`

## 注意事项

- `cycle_rate` 是理论值，实际射速由枪机循环时间（`bolt_mass`、`recoil_spring_strength`、`barrel_length`）共同决定。
- `bullet_type`、`bullet_mass`、`ballistic_coefficient` 等弹种切换字段已预留但注释掉，待后续弹种切换功能启用。
- 一个 `.tres` 文件对应一把武器，不同武器不共享同一个资源实例。
