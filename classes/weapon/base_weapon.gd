class_name BaseWeapon
extends Node3D

# ============================================================
# 武器基类
# 功能：所有枪械的根节点。管理子组件的生命周期、自动循环时序、
#       击发逻辑、换弹流程，以及各信号的路由分发。
# 用法：
#   1. 在场景中实例化 BaseWeapon 子类（或直接附加此脚本）
#   2. 准备好 WeaponConfig 资源（.tres）
#   3. 调用 initialize(cfg) 完成组件创建与配置
# ============================================================

# ============================================================
# 信号
# ============================================================
signal fired()
## 击发（子弹出膛）
signal bolt_moving(position: float)
## 枪机位置变化，参数：0.0（闭锁）~ 1.0（全开），用于驱动枪机动画
signal bolt_locked()
## 枪机闭锁（完成自动循环后触发）
signal bolt_hold_open()
## 空仓挂机激活（枪机被锁定在后方）
signal round_chambered()
## 子弹已推入枪膛




signal magazine_changed(mag_index: int)
##`magazine_changed` 
##也是给外部订阅用的钩子：UI 显示"当前在用第 N 个弹匣"、
##音效模块播弹匣切换音、动画模块触发退弹匣动作等等。




## 弹匣已更换
signal ammo_depleted()
## 所有弹药耗尽（尝试击发但无弹可用）
signal reload_started()
## 开始换弹
signal reload_countdown_started(duration: float)
## 本次换弹倒计时开始。duration 为实际仍需执行的总时长（秒）。
## 独立于分段动画信号，供 HUD 等只关心整体进度的系统使用。
signal reload_stage_started(stage: int, duration: float)
## 换弹阶段开始（stage 见 BaseWeapon.ReloadStage，duration 为该段时长）。
## 动画/音效接口：监听此信号播放对应片段即可，无需关心换弹内部流程。
signal reload_stage_finished(stage: int)
## 换弹阶段结束
signal reload_interrupted(completed_stages: Array)
## 换弹被打断，参数为已完成的阶段列表（下次换弹会跳过这些阶段）
signal reload_finished()
## 换弹完成
signal ejection(case_position: Vector3, case_velocity: Vector3)
## 抛壳，参数：弹壳弹出位置、弹壳初速度
signal fire_mode_changed(mode: String)
## 射击模式切换
signal malfunction_occurred(type: BoltComponent.JamType)
## 发生故障（哑火/烟囱卡弹/双上膛），供 UI/音效/动画订阅
signal malfunction_cleared()
## 故障排除完成


# ============================================================
# 公开属性
# ============================================================
var config: WeaponConfig                       # 武器配置
var current_fire_mode: String = "safe"         # 当前射击模式

# 枪机循环状态 ──────────────────────────────
var is_cycling: bool = false
## 枪机是否处于自动循环中（正在后坐或复进）
var cycle_phase: String = "idle"
## 当前阶段：idle（空闲）/ delay（导气延时）/ moving_back（后坐）/ moving_forward（复进）
var cycle_timer: float = 0.0
## 阶段计时器，用于 delay 阶段的倒计时
var bolt_position: float = 0.0
## 枪机位置：0.0 = 前方闭锁位，1.0 = 后方全开位

var trigger_held: bool = false                 # 扳机是否被按住（连发时需要）
## 当前这组点射还剩几发未打（不含已击发的首发）
var _burst_remaining: int = 0
## 本轮换弹中已完成的阶段（被打断后保留，下次换弹跳过；完整走完后清空）
var _reload_done_stages: Array = []
var is_reloading: bool = false                 # 是否正在换弹


# ============================================================
# 子组件引用
# ============================================================
var bolt_component: BoltComponent
## 枪机组件：处理开锁→后座→复进→闭锁的完整循环
var ammo_component: AmmoComponent
## 弹药组件：管理弹匣库存、膛内弹状态、托弹推送
var fire_control: FireControlComponent
## 击发控制组件：扳机状态、阻铁释放、保险逻辑
var gas_component: GasComponent
## 导气组件：计算导气孔到枪机的延时
var recoil_component: RecoilComponent
## 后座组件：枪口上跳角度和回正
var ejection_component: EjectionComponent
## 抛壳组件：弹壳抛出位置和速度
var malfunction_component: MalfunctionComponent
var fx_controller: WeaponFXController
## 开火表现控制器：抛壳刚体、枪口焰、枪口动态光照
## 故障/排障组件：聚合物理故障状态，协调排障流程
var attachment_manager: AttachmentManager
## 配件管理器：负责挂载瞄具/握把/枪口等


# ============================================================
# 组件初始化
# ============================================================

