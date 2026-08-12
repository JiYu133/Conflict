# AIPlayer 配置

AIPlayer 的玩法配置分为三层：`EncounterConfig` 选择阵营配置池，
`AIConfig` 打包角色、武器、LimboAI 行为树和情境参数，`AIProfile`
保存可复用的数值参数。运行一场默认遭遇战所需的资源已随项目提供，
不需要额外新建资源。

## 可直接使用的默认资源

- `assets/config/encounter/encounter_default.tres`：默认玩法配置。
- `assets/config/ai/ai_recruit.tres`：新兵。
- `assets/config/ai/ai_friendly_regular.tres`：友方普通兵。
- `assets/config/ai/ai_enemy_regular.tres`：敌方普通兵。
- `assets/config/ai/ai_veteran.tres`：老兵。
- `assets/config/ai/trees/ai_default_behavior_tree.tres`：默认 LimboAI 行为树。
- `assets/config/ai/profiles/`：上述配置引用的参数资源。

默认玩法已经把友方池设为“新兵、友方普通兵、老兵”，敌方池设为
“新兵、敌方普通兵、老兵”。因此首先只要在 Inspector 打开
`encounter_default.tres`，确认这两个数组没有丢失资源引用，即可运行。

## 新建一套配置

1. 复制一个最接近目标的 `AIProfile`，例如把 `ai_recruit_profile.tres`
   复制为 `ai_assault_profile.tres`，并在 Inspector 调整感知、反应、瞄准、
   点射、跑步、蹲伏、压制和撤退阈值。
2. 复制 `ai_friendly_regular.tres` 或 `ai_enemy_regular.tres` 为新的
   `AIConfig`。给它设置显示名称，并把四个情境 Profile 指向所需资源。
   同一 Profile 可以复用在多个情境；需要战斗和撤退明显不同才拆分。
3. 为 `behavior_tree` 指定 LimboAI `BehaviorTree` 资源。新配置可直接复用
   `ai_default_behavior_tree.tres`；只有需要改变决策结构时才复制并编辑它。
4. 在 `EncounterConfig` 的 `friendly_ai_configs` 或 `enemy_ai_configs`
   添加新的 `AIConfig`。数组按出生序号轮换；单个
   `friendly_ai_config` / `enemy_ai_config` 是数组为空时的后备配置。

`player_config`、`model_scene` 和 `starting_weapon` 是可选覆盖。留空时，
AIPlayer 会复制本局玩家的角色与真实武器配置；设置它们才用于创建兵种差异。

```gdscript
@export var friendly_ai_config: AIConfig
@export var enemy_ai_config: AIConfig
@export var friendly_ai_configs: Array[AIConfig]
@export var enemy_ai_configs: Array[AIConfig]
```

在 Inspector 中把 `assets/config/ai/ai_recruit.tres`、
`ai_friendly_regular.tres`、`ai_enemy_regular.tres` 或 `ai_veteran.tres`
拖入单个字段即可让全队使用一套配置。把资源放入数组后，AIPlayer 按出生序号轮换配置；因此可以直接组合新兵、普通兵和老兵。`selection_weight` 是配置池的权重预留字段，当前数组顺序是确定的，便于复现测试。

每个 `AIConfig` 包含：

- `player_config`、`model_scene` 和 `starting_weapon`：为空时复制玩法玩家的真实配置。
- `behavior_tree`：LimboAI 的 `BehaviorTree` 资源。
- `calm_profile`、`combat_profile`、`suppress_profile`、`retreat_profile`：不同情境的 `AIProfile` 参数。

## LimboAI 行为树

打开 `assets/config/ai/trees/ai_default_behavior_tree.tres`，用 LimboAI 编辑器替换根任务或建立子树，然后把保存后的资源赋给某个 `AIConfig.behavior_tree`。运行时 `AIPlayerManager` 创建 AIPlayer，`EncounterAIDirector` 将该资源交给 AIPlayer 的 `BTPlayer` 执行。

行为树任务通过 AIPlayer 的 `ai_player_brain` 元数据取得执行对象。移动必须调用 AIPlayer 的虚拟输入，开火必须调用武器扳机输入；不要在任务中直接写 `velocity`、生成子弹或调用伤害接口。

`AIProfile` 中的感知、反应、记忆、射击、弹药、跑步、撤退冲刺和蹲伏字段都会在运行时生效。医疗互助暂未接入行为树。

## 关卡资源

当前原型关卡自动使用 `EncounterPrototype` 中的出生点、任务点和撤离点坐标；
这些位置尚未接入场景 Marker。因此现在运行默认玩法不需要准备 Spawn、
Objective 或 Extraction Marker。若后续改为 Marker 驱动，需要在玩法配置
增加对应 NodePath 或在地图中约定 Marker 节点名，并由 EncounterPrototype
读取它们；在此之前，单独放置 Marker 不会影响出生和目标位置。

## 控制台

控制台里的 `bot` 是玩家实体操作命令，不是代码中的 AIPlayer 类型名。正式玩法代码使用 `AIPlayer`、`AIConfig`、`AIPlayerManager`、`AIPlayerBrain` 和 `EncounterAIDirector`。

可对已经创建的实体热加载决策配置：

```text
bot config 3 res://assets/config/ai/ai_veteran.tres
bot config all res://assets/config/ai/ai_recruit.tres
```

该命令会替换 AIProfile 和 LimboAI BehaviorTree，并保留当前的生命状态、
弹药、已装备武器和世界位置。`player_config`、`model_scene`、
`starting_weapon` 是 AIPlayer 创建时的实体配置；如需让这些覆盖生效，使用
目标 AIConfig 重新创建该实体。
