class_name WeaponManager
extends Node

signal weapon_changed(new_weapon: BaseWeapon)
signal weapon_fired(weapon: BaseWeapon)

## 配件装备/卸载后由此信号通知 UI 更新
signal attachment_equipped(slot_name: String, attachment_name: String)
signal attachment_detached(slot_name: String)
## 配件数值重算完成，UI 可刷新对比面板
signal weapon_stats_changed()

var current_weapon: BaseWeapon
var weapon_mount: Node3D
var camera_controller: PlayerCameraController
var settings_service
var is_aiming: bool = false

var _weapon_anim_controller: WeaponAnimationController
var _moving_parts_controller: WeaponMovingPartsController
var _stats_changed_callable: Callable  # 存储 lambda 以便 disconnect


func equip_weapon(weapon: BaseWeapon, emit_changed: bool = true) -> void:
	if current_weapon:
		if _weapon_anim_controller:
			_weapon_anim_controller.play_holster()
		# 显式断开信号，避免 queue_free 延迟期间旧信号仍触发
		var old_am := current_weapon.attachment_manager
		if old_am:
			if old_am.attachment_equipped.is_connected(_on_weapon_attachment_equipped):
				old_am.attachment_equipped.disconnect(_on_weapon_attachment_equipped)
			if old_am.attachment_detached.is_connected(_on_weapon_attachment_detached):
				old_am.attachment_detached.disconnect(_on_weapon_attachment_detached)
			if _stats_changed_callable.is_valid() and old_am.attachments_changed.is_connected(_stats_changed_callable):
				old_am.attachments_changed.disconnect(_stats_changed_callable)
		current_weapon.queue_free()
		_weapon_anim_controller = null
		_moving_parts_controller = null
	current_weapon = weapon
	if weapon.fx_controller:
		weapon.fx_controller.set_settings_service(settings_service)
	if weapon_mount:
		weapon_mount.add_child(weapon)
		_align_to_grip(weapon)
	else:
		push_error("WeaponManager: weapon_mount 为 null，武器 '%s' 已创建但不会显示" % weapon.name)

	# 创建动画控制器，挂在武器节点下随武器一起销毁
	_weapon_anim_controller = WeaponAnimationController.new()
	_weapon_anim_controller.name = "WeaponAnimationController"
	weapon.add_child(_weapon_anim_controller)
	_weapon_anim_controller.initialize(weapon)

	# 创建可动部件控制器（枪机/拉机柄位移驱动）
	_moving_parts_controller = WeaponMovingPartsController.new()
	_moving_parts_controller.name = "WeaponMovingPartsController"
	weapon.add_child(_moving_parts_controller)
	_moving_parts_controller.initialize(weapon)

	# 订阅配件变更信号，透传给外部系统
	_stats_changed_callable = func():
		_align_to_grip(current_weapon)
		weapon_stats_changed.emit()
	weapon.attachment_manager.attachment_equipped.connect(_on_weapon_attachment_equipped)
	weapon.attachment_manager.attachment_detached.connect(_on_weapon_attachment_detached)
	weapon.attachment_manager.attachments_changed.connect(_stats_changed_callable)

	if emit_changed:
		weapon_changed.emit(current_weapon)


## 用武器自身的 RightHandGrip 标记对齐到挂载点（右手骨骼）。
## 位置和朝向都要对齐：只对齐位置会让武器继承手骨自带的约 90° 基向量，
## 表现为「横着端枪」。取握把相对变换的逆，握把即与挂载点完全重合。
## 若美术摆放的握把 Marker 轴向与手骨约定不一致，用 WeaponConfig.grip_alignment_offset 微调。
func _align_to_grip(weapon: BaseWeapon) -> void:
	var grip := weapon.find_grip_node("RightHandGrip")
	if not grip:
		weapon.transform = Transform3D.IDENTITY
		return
	var grip_relative := _relative_grip_transform(weapon, grip)
	var offset := Basis.IDENTITY
	if weapon.config:
		var d: Vector3 = weapon.config.grip_alignment_offset
		offset = Basis.from_euler(Vector3(deg_to_rad(d.x), deg_to_rad(d.y), deg_to_rad(d.z)))
	weapon.transform = Transform3D(offset, Vector3.ZERO) * grip_relative.affine_inverse()


