# 回归测试与文档核对

从仓库根目录执行，使用 project.godot 匹配的 Godot 4.7。Windows 的完整入口：

```powershell
powershell -ExecutionPolicy Bypass -File tools/check.ps1 -GodotPath (Get-Command godot_console.exe).Source
```

该入口验证导入、autoload、标题/地图及当前场景运行器。日志在 .appdata/regression。新增的战斗与世界坐标回归可单独运行（本 PR 也接入完整入口）：

```powershell
godot_console.exe --headless --path . --fixed-fps 60 res://tests/combat_regression_check.tscn --quit-after 1200
godot_console.exe --headless --path . --fixed-fps 60 res://tests/force_pose_regression.tscn --quit-after 600
python tests/logger_bootstrap_check.py --godot godot_console.exe
```

| 运行器 | 覆盖 |
|---|---|
| combat_regression_check | 整段/分段换弹取消重启，两条弹道路径的枪口权威与 ADS 精度不变，缺枪管保护与重新装配 |
| force_pose_regression | 旋转 Skeleton3D 和非单位 rest 下，根/子骨骼世界位移与旋转 |
| ik_rig_check | 当前统一双臂/双腿 IK、站蹲/移动、斜坡、可达范围、释放及重绑定 |
| ads_system_runner / aim_breathing_runner | 当前武器姿态、瞄具、遮挡、呼吸和动画暂停契约 |
| ai_aim_check / movement_body_yaw_runner | AI 瞄准及运动/身体 yaw；使用 .tscn 正常 autoload 入口 |
| force_system_runner / force_integration_runner | 力传播、容量已满的后坐累加和真实玩家反馈接线 |
| player_components_runner | 当前组合根和组件初始化契约 |
| headless_debug_api_runner / medical_system_p4_runner / player_audio_interface_runner | 调试、医疗和音频集成契约 |

独立 logger 检查只复制源码与 LoggerService 基类到临时项目，不带 UID sidecar/.godot 缓存，验证干净导入与运行。当前 GlobalLogger 使用 classes/services/game_logger.gd 的源路径。

必须检查退出码、明确成功标记或 JSON 结果，以及 SCRIPT ERROR。--quit-after 仅是帧数兜底，退出 0 不能单独证明完成。旧 hand/foot IK、crouch_ik_check 和 weapon_presentation_check 已被当前 IKRig/ADS 场景替代，不要恢复旧入口。

force_system_runner 的 24 项断言可通过，但退出时仍报告既有资源清理泄漏；tools/check.ps1 忽略 resources still in use at exit，不表示该诊断已解决。

历史独立弹道积分/表面解析、遭遇战规则及碰撞专用运行器不在当前 tests 中，现有测试不代表这些领域覆盖完整。无头检查也不验证画面、穿插、舒适性、渲染性能或平台导出，相关修改仍需可视化试玩。
