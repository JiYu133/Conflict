# AttachmentFactory

**文件路径：** `Classes/Weapon/WeaponAttachments/attachment_factory.gd`  
**继承自：** `RefCounted`

## 功能概述

统一创建配件实例的入口。根据 `AttachmentConfig` 中的配置自动选择正确的子类并实例化，调用方无需关心具体配件类型，传入 Config 即可获得可用的配件实例。

## 初始化

本类无 `initialize()` 方法，配件实例化后会自动调用 `attachment_root.initialize(cfg, weapon)` 完成配件自身的初始化。

## 信号（Signals）

无。

## 公开方法（Methods）

### `create(cfg: AttachmentConfig, weapon: BaseWeapon) -> BaseAttachment`

根据配置创建一个配件实例。

- 优先使用 `cfg.attachment_scene` 中指定的场景实例化配件。
- 若场景为空或实例化失败，回退到 `_create_default_placeholder()` 用基础几何体动态生成占位模型。
- 实例化成功后调用 `attachment_root.initialize(cfg, weapon)` 注入配置。
- 失败时返回 `null` 并通过 `push_error` / `push_warning` 输出告警。

## 依赖关系

- **依赖：**
  - `AttachmentConfig` — 配件配置数据类，提供 `attachment_type`、`attachment_scene`、`attachment_name`
  - `BaseWeapon` — 配件所属武器，用于回传给配件实例
  - `BaseAttachment` — 所有配件的基类
  - `IronSightAttachment` — OPTIC 类型的默认占位脚本
  - `VerticalGripAttachment` — GRIP 类型的默认占位脚本
  - `SuppressorAttachment` — MUZZLE 类型的默认占位脚本
- **被依赖：**
  - 任何需要动态创建配件的调用方（如武器装备系统、`AttachmentManager`）

## 注意事项

- 若 `cfg.attachment_scene` 的根节点不是 `BaseAttachment`，该场景会被 `queue_free()` 并返回 `null`，不会生成占位模型。
- 占位模型使用 `BoxMesh`（尺寸 0.05×0.05×0.1），仅用于无美术资源时的功能测试。
- `_create_default_placeholder` 对未知 `attachment_type` 回退加载 `base_attachment.gd`，不会报错。
- 本类为纯静态工具类，不持有任何状态。