## 创建所有子组件的节点实例
## 顺序：枪机→弹药→击发→导气→后座→抛壳→配件
func _initialize_components() -> void:
	GlobalLogger.debug("BaseWeapon", "开始初始化武器部件")

	bolt_component = BoltComponent.new()
	bolt_component.name = "BoltComponent"
	add_child(bolt_component)

	ammo_component = AmmoComponent.new()
	ammo_component.name = "AmmoComponent"
	add_child(ammo_component)

	fire_control = FireControlComponent.new()
	fire_control.name = "FireControl"
	add_child(fire_control)

	gas_component = GasComponent.new()
	gas_component.name = "GasComponent"
	add_child(gas_component)

	recoil_component = RecoilComponent.new()
	recoil_component.name = "RecoilComponent"
	add_child(recoil_component)

	ejection_component = EjectionComponent.new()
	ejection_component.name = "EjectionComponent"
	add_child(ejection_component)

	malfunction_component = MalfunctionComponent.new()
	malfunction_component.name = "MalfunctionComponent"
	add_child(malfunction_component)

	# 开火表现（抛壳/枪口焰/枪口光照）：订阅 ejection 与 fired 信号
	fx_controller = WeaponFXController.new()
	fx_controller.name = "FXController"
	add_child(fx_controller)

	# 配件管理器：会在 _setup_from_config 之后初始化（需要先有 config）
	attachment_manager = AttachmentManager.new()
	attachment_manager.name = "AttachmentManager"
	add_child(attachment_manager)

## 将 WeaponConfig 注入到每个子组件
func _setup_from_config() -> void:
	GlobalLogger.debug("BaseWeapon", "=== " + config.weapon_name + " 组件初始化 ===")
	bolt_component.initialize(config)
	ammo_component.initialize(config)
	fire_control.initialize(config)
	gas_component.initialize(config)
	recoil_component.initialize(config, attachment_manager)
	ejection_component.initialize(config)
	malfunction_component.initialize(config, bolt_component, ejection_component, ammo_component)
	fx_controller.initialize(self, config.fx_config)

## 连接子组件的信号到本类的回调
## 这样 BaseWeapon 成为信号总线的中心控制器
func _connect_internal_signals() -> void:
	fire_control.trigger_pulled.connect(_on_trigger_pulled)
	fire_control.burst_started.connect(_on_burst_started)
	fire_control.trigger_released.connect(_on_trigger_released)
	bolt_component.cycle_completed.connect(_on_cycle_completed)
	bolt_component.bolt_reached_rear.connect(_on_bolt_reached_rear)
	ammo_component.last_round_fired.connect(_on_last_round_fired)
	ammo_component.bolt_hold_open_requested.connect(_on_bolt_hold_open_requested)
	bolt_component.jammed.connect(_on_bolt_jammed)
	malfunction_component.malfunction_occurred.connect(func(t): malfunction_occurred.emit(t))
	malfunction_component.malfunction_cleared.connect(func(): malfunction_cleared.emit())


# ============================================================
# 公开接口
# ============================================================

## 完整初始化流程：创建组件 → 注入配置 → 连接信号
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	current_fire_mode = _resolve_initial_fire_mode()
	_initialize_components()
	_setup_from_config()
	_connect_internal_signals()
	# 让配件管理器扫描本节点下的所有 AttachmentSlot
	# 这样玩家后续调用 equip_to_slot() 才能找到槽位
	attachment_manager.initialize(self, self)
	attachment_manager.attachment_equipped.connect(_on_attachment_equipped)
	attachment_manager.attachment_detached.connect(_on_attachment_detached)
	attachment_manager.attachments_changed.connect(_on_attachment_cache_changed)
	# 初始时无配件，capacity bonus 为 0；attachments_changed 会在装/卸配件后重算
	ammo_component.apply_magazine_attachments(attachment_manager)
	fire_control.set_fire_mode(current_fire_mode)


func _resolve_initial_fire_mode() -> String:
	if not config or config.fire_modes.is_empty():
		return "safe"
	if config.fire_modes.has(config.default_fire_mode):
		return config.default_fire_mode
	return config.fire_modes[0]


## 返回武器本体加当前已装备配件的总重量（kg）。
func get_total_weight() -> float:
	if not config:
		return 0.0
	return maxf(config.weight, 0.0) + (attachment_manager.get_total_attachment_weight() if attachment_manager else 0.0)


func has_chambered_round() -> bool:
	return ammo_component != null and ammo_component.has_chambered_round()


func get_current_magazine_count() -> int:
	return ammo_component.get_current_magazine_count() if ammo_component else 0


func get_reserve_ammo_count() -> int:
	return ammo_component.get_reserve_count() if ammo_component else 0

## 按下扳机
func press_trigger() -> void:
	if not config or not config.logic_enabled:
		return
	if not _check_required_attachments():
		return
	trigger_held = true
	fire_control.press_trigger()

## 松开扳机
func release_trigger() -> void:
	trigger_held = false
	if not config or not config.logic_enabled:
		return
	fire_control.release_trigger()


## 释放空仓挂机枪机，由武器协调弹药、枪机和循环状态。
func release_bolt() -> bool:
	if not bolt_component or not bolt_component.is_held_open():
		return false
	if not ammo_component or not ammo_component.has_ammo():
		return false
	ammo_component.prepare_next_round()
	bolt_component.release_bolt()
	is_cycling = true
	cycle_phase = "moving_forward"
	bolt_position = 1.0
	bolt_component.on_bolt_start_forward()
	return true


