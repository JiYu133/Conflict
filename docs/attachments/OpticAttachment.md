# OpticAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/scopes/optic_attachment.gd`  
**继承自：** `BaseAttachment`

## 功能概述

所有瞄具（机械瞄具、红点、全息、ACOG）的共同父类，提供机瞄状态（ADS，Aim Down Sights）下准星与视野相关的统一接口。子类通过重写其方法实现各自的瞄具特性。

## 初始化

无独立的 `initialize()` 逻辑，复用父类 `BaseAttachment` 的初始化流程。

## 信号（Signals）

无。

## 公开方法（Methods）

### `is_optic_active() -> bool`

返回瞄具当前是否处于激活状态，默认始终返回 `true`。子类可重写以实现特殊条件，例如低倍瞄具在任何距离均可使用，而高倍镜可根据距离或状态禁用。

## 依赖关系

- **依赖：**
  - `BaseAttachment` — 父类，提供配件基础生命周期与数据接口
- **被依赖：**
  - `IronSightAttachment`
  - `RedDotAttachment`
  - `HolographicAttachment`
  - `ACOGAttachment`

## 注意事项

- 本类是抽象中间层，不应直接实例化，应使用具体子类。
- `is_optic_active()` 的默认实现返回 `true`，子类若有条件性禁用逻辑必须主动重写。
