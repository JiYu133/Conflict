class_name BotConfig
extends Resource

## Optional overrides for bots. All resources are copied before being assigned
## to a bot, so the player's shared configuration is never mutated at runtime.
@export var player_config: PlayerConfig
@export var model_scene: PackedScene
@export var starting_weapon: WeaponConfig


func build_player_config(fallback: PlayerConfig) -> PlayerConfig:
	var source := player_config if player_config else fallback
	var result: PlayerConfig = PlayerConfig.new()
	if source:
		result = source.duplicate(true) as PlayerConfig
	if model_scene:
		result.model_scene = model_scene
	if starting_weapon:
		result.starting_weapon = starting_weapon
	return result