## 武器级配件门面：所有装卸请求统一从这里进入。
func equip_attachment(slot_name: String, cfg: AttachmentConfig) -> bool:
	if not attachment_manager or not cfg:
		return false
	var att := AttachmentFactory.create(cfg, self)
	if not att:
		return false
	if attachment_manager.equip_to_slot(att, slot_name):
		return true
	att.queue_free()
	return false


func equip_attachment_auto(cfg: AttachmentConfig) -> bool:
	if not attachment_manager or not cfg:
		return false
	var slot := attachment_manager.find_first_available_slot_for(cfg)
	return slot != null and equip_attachment(slot.get_slot_key(), cfg)


func detach_attachment(slot_name: String) -> BaseAttachment:
	if not attachment_manager:
		return null
	return attachment_manager.detach_from_slot(slot_name)


func set_attachment_rail_offset(slot_name: String, offset: float) -> void:
	if attachment_manager:
		attachment_manager.set_rail_offset(slot_name, offset)


func get_attachment_rail_offset(slot_name: String) -> float:
	return attachment_manager.get_rail_offset(slot_name) if attachment_manager else 0.0

## 调试用：直接设置弹匣/备用弹/膛内弹，并可将枪机恢复到可击发状态。
## 不清除故障；misfire / stovepipe / double-feed 仍需走排障流程。
func debug_set_ammo_state(current_mag_count: int, reserve_rounds: int, chambered: bool = true, release_bolt: bool = true) -> void:
	if not ammo_component:
		return
	ammo_component.debug_set_ammo(current_mag_count, reserve_rounds, chambered)
	if not release_bolt or not bolt_component:
		return

	is_cycling = false
	cycle_phase = "idle"
	cycle_timer = 0.0
	bolt_position = 0.0
	bolt_component.debug_force_locked()
	bolt_moving.emit(bolt_position)


## 调试用：补满弹药并保留在武器门面内，避免外部系统直接操作 AmmoComponent。
func debug_refill_ammo() -> void:
	if ammo_component:
		ammo_component.refill_all()

## 执行换弹
##
## 三种情况分别处理：
## 1. 战术换弹（膛内有弹）→ 只换弹匣，不碰枪机
## 2. 空仓换弹（弹匣打空，枪机被挂起）→ 换弹匣 + 释放枪机 + 复进推弹
## 3. 非空仓换弹（弹匣空了但枪机没被挂起，边缘情况）→ 换弹匣 + 手动上膛
func reload() -> void:
	if not config or not config.logic_enabled:
		return
	if _get_attachment_config_of_type(MagazineConfig) == null:
		GlobalLogger.warn("BaseWeapon", "[%s] 未装弹匣，无法换弹" % config.weapon_name)
		return
	if is_reloading or is_cycling:
		return

	is_reloading = true
	reload_started.emit()

	# 换弹时间从已装弹匣配件读取，未装弹匣时使用安全默认值
	var mag_cfg := _get_attachment_config_of_type(MagazineConfig) as MagazineConfig
	var tactical := ammo_component.has_chambered_round()

	# 分段换弹：拔弹匣 → 插弹匣 →（空仓时）拉机柄。
	# 每段开始时发 reload_stage_started，动画/音效按阶段挂接即可；
	# 弹匣配件未提供分段时长时回退到整段计时，行为与旧版一致。
	#
	# 断点续做：已完成的阶段记录在 _reload_done_stages 中。换弹被打断后
	# 再次按 R 会跳过做完的阶段——弹匣已经拔出来了就不必再拔一次。
	var staged := _staged_reload_times(mag_cfg, tactical)
	if staged.is_empty():
		var reload_t  := mag_cfg.reload_time       if mag_cfg else 4.0
		var reload_et := mag_cfg.reload_empty_time if mag_cfg else 5.0
		var whole_duration: float = reload_t if tactical else reload_et
		reload_countdown_started.emit(whole_duration)
		if not await _run_reload_stage(ReloadStage.WHOLE, whole_duration):
			return
	else:
		reload_countdown_started.emit(_remaining_reload_duration(staged))
		for entry in staged:
			var stage: ReloadStage = entry["stage"]
			if _reload_done_stages.has(stage):
				continue  # 该阶段此前已完成，跳过
			if not await _run_reload_stage(stage, entry["time"]):
				return

	if ammo_component.has_chambered_round():
		# 战术换弹：膛内有弹 → 只换弹匣，不动枪机
		ammo_component.swap_magazine()

	elif bolt_component.is_held_open():
		# 空仓换弹：换弹匣后释放枪机，由复进过程自然推弹入膛
		ammo_component.swap_magazine()
		ammo_component.prepare_next_round()  # 把弹匣顶端的弹喂到进弹位置
		bolt_component.release_bolt()
		# 关键：手动启动复进前必须把 is_cycling 置为 true，
		# 否则 _update_cycle() 入口判断直接 return，枪机永远到不了 0，
		# bolt_component.is_locked() 一直 false，后续 _fire_one_round() 被拒绝击发
		is_cycling = true
		cycle_phase = "moving_forward"
		bolt_position = 1.0  # 从全开位开始复进
		bolt_component.on_bolt_start_forward()

	else:
		# 非空仓换弹（边缘情况）：换弹匣后手动上膛
		ammo_component.swap_magazine()
		ammo_component.chamber_round()

	is_reloading = false
	_reload_done_stages.clear()   # 本次换弹完整走完，进度归零
	reload_finished.emit()


