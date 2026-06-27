# ExtendedMagAttachment

**文件路径：** `Classes/Weapon/WeaponAttachments/magazines/extended_mag.gd`  
**继承自：** `BaseAttachment`

## 功能概述

扩容弹匣配件（参考型号：PMAG 40发、Tapco SKS 30发）。在武器基础弹匣容量（`WeaponConfig.magazine_capacity`）之上叠加额外容量，减少换弹频率。当前额外容量硬编码为 10 发，配置驱动功能尚未实现。

## 初始化

`_on_initialized()` 标注为"预期不可达 / 待扩展"——当前固定使用默认值 10，未来可在此处从 `AttachmentConfig` 读取额外容量。

## 信号（Signals）

无。

## 公开方法（Methods）

### `get_extra_capacity() -> int`

返回此弹匣的额外容量加成，供 `AmmoComponent` 计算实际弹匣容量时调用。当前始终返回 `extra_capacity`（硬编码值 10）。

## 依赖关系

- **依赖：**
  - `BaseAttachment` — 父类，提供配件基础生命周期与数据接口
- **被依赖：**
  - `AmmoComponent` — 调用 `get_extra_capacity()` 计算实际弹匣容量
  - `AttachmentManager` — 装备到武器的弹匣插槽

## 注意事项

- `extra_capacity` 当前硬编码为 10，不从 `AttachmentConfig` 读取，所有扩容弹匣效果相同。
- 根据代码注释，`apply_magazine_attachments()` 的调用链路在 `BaseWeapon.initialize()` 中当前不会被触发，即该配件的容量加成在现有流程下实际上不生效，属于待完成功能。
- 重量增加逻辑未在本类中实现，依赖父类或外部系统处理。
- 注释提到部分弹匣会影响可靠性，但当前版本无可靠性系统，该特性未实现。
