# PlayerCameraController

**文件路径：** `classes/player/controller/player_camera_controller.gd`

头部位置用三轴 CameraSpring1D 过滤，视角由 PlayerLookController 提供；FOV、疼痛和视觉后坐单独叠加。武器姿态属于 WeaponPresentationController，IK 属于 IKRig。

## 初始化与模型

`initialize(player: BasePlayer, model_manager: PlayerModelManager, model_lookup_config: ModelLookupConfig, camera_config: CameraConfig, settings_service, create_local_camera: bool = true, look_controller: PlayerLookController = null)` 由 BasePlayer 调用。模型加载后由组合根查找/挂载相机、激活本地相机；AI 不创建本地 SeedCamera，但保留视角数据。

camera_ready(camera) 通知相机就绪。camera_mount 提供挂点；get_active_camera() 返回相机。controllable 读取 BasePlayer.controllable。

## ADS 与武器姿态

set_aim_config(config) 注入 AimConfig；set_ads_state(ads, ads_time, zoom_fov, center_offset, ads_anchor = null) 接受装备系统的有效 ADS 参数。raise_speed/lower_speed 与 ads_time 决定进度，smoothstep 后同时供 FOV 和武器姿态消费。reset_weapon_pose_to_hip() 立即回到腰射状态。

set_weapon_presentation_controller(controller) 注入展示组件；refresh_weapon_pose() 仅委托 ensure_pose_current()。不是旧版只写支点 X/Y、保留 Z 的实现，参见 [WeaponPresentationController](WeaponPresentationController.md) 和 [ADSSystem](../weapon/ADSSystem.md)。

## 后坐、疼痛与布娃娃

set_recoil_component()/clear_recoil_component() 维护 physical_recoil_applied 信号连接。每发 angular_velocity 注入独立俯仰/偏航弹簧，不写回 PlayerLookController 或玩家 yaw；ADS 不加快后坐回正。add_pain_impulse(world_direction, amount, intensity = 1.0) 使用独立疼痛弹簧。

disable_camera(skeleton = null) 让出普通操作视角；传入骨架时绑定布娃娃头部，on_ragdoll_physics_started() 同步物理头骨或可用父骨。enable_camera() 恢复常规相机；set_ragdoll_camera_shake() 控制轻微晃动。CameraConfig.ads_stiffness_multiplier、ragdoll_eye_offset 保留但当前未消费。

视角查询包括 get_view_yaw()/get_vertical_angle()（含自由观察）、get_base_view_yaw()/get_base_vertical_angle()、get_body_yaw_offset()、get_free_yaw_offset()/get_free_pitch_offset()、get_view_basis()。set_ai_view_angles(yaw, pitch) 服务 AI。当前没有 get_view_direction()/get_aim_direction()，需要方向时按消费方约定从 yaw/pitch 构造 Basis；实际弹丸始终使用枪口。

测试入口见 [Testing](../Testing.md)：ADS、呼吸、AI、组件装配和力反馈。
