extends CanvasLayer

## 武器改装界面
## 视觉语言与设置页（settings_menu.gd）保持一致：同一套配色、同样的高斯模糊背景、
## 左侧分类 + 右侧内容的双栏布局。
##
## 对外接口（供后续正式流程接入，目前由 debug 按键打开）：
##   initialize(player)  绑定玩家
##   open() / close() / toggle() / is_open()
##   signal opened / closed
##
## 数据流：BaseWeapon.attachment_manager 提供槽位，AttachmentCatalog 提供可选配件，
## 安装走 AttachmentFactory.create() + attachment_manager.equip_to_slot()。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const BLUR_SHADER_PATH := "res://res/shaders/death_blur.gdshader"
const AttachmentCatalog = preload("res://classes/ui/weapon_mod/attachment_catalog.gd")
const ModText = preload("res://classes/ui/weapon_mod/weapon_mod_text.gd")

# 配色与设置页完全一致（见 settings_menu.gd）
const COL_BACKDROP := Color(0.0, 0.0, 0.0, 0.68)
const COL_PANEL := Color(0.063, 0.067, 0.075, 0.90)
const COL_SURFACE := Color(0.10, 0.106, 0.12, 0.76)
const COL_BORDER := Color(1.0, 1.0, 1.0, 0.11)
const COL_TEXT := Color(0.945, 0.953, 0.961)
const COL_MUTED := Color(0.61, 0.64, 0.68)
const COL_ACCENT := Color(0.55, 0.72, 0.90)
const COL_ACCENT_DIM := Color(0.55, 0.72, 0.90, 0.13)
const COL_DANGER := Color(0.84, 0.42, 0.39)
const COL_DANGER_DIM := Color(0.84, 0.42, 0.39, 0.12)
const COL_HOVER := Color(1.0, 1.0, 1.0, 0.055)

signal opened
signal closed

var _player
var _open := false
var _was_controllable := false
var _theme: Theme
var _background_blur_layer: CanvasLayer

var _active_slot_name := ""
var _slot_buttons: Dictionary = {}
var _slot_list: VBoxContainer
var _content_title: Label
var _content_subtitle: Label
var _content_rows: VBoxContainer
var _stat_rows: VBoxContainer
var _notice: Label


# ── 对外接口 ────────────────────────────────────────────────

func initialize(player) -> void:
	_player = player


func is_open() -> bool:
	return _open


func toggle() -> void:
	if _open:
		close()
	else:
		open()


func open() -> void:
	if _open:
		return
	_open = true
	visible = true
	if _background_blur_layer:
		_background_blur_layer.visible = true
	if _player:
		_was_controllable = _player.controllable
		_player.set_controllable(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_rebuild()
	opened.emit()


func close() -> void:
	if not _open:
		return
	_open = false
	visible = false
	if _background_blur_layer:
		_background_blur_layer.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if _player:
		# 死亡玩家保持不可控，与设置页/自由视角一致
		_player.set_controllable(_was_controllable and _player.is_alive)
	closed.emit()


# ── 生命周期 ────────────────────────────────────────────────

func _ready() -> void:
	layer = 22  # 高于设置页(21)与暂停菜单(20)
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 15
	_setup_background_blur()
	_build_ui()
	visible = false


func _exit_tree() -> void:
	if _background_blur_layer and is_instance_valid(_background_blur_layer):
		_background_blur_layer.queue_free()


func _input(event: InputEvent) -> void:
	if not _open:
		return
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


# ── 背景模糊（与设置页同一实现）──────────────────────────────

func _setup_background_blur() -> void:
	_background_blur_layer = CanvasLayer.new()
	_background_blur_layer.name = "WeaponModBackgroundBlurLayer"
	_background_blur_layer.layer = 18  # 位于本层之下、游戏画面之上
	_background_blur_layer.visible = false
	get_parent().add_child(_background_blur_layer)

	var blur := ColorRect.new()
	blur.name = "WeaponModBackgroundBlur"
	blur.set_anchors_preset(Control.PRESET_FULL_RECT)
	blur.color = Color.WHITE
	blur.modulate.a = 0.72
	blur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := load(BLUR_SHADER_PATH) as Shader
	if shader:
		var material := ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("blur_amount", 3.0)
		blur.material = material
	_background_blur_layer.add_child(blur)


# ── 布局 ────────────────────────────────────────────────────

func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = COL_BACKDROP
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var panel := PanelContainer.new()
	panel.theme = _theme
	panel.add_theme_stylebox_override("panel", _box(COL_PANEL, COL_BORDER, 4))
	panel.custom_minimum_size = Vector2(1080, 650)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	backdrop.add_child(panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 26)
	panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)

	_build_header(root)
	root.add_child(_divider())

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 24)
	root.add_child(body)
	_build_slot_sidebar(body)
	_build_content(body)
	_build_stat_panel(body)

	_notice = Label.new()
	_notice.add_theme_font_size_override("font_size", 13)
	_notice.add_theme_color_override("font_color", COL_DANGER)
	_notice.visible = false
	root.add_child(_notice)

	root.add_child(_divider())
	_build_footer(root)


