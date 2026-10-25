# 补充运行时组件

本页补齐主索引未单独展开的组件，描述当前脚本职责和入口，不把“存在脚本”当作“已经接入所有场景”。主要玩家/武器/医疗/AI 系统见 [模块索引](README.md)，测试见 [Testing](Testing.md)。

## 玩家与生理反馈

| 类型 | 源码 | 当前职责/入口 |
|---|---|---|
| StaminaSystem | `classes/player/system/stamina_system.gd` | initialize(player, config)，处理移动消耗/恢复与负重；allows_sprint/run/jump、get_aim_stability_multiplier 等查询供移动和武器消费 |
| StaminaConfig | `classes/player/config/stamina_config.gd` | 体力、运动消耗、恢复、负重和俯卧翻滚参数，由 PlayerConfig.stamina_config 引用 |
| WeaponDropSystem | `classes/player/system/weapon_drop_system.gd` | 死亡时把现有武器放入 RigidBody3D，复活恢复；drop_current_weapon()/restore_current_weapon() 返回 bool，缺 dropped_collision_shape 时拒绝掉落 |
| ComaEffect | `classes/player/system/coma_effect.gd` | CanvasLayer 眼皮动画接口 enter_coma()/wake_up()/die()；不等同于 PlayerScreenEffects 的生理模糊 shader |
| CombatNotificationBridge | `classes/player/combat_notification_bridge.gd` | 将战斗/医疗状态接入通知展示的桥接组件 |

PlayerAudioController 当前只有禁用播放的集成接口，见 [PlayerAudioController](player/PlayerAudioController.md)。统一 IKRig、脊柱、下半身转身和武器 ADS 展示分别有独立文档，见主索引。

## UI、场景进入和调试

| 类型 | 源码 | 当前职责/入口 |
|---|---|---|
| LoadingScreen | `classes/ui/loading_screen.gd` | configure_map、set_status、set_progress、show_loading/ready/error 等加载展示接口 |
| MissionRecordingOverlay | `classes/ui/mission_recording_overlay.gd` | show_recording() 启动任务录制风格的 HUD 表现 |
| TitleBackdropController | `classes/ui/title_backdrop_controller.gd` | 标题场景背景表现控制 |
| RadialMenu | `classes/ui/radial_menu.gd` | 通用轮盘 UI；玩家输入/鼠标所有权由 RadialMenuService 协调 |
| RadialMenuConfig / RadialMenuOption | `classes/ui/radial_menu_config.gd`、`classes/ui/radial_menu_option.gd` | 轮盘布局与条目数据资源 |
| KeyPromptCard | `classes/ui/key_prompt_card.gd` | KeyPromptManager 使用的单条按键提示 |
| TopRightNotificationCard | `classes/ui/top_right_notification_card.gd` | 单条通知表现，集合管理见 UISystem |
| CombatNotificationLibrary | `classes/ui/combat_notification_library.gd` | 战斗通知内容/样式资源集合 |
| ConsoleSystem | `classes/ui/console/console_system.gd` | initialize(player)、open()/close()/is_open()；命令与 DebugAPI 接线 |
| WeaponModConfig | `classes/ui/weapon_mod/weapon_mod_config.gd` | 改装界面展示配置，不是武器逻辑或附件物理参数 |
| EncounterHUD | `classes/encounter/encounter_hud.gd` | 遭遇战状态/倒计时/目标信息展示，规则属于 EncounterRules |

参见 [UISystem](ui/UISystem.md)、[WeaponModMenu](ui/WeaponModMenu.md)、[EncounterSystemOverview](encounter/EncounterSystemOverview.md) 和 [DebugAPI](debug/DebugAPI.md)。

## 物理分层、附件与 FX

| 类型 | 源码 | 当前职责 |
|---|---|---|
| PhysicsLayers | `classes/physics/physics_layers.gd` | 共享碰撞层/掩码常量；脚部、弹丸与掉落武器使用不同查询/碰撞规则 |
| EnvironmentImpactEffect | `classes/combat/environment_impact_effect.gd` | 环境命中的撞击表现；伤害和穿透规则仍在弹道系统 |
| WeaponFXController / WeaponFXConfig | `classes/weapon/fx/weapon_fx_controller.gd`、`classes/weapon/fx/weapon_fx_config.gd` | 枪口闪光、热浪、抛壳等表现及配置；控制器 initialize(weapon, fx)，可接设置服务 |
| MuzzleFlashSequence | `classes/weapon/fx/muzzle_flash_sequence.gd` | 枪口闪光帧序列表现；不是弹丸本身 |
| ShellCasing | `classes/weapon/fx/shell_casing.gd` | 抛壳刚体及生命周期；不参与伤害计算 |
| SelectorSwitchAttachment | `classes/weapon/weaponattachments/selector_switch.gd` | 快慢机配件允许模式与开关表现，模式入口由 BaseWeapon 校验 |

枪管、弹匣、枪机框、握把、枪托、枪口装置的配置分别位于 classes/weapon/weaponattachments/，共享字段见 [AttachmentConfig](attachments/AttachmentConfig.md)。子类字段的源码与所用 .tres 是最终参数依据，不能把 WeaponConfig 当作所有物理参数的中央容器。

## 已知未接线项

CameraConfig.ads_stiffness_multiplier/ragdoll_eye_offset 等仍有导出但未消费的字段，对应页面已标注。RecoilPhysicsModel 的 receiver COM 质量加权仍有 P3 数据问题；这些文档说明不代表缺陷已修复。


## 当前组合与瞄准组件

| 类型 | 源码 | 当前职责 |
|---|---|---|
| PlayerWeaponFeedback | `classes/player/system/player_weapon_feedback.gd` | 武器后坐分配、换枪接线、携行重量同步 |
| PlayerUILayer | `classes/ui/player_ui_layer.gd` | 本地 HUD/菜单装配；AI 不创建 |
| LoggerService | `classes/services/logger_service.gd` | 可注入的静默日志基类；GlobalLogger 继承并输出日志 |
| AimConfig / AimBreathingController | `classes/player/config/aim_config.gd`、`classes/player/controller/aim_breathing_controller.gd` | ADS 速率、呼吸变换与 idle 暂停信号 |
| OpticRenderController / OpticEyeBoxConfig | `classes/player/controller/optic_render_controller.gd`、`classes/weapon/weaponattachments/scopes/optic_eye_box_config.gd` | 本地瞄具视图与眼盒/视差配置 |
| WeaponPresentationConfig | `classes/weapon/weapon_presentation_config.gd` | 呼吸、移动、惯性、遮挡姿态与阈值 |
| IKRigConfig / ArmIK / LegIK / TwoBoneIK | `classes/player/ik/ik_rig_config.gd` | 统一 IK 的配置、肢体状态与解析求解；详见 IKRig 文档 |
