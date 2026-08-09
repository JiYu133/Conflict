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

- 后座效果不配置固定的“垂直后座 -0.3°”数值。配件通过重量、质心位置、握点位置以及 `support_stiffness` / `support_damping` 改变武器的转动惯量和射手控枪模型。
- `RecoilPhysicsModel` 在配件装卸后重建物理参数，改装界面展示重建后的单发俯仰/偏航角速度冲量。
- 重量增加会影响武器总重和转动惯量，可能间接影响移动速度等依赖重量的系统。