func _build_header(parent: Control) -> void:
	var header := HBoxContainer.new()
	parent.add_child(header)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	titles.add_theme_constant_override("separation", 2)
	header.add_child(titles)

	var title := Label.new()
	title.text = ModText.TITLE
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(title)

	var subtitle := Label.new()
	subtitle.text = ModText.SUBTITLE
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(subtitle)


func _build_slot_sidebar(parent: Control) -> void:
	var side := VBoxContainer.new()
	side.custom_minimum_size = Vector2(240, 0)
	side.add_theme_constant_override("separation", 4)
	parent.add_child(side)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	side.add_child(scroll)

	_slot_list = VBoxContainer.new()
	_slot_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slot_list.add_theme_constant_override("separation", 4)
	scroll.add_child(_slot_list)


func _build_content(parent: Control) -> void:
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	parent.add_child(content)

	_content_title = Label.new()
	_content_title.add_theme_font_size_override("font_size", 18)
	_content_title.add_theme_color_override("font_color", COL_TEXT)
	content.add_child(_content_title)

	_content_subtitle = Label.new()
	_content_subtitle.add_theme_font_size_override("font_size", 13)
	_content_subtitle.add_theme_color_override("font_color", COL_MUTED)
	content.add_child(_content_subtitle)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)

	_content_rows = VBoxContainer.new()
	_content_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_rows.add_theme_constant_override("separation", 6)
	scroll.add_child(_content_rows)


func _build_stat_panel(parent: Control) -> void:
	var wrap := VBoxContainer.new()
	wrap.custom_minimum_size = Vector2(220, 0)
	wrap.add_theme_constant_override("separation", 8)
	parent.add_child(wrap)

	var header := Label.new()
	header.text = ModText.STAT_HEADER
	header.add_theme_font_size_override("font_size", 14)
	header.add_theme_color_override("font_color", COL_ACCENT)
	wrap.add_child(header)

	var box := PanelContainer.new()
	box.add_theme_stylebox_override("panel", _box(COL_SURFACE, COL_BORDER, 3))
	wrap.add_child(box)

	_stat_rows = VBoxContainer.new()
	_stat_rows.add_theme_constant_override("separation", 6)
	box.add_child(_stat_rows)


func _build_footer(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	parent.add_child(row)

	var hint := Label.new()
	hint.text = ModText.FOOTER_HINT
	hint.add_theme_font_size_override("font_size", 13)
	hint.add_theme_color_override("font_color", COL_MUTED)
	hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(hint)

	var close_button := Button.new()
	close_button.text = ModText.CLOSE
	close_button.custom_minimum_size = Vector2(132, 38)
	close_button.focus_mode = Control.FOCUS_NONE
	_style_button(close_button, false)
	close_button.pressed.connect(close)
	row.add_child(close_button)


# ── 数据刷新 ────────────────────────────────────────────────

func _current_weapon():
	if not _player or not _player.weapon_manager:
		return null
	return _player.weapon_manager.current_weapon


func _rebuild() -> void:
	_notice.visible = false
	for child in _slot_list.get_children():
		child.queue_free()
	_slot_buttons.clear()

	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		_content_title.text = ModText.NO_WEAPON
		_content_subtitle.text = ModText.NO_WEAPON_HINT
		_clear_rows()
		_refresh_stats()
		return

	var slots: Array = weapon.attachment_manager.get_slots()
	if slots.is_empty():
		_content_title.text = ModText.NO_SLOTS
		_content_subtitle.text = ""
		_clear_rows()
		_refresh_stats()
		return

	for slot in slots:
		_add_slot_button(slot as AttachmentSlot)

	# 保持当前选中槽位；失效则回到第一个
	var names := (slots.map(func(s): return (s as AttachmentSlot).get_slot_key()))
	if _active_slot_name == "" or not names.has(_active_slot_name):
		_active_slot_name = names[0]
	_select_slot(_active_slot_name)
	_refresh_stats()


func _add_slot_button(slot: AttachmentSlot) -> void:
	var key := slot.get_slot_key()
	var installed := slot.current_attachment
	var label := key
	var detail := ModText.SLOT_EMPTY
	if installed and installed.config:
		detail = installed.config.attachment_name

	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 46)
	button.focus_mode = Control.FOCUS_NONE
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.text = "%s\n%s" % [label, detail]
	button.autowrap_mode = TextServer.AUTOWRAP_OFF
	button.add_theme_font_size_override("font_size", 13)
	_style_slot_button(button, key == _active_slot_name)
	button.pressed.connect(func(): _select_slot(key))
	_slot_list.add_child(button)
	_slot_buttons[key] = button


