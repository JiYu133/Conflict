# BoltComponent

**文件路径：** `classes/weapon/bolt_component.gd`

**继承自：** `Node`

维护闭锁、空仓挂机与卡弹状态，输出后坐/复进速度。BaseWeapon._update_cycle() 实际推进归一化枪机位置并发相关信号；本组件不独立运行完整机械循环。

initialize(cfg: WeaponConfig) 保存引用并设置缺省速度、连接 cycle_completed→闭锁。reconfigure(bolt_cfg: BoltCarrierConfig) 使用枪机质量与复进簧，质量/簧接近零时分别回退 0.3 / 50.0。枪管初速由 set_muzzle_velocity(v) 缓存，不读取已移除的 WeaponConfig.muzzle_velocity/bolt_mass。

configure_cycle_rate(rpm, gas_delay = 0.0, rear_pause = 0.0) 按 60/RPM 标定整体往返速度；极端运动周期做最小值保护。速度是机械计时模型中的简化值，不应当作精确刚体积分。

## API 与信号

查询：is_locked()、is_held_open()、is_jammed()、get_jam_type()。状态切换：on_bolt_start_back()、on_bolt_start_forward()、hold_open()、release_bolt()；故障为 JamType.NONE/STOVEPIPE/DOUBLE_FEED。

cycle_completed、bolt_reached_rear、bolt_hold_open 与 jammed(type) 供 BaseWeapon 协调。release_bolt() 只释放状态，空仓装填仍需 BaseWeapon 设置 is_cycling、cycle_phase、bolt_position 并推进复进。

数据来自 BoltCarrierConfig、BarrelConfig 与 WeaponConfig.cycle_rate；接线由 BaseWeapon._apply_attachment_change() 更新。
