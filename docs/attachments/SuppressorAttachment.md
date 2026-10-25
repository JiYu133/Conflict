# SuppressorAttachment

**文件路径：** `classes/weapon/weaponattachments/muzzles/suppressor.gd`

**继承自：** `BaseAttachment`

## 功能概述

消音器配件的默认占位脚本（参考型号：PBS-4、SureFire SOCOM556-RC）。实际效果由配件资源及消费该配置的系统决定，本类不实现固定数值加成。

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

- `suppresses_flash` / `suppresses_sound` 来自 `AttachmentConfig`；`WeaponFXController` 读取这些标志选择枪口效果，`BaseWeapon` 的射击事件也携带声音抑制状态。本类不直接处理音频或 AI 感知。
- 重量、质心和长度由资源的 `weight_kg` / `center_of_mass_local` / `length_modifier` 决定，没有固定的 +0.4 kg。
- `damage_modifier` 当前没有运行时消费者；没有自动的亚音速弹伤害 -5% 分支。弹道伤害依据实际弹丸参数与命中状态计算。
