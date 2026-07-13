extends CanvasLayer

## 按键提示显示配置。留空时自动加载默认配置文件
@export var config: KeyPromptConfig

const DEFAULT_CONFIG_PATH := "res://res/config/ui/key_prompt_config_default.tres"

var _active_cards: Array[KeyPromptCard] = []
var _queue: Array[KeyPromptEntry] = []
var _container: Control


func _ready() -> void:
	layer = 10

	if not config:
		if ResourceLoader.exists(DEFAULT_CONFIG_PATH):
			config = load(DEFAULT_CONFIG_PATH)
		else:
			config = KeyPromptConfig.new()

	_container = Control.new()
	_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_container)


# ── 公开 API ──────────────────────────────────────────────

## 显示单条按键提示
func show_prompt(entry: KeyPromptEntry) -> void:
	if _active_cards.size() < config.max_visible_cards:
		_spawn_card(entry)
	else:
		_queue.append(entry)


## 显示一批提示；自动按 sort_order 排序后逐一调用 show_prompt
func show_prompts(entries: Array) -> void:
	var sorted := entries.duplicate()
	sorted.sort_custom(func(a, b): return a.sort_order < b.sort_order)
	for e in sorted:
		show_prompt(e)


## 立即滑出所有可见卡片并清空队列
func dismiss_all() -> void:
	_queue.clear()
	for card in _active_cards.duplicate():
		card.play_exit()


# ── 内部逻辑 ──────────────────────────────────────────────

func _spawn_card(entry: KeyPromptEntry) -> void:
	var card := KeyPromptCard.new()
	card.setup(entry, config)

	# 找到按 sort_order 的插入位置
	var insert_idx := _active_cards.size()
	for i in _active_cards.size():
		if _active_cards[i]._entry.sort_order > entry.sort_order:
			insert_idx = i
			break

	_active_cards.insert(insert_idx, card)
	_container.add_child(card)

	# 先定位到正确的 Y，再播放滑入
	var viewport_size := get_viewport().get_visible_rect().size
	var card_x := viewport_size.x - 280.0 - config.margin_right  # 280 为默认宽度占位
	card.position = Vector2(card_x, _card_y_for_index(insert_idx))

	card.dismissed.connect(_on_card_dismissed.bind(card))
	card.play_enter()

	# 重排插入点之后的卡片
	_reposition_cards_from(insert_idx + 1)


func _on_card_dismissed(card: KeyPromptCard) -> void:
	_active_cards.erase(card)
	_reposition_all_cards()

	if _queue.is_empty():
		return
	var next: KeyPromptEntry = _queue.pop_front()
	_spawn_card(next)


func _reposition_all_cards() -> void:
	_reposition_cards_from(0)


func _reposition_cards_from(start_index: int) -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	for i in range(start_index, _active_cards.size()):
		var card := _active_cards[i]
		var new_y := _card_y_for_index(i)
		var card_x := viewport_size.x - card.size.x - config.margin_right
		if card.size.x > 0:
			card.position.x = card_x
		card.reposition_to(new_y)


func _card_y_for_index(index: int) -> float:
	# 估算卡片高度：icon_size + 2*padding
	var estimated_h := config.icon_size + config.card_padding * 2.0
	return config.margin_top + index * (estimated_h + config.card_spacing)