func _select_slot(slot_name: String) -> void:
	_active_slot_name = slot_name
	_notice.visible = false
	for key in _slot_buttons:
		_style_slot_button(_slot_buttons[key], key == slot_name)

	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var slot: AttachmentSlot = weapon.attachment_manager.get_slot(slot_name)
	if not slot:
		return

	_content_title.text = slot_name
	var options := AttachmentCatalog.for_slot(slot)
	_content_subtitle.text = "%d 个可用配件" % options.size()
	_clear_rows()

	# 卸下当前配件
	if slot.current_attachment:
		if slot.can_be_empty:
			_add_action_row(ModText.DETACH, "", true, func(): _do_detach(slot_name))
		else:
			_add_action_row(ModText.SLOT_LOCKED, "", false, Callable())

	if options.is_empty():
		_add_info_row(ModText.LIST_EMPTY)
		return

	for cfg in options:
		var is_installed := slot.current_attachment != null \
			and slot.current_attachment.config == cfg
		_add_attachment_row(cfg, is_installed, slot_name)


func _add_attachment_row(cfg: AttachmentConfig, installed: bool, slot_name: String) -> void:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override(
		"panel", _box(COL_ACCENT_DIM if installed else COL_SURFACE,
			COL_ACCENT if installed else COL_BORDER, 3)
	)
	_content_rows.add_child(row)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	row.add_child(hbox)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 2)
	hbox.add_child(info)

	var name_label := Label.new()
	name_label.text = cfg.attachment_name
	name_label.add_theme_font_size_override("font_size", 15)
	name_label.add_theme_color_override("font_color", COL_ACCENT if installed else COL_TEXT)
	info.add_child(name_label)

	var stat_label := Label.new()
	stat_label.text = _describe_modifiers(cfg)
	stat_label.add_theme_font_size_override("font_size", 12)
	stat_label.add_theme_color_override("font_color", COL_MUTED)
	info.add_child(stat_label)

	var action := Button.new()
	action.text = ModText.INSTALLED if installed else "安装"
	action.custom_minimum_size = Vector2(96, 34)
	action.focus_mode = Control.FOCUS_NONE
	action.disabled = installed
	_style_button(action, not installed)
	if not installed:
		action.pressed.connect(func(): _do_equip(cfg, slot_name))
	hbox.add_child(action)


func _add_action_row(text: String, _detail: String, enabled: bool, on_press: Callable) -> void:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", _box(COL_DANGER_DIM, COL_DANGER, 3))
	_content_rows.add_child(row)

	var hbox := HBoxContainer.new()
	row.add_child(hbox)

	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", COL_DANGER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(label)

	if enabled and on_press.is_valid():
		var button := Button.new()
		button.text = "卸下"
		button.custom_minimum_size = Vector2(96, 34)
		button.focus_mode = Control.FOCUS_NONE
		_style_button(button, false)
		button.pressed.connect(on_press)
		hbox.add_child(button)


func _add_info_row(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_MUTED)
	_content_rows.add_child(label)


func _clear_rows() -> void:
	for child in _content_rows.get_children():
		child.queue_free()


# ── 改装操作 ────────────────────────────────────────────────

func _do_equip(cfg: AttachmentConfig, slot_name: String) -> void:
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var attachment := AttachmentFactory.create(cfg, weapon)
	if not attachment:
		_show_notice(ModText.EQUIP_FAILED % cfg.attachment_name)
		return
	if not weapon.attachment_manager.equip_to_slot(attachment, slot_name):
		attachment.queue_free()
		_show_notice(ModText.EQUIP_FAILED % cfg.attachment_name)
		return
	GlobalLogger.info("WeaponMod", "已安装 %s → %s" % [cfg.attachment_name, slot_name])
	_rebuild()


func _do_detach(slot_name: String) -> void:
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var removed = weapon.attachment_manager.detach_from_slot(slot_name)
	if removed:
		GlobalLogger.info("WeaponMod", "已卸下 %s" % slot_name)
	_rebuild()


