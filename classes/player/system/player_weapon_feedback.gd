class_name PlayerWeaponFeedback
extends Node
## 武器 → 玩家侧反馈：后坐力学分发、换枪时的 IK/相机绑定、负重同步。
##
## 为什么独立成组件（问题清单 R3：上帝对象分步抽取）：
## 这三件事共用同一组依赖（ForceReceiver / IKRig / PlayerCameraController /
## StaminaSystem / WeaponManager），并且**没有任何一处需要回头读玩家核心的状态或方法**
## —— 因此它能作为一个「不反向依赖玩家」的组件成立，而不是把代码换个地方放。
##
## 边界说明：唯一的玩家生命周期判断（布娃娃期间忽略后坐力）留在 `BasePlayer.apply_weapon_recoil()`
## 里做守卫，因为那是玩家自己的状态，不该让力学组件去反查玩家。
##
## 本组件不持有玩家引用，也不调用玩家核心的任何方法。

var _force_receiver: ForceReceiver
var _ik_rig: IKRig
var _camera_controller: PlayerCameraController
var _stamina_system: StaminaSystem
var _weapon_manager: WeaponManager


func initialize(
	force_receiver: ForceReceiver,
	ik_rig: IKRig,
	camera_controller: PlayerCameraController,
	stamina_system: StaminaSystem,
	weapon_manager: WeaponManager
) -> void:
	_force_receiver = force_receiver
	_ik_rig = ik_rig
	_camera_controller = camera_controller
	_stamina_system = stamina_system
	_weapon_manager = weapon_manager
	assert(
		is_instance_valid(_force_receiver) and is_instance_valid(_ik_rig)
		and is_instance_valid(_camera_controller) and is_instance_valid(_stamina_system)
		and is_instance_valid(_weapon_manager),
		"[Player 装配顺序] PlayerWeaponFeedback 需要 ForceReceiver / IKRig / CameraController / StaminaSystem / WeaponManager 先就绪。"
	)


## Distribute one weapon recoil wrench over the active stock and hand contacts.
func apply_recoil(weapon: BaseWeapon, recoil_data: Dictionary) -> void:
	if not is_instance_valid(weapon) or not _force_receiver:
		return
	var model: RecoilPhysicsModel = weapon.recoil_component.physics_model if weapon.recoil_component else null
	if not model:
		return
	var local_linear: Vector3 = recoil_data.get("linear_impulse_local", Vector3.ZERO)
	var local_angular: Vector3 = recoil_data.get("angular_impulse_local", Vector3.ZERO)
	if not local_linear.is_finite() or not local_angular.is_finite():
		return
	var config := _force_receiver.get_config()
	var skeleton := _force_receiver.get_skeleton()
	if not is_instance_valid(skeleton):
		return
	var contacts: Array[Dictionary] = []
	var shoulder_bone := "mixamorig_RightShoulder"
	if model.shoulder_contact.is_finite() and config.recoil_shoulder_stiffness > 0.0 \
			and skeleton.find_bone(shoulder_bone) >= 0:
		contacts.append({
			"name": "shoulder",
			"bone": shoulder_bone,
			"point_local": model.shoulder_contact,
			"stiffness": config.recoil_shoulder_stiffness,
		})
	_add_recoil_hand_contact(
		weapon, contacts, "RightHandGrip", "mixamorig_RightHand",
		config.recoil_primary_hand_stiffness
	)
	_add_recoil_hand_contact(
		weapon, contacts, "LeftHandGrip", "mixamorig_LeftHand",
		config.recoil_support_hand_stiffness
	)
	if contacts.is_empty():
		return

	var weapon_basis := weapon.global_basis.orthonormalized()
	var impulse_world := weapon_basis * local_linear
	var target_angular_world := weapon_basis * local_angular
	var shoulder_world := weapon.global_transform * model.shoulder_contact
	var recoil_duration := model.get_recoil_response_duration_s(config.decay_floor)
	var total_stiffness := 0.0
	for contact in contacts:
		total_stiffness += float(contact["stiffness"])
	if total_stiffness <= 0.0:
		return

	var contact_moments := Vector3.ZERO
	for contact in contacts:
		var share := float(contact["stiffness"]) / total_stiffness
		var contact_impulse := impulse_world * share
		var point_world: Vector3 = weapon.global_transform * (contact["point_local"] as Vector3)
		contact_moments += (point_world - shoulder_world).cross(contact_impulse)
	var residual_angular := target_angular_world - contact_moments
	for contact in contacts:
		var share := float(contact["stiffness"]) / total_stiffness
		var contact_impulse := impulse_world * share
		var point_world: Vector3 = weapon.global_transform * (contact["point_local"] as Vector3)
		_force_receiver.apply_recoil_impulse(
			contact_impulse,
			(point_world - shoulder_world).cross(contact_impulse) + residual_angular * share,
			String(contact["bone"]),
			recoil_duration
		)


func _add_recoil_hand_contact(
	weapon: BaseWeapon,
	contacts: Array[Dictionary],
	marker_name: String,
	bone_name: String,
	stiffness: float
) -> void:
	var skeleton := _force_receiver.get_skeleton()
	if stiffness <= 0.0 or not is_instance_valid(skeleton):
		return
	if skeleton.find_bone(bone_name) < 0:
		return
	var marker := weapon.find_grip_node(marker_name)
	if not is_instance_valid(marker):
		return
	var point_local := weapon.to_local(marker.global_position) if weapon.is_inside_tree() else marker.position
	contacts.append({
		"name": marker_name,
		"bone": bone_name,
		"point_local": point_local,
		"stiffness": stiffness,
	})


func on_weapon_changed(new_weapon: BaseWeapon) -> void:
	# A weapon's contact points and inertia may change, so discard the previous
	# weapon's persistent recoil state before binding the new component.
	if _force_receiver:
		_force_receiver.clear_forces()
	var weight := new_weapon.config.left_hand_ik_weight if new_weapon and new_weapon.config else 1.0
	_ik_rig.set_weapon(new_weapon, weight)
	if _camera_controller:
		_camera_controller.set_recoil_component(
			new_weapon.recoil_component if new_weapon else null
		)
	sync_carry_weight_to_stamina()


## 将当前武器（含已装备配件）的总重量同步给耐力系统。
func sync_carry_weight_to_stamina() -> void:
	if not _stamina_system:
		return
	var weapon := _weapon_manager.current_weapon if _weapon_manager else null
	if weapon and weapon.config and weapon.config.weight_affects_movement:
		_stamina_system.set_carry_weight(weapon.get_total_weight())
	else:
		_stamina_system.set_carry_weight(0.0)
