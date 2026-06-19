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
signal reload_finished()
## 换弹完成
signal ejection(case_position: Vector3, case_velocity: Vector3)
## 抛壳，参数：弹壳弹出位置、弹壳初速度
signal fire_mode_changed(mode: String)
## 射击模式切换


# ============================================================
# 公开属性
# ============================================================
var config: WeaponConfig                       # 武器配置
var current_fire_mode: String = "semi"         # 当前射击模式

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
var attachment_manager: AttachmentManager
## 配件管理器：负责挂载瞄具/握把/枪口等


# ============================================================
# 组件初始化
# ============================================================

## 创建所有子组件的节点实例
## 顺序：枪机→弹药→击发→导气→后座→抛壳→配件
func _initialize_components() -> void:
	print("开始初始化武器部件")

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

	# 配件管理器：会在 _setup_from_config 之后初始化（需要先有 config）
	attachment_manager = AttachmentManager.new()
	attachment_manager.name = "AttachmentManager"
	add_child(attachment_manager)

## 将 WeaponConfig 注入到每个子组件
func _setup_from_config() -> void:
	print("=== " + config.weapon_name + "组件初始化 ===")
	bolt_component.initialize(config)
	ammo_component.initialize(config)
	fire_control.initialize(config)
	gas_component.initialize(config)
	recoil_component.initialize(config, attachment_manager)
	ejection_component.initialize(config)

## 连接子组件的信号到本类的回调
## 这样 BaseWeapon 成为信号总线的中心控制器
func _connect_internal_signals() -> void:
	fire_control.trigger_pulled.connect(_on_trigger_pulled)
	fire_control.trigger_released.connect(_on_trigger_released)
	bolt_component.cycle_completed.connect(_on_cycle_completed)
	bolt_component.bolt_reached_rear.connect(_on_bolt_reached_rear)
	ammo_component.last_round_fired.connect(_on_last_round_fired)
	ammo_component.bolt_hold_open_requested.connect(_on_bolt_hold_open_requested)


# ============================================================
# 公开接口
# ============================================================

## 完整初始化流程：创建组件 → 注入配置 → 连接信号
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	_initialize_components()
	_setup_from_config()
	_connect_internal_signals()
	# 让配件管理器扫描本节点下的所有 AttachmentSlot
	# 这样玩家后续调用 equip_to_slot() 才能找到槽位
	attachment_manager.initialize(self, self)
	# 弹匣容量 = 武器基础容量 + 扩容弹匣附件的额外容量
	# 【预期不可达】此处运行时尚无配件被装上（attachment_manager 只扫描了槽位），
	# 故当前 bonus 恒为 0；装/卸扩容弹匣后并未重新结算容量。补全该功能需在
	# equip_to_slot()/detach_from_slot() 后回调此函数，本轮不实现。
	ammo_component.apply_magazine_attachments(attachment_manager)

## 按下扳机
## 设置 trigger_held 后，连发模式会利用这个标志自动续火
func press_trigger() -> void:
	trigger_held = true
	fire_control.press_trigger(current_fire_mode)

## 松开扳机
func release_trigger() -> void:
	trigger_held = false
	fire_control.release_trigger()

## 执行换弹
##
## 三种情况分别处理：
## 1. 战术换弹（膛内有弹）→ 只换弹匣，不碰枪机
## 2. 空仓换弹（弹匣打空，枪机被挂起）→ 换弹匣 + 释放枪机 + 复进推弹
## 3. 非空仓换弹（弹匣空了但枪机没被挂起，边缘情况）→ 换弹匣 + 手动上膛
func reload() -> void:
	if is_reloading or is_cycling:
		return

	is_reloading = true
	reload_started.emit()

	# 根据膛内是否有弹选择换弹时长
	var duration = config.reload_time if ammo_component.has_chambered_round() else config.reload_empty_time
	await get_tree().create_timer(duration).timeout
	# 武器可能在换弹计时期间被卸下/释放，await 恢复后必须确认自身仍有效
	if not is_instance_valid(self):
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
	reload_finished.emit()

## 切换射击模式
## 按 config.fire_modes 列表的顺序循环
func cycle_fire_mode() -> void:
	var modes = config.fire_modes
	if modes.size() == 0:
		return

	var idx = modes.find(current_fire_mode)
	idx = (idx + 1) % modes.size()
	current_fire_mode = modes[idx]
	fire_mode_changed.emit(current_fire_mode)

## 获取当前散布值
## 区分腰射和机瞄，返回武器基础散布 + 所有附件的散布修正
func get_current_spread(is_ads: bool) -> float:
	var base = config.ads_spread if is_ads else config.hipfire_spread
	if attachment_manager:
		base += attachment_manager.get_total_spread_modifier(is_ads)
	return base


# ============================================================
# 自动循环（核心逻辑）
# ============================================================

func _process(delta: float) -> void:
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
				bolt_component.bolt_reached_rear.emit()

		"moving_forward":
			# 枪机复进阶段：复进簧推着枪机向前回位
			bolt_position -= bolt_component.bolt_speed_close * delta
			bolt_moving.emit(bolt_position)
			if bolt_position <= 0.0:
				bolt_position = 0.0

				# 推弹入膛：枪机完全闭锁瞬间，子弹从进弹位置进入枪膛
				if ammo_component.is_next_round_ready():
					ammo_component.chamber_round()
					round_chambered.emit()

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

	if current_fire_mode == "auto" and trigger_held and ammo_component.has_ammo():
		_fire_one_round()

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

	# 启动自动循环
	is_cycling = true
	cycle_phase = "delay"
	cycle_timer = gas_component.get_delay_time()
	bolt_position = 0.0

	fired.emit()
	recoil_component.apply_recoil()


# ============================================================
# 信号回调（由子组件信号触发）
# ============================================================

## 扳机扣下 → 尝试击发
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

## 扳机松开
func _on_trigger_released() -> void:
	pass

## 自动循环完成 → 通知外部闭锁
func _on_cycle_completed() -> void:
	bolt_locked.emit()

## 枪机到达后方 → 抛壳 + 准备下一发
func _on_bolt_reached_rear() -> void:
	# 抛壳
	var eject_pos = ejection_component.get_ejection_position()
	var eject_vel = ejection_component.get_ejection_velocity()
	ejection.emit(eject_pos, eject_vel)

	# 从弹匣推送下一发到进弹位置（弹底窝前端）
	if ammo_component.has_ammo():
		ammo_component.prepare_next_round()

	# 短暂停顿后开始复进（模拟托弹板上升/弹壳脱离的时间）
	await get_tree().create_timer(0.005).timeout
	# 武器可能在这 5ms 内被释放，await 恢复后必须确认自身仍有效
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
