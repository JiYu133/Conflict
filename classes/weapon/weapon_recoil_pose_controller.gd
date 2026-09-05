class_name WeaponRecoilPoseController
extends Node

## Applies recoil without changing the authored weapon hierarchy.
## Keeping local transforms intact is important because weapon initialization
## happens before WeaponManager attaches the weapon to the hand mount.

var weapon: BaseWeapon
var recoil_component: RecoilComponent
var recoil_pivot: Node3D
var _pivot_local_origin := Vector3.ZERO
var _fallback_visual_nodes: Array[Node3D] = []
var _last_delta := Transform3D.IDENTITY
var _using_authored_pivot := false
var _initialized := false

func initialize(owner: BaseWeapon, recoil: RecoilComponent) -> void:
	weapon = owner
	recoil_component = recoil
	# Run after authored weapon animation so the physical pose is the final layer.
	process_priority = 100
	_setup_pivot()


func _setup_pivot() -> void:
	if _initialized or not is_instance_valid(weapon):
		return
	recoil_pivot = weapon.find_child("RecoilPivot", true, false) as Node3D
	if recoil_pivot and recoil_pivot != weapon:
		_using_authored_pivot = true
		_pivot_local_origin = recoil_pivot.position
		_initialized = true
		return

	# Fallback: no hierarchy mutation. Apply a local delta around the authored
	# shoulder point to each direct visual node, preserving all attachment data.
	recoil_pivot = Node3D.new()
	recoil_pivot.name = "RecoilPivot"
	weapon.add_child(recoil_pivot)
	_pivot_local_origin = weapon.config.recoil_pivot_local if weapon.config else Vector3(0.0, -0.04, 0.35)
	recoil_pivot.position = _pivot_local_origin

	var keep_names := {
		"RightHandGrip": true,
		"RecoilComponent": true,
		"RecoilPivot": true,
		"WeaponRecoilPoseController": true,
		"BoltComponent": true,
		"AmmoComponent": true,
		"FireControl": true,
		"GasComponent": true,
		"EjectionComponent": true,
		"MalfunctionComponent": true,
		"FXController": true,
		"AttachmentManager": true,
		"WeaponAnimationController": true,
		"WeaponMovingPartsController": true,
	}
	for child in weapon.get_children():
		if keep_names.has(child.name) or not (child is Node3D):
			continue
		_fallback_visual_nodes.append(child as Node3D)
	_initialized = true


func _process(_delta: float) -> void:
	if not _initialized or not is_instance_valid(recoil_component):
		return
	var pose := Transform3D(
		recoil_component.get_pose_rotation(),
		recoil_component.get_pose_translation()
	)
	if _using_authored_pivot:
		if is_instance_valid(recoil_pivot):
			recoil_pivot.transform = Transform3D(
				pose.basis,
				_pivot_local_origin + recoil_component.get_pose_translation()
			)
		return

	var inverse_pivot := Transform3D(Basis.IDENTITY, -_pivot_local_origin)
	var delta := Transform3D(Basis.IDENTITY, _pivot_local_origin) * pose * inverse_pivot
	for node in _fallback_visual_nodes:
		if is_instance_valid(node):
			# Remove only our previous delta, leaving animation/attachment edits intact.
			node.transform = _last_delta.affine_inverse() * node.transform
			node.transform = delta * node.transform
	_last_delta = delta


func reset_pose() -> void:
	if is_instance_valid(recoil_component):
		recoil_component.reset()
	if _using_authored_pivot and is_instance_valid(recoil_pivot):
		recoil_pivot.transform = Transform3D(Basis.IDENTITY, _pivot_local_origin)
	else:
		for node in _fallback_visual_nodes:
			if is_instance_valid(node):
				node.transform = _last_delta.affine_inverse() * node.transform
		_last_delta = Transform3D.IDENTITY


func get_snapshot() -> Dictionary:
	return {
		"pivot_path": str(recoil_pivot.get_path()) if is_instance_valid(recoil_pivot) else "",
		"authored_pivot": _using_authored_pivot,
		"recoil": recoil_component.get_pose_snapshot() if is_instance_valid(recoil_component) else {},
	}
