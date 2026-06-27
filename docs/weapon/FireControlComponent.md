# FireControlComponent

**文件路径：** `Classes/Weapon/Weapon/fire_control_component.gd`  
**继承自：** `Node`

## 功能概述

模拟扳机组、阻铁和保险的完整击发控制逻辑。根据当前射击模式（`safe` / `semi` / `auto`）决定是否允许击发，并通过 `_trigger_reset` 标志确保半自动模式下每发子弹都需要完整的松开-扣下动作。

## 初始化

### `initialize(cfg: WeaponConfig) -> void`

在武器实例创建后由 `BaseWeapon` 调用，将 `WeaponConfig` 引用存入 `config`（当前版本用于后续扩展，初始化本身不从配置读取数据）。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `trigger_pulled` | 无 | 扳机被扣下且通过了射击模式检查（非 safe，且 semi 模式下扳机已复位） |
| `trigger_released` | 无 | 扳机被松开，`_trigger_reset` 已置为 `true` |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置引用，由 `initialize()` 注入 |

## 公开方法（Methods）

### `press_trigger(mode: String) -> void`
模拟扣下扳机。`mode` 取值：
- `"safe"`：保险状态，直接返回，不发出任何信号。
- `"semi"`：半自动，仅当 `_trigger_reset == true` 时 emit `trigger_pulled` 并将 `_trigger_reset` 置为 `false`，防止按住扳机连发。
- `"auto"`：全自动，每次调用都 emit `trigger_pulled`，由上游（`BaseWeapon`）通过 `trigger_held` 标志控制是否持续调用。
- `"burst"`（三发点射）：未实现，当前代码无此分支。

### `release_trigger() -> void`
模拟松开扳机，将 `_trigger_reset` 复位为 `true` 并 emit `trigger_released`。半自动模式下必须调用此方法才能允许下一次击发。

## 依赖关系

- **依赖：** `WeaponConfig`（当前仅存引用，未读取具体字段；`fire_modes` 合法性校验由上游调用方负责）
- **被依赖：** `BaseWeapon` 持有此组件，在玩家输入时调用 `press_trigger()` / `release_trigger()`，并订阅 `trigger_pulled` 信号以触发实际击发流程

## 注意事项

- 射击模式的合法性（是否在 `config.fire_modes` 列表中）由 `BaseWeapon` 在切换模式时校验，`FireControlComponent` 本身不做校验，传入非法 mode 字符串时 `match` 不匹配任何分支，行为等同于 `"safe"`（静默忽略）。
- `"auto"` 模式下 `press_trigger()` 本身不含循环，需要上游每帧或每个弹道循环结束后重复调用才能实现持续射击。
- `"burst"` 分支当前完全未实现，扩展时需在 `press_trigger()` 的 `match` 块中添加对应逻辑，并在 `WeaponConfig` 的 `fire_modes` 中注册。
- `_trigger_reset` 初始值为 `true`，武器生成后无需额外初始化即可立即击发。
