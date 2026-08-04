# PlayerRagdollSystem

**文件路径：** `classes/player/player_ragdoll_system.gd`
**继承自：** `Node`

## 功能概述

管理玩家从死亡动画到布娃娃物理、再到复活恢复的完整流程。系统不会采用模型场景中预制的物理骨骼作为运行时布娃娃，而是在首次死亡时依据 `Skeleton3D` 与 `RagdollConfig` 惰性创建自己的 `PhysicalBoneSimulator3D`、物理骨骼、关节和碰撞体。

## 阶段与死亡类型

`RagdollPhase` 表示当前阶段：

| 值 | 含义 |
|---|---|
| `INACTIVE` | 正常动画驱动状态 |
| `DEATH_ANIMATION` | 死亡动画或动画到物理的等待阶段 |
| `RAGDOLL_PHYSICS` | 物理骨骼正在模拟 |

`DeathType` 支持 `FRONT`、`BACK`、`RIGHT`、`FRONT_HEADSHOT`、`BACK_HEADSHOT`、`CROUCHING_HEADSHOT`、`EXPLOSION` 和 `GENERIC`。类型用于选择死亡动画、默认冲击方向和冲击力倍率；调用方也可以传入明确的世界空间冲击方向。

## 初始化

### `initialize(skeleton, animator, animation_tree, config, weapon_mount) -> void`

| 参数 | 类型 | 说明 |
|---|---|---|
| `skeleton` | `Skeleton3D` | 创建物理骨骼、保存和恢复姿态的目标骨架；缺失时禁用功能并记录警告 |
| `animator` | `AnimationPlayer` | 可选，按死亡类型播放死亡动画 |
| `animation_tree` | `AnimationTree` | 可选，死亡时停用，复活时恢复 |
| `config` | `RagdollConfig` | 可选；为空时创建默认配置 |
| `weapon_mount` | `Node3D` | 可选；进入物理阶段时隐藏，复活时显示 |

重复初始化会停止并释放上一个由本系统动态创建的模拟器，清除旧模型的物理骨骼、姿态、第一人称网格和阶段缓存。初始化还会收集使用渲染 layer 2 的第一人称隐藏网格，并处理模型内预制的物理模拟器。

## 信号

| 信号 | 参数 | 触发时机 |
|---|---|---|
| `ragdoll_enabled` | — | 死亡流程已启动；此时可能仍处于死亡动画阶段 |
| `death_animation_started` | `anim_name: String` | 找到并开始播放对应死亡动画后 |
| `ragdoll_physics_started` | — | 物理模拟真正启动后 |
| `ragdoll_disabled` | — | 物理或死亡动画停止，姿态与动画系统恢复后 |

## 只读状态

| 属性 | 类型 | 说明 |
|---|---|---|
| `is_active` | `bool` | 死亡流程是否已激活 |
| `current_phase` | `RagdollPhase` | 当前动画/物理阶段 |

## 公开方法

### `enable(death_type = GENERIC, impact_direction = Vector3.ZERO) -> void`

按以下顺序启动死亡流程：

1. 首次调用时创建运行时物理骨骼。
2. 清除稳定 IK 留下的持久骨骼覆盖，并保存当前骨骼姿态供复活恢复。
3. 停用 `AnimationTree`。
4. 若 `play_death_animation` 已启用且目标动画存在，播放动画并等待 `death_anim_to_ragdoll_time`；否则立即进入物理阶段。
5. 进入物理阶段时隐藏武器、调整第一人称网格渲染层、启动模拟并施加冲击力。

重复激活或缺少骨架时直接返回。`ragdoll_enabled` 表示整个序列开始，不能当作“物理已经开始”；需要后者时监听 `ragdoll_physics_started`。

### `disable() -> void`

物理阶段会停止模拟，死亡动画阶段会停止动画。随后恢复死亡前保存的骨骼姿态，重新启用 `AnimationPlayer` 和 `AnimationTree`，显示武器，把第一人称网格恢复到 layer 1+2，并回到 `INACTIVE`。

### `set_weapon_mount(weapon_mount: Node3D) -> void`

更新需要在物理阶段隐藏的武器挂载点。模型加载时可能先初始化布娃娃、后找到挂载点，因此提供独立设置入口。

## 运行时物理骨骼生成

- 排除名称命中 `RagdollConfig.exclude_bone_keywords`、没有有效子段或段长小于 `0.001 m` 的骨骼。
- 头部使用球形碰撞体，其余有效骨骼使用胶囊体；头、躯干、骨盆和普通肢体分别使用对应配置半径。
- 无有效物理父级的骨骼不创建关节，其余使用带角度限制的 Cone 关节，避免肢体无限折叠。
- 质量、线性阻尼和角阻尼支持按骨骼名称覆盖；碰撞层和遮罩来自 `RagdollConfig`。
- 启用自碰撞时，仅为同骨、两代以内的祖先/后代以及拥有同一物理父级的近邻骨骼添加碰撞例外；远端肢体仍可互相碰撞。
- 冲击力优先施加到上半身关键词匹配的骨骼；爆炸和爆头使用各自的配置倍率。

## 模型内预制物理骨骼

测试模型 `res/models/player/test_model/swat.tscn` 包含一个编辑器生成的 `PhysicalBoneSimulator3D` 和 21 个主要身体物理骨骼，便于在编辑器中检查骨骼映射、关节和碰撞形状。它**不是**运行时布娃娃的数据源。

`initialize()` 会递归查找骨架下除当前运行时模拟器以外的预制模拟器。如果预制模拟器正在运行，系统会停止模拟、将其设为 inactive，并把其中所有 `PhysicalBone3D` 的 collision layer/mask 清零，防止它与正常玩家胶囊体或动态布娃娃互相推动。当前实现只在 `is_simulating_physics()` 为 `true` 时执行这组停用和清层操作。

## 配置依赖

`RagdollConfig` 提供以下参数组：

- 物理骨骼半径、头/躯干/骨盆半径、质量与阻尼；
- 是否启用自碰撞；
- 是否播放死亡动画及动画到物理的等待时间；
- 默认、爆头和爆炸冲击力与持续帧数；
- 布娃娃碰撞 layer/mask；
- 排除骨骼关键词、上半身冲击目标关键词；
- 按骨骼名称覆盖质量和阻尼的字典。

## 注意事项

- 运行时依赖 Godot 4 的 `PhysicalBoneSimulator3D` API，不存在回退到旧 `Skeleton3D` 物理方法的路径。
- `disable()` 会直接还原死亡前保存的骨骼姿态；当前没有从倒地姿势平滑起身的过渡动画。
- 重复调用 `enable()` / `disable()` 有幂等保护。
- 模型热重载时必须重新调用 `initialize()`，使系统释放属于旧骨架的运行时节点和缓存。
