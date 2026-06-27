# FootIKController

**文件路径：** `Classes/Player/foot_ik_controller.gd`  
**继承自：** `Node`

## 功能概述

管理玩家双脚的 IK（反向运动学）地面适配，通过在左右脚位置各设置一条向下的 `RayCast3D` 射线检测地面碰撞信息，供上层系统调整脚部骨骼位置，使角色在不平整地形上站立更自然。

## 初始化

### `initialize(model_manager: PlayerModelManager, config: ModelLookupConfig) -> void`

- **调用时机：** 在 `BasePlayer` 完成模型加载后调用，需保证 `PlayerModelManager` 已执行过 `load_model()`。
- **参数：**
  - `model_manager` — 持有骨骼引用并提供 `find_node_by_names()` 能力。
  - `config` — `ModelLookupConfig` 资源，提供 `left_foot_ray_names` 和 `right_foot_ray_names` 候选名称列表。
- 初始化后立即监听 `model_manager.model_loaded` 信号，以便在模型热重载时自动重新搜索射线节点。

## 信号（Signals）

该类无公开信号。

## 公开属性（Properties）

该类无公开属性。

## 公开方法（Methods）

### `get_ground_info() -> Dictionary`

返回双脚的地面碰撞信息，结构如下：

```gdscript
{
    "left":  { "colliding": bool, "point": Vector3, "normal": Vector3 },
    "right": { "colliding": bool, "point": Vector3, "normal": Vector3 }
}
```

若对应射线节点不存在或未碰撞，则 `colliding` 为 `false`，`point` 和 `normal` 返回默认值（`Vector3.ZERO` / `Vector3.UP`）。

### `process_ik(delta: float) -> void`

每帧处理脚部 IK 调整。**当前为空实现（TODO）**，预计使用 `SkeletonIK3D` 或手动骨骼变换实现。

## 依赖关系

- **依赖：**
  - `PlayerModelManager` — 获取骨骼引用，监听 `model_loaded` 信号，调用 `find_node_by_names()`
  - `ModelLookupConfig` — 提供脚部射线节点的候选名称列表
  - `RayCast3D` — 从模型场景中查找或自动创建的脚部检测射线
- **被依赖：**
  - `BasePlayer` 或上层移动系统 — 调用 `get_ground_info()` 和 `process_ik()` 来执行地面适配

## 注意事项

- 若模型场景内未预设射线节点，会尝试通过 `_create_rays_from_skeleton()` 从骨骼自动创建，但该方法**目前也是空实现（TODO）**，意味着找不到预设节点时 IK 功能将静默失效。
- `ModelLookupConfig` 中的 `left_foot_ray_names` / `right_foot_ray_names` 需要与模型场景内实际节点名称对应，否则查找失败。
- `process_ik()` 目前不产生任何效果，整个 IK 调整功能尚处于骨架阶段。
