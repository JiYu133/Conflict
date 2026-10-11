# AI 系统概览

## 核心理念

**AI 不是"敌人脚本"，而是复用玩家实体的另一名参与者。** `AIPlayer` 继承同一个 `BasePlayer`，走同一套 `PlayerMovementController`、`WeaponManager`、`HealthSystem` 和 `PlayerRagdollSystem`。AI 没有专用的移动积分、专用的射击通路或专用的伤害计算——它只是不接受键鼠输入，改由 LimboAI 行为树驱动同样的接口。

这条约束换来两件事：玩家身上任何一次调参（后坐、姿态速度、失血惩罚）自动作用于 AI；反过来，AI 暴露出的物理/医疗缺陷也一定是玩家会遇到的缺陷。

**决策归行为树，执行归 Brain。** LimboAI 行为树决定"做什么"（走、找、打、换弹、撤退）；`AIPlayerBrain` 只负责"怎么做"（感知、寻路、扣扳机），本身不保存任何决策状态。改 AI 行为 = 在 LimboAI 编辑器里改树，不用改代码。

**信息流经黑板，不经节点引用。** 队友之间不互相持有引用、不直接读对方的目标。所有战术信息（发现敌人、遭受火力、请求掩护、撤退命令）都发布到本小队的 `AIBlackboard`，其他成员从黑板读。这让"班组通信"成为可替换的一层，也为将来接入网络留下唯一的收敛点。

## 文件结构

```
classes/bot/
├── ai_player_manager.gd     ← 地图级工厂与注册表：生成/回收/分帧加载
├── ai_player_brain.gd       ← 单个 AI 的感知与执行层（无决策）
├── ai_squad_commander.gd    ← 小队级：选举队长、分配掩护/突击位
├── ai_blackboard.gd         ← 小队共享情报（唯一的通信面）
├── ai_profile.gd            ← 行为参数资源（感知/移动/火控/战术）
├── ai_config.gd             ← 玩法配置包：Profile + 行为树 + 装备
├── aim/
│   ├── ai_aim_provider.gd   ← 瞄准接口（AIAimProvider）
│   └── ai_simple_aim.gd     ← 默认占位瞄准（AISimpleAim）
└── limbo/
    ├── ai_bt.gd             ← 任务共用工具（取 Brain、读坐标变量）
    └── tasks/               ← 自定义 LimboAI 任务（编辑器任务面板可见）

assets/config/ai/trees/ai_default_behavior_tree.tres  ← 默认行为树
tools/build_ai_behavior_tree.gd                       ← 用代码重建默认行为树
classes/player/ai_player.gd                           ← BasePlayer 的 AI 特化入口
```

## 分层职责

```text
AIPlayerManager        地图级：谁存在、何时生成、模型分帧加载
        ↓ 持有
AISquadCommander       小队级：队长选举、掩护/突击位分配
        ↓ 读写
AIBlackboard           情报级：敌情、火力、掩护请求、撤退令
        ↑ 读写
LimboAI 行为树          决策级：每帧从上到下选第一个条件成立的分支
        ↓ 调用
AIPlayerBrain          执行级：感知、寻路、视角、扳机
        ↓ 调用
BasePlayer             与玩家完全相同的移动/武器/医疗实体
```

四层之间只向下调用、向上发布，不跨层反向持有。`AIPlayerBrain` 不知道 `EncounterController` 的存在；它只知道黑板上有没有目标点和撤退令。

## 行为树

根节点是 `BTDynamicSequence`：第一个子任务 **Sense Environment** 每帧刷新感知并把世界状态写进 LimboAI 黑板，第二个子任务 **Decide**（`BTDynamicSelector`）按优先级从上到下选择第一个条件成立的分支。每个分支都是 `BTDynamicSequence`（若干 Check Flag 条件 + 一个动作），所以条件每帧重新检查，一旦不成立，正在执行的动作立即被打断（`_exit` 负责松扳机、停步）。

