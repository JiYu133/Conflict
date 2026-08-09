class_name WeaponFXController
extends Node

# ============================================================
# 开火表现控制器
#
# 订阅 BaseWeapon 已有信号，把"物理事件"翻译成"视听表现"：
#   ejection(pos, vel) → 生成物理弹壳（P0）
#   fired()            → 枪口焰 + 枪口动态光照 + 残留烟雾（P2 接口）
#
# 全部效果都由 WeaponFXConfig 驱动，且素材缺失时静默跳过——
# 现在没有贴图/模型也能跑，美术补素材后填 .tres 即可生效。
#
# 场景节点约定（武器 .tscn）：
#   Muzzle          — 枪口特效挂点（缺省回退到 weapon_length 推算的位置）
#   EjectionPort    — 抛壳口挂点（缺省用 EjectionComponent 给的局部坐标）
# ============================================================

const MUZZLE_NODE_NAME := "Muzzle"
const EJECTION_NODE_NAME := "EjectionPort"
const HEAT_HAZE_MARKER_NAME := "HeatHaze"
const HEAT_HAZE_MATERIAL_PATH := "res://assets/materials/fx/heat_haze_material.tres"
const PREFERRED_HEAT_HAZE_NOISE_PATH := "res://assets/textures/fx/noise_heat_haze.png"
const DEFAULT_HEAT_HAZE_NOISE_PATH := "res://assets/textures/effects/noise/noise_heat_haze.tres"

var _weapon: BaseWeapon
var _fx: WeaponFXConfig
var _settings_service = null
var _muzzle_point: Node3D
var _ejection_point: Node3D
var _heat_haze_marker: Node3D
var _heat_haze_particles: GPUParticles3D
var _heat_haze_material: ShaderMaterial
var _heat_haze_noise: Texture2D
var _heat_haze_particle_process: ParticleProcessMaterial
var _heat_haze_heat: float = 0.0
var _heat_haze_profile_multiplier: float = 1.0
var _live_shells: Array[ShellCasing] = []


func initialize(weapon: BaseWeapon, fx: WeaponFXConfig) -> void:
	_weapon = weapon
	_fx = fx if fx else WeaponFXConfig.new()
	_resolve_markers()
	_load_heat_haze_resources()
	# 抛壳窗与枪口挂点通常定义在配件场景里（抛壳窗在机匣/机匣盖，枪口在枪管），
	# 而配件是在武器初始化之后才装上的——因此必须在配件变动后重新查找，
	# 否则永远只找得到机匣本体上的挂点（或找不到，退化成硬编码偏移）。
	if weapon.attachment_manager:
		weapon.attachment_manager.attachments_changed.connect(_resolve_markers)

	if not weapon.ejection.is_connected(_on_ejection):
		weapon.ejection.connect(_on_ejection)
	if not weapon.fired.is_connected(_on_fired):
		weapon.fired.connect(_on_fired)

func set_settings_service(service) -> void:
	_settings_service = service
	if _settings_service and not _settings_service.value_changed.is_connected(_on_setting_changed):
		_settings_service.value_changed.connect(_on_setting_changed)
	if _heat_haze_allowed() and not _heat_haze_material:
		_load_heat_haze_resources()

func _on_setting_changed(key: String, value: Variant) -> void:
	match key:
		"graphics/heat_haze":
			if not bool(value):
				_heat_haze_heat = 0.0
				if is_instance_valid(_heat_haze_particles):
					_heat_haze_particles.emitting = false
					_heat_haze_particles.visible = false
			else:
				_load_heat_haze_resources()
				if is_instance_valid(_heat_haze_particles):
					_heat_haze_particles.visible = true
		"graphics/muzzle_flash":
			if not bool(value):
				_free_effect_group("weapon_muzzle_flash_effects")
		"graphics/muzzle_light":
			if not bool(value):
				_free_effect_group("weapon_muzzle_light_effects")


