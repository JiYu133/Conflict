class_name EncounterConfig
extends Resource

@export_group("Match")
@export var match_duration: float = 600.0
@export var deployment_duration: float = 0.0
@export var objective_control_duration: float = 90.0
@export var extraction_duration: float = 20.0
@export var player_faction: int = 0

@export_group("Zones")
@export var objective_radius: float = 8.0
@export var extraction_radius: float = 5.0
@export var max_medical_distance: float = 2.5
@export var player_spawn_position: Vector3 = Vector3(-20.0, 0.9, 14.0)
@export var player_spawn_yaw_degrees: float = 0.0

@export_group("Forces")
@export var friendly_ai_player_count: int = 3
@export var enemy_ai_player_count: int = 4

## 正式 AIPlayer 配置。每个资源同时打包玩家配置、武器覆盖、行为树和战术参数。
## 配置池非空时按出生序号轮换，可直接组合新兵、普通兵和老兵。
@export_group("AIPlayer")
@export var friendly_ai_config: AIConfig
@export var enemy_ai_config: AIConfig
@export var friendly_ai_configs: Array[AIConfig] = []
@export var enemy_ai_configs: Array[AIConfig] = []

@export_group("Medical")
@export var treatment_duration: float = 2.0
@export var bandage_count: int = 3
@export var tourniquet_count: int = 2
@export var chest_seal_count: int = 2
@export var splint_count: int = 2
@export var morphine_count: int = 2
