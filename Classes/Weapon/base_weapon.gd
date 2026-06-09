class_name BaseWeapon
extends Node3D

# 信号
signal fired()
signal bolt_moving(position: float)
signal bolt_locked()
signal bolt_hold_open()
signal round_chambered()
signal magazine_changed(mag_index: int)
signal ammo_depleted()
signal reload_started()
signal reload_finished()
signal ejection(case_position: Vector3, case_velocity: Vector3)
signal fire_mode_changed(mode: String)

# 状态变量
var config: WeaponConfig 
var current_fire_mode: String = "semi" ## 当前的开火模式
var is_cycling: bool = false ## 枪机是否在运动?若在运动则无法进行击发
var cycle_phase: String = "idle" ## 枪机自动循环状态
var cycle_timer: float = 0.0 ## 枪机自动循环时间
var bolt_position: float = 0.0 ## 枪机位置 0.0 = 闭锁（前方），1.0 = 全开（后方）
var trigger_held: bool = false ## 按住扳机状态
var is_reloading: bool = false ## 战术换弹状态

# 组件引用
var bolt_component: BoltComponent ## 枪机组件:枪机 + 枪机框
var ammo_component: AmmoComponent ## 弹药组件:弹匣 + 托弹板 + 膛内弹药
var fire_control: FireControlComponent ## 击发控制组件:扳机 + 阻铁 + 击锤
var gas_component: GasComponent ## 导气组件:导气孔 + 导气管 + 活塞
var recoil_component: RecoilComponent ## 后座组件:枪口上跳 + 控枪
var ejection_component: EjectionComponent ## 抛壳组件:抛壳挺 + 抛壳窗


# 初始化枪械组件
func _initialize_components() -> void:
	print("开始初始化武器部件")
	bolt_component = BoltComponent.new()
	bolt_component.name = "BoltComponent"
	add_child(bolt_component)
	print("bolt_component 创建成功: ", bolt_component is BoltComponent)

	ammo_component = AmmoComponent.new()
	ammo_component.name = "AmmoComponent"
	add_child(ammo_component)
	print("ammo_component 创建成功: ", ammo_component is AmmoComponent)

	fire_control = FireControlComponent.new()
	fire_control.name = "FireControl"
	add_child(fire_control)
	print("fire_control 创建成功: ", fire_control is FireControlComponent)

	gas_component = GasComponent.new()
	gas_component.name = "GasComponent"
	add_child(gas_component)
	print("gas_component 创建成功: ", gas_component is GasComponent)
	
	recoil_component = RecoilComponent.new()
	recoil_component.name = "RecoilComponent"
	add_child(recoil_component)
	print("recoil_component 创建成功: ", recoil_component is RecoilComponent)

	ejection_component = EjectionComponent.new()
	ejection_component.name = "EjectionComponent"
	add_child(ejection_component)
	print("ejection_component 创建成功: ", ejection_component is EjectionComponent)

func _setup_from_config() -> void:
	print("=== " + config.weapon_name + "组件初始化 ===")
	bolt_component = BoltComponent.new()
	ammo_component = AmmoComponent.new()
	fire_control = FireControlComponent.new()
	gas_component = GasComponent.new()
	recoil_component = RecoilComponent.new()
	ejection_component = EjectionComponent.new()
	if bolt_component:
		bolt_component.initialize(config)
	else:
		print("bolt_component 为 null！")
	
	if ammo_component:
		ammo_component.initialize(config)
	else:
		print("ammo_component 为 null！")
	
	if fire_control:
		fire_control.initialize(config)
	else:
		print("fire_control 为 null！")
	
	if gas_component:
		gas_component.initialize(config)
	else:
		print("gas_component 为 null！")
	
	if recoil_component:
		recoil_component.initialize(config)
	else:
		print("recoil_component 为 null！")
	
	if ejection_component:
		ejection_component.initialize(config)
	else:
		print("ejection_component 为 null！")

func _connect_internal_signals() -> void:
	fire_control.trigger_pulled.connect(_on_trigger_pulled)
	fire_control.trigger_released.connect(_on_trigger_released)
	bolt_component.cycle_completed.connect(_on_cycle_completed)
	bolt_component.bolt_reached_rear.connect(_on_bolt_reached_rear)
	ammo_component.last_round_fired.connect(_on_last_round_fired)
	ammo_component.bolt_hold_open_requested.connect(_on_bolt_hold_open_requested)

