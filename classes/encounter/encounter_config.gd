class_name EncounterConfig
extends Resource

@export_group("Match")
## Match total duration in seconds.
@export var match_duration: float = 600.0
## Deployment phase duration in seconds.
@export var deployment_duration: float = 0.0
## Required continuous objective-control time in seconds.
@export var objective_control_duration: float = 90.0
## Extraction phase duration in seconds.
@export var extraction_duration: float = 20.0
## Faction index assigned to the player team.
@export var player_faction: int = 0

@export_group("Zones")
## Objective capture radius in metres.
@export var objective_radius: float = 8.0
## Extraction zone radius in metres.
@export var extraction_radius: float = 5.0
## Maximum distance for medical treatment in metres.
@export var max_medical_distance: float = 2.5
## Player spawn position in world space.
@export var player_spawn_position: Vector3 = Vector3(-20.0, 0.9, 14.0)
## Player spawn yaw in degrees.
@export var player_spawn_yaw_degrees: float = 0.0

@export_group("Forces")
## Number of friendly AI players spawned for the encounter.
@export var friendly_ai_player_count: int = 3
## Number of enemy AI players spawned for the encounter.
@export var enemy_ai_player_count: int = 4

## 正式 AIPlayer 配置。每个资源同时打包玩家配置、武器覆盖、行为树和战术参数。
## 配置池非空时按出生序号轮换，可直接组合新兵、普通兵和老兵。
@export_group("AIPlayer")
## Fallback configuration for friendly AI players.
@export var friendly_ai_config: AIConfig
## Fallback configuration for enemy AI players.
@export var enemy_ai_config: AIConfig
## Optional friendly AI configuration pool, cycled by spawn order.
@export var friendly_ai_configs: Array[AIConfig] = []
## Optional enemy AI configuration pool, cycled by spawn order.
@export var enemy_ai_configs: Array[AIConfig] = []

@export_group("Medical")
## Treatment interaction duration in seconds.
@export var treatment_duration: float = 2.0
## Number of bandage items available per encounter.
@export var bandage_count: int = 3
## Number of tourniquets available per encounter.
@export var tourniquet_count: int = 2
## Number of chest seals available per encounter.
@export var chest_seal_count: int = 2
## Number of splints available per encounter.
@export var splint_count: int = 2
## Number of morphine doses available per encounter.
@export var morphine_count: int = 2
