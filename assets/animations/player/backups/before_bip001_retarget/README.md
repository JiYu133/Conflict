旧动画备份（替换为 Bip001 重定向动作之前）

- idle.tres：原先实际使用的待机动画库。
- idle.fbx、idle.fbx.import：原待机 FBX 及导入设置。
- [old]sprint forward.fbx 及其 .import：原先实际使用的向前冲刺动画。
- swat.tscn：替换之前的角色场景，包含用户当时已有的场景改动。

此目录通过 .gdignore 排除导入，避免备份资源 UID 与当前资源冲突。
恢复时将所需文件复制回原位置；场景备份原路径为 assets/models/player/test_model/swat.tscn。
当前使用 idle.tres 和 retargeted_sprint.tres 中的重定向动画。
