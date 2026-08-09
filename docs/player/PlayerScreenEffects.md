# PlayerScreenEffects

`PlayerScreenEffects` 管理玩家的体力/疼痛反馈、濒死视觉和死亡渐黑。

濒死（`BasePlayer.go_unconscious()`）期间会启用 `coma_distortion.gdshader`，效果包括：

- 保留中心可见度的屏幕渐暗，最大暗化约 38%，不会完全遮挡画面；
- 低频 UV 波动造成轻微画面扭曲；
- 红/蓝通道分离造成轻微重影；
- 与 `PlayerCameraController.set_ragdoll_camera_shake(true)` 配合产生轻微相机晃动。

正式死亡时濒死效果淡出，由原有死亡渐黑接管；恢复意识时 `clear_death_blur()` 清除全部濒死状态。
