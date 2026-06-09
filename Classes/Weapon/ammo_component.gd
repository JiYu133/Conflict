class_name AmmoComponent
extends Node

signal last_round_fired()
signal bolt_hold_open_requested()
signal ammo_count_changed(current: int, reserve: int)

var config: WeaponConfig
var magazines: Array[Array] = []
var current_magazine: int = 0
var chambered_round: bool = false
var _next_round_ready: bool = false

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	# 初始化弹匣，每个弹匣填充指定数量的子弹（默认普通弹）
	for i in range(cfg.reserve_magazines + 1):
		var mag = []
		for j in range(cfg.magazine_capacity):
			mag.append(null)  # null 表示标准弹
		magazines.append(mag)
	current_magazine = 0
	chambered_round = false
	print("AmmoComponent 初始化完成")

func has_ammo() -> bool:
	if chambered_round:
		return true
	if current_magazine < magazines.size():
		return magazines[current_magazine].size() > 0
	return false

func has_chambered_round() -> bool:
	return chambered_round

func consume_round() -> void:
	if chambered_round:
		chambered_round = false
		return
	if current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		magazines[current_magazine].pop_front()
		if magazines[current_magazine].size() == 0:
			last_round_fired.emit()

func prepare_next_round() -> void:
	if current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		_next_round_ready = true

func chamber_round() -> void:
	if _next_round_ready:
		chambered_round = true
		_next_round_ready = false
	elif current_magazine < magazines.size() and magazines[current_magazine].size() > 0:
		chambered_round = true

func should_hold_open() -> bool:
	return not has_ammo() and config.has_last_round_hold_open

func swap_magazine() -> void:
	# 【已实现】简化弹匣轮换，TODO: 真正选择有弹的弹匣
	current_magazine += 1
	if current_magazine >= magazines.size():
		current_magazine = 0

func get_total_remaining() -> int:
	var total = 0
	for mag in magazines:
		total += mag.size()
	if chambered_round:
		total += 1
	return total
