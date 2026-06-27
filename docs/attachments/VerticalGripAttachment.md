# VerticalGripAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/grips/vertical_grip.gd`  
**继承自：** `BaseAttachment`

## 功能概述

垂直前握把（参考型号：Magpul RVG、KAC Vertical Grip）。装于护木下方，通过改善握持稳定性来减少枪口上跳，并加快后座回正速度，是最常见的枪管下挂配件。

## 初始化

`_on_initialized()` 为空实现，无额外资源需要在初始化阶段加载。

## 信号（Signals）

无。

## 公开方法（Methods）

无额外公开方法，继承 `BaseAttachment` 基础接口。

## 依赖关系

- **依赖：**
  - `BaseAttachment` — 父类，提供配件基础生命周期与数据接口
- **被依赖：**
  - `AttachmentFactory` — GRIP 类型无场景时作为默认占位脚本加载
  - `AttachmentManager` — 装备到武器的 GripRail（护木）插槽

## 注意事项

- 游戏数值效果：垂直后座 -0.3°，后座回正速度 +1.0°/s，重量 +0.1kg。
- 数值的实际应用依赖 `BaseWeapon` 或后座力系统读取配件属性并叠加计算，本类仅声明意图，不直接修改武器参数。
- 重量增加会影响武器总重，可能间接影响移动速度等依赖重量的系统。