func _show_notice(text: String) -> void:
	_notice.text = text
	_notice.visible = true


# ── 参数面板 ────────────────────────────────────────────────

func _refresh_stats() -> void:
	for child in _stat_rows.get_children():
		child.queue_free()
	var weapon = _current_weapon()
	if not weapon or not weapon.config:
		return
	var cfg: WeaponConfig = weapon.config
	var am = weapon.attachment_manager
	_add_stat(ModText.STAT_SPREAD_HIP, "%.2f°" % weapon.get_current_spread(false))
	_add_stat(ModText.STAT_SPREAD_ADS, "%.2f°" % weapon.get_current_spread(true))
	if am:
		_add_stat(ModText.STAT_RECOIL_V, "%.2f" % (cfg.recoil_vertical + am.get_total_recoil_vertical_modifier()))
		_add_stat(ModText.STAT_RECOIL_H, "%.2f" % (cfg.recoil_horizontal + am.get_total_recoil_horizontal_modifier()))
		_add_stat(ModText.STAT_WEIGHT, "%.2f kg" % (cfg.weight + am.get_total_attachment_weight()))
	else:
		_add_stat(ModText.STAT_RECOIL_V, "%.2f" % cfg.recoil_vertical)
		_add_stat(ModText.STAT_RECOIL_H, "%.2f" % cfg.recoil_horizontal)
		_add_stat(ModText.STAT_WEIGHT, "%.2f kg" % cfg.weight)


func _add_stat(label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	_stat_rows.add_child(row)
	var label := Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_MUTED)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	var value := Label.new()
	value.text = value_text
	value.add_theme_font_size_override("font_size", 13)
	value.add_theme_color_override("font_color", COL_TEXT)
	row.add_child(value)


## 生成配件数值摘要（只列非零项，负值=更优显示为绿色语义由文案体现）
func _describe_modifiers(cfg: AttachmentConfig) -> String:
	var parts: PackedStringArray = []
	if not is_zero_approx(cfg.hipfire_spread_modifier):
		parts.append("腰射 %+.2f" % cfg.hipfire_spread_modifier)
	if not is_zero_approx(cfg.ads_spread_modifier):
		parts.append("机瞄 %+.2f" % cfg.ads_spread_modifier)
	if not is_zero_approx(cfg.weight_kg):
		parts.append("重量 %+.2fkg" % cfg.weight_kg)
	if parts.is_empty():
		return "无数值修正"
	return " · ".join(parts)


# ── 样式（与设置页一致）──────────────────────────────────────

func _box(background: Color, border: Color, radius: int, border_width: int = 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 10
	box.content_margin_right = 10
	box.content_margin_top = 7
	box.content_margin_bottom = 7
	return box


func _divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.color = COL_BORDER
	divider.custom_minimum_size = Vector2(0, 1)
	return divider


func _style_button(button: Button, accent: bool) -> void:
	var bg := COL_ACCENT_DIM if accent else COL_SURFACE
	var border := COL_ACCENT if accent else COL_BORDER
	var text := COL_ACCENT if accent else COL_TEXT
	button.add_theme_stylebox_override("normal", _box(bg, border, 3))
	button.add_theme_stylebox_override("hover", _box(COL_HOVER, border, 3))
	button.add_theme_stylebox_override("pressed", _box(bg, border, 3))
	button.add_theme_stylebox_override("focus", _box(bg, border, 3))
	button.add_theme_stylebox_override("disabled", _box(COL_SURFACE, COL_BORDER, 3))
	button.add_theme_color_override("font_color", text)
	button.add_theme_color_override("font_hover_color", COL_TEXT)
	button.add_theme_color_override("font_disabled_color", COL_MUTED)
	button.add_theme_font_size_override("font_size", 13)


func _style_slot_button(button: Button, selected: bool) -> void:
	var bg := COL_ACCENT_DIM if selected else Color(0, 0, 0, 0)
	var border := COL_ACCENT if selected else COL_BORDER
	button.add_theme_stylebox_override("normal", _box(bg, border, 3))
	button.add_theme_stylebox_override("hover", _box(COL_HOVER, border, 3))
	button.add_theme_stylebox_override("pressed", _box(bg, border, 3))
	button.add_theme_stylebox_override("focus", _box(bg, border, 3))
	button.add_theme_color_override("font_color", COL_ACCENT if selected else COL_MUTED)
	button.add_theme_color_override("font_hover_color", COL_TEXT)
