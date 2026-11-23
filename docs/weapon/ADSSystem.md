# ADS 与双相机瞄具

ADS 只改变观察和持枪姿态。切换 ADS 不修改武器或配件资源、散布、弹药、弹道参数、后坐冲量、控枪系数和后坐恢复速度。弹丸始终从实时 `Muzzle.global_position` 沿 `-Muzzle.global_basis.z` 发射；相机不参与弹道计算。姿态变化会自然改变物理枪口的位置和朝向。

## 组件边界

- `BasePlayer` 负责组装：注入视角、ADS 混合值、速度和伤情稳定性；连接遮挡信号与开火门禁。
- `WeaponPresentationController` 读取注入的状态与当前武器 marker，直接跟随动画右手挂点并叠加 ADS、呼吸、移动和遮挡偏移，不持有玩家或相机组件。
- 武器位置与旋转不使用追赶弹簧，每帧在手臂 IK 前直接更新。角色移动不会产生随速度累积的追赶误差。
- `WeaponObstructionDetector` 只做球体扫掠，输出连续权重，不修改武器、相机或弹药。
- `BaseWeapon` 在消耗弹药前调用注入的开火门禁；所有单发、连发和点射共用此路径。
- `IKRig` 在动画与躯干修饰器之后推进武器姿态，再让双手跟随最终握点。右手腕相对 `RightHandGrip` 的校准只在绑定时采样，避免逐帧反馈。
- `OpticRenderController` 复用一个 SubViewport 和镜内相机，双手 IK 完成后刷新镜内相机。`PlayerCameraController.refresh_weapon_pose()` 保留为兼容转发接口，同帧多次调用不重复推进呼吸和偏移状态。

## 瞄准速度与屏息

配置入口为 `assets/config/player/aim_config_default.tres`，由 `PlayerConfig.aim_config` 引用；脚本类型为 `AimConfig`。

抬枪速度沿用武器系统的时间定义：

```text
武器有效 ADS 时间 = max(WeaponConfig.ads_time + 所有配件 ads_speed_modifier 之和, 0.05 秒)
进入 ADS 的过渡时间 = 武器有效 ADS 时间 / AimConfig.raise_speed
退出 ADS 的过渡时间 = 武器有效 ADS 时间 / AimConfig.lower_speed
```

`raise_speed` 和 `lower_speed` 默认均为 1；2 表示两倍速，0.5 表示半速。配件 `ads_speed_modifier` 的单位是秒，负值缩短时间，正值延长时间。倍率只在相机推进 ADS 进度时读取，不回写武器有效时间和改装数据快照。过渡继续使用 smoothstep，武器直接应用当前混合姿态，不额外等待弹簧收敛。当前没有额外引入质量、质心或人体工学到抬枪时间的换算。

进入 ADS 后，`AimBreathingController` 通过信号暂停站立、蹲姿和转身基础层的 idle 时间推进；匍匐 idle 也暂停。动画树和骨骼修饰器继续工作，行走、转身腿部、匍匐移动及姿态切换继续播放。退出 ADS 后恢复 idle。

ADS 下按住左 Alt（`hold_breath`）平滑屏息，松开后恢复呼吸；右 Alt 不触发。退出 ADS 或失去操作权后取消屏息，菜单打开时不接收屏息输入。

呼吸由独立组件生成视角空间的微小位移与旋转偏移，直接叠加到当前持枪姿态，再由已有双手 IK 跟随。`breathing_frequency_hz` 调整基础频率，`breathing_position` 调整位移幅度（米），`breathing_rotation_degrees` 调整旋转幅度（度），`hold_blend_time` 和 `release_blend_time` 调整屏息与恢复时间（秒）。它不向受击/后坐力接收器注入冲量，也不修改其刚度、阻尼或任何武器数据。屏息只收住呼吸晃动，移动惯性、遮挡收枪和后坐力仍正常生效。

## Marker 校准

`ADSAnchor` 的世界位置表示满 ADS 时眼睛应处的位置，局部 `-Z` 表示瞄准方向。瞄准姿态为 `main_camera * inverse(anchor_relative_to_pose_root)`，按当前 ADS 混合值直接应用；呼吸、移动和视角惯性允许小幅动态偏移。缺失 marker 时使用 `WeaponConfig.ads_center_offset`。

主相机优先使用头部 BoneAttachment3D 下的 `EyeAnchor` 位置，旋转仍来自视角控制器。缺失时使用原有头部偏移与眼高回退。ADS 不修改身体和手臂的可见性、渲染层或阴影设置。

光学瞄具需要同时提供 `OpticCameraAnchor` 和 `LensSurface`。前者是镜内相机的位置与方向，后者是有 UV 的镜片网格。1x 和多倍率统一使用双相机，`optic_fov = 2 * atan(tan(main_fov / 2) / magnification)`。原有 `pixel_zoom` 设置不再参与运行时选择。

镜内相机与主场景共享 World3D，排除本地武器专用渲染层 20。机瞄不分配镜内相机，首次绑定有效光学瞄具时创建，之后复用。ADS 退出过渡结束后停止 SubViewport 更新并恢复原镜片材质。

`OpticEyeBoxConfig` 使用 ADSAnchor 作为眼睛校准点，在 OpticCameraAnchor 轴向计算横向、纵向和眼距偏离，并检查瞄准角误差。容差、软化范围和最小亮度都可在瞄具场景中配置；阴影只作用于镜片材质。

## 遮挡

从眼睛位置沿实时枪口方向进行球体扫掠，长度至少覆盖武器及配件长度，递归排除玩家与武器子树中的碰撞 RID，并额外处理起点重叠。原始权重与平滑姿态权重任一超过阈值都会禁射。进入和退出使用独立速度；检测依赖缺失时输出零并记录一次调试信息。

## 验证

使用 Godot 4.7 执行：

```text
godot --headless --path . --fixed-fps 60 res://tests/ads_system_runner.tscn
godot --headless --path . --fixed-fps 60 res://tests/ik_rig_check.tscn
godot --headless --path . --fixed-fps 60 res://tests/ai_aim_check.tscn
godot --headless --path . --fixed-fps 60 res://tests/force_integration_runner.tscn
```

现有正式资源只有机瞄提供 ADSAnchor；光学瞄具使用实际 LensSurface、OpticCameraAnchor 后才能启用镜内画面。专项测试通过运行时安装 1x/4x 光学瞄具验证整条链路。具体美术资源的镜片 UV 和眼距仍需按模型校准。
