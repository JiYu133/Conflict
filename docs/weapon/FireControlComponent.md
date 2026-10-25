# FireControlComponent

**文件路径：** `classes/weapon/fire_control_component.gd`

**继承自：** `Node`

管理扳机复位与 safe / semi / auto / burst。枪机循环和点射剩余发数由 BaseWeapon 管理，本组件不生成弹丸。

| 方法 | 行为 |
|---|---|
| `initialize(cfg)` | 保存 WeaponConfig |
| `set_fire_mode(mode) -> bool` | 检查 config.fire_modes 后更新模式 |
| `press_trigger()` | 使用 current_fire_mode，没有 mode 参数 |
| `release_trigger()` | 复位扳机并发 trigger_released |

safe 不击发；semi 仅扳机已复位时发 trigger_pulled；auto 每次调用都发 trigger_pulled，BaseWeapon 通过 trigger_held 在枪机循环结束后续发。

burst 已实现：有效扣扳机先发 burst_started，再发 trigger_pulled；下一组前需松扳机。BaseWeapon 用 WeaponConfig.burst_count 追踪余数，当前一组不因松开扳机中断。

trigger_pulled、trigger_released、burst_started 均无参数。BaseWeapon 还检查快慢机允许的模式，外部优先调用 WeaponManager 的切换入口。测试说明见 [Testing](../Testing.md)。
