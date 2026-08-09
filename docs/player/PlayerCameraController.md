# PlayerCameraController

**文件路径：** `Classes/Player/player_camera_controller.gd`
**继承自：** `Node`

## 功能概述

`PlayerCameraController` 负责管理第一人称视角的摄像机挂载与鼠标视角控制，并叠加多层程序化摄像机效果，产生沉浸式的持枪手感。

摄像机位置获取支持三种方式（优先级递减）：

1. 模型场景中预设的 `CameraMount` 节点（挂载点）
2. 模型场景自带的 `Camera3D`
3. 从头部骨骼动态创建 `Marker3D` 挂载点（回退方案）

所有程序化效果均为独立层，最终以加法合成到摄像机变换，互不干扰，可通过 `CameraConfig` 单独开关。

---

## 初始化

```gdscript
func initialize(
    player: CharacterBody3D,
    model_manager: PlayerModelManager,
    model_lookup_config: ModelLookupConfig,
    camera_config: CameraConfig
) -> void
```

由 `BasePlayer` 在子系统组装阶段调用。完成以下工作：

- 保存各依赖引用
- 按 `CameraConfig` 参数创建 `_land_spring` 与 `_pitch_spring` 两个弹簧实例
- 向玩家节点添加临时占位 `SeedCamera`，防止视口在真实摄像机挂载前出现空窗
- 将鼠标设为捕获模式（`MOUSE_MODE_CAPTURED`）

> **注意：** 初始化完成后，外部还需将 `model_manager.model_loaded` 信号连接到 `_on_model_loaded`，摄像机才会在模型加载后自动查找挂载点。

完成模型加载后，调用 `enable_camera()` 正式激活视角控制并发出 `camera_ready` 信号。

玩家死亡/昏迷后，`disable_camera()` 会将活动相机移出玩家和模型层级，关闭头部位置弹簧，
并直接读取布娃娃头部的物理姿态。若模型没有头部 `PhysicalBone3D`，会回退到最近的物理父骨骼
（当前测试模型为 `mixamorig_Neck`），再应用死亡前缓存的头部相对变换，因此相机可以保留真实的翻滚。

进入昏迷或死亡布娃娃后，会通过 `set_ragdoll_camera_shake(true)` 启用轻微的程序化位置、俯仰、偏航和横滚晃动；
恢复意识、复活或重新启用正常相机时会清除该效果。晃动幅度保持较低，并叠加在物理骨骼的真实翻滚姿态之上。
相机接管前会缓存原父节点和局部变换，复活时原样恢复，因此同时兼容显式 `CameraMount` 和模型自带 `Camera3D`。

---

## 信号（Signals）

| 信号 | 参数 | 说明 |
|------|------|------|
| `camera_ready` | `camera: Camera3D` | 摄像机挂载完毕、视角控制就绪时发出，订阅方可在此时安全访问活动摄像机。**若模型无任何可识别的摄像机挂载点（无 CameraMount、无 Camera3D、无头骨），参数可能为 null，订阅方应做非空检查** |

---

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `camera_mount` | `Node3D`（只读） | 当前活动的摄像机挂载点，通过 `_camera_mount` 私有变量暴露 |
| `model_camera` | `Camera3D`（只读） | 模型自带的摄像机（如有），通过 `_model_camera` 私有变量暴露 |

---

## 公开方法（Methods）

### `enable_camera() -> void`

启用摄像机视角控制。从 `CameraConfig` 读取鼠标灵敏度与垂直角度限制，然后按优先级（挂载点 → 模型摄像机 → 骨骼创建）完成摄像机挂载，最后发出 `camera_ready` 信号并应用 FOV。

### `setup_weapon_sway_pivot(weapon_mount: Node3D) -> Node3D`

在 `weapon_mount` 下创建名为 `WeaponSwayPivot` 的 `Node3D` 节点并返回，供调用方将武器实际挂载到该支点之下以获得晃动效果。若支点已存在则直接返回现有实例。由 `BasePlayer._on_model_loaded` 在 `WeaponMount` 就绪后调用。

