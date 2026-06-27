# BaseWeapon

**文件路径：** `Classes/Weapon/Weapon/base_weapon.gd`
**继承自：** `Node3D`

## 功能概述

所有枪械的根节点。负责管理子组件的生命周期、枪机自动循环状态机、击发逻辑、换弹流程，以及内部信号的路由分发。外部系统（玩家控制器、UI、音效）只需订阅 BaseWeapon 暴露的信号，无需直接访问各子组件。

## 初始化

```
initialize(cfg: WeaponConfig) -> void
```

完整初始化流程，按顺序执行：
1. 保存 `config` 引用
2. `_initialize_components()` — 创建并添加所有子组件节点
3. `_setup_from_config()` — 将 `WeaponConfig` 注入各组件
4. `_connect_internal_signals()` — 连接子组件信号到本类回调
5. `attachment_manager.initialize()` — 扫描场景内的 `AttachmentSlot`
6. `ammo_component.apply_magazine_attachments()` — 根据配件调整弹匣容量

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `fired` | — | 子弹出膛时 |
| `bolt_moving` | `position: float` | 枪机位置变化时（0.0 = 闭锁，1.0 = 全开） |
| `bolt_locked` | — | 枪机完成自动循环并闭锁后 |
| `bolt_hold_open` | — | 空仓挂机激活时 |
| `round_chambered` | — | 子弹被推入枪膛时 |
| `magazine_changed` | `mag_index: int` | 弹匣切换时（供 UI / 音效 / 动画订阅） |
| `ammo_depleted` | — | 扳机扣下但无弹可用时 |
| `reload_started` | — | 换弹开始时 |
| `reload_finished` | — | 换弹完成时 |
| `ejection` | `case_position: Vector3, case_velocity: Vector3` | 抛壳时，携带弹壳位置与初速度 |
| `fire_mode_changed` | `mode: String` | 射击模式切换时 |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置资源 |
| `current_fire_mode` | `String` | 当前射击模式，默认 `"semi"` |
| `is_cycling` | `bool` | 枪机是否处于自动循环中 |
| `cycle_phase` | `String` | 当前循环阶段：`idle` / `delay` / `moving_back` / `moving_forward` |
| `cycle_timer` | `float` | delay 阶段的倒计时（秒） |
| `bolt_position` | `float` | 枪机位置：0.0 = 前方闭锁，1.0 = 后方全开 |
| `trigger_held` | `bool` | 扳机是否被持续按住（连发续火依赖此标志） |
| `is_reloading` | `bool` | 是否正在换弹 |
| `bolt_component` | `BoltComponent` | 枪机组件 |
| `ammo_component` | `AmmoComponent` | 弹药组件 |
| `fire_control` | `FireControlComponent` | 击发控制组件 |
| `gas_component` | `GasComponent` | 导气组件 |
| `recoil_component` | `RecoilComponent` | 后座组件 |
| `ejection_component` | `EjectionComponent` | 抛壳组件 |
| `attachment_manager` | `AttachmentManager` | 配件管理器 |

## 公开方法（Methods）

### `initialize(cfg: WeaponConfig) -> void`
完整初始化武器，见上方"初始化"章节。

### `press_trigger() -> void`
按下扳机。设置 `trigger_held = true` 并通知 `FireControlComponent`；连发模式下此标志驱动续火。

### `release_trigger() -> void`
松开扳机。清除 `trigger_held`，通知 `FireControlComponent`。

### `reload() -> void`
执行换弹。区分三种情况：
- 战术换弹（膛内有弹）：只换弹匣，不动枪机
- 空仓换弹（弹匣打空，枪机挂起）：换弹匣 + 释放枪机 + 复进推弹
- 边缘情况（弹匣空但枪机未挂起）：换弹匣 + 手动上膛

换弹期间 `is_reloading = true`，期间再次调用直接 return。

### `cycle_fire_mode() -> void`
按 `config.fire_modes` 列表顺序循环切换射击模式，触发 `fire_mode_changed` 信号。

### `get_current_spread(is_ads: bool) -> float`
返回当前散布值（度）。基础值取自 `config`，再叠加所有配件的散布修正。

## 依赖关系
- **依赖：** `WeaponConfig`、`BoltComponent`、`AmmoComponent`、`FireControlComponent`、`GasComponent`、`RecoilComponent`、`EjectionComponent`、`AttachmentManager`
- **被依赖：** `WeaponManager`（调用 `initialize` 并挂载到场景）、`BaseAttachment`（持有 `parent_weapon` 引用）、`AttachmentManager`（持有 `parent_weapon` 引用）

## 注意事项

- `reload()` 使用 `await` 计时，await 恢复后会用 `is_instance_valid(self)` 检查武器是否仍有效，避免换弹中途被销毁导致崩溃。
- 空仓换弹后手动启动复进前必须将 `is_cycling = true` 且 `bolt_position = 1.0`，否则状态机入口判断会直接 return，枪机永远无法复进。
- `_on_bolt_hold_open_requested()` 回调当前为预留接口，全库无 emit；实际空仓挂机由 `_handle_cycle_complete()` 驱动。
- 扩容弹匣在 `initialize()` 末尾调用 `apply_magazine_attachments()`，但此时尚无配件装入，bonus 恒为 0；装卸扩容弹匣后需重新调用该函数（当前版本未实现）。
