extends CanvasLayer

signal notification_shown(notification_id: StringName)
signal notification_dismissed(notification_id: StringName)

@export var config: TopRightNotificationConfig

const DEFAULT_CONFIG_PATH := "res://res/config/ui/top_right_notification_config_default.tres"

var _stack: VBoxContainer
var _entries: Dictionary[StringName, TopRightNotificationEntry] = {}
var _cards: Dictionary[StringName, TopRightNotificationCard] = {}
var _queue: Array[TopRightNotificationEntry] = []


func _ready() -> void:
	layer = 10
	if not config:
		config = load(DEFAULT_CONFIG_PATH) as TopRightNotificationConfig
	if not config:
		config = TopRightNotificationConfig.new()
	_build_layout()
	_show_startup_notifications.call_deferred()


func _show_startup_notifications() -> void:
	# Autoloads become ready before the main scene. Waiting here prevents all slide
	# tweens from completing behind the loading screen.
	while not get_tree().current_scene:
		await get_tree().process_frame
	await get_tree().process_frame
	if config.startup_delay > 0.0:
		await get_tree().create_timer(config.startup_delay).timeout
	for entry in config.startup_notifications:
		register_notification(entry)
		if entry.visible:
			show_notification(entry)
			# Finish this bar's complete slide before allowing the next one to start.
			var sequence_wait := config.slide_in_duration + config.startup_gap
			if sequence_wait > 0.0:
				await get_tree().create_timer(sequence_wait).timeout


## Registers an entry without displaying it. Registered entries can later be toggled by ID.
func register_notification(entry: TopRightNotificationEntry) -> void:
	if not entry:
		return
	_ensure_id(entry)
	_entries[entry.notification_id] = entry


## Displays or updates a resource-defined notification.
func show_notification(entry: TopRightNotificationEntry) -> void:
	if not entry:
		return
	register_notification(entry)
	entry.visible = true
	if _cards.has(entry.notification_id):
		_cards[entry.notification_id].refresh()
		_sort_cards()
		return
	_remove_from_queue(entry.notification_id)
	if _cards.size() >= config.max_visible_notifications:
		_queue.append(entry)
		_sort_queue()
		return
	_spawn_card(entry)


## Convenience API for runtime gameplay messages such as malfunctions or medical instructions.
func show_text(
	notification_id: StringName,
	text: String,
	symbol: String = "",
	icon: Texture2D = null,
	display_order: int = 0,
	duration: float = 4.0
) -> TopRightNotificationEntry:
	var entry := TopRightNotificationEntry.new()
	entry.notification_id = notification_id
	entry.text = text
	entry.symbol = symbol
	entry.icon = icon
	entry.display_order = display_order
	entry.duration = duration
	show_notification(entry)
	return entry


## Shows or hides one registered notification without affecting the others.
func set_notification_visible(notification_id: StringName, should_be_visible: bool) -> void:
	var entry: TopRightNotificationEntry = _entries.get(notification_id)
	if not entry:
		return
	entry.visible = should_be_visible
	if should_be_visible:
		show_notification(entry)
	else:
		dismiss_notification(notification_id)


func dismiss_notification(notification_id: StringName) -> void:
	_remove_from_queue(notification_id)
	if _cards.has(notification_id):
		_cards[notification_id].play_exit()


func dismiss_all() -> void:
	_queue.clear()
	for card in _cards.values():
		card.play_exit()


func _build_layout() -> void:
	var margin := MarginContainer.new()
	margin.name = "TopRightNotificationArea"
	margin.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	margin.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	margin.grow_vertical = Control.GROW_DIRECTION_END
	margin.offset_left = -config.card_width - config.margin_right
	margin.offset_right = -config.margin_right
	margin.offset_top = config.margin_top
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)

	_stack = VBoxContainer.new()
	_stack.name = "NotificationStack"
	_stack.add_theme_constant_override("separation", config.card_spacing)
	_stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(_stack)


func _spawn_card(entry: TopRightNotificationEntry) -> void:
	var card := TopRightNotificationCard.new()
	card.setup(entry, config)
	card.dismissed.connect(_on_card_dismissed)
	_cards[entry.notification_id] = card
	_stack.add_child(card)
	_sort_cards()
	card.play_enter()
	notification_shown.emit(entry.notification_id)


func _on_card_dismissed(notification_id: StringName) -> void:
	_cards.erase(notification_id)
	notification_dismissed.emit(notification_id)
	_drain_queue()


func _drain_queue() -> void:
	while _cards.size() < config.max_visible_notifications and not _queue.is_empty():
		var next: TopRightNotificationEntry = _queue.pop_front()
		if next.visible:
			_spawn_card(next)


func _sort_cards() -> void:
	var sorted_cards: Array = _cards.values()
	sorted_cards.sort_custom(func(a: TopRightNotificationCard, b: TopRightNotificationCard):
		return a.entry.display_order < b.entry.display_order
	)
	for index in sorted_cards.size():
		_stack.move_child(sorted_cards[index], index)


func _sort_queue() -> void:
	_queue.sort_custom(func(a: TopRightNotificationEntry, b: TopRightNotificationEntry):
		return a.display_order < b.display_order
	)


func _remove_from_queue(notification_id: StringName) -> void:
	for index in range(_queue.size() - 1, -1, -1):
		if _queue[index].notification_id == notification_id:
			_queue.remove_at(index)


func _ensure_id(entry: TopRightNotificationEntry) -> void:
	if entry.notification_id.is_empty():
		entry.notification_id = StringName("notification_%d" % entry.get_instance_id())
