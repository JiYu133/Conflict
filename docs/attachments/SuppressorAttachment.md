# SuppressorAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/muzzles/suppressor.gd`  
**继承自：** `BaseAttachment`

## 功能概述

螺纹式消音器（参考型号：PBS-4、SureFire SOCOM556-RC）。通过减少枪口火光和枪声来降低射击暴露风险，适合隐蔽战术场景。部分型号在使用亚音速弹时会小幅降低伤害。

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
  - `AttachmentFactory` — MUZZLE 类型无场景时作为默认占位脚本加载
  - `AttachmentManager` — 装备到武器的 MuzzleRail（枪口）插槽

## 注意事项

- 游戏数值效果：抑制枪口火光、抑制枪声、重量 +0.4kg、伤害 -5%（使用亚音速弹时）。
- 消音效果的具体实现（音频系统、AI 感知范围等）依赖外部系统读取配件状态，本类不直接处理音频。
- 重量 +0.4kg 是所有配件中最重的单个部件，对重量敏感的武器需注意总重上限。
- 伤害 -5% 仅在特定弹药类型下生效，普通弹药不受影响（设计参考层面）。