func _relative_grip_transform(root: Node3D, descendant: Node3D) -> Transform3D:
	var result := Transform3D.IDENTITY
	var node: Node3D = descendant
	while node and node != root:
		result = node.transform * result
		node = node.get_parent() as Node3D
	return result

## 设置武器挂载点(从调用处获取)
func set_mount(mount: Node3D) -> void:
	weapon_mount = mount


## Detach the equipped weapon without replacing or duplicating it.
func detach_current_weapon_to(new_parent: Node3D) -> BaseWeapon:
	if not is_instance_valid(current_weapon) or not is_instance_valid(new_parent):
		return null
	release_trigger()
	set_aiming(false)
	current_weapon.reparent(new_parent, false)
	current_weapon.transform = Transform3D.IDENTITY
	return current_weapon


## Return a previously detached current weapon to the authored hand mount.
func restore_current_weapon_to_mount(weapon: BaseWeapon) -> bool:
	if not is_instance_valid(weapon) or weapon != current_weapon or not is_instance_valid(weapon_mount):
		return false
	weapon.reparent(weapon_mount, false)
	_align_to_grip(weapon)
	_apply_ads_state()
	return true

func set_camera_controller(controller: PlayerCameraController) -> void:
	camera_controller = controller

func set_settings_service(service) -> void:
	settings_service = service
	if current_weapon and current_weapon.fx_controller:
		current_weapon.fx_controller.set_settings_service(service)

func press_trigger() -> void:
	if current_weapon:
		current_weapon.press_trigger()

func release_trigger() -> void:
	if current_weapon:
		current_weapon.release_trigger()

func reload() -> void:
	if current_weapon:
		current_weapon.reload()

func cycle_fire_mode() -> bool:
	if current_weapon:
		return current_weapon.cycle_fire_mode()
	return false


func get_available_fire_modes() -> Array[String]:
	if current_weapon:
		return current_weapon.get_available_fire_modes()
	return []


func set_fire_mode(mode: String) -> bool:
	if current_weapon:
		return current_weapon.set_fire_mode(mode)
	return false

func attempt_malfunction_clearance() -> void:
	if current_weapon:
		current_weapon.attempt_malfunction_clearance()

func set_aiming(aiming: bool) -> void:
	is_aiming = aiming
	if _weapon_anim_controller:
		if aiming:
			_weapon_anim_controller.play_ads_in()
		else:
			_weapon_anim_controller.play_ads_out()
	_apply_ads_state()

## 根据配置创建武器实例，装备并自动装上预设配件
func load_and_equip(config: WeaponConfig) -> void:
	if not config:
		GlobalLogger.error("WeaponManager", "WeaponConfig 为空，无法装备武器")
		return
	GlobalLogger.info("WeaponManager", "装备武器: " + config.weapon_name)
	var weapon_scene = config.weapon_scene
	if not weapon_scene:
		GlobalLogger.error("WeaponManager", "武器 %s 缺少 weapon_scene" % config.weapon_name)
		return
	var weapon = weapon_scene.instantiate() as BaseWeapon
	if not weapon:
		GlobalLogger.error("WeaponManager", "武器场景根节点应为 BaseWeapon: " + config.weapon_name)
		return
	weapon.initialize(config)
	equip_weapon(weapon, false)
	_equip_default_attachments(config)
	weapon_changed.emit(current_weapon)
	_apply_ads_state()


## 装上 WeaponConfig 里定义的预设配件。
## 推荐只填 default_attachment_configs，代码会按顺序自动匹配当前可用槽位；
## 旧的 default_attachment_slots + configs 等长写法仍兼容。
func _equip_default_attachments(config: WeaponConfig) -> void:
	var slots   := config.default_attachment_slots
	var configs := config.default_attachment_configs
	if not slots.is_empty() and slots.size() == configs.size():
		for i in slots.size():
			var slot_name: String        = slots[i]
			var att_cfg: AttachmentConfig = configs[i]
			if not att_cfg:
				GlobalLogger.warn("WeaponManager", "预设配件 [%d] 配置为空，跳过" % i)
				continue
			var ok := equip_attachment(slot_name, att_cfg)
			if ok:
				GlobalLogger.debug("WeaponManager", "预设配件已装: %s → %s" % [slot_name, att_cfg.attachment_name])
			else:
				GlobalLogger.warn("WeaponManager", "预设配件装配失败: %s → %s" % [slot_name, att_cfg.attachment_name])
		return
	for i in configs.size():
		var att_cfg: AttachmentConfig = configs[i]
		if not att_cfg:
			GlobalLogger.warn("WeaponManager", "预设配件 [%d] 配置为空，跳过" % i)
			continue
		var ok := equip_attachment_auto(att_cfg)
		if ok:
			GlobalLogger.debug("WeaponManager", "预设配件已自动装好: %s" % att_cfg.attachment_name)
		else:
			GlobalLogger.warn("WeaponManager", "预设配件无可用槽位，已跳过: %s" % att_cfg.attachment_name)


