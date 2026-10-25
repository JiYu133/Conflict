# BaseWeapon

**文件路径：** `classes/weapon/base_weapon.gd`

**继承自：** `Node3D`

武器组件的门面：初始化枪机、弹药、击发、导气、后坐、抛壳、故障、FX 与配件管理，协调击发、自动循环、换弹和信号。WeaponManager 创建实例、设置挂点，并按依赖顺序装默认配件。

## 常用接口

| 方法 | 行为 |
|---|---|
| `initialize(cfg: WeaponConfig)` | 创建组件、配置和内部接线 |
| `press_trigger()` / `release_trigger()` | 扣/松扳机，公共击发入口检查所需配件 |
| `reload()` / `interrupt_reload()` | 开始或取消换弹，保留完成的阶段 |
| `cycle_fire_mode() -> bool` / `set_fire_mode(mode) -> bool` | 检查武器与快慢机支持后切换 |
| `get_available_fire_modes()` | 获取当前可选模式 |
| `get_current_spread(is_ads)` | 旧接口：返回 hipfire_spread，忽略 ADS；发射路径不消费此值 |
| `get_stats_snapshot()` | 改装 UI/调试用快照 |
| `debug_set_ammo_state(...)` / `debug_refill_ammo()` | 调试弹药设置 |

current_fire_mode 在未初始化时为 safe，初始化按配置/快慢机解析。is_cycling、cycle_phase、cycle_timer、bolt_position、trigger_held 和 is_reloading 暴露当前机械状态，业务输入优先走 WeaponManager。

## 击发与弹道

一次实际击发检查可用弹药、闭锁、非循环/换弹和枪管/World3D；缺枪管时不消耗膛内弹、不启动循环、不发 fired 或 recoil。通过检查后消耗一发，处理哑火，启动枪机循环并发射弹丸。

弹丸从 Muzzle Marker 的 -Z 或武器前向出发。ADS 不改变散布；hipfire_spread/ads_spread 和配件散布修正是兼容数据，不送入飞行弹道或 hitscan。弹道随机性由实际 BarrelConfig 控制。镜头不替代枪口物理，参见 [ADSSystem](ADSSystem.md)。

## 换弹

MagazineConfig 的 stage_mag_out_time / stage_mag_in_time / stage_charge_time 支持分段；全零回退 reload_time / reload_empty_time。战术换弹不拉机柄，空仓挂机需释放枪机并显式启动复进，其他空仓情况手动上膛。

已完成阶段保留在中断进度中。每次尝试有独立 generation，所有 await 恢复与阶段完成回调后都验证身份，旧计时器不能提前结束新换弹。

## 信号

fired、bolt_locked、bolt_hold_open、round_chambered、ammo_depleted、reload_started、reload_finished；bolt_moving(position)、magazine_changed(index)、ejection(position, velocity)、fire_mode_changed(mode)。

分段/取消信号为 reload_countdown_started(duration)、reload_stage_started(stage, duration)、reload_stage_finished(stage)、reload_interrupted(completed_stages)。故障信号为 malfunction_occurred(type) / malfunction_cleared()。

配件变化通过 _apply_attachment_change() 重配受影响组件；MagazineConfig 变化会触发 ammo_component.reconfigure()，RecoilComponent 会重建物理数据。不要使用旧文档“所有扩容靠 apply_magazine_attachments()”的假定。

测试为 combat_regression_check、ads_system_runner 和 force_integration_runner，见 [Testing](../Testing.md)。
