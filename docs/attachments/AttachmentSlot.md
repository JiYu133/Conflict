# AttachmentSlot

**文件路径：** `classes/weapon/weaponattachments/attachment_slot.gd`
**继承自：** `Node3D`

## 功能概述

配件挂载槽。在武器场景或配件场景中放置 `Marker3D` 或 `Node3D` 节点(通常情况下，我们建议你使用 **Marker3D** ，因为在Godot中 `Marker3D` 节点可以指示方向，方便配件方向的调整)并绑定此脚本，该节点放置在接口位置即为挂载锚点，子配件需要设置 `SnapPoint` [^1]来对齐挂载锚点。

[^1]`SnapPoint` 是配件系统中的一个机制，通常为`Marker3D`类型，在配件场景中，它用来标记此配件和父部件的连接点，以矫正安装的位置。

配件场景内可包含子 AttachmentSlot，实现层级槽位（如机匣盖上的导轨槽）。

## 枚举

```gdscript
enum SlotType {
    OPTIC_RAIL      = 0,   # 顶部瞄具导轨
    SIDE_RAIL_LEFT  = 1,   # 左侧导轨
    SIDE_RAIL_RIGHT = 2,   # 右侧导轨
    MUZZLE          = 3,   # 枪口螺纹
    UNDERBARREL     = 4,   # 下挂导轨
    BARREL          = 5,   # 枪管接口
    HANDGUARD       = 6,   # 护木接口
    RECEIVER_COVER  = 7,   # 机匣盖接口
    PISTOL_GRIP     = 8,   # 手枪握把
    TRIGGER_GROUP   = 9,   # 扳机组
    CHARGING_HANDLE = 10,  # 拉机柄
    MAGAZINE_WELL   = 11,  # 弹匣井
    STOCK_ADAPTER   = 12,  # 枪托接口
    BOLT_CARRIER    = 13,  # 枪机框
}
```

## 公开属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `slot_type` | `SlotType` | 槽位类型，决定可装哪类配件（@export） |
| `slot_name` | `String` | AttachmentManager 字典 key，也用于 UI 显示（@export） |
| `can_be_empty` | `bool` | 是否允许此槽为空（@export，数据标记） |
| `current_attachment` | `BaseAttachment` | 当前装入的配件，null = 空槽 |
| `is_occupied` | `bool` | 只读，current_attachment != null 时为 true |

## 公开方法

### `attach(attachment: BaseAttachment) -> bool`
只做状态记录（`current_attachment = attachment`），不操作场景树。节点挂载由 `AttachmentManager._place_attachment()` 负责。槽位被占或类型不匹配时警告并返回 `false`。

### `detach() -> BaseAttachment`
只清除状态（`current_attachment = null`），不操作场景树。节点移除由 `AttachmentManager.detach_from_slot()` 负责。返回被卸下的实例，为空时返回 null。

## 注意事项

- `slot_name` 为空时 AttachmentManager 用节点名作为 key，建议显式设置
- `attach()` / `detach()` 只管状态，场景树操作全部由 AttachmentManager 统一处理，职责清晰不会产生双重移除
