# WeaponConfig

**文件路径：** `Classes/Weapon/Weapon/weapon_config.gd`
**继承自：** `Resource`

## 功能概述

武器参数的中央数据容器。它保存机匣本体、视觉、散布和后座物理基准；枪管、枪机框、弹匣的专属参数由对应的配件配置保存。在 Godot 编辑器中创建 `.tres` 资源文件并填入物理数据，通过 `BaseWeapon.initialize(cfg)` 注入到武器实例。

## 配置参数（@export var）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `weapon_name` | `String` | `"Unnamed Weapon"` | 武器显示名称 |
| `weapon_type` | `String` | `"rifle"` | 武器种类标识（rifle / smg / shotgun / pistol 等） |
| `action_type` | `String` | `"gas_operated"` | 自动方式：gas_operated / blowback / bolt_action / manual |
| `open_bolt` | `bool` | `false` | true = 开膛待击（MG42），false = 闭膛待击（M4A1） |
| `cycle_rate` | `float` | `600.0` | 理论射速（RPM），实际射速受枪机循环时间制约 |
| `fire_modes` | `Array[String]` | `["safe","semi","auto"]` | 可选射击模式列表，按循环顺序排列 |
| `default_fire_mode` | `String` | `"semi"` | 武器出生时的默认射击模式 |
| `hipfire_spread` | `float` | `3.0` | 腰射散布（度） |
| `ads_spread` | `float` | `0.1` | 机瞄散布（度） |
| `weight` | `float` | `3.5` | 武器重量（kg，含空弹匣） |
| `weight_affects_movement` | `bool` | `true` | 重量是否影响玩家移动速度 |
| `weapon_scene` | `PackedScene` | — | 武器 3D 模型场景，需含 AnimationPlayer 和挂载点 |
| `weapon_length` | `float` | `0.75` | 武器全长（m），用于顶墙收枪射线检测 |
| `origin_country` | `String` | `"Russia"` | 原产国 |
| `era` | `String` | `"Modern"` | 时代（"Cold War" / "Modern" / "Modernized"） |

## 依赖关系
- **依赖：** 无（纯数据资源）
- **被依赖：** `BaseWeapon`、`BoltComponent`、`AmmoComponent`、`FireControlComponent`、`GasComponent`、`RecoilComponent`、`EjectionComponent`、`WeaponManager`

## 注意事项

- 枪管物理数据（`barrel_length`、`muzzle_velocity`、弹头/装药质量等）来自 `BarrelConfig`；枪机和弹匣数据分别来自 `BoltCarrierConfig`、`MagazineConfig`。
- 后座不读取固定的 `recoil_vertical` / `recoil_horizontal` / `kick_*` 数值；这些字段仅作为旧资源兼容字段保留。实际结果来自 `RecoilPhysicsModel` 的冲量、力矩、惯量和控枪计算。
- 一个 `.tres` 文件对应一把武器，不同武器不共享同一个资源实例。
