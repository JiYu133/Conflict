# ExtendedMagAttachment

**文件路径：** `classes/weapon/weaponattachments/magazines/extended_mag.gd`

**继承自：** `BaseAttachment`

旧的扩容加成配件类，get_extra_capacity() 返回 extra_capacity，脚本默认 10；不从通用 AttachmentConfig 自动读取容量。

当前普通弹匣主流程使用 MagazineConfig.magazine_capacity、reserve_magazines 和 has_last_round_hold_open，由 AmmoComponent.reconfigure() 更新。WeaponConfig 已没有 magazine_capacity 字段，不应在机匣上设置弹匣容量。

apply_magazine_attachments() 仍保留为旧加成接口，且 BaseWeapon 初始化有调用；但当时默认配件通常尚未装好。后续装配 MagazineConfig 会重建弹匣池，因此不能假定此旧节点自动为所有当前弹匣持续增加 10 发。

制作新弹匣优先提供 MagazineConfig 和正确附件场景，不依赖旧容量加成。当前已存在哑火、烟囱卡弹和双上膛系统，但本类本身不实现“扩容弹匣可靠性惩罚”。
