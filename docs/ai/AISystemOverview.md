# AI 系统概览

## 核心理念

**AI 不是"敌人脚本"，而是复用玩家实体的另一名参与者。** `AIPlayer` 继承同一个 `BasePlayer`，走同一套 `PlayerMovementController`、`WeaponManager`、`HealthSystem` 和 `PlayerRagdollSystem`。AI 没有专用的移动积分、专用的射击通路或专用的伤害计算——它只是不接受键鼠输入，改由 `AIPlayerBrain` 驱动同样的接口。

这条约束换来两件事：玩家身上任何一次调参（后坐、姿态速度、失血惩罚）自动作用于 AI；反过来，AI 暴露出的物理/医疗缺陷也一定是玩家会遇到的缺陷。

**信息流经黑板，不经节点引用。** 队友之间不互相持有引用、不直接读对方的 `_target`。所有战术信息（发现敌人、遭受火力、请求掩护、撤退命令）都发布到本小队的 `AIBlackboard`，其他成员从黑板读。这让"班组通信"成为可替换的一层，也为将来接入网络留下唯一的收敛点。

## 文件结构

```
classes/bot/
├── ai_player_manager.gd     ← 地图级工厂与注册表：生成/回收/分帧加载
├── ai_player_brain.gd       ← 单个 AI 的状态机与感知-决策-执行循环
├── ai_squad_commander.gd    ← 小队级：选举队长、分配掩护/突击位
├── ai_blackboard.gd         ← 小队共享情报（唯一的通信面）
├── ai_profile.gd            ← 行为参数资源（感知/移动/火控/战术）
├── ai_config.gd             ← 玩法配置包：Profile + 阵营 + 装备
└── limbo/limbo_bot_tick.gd  ← 行为树 tick 适配

classes/player/ai_player.gd  ← BasePlayer 的 AI 特化入口
```

## 分层职责

```text
AIPlayerManager        地图级：谁存在、何时生成、模型分帧加载
        ↓ 持有
AISquadCommander       小队级：队长选举、掩护/突击位分配
        ↓ 读写
AIBlackboard           情报级：敌情、火力、掩护请求、撤退令
        ↑ 读写
AIPlayerBrain          个体级：感知 → 状态机 → 调用 BasePlayer 接口
        ↓ 调用
BasePlayer             与玩家完全相同的移动/武器/医疗实体
```

四层之间只向下调用、向上发布，不跨层反向持有。`AIPlayerBrain` 不知道 `EncounterController` 的存在；它只知道黑板上有没有目标点和撤退令。

## 状态机

`AIPlayerBrain.State` 共 15 个状态：

| 分组 | 状态 | 说明 |
|---|---|---|
| 机动 | `IDLE` / `MOVE_TO_OBJECTIVE` / `PATROL_OBJECTIVE` / `SEARCH` | 无敌情时的推进与巡逻 |
| 交火 | `ENGAGE` / `SUPPRESS` | 直接射击与压制射击 |
| 掩护 | `TAKE_COVER` / `MOVE_UNDER_COVER` | 进入掩体、交替掩护移动 |
| 班组 | `RESCUE` / `RETREAT` / `HOLD_EXTRACTION` | 救援倒地队友、撤退、固守撤离点 |
| 武器 | `RELOAD` / `CLEAR_MALFUNCTION` | 换弹与排障，走玩家同一套接口 |
| 生命 | `DOWNED` / `DEAD` | 由 `HealthSystem` 状态驱动，非 AI 自行决定 |

`DOWNED` 与 `DEAD` 不由决策逻辑进入——它们是 `HealthSystem` 医疗状态的投影。这保证"AI 濒死"和"玩家濒死"是同一套判定，不会出现 AI 靠特殊分支免疫失血的情况。

## 感知

感知不是全知查询，而是三重过滤：

1. **距离** — `perception_distance`（默认 32m）
2. **视野角** — `field_of_view_degrees`（默认 120°），`_within_fov()`
3. **视线** — `_can_see()` 发射线，`_get_visibility_exclusions()` 排除自身碰撞体

三者全部通过才算"看见"。看见之后仍不立即开火：`reaction_time`（默认 0.25s）模拟反应延迟，`sight_check_interval`（0.20s）限制射线频率避免每帧开销。目标离开视野后由 `target_memory_time`（5s）维持记忆，超时才丢失——这是 AI 会朝最后已知位置搜索而不是瞬间遗忘的原因。

命中不是完美的：`aim_error_degrees`（默认 3°）在开火方向上施加锥形误差，`_apply_aim_error()` 每次开火重新采样。

## AIProfile 参数

`AIProfile` 是纯资源，按需在编辑器里派生出"新兵/老兵/精锐"等档位，不需要改代码。

| 分组 | 关键字段 | 作用 |
|---|---|---|
| Perception | `perception_distance` / `field_of_view_degrees` / `reaction_time` / `target_memory_time` / `aggression` | 何时发现、多快反应、记多久 |
| Movement | `move_speed` / `chase_distance` / `replan_interval` / `local_avoidance_distance` / `run_to_objective` / `crouch_in_combat` | 推进方式与重规划频率 |
| Fire Control | `weapon_distance` / `aim_error_degrees` / `burst_length` / `fire_interval` / `minimum_ammo_ratio` | 交火距离、精度与节奏 |
| Team Tactics | 掩护/突击分配相关 | 小队协同行为 |

`minimum_ammo_ratio` 决定 AI 在余弹低于该比例时主动进入 `RELOAD`，而不是打空后被动换弹——这是 AI 看起来"有战术素养"的主要来源之一。

## 导航

`AINavigationService` 是导航外观层，AI 只向它请求路径，不直接操作 `NavigationAgent3D`。地图使用作者手工摆放的 `NavigationRegion3D`。`replan_interval`（0.35s）限制重规划频率；`local_avoidance_distance` 处理近距离绕行，避免小队成员互相卡住。

移动最终仍然写进 `PlayerMovementController`——AI 走的是玩家的加速度、步态波动与转向减速，因此 AI 的移动手感天然与玩家一致。

## 分帧生成

`AIPlayerManager` 支持 `defer_ai_model_load`：一次生成多个 AI 时，模型与装备实例化被排进后续帧，避免同一帧内多套场景树同时构建造成明显卡顿。`BasePlayer.ai_runtime_ready` 信号在该 AI 真正可用时发出。

## 与遭遇战系统的关系

AI 系统本身不定义胜负、目标或撤离。它只消费黑板上的 `objective_position` / `extraction_position` / `retreat_order`。这些值由 [遭遇战系统](../encounter/EncounterSystemOverview.md) 的 `EncounterAIDirector` 写入。

因此可以在没有 `EncounterController` 的场景里单独生成 AI 做射击测试，它们会停留在 `IDLE` / `PATROL_OBJECTIVE`，不会报错。

## 调试

控制台（`` ` `` 键）提供 AI 生成与控制指令；`tests/` 下有 `ai_config_check.gd` 等脚本覆盖配置装载与行为断言。
