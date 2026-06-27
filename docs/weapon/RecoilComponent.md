# RecoilComponent

**文件路径：** `Classes/Weapon/Weapon/recoil_component.gd`
**继承自：** `Node`

## 功能概述

后座组件。模拟每发子弹射击后的枪口上跳（垂直后座）以及左右随机偏移（水平后座），并在每帧自动回正，模拟玩家控枪复位动作。后座角度累积后由外部（摄像机控制器或准星系统）每帧读取，用于驱动画面或准星偏移。

## 初始化

```
initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void
```

注入武器配置和配件管理器引用。`am` 可为 null（无配件修正时）。初始化后重置累积角度为 0。

## 信号（Signals）

无。

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置，提供基础后座参数 |
| `attachment_manager` | `AttachmentManager` | 配件管理器，用于读取配件的后座修正（可为 null） |

## 公开方法（Methods）

### `apply_recoil() -> void`
应用一发子弹的后座。每次 `fired` 信号触发时由 `BaseWeapon` 调用。
- 垂直后座 = `config.recoil_vertical` + 所有配件的垂直修正，取 max(值, 0)后累加到 `_current_recoil_angle`
- 水平后座 = `config.recoil_horizontal` + 所有配件的水平修正，取 max(值, 0)后在 `[-horizontal, +horizontal]` 范围内随机叠加

### `get_recoil_offset() -> float`
返回当前累积的垂直后座角度（度，正值 = 枪口上抬）。外部摄像机控制器每帧调用。

### `get_recoil_horizontal_offset() -> float`
返回当前累积的水平后座角度（度，正值 = 向右，负值 = 向左）。外部准星或相机 yaw 叠加此值。

## 依赖关系
- **依赖：** `WeaponConfig`（`recoil_vertical`、`recoil_horizontal`、`recoil_recovery_speed`）、`AttachmentManager`（后座修正汇总）
- **被依赖：** `BaseWeapon`（持有引用，在 `_fire_one_round()` 中调用 `apply_recoil()`）、摄像机/准星控制器（每帧读取偏移量）

## 注意事项

- 回正逻辑在 `_process(delta)` 中每帧执行，使用 `move_toward` 线性插值，`recovery_speed` 来自 `config` 与配件修正之和（取 max(值, 0) 防止负速度）。
- 水平后座方向随机（`randf_range`），每发方向独立，不会单向累积。
- 此组件不直接操作摄像机，仅维护角度数值；调用方负责将偏移量映射到实际旋转。