### `connect_movement_signals(movement: PlayerMovementController) -> void`

将 `PlayerMovementController` 的 `landed` 与 `jumped` 信号分别连接到 `on_landed` 和 `on_jumped`，启用落地冲击效果。由 `BasePlayer` 在子系统初始化完成后调用，内部做幂等校验防止重复连接。

### `set_recoil_component(rc: RecoilComponent) -> void`

注入 `RecoilComponent` 引用，后座层将在每帧从中读取累积偏移。在武器装备后由 `BasePlayer` 调用；传入 `null` 可清除后座效果。

### `get_active_camera() -> Camera3D`

返回当前活动的 `Camera3D`，供 `WeaponObstructionDetector` 等外部系统使用。

死亡跟随期间返回的相机仍为同一活动相机，但其父节点为场景根，位置和朝向每帧由布娃娃物理骨骼驱动。

### `on_landed() -> void`

落地回调，由 `PlayerMovementController.landed` 信号触发。按空中下落速度缩放冲击幅度，向位置弹簧施加向下冲量，向 pitch 弹簧施加向前点头冲量。

### `on_jumped() -> void`

起跳回调，由 `PlayerMovementController.jumped` 信号触发。向位置弹簧施加向上轻推冲量，向 pitch 弹簧施加轻微后仰冲量。

---

## 程序化摄像机效果层

所有效果在 `_process(delta)` 中独立计算，最终以加法合成到摄像机变换。位置偏移（`pos_offset`）由层 1、2、3 求和后写入 `_active_camera.position`；旋转偏移由层 4 叠加到 `_vertical_angle` 后写入 `_active_camera.rotation.x`；Z 轴倾斜由层 5 在 `_process` 末尾统一写入 `_active_camera.rotation.z`（不在 `_update_tilt` 内部写，统一由 `_process` 负责）。

### 层 1：头部摆动（Head Bob）

**控制开关：** `CameraConfig.bob_enabled`

基于角色水平速度驱动垂直正弦轨迹，模拟步伐重心起伏：

- 相位累加速率根据速度自动切换行走频率（`bob_frequency_walk`）和奔跑频率（`bob_frequency_run`）；切换阈值为 `walk_speed_reference × bob_run_threshold_multiplier`。
- 振幅随水平速度线性缩放（`speed_t = h_speed / max_speed_reference`），低速轻微、高速明显。
- 离地或速度低于 `bob_min_speed` 时，偏移以 `bob_return_speed` 速率 lerp 归零，相位同步重置，避免下次落地时跳跃。
- **注意：** `bob_return_speed` 的 lerp 无 clamp 保护，帧率极低时可能产生过冲，见 `CameraConfig` 注意事项。

相关配置键：`bob_enabled`、`bob_min_speed`、`bob_run_threshold_multiplier`、`bob_frequency_walk`、`bob_frequency_run`、`bob_amplitude_vertical`、`bob_return_speed`、`walk_speed_reference`、`max_speed_reference`

### 层 2：呼吸摆动（Breathing）

**控制开关：** `CameraConfig.breathe_enabled`

静止或低速时叠加低频 sine 漂移，模拟持枪自然呼吸感：

- 垂直分量为全频 `sin(phase × TAU)`，水平分量为半频 `sin(phase × TAU × 0.5)`。
- 权重 `weight = 1 - clamp(h_speed / breathe_max_speed, 0, 1)`：速度超过 `breathe_max_speed` 时效果线性淡出，与头部摆动层平滑交接，两者不会同时全强度叠加。

相关配置键：`breathe_frequency`、`breathe_amplitude_vertical`、`breathe_amplitude_horizontal`、`breathe_max_speed`

### 层 3：落地冲击（Landing Impact）

**控制开关：** `CameraConfig.land_impact_enabled`

使用两个独立的 `CameraSpring` 弹簧实例，在落地/起跳事件时施加冲量，产生自然衰减的物理感：

