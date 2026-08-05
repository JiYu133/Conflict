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

var _weapon: BaseWeapon
var _fx: WeaponFXConfig
var _muzzle_point: Node3D
var _ejection_point: Node3D
var _live_shells: Array[ShellCasing] = []


func initialize(weapon: BaseWeapon, fx: WeaponFXConfig) -> void:
	_weapon = weapon
	_fx = fx if fx else WeaponFXConfig.new()
	_resolve_markers()
	# 抛壳窗与枪口挂点通常定义在配件场景里（抛壳窗在机匣/机匣盖，枪口在枪管），
	# 而配件是在武器初始化之后才装上的——因此必须在配件变动后重新查找，
	# 否则永远只找得到机匣本体上的挂点（或找不到，退化成硬编码偏移）。
	if weapon.attachment_manager:
		weapon.attachment_manager.attachments_changed.connect(_resolve_markers)

	if not weapon.ejection.is_connected(_on_ejection):
		weapon.ejection.connect(_on_ejection)
	if not weapon.fired.is_connected(_on_fired):
		weapon.fired.connect(_on_fired)


## 递归查找挂点。find_child(recursive) 会一并搜索已装配件的场景，
## 因此挂点既可以放在机匣本体，也可以放在配件里（推荐后者：
## 抛壳窗属于机匣/机匣盖，枪口属于枪管，换件后位置自然跟着变）。
func _resolve_markers() -> void:
	if not is_instance_valid(_weapon):
		return
	_muzzle_point = _weapon.find_child(MUZZLE_NODE_NAME, true, false) as Node3D
	_ejection_point = _weapon.find_child(EJECTION_NODE_NAME, true, false) as Node3D
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
	_spawn_flash(profile, xf)
	_spawn_muzzle_light(profile, xf)
	_spawn_smoke(xf)


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
	node.global_transform = xf
	node.scale = Vector3.ONE * float(profile.get("scale", 1.0))
	_auto_free(node, float(profile.get("lifetime", 0.05)) + 1.0)


func _spawn_muzzle_light(profile: Dictionary, xf: Transform3D) -> void:
	if not _fx.muzzle_light_enabled:
		return
	var light := OmniLight3D.new()
	light.light_color = _fx.muzzle_light_color
	light.light_energy = float(profile.get("light_energy", _fx.muzzle_light_energy))
	light.omni_range = _fx.muzzle_light_range
	light.shadow_enabled = false
	_weapon.get_tree().current_scene.add_child(light)
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


func _auto_free(node: Node, seconds: float) -> void:
	var timer := node.get_tree().create_timer(seconds)
	timer.timeout.connect(func():
		if is_instance_valid(node):
			node.queue_free()
	)
