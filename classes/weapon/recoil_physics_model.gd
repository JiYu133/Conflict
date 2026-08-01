class_name RecoilPhysicsModel
extends RefCounted

# Deterministic impulse + damped-oscillator recoil model.
# Weapon local axes: -Z = muzzle direction, +Z = recoil rear, +Y = up.

const MIN_INERTIA := 0.05
const DEFAULT_BULLET_MASS_KG := 0.0045
const DEFAULT_MUZZLE_VELOCITY := 880.0
const DEFAULT_GAS_MASS_KG := 0.0016
const DEFAULT_GAS_VELOCITY := 900.0
const DEFAULT_GAS_FACTOR := 0.6

var total_mass: float = 3.5
var center_of_mass: Vector3 = Vector3.ZERO
var inertia_pitch: float = 0.4
var inertia_yaw: float = 0.4
var bore_point: Vector3 = Vector3(0, 0.06, -0.35)
var shoulder_contact: Vector3 = Vector3(0, -0.04, 0.35)
var gas_impulse_vector: Vector3 = Vector3(0, 0, 1)
var gas_impulse_fraction: float = 1.0
var base_control_stiffness: float = 120.0
var base_control_damping: float = 18.0
var shooter_impulse_noise: float = 0.03
var attachment_control_stiffness: float = 0.0
var attachment_control_damping: float = 0.0
var impulse_magnitude: float = 0.0
var pitch_impulse_rad_s: float = 0.0
var yaw_impulse_rad_s: float = 0.0

var barrel_config: BarrelConfig = null
var _weapon_config: WeaponConfig = null
var _attachment_manager: AttachmentManager = null


func rebuild(weapon_cfg: WeaponConfig, am: AttachmentManager) -> void:
	_weapon_config = weapon_cfg
	_attachment_manager = am
	barrel_config = _find_barrel_config()

	var mass_parts: Array[Dictionary] = []
	base_control_stiffness = 120.0
	base_control_damping = 18.0
	shooter_impulse_noise = 0.03
	attachment_control_stiffness = 0.0
	attachment_control_damping = 0.0
	gas_impulse_vector = Vector3(0, 0, 1)
	gas_impulse_fraction = 1.0

	if _weapon_config:
		var receiver_mass := maxf(_weapon_config.receiver_mass_kg, 0.1)
		total_mass = receiver_mass
		center_of_mass = _weapon_config.receiver_com_local
		base_control_stiffness = _weapon_config.recoil_control_stiffness
		base_control_damping = _weapon_config.recoil_control_damping
		shooter_impulse_noise = _weapon_config.shooter_impulse_noise
		bore_point = _weapon_config.bore_point_local
		shoulder_contact = _weapon_config.shoulder_pivot_local
		mass_parts.append({"mass": receiver_mass, "pos": _weapon_config.receiver_com_local})
	else:
		total_mass = 3.5
		center_of_mass = Vector3.ZERO
		bore_point = Vector3(0, 0.06, -0.35)
		shoulder_contact = Vector3(0, -0.04, 0.35)

	if _attachment_manager:
		for att in _attachment_manager.get_all_attachments():
			var mass := maxf(att.config.weight_kg, 0.0)
			var pos := _get_attachment_local(att, att.config.center_of_mass_local)
			mass_parts.append({"mass": mass, "pos": pos})
			total_mass += mass
			center_of_mass += pos * mass
			_collect_special_attachment(att, pos)

	var barrel_attachment := _find_barrel_attachment()
	if barrel_attachment and _weapon_config:
		bore_point = _get_attachment_local(
			barrel_attachment,
			Vector3(0, _weapon_config.bore_axis_height_m, 0)
		)

	if total_mass > 0.0:
		center_of_mass /= total_mass

	_compute_inertia(mass_parts)
	_compute_impulse()


func get_shot_angular_impulse() -> Vector2:
	var variation := 0.02
	if barrel_config:
		variation = barrel_config.charge_variation
	var charge_scale := 1.0 + randf_range(-variation, variation)
	var noise_torque := impulse_magnitude * shooter_impulse_noise
	var noise_angle := randf_range(-PI, PI)
	return Vector2(
		pitch_impulse_rad_s * charge_scale + sin(noise_angle) * noise_torque / inertia_pitch,
		yaw_impulse_rad_s * charge_scale + cos(noise_angle) * noise_torque / inertia_yaw
	)


func get_control() -> Vector2:
	return Vector2(
		base_control_stiffness + attachment_control_stiffness,
		base_control_damping + attachment_control_damping
	)


