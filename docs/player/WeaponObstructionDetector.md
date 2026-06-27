# WeaponObstructionDetector

**文件路径：** `Classes/Player/weapon_obstruction_detector.gd`
**继承自：** `Node`

## 功能概述

武器遮挡检测器。每帧从摄像机位置向前发射一条短射线，检测武器前方是否存在障碍物。检测到障碍时按距离比例将武器晃动支点（`sway_pivot`）沿 `-Z` 轴平滑缩回，障碍消失后自动归位。射线长度动态读取当前武器配置（`weapon_length` 加上枪口配件修正），确保安装消音器等枪口装置后仍能正确检测。

纯本地视觉效果，不影响任何物理状态或网络同步。由 `BasePlayer._on_model_loaded()` 在摄像机和晃动支点就绪后动态创建并初始化。

## 初始化

### `initialize(player: CharacterBody3D, camera: Camera3D, weapon_manager: WeaponManager, sway_pivot: Node3D) -> void`

传入玩家根节点（用于物理空间查询和射线排除）、活动摄像机、武器管理器（读取当前武器长度）以及武器晃动支点（被修改 `position.z`）。必须在模型加载、摄像机节点和晃动支点均已就绪后调用。

## 信号（Signals）

无。

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `RETRACT_SPEED` | `float`（常量 `12.0`） | 缩回/归位的插值速度 |
| `MAX_RETRACT` | `float`（常量 `0.35`） | 最大缩进距离（m） |
| `FALLBACK_RAY_LENGTH` | `float`（常量 `0.75`） | 无武器时的默认射线检测长度（m） |

## 公开方法（Methods）

### `initialize(player: CharacterBody3D, camera: Camera3D, weapon_manager: WeaponManager, sway_pivot: Node3D) -> void`

见"初始化"章节。

## 内部逻辑说明

每帧 `_physics_process` 执行：

1. 调用 `_get_ray_length()` 确定本帧射线长度：优先读取 `weapon_manager.current_weapon.config.weapon_length`，再加上 `attachment_manager.get_total_length_modifier()`；无武器时回退到 `FALLBACK_RAY_LENGTH`
2. 调用 `_get_target_retract()` 发射射线：从 `camera.global_position` 沿摄像机 `-Z` 方向投射，排除玩家自身碰撞体；若命中则按 `1.0 - hit_dist / ray_length` 计算缩进比例并乘以 `MAX_RETRACT`，未命中返回 `0.0`
3. 使用 `lerp` 以 `RETRACT_SPEED * delta` 平滑过渡 `_retract_amount`
4. 将结果写入 `sway_pivot.position.z = -_retract_amount`

## 依赖关系

- **依赖：** `CharacterBody3D`（获取物理空间、排除自身 RID）、`Camera3D`（射线起点与方向）、`WeaponManager`（读取当前武器长度及配件修正）、`Node3D`（sway_pivot，被写入 position.z）
- **被依赖：** `BasePlayer`（在 `_on_model_loaded()` 中动态创建并持有节点引用）

## 注意事项

- 此节点在 `_on_model_loaded()` 中动态创建，比其他子系统晚初始化，无法在模型加载前访问。
- 缩进效果直接修改 `sway_pivot.position.z`，与 `PlayerCameraController` 中的武器晃动（sway）叠加作用，两者均作用于同一个支点节点。
- 射线排除仅排除玩家自身（通过 `get_rid()`），队友或其他动态物体均会触发缩进。
- `lerp` 的第三个参数被 `clamp(delta * RETRACT_SPEED, 0.0, 1.0)` 限制在 `[0, 1]`，在极低帧率下不会产生过冲。
