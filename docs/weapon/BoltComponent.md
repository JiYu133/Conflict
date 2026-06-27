# BoltComponent

**文件路径：** `Classes/Weapon/Weapon/bolt_component.gd`  
**继承自：** `Node`

## 功能概述

模拟自动武器枪机的完整运动循环：开锁 → 后坐 → 复进 → 闭锁。枪机是否处于闭锁状态（`_is_locked`）是武器能否击发的关键前提，空仓挂机状态（`_is_held_open`）则阻止枪机复进直到玩家手动释放。

## 初始化

### `initialize(cfg: WeaponConfig) -> void`

在武器实例创建后由 `BaseWeapon` 调用。根据 `cfg.muzzle_velocity` 按 15% 比例换算后坐速度；根据 `cfg.recoil_spring_strength / cfg.bolt_mass * 0.02` 换算复进速度（两者均有零值保护兜底：`bolt_mass < 0.001` 取 0.3，`recoil_spring_strength < 0.001` 取 50.0）。同时连接 `cycle_completed` 信号到内部回调 `_on_cycle_completed` 以自动执行闭锁。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `cycle_completed` | 无 | 枪机完成一个完整自动循环（复进到位并闭锁） |
| `bolt_reached_rear` | 无 | 枪机后坐到达行程终点，此时可触发抛壳和推弹准备 |
| `bolt_hold_open` | 无 | 枪机被挂起锁定在后方（空仓挂机激活） |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置引用，由 `initialize()` 注入 |
| `bolt_speed_open` | `float` | 枪机后坐速度（m/s），由初速 × 0.15 换算 |
| `bolt_speed_close` | `float` | 枪机复进速度（m/s），由复进簧刚度 / 枪机质量 × 0.02 换算 |

## 公开方法（Methods）

### `is_locked() -> bool`
返回枪机是否处于闭锁状态。只有 `true` 时击发控制组件才允许开火。

### `is_held_open() -> bool`
返回枪机是否被空仓挂机卡住（停留在后方）。

### `on_bolt_start_back() -> void`
标记枪机开始后坐，将 `_is_locked` 置为 `false`（开锁）。应在击发后由 `BaseWeapon` 调用。

### `on_bolt_start_forward() -> void`
标记枪机开始复进，`_is_locked` 保持 `false`（枪机尚未到位）。应在后坐完成后由 `BaseWeapon` 调用。

### `hold_open() -> void`
将枪机挂起在后方（`_is_held_open = true`），对应空仓挂机状态。

### `release_bolt() -> void`
释放空仓挂机（`_is_held_open = false`）。当前版本不会自动触发复进，复进由 `BaseWeapon.reload()` 中手动调用 `_start_bolt_forward()` 完成。

## 依赖关系

- **依赖：** `WeaponConfig`（读取 `muzzle_velocity`、`bolt_mass`、`recoil_spring_strength`）
- **被依赖：** `BaseWeapon` 持有此组件，在击发流程各阶段调用状态切换方法，并订阅 `cycle_completed`、`bolt_reached_rear`、`bolt_hold_open` 信号以推进武器状态机

## 注意事项

- `_is_locked` 的内部回调（`_on_cycle_completed`）在 `initialize()` 时已通过信号连接，无需外部再次连接。若外部也连接了 `cycle_completed`，闭锁回调仍会正常执行，但顺序取决于连接时机。
- `release_bolt()` 当前不触发复进动作，调用后必须由 `BaseWeapon` 显式推进枪机，否则枪机将停留在开锁但未挂起的中间状态。
- `bolt_speed_open` 和 `bolt_speed_close` 均为经验简化值，不代表物理精确模拟，仅用于驱动动画计时和音效参数。
- 零值保护仅在 `cfg.bolt_mass` 和 `cfg.recoil_spring_strength` 接近零时生效；若这两个字段在 `WeaponConfig` 中未赋值（默认为 0），将使用兜底值 0.3 和 50.0，可能与实际武器数值差异较大。