- **`_land_spring`（位置弹簧）：** 控制摄像机 Y 轴下沉与回弹。落地时施加负向冲量（`land_impact_impulse`），起跳时施加正向冲量（`jump_lift_impulse`）。
- **`_pitch_spring`（俯仰弹簧）：** 控制摄像机 X 轴旋转。落地时向前点头（`land_pitch_impulse`），起跳时轻微后仰（`jump_pitch_impulse`）。
- 冲量幅度按空中最大下落速度缩放：`velocity_scale = 1 + abs(_air_y_velocity) × land_impact_velocity_scale`，落得越重动静越大。

相关配置键：`land_impact_impulse`、`land_impact_velocity_scale`、`land_impact_stiffness`、`land_impact_damping`、`land_pitch_impulse`、`land_pitch_stiffness`、`land_pitch_damping`、`jump_lift_impulse`、`jump_pitch_impulse`

### 层 4：后座（Recoil）

**依赖：** 外部通过 `set_recoil_component()` 注入 `RecoilComponent`

从 `RecoilComponent` 读取已累积的后座偏移，叠加到摄像机旋转：

- **垂直后座（pitch）：** 调用 `_recoil_component.get_recoil_offset()`，直接加到 `_active_camera.rotation.x`，不修改 `_vertical_angle`，确保后座视觉效果与玩家准星控制解耦——松开扳机后准星回正不影响后座动画。
- **水平后座（yaw）：** 调用 `_recoil_component.get_recoil_horizontal_offset()`，乘以 `delta` 后通过 `_player.rotate_y()` 应用，保持水平视角与角色朝向一致。

### 层 5：速度倾斜（Tilt）

**控制开关：** `CameraConfig.tilt_enabled`

根据角色局部坐标系的横向速度，将摄像机沿 Z 轴轻微倾斜，模拟重心偏移感：

- 将世界空间速度转换到玩家局部坐标系，取 X 分量（向右为正）。
- 目标倾斜角：`-clamp(lateral_speed / max_speed_reference, -1, 1) × tilt_max_angle`（方向取反：向右跑 → 相机左倾）。
- 以 `tilt_speed` 平滑 lerp 到目标角度，结果存入 `_tilt_angle`；`_process` 末尾统一将其写入 `_active_camera.rotation.z`。

相关配置键：`tilt_max_angle`、`tilt_speed`、`max_speed_reference`

### 武器晃动（Weapon Sway）

**控制开关：** `CameraConfig.sway_enabled`  
**作用节点：** `_sway_pivot`（`WeaponSwayPivot`），不影响摄像机旋转

三层效果叠加，作用于 `WeaponMount` 下的支点节点：

- **层 A（look sway）：** 鼠标移动量 `_mouse_delta` 分别乘以 `sway_look_amount`（横滚/Z 轴）和 `sway_look_amount_pitch`（俯仰/X 轴）驱动支点旋转目标，lerp 平滑归位，模拟武器惯性滞后。
- **层 B（move sway）：** 角色速度转换到局部坐标系后乘以 `sway_move_amount × sway_move_scale_*`，驱动支点位置偏移（X/Y 轴），模拟持枪重量在运动中的晃动。空中时 Y 速度非零，会产生额外垂直偏移。
- **层 C（weapon lag）：** 由 `weapon_lag_enabled` 独立控制。鼠标输入乘以灵敏度后叠加到 yaw/pitch 积累量，每帧钳制到 `weapon_lag_max` 后再 lerp 归零，产生转头时武器的惯性滞后感。**仅在 `sway_enabled = true` 时生效**；`look sway` 使用原始像素输入，`weapon lag` 乘以 `mouse_sensitivity`，两者量纲不同，调整灵敏度时 lag 效果会同步缩放但 sway 不会。

Z 轴（`position.z`）保留给 `WeaponObstructionDetector` 控制收枪偏移，本控制器仅写 X/Y。