## 中断当前换弹。已完成的阶段会被保留，下次换弹从断点继续。
## 供后续"换弹中被打断"的玩法逻辑调用（受击 / 切枪 / 冲刺等）。
func interrupt_reload() -> void:
	if not is_reloading:
		return
	is_reloading = false
	reload_interrupted.emit(_reload_done_stages.duplicate())
	GlobalLogger.debug("BaseWeapon", "换弹被打断，已完成阶段: %s" % str(_reload_done_stages))


## 换弹阶段。WHOLE 为无分段配置时的回退（等价旧版单段等待）。
enum ReloadStage { WHOLE, MAG_OUT, MAG_IN, CHARGE }


## 组装分段时长表；三段全为 0 视为"未配置分段"，返回空数组走回退路径。
## tactical = 膛内有弹（战术换弹），无需拉机柄。
func _staged_reload_times(mag_cfg: MagazineConfig, tactical: bool) -> Array:
	if not mag_cfg:
		return []
	var out := mag_cfg.stage_mag_out_time
	var into := mag_cfg.stage_mag_in_time
	var charge := 0.0 if tactical else mag_cfg.stage_charge_time
	if out <= 0.0 and into <= 0.0 and charge <= 0.0:
		return []
	var stages: Array = []
	if out > 0.0:
		stages.append({ "stage": ReloadStage.MAG_OUT, "time": out })
	if into > 0.0:
		stages.append({ "stage": ReloadStage.MAG_IN, "time": into })
	if charge > 0.0:
		stages.append({ "stage": ReloadStage.CHARGE, "time": charge })
	return stages


## 汇总本次仍未完成的分段时长，供整体换弹倒计时显示。
func _remaining_reload_duration(stages: Array) -> float:
	var duration := 0.0
	for entry in stages:
		var stage: ReloadStage = entry["stage"]
		if not _reload_done_stages.has(stage):
			duration += float(entry["time"])
	return duration


## 执行单个换弹阶段。返回 false 表示武器在等待期间失效，调用方应立即中止。
func _run_reload_stage(stage: ReloadStage, duration: float) -> bool:
	reload_stage_started.emit(stage, duration)
	await get_tree().create_timer(duration).timeout
	# 武器可能在换弹计时期间被卸下/释放
	if not is_instance_valid(self):
		return false
	# 中途被 interrupt_reload() 打断：不记录本阶段，也不继续后续阶段
	if not is_reloading:
		return false
	_reload_done_stages.append(stage)
	reload_stage_finished.emit(stage)
	return true


## 切换射击模式
## 按 config.fire_modes 列表的顺序循环
func cycle_fire_mode() -> bool:
	if not config or not config.logic_enabled:
		return false
	if not attachment_manager:
		return false
	var selector := attachment_manager.get_attachment_of_type(AttachmentConfig.AttachmentType.SELECTOR_SWITCH)
	if not selector or not selector.has_method("can_switch_fire_mode") or not selector.can_switch_fire_mode():
		return false
	var modes = config.fire_modes
	if modes.size() == 0:
		return false

	var idx = modes.find(current_fire_mode)
	idx = (idx + 1) % modes.size()
	current_fire_mode = modes[idx]
	if not fire_control.set_fire_mode(current_fire_mode):
		return false
	if selector.has_method("on_fire_mode_changed"):
		selector.on_fire_mode_changed(current_fire_mode)
	fire_mode_changed.emit(current_fire_mode)
	return true


