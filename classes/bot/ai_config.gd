class_name AIConfig
extends Resource

## 可直接导入玩法配置的完整 AIPlayer 配置包。
## 包含角色/武器覆盖、LimboAI 行为树及不同战术情境的参数。

@export_group("Identity")
## Inspector 和调试界面显示的配置名称，例如“新兵”或“老兵”。
@export var config_name: String = "Default AI"
## 配置池未来使用加权随机分配时的权重预留。
@export_range(0.0, 100.0) var selection_weight: float = 1.0

@export_group("AIPlayer")
## 为空时复制当前玩法玩家的 PlayerConfig。
@export var player_config: PlayerConfig
## 可选模型覆盖。
@export var model_scene: PackedScene
## 可选初始武器覆盖；为空时沿用 PlayerConfig 的真实武器。
@export var starting_weapon: WeaponConfig

@export_group("LimboAI")
## 由 BTPlayer 执行的 LimboAI BehaviorTree 资源。
@export var behavior_tree: BehaviorTree

@export_group("Tactical Profiles")
## 无敌情、移动到任务点和巡逻时使用。
@export var calm_profile: AIProfile
## 发现并交战时使用。
@export var combat_profile: AIProfile
## 承担压制任务时使用。
@export var suppress_profile: AIProfile
## 撤退和前往撤离区时使用。
@export var retreat_profile: AIProfile


func get_profile(context: String) -> AIProfile:
	match context:
		"combat":
			if combat_profile:
				return combat_profile
		"suppress":
			if suppress_profile:
				return suppress_profile
		"retreat":
			if retreat_profile:
				return retreat_profile
	return calm_profile


func build_player_config(fallback: PlayerConfig) -> PlayerConfig:
	var source := player_config if player_config else fallback
	var result := source.duplicate(true) as PlayerConfig if source else PlayerConfig.new()
	if model_scene:
		result.model_scene = model_scene
	if starting_weapon:
		result.starting_weapon = starting_weapon
	return result
