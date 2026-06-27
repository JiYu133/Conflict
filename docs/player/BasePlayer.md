# BasePlayer

**文件路径：** `Classes/Player/base_player.gd`
**继承自：** `CharacterBody3D`

## 功能概述

玩家实体的根节点脚本。负责在 `_ready()` 时创建并初始化全部子系统，管理子系统间的信号连接，并对外暴露玩家生命周期（死亡/复活）与可控状态的公开 API。子系统均作为子节点挂载在 BasePlayer 下，通过成员变量引用访问。

## 初始化

`_ready()` 调用 `_initialize_subsystems()`，按以下顺序完成初始化：

1. 创建并添加全部子系统节点（ModelManager、CameraController、RagdollSystem、MovementController、FootIKController、WeaponManager、AnimationController）
2. 依次调用各子系统的 `initialize()` 方法，传入所需依赖
3. 将 `movement_controller` 的落地/起跳信号连接到 `camera_controller`
4. 连接 `model_manager.model_loaded` 与 `weapon_manager.weapon_changed` 信号
5. 若 `player_config.model_scene` 存在，调用 `model_manager.load_model()` 加载模型

模型加载完成后，`_on_model_loaded()` 回调负责：初始化布娃娃系统、动画控制器、查找武器挂载点、创建武器晃动支点、初始化 `WeaponObstructionDetector`，以及装备初始武器。

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
| `foot_ik_controller` | `FootIKController` | 脚部 IK 控制器引用 |
| `weapon_manager` | `WeaponManager` | 武器管理器引用 |
| `animation_controller` | `PlayerAnimationController` | 动画控制器引用 |

## 公开方法（Methods）

### `die() -> void`
将 `is_alive` 设为 `false`，启用布娃娃系统。若玩家已死亡则直接返回。

### `revive() -> void`
将 `is_alive` 设为 `true`，禁用布娃娃系统。若玩家已存活则直接返回。

### `set_controllable(enabled: bool) -> void`
设置 `controllable` 标志并记录日志。

### `reload_model() -> void`
热重载模型，重新调用 `model_manager.load_model()`，供 Mod 运行时使用。

## 依赖关系

- **依赖：** `PlayerConfig`、`PlayerModelManager`、`PlayerCameraController`、`PlayerRagdollSystem`、`PlayerMovementController`、`FootIKController`、`WeaponManager`、`PlayerAnimationController`、`WeaponObstructionDetector`、`GlobalLogger`
- **被依赖：** 场景树中的具体玩家场景节点；其他需要访问玩家子系统的外部系统

## 注意事项

- `faction_changed` 信号已声明但代码中暂无主动 emit，外部若依赖该信号需自行调用或扩展 setter。
- `WeaponObstructionDetector` 是在 `_on_model_loaded()` 内动态创建的，比其他子系统晚一帧初始化，不可在模型加载前访问。
- `_on_model_loaded()` 中会将模型从 `ModelManager` 下移到 `BasePlayer` 自身下，以确保变换跟随玩家根节点。
