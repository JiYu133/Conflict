# PlayerConfig

**文件路径：** `classes/player/config/player_config.gd`

**继承自：** `Resource`

玩家子系统配置组合资源，默认 assets/config/player/player_config.tres。移动、姿态和碰撞参数编辑 movement_config 引用的 MovementConfig，而不是旧版平铺属性。

| 字段 | 类型 | 脚本默认值 |
|---|---|---|
| `movement_config` | `MovementConfig` | `null` |
| `model_scene` | `PackedScene` | `null` |
| `model_config` | `ModelLookupConfig` | `null` |
| `camera_config` | `CameraConfig` | `null` |
| `aim_config` | `AimConfig` | `null` |
| `walk_enter_speed_sq` | `float` | `0.25` |
| `walk_exit_speed_sq` | `float` | `0.0225` |
| `land_recovery_time` | `float` | `0.3` |
| `camera_stand_eye_height` | `float` | `1.6` |
| `camera_crouch_eye_height` | `float` | `1.0` |
| `ragdoll_config` | `RagdollConfig` | `null` |
| `force_config` | `ForceConfig` | `null` |
| `ik_config` | `IKRigConfig` | `null` |
| `spine_aim_config` | `SpineAimConfig` | `null` |
| `starting_weapon` | `WeaponConfig` | `null` |
| `health_config` | `HealthConfig` | `null` |
| `blood_effect_config` | `BloodEffectConfig` | `null` |
| `stamina_config` | `StaminaConfig` | `null` |


movement_config 负责速度、重力、姿态、转身与模型高度，见 [MovementConfig](MovementConfig.md)。model_config 是节点查找，camera_config 是相机弹簧；ik_config 配置统一双臂/双腿 IKRig，spine_aim_config 配置脊柱，aim_config 配置 ADS 速率和呼吸。ragdoll、force、health、blood_effect、stamina 配置分别归各子系统所有。

walk_enter_speed_sq / walk_exit_speed_sq / land_recovery_time 属于动画状态阈值；camera_stand_eye_height / camera_crouch_eye_height 用作缺少有效头部挂点时的眼高 fallback。

walk_speed、model_y_offset 等旧只读 getter 仍委托 movement_config，但不是可独立保存的导出字段；缺失 movement_config 时的 fallback 也不保证等于新建 MovementConfig 的默认值。

加载模型必须传有效 PlayerConfig 和 model_scene。个别子系统支持 null 配置，不能推导出所有入口都接受空 PlayerConfig。
