# IronSightAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/scopes/iron_sight.gd`  
**继承自：** `OpticAttachment`

## 功能概述

传统机械瞄具（准星 + 照门）的实现。几乎所有枪械出厂默认携带，玩家无需主动装备。它是 OpticRail 插槽的默认配件，作为其他高级瞄具的基准和回退选项。

## 初始化

`_on_initialized()` 为空实现——机械瞄具没有实体模型，仅作为逻辑标记存在。

## 信号（Signals）

无。

## 公开方法（Methods）

无额外公开方法，继承 `OpticAttachment.is_optic_active()`。

## 依赖关系

- **依赖：**
  - `OpticAttachment` — 父类
- **被依赖：**
  - `AttachmentFactory` — OPTIC 类型无场景时作为默认占位脚本加载
  - `BaseWeapon` / `AttachmentManager` — 默认装备到 OpticRail 插槽

## 注意事项

- 根据注释，机械瞄具设计上不可卸下（`can_be_empty = false`），但该属性的具体实现在 `BaseAttachment` 层。
- 放大倍率 1.0，散布修正 0，HUD 准星即为其瞄具图案，无独立资源。
- 玩家装备更高级瞄具时，此配件被替换而非叠加。
