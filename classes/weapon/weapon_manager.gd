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
var is_aiming: bool = false

var _weapon_anim_controller: WeaponAnimationController
var _moving_parts_controller: WeaponMovingPartsController
var _stats_changed_callable: Callable  # 存储 lambda 以便 disconnect


func equip_weapon(weapon: BaseWeapon) -> void:
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
	_stats_changed_callable = func(): weapon_stats_changed.emit()
	weapon.attachment_manager.attachment_equipped.connect(_on_weapon_attachment_equipped)
	weapon.attachment_manager.attachment_detached.connect(_on_weapon_attachment_detached)
	weapon.attachment_manager.attachments_changed.connect(_stats_changed_callable)

	weapon_changed.emit(current_weapon)


func _align_to_grip(weapon: BaseWeapon) -> void:
	var grip := weapon.find_child("RightHandGrip", true, false) as Node3D
	if not grip:
		weapon.position = Vector3.ZERO
		weapon.rotation = Vector3.ZERO
		return
	weapon.transform = grip.transform.inverse()

## 设置武器挂载点(从调用处获取)
func set_mount(mount: Node3D) -> void:
	weapon_mount = mount

func set_camera_controller(controller: PlayerCameraController) -> void:
	camera_controller = controller

func press_trigger() -> void:
	if current_weapon:
		current_weapon.press_trigger()

func release_trigger() -> void:
	if current_weapon:
		current_weapon.release_trigger()

func reload() -> void:
	if current_weapon:
		current_weapon.reload()

func cycle_fire_mode() -> void:
	if current_weapon:
		current_weapon.cycle_fire_mode()

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

## 根据配置和模型路径创建武器实例并装备
func load_and_equip(config: WeaponConfig) -> void:
	if not config:
		push_error("WeaponConfig 为空，无法装备武器")
		return
	print("装备武器 " + config.weapon_name)
	var weapon_scene = config.weapon_scene
	if not weapon_scene:
		push_error("武器 %s 缺少 weapon_scene" % config.weapon_name)
		return
	var weapon = weapon_scene.instantiate() as BaseWeapon
	if not weapon:
		push_error("武器场景的根节点应为BaseWeapon: " + config.weapon_name)
		return
	weapon.initialize(config)
	equip_weapon(weapon)
	_apply_ads_state()


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
	var att := AttachmentFactory.create(cfg, current_weapon)
	if not att:
		return false
	return current_weapon.attachment_manager.equip_to_slot(att, slot_name)


## 从当前武器的指定槽位卸载配件，返回被卸下的实例（null = 失败）
func detach_attachment(slot_name: String) -> BaseAttachment:
	if not current_weapon or not current_weapon.attachment_manager:
		return null
	return current_weapon.attachment_manager.detach_from_slot(slot_name)


## 查询当前武器所有槽位状态，供改装 UI 渲染列表
## 每项 Dictionary: { slot_name, slot_type, is_occupied, attachment_name, attachment_config }
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
			"is_occupied": slot.is_occupied,
			"attachment_name": slot.current_attachment.config.attachment_name if slot.is_occupied else "",
			"attachment_config": slot.current_attachment.config if slot.is_occupied else null,
		})
	return result


## 返回当前武器配置中允许的槽位类型列表（基于 supports_* 字段）
func get_supported_slot_types() -> Array[AttachmentSlot.SlotType]:
	if not current_weapon or not current_weapon.config:
		return []
	return current_weapon.config.get_allowed_slot_types()


# ============================================================
# 内部信号回调
# ============================================================

func _on_weapon_attachment_equipped(slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	var slot_name: String = slot.slot_name if slot.slot_name != "" else String(slot.name)
	attachment_equipped.emit(slot_name, attachment.config.attachment_name)
	_apply_ads_state()


func _on_weapon_attachment_detached(slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	var slot_name: String = slot.slot_name if slot.slot_name != "" else String(slot.name)
	attachment_detached.emit(slot_name)
	_apply_ads_state()

