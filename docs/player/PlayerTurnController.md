# PlayerTurnController

**文件路径：** `classes/player/controller/player_turn_controller.gd`

管理基础视角与身体分离时的下半身转身。自由观察偏移不触发转身。

`initialize(player, camera, movement, animation, config)` 由 BasePlayer 调用；公开查询为 is_turning()、get_turn_progress()、get_debug_snapshot()，cancel_for_prone_roll() 用于让出翻滚控制。

静止转身在 IDLE 且偏差超过 MovementConfig.turn_trigger_angle_degrees 时启动；超过 forced_turn_angle_degrees 可在移动中强制启动。单段受 turn_clip_authored_angle_degrees 限制，强制转身可继续下一段以消耗剩余偏差。

站/蹲转身仅过滤下半身轨道，上半身仍由基础动画、脊柱与手 IK 控制。俯卧转身使用独立 AnimationPlayer 片段；进入/退出俯卧和翻滚时不抢占全身动画。离地、死亡与布娃娃取消转身。

快照包含 turning、forced_turning、progress、remaining_angle、playback_speed、block_reason 等，供 DebugAPI 查询。movement_body_yaw_runner 使用正常场景入口完成 autoload 初始化，详见 [Testing](../Testing.md)。
