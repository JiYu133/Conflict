# RecoilComponent

**文件路径：** `classes/weapon/recoil_component.gd`
**继承自：** `Node`

## 功能概述

物理驱动的后座组件。每发子弹根据弹头动量、燃气冲量、武器总质量、质心、转动惯量和力矩臂，计算一次俯仰/偏航角速度冲量；随后用弹簧阻尼系统将摄像机偏移回正。

它不再读取 `recoil_vertical_modifier` / `recoil_horizontal_modifier` 等角度修正字段。旧字段仅保留为兼容数据，不参与后座计算。

## 初始化

```gdscript
initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void
```

创建 `RecoilPhysicsModel` 并根据当前武器和配件重建物理快照。

## 公开方法

```gdscript
rebuild_physics() -> void
```

配件装卸后由 `BaseWeapon._reconfigure_from_attachments()` 调用，重新计算质量、质心、转动惯量、燃气冲量和控枪参数。

```gdscript
apply_recoil(control_multiplier: float = 1.0) -> void
```

对当前后座状态施加一发子弹的角速度冲量。`control_multiplier` 只影响后续弹簧刚度/阻尼，不改变单发冲量。

```gdscript
get_camera_pitch_offset() -> float
get_camera_yaw_offset() -> float
```

返回当前瞬态后座偏移（弧度），由 `PlayerCameraController` 每帧叠加到鼠标视角上。

```gdscript
get_physics_snapshot() -> Dictionary
```

返回 `RecoilPhysicsModel` 的物理快照，供改装 UI 和调试使用。

## 依赖关系

- `RecoilPhysicsModel`：冲量、力矩、转动惯量、弹簧阻尼计算
- `BarrelConfig`：弹头质量、初速、装药质量、燃气速度
- `MuzzleDeviceConfig` / `GripConfig` / `StockConfig`：枪口燃气向量、握把支撑、肩部接触点
- `PlayerCameraController`：每帧读取 `get_camera_*_offset()` 并应用到摄像机