## 递归查找挂点。find_child(recursive) 会一并搜索已装配件的场景，
## 因此挂点既可以放在机匣本体，也可以放在配件里（推荐后者：
## 抛壳窗属于机匣/机匣盖，枪口属于枪管，换件后位置自然跟着变）。
func _resolve_markers() -> void:
	if not is_instance_valid(_weapon):
		return
	_muzzle_point = _weapon.find_child(MUZZLE_NODE_NAME, true, false) as Node3D
	_ejection_point = _weapon.find_child(EJECTION_NODE_NAME, true, false) as Node3D
	var next_heat_marker := _weapon.find_child(HEAT_HAZE_MARKER_NAME, true, false) as Node3D
	# 旧武器没有专用 Marker 时回退到 Muzzle，但新枪管应始终提供 HeatHaze Marker。
	if not next_heat_marker:
		next_heat_marker = _muzzle_point
	if next_heat_marker != _heat_haze_marker:
		_clear_heat_haze_node()
		_heat_haze_marker = next_heat_marker
	if not _ejection_point:
		GlobalLogger.debug(
			"WeaponFX",
			"未找到 %s 挂点，抛壳将使用 EjectionComponent 的硬编码偏移（位置可能不准）"
				% EJECTION_NODE_NAME
		)


# ── 抛壳（P0）────────────────────────────────────────────────

## eject_pos / eject_vel 由 EjectionComponent 按武器局部空间给出
func _on_ejection(eject_pos: Vector3, eject_vel: Vector3) -> void:
	if not _weapon or not _weapon.is_inside_tree():
		return
	var world_parent := _weapon.get_tree().current_scene
	if not world_parent:
		return

	var shell := ShellCasing.new()
	shell.setup(_fx)
	shell.build_visual(_fx.shell_scene)
	world_parent.add_child(shell)

	# 抛壳口世界变换：优先用场景挂点，否则用组件给的局部偏移
	var basis: Basis = _weapon.global_basis
	var origin: Vector3
	if _ejection_point:
		origin = _ejection_point.global_position
		basis = _ejection_point.global_basis
	else:
		origin = _weapon.global_position + basis * eject_pos
	shell.global_position = origin

	# 初速：局部方向转世界，叠加随机扰动，让每次轨迹不同（清单要求"自然弹出"）
	var jitter := _fx.shell_velocity_jitter
	var vel: Vector3 = basis * eject_vel
	vel += Vector3(
		randf_range(-jitter, jitter),
		randf_range(-jitter, jitter),
		randf_range(-jitter, jitter)
	) * vel.length()
	# 继承持枪者的移动速度，跑动中抛壳不会诡异地留在原地
	vel += _get_carrier_velocity()
	shell.linear_velocity = vel

	# 翻滚：绕随机轴给一个角速度
	var spin_axis := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	shell.angular_velocity = spin_axis * randf_range(_fx.shell_spin_min, _fx.shell_spin_max)

	_track_shell(shell)


## 限制同时存在的弹壳数量，超出上限回收最早的。
## 弹壳到寿命会自行 queue_free()，列表里因此会留下已释放的引用；
## 直接 pop_front() 赋给 ShellCasing 类型变量会抛
## "Trying to assign invalid previously freed instance"，所以先清理再回收。
func _track_shell(shell: ShellCasing) -> void:
	_live_shells.append(shell)

	# 剔除已自然销毁的条目（用无类型变量接收，避免赋值期即报错）
	var alive: Array[ShellCasing] = []
	for entry in _live_shells:
		if is_instance_valid(entry):
			alive.append(entry)
	_live_shells = alive

	var cap := maxi(_fx.shell_max_count, 1)
	while _live_shells.size() > cap:
		var oldest := _live_shells[0]
		_live_shells.remove_at(0)
		if is_instance_valid(oldest):
			oldest.queue_free()


func _get_carrier_velocity() -> Vector3:
	var node: Node = _weapon
	while node:
		if node is CharacterBody3D:
			return (node as CharacterBody3D).velocity
		node = node.get_parent()
	return Vector3.ZERO


# ── 枪口焰 / 光照（P2 接口，无素材时静默跳过）──────────────────

func _on_fired() -> void:
	if not _weapon or not _weapon.is_inside_tree():
		return
	var profile := _fx.resolve_muzzle_profile(_effective_barrel_length(), _muzzle_kind())
	var xf := _muzzle_transform()
	if _setting_enabled("graphics/muzzle_flash", true):
		_spawn_flash(profile, xf)
	_spawn_muzzle_light(profile, xf)
	_spawn_smoke(xf)
	if _heat_haze_allowed():
		_add_heat_haze_heat(profile)


