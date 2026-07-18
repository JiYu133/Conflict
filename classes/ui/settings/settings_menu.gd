class_name SettingsMenu
extends CanvasLayer

# ============================================================
# 设置菜单（ESC 打开）—— 键位重绑定面板
# 功能：类似 Minecraft 控制设置的键位面板。列出全部可重绑定动作，
#       点击键位 → 监听下一个按键 → 覆盖绑定；实时冲突检测；
#       支持单项/全部恢复默认；关闭时持久化到 user://keybinds.cfg。
# 用法：由 BasePlayer 在 _initialize_subsystems() 中创建并 initialize(player)。
#       BasePlayer 打开菜单期间让出全部输入（见 base_player._input）。
# 设计：纯代码构建（与项目其他 UI 一致）；扁平、克制、单一强调色，
#       细描边、留白充足；ConflictCJKUI 字体。
# ============================================================

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"

# 配色（扁平·克制·单一强调色）──────────────────────────────
const COL_BACKDROP   := Color(0, 0, 0, 0.72)
const COL_PANEL      := Color(0.086, 0.098, 0.118, 0.98)
const COL_BORDER     := Color(1, 1, 1, 0.07)
const COL_ACCENT     := Color(0.85, 0.72, 0.20)      # 游戏统一金色
const COL_ACCENT_DIM := Color(0.85, 0.72, 0.20, 0.16)
const COL_TEXT       := Color(0.92, 0.93, 0.95)
const COL_MUTED      := Color(0.55, 0.58, 0.63)
const COL_KEYCAP     := Color(0.16, 0.17, 0.20)
const COL_KEYCAP_HL  := Color(0.22, 0.23, 0.27)
const COL_DANGER     := Color(0.90, 0.36, 0.33)
const COL_DANGER_DIM := Color(0.90, 0.36, 0.33, 0.14)
const COL_ROW_HOVER  := Color(1, 1, 1, 0.035)

var _player: BasePlayer = null
var _open: bool = false
var _was_controllable: bool = false

var _listening_action: String = ""
var _listen_button: Button = null
var _listen_frame: int = 0
var _pulse_tween: Tween = null

var _theme: Theme = null
var _panel: PanelContainer = null
var _rows_container: VBoxContainer = null
var _warning_label: Label = null
# action → 键位按钮 / 行容器，供刷新与冲突高亮
var _key_buttons: Dictionary = {}
var _rows: Dictionary = {}


func initialize(player: BasePlayer) -> void:
	_player = player


func is_open() -> bool:
	return _open


func _ready() -> void:
	layer = 20
	# 启动时套用已保存的键位覆盖（KeybindStore 幂等）
	KeybindStore.apply_saved()
	_build_theme()
	_build_ui()
	visible = false


# ── 开关 ────────────────────────────────────────────────────

func open() -> void:
	if _open:
		return
	_open = true
	visible = true
	if _player:
		_was_controllable = _player.controllable
		_player.set_controllable(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_refresh_all()


func close() -> void:
	if not _open:
		return
	_cancel_listening()
	KeybindStore.save_all()
	_open = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if _player:
		# 死亡玩家保持不可控（与 FreeCameraController / MedicalDebugMenu 一致）
		_player.set_controllable(_was_controllable and _player.is_alive)


# ── 输入：菜单在打开或监听时独占 ESC 与按键捕获 ──────────────

func _input(event: InputEvent) -> void:
	# 监听中：捕获下一个按键/鼠标键作为新绑定
	if _listening_action != "":
		_handle_listen_input(event)
		return

	if event.is_action_pressed("ui_cancel"):
		if _open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()


func _handle_listen_input(event: InputEvent) -> void:
	# 忽略进入监听那一帧的残留事件（点击键帽的鼠标释放等）
	if Engine.get_process_frames() == _listen_frame:
		return

	# ESC 取消监听（不绑定 ESC，保留给菜单）
	if event is InputEventKey and event.pressed and not event.echo \
			and (event as InputEventKey).physical_keycode == KEY_ESCAPE:
		_cancel_listening()
		get_viewport().set_input_as_handled()
		return

	var new_event: InputEvent = null
	if event is InputEventKey and event.pressed and not event.echo:
		new_event = event
	elif event is InputEventMouseButton and event.pressed:
		var btn := (event as InputEventMouseButton).button_index
		# 滚轮不作为可绑定键（留给姿态微调等连续输入）
		if btn != MOUSE_BUTTON_WHEEL_UP and btn != MOUSE_BUTTON_WHEEL_DOWN:
			new_event = event

	if new_event:
		KeybindStore.rebind_action(_listening_action, new_event.duplicate())
		_cancel_listening()
		_refresh_all()
		get_viewport().set_input_as_handled()


# ── 主题与样式 ───────────────────────────────────────────────

func _build_theme() -> void:
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 15


func _flat_box(bg: Color, border: Color, radius: int, border_w: int = 1) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_border_width_all(border_w)
	s.border_color = border
	s.set_corner_radius_all(radius)
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s


# ── UI 构建 ──────────────────────────────────────────────────

func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = COL_BACKDROP
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP  # 拦截点击，防止穿透到游戏
	add_child(backdrop)

	_panel = PanelContainer.new()
	_panel.theme = _theme
	_panel.add_theme_stylebox_override("panel", _flat_box(COL_PANEL, COL_BORDER, 12))
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.custom_minimum_size = Vector2(600, 0)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	backdrop.add_child(_panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 26)
	_panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)

	_build_header(root)
	root.add_child(_divider())
	_build_scroll_list(root)
	_build_warning(root)
	root.add_child(_divider())
	_build_footer(root)


