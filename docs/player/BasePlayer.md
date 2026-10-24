# BasePlayer

**文件路径：** `classes/player/base_player.gd`
**继承自：** `CharacterBody3D`

## 功能概述

玩家实体的组合根。负责在 `_ready()` 时创建并初始化子系统，管理信号连接，并对外暴露玩家生命周期（死亡/复活）与可控状态的公开 API。核心组件挂在玩家下，具体 HUD 和菜单由 `PlayerUILayer` 持有，玩家保留兼容引用。

## 初始化

`_ready()` 调用 `_initialize_subsystems()`，按以下顺序完成初始化：

1. `_create_core_subsystems()` 创建核心组件。
2. `_initialize_controllers()` 初始化控制器并注入配置及状态提供者。
3. `_initialize_combat_feedback()` 初始化碰撞、医疗表现、体力、音频及 `PlayerWeaponFeedback`。
4. `_create_ui_subsystems()` 为本地玩家创建 `PlayerUILayer` 等组件，AI 跳过本地 UI。
5. `_connect_signals()` 连接组件事件；随后按配置加载角色模型。

模型加载完成后，`_on_model_loaded()` 分步完成布娃娃初始化、模型挂载、动画激活、骨骼绑定、相机与武器挂点接入，以及初始武器装备。武器阻挡检测在控制器阶段初始化，通过状态提供者读取实际武器数据。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `died` | 无 | `is_alive` 从 `true` 变为 `false` 时 |
| `revived` | 无 | `is_alive` 从 `false` 变为 `true` 时 |
| `faction_changed` | `new_faction: Faction` | 阵营变更时（枚举值已定义，信号声明存在，当前未见主动 emit） |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `player_config` | `PlayerConfig` | 玩家配置资源，在编辑器中赋值 |
| `is_alive` | `bool` | 存活状态；setter 自动切换 `controllable` 并发射 `died`/`revived` 信号 |
| `controllable` | `bool` | 是否接受控制输入 |
| `faction` | `Faction` | 玩家阵营，枚举值为 `RU`、`UA`、`None` |
| `model_manager` | `PlayerModelManager` | 模型管理子系统引用 |
| `camera_controller` | `PlayerCameraController` | 摄像机控制子系统引用 |
| `ragdoll_system` | `PlayerRagdollSystem` | 布娃娃系统引用 |
| `movement_controller` | `PlayerMovementController` | 移动控制器引用 |
| `collision_controller` | `PlayerCollisionController` | 主环境碰撞体唯一所有者 |
| `ik_rig` | `IKRig` | 双臂握枪 + 双脚贴地 IK |
| `weapon_manager` | `WeaponManager` | 武器管理器引用 |
| `weapon_feedback` | `PlayerWeaponFeedback` | 后坐力分配、换枪接线和携行重量同步 |
| `ui_layer` | `PlayerUILayer` | 本地玩家界面装配层；AI 为空 |
| `animation_controller` | `PlayerAnimationController` | 动画控制器引用 |

`BasePlayer` 同时是玩家子系统的组合根：它负责连接 stance 信号，并通过公开的纯数值接口更新 movement、camera、model 与 collision。在这条姿态/碰撞数据流中，业务组件不互相保存引用；医疗 hitbox 包络以 `Callable -> AABB` 注入碰撞控制器。

## 公开方法（Methods）

### `die() -> void`
将 `is_alive` 设为 `false`，启用布娃娃系统。若玩家已死亡则直接返回。

### `revive() -> void`
将 `is_alive` 设为 `true`，禁用布娃娃系统。若玩家已存活则直接返回。

### `set_controllable(enabled: bool) -> void`
设置 `controllable` 标志并记录日志。切换为 `false` 时会立即调用 `movement_controller.clear_locomotion_state()`，结束冲刺/奔跑并清除步态、Shift 长按和起步爆发等瞬时移动状态，避免菜单或自由视角接管后恢复出旧输入。

### `reload_model() -> void`
热重载模型，重新调用 `model_manager.load_model()`，供 Mod 运行时使用。

## 依赖关系

- **依赖：** `PlayerConfig`、`PlayerModelManager`、`PlayerCameraController`、`PlayerRagdollSystem`、`PlayerMovementController`、`IKRig`、`WeaponManager`、`PlayerAnimationController`、`WeaponObstructionDetector`、`GlobalLogger`
- **被依赖：** 场景树中的具体玩家场景节点；其他需要访问玩家子系统的外部系统

## 注意事项

- `faction_changed` 信号已声明但代码中暂无主动 emit，外部若依赖该信号需自行调用或扩展 setter。
- 模型加载前骨骼和武器挂点可能尚未就绪，组件应通过注入的状态提供者处理这种情况。
- `_on_model_loaded()` 中会将模型从 `ModelManager` 下移到 `BasePlayer` 自身下，以确保变换跟随玩家根节点。
