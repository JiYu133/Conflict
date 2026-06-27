# AttachmentConfig

**文件路径：** `Classes/Weapon/WeaponAttachments/attachment_config.gd`
**继承自：** `Resource`

## 功能概述

配件配置资源。作为配件的"数据档案"，保存一种配件的全部参数。在 Godot 编辑器中创建 `.tres` 资源并填写数值，被 `AttachmentManager` 加载后自动影响武器数值。一个 `.tres` 文件对应一种配件（红点/全息/ACOG/前握把等）。

## 配置参数（@export var）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `attachment_name` | `String` | `"Unnamed Attachment"` | 配件显示名 |
| `attachment_type` | `AttachmentType` | `OPTIC` | 配件大类（OPTIC / GRIP / MUZZLE / MAGAZINE / SIDE） |
| `allowed_slot` | `AttachmentSlot.SlotType` | `OPTIC_RAIL` | 允许装入的挂载点类型 |
| `requires_existing_attachment` | `bool` | `false` | 是否需要先装有某个配件才能安装 |
| `hipfire_spread_modifier` | `float` | `0.0` | 腰射散布修正（度，负值 = 更准） |
| `ads_spread_modifier` | `float` | `0.0` | 机瞄散布修正（度，负值 = 更准） |
| `recoil_vertical_modifier` | `float` | `0.0` | 垂直后座修正（度，负值 = 减少上跳） |
| `recoil_horizontal_modifier` | `float` | `0.0` | 水平后座修正（度，负值 = 减少偏移） |
| `recoil_recovery_modifier` | `float` | `0.0` | 后座回正速度修正（正值 = 更快回正） |
| `weight_kg` | `float` | `0.1` | 配件重量（kg），叠加到武器总重量 |
| `ads_speed_modifier` | `float` | `0.0` | 瞄准速度修正（正值 = 更快瞄准） |
| `magnification` | `float` | `1.0` | 放大倍率（1.0 = 无放大，4.0 = ACOG 4x） |
| `fov_override` | `float` | `-1.0` | 强制 FOV（-1 表示沿用摄像机 FOV） |
| `has_reticle` | `bool` | `true` | 是否有准星图案 |
| `reticle_color` | `Color` | `Color(1,0,0)` | 准星颜色（红点用红/橙，全息用红） |
| `suppresses_flash` | `bool` | `false` | 是否抑制枪口火光（消音器特有） |
| `suppresses_sound` | `bool` | `false` | 是否抑制枪声（消音器特有） |
| `length_modifier` | `float` | `0.0` | 枪口长度修正（m），影响顶墙收枪检测 |
| `damage_modifier` | `float` | `0.0` | 伤害修正（消音器亚音速弹可能为负值） |
| `attachment_scene` | `PackedScene` | — | 配件 3D 模型场景，挂在武器指定 Marker3D 上 |
| `mount_point_name` | `String` | `""` | 挂载的 Marker3D 节点名（留空使用默认位置） |

## 枚举

```
enum AttachmentType {
    OPTIC,    # 瞄具
    GRIP,     # 握把
    MUZZLE,   # 枪口
    MAGAZINE, # 弹匣
    SIDE      # 侧挂
}
```

## 依赖关系
- **依赖：** `AttachmentSlot`（引用 `SlotType` 枚举）
- **被依赖：** `BaseAttachment`（持有 `config` 引用，所有数值读取方法均从此资源取值）、`AttachmentSlot`（装备时检查 `allowed_slot`）

## 注意事项

- 所有数值修正均为绝对值叠加，不是百分比乘数；多个同类配件的修正会被 `AttachmentManager` 线性累加。
- `damage_modifier` 目前已声明但具体消费逻辑尚未实现（无伤害计算系统引用此字段）。
- `requires_existing_attachment` 目前已声明但 `AttachmentSlot.attach()` 未检查此约束，需后续实现。
