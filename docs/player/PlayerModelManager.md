# PlayerModelManager

**文件路径：** `Classes/Player/player_model_manager.gd`  
**继承自：** `Node`

## 功能概述

负责加载和卸载玩家的 3D 模型场景，实例化后自动查找并缓存骨骼系统（Skeleton3D）和动画播放器（AnimationPlayer），同时根据 PlayerConfig 的参数为玩家创建胶囊碰撞体。

## 初始化

该类无独立的 `initialize()` 方法，通过 `load_model(player_config)` 完成初始化：

- **调用时机：** 在 `BasePlayer` 完成自身初始化后调用，通常在 `_ready()` 阶段。
- **参数：** `player_config: PlayerConfig` — 包含 `model_scene`（PackedScene）、`model_config`（ModelLookupConfig）和碰撞体尺寸参数。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `model_loaded` | `model: Node3D` | 模型实例化并添加到场景树后，碰撞体创建前 |
| `model_unloaded` | 无 | 旧模型被 `queue_free()` 并清除缓存后 |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `model_node` | `Node3D` | 当前加载的模型场景根节点（只读） |
| `skeleton` | `Skeleton3D` | 模型中的骨骼系统，用于挂载武器、摄像机等（只读） |
| `animator` | `AnimationPlayer` | 模型中的动画播放器，用于播放行走/奔跑等动画（只读） |

## 公开方法（Methods）

### `load_model(player_config: PlayerConfig) -> void`

从 `PlayerConfig.model_scene` 实例化模型，挂载到父节点（BasePlayer）下，查找骨骼与动画组件，发射 `model_loaded` 信号，最后创建胶囊碰撞体。加载新模型前会先调用 `unload_model()` 安全卸载旧模型。

### `unload_model() -> void`

释放当前模型实例（`queue_free()`），清空 `_model_node`、`_skeleton`、`_animator` 缓存，并发射 `model_unloaded` 信号。

### `find_node_by_names(names: Array, type: String = "") -> Node`

在已加载的模型场景内按候选名称数组进行模糊查找（`find_child`），按数组顺序返回第一个匹配项。可通过 `type` 参数过滤节点类型（如 `"Skeleton3D"`）。

## 依赖关系

- **依赖：**
  - `PlayerConfig` — 提供模型场景路径和碰撞体参数
  - `ModelLookupConfig` — 提供骨骼节点名称和动画节点名称的查找规则
- **被依赖：**
  - `BasePlayer` — 持有该节点并调用 `load_model()`
  - `PlayerAnimationController` — 通过 `model_manager.animator` 获取动画播放器引用
  - `PlayerRagdollSystem` — 通过外部传入的 `skeleton` / `animator` 使用其缓存结果
  - `FootIKController` — 持有 `PlayerModelManager` 引用，监听 `model_loaded` 信号并调用 `find_node_by_names()`

## 注意事项

- 采用"先实例化新模型、验证成功后再卸载旧模型"的顺序，防止新模型失败时玩家变成隐形状态。
- `_create_collision_body()` 在 `model_loaded` 信号发射之后执行，监听该信号的模块（如摄像机）在回调时碰撞体可能尚未就绪。
- 碰撞体的 `position` 固定为 `Vector3.ZERO`，若模型骨骼原点不在角色脚底需要手动偏移。
- 若 `player_config` 为 `null`，会使用默认的 `PlayerConfig.new()` 和 `ModelLookupConfig.new()`，可能导致找不到骨骼或动画，并输出 `push_warning`。