相关配置键：`sway_enabled`、`sway_look_amount`、`sway_look_amount_pitch`、`sway_move_amount`、`sway_move_scale_horizontal`、`sway_move_scale_vertical`、`sway_speed`、`weapon_lag_enabled`、`weapon_lag_scale`、`weapon_lag_max`、`weapon_lag_return_speed`

---

## 内部工具类：CameraSpring

`CameraSpring` 是定义在脚本内部的轻量弹簧-阻尼模拟器，专为摄像机效果设计。

**属性：**

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `position` | `float` | `0.0` | 当前位移（单位：m 或 rad，取决于使用场景） |
| `velocity` | `float` | `0.0` | 当前速度（m/s 或 rad/s） |
| `stiffness` | `float` | `180.0` | 弹簧刚度，值越大回弹越快 |
| `damping` | `float` | `16.0` | 阻尼系数，值越大振荡越少 |

**方法：**

| 方法 | 返回值 | 说明 |
|------|--------|------|
| `update(delta: float, target: float = 0.0) -> float` | `float` | 每帧推进弹簧状态，朝 `target` 收敛，返回当前 `position` |
| `add_impulse(impulse: float) -> void` | — | 施加瞬时速度冲量（正值向上/前，负值向下/后） |
| `reset() -> void` | — | 将 `position` 与 `velocity` 重置为 0，回到静止状态 |

弹簧力公式：`force = -stiffness × (position - target) - damping × velocity`

---

## 依赖关系

| 依赖 | 类型 | 说明 |
|------|------|------|
| `PlayerModelManager` | 节点引用 | 提供模型节点、骨骼、`find_node_by_names()` 等查询能力 |
| `ModelLookupConfig` | Resource | 配置摄像机挂载点候选名称列表（`camera_mount_names`）和头部骨骼候选名称列表（`head_bone_names`） |
| `CameraConfig` | Resource | 配置所有摄像机效果的开关与参数（灵敏度、FOV、各层幅度/频率等） |
| `CharacterBody3D`（`_player`） | 节点引用 | 提供 `rotate_y()`（水平视角）、`velocity`（速度驱动效果）、`is_on_floor()`（步态/呼吸判断） |
| `PlayerMovementController` | 节点引用 | 通过信号 `landed` / `jumped` 触发落地冲击效果，由 `connect_movement_signals()` 接入 |
| `RecoilComponent` | 节点引用 | 提供 `get_recoil_offset()` 和 `get_recoil_horizontal_offset()`，由 `set_recoil_component()` 注入 |

---

## 注意事项

- **武器晃动只修改 `_sway_pivot` 的 X/Y 轴，Z 轴保留给外部系统。** `WeaponObstructionDetector` 等组件通过修改 `_sway_pivot.position.z` 实现收枪偏移，若此控制器也写入 Z 轴将产生冲突。见代码注释：`# 只插值 X/Y，Z 轴留给 WeaponObstructionDetector 控制收枪偏移`。

- **后座不修改 `_vertical_angle`。** `_get_recoil_pitch()` 的返回值仅在写入 `_active_camera.rotation.x` 时临时叠加，`_vertical_angle` 始终只反映鼠标输入，保证后座恢复后准星位置不漂移。

- **摄像机查找需要外部连接信号。** `initialize()` 不会自动查找模型节点，必须在外部将 `model_manager.model_loaded` 连接到 `_on_model_loaded()`，否则摄像机挂载不会执行。

- **SeedCamera 占位摄像机。** 初始化时会向玩家节点添加一个名为 `SeedCamera` 的临时 `Camera3D`，防止视口空窗。它会在 `_attach_to_mount()` 中检测并 `queue_free()`，正常流程无需手动清理。

- **`ModelLookupConfig` 与 `CameraConfig` 可为空。** `initialize()` 对两者均做了 `if … else … .new()` 保护，传入 `null` 时会使用默认配置实例，不会崩溃。

- **弹簧参数在 `initialize()` 时写入，此后修改 `CameraConfig` 不会自动同步。** 若需运行时热更新弹簧参数，需手动赋值 `_land_spring.stiffness` 等属性。
