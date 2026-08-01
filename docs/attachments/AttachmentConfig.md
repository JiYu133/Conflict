# AttachmentConfig

**脚本路径：** `classes/weapon/weaponattachments/attachment_config.gd`
**资源路径：** `res/config/weapons/attachments/<配件类型>/*.tres`

## 功能概述

配件的数据档案，一个 `.tres` = 一种配件。由 `AttachmentFactory.create()` 读取后实例化配件节点。

## 关键字段速查

### 槽位约束
| 字段 | 类型 | 说明 |
|------|------|------|
| `attachment_type` | `AttachmentType` | 配件大类型；槽位用它判断是否可以安装 |
| `allowed_slot` | `AttachmentSlot.SlotType` | 旧版单值约束，仅保留兼容；运行时以场景 Marker3D 的 `allowed_attachment_types` 为准 |
| `required_slots` | `Array[SlotType]` | 安装前必须已装的槽位类型列表（空 = 无依赖）|
| `preferred_slot_names` | `Array[String]` | 自动装配时优先尝试的槽位名，按顺序回退；左右导轨用 `["SideRailLeft"]` 或 `["SideRailRight"]` |
| `mount_point_name` | `String` | 旧版单值安装点；`preferred_slot_names` 为空时使用它 |

槽位允许哪些 `attachment_type` 在对应场景的 `AttachmentSlot.allowed_attachment_types` 上多选；留空时使用 `slot_type` 的旧映射兼容。

`required_slots` 示例：瞄具依赖机匣盖上的导轨，填 `[SlotType.RECEIVER_COVER]`，没有机匣盖时安装会被拒绝并打印警告。

### 行为标志
| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `no_visual` | `bool` | `false` | 纯数值配件，不生成 3D 节点（扳机组参数等）|
| `rail_adjustable` | `bool` | `false` | 可沿导轨 Z 轴前后滑动（瞄具等）|
| `rail_offset` | `float` | `0.0` | 装配时的初始导轨偏移（m），非 0 也会应用到固定位置；`rail_adjustable` 只控制 UI 是否可滑动 |
| `rail_offset_min/max` | `float` | `±0.05` | 滑动范围限制 |

同类槽位有多个时，预设自动装配不会只靠场景顺序猜。例如战术灯可以装左/右侧导轨，就在 `preferred_slot_names` 填 `["SideRailLeft"]` 或 `["SideRailRight"]`；如果一侧已被占用，也可以填 `["SideRailLeft", "SideRailRight"]` 让它按顺序回退。

配件的视觉对齐不在此配置里控制：在配件场景内放一个名为 `SnapPoint` 的 `Marker3D` 即启用精确对齐，没有则回退为原点对齐。详见 `AttachmentManager.md`。

### 数值修正
`hipfire_spread_modifier` / `ads_spread_modifier` / `recoil_vertical_modifier` / `recoil_horizontal_modifier` / `recoil_recovery_modifier` / `ads_speed_modifier` / `weight_kg` / `center_of_mass_local` / `length_modifier` / `damage_modifier`

`recoil_*_modifier` 字段仅作为旧数据兼容保留；新物理后座系统不读取它们。

均为绝对量叠加，负值 = 减少，正值 = 增加。

### 配件子类

枪管、枪机框、弹匣有专属子类，包含物理参数：

| 子类 | 额外字段 |
|------|---------|
| `BarrelConfig` | `barrel_length`, `muzzle_velocity`, `caliber`, `bullet_mass_g`, `ballistic_coefficient`, `propellant_mass_g`, `gas_exit_velocity_mps`, `gas_impulse_factor`, `charge_variation`, `misfire_chance` |
| `BoltCarrierConfig` | `bolt_mass`, `recoil_spring_strength`, `bolt_travel_m`, `stovepipe_chance`, `double_feed_chance` |
| `MagazineConfig` | `magazine_capacity`, `magazine_type`, `has_last_round_hold_open`, `reserve_magazines`, `reload_time`, `reload_empty_time` |
| `MuzzleDeviceConfig` | `gas_impulse_vector`, `gas_impulse_fraction` |
| `GripConfig` | `grip_point_local`, `support_stiffness`, `support_damping` |
| `StockConfig` | `shoulder_contact_local`, `support_stiffness`, `support_damping` |

## AttachmentType 枚举

```
OPTIC / MUZZLE / GRIP / MAGAZINE / BARREL / HANDGUARD / STOCK /
PISTOL_GRIP / RECEIVER_COVER / TRIGGER / CHARGING_HANDLE /
TACTICAL_DEVICE / SIDE / RECEIVER / BOLT_CARRIER / SELECTOR_SWITCH
```
