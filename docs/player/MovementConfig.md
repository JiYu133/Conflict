# MovementConfig

**文件路径：** `classes/player/config/movement_config.gd`

**继承自：** `Resource`

由 PlayerConfig.movement_config 引用，管理移动、姿态、翻滚、转身、模型高度与碰撞拟合/fallback。下表为脚本默认值；assets/config/player/movement_config_default.tres 覆盖部分值。

| 字段 | 类型 | 脚本默认值 |
|---|---|---|
| `walk_speed` | `float` | `1.5` |
| `run_speed` | `float` | `3.5` |
| `sprint_speed` | `float` | `6.0` |
| `crouch_speed` | `float` | `1.0` |
| `sprint_hold_threshold` | `float` | `0.25` |
| `ground_acceleration` | `float` | `6.0` |
| `jump_force` | `float` | `3.2` |
| `gravity` | `float` | `9.8` |
| `air_acceleration` | `float` | `1.0` |
| `air_deceleration` | `float` | `2.0` |
| `floor_snap_velocity` | `float` | `-0.5` |
| `input_dead_zone` | `float` | `0.1` |
| `backward_dot_threshold` | `float` | `-0.3` |
| `lateral_dot_threshold` | `float` | `0.7` |
| `turn_decel_min_speed` | `float` | `0.1` |
| `air_input_threshold` | `float` | `0.1` |
| `lateral_speed_ratio` | `float` | `0.8` |
| `backward_speed_ratio` | `float` | `0.7` |
| `stop_brake_strength` | `float` | `5.0` |
| `turn_decel_factor` | `float` | `0.85` |
| `turn_in_place_enabled` | `bool` | `true` |
| `turn_trigger_angle_degrees` | `float` | `40.0` |
| `forced_turn_angle_degrees` | `float` | `120.0` |
| `turn_view_limit_degrees` | `float` | `90.0` |
| `turn_view_min_sensitivity_ratio` | `float` | `0.25` |
| `turn_clip_authored_angle_degrees` | `float` | `90.0` |
| `turn_min_playback_speed` | `float` | `1.25` |
| `turn_max_playback_speed` | `float` | `1.5` |
| `prone_turn_min_playback_speed` | `float` | `1.0` |
| `prone_turn_max_playback_speed` | `float` | `1.0` |
| `prone_crawl_turn_speed_multiplier` | `float` | `0.8` |
| `turn_constrained_speed_ratio` | `float` | `0.25` |
| `turn_constrained_acceleration_ratio` | `float` | `0.25` |
| `turn_transition_time` | `float` | `0.12` |
| `moving_body_turn_speed_degrees` | `float` | `360.0` |
| `moving_body_velocity_yaw_threshold_degrees` | `float` | `120.0` |
| `burst_strength` | `float` | `1.2` |
| `burst_duration` | `float` | `0.12` |
| `gait_frequency_walk` | `float` | `1.8` |
| `gait_frequency_run` | `float` | `2.5` |
| `gait_frequency_sprint` | `float` | `3.2` |
| `gait_amplitude_walk` | `float` | `0.06` |
| `gait_amplitude_run` | `float` | `0.12` |
| `gait_amplitude_sprint` | `float` | `0.18` |
| `stance_transition_speed` | `float` | `3.0` |
| `automatic_stance_transition_speed` | `float` | `8.0` |
| `stance_step_size` | `float` | `0.1` |
| `crouch_capsule_height` | `float` | `0.6` |
| `crouch_y_offset` | `float` | `-1.3` |
| `crouch_walk_xfade_time` | `float` | `0.3` |
| `prone_forward_speed` | `float` | `0.8` |
| `prone_backward_speed` | `float` | `0.55` |
| `prone_lateral_speed` | `float` | `0.65` |
| `prone_roll_speed` | `float` | `3.2` |
| `prone_roll_cooldown` | `float` | `0.15` |
| `prone_roll_chain_reset_time` | `float` | `1.0` |
| `prone_roll_duration` | `float` | `0.45` |
| `prone_roll_acceleration` | `float` | `18.0` |
| `prone_capsule_height` | `float` | `0.6` |
| `prone_collision_y_offset` | `float` | `-0.6` |
| `prone_model_y_offset` | `float` | `-1.35` |
| `model_y_offset` | `float` | `-0.5` |
| `collision_shape_height` | `float` | `1.8` |
| `collision_shape_radius` | `float` | `0.4` |
| `collision_shape_y_offset` | `float` | `0.0` |
| `hitbox_driven_collision` | `bool` | `false` |
| `collision_bounds_margin` | `float` | `0.025` |
| `collision_bounds_follow_speed` | `float` | `2.0` |
| `collision_bounds_min_height` | `float` | `0.6` |
| `collision_bounds_max_height` | `float` | `3.0` |
| `collision_bounds_max_radius` | `float` | `0.75` |
| `collision_axis_switch_ratio` | `float` | `1.15` |
| `collision_axis_switch_stability_frames` | `int` | `4` |
| `collision_axis_follow_speed_degrees` | `float` | `240.0` |


model_y_offset / crouch_y_offset / prone_model_y_offset 是模型表现偏移。默认资源站姿为 -1.0 m；腿部可达范围和骨盆下沉由 IKRigConfig 控制；更换模型/动画需重新校准腿长、相机和碰撞 envelope。

碰撞字段由 PlayerCollisionController 消费，固定尺寸主要服务 fallback。转身配置见 [PlayerTurnController](PlayerTurnController.md)。运行 [Testing](../Testing.md) 的 ik_rig_check 检查站蹲、移动和斜坡。
