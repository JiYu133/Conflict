class_name AINavigationService
extends Node

## Navigation facade used by AIPlayerBrain. Authored NavigationRegion3D maps are
## preferred. If a map has none, the service safely falls back to a short ray
## and CharacterBody3D collision movement; it never uses the debug test-motion
## bridge as an AI API.

@export var agent_radius: float = 0.45
@export var agent_height: float = 1.8
@export var max_slope_degrees: float = 45.0
@export var max_step_height: float = 0.5
@export var local_avoidance_distance: float = 1.5

var _agents: Dictionary = {}


func get_direction(bot: BasePlayer, destination: Vector3, delta: float, replan_interval: float) -> Vector3:
	if not bot:
		return Vector3.ZERO
	var key := bot.get_instance_id()
	var record: Dictionary = _agents.get(key, {})
	var agent: NavigationAgent3D = record.get("agent", null)
	var timer := float(record.get("timer", 0.0)) - delta
	if not agent:
		agent = NavigationAgent3D.new()
		agent.name = "Agent_%d" % key
		agent.path_height_offset = 0.0
		agent.path_desired_distance = 0.6
		agent.target_desired_distance = 1.0
		agent.radius = agent_radius
		agent.height = agent_height
		agent.avoidance_enabled = true
		agent.neighbor_distance = maxf(local_avoidance_distance, 0.5)
		# NavigationAgent3D is a Node rather than a Node3D. Parent it to the
		# moving AIPlayer so the navigation server receives the AIPlayer's transform.
		bot.add_child(agent)
		record = {"agent": agent, "timer": 0.0, "target": destination}
		timer = 0.0
	var current_target: Vector3 = record.get("target", destination)
	if timer <= 0.0 or current_target.distance_to(destination) > 0.5:
		agent.target_position = destination
		record["target"] = destination
		timer = maxf(replan_interval, 0.05)
	record["timer"] = timer
	_agents[key] = record
	var next := agent.get_next_path_position()
	var direction := next - bot.global_position
	direction.y = 0.0
	if direction.length_squared() < 0.04:
		direction = destination - bot.global_position
		direction.y = 0.0
	if direction.length_squared() <= 0.04:
		return Vector3.ZERO
	return _avoid_local_obstacle(bot, direction.normalized())


func forget(bot: BasePlayer) -> void:
	if not bot:
		return
	var key := bot.get_instance_id()
	var record: Dictionary = _agents.get(key, {})
	var agent: NavigationAgent3D = record.get("agent", null)
	if agent:
		agent.queue_free()
	_agents.erase(key)


func _avoid_local_obstacle(bot: BasePlayer, direction: Vector3) -> Vector3:
	var world := bot.get_world_3d()
	if not world:
		return direction
	var origin := bot.global_position + Vector3.UP * 0.8
	var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * local_avoidance_distance, 1)
	query.exclude = [bot.get_rid()]
	var hit := world.direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return direction
	var left := Vector3(-direction.z, 0.0, direction.x)
	return left.normalized() if left.length_squared() > 0.01 else direction
