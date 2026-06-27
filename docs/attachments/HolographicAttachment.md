# HolographicAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/scopes/holographic.gd`  
**继承自：** `OpticAttachment`

## 功能概述

全息衍射瞄具（参考型号：EOTech EXPS3、HoloSun 512）。利用全息图技术投射复杂准星图案（圆圈 + 中心点），1 倍无放大，适合近距离快速瞄准（CQB 场景）。

## 初始化

`_on_initialized()` 为空实现，无额外资源需要在初始化阶段加载。

## 信号（Signals）

无。

## 公开方法（Methods）

无额外公开方法，继承 `OpticAttachment.is_optic_active()`。

## 依赖关系

- **依赖：**
  - `OpticAttachment` — 父类
- **被依赖：**
  - `AttachmentFactory` — 通过 `AttachmentConfig` 实例化
  - `AttachmentManager` — 装备到武器的 OpticRail 插槽

## 注意事项

- 1 倍放大，散布修正略弱于 `RedDotAttachment`，适合近战而非远程精确射击。
- 全息准星图案（圆圈+点）比红点更复杂，视觉上覆盖面积更大，可能影响精确点射时的目标遮挡。
- 与红点的区别：技术原理不同（全息衍射 vs 反射），准星图案不同，散布修正数值略低。
