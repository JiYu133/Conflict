# WeaponManager

**文件路径：** `Classes/Weapon/Weapon/weapon_manager.gd`
**继承自：** `Node`

## 功能概述

武器持有者（玩家/AI）的门面控制器。负责管理当前装备的武器实例，将玩家输入（扳机、换弹、切模式）转发给当前武器，并对外暴露武器切换和加载接口。一个角色挂一个 WeaponManager 即可，不需要直接操作 BaseWeapon。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `weapon_changed` | `new_weapon: BaseWeapon` | 装备新武器时 |
| `weapon_fired` | `weapon: BaseWeapon` | （预留，当前无 emit） |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `current_weapon` | `BaseWeapon` | 当前装备的武器实例 |
| `weapon_mount` | `Node3D` | 武器在场景中的挂载节点，需在使用前通过 `set_mount()` 设置 |
| `is_aiming` | `bool` | 当前是否处于瞄准状态（供外部查询，WeaponManager 本身不消费此值） |

## 公开方法（Methods）

### `set_mount(mount: Node3D) -> void`
设置武器挂载节点。必须在调用 `equip_weapon()` 或 `load_and_equip()` 之前调用，否则武器会创建但不显示在场景中。

### `load_and_equip(config: WeaponConfig) -> void`
从 `WeaponConfig.weapon_scene` 实例化武器场景，调用 `weapon.initialize(config)`，然后调用 `equip_weapon()`。`config` 为空、`weapon_scene` 缺失或根节点不是 `BaseWeapon` 时会打印错误并 return。

### `equip_weapon(weapon: BaseWeapon) -> void`
替换当前武器。会先 `queue_free()` 旧武器，再将新武器添加为 `weapon_mount` 的子节点并归零位置/旋转，最后发出 `weapon_changed` 信号。

### `press_trigger() -> void`
转发扳机按下事件给 `current_weapon`。

### `release_trigger() -> void`
转发扳机松开事件给 `current_weapon`。

### `reload() -> void`
转发换弹请求给 `current_weapon`。

### `cycle_fire_mode() -> void`
转发射击模式切换请求给 `current_weapon`。

### `set_aiming(aiming: bool) -> void`
设置 `is_aiming` 状态标志。

## 依赖关系
- **依赖：** `BaseWeapon`、`WeaponConfig`
- **被依赖：** 玩家控制器或 AI 控制器（持有并调用 WeaponManager）

## 注意事项

- `weapon_mount` 为 null 时 `equip_weapon()` 会打印错误，武器节点已创建但不会出现在场景树的正确位置，注意在初始化时先调用 `set_mount()`。
- `equip_weapon()` 会立刻 `queue_free()` 旧武器，若旧武器正在换弹（有 `await` 挂起），`is_instance_valid` 检查会捕获此情况，不会崩溃。
- `weapon_fired` 信号目前无任何 emit，是预留接口。