| 优先级 | 分支 | 条件 | 动作 |
|---|---|---|---|
| 1 | Incapacitated | `is_incapacitated` | 原地不动 |
| 2 | Retreat | `retreat_order` | 到撤离点则驻守，否则冲刺去集结点 |
| 3 | Clear malfunction | `weapon_malfunction` | 排障 |
| 4 | Reload | `needs_reload` | 换弹 |
| 5 | Ordered move | `command_ignores_enemies` | 执行"后撤/去任务点"命令（无视敌人） |
| 6 | React to new target | 看见目标但反应时间未到 | 停下并转向目标 |
| 7 | Suppress | 看见目标 且 被分配压制 | 瞄准 + 开火（suppress 档） |
| 8 | Engage | 看见目标 且 在射程内 | 瞄准 + 开火（combat 档） |
| 9 | Follow squad command | `has_command` | 执行其余小队命令 |
| 10 | Chase | 看见目标（射程外） | 追向目标 |
| 11 | Search | `has_enemy_memory` | 去最后已知位置，超时后遗忘 |
| 12 | Move to objective | 未到任务点 | 跑向任务点 |
| 13 | Patrol (hold) | — | 原地驻守 |

"瞄准 + 开火"是一个 `BTParallel`：**Aim At Target** 每帧通过瞄准接口转向目标，并把"是否已对准"写到黑板变量 `aim_ready`；**Fire At Target** 只在 `aim_ready` 为真时按 Profile 的点射节奏扣扳机。

`Incapacitated` 不由决策逻辑主动进入——它是 `HealthSystem` 医疗状态（死亡/昏迷）的投影。这保证"AI 濒死"和"玩家濒死"是同一套判定。

### 黑板变量

由 `AIPlayerBrain.write_blackboard()` 每帧写入，可直接用于 Check Flag 或 LimboAI 内置的 `BTCheckVar`：

| 类型 | 变量 |
|---|---|
| 目标 | `target`（BasePlayer）、`target_position`、`last_known_enemy_position` |
| 目标状态（bool） | `has_target`、`target_visible`、`target_in_range`、`target_reacted`、`has_enemy_memory` |
| 位置（Vector3） | `objective_position`、`extraction_position`、`rally_position` |
| 战术（bool） | `at_objective`、`at_extraction`、`retreat_order`、`is_suppressing`、`has_command`、`command_ignores_enemies` |
| 自身（bool） | `weapon_malfunction`、`needs_reload`、`is_incapacitated` |
| 瞄准输出 | `aim_ready`（由 Aim At Target 写入） |

### 自定义任务

`classes/bot/limbo/tasks/` 已在项目设置 `limbo_ai/behavior_tree/user_task_dir_1` 中登记，LimboAI 编辑器的任务面板里可直接拖用。

| 任务 | 作用 |
|---|---|
| Sense Environment | 感知 + 写黑板，必须放在根节点第一个 |
| Check Flag | 检查一个 bool 黑板变量（可取反） |
| Move To | 走/跑到某个坐标变量，到达返回 SUCCESS |
| Hold Position | 原地停住，可选朝向某个坐标变量 |
| Aim At Target | 瞄准接口所在的任务，见下一节 |
| Fire At Target | `aim_ready` 时点射 |
| Reload Weapon / Clear Malfunction | 换弹 / 排障 |
| Search Last Known | 搜索最后已知位置 |
| Follow Squad Command | 执行玩家的小队命令 |

任务一律通过 Brain 调用玩家接口：移动走虚拟输入，开火走扳机输入；不要在任务里直接写 `velocity`、生成子弹或调用伤害接口。

## 瞄准接口

瞄准是可替换的一层：`AIAimProvider`（`classes/bot/aim/ai_aim_provider.gd`）。

```gdscript
class_name MyAim
extends AIAimProvider

func update_aim(brain: AIPlayerBrain, target: BasePlayer, profile: AIProfile, delta: float) -> bool:
	# 用 brain.aim_at_direction(dir) 转动视角/身体。
	# 返回 true = 已对准，Fire At Target 才会扣扳机。
	return false
```

| 回调 | 时机 |
|---|---|
| `begin_aim(brain, target)` | 开始瞄准某个目标（含中途换目标） |
| `update_aim(brain, target, profile, delta) -> bool` | 每个物理帧；返回是否已对准 |
| `on_shot_fired(brain)` | 每次扣下扳机后 |
| `end_aim(brain)` | 目标丢失或分支被打断 |

接入方式：在 LimboAI 编辑器选中 "Aim At Target"，把 `aim_provider` 换成你的资源；或者直接用自己的任务替换这个节点，只要同样写 `aim_ready` 即可。每个 AIPlayer 会复制一份 provider，所以实例变量可以存放每个 bot 自己的状态。

Brain 提供的瞄准相关工具：`get_eye_position()`、`get_target_aim_point(actor)`、`get_aim_direction()`（当前指令方向）、`get_muzzle_position()` / `get_muzzle_direction()`（枪管实际朝向）、`aim_at_direction(dir)`。