func _process(delta: float) -> void:
	if not _fx:
		return
	if _heat_haze_allowed() and _heat_haze_heat > 0.0:
		_heat_haze_heat = maxf(
			_heat_haze_heat - maxf(_fx.heat_haze_cooling_rate, 0.01) * delta,
			0.0
		)
	if _heat_haze_allowed():
		_update_heat_haze_particles()


## 有效枪管长度：优先取已装枪管组件，其次武器配置
func _effective_barrel_length() -> float:
	if _weapon:
		var barrel := _weapon._get_attachment_config_of_type(BarrelConfig) as BarrelConfig
		if barrel:
			return barrel.barrel_length
		if _weapon.config:
			return _weapon.config.barrel_length
	return 0.415


## 判定枪口装置类别：按已装枪口配件的名称/字段推断。
## 消音器优先级最高（同时抑制焰与光）。
func _muzzle_kind() -> int:
	if not _weapon or not _weapon.attachment_manager:
		return WeaponFXConfig.MuzzleKind.NONE
	for att in _weapon.attachment_manager.get_all_attachments():
		var cfg := (att as BaseAttachment).config
		if not cfg:
			continue
		if cfg.attachment_type != AttachmentConfig.AttachmentType.MUZZLE:
			continue
		# 配件配置若声明了消音/消焰能力则直接采用，否则按名称回退判断
		if cfg.suppresses_sound:
			return WeaponFXConfig.MuzzleKind.SUPPRESSOR
		if cfg.suppresses_flash:
			return WeaponFXConfig.MuzzleKind.FLASH_HIDER
		var lower := cfg.attachment_name.to_lower()
		if lower.contains("suppress") or cfg.attachment_name.contains("消音"):
			return WeaponFXConfig.MuzzleKind.SUPPRESSOR
		if lower.contains("brake") or cfg.attachment_name.contains("制退"):
			return WeaponFXConfig.MuzzleKind.BRAKE
		if lower.contains("hider") or cfg.attachment_name.contains("消焰"):
			return WeaponFXConfig.MuzzleKind.FLASH_HIDER
		return WeaponFXConfig.MuzzleKind.NONE
	return WeaponFXConfig.MuzzleKind.NONE


func _muzzle_transform() -> Transform3D:
	if _muzzle_point:
		return _muzzle_point.global_transform
	var offset: float = _weapon.config.weapon_length if _weapon.config else 0.7
	return Transform3D(
		_weapon.global_basis,
		_weapon.global_position + _weapon.global_basis.z * -offset
	)


func _spawn_flash(profile: Dictionary, xf: Transform3D) -> void:
	var scene: PackedScene = profile.get("scene")
	if not scene:
		return  # 素材未就绪：静默跳过
	var node := scene.instantiate() as Node3D
	if not node:
		return
	_weapon.get_tree().current_scene.add_child(node)
	node.add_to_group("weapon_muzzle_flash_effects")
	node.global_transform = xf
	node.scale = Vector3.ONE * float(profile.get("scale", 1.0))
	_auto_free(node, float(profile.get("lifetime", 0.05)) + 1.0)


func _spawn_muzzle_light(profile: Dictionary, xf: Transform3D) -> void:
	if not _fx.muzzle_light_enabled or not _setting_enabled("graphics/muzzle_light", true):
		return
	var light := OmniLight3D.new()
	light.light_color = _fx.muzzle_light_color
	light.light_energy = float(profile.get("light_energy", _fx.muzzle_light_energy))
	light.omni_range = _fx.muzzle_light_range
	light.shadow_enabled = false
	_weapon.get_tree().current_scene.add_child(light)
	light.add_to_group("weapon_muzzle_light_effects")
	light.global_position = xf.origin
	# 一次性闪光：能量快速衰减到 0 后销毁
	var tween := light.create_tween()
	tween.tween_property(light, "light_energy", 0.0, _fx.muzzle_light_decay)
	tween.tween_callback(light.queue_free)


