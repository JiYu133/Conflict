# BaseAttachment

**文件路径：** `classes/weapon/weaponattachments/base_attachment.gd`
**继承自：** `Node3D`

## 功能概述

所有配件的基类。持有 `AttachmentConfig` 引用，通过统一接口向 `AttachmentManager` 提供数值修正。子类可重写各修正方法实现条件逻辑。

`no_visual = true` 的配件实例不会出现在场景树中，但所有方法照常工作。

## 初始化

```gdscript
initialize(cfg: AttachmentConfig, weapon: BaseWeapon) -> void
```

注入配置和武器引用，调用 `_on_initialized()` 供子类扩展。`parent_weapon` 可能在 `AttachmentManager.equip_to_slot()` 中被覆盖赋值。

## 公开属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `AttachmentConfig` | 配件配置资源 |
| `parent_weapon` | `BaseWeapon` | 所属武器引用（初始为 null） |

## 数值接口

全部直接读 `config` 字段，子类可重写：

`get_spread_modifier(is_ads)` / `get_recoil_vertical_modifier()` / `get_recoil_horizontal_modifier()` / `get_recoil_recovery_modifier()` / `get_ads_speed_modifier()` / `get_weight()` / `suppresses_muzzle_flash()` / `suppresses_sound()` / `get_length_modifier()` / `get_magnification()` / `get_fov_override()` / `set_reticle_visible(visible)`

## 注意事项

- `_on_initialized()` 是子类唯一的自定义初始化扩展点，基类为空实现
- 子类不应在 `_on_initialized()` 中依赖 `parent_weapon` 非 null