默认实现 `AISimpleAim` 只是占位：以限定角速度把**枪管**（而不是眼睛）转向目标胸口，叠加 `aim_error_degrees` 的水平随机误差，每开一枪重新随机。它会测量视线与枪管之间的偏差并抵消，因此即使武器姿态让枪管偏离视线也能命中。

## 感知

感知不是全知查询，而是三重过滤：

1. **距离** — `perception_distance`（默认 32m）
2. **视野角** — `field_of_view_degrees`（默认 120°），`within_fov()`
3. **视线** — `can_see()` 从眼睛向目标胸口发射线；射线碰到自己的碰撞体（胶囊、hitbox、布娃娃骨骼、武器）会被记住并跳过

三者全部通过才算"看见"。看见之后仍不立即开火：`reaction_time`（默认 0.25s）期间走 "React to new target" 分支，只转向不开火；`sight_check_interval`（0.20s）限制全量扫描频率。目标离开视野后由 `target_memory_time`（5s）维持记忆，超时才丢失——这是 AI 会朝最后已知位置搜索而不是瞬间遗忘的原因。

高度基准：`BasePlayer` 的原点是胶囊中心（站立时离地约 0.9m），眼睛取原点 +0.6m、胸口取 +0.3m（来自头部/上躯干 hitbox）。

## AIProfile 参数

`AIProfile` 是纯资源，按需在编辑器里派生出"新兵/老兵/精锐"等档位，不需要改代码。任务通过 `profile_context`（calm / combat / suppress / retreat）选择用哪一档。

| 分组 | 关键字段 | 作用 |
|---|---|---|
| Perception | `perception_distance` / `field_of_view_degrees` / `reaction_time` / `target_memory_time` / `aggression` | 何时发现、多快反应、记多久 |
| Movement | `chase_distance` / `replan_interval` / `local_avoidance_distance` / `run_to_objective` / `crouch_in_combat` | 推进方式与重规划频率 |
| Fire Control | `weapon_distance` / `aim_error_degrees` / `burst_length` / `fire_interval` / `minimum_ammo_ratio` | 交火距离、精度与节奏 |
| Team Tactics | 掩护/突击分配相关、`search_duration` | 小队协同行为 |

`minimum_ammo_ratio` 决定 AI 在余弹低于该比例时主动换弹，而不是打空后被动换弹。

## 导航

`AINavigationService` 是导航外观层，AI 只向它请求方向，不直接操作 `NavigationAgent3D`。地图使用作者手工摆放的 `NavigationRegion3D`；没有导航网格的地图（如 TestMap）退化为直线 + 近距离射线避障。`replan_interval`（0.35s）限制重规划频率；`local_avoidance_distance` 处理近距离绕行，避免小队成员互相卡住。

移动最终仍然写进 `PlayerMovementController`——AI 走的是玩家的加速度、步态波动与转向减速，因此 AI 的移动手感天然与玩家一致。

## 分帧生成

`AIPlayerManager` 支持 `defer_ai_model_load`：一次生成多个 AI 时，模型与装备实例化被排进后续帧，避免同一帧内多套场景树同时构建造成明显卡顿。`BasePlayer.ai_runtime_ready` 信号在该 AI 真正可用时发出。

## 与遭遇战系统的关系

AI 系统本身不定义胜负、目标或撤离。它只消费黑板上的 `objective_position` / `extraction_position` / `retreat_order`。这些值由 [遭遇战系统](../encounter/EncounterSystemOverview.md) 的 `EncounterAIDirector` 写入。

没有 `EncounterController` 的场景里，Brain 会把 `AIPlayerManager` 里的所有 AIPlayer 和玩家当作可感知对象，因此可以单独生成 AI 做射击测试。

## 测试与调试

- `tests/ai_behavior_check.tscn` — 真实 AIPlayer 端到端：瞄准接口未对准时不开火；两个 bot 从感知距离外出发，走向任务点、发现、瞄准、开火并命中。
- `tests/ai_aim_check.tscn` — 视角/身体/脊柱/枪口的一致性。

```text
godot --headless --path . --fixed-fps 60 tests/ai_behavior_check.tscn
```

运行时可在 LimboAI 的调试面板查看每个 bot 的行为树状态；`AIPlayerBrain.activity` 记录最近启动的动作名。控制台（`` ` `` 键）提供 AI 生成与控制指令。