# 公开接口

## 初始化枪械
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	_initialize_components()
	_setup_from_config()
	_connect_internal_signals()
	
## 按下扳机
func press_trigger() -> void:
	trigger_held = true
	fire_control.press_trigger(current_fire_mode)
## 松开扳机
func release_trigger() -> void:
	trigger_held = false
	fire_control.release_trigger()
## 战术换弹
func reload() -> void:
	# 检查换弹状态
	if is_reloading or is_cycling:
		return
	is_reloading = true
	reload_started.emit()
	var duration = config.reload_time if ammo_component.has_chambered_round() else config.reload_empty_time
	await get_tree().create_timer(duration).timeout
	if ammo_component.has_chambered_round():
		ammo_component.swap_magazine()
	else:
		ammo_component.swap_magazine()
		ammo_component.chamber_round()
		if bolt_component.is_held_open():
			bolt_component.release_bolt()
			_start_bolt_forward()
	is_reloading = false
	reload_finished.emit()

func cycle_fire_mode() -> void:
	var modes = config.fire_modes
	if modes.size() == 0:
		return
	# idx:当前射击模式在可选列表中的位置
	var idx = modes.find(current_fire_mode)
	idx = (idx + 1) % modes.size()
	current_fire_mode = modes[idx]
	fire_mode_changed.emit(current_fire_mode)

func get_current_spread(is_ads: bool) -> float:
	return config.ads_spread if is_ads else config.hipfire_spread

# 内部循环（自动原理）
func _process(delta: float) -> void:
	_update_cycle(delta)

func _update_cycle(delta: float) -> void:
	if not is_cycling:
		return
	match cycle_phase:
		"delay":
			cycle_timer -= delta
			if cycle_timer <= 0.0:
				_start_bolt_back()
		"moving_back":
			bolt_position += bolt_component.bolt_speed_open * delta
			bolt_moving.emit(bolt_position)
			if bolt_position >= 1.0:
				bolt_position = 1.0
				bolt_component.bolt_reached_rear.emit()
		"moving_forward":
			bolt_position -= bolt_component.bolt_speed_close * delta
			bolt_moving.emit(bolt_position)
			if bolt_position <= 0.0:
				bolt_position = 0.0
				cycle_phase = "idle"
				is_cycling = false
				bolt_component.cycle_completed.emit()
				_handle_cycle_complete()

func _start_bolt_back() -> void:
	cycle_phase = "moving_back"
	bolt_component.on_bolt_start_back()

func _start_bolt_forward() -> void:
	cycle_phase = "moving_forward"
	bolt_component.on_bolt_start_forward()

func _handle_cycle_complete() -> void:
	if current_fire_mode == "auto" and trigger_held and ammo_component.has_ammo():
		_fire_one_round()
	if ammo_component.should_hold_open():
		bolt_component.hold_open()
		bolt_hold_open.emit()

func _fire_one_round() -> void:
	if is_cycling or is_reloading:
		return
	if not ammo_component.has_ammo():
		return
	if not bolt_component.is_locked():
		return
	ammo_component.consume_round()
	is_cycling = true
	cycle_phase = "delay"
	cycle_timer = gas_component.get_delay_time()
	bolt_position = 0.0
	fired.emit()
	recoil_component.apply_recoil()

# 信号回调
func _on_trigger_pulled() -> void:
	if is_reloading:
		return
	if not ammo_component.has_ammo():
		ammo_depleted.emit()
		return
	if bolt_component.is_held_open():
		return
	if not bolt_component.is_locked():
		return
	_fire_one_round()

func _on_trigger_released() -> void:
	pass

func _on_cycle_completed() -> void:
	bolt_locked.emit()

func _on_bolt_reached_rear() -> void:
	var eject_pos = ejection_component.get_ejection_position()
	var eject_vel = ejection_component.get_ejection_velocity()
	ejection.emit(eject_pos, eject_vel)
	if ammo_component.has_ammo():
		ammo_component.prepare_next_round()
		round_chambered.emit()
	await get_tree().create_timer(0.005).timeout
	_start_bolt_forward()

func _on_last_round_fired() -> void:
	pass

func _on_bolt_hold_open_requested() -> void:
	if config.has_last_round_hold_open:
		bolt_component.hold_open()
		bolt_hold_open.emit()
		
