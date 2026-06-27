# RedDotAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/scopes/red_dot.gd`  
**继承自：** `OpticAttachment`

## 功能概述

红点反射式瞄具（参考型号：Aimpoint CompM2、Truglo Red Dot）。1 倍无放大，通过在镜片上投射红色光点作为瞄准参考，支持双眼睁眼瞄准，不影响视野范围。

## 初始化

`_on_initialized()` 为空实现。红点图案绘制在 Hologram/Quad 节点上，无独立物理模型需要初始化。

## 信号（Signals）

无。

## 公开方法（Methods）

无额外公开方法，继承 `OpticAttachment.is_optic_active()`。

## 依赖关系

- **依赖：**
  - `OpticAttachment` — 父类
- **被依赖：**
  - `AttachmentFactory` — 通过 `AttachmentConfig` 指定场景后实例化
  - `AttachmentManager` — 装备到武器的 OpticRail 插槽

## 注意事项

- 1 倍放大，ADS 状态下大幅减少腰射散布。
- 准星永远与目标齐平，不受弹道下坠影响（游戏设计层面的简化）。
- 红点图案依赖外部渲染节点（Hologram/Quad），若场景中缺少该节点，准星图案不会显示但功能仍正常。
