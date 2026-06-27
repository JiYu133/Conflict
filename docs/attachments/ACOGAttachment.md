# ACOGAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/scopes/acog.gd`  
**继承自：** `OpticAttachment`

## 功能概述

固定倍率棱镜式望远瞄具（参考型号：Trijicon TA31 4x32 ACOG）。提供 4 倍光学放大，专为中远距离精确射击设计，是所有瞄具中放大倍率最高的选项。

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

- 4 倍放大使 FOV 缩小至约 15°，腰射时几乎无法正常使用（视野过小）。
- ADS 散布修正极小，适合远距离点射，但进入 ADS 的响应速度可能因重量较大而略慢。
- 与红点/全息不同，ACOG 使用棱镜光学系统，理论上在无电池状态下仍可使用（设计参考层面）。
- 不适合 CQB 场景，与 `HolographicAttachment` 的定位完全相反。
