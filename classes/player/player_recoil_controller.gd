class_name PlayerRecoilController
extends Node

var _player: BasePlayer
var _config: PlayerRecoilConfig
var _skeleton: Skeleton3D
var _weapon: BaseWeapon
var _recoil: RecoilComponent
var _modifier: RecoilBodyModifier


func initialize(player: BasePlayer, config: PlayerRecoilConfig = null) -> void:
	_player = player
	_config = config if is_instance_valid(config) else PlayerRecoilConfig.new()


func setup(skeleton: Skeleton3D) -> void:
	_skeleton = skeleton
	if not is_instance_valid(_skeleton):
		return
	if is_instance_valid(_modifier):
		_modifier.queue_free()
	_modifier = RecoilBodyModifier.new()
	_modifier.name = "RecoilBodyModifier"
	_skeleton.add_child(_modifier)
	_modifier.setup(_recoil, _config)
	_move_before_first_ik()


func set_weapon(weapon: BaseWeapon) -> void:
	_weapon = weapon
	_recoil = weapon.get_node_or_null("RecoilComponent") as RecoilComponent if is_instance_valid(weapon) else null
	if is_instance_valid(_modifier):
		_modifier.set_recoil_component(_recoil)


func process_recoil(active: bool = true) -> void:
	if is_instance_valid(_modifier):
		_modifier.set_enabled(active)


func _move_before_first_ik() -> void:
	for child in _skeleton.get_children():
		if child is TwoBoneIK3D:
			_skeleton.move_child(_modifier, child.get_index())
			return
