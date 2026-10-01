# PlayerScreenEffects

`PlayerScreenEffects` 管理玩家的体力/疼痛反馈、濒死视觉和死亡渐黑。

需要读取屏幕纹理的效果统一由 `physiological_effect.gdshader` 在一次全屏 pass 中完成：

- 体力、疼痛和死亡使用同一组 9-tap 模糊采样；
- 受击时按弹头来源方向提高对应屏幕边缘的模糊半径，并叠加轻微全屏模糊；
- 濒死状态在模糊采样上叠加低频 UV 波动、轻微降饱和与 RGB 重影；
- RGB 重影复用模糊的水平采样，不再额外运行第二个全屏 shader。

受击严重性由 `DamageInfo.amount / 600 J` 归一化，再按命中部位修正：头部 `1.25x`、躯干 `1.0x`、四肢 `0.65x`。严重性同时控制短促的全屏轻模糊和方向性边缘模糊，并在约 1.25 秒内消退。弹道方向会转换到当前活动摄像机空间；正面/背面分别映射到上/下边缘，方向未知时使用均匀边缘反馈。

濒死（`BasePlayer.go_unconscious()`）期间会提高统一生理 shader 的 `coma_intensity`，效果包括：

- 保留中心可见度的屏幕渐暗，最大暗化约 38%，不会完全遮挡画面；
- 低频 UV 波动造成轻微画面扭曲；
- 红/蓝通道分离造成轻微重影；
- 与 `PlayerCameraController.set_ragdoll_camera_shake(true)` 配合产生轻微相机晃动。

正式死亡时濒死参数清零，由统一 shader 的死亡模糊和独立纯黑覆盖接管；恢复意识时 `clear_death_blur()` 清除全部濒死状态。

## 调试命令

以下命令仅在 Debug 构建中开放，且不会修改医疗状态：

| 命令 | 用途 |
|---|---|
| `screen_hit <left\|right\|top\|bottom\|front\|back\|all> [severity]` | 测试方向性边缘和全屏受击模糊；严重性为 `0.05-1.0` |
| `screen_stamina <0-1>` | 设置用于屏幕反馈的剩余体力比例 |
| `screen_pain <0-1>` | 设置用于屏幕反馈的疼痛等级 |
| `screen_coma <1\|0>` | 开关昏迷视觉 |
| `screen_death` | 触发死亡模糊与渐黑 |
| `screen_clear` | 清除上述全部测试状态 |
