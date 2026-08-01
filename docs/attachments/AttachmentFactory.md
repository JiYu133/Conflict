# AttachmentFactory

**文件路径：** `classes/weapon/weaponattachments/attachment_factory.gd`
**继承自：** `RefCounted`

## 功能概述

统一创建配件实例的入口。调用方只需传入 `AttachmentConfig`，工厂按以下优先级创建实例：

1. `cfg.no_visual = true` → 直接返回裸 `BaseAttachment`（无任何子节点）
2. `cfg.attachment_scene` 有效 → 实例化场景，根节点必须是 `BaseAttachment`
3. 场景缺失或根节点类型错误 → `_create_default_placeholder()` 用 BoxMesh 动态生成占位模型
4. 实例化成功后调用 `attachment_root.initialize(cfg, weapon)` 注入配置

## 公开方法

### `static create(cfg: AttachmentConfig, weapon: BaseWeapon) -> BaseAttachment`

返回 `BaseAttachment` 实例，失败时返回 `null` 并输出 error/warning。

## 注意事项

- 本类为纯静态工具类，不持有状态
- 占位模型仅供无美术资源时功能测试（BoxMesh 0.05×0.05×0.1）
- `no_visual` 配件的 `initialize()` 照常执行，数值修正正常生效
