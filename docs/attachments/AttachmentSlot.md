# AttachmentSlot

**文件路径：** `Classes/Weapon/WeaponAttachments/attachment_slot.gd`
**继承自：** `Node3D`

## 功能概述

配件挂载点。标记武器场景中一个可挂配件的物理位置（瞄具导轨、枪口螺纹、握把槽等），同时承担槽位占用检查逻辑，阻止两个配件装入同一位置。在武器场景中放置 Node3D 节点并绑定此脚本，`AttachmentManager` 会自动扫描并注册。

典型场景结构示例（AK-74M）：
```
Weapon
├── Barrel
│   └── Muzzle (AttachmentSlot)       ← 装消音器
├── Receiver
│   └── OpticRail (AttachmentSlot)    ← 装瞄具
└── Handguard
    └── Underbarrel (AttachmentSlot)  ← 装握把
```

## 枚举

```
enum SlotType {
    OPTIC_RAIL,    # 顶部瞄具导轨（皮卡汀尼/燕尾）
    MUZZLE,        # 枪口螺纹
    UNDERBARREL,   # 下挂导轨（前握把/榴弹发射器）
    MAGAZINE_WELL, # 弹匣井
    SIDE_RAIL      # 侧导轨
}
```

## 信号（Signals）

无。

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `slot_type` | `SlotType` | 槽位类型，决定能装哪类配件（@export） |
| `slot_name` | `String` | 显示名，HUD 提示用，也作为 AttachmentManager 中的字典 key（@export） |
| `can_be_empty` | `bool` | 是否可以为空；机械瞄具槽设为 false 以保留后照门（@export） |
| `current_attachment` | `BaseAttachment` | 当前装入的配件实例，null = 空槽 |
| `is_occupied` | `bool` | 只读计算属性，`current_attachment != null` 时为 true |

## 公开方法（Methods）

### `attach(attachment: BaseAttachment) -> bool`
尝试挂载一个配件实例。
- 槽位已被占用 → `push_warning` 并返回 `false`
- 配件的 `config.allowed_slot` 与 `slot_type` 不匹配 → `push_warning` 并返回 `false`
- 验证通过 → 将配件添加为子节点，同步 `global_transform`，返回 `true`

### `detach() -> BaseAttachment`
卸载当前配件。将配件从场景树移除，清空 `current_attachment`，返回被卸下的配件实例（调用方负责释放或放回库存）。槽位为空时返回 `null`。

## 依赖关系
- **依赖：** `BaseAttachment`（`attach()` 入参，读取 `config.allowed_slot`）
- **被依赖：** `AttachmentManager`（扫描、持有和调用所有 AttachmentSlot）

## 注意事项

- `slot_name` 为空时，`AttachmentManager` 会用节点名（`child.name`）作为 key；建议显式设置 `slot_name` 以保证稳定性。
- `attach()` 执行后配件的 `global_transform` 被强制同步为槽位的 `global_transform`，确保配件出现在正确的物理位置。
- `can_be_empty` 当前仅作为数据标记，`detach()` 并不检查此字段；调用方需自行判断是否允许卸载。