func _on_attachment_equipped(_slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	if attachment.config and attachment.config.attachment_type == AttachmentConfig.AttachmentType.SELECTOR_SWITCH:
		if attachment.has_method("on_fire_mode_changed"):
			attachment.on_fire_mode_changed(current_fire_mode)
	_apply_attachment_change(attachment.config, true)


func _on_attachment_detached(_slot: AttachmentSlot, attachment: BaseAttachment) -> void:
	if attachment:
		_apply_attachment_change(attachment.config, false)


## 只更新受变更配件影响的底层组件。
func _apply_attachment_change(attachment_cfg: AttachmentConfig, equipped: bool) -> void:
	if not attachment_cfg:
		return
	var script : Script = attachment_cfg.get_script()
	if script == BarrelConfig:
		var barrel := attachment_cfg as BarrelConfig
		if equipped:
			gas_component.reconfigure(barrel)
			ejection_component.reconfigure(barrel)
			bolt_component.set_muzzle_velocity(barrel.muzzle_velocity)
		else:
			var current_barrel := _get_attachment_config_of_type(BarrelConfig) as BarrelConfig
			if current_barrel:
				_apply_attachment_change(current_barrel, true)
	if script == BoltCarrierConfig:
		var bolt := attachment_cfg as BoltCarrierConfig
		if equipped:
			bolt_component.reconfigure(bolt)
			ejection_component.reconfigure_bolt(bolt)
			malfunction_component.reconfigure_bolt(bolt)
		else:
			var current_bolt := _get_attachment_config_of_type(BoltCarrierConfig) as BoltCarrierConfig
			if current_bolt:
				_apply_attachment_change(current_bolt, true)
	if script == MagazineConfig:
		if equipped:
			ammo_component.reconfigure(attachment_cfg as MagazineConfig)
		else:
			ammo_component.clear_magazine()
	if script == BarrelConfig or script == BoltCarrierConfig:
		bolt_component.configure_cycle_rate(config.cycle_rate, gas_component.get_delay_time(), 0.005)
	if recoil_component:
		recoil_component.rebuild_physics()

## 获取当前散布值
## 区分腰射和机瞄，返回武器基础散布 + 所有附件的散布修正
func get_current_spread(is_ads: bool) -> float:
	var base = config.ads_spread if is_ads else config.hipfire_spread
	if attachment_manager:
		base += attachment_manager.get_total_spread_modifier(is_ads)
	return base


## 获取实际生效的 ADS FOV（配件瞄具优先，回退 config 字段，再回退 -1）
func get_effective_fov_override() -> float:
	if attachment_manager:
		var fov := attachment_manager.get_fov_override()
		if fov > 0.0:
			return fov
	return config.ads_fov_override if config else -1.0


## 获取实际生效的 ADS 时间（含配件瞄准速度修正，修正值为负 = 更快）
func get_effective_ads_time() -> float:
	if not config:
		return 0.25
	var t := config.ads_time
	if attachment_manager:
		t += attachment_manager.get_total_ads_speed_modifier()
	return max(t, 0.05)


## 返回当前武器数值快照，供改装 UI 装前/装后对比
func get_stats_snapshot() -> Dictionary:
	if not config:
		return {}
	var physics := recoil_component.get_physics_snapshot() if recoil_component else {}
	return {
		"spread_ads": get_current_spread(true),
		"spread_hip": get_current_spread(false),
		# UI-facing values are physical angular-speed impulse magnitudes per shot.
		"recoil_v": absf(rad_to_deg(physics.get("pitch_impulse_rad_s", 0.0))),
		"recoil_h": absf(rad_to_deg(physics.get("yaw_impulse_rad_s", 0.0))),
		"recoil_impulse_ns": physics.get("impulse_magnitude_ns", 0.0),
		"recoil_mass_kg": physics.get("total_mass_kg", 0.0),
		"recoil_recovery_stiffness": physics.get("control_stiffness", 0.0),
		"recoil_recovery_damping": physics.get("control_damping", 0.0),
		"ads_time": get_effective_ads_time(),
		"weight": get_total_weight(),
		"suppressed": attachment_manager.suppresses_sound() if attachment_manager else false,
		"fov_override": get_effective_fov_override(),
	}


# ============================================================
# 自动循环（核心逻辑）
# ============================================================

func _process(delta: float) -> void:
	if recoil_component:
		recoil_component.set_control_multiplier(_get_control_multiplier())
	_update_cycle(delta)

## 枪机自动循环状态机
##
## 完整循环顺序：
##   idle → delay（导气延时）→ moving_back（枪机后坐）
##   → bolt_reached_rear（抛壳+推弹准备）→ moving_forward（枪机复进）
##   → bolt_position <= 0.0（推弹入膛+闭锁）→ idle
##
## 闭锁后检查是否应继续连发或空仓挂机
func _update_cycle(delta: float) -> void:
	if not is_cycling:
		return

	match cycle_phase:
		"delay":
			# 导气延时阶段：等待火药燃气从导气孔传到活塞
			cycle_timer -= delta
			if cycle_timer <= 0.0:
				_start_bolt_back()

		"moving_back":
			# 枪机后坐阶段：枪机被活塞推着向后，压缩复进簧
			bolt_position += bolt_component.bolt_speed_open * delta
			bolt_moving.emit(bolt_position)
			if bolt_position >= 1.0:
				bolt_position = 1.0
				# 必须先离开 moving_back 再发信号：_on_bolt_reached_rear() 里有
				# await（等 5ms 再复进），期间 _update_cycle 仍在跑，
				# 若相位不变则下一帧 bolt_position 又 >= 1.0，会重复抛壳。
				# 表现为每次射击弹出 2~3 枚弹壳（帧率越高越多）。
				cycle_phase = "at_rear"
				bolt_component.bolt_reached_rear.emit()

		"at_rear":
			# 到位等待：由 _on_bolt_reached_rear() 的延时回调切到 moving_forward
			pass

		"moving_forward":
			# 枪机复进阶段：复进簧推着枪机向前回位
			bolt_position -= bolt_component.bolt_speed_close * delta
			bolt_moving.emit(bolt_position)

			# 烟囱卡弹检测：弹壳卡在抛壳口时枪机被阻停在中途（约 30% 行程处）
			if ejection_component.is_case_stuck() and bolt_position <= 0.3:
				bolt_position = 0.3
				is_cycling = false
				cycle_phase = "idle"
				malfunction_component.trigger_stovepipe()
				return

			if bolt_position <= 0.0:
				bolt_position = 0.0

				# 推弹入膛：枪机完全闭锁瞬间，子弹从进弹位置进入枪膛
				if ammo_component.is_next_round_ready():
					ammo_component.chamber_round()
					round_chambered.emit()

				# 双上膛检测：抛壳失败（弹壳卡住）且枪机仍完成了复进 → 两发卡死
				# 条件：ejection 标记弹壳卡住，但 bolt 没在 0.3 处被拦住（极端情况）
				if ejection_component.is_case_stuck():
					is_cycling = false
					cycle_phase = "idle"
					# 检查 double_feed_chance 决定是否升级为双上膛
					var bolt_cfg := _get_attachment_config_of_type(BoltCarrierConfig) as BoltCarrierConfig
					var dfc := bolt_cfg.double_feed_chance if bolt_cfg else 0.0
					if dfc > 0.0 and randf() < dfc:
						malfunction_component.trigger_double_feed()
					else:
						malfunction_component.trigger_stovepipe()
					return

				cycle_phase = "idle"
				is_cycling = false
				bolt_component.cycle_completed.emit()
				_handle_cycle_complete()

## 触发枪机后坐
func _start_bolt_back() -> void:
	cycle_phase = "moving_back"
	bolt_component.on_bolt_start_back()

## 触发枪机复进
## 注意：调用方需要先确保 is_cycling = true，并把 bolt_position 设为 1.0（全开位）
## 本函数只负责"切换状态名 + 通知组件"，不负责初始化循环上下文
func _start_bolt_forward() -> void:
	cycle_phase = "moving_forward"
	bolt_component.on_bolt_start_forward()

## 自动循环完成后的收尾检查
##
## 两个关键判断（互斥，所以顺序无关但都要检查）：
##   - 连发模式下扳机仍按住且有弹 → 继续开火
##   - 弹匣已空且武器支持空仓挂机 → 挂起枪机
##
## 注意：连发续火和空仓挂机在"有弹/无弹"上互斥，
## 膛内有弹+弹匣有弹 = 续火；膛内无弹+弹匣空 = 挂机。
## 两种状态不会同时进入，但都需要在闭锁后立刻检查。
func _handle_cycle_complete() -> void:
	if ammo_component.should_hold_open():
		# 优先处理空仓挂机：把弹匣打空后无论什么模式都要停火
		bolt_component.hold_open()
		bolt_hold_open.emit()
		return

	if not ammo_component.has_ammo():
		return

	if current_fire_mode == "auto" and trigger_held:
		_fire_one_round()
	elif current_fire_mode == "burst" and _burst_remaining > 0:
		# 点射：不看 trigger_held，一组打满为止（断续器行为）
		_burst_remaining -= 1
		_fire_one_round()

## 一组点射开始：装填本组剩余发数（首发由 trigger_pulled 直接打出，故 -1）
func _on_burst_started() -> void:
	var count: int = config.burst_count if config else 3
	_burst_remaining = maxi(count - 1, 0)


## 单次开火
##
## 前置条件（三个必须同时满足）：
##   1. 枪机不在运动中（is_cycling = false）
##   2. 不在换弹中（is_reloading = false）
##   3. 有弹药可用（has_ammo）
##   4. 枪机已闭锁（is_locked）
func _fire_one_round() -> void:
	if is_cycling or is_reloading:
		return
	if not ammo_component.has_ammo():
		return
	if not bolt_component.is_locked():
		return

	ammo_component.consume_round()

	# 哑火判定：底火有概率不响，弹留在膛内，枪机不启动循环
	var barrel_cfg := _get_attachment_config_of_type(BarrelConfig) as BarrelConfig
	var misfire := barrel_cfg.misfire_chance if barrel_cfg else 0.0
	if misfire > 0.0 and randf() < misfire:
		malfunction_component.trigger_misfire()
		return

	# 启动自动循环
	is_cycling = true
	cycle_phase = "delay"
	cycle_timer = gas_component.get_delay_time()
	bolt_position = 0.0

	# 发射弹丸（P1 hitscan）
	_spawn_projectile()

	fired.emit()
	recoil_component.apply_recoil(_get_control_multiplier())


## 计算射手控枪系数；只改变弹簧刚度/阻尼，不改变单发冲量
func _get_control_multiplier() -> float:
	var mult := 1.0
	# 向上找到所属 BasePlayer
	var node: Node = self
	while node and not (node is BasePlayer):
		node = node.get_parent()
	if not node:
		return mult
	var player := node as BasePlayer
	# ADS 提高控枪刚度
	if player.weapon_manager and player.weapon_manager.is_aiming:
		mult *= 1.35
	# 蹲姿提高控枪稳定性
	if player.stance_controller:
		mult *= lerp(1.0, 1.2, player.stance_controller.get_stance_value())
	# 体力/伤情降低控枪能力
	if player.health_system:
		var stability := player.health_system.get_aim_stability_multiplier()
		mult *= max(stability, 0.1)
	return mult


## 发射弹丸
## 弹道模拟和 hitscan 都从枪口位置沿枪口轴线发射；摄像机不参与弹道计算。
func _spawn_projectile() -> void:
	var world := get_world_3d()
	if not world:
		GlobalLogger.warn("BaseWeapon", "Cannot get World3D, projectile not fired")
		return

	var exclusions := _collect_shooter_exclusions()

	# 弹道参数（初速/弹头质量/弹道系数）已迁移到枪管配件，
	# 从已装 BarrelConfig 读取；没装枪管时不应该走到这里（_check_required_attachments 已拦），
	# 仍做空值保护以防被其他路径调用。
	var barrel := _get_attachment_config_of_type(BarrelConfig) as BarrelConfig
	if not barrel:
		GlobalLogger.warn("BaseWeapon", "[%s] 未装枪管，无法计算弹道" % config.weapon_name)
		return

	var muzzle := _get_muzzle_position()
	var shot_dir := _get_muzzle_direction()

	if config and config.use_ballistic_simulation:
		BallisticProjectileSystem.get_or_create(get_tree()).spawn(
			muzzle, shot_dir, barrel, self, exclusions, world
		)
	else:
		Projectile.fire_hitscan(muzzle, shot_dir, barrel, self, world, exclusions)


## 枪口世界坐标（武器局部 -Z 方向延伸 weapon_length）
func _get_muzzle_position() -> Vector3:
	var muzzle_marker := find_child("Muzzle", true, false) as Node3D
	if muzzle_marker:
		return muzzle_marker.global_position
	var muzzle_offset: float = config.weapon_length if config else 0.7
	return global_position + global_basis.z * -muzzle_offset


## 枪口方向完全由枪口 Marker 的 -Z 轴决定；没有 Marker 时使用武器根节点 -Z 轴。
func _get_muzzle_direction() -> Vector3:
	var muzzle_marker := find_child("Muzzle", true, false) as Node3D
	if muzzle_marker:
		return (-muzzle_marker.global_basis.z).normalized()
	return (-global_basis.z).normalized()


## 收集射手自身的物理 RID（胶囊体 + 全部 BodyHitbox），
## 供枪口起点的射线排除，防止射线命中自己的身体/手臂 hitbox
func _collect_shooter_exclusions() -> Array[RID]:
	var rids: Array[RID] = []
	var node: Node = self
	while node and node is not BasePlayer:
		node = node.get_parent()
	if node:
		var player := node as BasePlayer
		rids.append(player.get_rid())
		if player.health_system:
			rids.append_array(player.health_system.get_hitbox_rids())
	return rids


# ============================================================
# 信号回调（由子组件信号触发）
# ============================================================

## 扳机扣下 → 尝试击发
func _on_trigger_pulled() -> void:
	if is_reloading:
		return
	# 有未排除的故障时拒绝击发（哑火后膛内仍有弹，必须先排障）
	if malfunction_component and malfunction_component.has_malfunction():
		return
	if not ammo_component.has_ammo():
		ammo_depleted.emit()
		return
	if bolt_component.is_held_open():
		return
	if not bolt_component.is_locked():
		return
	_fire_one_round()

## 扳机松开
func _on_trigger_released() -> void:
	pass

## 自动循环完成 → 通知外部闭锁
func _on_cycle_completed() -> void:
	bolt_locked.emit()

## 枪机到达后方 → 尝试抛壳 + 准备下一发
func _on_bolt_reached_rear() -> void:
	var eject_pos = ejection_component.get_ejection_position()
	var eject_vel = ejection_component.get_ejection_velocity()

	# 物理抛壳：有概率失败（烟囱/双上膛的前兆）
	var ejected := ejection_component.attempt_eject()
	if ejected:
		ejection.emit(eject_pos, eject_vel)

	# 准备下一发（无论抛壳是否成功都推弹，双上膛就在这里产生）
	if ammo_component.has_ammo():
		ammo_component.prepare_next_round()

	await get_tree().create_timer(0.005).timeout
	if not is_instance_valid(self):
		return
	_start_bolt_forward()

## 弹匣最后一发打完
## 当前为空实现，后续可添加弹药耗尽提示等效果
func _on_last_round_fired() -> void:
	# 空仓挂机逻辑由 _handle_cycle_complete() 统一处理
	pass

## 收到空仓挂机请求
## 【预期不可达】ammo_component.bolt_hold_open_requested 信号目前全库无 emit，
## 实际空仓挂机由 _handle_cycle_complete() → should_hold_open() 驱动。
## 此回调保留为后续"拉机柄挂机"系统的预留接口。
func _on_bolt_hold_open_requested() -> void:
	if config.has_last_round_hold_open:
		bolt_component.hold_open()
		bolt_hold_open.emit()

## 枪机卡弹（BoltComponent.jammed 信号转发）
func _on_bolt_jammed(_type: BoltComponent.JamType) -> void:
	# 故障已由 malfunction_component 广播，此处可额外记录日志
	pass


# ============================================================
# 排障公开接口
# ============================================================

## 玩家每次按排障键调用一次。
## 每次调用推进一步排障流程（多步故障需要多次调用）。
func attempt_malfunction_clearance() -> void:
	if not config or not config.logic_enabled:
		return
	if not malfunction_component or not malfunction_component.has_malfunction():
		return
	var cleared := malfunction_component.attempt_clearance()
	if cleared:
		_restore_after_clearance()

## 排障完成后恢复枪机到可击发状态
func _restore_after_clearance() -> void:
	is_cycling = false
	cycle_phase = "idle"
	bolt_position = 0.0
	# 若膛内无弹且弹匣有弹，重新推弹入膛（双上膛排障后 MalfunctionComponent 已处理此逻辑）
	if not ammo_component.has_chambered_round() and ammo_component.has_ammo():
		ammo_component.prepare_next_round()
		ammo_component.chamber_round()


# ============================================================
# 配件变更回调
# ============================================================

## AttachmentManager 先重建通用缓存，再在此处理扩容弹匣等派生数值。
func _on_attachment_cache_changed() -> void:
	if not ammo_component or not attachment_manager:
		return
	var mag := _get_attachment_config_of_type(MagazineConfig) as MagazineConfig
	if mag:
		var target_capacity := mag.magazine_capacity + attachment_manager.get_total_magazine_capacity_bonus()
		if ammo_component.get_capacity() != target_capacity:
			ammo_component.recalculate_capacity(mag.magazine_capacity, attachment_manager.get_total_magazine_capacity_bonus())


## 遍历所有已装配件，返回第一个 config 类型匹配的实例
## 用于从配件中提取 BarrelConfig / BoltCarrierConfig / MagazineConfig 等子类
func _get_attachment_config_of_type(type: Script) -> AttachmentConfig:
	for att in attachment_manager.get_all_attachments():
		if att.config and att.config.get_script() == type:
			return att.config
	return null


## 检查关键配件（枪管 + 弹匣）是否已装，缺失时拒绝击发
func _check_required_attachments() -> bool:
	if _get_attachment_config_of_type(BarrelConfig) == null:
		GlobalLogger.warn("BaseWeapon", "[%s] 缺少枪管配件，无法击发" % config.weapon_name)
		return false
	if _get_attachment_config_of_type(MagazineConfig) == null:
		GlobalLogger.warn("BaseWeapon", "[%s] 缺少弹匣配件，无法击发" % config.weapon_name)
		return false
	return true


## 从机匣及所有已装配件中递归查找 grip 节点。
## 多个同名 grip 时优先选择握把/护木挂载点，其次选择更靠前的节点。
func find_grip_node(grip_name: String) -> Node3D:
	var candidates: Array[Node3D] = []
	_collect_grip_nodes(self, grip_name, candidates)
	if candidates.is_empty():
		return null

	var best := candidates[0]
	var best_score := _grip_node_score(best)
	for i in range(1, candidates.size()):
		var score := _grip_node_score(candidates[i])
		if score > best_score:
			best = candidates[i]
			best_score = score
	return best


func _collect_grip_nodes(root: Node, grip_name: String, result: Array[Node3D]) -> void:
	for child in root.get_children():
		if String(child.name) == grip_name and child is Node3D:
			result.append(child as Node3D)
		if child.get_child_count() > 0:
			_collect_grip_nodes(child, grip_name, result)


func _grip_node_score(node: Node3D) -> float:
	var priority := 0.0
	var parent: Node = node
	while parent:
		if parent is AttachmentSlot:
			var slot := parent as AttachmentSlot
			if slot.slot_name == "PistolGrip":
				priority = 100.0
			elif slot.slot_type == AttachmentSlot.SlotType.PISTOL_GRIP:
				priority = 100.0
			elif slot.slot_name == "Underbarrel":
				priority = 90.0
			elif slot.slot_type == AttachmentSlot.SlotType.UNDERBARREL:
				priority = 90.0
			elif slot.slot_name == "Handguard":
				priority = 80.0
			elif slot.slot_type == AttachmentSlot.SlotType.HANDGUARD:
				priority = 80.0
		parent = parent.get_parent()

	var local_z := node.position.z
	if is_inside_tree():
		local_z = to_local(node.global_position).z
	return priority - local_z * 0.001
