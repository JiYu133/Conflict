# BaseAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/base_attachment.gd`
**继承自：** `Node3D`

## 功能概述

所有武器配件（瞄具/握把/枪口/弹匣）的根节点基类。每个配件实例化时持有一个 `AttachmentConfig` 资源，通过统一接口向 `AttachmentManager` 提供数值修正。子类可重写各修正方法以加入特殊逻辑（例如 ACOG 只在 ADS 状态生效）。

## 初始化

```
initialize(cfg: AttachmentConfig, weapon: BaseWeapon) -> void
```

注入配置资源和所属武器引用，随后调用 `_on_initialized()` 供子类执行自定义逻辑（如实例化 3D 模型）。

## 信号（Signals）

无。

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `AttachmentConfig` | 当前配件的配置资源 |
| `parent_weapon` | `BaseWeapon` | 所属武器引用（用于回传数值修正），初始为 null |

## 公开方法（Methods）

### `get_spread_modifier(is_ads: bool) -> float`
返回对散布的修正值（度）。`is_ads = true` 时返回 `config.ads_spread_modifier`，否则返回 `config.hipfire_spread_modifier`。子类可重写以实现条件生效逻辑。

### `get_recoil_vertical_modifier() -> float`
返回垂直后座修正（度）。

### `get_recoil_horizontal_modifier() -> float`
返回水平后座修正（度）。

### `get_recoil_recovery_modifier() -> float`
返回后座回正速度修正。

### `get_ads_speed_modifier() -> float`
返回瞄准速度修正。

### `get_weight() -> float`
返回配件重量（kg）。

### `suppresses_muzzle_flash() -> bool`
返回是否抑制枪口火光。

### `suppresses_sound() -> bool`
返回是否抑制枪声。

### `get_length_modifier() -> float`
返回枪口长度修正（m）。

### `get_magnification() -> float`
返回放大倍率（1.0 = 无放大）。

### `get_fov_override() -> float`
返回强制 FOV（-1 表示不覆盖）。

### `set_reticle_visible(visible: bool) -> void`
显示/隐藏准星。基类为空实现，子类按需重写（如 OpticAttachment 控制准星 UI 节点）。

## 依赖关系
- **依赖：** `AttachmentConfig`（所有数值读取的数据来源）、`BaseWeapon`（持有引用但基类方法中未直接调用）
- **被依赖：** `AttachmentSlot`（持有 `current_attachment: BaseAttachment`）、`AttachmentManager`（遍历所有配件调用修正方法）

## 注意事项

- `_on_initialized()` 基类为空实现，是子类自定义初始化的扩展点，不要在基类中添加逻辑。
- 所有修正方法均直接读取 `config` 字段，无缓存；如需性能优化，子类可在 `_on_initialized()` 时缓存常用值。
- `parent_weapon` 在 `initialize()` 时由子类调用链设置，也可能在 `AttachmentManager.equip_to_slot()` 中被覆盖赋值。
