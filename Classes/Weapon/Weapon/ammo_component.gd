class_name AmmoComponent
extends Node

# ============================================================
# 弹药管理组件
# 功能：管理所有弹匣库存、膛内弹药状态、托弹板推送逻辑。
#       每个弹匣是一个 Array，内部元素为 null（标准弹）或 BulletData（自定义弹种）。
# 依赖：WeaponConfig（需要 magazine_capacity / reserve_magazines 等）
# 信号：由 BaseWeapon 消费，驱动空仓挂机和换弹逻辑
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal last_round_fired()
## 当前弹匣最后一发已打完




signal bolt_hold_open_requested()##！！！    预留接口
##bolt_hold_open_requested` 
##信号是**故意的预留接口**，
##代码里目前没显式 `emit` 或连它，
##是给后续"拉机柄挂机"系统留的钩子——比如步枪打空后让拉机柄挂在后面、
##玩家按键（`L`）手动释放闭锁时让其他模块（动画/音效/UI）订阅响应






## 向枪机请求空仓挂机（由 BaseWeapon 判断是否允许挂起）
signal ammo_count_changed(current: int, reserve: int)
## 弹药数量变化通知，参数：弹匣余弹、备用弹匣总弹（含膛内）

# 公开属性 ────────────────────────────────────────────────
var config: WeaponConfig                    # 武器配置引用
var magazines: Array[Array] = []            # 所有弹匣的数组，magazines[i] = 第 i 个弹匣的子弹列表
var current_magazine: int = 0               # 当前在用的弹匣索引
var chambered_round: bool = false           # 枪膛内是否有子弹
var _next_round_ready: bool = false         # 托弹板是否已将下一发顶到进弹位置（等待枪机复进抓取）


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg

	# 创建弹匣池
	# 总弹匣数 = 枪上在用的 1 个 + 备用弹匣 reserve_magazines 个
	for i in range(cfg.reserve_magazines + 1):
		var mag = []
		for j in range(cfg.magazine_capacity):
			mag.append(null)  # null 表示标准弹（后续可扩展为 BulletData 实例）
		magazines.append(mag)

	current_magazine = 0
	chambered_round = false

	print("AmmoComponent 初始化完成")


# ============================================================
# 状态查询
# ============================================================

## 是否有弹药可用（膛内子弹或弹匣内有弹）
func has_ammo() -> bool:
	if chambered_round:
		return true
	if current_magazine < magazines.size():
		return magazines[current_magazine].size() > 0
	return false

## 膛内是否有未击发的子弹
func has_chambered_round() -> bool:
	return chambered_round

## 下一发是否已送到进弹位置（等待枪机复进推入膛）
func is_next_round_ready() -> bool:
	return _next_round_ready


# ============================================================
# 弹药消耗与供给
# ============================================================

## 消耗一发子弹
## 优先级：先消耗膛内弹 → 膛内无弹时从弹匣顶部取一发
func consume_round() -> void:
	if chambered_round:
		chambered_round = false
		ammo_count_changed.emit(get_current_magazine_count(), get_reserve_count())
		return
	if current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		magazines[current_magazine].pop_front()
		ammo_count_changed.emit(get_current_magazine_count(), get_reserve_count())
		if magazines[current_magazine].size() == 0:
			last_round_fired.emit()  # 通知外部：弹匣空了

## 当前弹匣余弹
func get_current_magazine_count() -> int:
	if current_magazine < magazines.size():
		return magazines[current_magazine].size()
	return 0

## 备用弹匣总弹数（不含当前在用的弹匣）
func get_reserve_count() -> int:
	var total = 0
	for i in magazines.size():
		if i == current_magazine:
			continue
		total += magazines[i].size()
	return total

## 将弹匣顶部的子弹顶到进弹位置
## 这一步只是"准备好"，真正进膛要等枪机复进时调用 chamber_round()
func prepare_next_round() -> void:
	if current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		_next_round_ready = true

## 将准备好的子弹推入枪膛
## 优先从 _next_round_ready 取（同时把子弹实体从弹匣中弹出，避免"膛内有弹但弹匣数不变"造成无限弹药）
## 回退到直接从弹匣顶取
func chamber_round() -> void:
	if _next_round_ready:
		chambered_round = true
		_next_round_ready = false
		# 弹匣顶端的子弹在 prepare_next_round() 时已对准进弹位，
		# 现在被推入膛内，必须从数组里移除，否则弹匣计数永远不变
		if current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
			magazines[current_magazine].pop_front()
			ammo_count_changed.emit(get_current_magazine_count(), get_reserve_count())
	elif current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		chambered_round = true
		magazines[current_magazine].pop_front()
		ammo_count_changed.emit(get_current_magazine_count(), get_reserve_count())


# ============================================================
# 空仓挂机与换弹
# ============================================================

## 判断是否需要空仓挂机
## 条件：弹匣无弹 + 膛内无弹 + 武器配置支持空仓挂机
func should_hold_open() -> bool:
	return not has_ammo() and config.has_last_round_hold_open

## 切换弹匣
## 优先级：找第一个有子弹的弹匣；若都为空则保持当前索引（由空仓挂机流程接管）
## 同时清空膛内弹状态：新弹匣的顶弹在 reload() 流程中由 prepare_next_round()/chamber_round() 重新进膛
func swap_magazine() -> void:
	chambered_round = false
	_next_round_ready = false

	for i in magazines.size():
		var idx = (current_magazine + 1 + i) % magazines.size()
		if magazines[idx].size() > 0:
			current_magazine = idx
			return

	# 所有弹匣都空：保持在原索引（弹匣计数仍为 0，触发空仓挂机）
	current_magazine = current_magazine % magazines.size()

## 应用弹匣附件的容量加成（在 attachment_manager 初始化完成后调用）
## 入参：am = 所属武器的 AttachmentManager，从中读取扩容弹匣的额外容量
## 处理：所有弹匣追加 extra_capacity 发子弹（用 null 填充标准弹）
func apply_magazine_attachments(am: AttachmentManager) -> void:
	if not am:
		return
	var bonus = am.get_total_magazine_capacity_bonus()
	if bonus <= 0:
		return
	for i in magazines.size():
		for j in range(bonus):
			magazines[i].append(null)
	print("[Ammo] 弹匣附件扩容 +%d（当前容量 %d）" % [bonus, config.magazine_capacity + bonus])

## 获取指定索引的弹匣余弹
func get_magazine_count(idx: int) -> int:
	if idx >= 0 and idx < magazines.size():
		return magazines[idx].size()
	return 0

## 计算总剩余弹药数（所有弹匣 + 膛内）
func get_total_remaining() -> int:
	var total = 0
	for mag in magazines:
		total += mag.size()
	if chambered_round:
		total += 1
	return total