func _spawn_smoke(xf: Transform3D) -> void:
	if not _fx.smoke_scene:
		return
	var node := _fx.smoke_scene.instantiate() as Node3D
	if not node:
		return
	_weapon.get_tree().current_scene.add_child(node)
	node.global_transform = xf
	_auto_free(node, 4.0)


## 初始化并缓存 Shader/Noise。热浪节点只在第一次开火时创建一次，后续复用。
func _load_heat_haze_resources() -> void:
	if not _fx.heat_haze_enabled or not _heat_haze_allowed():
		return
	_heat_haze_noise = _fx.heat_haze_noise_texture as Texture2D
	if not _heat_haze_noise and ResourceLoader.exists(PREFERRED_HEAT_HAZE_NOISE_PATH):
		_heat_haze_noise = load(PREFERRED_HEAT_HAZE_NOISE_PATH) as Texture2D
	if not _heat_haze_noise and ResourceLoader.exists(DEFAULT_HEAT_HAZE_NOISE_PATH):
		_heat_haze_noise = load(DEFAULT_HEAT_HAZE_NOISE_PATH) as Texture2D
	if not _heat_haze_material:
		var configured_material := _fx.heat_haze_material as ShaderMaterial
		if configured_material:
			_heat_haze_material = configured_material.duplicate() as ShaderMaterial
		elif ResourceLoader.exists(HEAT_HAZE_MATERIAL_PATH):
			_heat_haze_material = (load(HEAT_HAZE_MATERIAL_PATH) as ShaderMaterial).duplicate() as ShaderMaterial
	if _heat_haze_material:
		# 每把武器使用自己的材质实例，避免热量透明度互相污染。
		if _heat_haze_noise:
			_heat_haze_material.set_shader_parameter("noise_texture", _heat_haze_noise)
		_heat_haze_material.set_shader_parameter("distortion_strength", _fx.heat_haze_strength)
		_heat_haze_material.set_shader_parameter("flow_speed", _fx.heat_haze_flow_speed)
		_heat_haze_material.set_shader_parameter("noise_scale", _fx.heat_haze_noise_scale)
		_heat_haze_material.set_shader_parameter("proximity_fade_distance", 0.75)


func _add_heat_haze_heat(profile: Dictionary) -> void:
	if not _heat_haze_allowed() or not _weapon or not _weapon.is_inside_tree():
		return
	var profile_id: int = int(profile.get("profile", WeaponFXConfig.MuzzleProfile.STANDARD))
	_heat_haze_profile_multiplier = _heat_haze_multiplier_for_profile(profile_id)
	_heat_haze_heat = minf(
		_heat_haze_heat + _fx.heat_haze_heat_per_shot * _heat_haze_profile_multiplier,
		maxf(_fx.heat_haze_max_heat, 0.1)
	)
	_ensure_heat_haze_particles()
	_update_heat_haze_particles()
	if is_instance_valid(_heat_haze_particles):
		# restart() 清除上一轮尚未结束的粒子，保证自动射击不会无限堆积。
		_heat_haze_particles.emitting = true
		_heat_haze_particles.restart()


func _heat_haze_multiplier_for_profile(profile_id: int) -> float:
	match profile_id:
		WeaponFXConfig.MuzzleProfile.SHORT_BARREL:
			return 1.25
		WeaponFXConfig.MuzzleProfile.LONG_BARREL:
			return 0.75
		WeaponFXConfig.MuzzleProfile.FLASH_HIDER:
			return 0.75
		WeaponFXConfig.MuzzleProfile.MUZZLE_BRAKE:
			return 1.15
		WeaponFXConfig.MuzzleProfile.SUPPRESSOR:
			return 0.55
	return 1.0


