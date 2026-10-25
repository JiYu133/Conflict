# PlayerAnimationController

**文件路径：** `classes/player/controller/player_animation_controller.gd`

**继承自：** `Node`

当前主要驱动 AnimationTree 的状态机与方向 BlendSpace2D；俯卧进入/退出、爬行、翻滚及俯卧转身可使用 AnimationPlayer 的直接片段覆盖。不是旧版七状态、纯信号播放器。

## 初始化与状态

`initialize(player: CharacterBody3D, movement: PlayerMovementController, model_manager: PlayerModelManager, anim_config: PlayerConfig = null) -> void`

模型加载后调用，缓存 animation_tree / playback，连接移动和生命周期信号。每帧更新局部方向混合坐标并查询地面/速度状态；walk_enter_speed_sq / walk_exit_speed_sq / land_recovery_time 来自 PlayerConfig。

状态包含 IDLE、WALK、CROUCH_WALK、RUN、SPRINT、JUMP、FALL、LAND、DEATH，以及站姿、蹲姿与俯卧的左右 TURN 状态。节点名取自脚本 SM_* 常量；不能只添加同名 AnimationPlayer 片段就假定状态树完成接线。

## 转身与全身片段

PlayerTurnController 使用 begin_external_turn() / end_external_turn() 及播放位置/速度接口协调身体 yaw。站/蹲转身轨道只作用于下半身；俯卧片段覆盖期间避免状态树覆盖其完整姿态。

get_current_state()、get_turn_clip_length()、get_turn_playback_progress()、set_turn_playback_speed() 等公开查询/控制接口服务转身流程；脚本中并非“无公开方法”。死亡/昏迷停用常规状态树以让出布娃娃，复活恢复。

完整模型资源与默认动画见 assets/models/player/test_model/swat.tscn；验证命令及 movement_body_yaw_runner 场景入口见 [Testing](../Testing.md)。