func _apply_ads_state() -> void:
	if not camera_controller or not current_weapon or not current_weapon.config:
		return
	camera_controller.set_ads_state(
		is_aiming,
		current_weapon.get_effective_ads_time(),
		current_weapon.get_effective_fov_override(),
		current_weapon.config.ads_center_offset
	)


# ============================================================
# 改装接口（供改装 UI 调用）
# ============================================================

## 将一个配件装到当前武器的指定槽位
## 返回 true = 成功；false = 无武器 / 槽位不存在 / 类型不匹配
func equip_attachment(slot_name: String, cfg: AttachmentConfig) -> bool:
	if not current_weapon or not current_weapon.attachment_manager:
		return false
	return current_weapon.equip_attachment(slot_name, cfg)


## 不指定槽位名，自动匹配当前第一个能接受该配件的空槽位。
## 父配件先装上后，它场景内的子槽会立即进入匹配范围。
func equip_attachment_auto(cfg: AttachmentConfig) -> bool:
	if not current_weapon:
		return false
	return current_weapon.equip_attachment_auto(cfg)


## 从当前武器的指定槽位卸载配件，返回被卸下的实例（null = 失败）
func detach_attachment(slot_name: String) -> BaseAttachment:
	if not current_weapon:
		return null
	return current_weapon.detach_attachment(slot_name)


## 查询当前武器所有槽位状态，供改装 UI 渲染列表
## 每项 Dictionary: { slot_name, slot_type, allowed_attachment_types, is_occupied, attachment_name, attachment_config }
func get_attachment_slots() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not current_weapon or not current_weapon.attachment_manager:
		return result
	var am := current_weapon.attachment_manager
	for slot_name in am.get_slot_names():
		var slot: AttachmentSlot = am.get_slot(slot_name)
		if not slot:
			continue
		result.append({
			"slot_name": slot_name,
			"slot_type": slot.slot_type,
			"allowed_attachment_types": slot.allowed_attachment_types,
			"is_occupied": slot.is_occupied,
			"attachment_name": slot.current_attachment.config.attachment_name if slot.is_occupied else "",
			"attachment_config": slot.current_attachment.config if slot.is_occupied else null,
		})
	return result


## 返回当前场景中已注册槽位的类型列表；槽位来源是 AttachmentSlot Marker3D，不再读 WeaponConfig。
func get_supported_slot_types() -> Array[AttachmentSlot.SlotType]:
	var result: Array[AttachmentSlot.SlotType] = []
	if not current_weapon or not current_weapon.attachment_manager:
		return result
	for slot in current_weapon.attachment_manager.get_slots():
		if not result.has(slot.slot_type):
			result.append(slot.slot_type)
	return result


## 调整指定槽位配件的导轨位置（供改装 UI 滑动条调用）
func set_rail_offset(slot_name: String, offset: float) -> void:
	if current_weapon:
		current_weapon.set_attachment_rail_offset(slot_name, offset)


## 获取指定槽位配件的当前导轨偏移值
func get_rail_offset(slot_name: String) -> float:
	return current_weapon.get_attachment_rail_offset(slot_name) if current_weapon else 0.0


# ============================================================
# 内部信号回调
# ============================================================

func _on_weapon_attachment_equipped(slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	var slot_name: String = slot.get_slot_key()
	attachment_equipped.emit(slot_name, attachment.config.attachment_name)
	_apply_ads_state()


func _on_weapon_attachment_detached(slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	var slot_name: String = slot.get_slot_key()
	attachment_detached.emit(slot_name)
	_apply_ads_state()
