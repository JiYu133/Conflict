# GasComponent

**文件路径：** `Classes/Weapon/Weapon/gas_component.gd`  
**继承自：** `Node`

## 功能概述

模拟导气式自动武器从子弹经过导气孔到枪机开始后坐的延时。子弹飞过导气孔时，部分高压燃气被引入导气管推动活塞，活塞再推动枪机框向后运动；该组件将这一物理过程简化为一个延时值，供 `BaseWeapon` 在击发后计时使用。

## 初始化

### `initialize(cfg: WeaponConfig) -> void`

在武器实例创建后由 `BaseWeapon` 调用，将 `WeaponConfig` 引用存入 `config`。

## 信号（Signals）

此组件无信号。

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置引用，由 `initialize()` 注入 |

## 公开方法（Methods）

### `get_delay_time() -> float`
计算从子弹经过导气孔到枪机开始后坐的延时（秒）。

计算方式：
1. 子弹飞越枪管的总时间 = `config.barrel_length / config.muzzle_velocity`
2. 导气孔通常位于枪管约 1/3 处，取总飞行时间的 30% 作为延时近似值

返回值约为 `barrel_length / muzzle_velocity * 0.3`。

## 依赖关系

- **依赖：** `WeaponConfig`（读取 `barrel_length` 和 `muzzle_velocity`）
- **被依赖：** `BaseWeapon` 持有此组件，在击发后调用 `get_delay_time()` 获取延时，然后启动计时器，计时结束后再触发枪机后坐流程

## 注意事项

- 当前实现为纯经验公式，30% 系数不区分短行程活塞、长行程活塞或导气管长度，所有导气式武器共用同一比例。
- 若 `config.muzzle_velocity` 为 0，将发生除零错误（返回 `inf` 或 `NaN`），使用前需确保 `WeaponConfig` 中 `muzzle_velocity > 0`。
- 后续扩展方向（代码内 TODO）：从 `config` 读取导气孔到弹膛的精确距离，并区分短行程/长行程的延时差异。
- 此组件不模拟导气压力、活塞力等物理量，仅输出一个延时时间，实际的枪机运动速度由 `BoltComponent` 的 `bolt_speed_open` 控制。