func _build_header(parent: Control) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)

	var titles := VBoxContainer.new()
	titles.add_theme_constant_override("separation", 2)
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(titles)

	var title := Label.new()
	title.text = "设置 · 控制"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "点击键位后按下新按键进行绑定 · ESC 关闭"
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(subtitle)


func _build_scroll_list(parent: Control) -> void:
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 360)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroll)

	_rows_container = VBoxContainer.new()
	_rows_container.add_theme_constant_override("separation", 4)
	_rows_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_rows_container)

	var current_category := ""
	for entry in KeybindStore.ACTIONS:
		if entry["category"] != current_category:
			current_category = entry["category"]
			_add_category_header(current_category)
		_add_keybind_row(entry)


func _add_category_header(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_ACCENT)
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 2)
	m.add_child(label)
	_rows_container.add_child(m)


func _add_keybind_row(entry: Dictionary) -> void:
	var action: String = entry["action"]

	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", _flat_box(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 8))
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	_rows_container.add_child(row)
	_rows[action] = row

	# 悬停高亮
	row.mouse_entered.connect(func(): _set_row_hover(row, true))
	row.mouse_exited.connect(func(): _set_row_hover(row, false))

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	row.add_child(hbox)

	var name_label := Label.new()
	name_label.text = entry["display"]
	name_label.add_theme_font_size_override("font_size", 15)
	name_label.add_theme_color_override("font_color", COL_TEXT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(name_label)

	var key_button := Button.new()
	key_button.custom_minimum_size = Vector2(190, 38)
	key_button.focus_mode = Control.FOCUS_NONE
	_style_keycap(key_button, false, false)
	key_button.pressed.connect(_on_keycap_pressed.bind(action))
	hbox.add_child(key_button)
	_key_buttons[action] = key_button

	var reset_button := Button.new()
	reset_button.text = "默认"
	reset_button.tooltip_text = "恢复此项默认键位"
	reset_button.custom_minimum_size = Vector2(58, 38)
	reset_button.focus_mode = Control.FOCUS_NONE
	_style_ghost(reset_button)
	reset_button.pressed.connect(_on_reset_row.bind(action))
	hbox.add_child(reset_button)


func _build_warning(parent: Control) -> void:
	_warning_label = Label.new()
	_warning_label.add_theme_font_size_override("font_size", 13)
	_warning_label.add_theme_color_override("font_color", COL_DANGER)
	_warning_label.visible = false
	parent.add_child(_warning_label)


func _build_footer(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	parent.add_child(row)

	var reset_all := Button.new()
	reset_all.text = "恢复全部默认"
	reset_all.custom_minimum_size = Vector2(0, 40)
	reset_all.focus_mode = Control.FOCUS_NONE
	_style_ghost(reset_all)
	reset_all.pressed.connect(_on_reset_all)
	row.add_child(reset_all)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)

	var done := Button.new()
	done.text = "完成"
	done.custom_minimum_size = Vector2(140, 40)
	done.focus_mode = Control.FOCUS_NONE
	_style_accent(done)
	done.pressed.connect(close)
	row.add_child(done)


func _divider() -> Control:
	var line := ColorRect.new()
	line.color = COL_BORDER
	line.custom_minimum_size = Vector2(0, 1)
	return line


# ── 按钮样式 ─────────────────────────────────────────────────

func _style_keycap(button: Button, listening: bool, conflict: bool) -> void:
	var bg := COL_KEYCAP
	var border := COL_BORDER
	var text := COL_TEXT
	if conflict:
		bg = COL_DANGER_DIM
		border = COL_DANGER
		text = COL_DANGER
	elif listening:
		bg = COL_ACCENT_DIM
		border = COL_ACCENT
		text = COL_ACCENT
	var normal := _flat_box(bg, border, 6)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", _flat_box(COL_KEYCAP_HL if not (listening or conflict) else bg, COL_ACCENT if not conflict else COL_DANGER, 6))
	button.add_theme_stylebox_override("pressed", normal)
	button.add_theme_stylebox_override("focus", normal)
	button.add_theme_color_override("font_color", text)
	button.add_theme_color_override("font_hover_color", text)
	button.add_theme_font_size_override("font_size", 14)


func _style_ghost(button: Button) -> void:
	var normal := _flat_box(Color(0, 0, 0, 0), COL_BORDER, 6)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", _flat_box(COL_ROW_HOVER, COL_MUTED, 6))
	button.add_theme_stylebox_override("pressed", normal)
	button.add_theme_stylebox_override("focus", normal)
	button.add_theme_color_override("font_color", COL_MUTED)
	button.add_theme_color_override("font_hover_color", COL_TEXT)


func _style_accent(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _flat_box(COL_ACCENT, COL_ACCENT, 6))
	var hover := _flat_box(COL_ACCENT.lightened(0.08), COL_ACCENT, 6)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", _flat_box(COL_ACCENT.darkened(0.08), COL_ACCENT, 6))
	button.add_theme_stylebox_override("focus", _flat_box(COL_ACCENT, COL_ACCENT, 6))
	button.add_theme_color_override("font_color", Color(0.08, 0.07, 0.02))
	button.add_theme_color_override("font_hover_color", Color(0.08, 0.07, 0.02))


func _set_row_hover(row: PanelContainer, hovered: bool) -> void:
	var bg := COL_ROW_HOVER if hovered else Color(0, 0, 0, 0)
	row.add_theme_stylebox_override("panel", _flat_box(bg, Color(0, 0, 0, 0), 8))


# ── 交互回调 ─────────────────────────────────────────────────

func _on_keycap_pressed(action: String) -> void:
	if _listening_action == action:
		_cancel_listening()
		return
	_cancel_listening()  # 切换到新的监听目标
	_listening_action = action
	_listen_button = _key_buttons[action]
	_listen_frame = Engine.get_process_frames()
	_listen_button.text = "▶ 按下按键…"
	_style_keycap(_listen_button, true, false)
	_start_pulse(_listen_button)


func _cancel_listening() -> void:
	if _listening_action == "":
		return
	_stop_pulse()
	var action := _listening_action
	_listening_action = ""
	_listen_button = null
	_refresh_row(action)


func _on_reset_row(action: String) -> void:
	_cancel_listening()
	KeybindStore.reset_action(action)
	_refresh_all()


func _on_reset_all() -> void:
	_cancel_listening()
	KeybindStore.reset_all()
	_refresh_all()


# ── 刷新与冲突高亮 ───────────────────────────────────────────

func _refresh_all() -> void:
	var any_conflict := false
	for entry in KeybindStore.ACTIONS:
		if _refresh_row(entry["action"]):
			any_conflict = true
	if _warning_label:
		_warning_label.visible = any_conflict
		if any_conflict:
			_warning_label.text = "⚠ 存在按键冲突（红色标记）——同一按键被多个动作占用"


## 刷新单行显示与冲突样式；返回该行是否冲突。
func _refresh_row(action: String) -> bool:
	if action == _listening_action:
		return false  # 监听中，保持提示文本
	var button: Button = _key_buttons.get(action, null)
	if not button:
		return false
	var conflict := not KeybindStore.find_conflicts(action).is_empty()
	button.text = KeybindStore.describe_action(action)
	_style_keycap(button, false, conflict)
	return conflict


# ── 监听脉冲动画 ─────────────────────────────────────────────

func _start_pulse(button: Button) -> void:
	_stop_pulse()
	_pulse_tween = create_tween().set_loops()
	_pulse_tween.tween_property(button, "modulate:a", 0.45, 0.5).set_trans(Tween.TRANS_SINE)
	_pulse_tween.tween_property(button, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)


func _stop_pulse() -> void:
	if _pulse_tween and _pulse_tween.is_valid():
		_pulse_tween.kill()
	_pulse_tween = null
	if _listen_button:
		_listen_button.modulate.a = 1.0
