# WeaponMovingPartsController

**文件路径：** `classes/weapon/weapon_moving_parts_controller.gd`
**继承自：** `Node`

## 功能概述

可动部件控制器。订阅 `BaseWeapon.bolt_moving(position: float)` 信号，驱动武器场景中命名为 `BoltCarrier` 和 `ChargingHandleMesh` 的 Node3D 节点沿 Z 轴往复位移，模拟枪机后座与复进。

由 `WeaponManager.equip_weapon()` 创建，挂在武器节点下随武器一起销毁。

## 工作模式

**默认（位移驱动）：** 在 `_record_rest_positions()` 记录各节点的静息位置，`bolt_moving` 信号回调里计算 `rest_pos + Z * position * bolt_travel_m` 并写入 `position`。

**动画驱动（可选）：** 武器 `AnimationPlayer` 中存在名为 `bolt_cycle` 的动画时，改为调用 `anim_player.seek(position * anim.length, true)`，美术可在动画里控制多部件联动。

## 节点命名约定

武器场景内的可动部件按此命名，控制器用 `find_child()` 自动查找：

| 节点名 | 说明 |
|--------|------|
| `BoltCarrier` | 枪机框/活塞（沿 +Z 后退） |
| `ChargingHandleMesh` | 拉机柄（随枪机框同步） |

## 初始化

```gdscript
initialize(weapon: BaseWeapon) -> void
```

查找可动部件节点，用 `call_deferred("_record_rest_positions")` 延迟一帧记录静息位置（保证 GLB 节点 `_ready()` 已执行），然后连接 `bolt_moving` 信号。

## 相关配置

`WeaponConfig.bolt_travel_m`：枪机行程（m），控制最大位移距离。默认 `0.08`。

## 注意事项

- 找不到 `BoltCarrier` 且无 `bolt_cycle` 动画时静默跳过，武器功能不受影响
- 动画驱动模式下 `bolt_travel_m` 不起作用，行程由动画长度决定