func _ensure_heat_haze_particles() -> void:
	if is_instance_valid(_heat_haze_particles):
		return
	if not _heat_haze_marker or not is_instance_valid(_heat_haze_marker):
		return
	if not _heat_haze_material:
		return
	_heat_haze_particles = GPUParticles3D.new()
	_heat_haze_particles.name = "HeatHazeParticles"
	_heat_haze_particles.amount = maxi(_fx.heat_haze_particle_amount, 1)
	_heat_haze_particles.lifetime = maxf(_fx.heat_haze_particle_lifetime, 0.05)
	_heat_haze_particles.one_shot = true
	_heat_haze_particles.explosiveness = 1.0
	_heat_haze_particles.local_coords = true
	_heat_haze_particles.emitting = false
	_heat_haze_particles.visibility_aabb = AABB(Vector3(-3.0, -3.0, -3.0), Vector3(6.0, 6.0, 6.0))
	_heat_haze_particles.position = Vector3(0.0, 0.0, -_fx.heat_haze_offset)
	_heat_haze_marker.add_child(_heat_haze_particles)

	var quad := QuadMesh.new()
	quad.size = Vector2.ONE
	quad.material = _heat_haze_material
	_heat_haze_particles.draw_pass_1 = quad
	_heat_haze_particle_process = _build_heat_haze_particle_process()
	_heat_haze_particles.process_material = _heat_haze_particle_process


func _build_heat_haze_particle_process() -> ParticleProcessMaterial:
	var process_material := ParticleProcessMaterial.new()
	process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	process_material.direction = Vector3.UP
	process_material.spread = clampf(_fx.heat_haze_spread, 0.0, 45.0)
	process_material.initial_velocity_min = maxf(_fx.heat_haze_velocity_min, 0.0)
	process_material.initial_velocity_max = maxf(_fx.heat_haze_velocity_max, process_material.initial_velocity_min)
	process_material.gravity = Vector3.ZERO
	process_material.scale_min = 1.0
	process_material.scale_max = 1.0
	var scale_texture := CurveTexture.new()
	scale_texture.curve = _build_heat_haze_scale_curve()
	process_material.scale_curve = scale_texture
	process_material.color_ramp = _build_heat_haze_color_ramp()
	return process_material


func _build_heat_haze_scale_curve() -> Curve:
	var curve := Curve.new()
	curve.min_value = 0.0
	curve.max_value = maxf(_fx.heat_haze_particle_scale.y, 0.1)
	curve.add_point(Vector2(0.0, maxf(_fx.heat_haze_particle_scale.x, 0.01)))
	curve.add_point(Vector2(0.12, lerpf(_fx.heat_haze_particle_scale.x, _fx.heat_haze_particle_scale.y, 0.65)))
	curve.add_point(Vector2(0.35, _fx.heat_haze_particle_scale.y))
	curve.add_point(Vector2(1.0, _fx.heat_haze_particle_scale.y))
	return curve


func _build_heat_haze_color_ramp() -> GradientTexture1D:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([
		Color(1.0, 1.0, 1.0, 0.5),
		Color(1.0, 1.0, 1.0, 0.0)
	])
	var ramp := GradientTexture1D.new()
	ramp.gradient = gradient
	return ramp


func _update_heat_haze_particles() -> void:
	if not is_instance_valid(_heat_haze_particles) or not _heat_haze_material:
		return
	_heat_haze_particles.visible = _heat_haze_allowed()
	var heat_factor := clampf(_heat_haze_heat / maxf(_fx.heat_haze_max_heat, 0.1), 0.0, 1.0)
	var opacity := _fx.heat_haze_opacity * lerpf(0.35, 1.0, heat_factor) * _heat_haze_profile_multiplier
	_heat_haze_material.set_shader_parameter("opacity", opacity)


func _heat_haze_allowed() -> bool:
	return _fx.heat_haze_enabled and _setting_enabled("graphics/heat_haze", true)


func _setting_enabled(key: String, fallback: bool) -> bool:
	return bool(_settings_service.get_value(key, fallback)) if _settings_service else fallback


func _free_effect_group(group_name: String) -> void:
	if not _weapon or not _weapon.get_tree():
		return
	for node in _weapon.get_tree().get_nodes_in_group(group_name):
		if is_instance_valid(node):
			node.queue_free()


func _clear_heat_haze_node() -> void:
	if is_instance_valid(_heat_haze_particles):
		_heat_haze_particles.queue_free()
	_heat_haze_particles = null
	_heat_haze_particle_process = null


func _auto_free(node: Node, seconds: float) -> void:
	var timer := node.get_tree().create_timer(seconds)
	timer.timeout.connect(func():
		if is_instance_valid(node):
			node.queue_free()
	)
