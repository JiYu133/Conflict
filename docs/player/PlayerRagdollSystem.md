# PlayerRagdollSystem

**文件路径：** `Classes/Player/player_ragdoll_system.gd`  
**继承自：** `Node`

## 功能概述

管理玩家的布娃娃（ragdoll）物理效果，通过启停 `PhysicalBoneSimulator3D` 或 `Skeleton3D` 的物理骨骼模拟，在动画驱动与物理驱动之间切换，适用于死亡倒地等需要真实物理响应的场景。

## 初始化

### `initialize(skeleton: Skeleton3D, animator: AnimationPlayer = null) -> void`

- **调用时机：** 在 `BasePlayer` 加载模型后（通常在 `model_loaded` 信号回调内）调用。
- **参数：**
  - `skeleton` — 来自 `PlayerModelManager.skeleton` 的骨骼系统引用。
  - `animator` — 可选，来自 `PlayerModelManager.animator`，用于在布娃娃停用时恢复动画播放。
- 初始化时会自动在骨骼父节点下查找 `PhysicalBoneSimulator3D` 子节点并缓存。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `ragdoll_enabled` | 无 | 布娃娃物理模拟成功启动后 |
| `ragdoll_disabled` | 无 | 布娃娃物理模拟停止、动画系统恢复后 |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `is_active` | `bool` | 当前布娃娃是否处于激活状态（只读） |

## 公开方法（Methods）

### `enable() -> void`

激活布娃娃：停止并禁用 `AnimationPlayer`，启动物理骨骼模拟，发射 `ragdoll_enabled` 信号。若已激活或骨骼为空则提前返回。

### `disable() -> void`

停用布娃娃：停止物理骨骼模拟，重新启用 `AnimationPlayer`，发射 `ragdoll_disabled` 信号。

## 依赖关系

- **依赖：**
  - `Skeleton3D` — 骨骼系统，布娃娃的核心驱动对象
  - `AnimationPlayer` — 布娃娃停用时需要恢复动画
  - `PhysicalBoneSimulator3D` — Godot 4.x 的物理骨骼模拟器节点（自动查找）
- **被依赖：**
  - `BasePlayer` — 在玩家死亡时调用 `enable()`，复活时调用 `disable()`

## 注意事项

- 物理模拟器查找采用降级策略：优先使用 `PhysicalBoneSimulator3D`，若找不到则回退到 `Skeleton3D` 自身的方法，两者均不可用时输出 `push_error` 并中止激活。
- `disable()` 后目前仅恢复了 `AnimationPlayer.active = true`，**尚未实现**从布娃娃姿态过渡回站立动画（代码中标注了 `TODO`）。
- 重复调用 `enable()` / `disable()` 有幂等保护（通过 `_is_active` 标志）。
