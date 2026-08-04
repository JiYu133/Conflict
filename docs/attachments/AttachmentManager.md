# AttachmentManager

**文件路径：** `classes/weapon/weaponattachments/attachment_manager.gd`
**继承自：** `Node`

## 功能概述

配件管理器。每个机匣（BaseWeapon）挂一个 AttachmentManager，负责：
1. 递归扫描场景内所有 `AttachmentSlot` 建立字典索引，并在配件装入后继续扫描配件自身的子槽（层级槽位）
2. 管理配件节点的场景树归属（add_child / remove_child）
3. 维护数值修正缓存，`attachments_changed` 时触发 `_rebuild_cache()` 重算

`AttachmentSlot` 本身即为挂载锚点，配件作为其子节点挂载，对齐规则见下文「对齐方式（SnapPoint）」。
槽位允许安装的配件类型在场景 Marker3D 的 `allowed_attachment_types` 上多选；运行时不再读取 `WeaponConfig.supported_slots`。

## 层级槽位

配件场景内可包含子 `AttachmentSlot`（例：机匣盖场景里有 `OpticRail` 槽，护木场景里有 `Underbarrel` 槽）。装上配件时自动扫描并注册这些新槽；卸下时自动递归清理。

## 信号

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `attachment_equipped` | `slot, attachment` | 配件成功装入后 |
| `attachment_detached` | `slot, attachment` | 配件成功卸下后 |
| `attachments_changed` | — | 任意装卸操作后，触发缓存重建 |

## 公开方法

| 方法 | 说明 |
|------|------|
| `initialize(weapon, weapon_root)` | 扫描槽位，连接缓存信号 |
| `get_slot_names() -> Array[String]` | 所有已注册槽位名（不直接暴露 _slots） |
| `equip_to_slot(attachment, slot_name) -> bool` | 装入配件，扫描子槽，触发信号 |
| `detach_from_slot(slot_name) -> BaseAttachment` | 卸下配件，递归清理子槽，从场景树移除 |
| `get_slot(slot_name) -> AttachmentSlot` | 获取槽位节点 |
| `get_slots() -> Array[AttachmentSlot]` | 获取所有已注册槽位 |
| `find_first_available_slot_for(cfg) -> AttachmentSlot` | 先按 `preferred_slot_names` 找，再按场景顺序找第一个可接受且未占用的槽位 |
| `get_all_attachments() -> Array[BaseAttachment]` | 所有已装配件 |
| `get_attachment_in_slot(slot_name) -> BaseAttachment` | 指定槽位的配件 |
| `set_rail_offset(slot_name, offset)` | 调整导轨配件前后位置（clamp 到 min/max） |
| `get_rail_offset(slot_name) -> float` | 获取当前导轨偏移 |

## 数值查询（读缓存，O(1)）

`get_total_spread_modifier(is_ads)` / `get_total_recoil_vertical_modifier()` / `get_total_recoil_horizontal_modifier()` / `get_total_recoil_recovery_modifier()` / `get_total_ads_speed_modifier()` / `get_total_attachment_weight()` / `get_total_length_modifier()` / `get_total_magazine_capacity_bonus()` / `suppresses_muzzle_flash()` / `suppresses_sound()` / `get_magnification()` / `get_fov_override()`

## 对齐方式（SnapPoint）

配件装入槽位后的位置由两条规则决定：

1. **有 SnapPoint**：配件场景内若存在名为 `SnapPoint` 的 `Marker3D`，管理器计算它相对配件根节点的变换并取逆，使 SnapPoint 的世界位置与 `AttachmentSlot` 重合。美术在 Blender/Godot 里手动摆放这个点，标记真正的装配接触面。
2. **无 SnapPoint**：回退为 `transform = IDENTITY`，即配件原点贴合槽位。原点已经设在接触面中心的配件可以不加 SnapPoint。

配置了非 0 `rail_offset` 的配件（不要求 `rail_adjustable`）在对齐结果基础上叠加 Z 轴偏移；对齐后的基准 Z 存在节点 meta `_rail_base_z` 里，当前实例的偏移存在 `_rail_offset` 里。`set_rail_offset()` 每次都从基准重新计算，不会累积漂移，也不会修改可能被预览武器和真枪共同引用的 `AttachmentConfig` 资源。`get_rail_offset()` 优先读取实例元数据，旧实例没有元数据时才回退到配置默认值。

旧的 `auto_center`（运行时 AABB 居中）已移除——局部 AABB 在子节点带 transform 时结果不可靠，且业界（Arma Reforger 的 Slot/Snap、RoN 的手动偏移）均采用手动标记点方案。

## 注意事项

- 数值查询全部走缓存，无性能问题，不需要每帧遍历
- 卸下配件时递归 `_remove_child_slots()`，防止子槽残留
- 重名槽位只保留先扫描到的，后者打警告忽略
- 右侧 AK-12 皮卡汀尼侧导轨的预设首选槽位是 `SideRailRight`；左右专用资源必须让 `preferred_slot_names` 与模型方向一致