func get_snapshot() -> Dictionary:
	return {
		"total_mass_kg": total_mass,
		"center_of_mass": center_of_mass,
		"inertia_pitch": inertia_pitch,
		"inertia_yaw": inertia_yaw,
		"bore_point": bore_point,
		"shoulder_contact": shoulder_contact,
		"gas_impulse_vector": gas_impulse_vector,
		"gas_impulse_fraction": gas_impulse_fraction,
		"impulse_magnitude_ns": impulse_magnitude,
		"pitch_impulse_rad_s": pitch_impulse_rad_s,
		"yaw_impulse_rad_s": yaw_impulse_rad_s,
		"control_stiffness": get_control().x,
		"control_damping": get_control().y,
		"shooter_impulse_noise": shooter_impulse_noise,
	}


func _find_barrel_config() -> BarrelConfig:
	if not _attachment_manager:
		return null
	for att in _attachment_manager.get_all_attachments():
		if att.config is BarrelConfig:
			return att.config as BarrelConfig
	return null


func _find_barrel_attachment() -> BaseAttachment:
	if not _attachment_manager:
		return null
	for att in _attachment_manager.get_all_attachments():
		if att.config is BarrelConfig:
			return att
	return null


func _get_attachment_local(att: BaseAttachment, offset: Vector3) -> Vector3:
	if not att:
		return offset
	if _attachment_manager and _attachment_manager.parent_weapon:
		var weapon := _attachment_manager.parent_weapon
		if weapon.is_inside_tree() and att.is_inside_tree():
			return weapon.global_transform.affine_inverse() * att.global_position + offset
	return att.position + offset


func _collect_special_attachment(att: BaseAttachment, pos: Vector3) -> void:
	if att.config is MuzzleDeviceConfig:
		var muzzle_cfg := att.config as MuzzleDeviceConfig
		gas_impulse_vector = muzzle_cfg.gas_impulse_vector
		gas_impulse_fraction = muzzle_cfg.gas_impulse_fraction

	if att.config is GripConfig:
		var grip_cfg := att.config as GripConfig
		var grip_pos := _get_attachment_local(att, grip_cfg.grip_point_local)
		var r := grip_pos - shoulder_contact
		var lever := Vector2(r.z, r.y).length()
		attachment_control_stiffness += grip_cfg.support_stiffness * lever * lever
		attachment_control_damping += grip_cfg.support_damping * lever * lever

	if att.config is StockConfig:
		var stock_cfg := att.config as StockConfig
		shoulder_contact = _get_attachment_local(att, stock_cfg.shoulder_contact_local)
		attachment_control_stiffness += stock_cfg.support_stiffness
		attachment_control_damping += stock_cfg.support_damping


func _compute_inertia(mass_parts: Array[Dictionary]) -> void:
	inertia_pitch = 0.0
	inertia_yaw = 0.0
	for part in mass_parts:
		var mass := float(part["mass"])
		var pos := part["pos"] as Vector3
		var r := pos - shoulder_contact
		inertia_pitch += mass * (r.y * r.y + r.z * r.z)
		inertia_yaw += mass * (r.x * r.x + r.z * r.z)
		inertia_pitch = maxf(inertia_pitch, MIN_INERTIA)
		inertia_yaw = maxf(inertia_yaw, MIN_INERTIA)


func _compute_impulse() -> void:
	var bullet_mass_kg := DEFAULT_BULLET_MASS_KG
	var muzzle_velocity := DEFAULT_MUZZLE_VELOCITY
	var gas_mass_kg := DEFAULT_GAS_MASS_KG
	var gas_velocity := DEFAULT_GAS_VELOCITY
	var gas_factor := DEFAULT_GAS_FACTOR

	if barrel_config:
		bullet_mass_kg = barrel_config.bullet_mass_g / 1000.0
		muzzle_velocity = barrel_config.muzzle_velocity
		gas_mass_kg = barrel_config.propellant_mass_g / 1000.0
		gas_velocity = barrel_config.gas_exit_velocity_mps
		gas_factor = barrel_config.gas_impulse_factor

	var bullet_momentum := bullet_mass_kg * muzzle_velocity
	var gas_momentum := gas_mass_kg * gas_velocity * gas_factor
	var gas_vec := gas_impulse_vector.normalized() * gas_momentum * gas_impulse_fraction
	var impulse := Vector3(gas_vec.x, gas_vec.y, bullet_momentum + gas_vec.z)
	impulse_magnitude = impulse.length()

	var r := bore_point - shoulder_contact
	var torque := r.cross(impulse)
	pitch_impulse_rad_s = torque.x / inertia_pitch
	yaw_impulse_rad_s = torque.y / inertia_yaw
