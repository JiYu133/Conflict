# AttachmentManager

**文件路径：** `Classes/Weapon/WeaponAttachments/attachment_manager.gd`
**继承自：** `Node`

## 功能概述

配件管理器。每把武器挂一个 AttachmentManager，负责：
1. 递归扫描武器场景内所有的 `AttachmentSlot` 并建立字典索引
2. 接受装备/卸载请求，委托给对应槽位处理
3. 汇总所有已装配件的数值修正，供武器各子系统查询

数值汇总公式：`武器实际值 = 武器基础值 + Σ 所有当前配件的修正`

## 初始化

```
initialize(weapon: BaseWeapon, weapon_root: Node) -> void
```

由 `BaseWeapon.initialize()` 调用。保存武器引用后，递归扫描 `weapon_root` 下所有 `AttachmentSlot` 子节点，以 `slot_name`（或节点名）为 key 存入 `_slots` 字典。重名挂载点保留先扫描到的，并发出警告。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `attachment_equipped` | `slot: AttachmentSlot, attachment: BaseAttachment` | 配件成功装备后 |
| `attachment_detached` | `slot: AttachmentSlot, attachment: BaseAttachment` | 配件成功卸下后 |
| `attachments_changed` | — | 任意装备或卸载操作成功后（用于触发数值重算） |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `parent_weapon` | `BaseWeapon` | 所属武器引用 |

## 公开方法（Methods）

### `equip_to_slot(attachment: BaseAttachment, slot_name: String) -> bool`
将配件装入指定名称的槽位。槽位不存在时 `push_error` 并返回 `false`；成功时设置 `attachment.parent_weapon`，发出 `attachment_equipped` 和 `attachments_changed` 信号。

### `detach_from_slot(slot_name: String) -> BaseAttachment`
从指定槽位卸下配件，发出 `attachment_detached` 和 `attachments_changed` 信号，返回被卸下的配件实例。槽位不存在或为空时返回 `null`。

### `get_slot(slot_name: String) -> AttachmentSlot`
按名称获取挂载点节点，不存在时返回 `null`。

### `get_all_attachments() -> Array[BaseAttachment]`
返回所有已占用槽位中的配件数组，用于数值汇总遍历。

### `get_attachment_in_slot(slot_name: String) -> BaseAttachment`
返回指定槽位当前的配件实例，槽位为空或不存在时返回 `null`。

### `get_total_spread_modifier(is_ads: bool) -> float`
所有配件的散布修正之和（区分机瞄/腰射）。

### `get_total_recoil_vertical_modifier() -> float`
所有配件的垂直后座修正之和。

### `get_total_recoil_horizontal_modifier() -> float`
所有配件的水平后座修正之和。

### `get_total_recoil_recovery_modifier() -> float`
所有配件的后座回正速度修正之和。

### `get_total_ads_speed_modifier() -> float`
所有配件的瞄准速度修正之和。

### `get_total_attachment_weight() -> float`
所有配件的重量之和（kg）。

### `suppresses_muzzle_flash() -> bool`
任意配件抑制枪口火光时返回 `true`。

### `suppresses_sound() -> bool`
任意配件抑制枪声时返回 `true`。

### `get_magnification() -> float`
返回当前瞄具的最大放大倍率（无瞄具时返回 1.0，仅对 `OpticAttachment` 类型生效）。

### `get_total_length_modifier() -> float`
所有枪口装置的长度修正之和（m），用于顶墙收枪射线检测。

### `get_total_magazine_capacity_bonus() -> int`
所有扩容弹匣的额外容量之和（仅对 `ExtendedMagAttachment` 类型生效）。

### `get_fov_override() -> float`
返回当前瞄具的 FOV 覆盖值（无瞄具或无覆盖时返回 -1.0，仅对 `OpticAttachment` 类型且 `fov_override > 0` 时生效）。

## 依赖关系
- **依赖：** `BaseWeapon`、`AttachmentSlot`、`BaseAttachment`、`OpticAttachment`（类型检查）、`ExtendedMagAttachment`（类型检查）
- **被依赖：** `BaseWeapon`（持有引用，初始化后调用各汇总方法）、`RecoilComponent`（查询后座修正）、`AmmoComponent`（查询弹匣容量加成）

## 注意事项

- `get_magnification()` 和 `get_fov_override()` 使用 `is OpticAttachment` 类型检查，依赖 `OpticAttachment` 子类存在；`get_total_magazine_capacity_bonus()` 同理依赖 `ExtendedMagAttachment`。
- 所有数值汇总方法每次调用都遍历 `get_all_attachments()`，无缓存；配件数量较多时如有性能需求，可在 `attachments_changed` 时重算并缓存。
- 重名挂载点（`slot_name` 相同）只保留先扫描到的，后者被忽略并发出警告，避免使用重复名称。
