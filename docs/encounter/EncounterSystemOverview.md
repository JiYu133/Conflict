# 遭遇战系统概览

## 核心理念

**规则是纯数据对象，场景只是它的显示层。** `EncounterRules` 是 `RefCounted`，不继承 `Node`、不进场景树、不认识任何 3D 节点。它只接收"谁在目标区内、现在几点"，输出状态与信号。`EncounterController` 才是场景里的那一层，负责把 `EncounterZone` 的进出事件喂给规则，并把规则发出的信号转给 HUD 和 AI。

这样拆的直接收益：对局规则可以在无场景的测试里逐帧推进（见 `tests/encounter_rules_check.gd`），不需要实例化地图、玩家或 AI。

**撤离不是终点，是决策点。** 参照《Conflict》开发大纲，任务完成后对局不立即结束——撤离窗口开启，玩家可以选择继续作战或撤离，这两种选择通向不同的结算结果。

## 文件结构

```
classes/encounter/
├── encounter_rules.gd         ← 纯规则状态机（RefCounted，无场景依赖）
├── encounter_controller.gd    ← 场景层：接线 Zone / HUD / AI
├── encounter_config.gd        ← 对局参数资源
├── encounter_zone.gd          ← 目标点/撤离点区域（Area3D）
├── encounter_ai_director.gd   ← 把对局状态写进 AI 黑板
├── encounter_hud.gd           ← 对局状态显示
├── encounter_prototype.gd     ← 原型场景装配
└── medical_treatment_component.gd  ← 队友互救（拖曳/止血/唤醒）
```

## 对局状态机

`EncounterRules.MatchState`：

```text
DEPLOYMENT ──→ ACTIVE ──→ OBJECTIVE_SECURED ──→ EXTRACTION_OPEN
                  │                                    │
                  │                                    ├──→ MATCH_SUCCESS
                  ├──→ MATCH_FAILED                    └──→ MATCH_PARTIAL_SUCCESS
                  │    （全队阵亡）
                  └──→ MATCH_FAILED
                       （超时且无人撤离）
```

| 状态 | 含义 |
|---|---|
| `DEPLOYMENT` | 部署准备阶段，`deployment_duration` 为 0 时直接跳过 |
| `ACTIVE` | 对局进行中，计时开始 |
| `OBJECTIVE_SECURED` | 目标点控制满 `objective_control_duration` |
| `EXTRACTION_OPEN` | 撤离窗口开启 |
| `MATCH_SUCCESS` | 任务完成 + 有人撤离 |
| `MATCH_PARTIAL_SUCCESS` | 时间耗尽 + 有人撤离 |
| `MATCH_FAILED` | 全队阵亡，或超时且无人撤离 |

## 目标点控制

`ObjectiveState` 独立于对局状态：`UNCONTROLLED` / `CONTESTED` / `RU_CONTROLLED` / `UA_CONTROLLED` / `SECURED`。

区内同时存在双方成员时进入 `CONTESTED`，控制进度停滞而非清零。只有单方独占才继续累计，累计满 `objective_control_duration`（默认 90s）后转 `SECURED`。`objective_progress_changed(progress, control_faction, objective_state)` 每次变化时发出，HUD 直接消费这一个信号即可，无需自行轮询。

## EncounterConfig

| 分组 | 字段 | 默认 | 说明 |
|---|---|---|---|
| Match | `match_duration` | 600.0 | 对局总时长（秒），超时强制结算 |
| Match | `deployment_duration` | 0.0 | 部署阶段时长；0 = 跳过 |
| Match | `objective_control_duration` | 90.0 | 目标点控制满多久算 `SECURED` |
| Match | `extraction_duration` | 20.0 | 在撤离区停留多久算撤离成功 |
| Match | `player_faction` | 0 | 玩家所属阵营 |
| Zones | `objective_radius` | 8.0 | 目标区半径 |
| Zones | `extraction_radius` | 5.0 | 撤离区半径 |
| Zones | `max_medical_distance` | 2.5 | 队友互救的最大距离 |
| Zones | `player_spawn_position` / `player_spawn_yaw_degrees` | — | 玩家出生点与朝向 |

区域半径同时写入 `EncounterZone.set_radius()`，`Area3D` 的碰撞形状据此重建——半径只有一个真值来源，不会出现配置与碰撞体不一致。

## 与 AI 系统的接线

`EncounterAIDirector` 是遭遇战与 [AI 系统](../ai/AISystemOverview.md) 之间唯一的桥：

```text
EncounterRules（对局状态）
        ↓ 信号
EncounterAIDirector
        ↓ 写入
AIBlackboard.objective_position / extraction_position / retreat_order
        ↑ 读取
AIPlayerBrain
```

方向是单向的。AI 从不回写对局状态；它对目标点的"贡献"只体现为它站在 `EncounterZone` 里，由 `EncounterController` 统一上报。这避免了"AI 自己宣布占领了目标点"这类越权。

## 队友互救

`MedicalTreatmentComponent` 实现开发大纲中"仅队友可执行"的那部分急救动作。距离由 `max_medical_distance`（2.5m）限制，治疗过程通过 `BasePlayer.CONTROL_LOCK_MEDICAL` 持有控制锁——施救者在动作期间让出移动控制权，与暂停菜单、自由视角使用同一套 `PlayerControlState` 仲裁，不会互相覆盖。

## 测试

`tests/encounter_rules_check.gd` 直接实例化 `EncounterRules` 并手动推进时间，验证状态迁移与结算分支。因为规则层没有场景依赖，这些断言不需要跑起整张地图。
