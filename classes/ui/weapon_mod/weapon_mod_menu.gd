extends CanvasLayer

## 武器改装界面（军械档案 / Ordnance Dossier 风格）
##
## 布局：武器 3D 侧视图居中，各挂载点用贝塞尔引线牵引到左右两侧的槽位卡片；
## 点卡片展开该槽位的配件列表，安装/卸下即时反映到中央预览与底部数据条。
##
## 与 Delta Force / 塔科夫 的区别（JiYu 要求做出辨识度）：
##   · 引线是弯曲的贝塞尔曲线 + 挂载点圆环节点，不是散落的直线细线
##   · 卡片沿左右两条竖直"导轨"对齐排列，而不是绕枪身随意摆放
##   · 蓝图网格 + 四角取景括号，整体是"军械档案页"而非"商店货架"
##   · 数据条实时插值动画，改装的数值收益一眼可见
##
## 对外接口：initialize(player) / open() / close() / toggle() / is_open()
##           signal opened / closed

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const BLUR_SHADER_PATH := "res://res/shaders/death_blur.gdshader"
const AttachmentCatalog = preload("res://classes/ui/weapon_mod/attachment_catalog.gd")
const ModText = preload("res://classes/ui/weapon_mod/weapon_mod_text.gd")
const WeaponPreviewScript = preload("res://classes/ui/weapon_mod/weapon_preview.gd")
const CalloutLayerScript = preload("res://classes/ui/weapon_mod/weapon_callout_layer.gd")

# 配色沿用设置页
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
const COL_TOOLTIP_BG := Color(0.043, 0.047, 0.055, 0.98)

const CHIP_SIZE := Vector2(184, 52)
const CHIP_GAP := 12.0

signal opened
signal closed

var _player
var _open := false
var _was_controllable := false
var _theme: Theme
var _background_blur_layer: CanvasLayer

var _preview: SubViewport
var _preview_display: TextureRect
var _callout_layer: WeaponCalloutLayer
var _stage: Control
var _chip_layer: Control

var _active_slot := ""
var _slot_chips: Dictionary = {}   # slot_name -> PanelContainer
var _slot_order: Array[String] = []
var _detail_panel: PanelContainer
var _detail_title: Label
var _detail_sub: Label
var _detail_rows: VBoxContainer
var _stat_bar_rows: Dictionary = {}
var _stat_strip: HBoxContainer
var _notice: Label
var _title_label: Label
var _subtitle_label: Label


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
	_rebuild_all()
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
		_player.set_controllable(_was_controllable and _player.is_alive)
	closed.emit()


# ── 生命周期 ────────────────────────────────────────────────

func _ready() -> void:
	layer = 22
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 15
	_setup_tooltip_style()
	_setup_background_blur()
	_build_ui()
	visible = false


func _exit_tree() -> void:
	if _background_blur_layer and is_instance_valid(_background_blur_layer):
		_background_blur_layer.queue_free()


func _process(_delta: float) -> void:
	if _open:
		_update_callouts()


func _input(event: InputEvent) -> void:
	if not _open:
		return
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


# ── 背景模糊 / 提示气泡（与设置页一致）───────────────────────

func _setup_background_blur() -> void:
	_background_blur_layer = CanvasLayer.new()
	_background_blur_layer.name = "WeaponModBackgroundBlurLayer"
	_background_blur_layer.layer = 18
	_background_blur_layer.visible = false
	get_parent().add_child(_background_blur_layer)

	var blur := ColorRect.new()
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


func _setup_tooltip_style() -> void:
	var box := _box(COL_TOOLTIP_BG, COL_BORDER, 3)
	box.content_margin_left = 12
	box.content_margin_right = 12
	_theme.set_stylebox("panel", "TooltipPanel", box)
	_theme.set_color("font_color", "TooltipLabel", COL_TEXT)
	_theme.set_font_size("font_size", "TooltipLabel", 13)


# ── 布局 ────────────────────────────────────────────────────

func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = COL_BACKDROP
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.theme = _theme
	add_child(backdrop)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 34)
	backdrop.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	_build_header(root)
	root.add_child(_divider())

	# 中央舞台：预览图 + 引线层 + 卡片层（互相叠放）
	_stage = Control.new()
	_stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_stage.clip_contents = false
	root.add_child(_stage)

	_preview = WeaponPreviewScript.new()
	_stage.add_child(_preview)

	_preview_display = TextureRect.new()
	_preview_display.set_anchors_preset(Control.PRESET_FULL_RECT)
	_preview_display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_preview_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_preview_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview_display.texture = _preview.get_texture()
	_stage.add_child(_preview_display)

	_callout_layer = CalloutLayerScript.new()
	_callout_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_stage.add_child(_callout_layer)

	_chip_layer = Control.new()
	_chip_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_chip_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_chip_layer)

	_build_detail_panel(_stage)

	_notice = Label.new()
	_notice.add_theme_font_size_override("font_size", 13)
	_notice.add_theme_color_override("font_color", COL_DANGER)
	_notice.visible = false
	root.add_child(_notice)

	root.add_child(_divider())
	_build_stat_strip(root)
	_build_footer(root)


func _build_header(parent: Control) -> void:
	var header := HBoxContainer.new()
	parent.add_child(header)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	titles.add_theme_constant_override("separation", 2)
	header.add_child(titles)

	_title_label = Label.new()
	_title_label.text = ModText.TITLE
	_title_label.add_theme_font_size_override("font_size", 26)
	_title_label.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(_title_label)

	_subtitle_label = Label.new()
	_subtitle_label.text = ModText.SUBTITLE
	_subtitle_label.add_theme_font_size_override("font_size", 13)
	_subtitle_label.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(_subtitle_label)

	# 视角复位按钮（自由旋转接入后更有用）
	var reset := Button.new()
	reset.text = ModText.RESET_VIEW
	reset.custom_minimum_size = Vector2(108, 34)
	reset.focus_mode = Control.FOCUS_NONE
	_style_button(reset, false)
	reset.pressed.connect(func():
		_preview.reset_view()
	)
	header.add_child(reset)


## 配件列表面板：默认隐藏，选中槽位时从该侧滑出
func _build_detail_panel(parent: Control) -> void:
	_detail_panel = PanelContainer.new()
	_detail_panel.add_theme_stylebox_override("panel", _box(COL_PANEL, COL_ACCENT, 4))
	_detail_panel.custom_minimum_size = Vector2(340, 0)
	_detail_panel.visible = false
	parent.add_child(_detail_panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 14)
	_detail_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	_detail_title = Label.new()
	_detail_title.add_theme_font_size_override("font_size", 17)
	_detail_title.add_theme_color_override("font_color", COL_ACCENT)
	vbox.add_child(_detail_title)

	_detail_sub = Label.new()
	_detail_sub.add_theme_font_size_override("font_size", 12)
	_detail_sub.add_theme_color_override("font_color", COL_MUTED)
	vbox.add_child(_detail_sub)

	vbox.add_child(_divider())

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 300)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	_detail_rows = VBoxContainer.new()
	_detail_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_rows.add_theme_constant_override("separation", 6)
	scroll.add_child(_detail_rows)


func _build_stat_strip(parent: Control) -> void:
	_stat_strip = HBoxContainer.new()
	_stat_strip.add_theme_constant_override("separation", 28)
	parent.add_child(_stat_strip)


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


# ── 数据构建 ────────────────────────────────────────────────

func _current_weapon():
	if not _player or not _player.weapon_manager:
		return null
	return _player.weapon_manager.current_weapon


## 采集真枪当前的配件状态：{ slot_name: AttachmentConfig }
func _capture_attachment_state() -> Dictionary:
	var state := {}
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return state
	for slot in weapon.attachment_manager.get_slots():
		var s := slot as AttachmentSlot
		if s.current_attachment and s.current_attachment.config:
			state[s.get_slot_key()] = s.current_attachment.config
	return state


func _rebuild_all() -> void:
	_notice.visible = false
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		_title_label.text = ModText.NO_WEAPON
		_subtitle_label.text = ModText.NO_WEAPON_HINT
		_clear_chips()
		_detail_panel.visible = false
		return

	_title_label.text = weapon.config.weapon_name if weapon.config else ModText.TITLE
	_subtitle_label.text = ModText.SUBTITLE

	_preview.rebuild(weapon.config, _capture_attachment_state())
	_build_chips(weapon)
	_refresh_stats()
	if _active_slot != "" and _slot_chips.has(_active_slot):
		_show_slot_detail(_active_slot)
	else:
		_detail_panel.visible = false


func _clear_chips() -> void:
	for child in _chip_layer.get_children():
		child.queue_free()
	_slot_chips.clear()
	_slot_order.clear()
	_callout_layer.set_callouts([])


func _build_chips(weapon) -> void:
	_clear_chips()
	var slots: Array = weapon.attachment_manager.get_slots()
	for slot in slots:
		var s := slot as AttachmentSlot
		_slot_order.append(s.get_slot_key())

	for key in _slot_order:
		var slot: AttachmentSlot = weapon.attachment_manager.get_slot(key)
		var chip := _make_chip(key, slot)
		_chip_layer.add_child(chip)
		_slot_chips[key] = chip

	_layout_chips.call_deferred()


func _make_chip(slot_name: String, slot: AttachmentSlot) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.custom_minimum_size = CHIP_SIZE
	chip.size = CHIP_SIZE
	chip.mouse_filter = Control.MOUSE_FILTER_STOP
	_style_chip(chip, slot_name == _active_slot)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	chip.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	margin.add_child(vbox)

	var name_label := Label.new()
	name_label.text = slot_name
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.add_theme_color_override("font_color", COL_MUTED)
	vbox.add_child(name_label)

	var value_label := Label.new()
	var installed := slot.current_attachment if slot else null
	value_label.text = installed.config.attachment_name if (installed and installed.config) else ModText.SLOT_EMPTY
	value_label.add_theme_font_size_override("font_size", 14)
	value_label.add_theme_color_override(
		"font_color", COL_TEXT if installed else COL_MUTED.darkened(0.15)
	)
	value_label.clip_text = true
	vbox.add_child(value_label)

	chip.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed \
				and event.button_index == MOUSE_BUTTON_LEFT:
			_show_slot_detail(slot_name)
	)
	return chip


## 卡片沿左右两条竖直导轨均匀排布；按挂载点在画面中的高度分配左右，
## 使引线尽量不交叉。
func _layout_chips() -> void:
	if _slot_order.is_empty() or not is_instance_valid(_stage):
		return
	var stage_size := _stage.size
	if stage_size.x <= 0.0:
		return

	# 依据投影位置把槽位分到左右两列
	var display_size := _preview_display.size
	var entries: Array = []
	for key in _slot_order:
		var proj: Dictionary = _preview.project_slot(key, display_size)
		var anchor: Vector2 = proj.get("position", stage_size * 0.5)
		entries.append({ "key": key, "anchor": anchor, "visible": proj.get("visible", false) })

	entries.sort_custom(func(a, b): return a["anchor"].y < b["anchor"].y)
	var left: Array = []
	var right: Array = []
	for e in entries:
		if (e["anchor"] as Vector2).x < stage_size.x * 0.5:
			left.append(e)
		else:
			right.append(e)
	# 两侧数量差距过大时匀一匀，避免一列排到画面外
	while left.size() > right.size() + 1:
		right.append(left.pop_back())
	while right.size() > left.size() + 1:
		left.append(right.pop_back())

	_place_column(left, -1, stage_size)
	_place_column(right, 1, stage_size)


func _place_column(entries: Array, side: int, stage_size: Vector2) -> void:
	if entries.is_empty():
		return
	var total_h: float = entries.size() * CHIP_SIZE.y + (entries.size() - 1) * CHIP_GAP
	var start_y: float = maxf((stage_size.y - total_h) * 0.5, 0.0)
	var x: float = 0.0 if side < 0 else stage_size.x - CHIP_SIZE.x
	for i in entries.size():
		var key: String = entries[i]["key"]
		var chip: PanelContainer = _slot_chips.get(key)
		if not chip:
			continue
		chip.position = Vector2(x, start_y + i * (CHIP_SIZE.y + CHIP_GAP))
		chip.set_meta("side", side)


## 每帧刷新引线（预览旋转/窗口缩放时都要跟着动）
func _update_callouts() -> void:
	if _slot_order.is_empty() or not _preview_display:
		return
	var display_size := _preview_display.size
	var data: Array = []
	for key in _slot_order:
		var chip: PanelContainer = _slot_chips.get(key)
		if not chip or not is_instance_valid(chip):
			continue
		var proj: Dictionary = _preview.project_slot(key, display_size)
		if not proj.get("visible", false):
			continue
		var side: int = chip.get_meta("side", -1)
		# 引线接到卡片朝向画面中心的那条边的中点
		var target := chip.position + Vector2(
			chip.size.x if side < 0 else 0.0, chip.size.y * 0.5
		)
		data.append({
			"anchor": proj["position"],
			"target": target,
			"active": key == _active_slot,
			"side": side,
		})
	_callout_layer.set_callouts(data)


# ── 配件列表 ────────────────────────────────────────────────

func _show_slot_detail(slot_name: String) -> void:
	_active_slot = slot_name
	_notice.visible = false
	for key in _slot_chips:
		_style_chip(_slot_chips[key], key == slot_name)

	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var slot: AttachmentSlot = weapon.attachment_manager.get_slot(slot_name)
	if not slot:
		return

	_detail_title.text = slot_name
	var options := AttachmentCatalog.for_slot(slot)
	_detail_sub.text = ModText.OPTION_COUNT % options.size()

	for child in _detail_rows.get_children():
		child.queue_free()

	if slot.current_attachment:
		if slot.can_be_empty:
			_add_detach_row(slot_name)
		else:
			var locked := Label.new()
			locked.text = ModText.SLOT_LOCKED
			locked.add_theme_font_size_override("font_size", 13)
			locked.add_theme_color_override("font_color", COL_MUTED)
			_detail_rows.add_child(locked)

	if options.is_empty():
		var empty := Label.new()
		empty.text = ModText.LIST_EMPTY
		empty.add_theme_font_size_override("font_size", 13)
		empty.add_theme_color_override("font_color", COL_MUTED)
		_detail_rows.add_child(empty)
	else:
		for cfg in options:
			var installed: bool = slot.current_attachment != null \
				and slot.current_attachment.config == cfg
			_add_option_row(cfg, installed, slot_name)

	# 面板贴在所选卡片的对侧，避免遮住引线
	var chip: PanelContainer = _slot_chips.get(slot_name)
	_detail_panel.visible = true
	if chip:
		var side: int = chip.get_meta("side", -1)
		_detail_panel.position = Vector2(
			CHIP_SIZE.x + 28.0 if side < 0 else _stage.size.x - CHIP_SIZE.x - 368.0,
			clampf(chip.position.y - 40.0, 0.0, maxf(_stage.size.y - 380.0, 0.0))
		)


func _add_option_row(cfg: AttachmentConfig, installed: bool, slot_name: String) -> void:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override(
		"panel",
		_box(COL_ACCENT_DIM if installed else COL_SURFACE,
			COL_ACCENT if installed else COL_BORDER, 3)
	)
	_detail_rows.add_child(row)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	row.add_child(hbox)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 1)
	hbox.add_child(info)

	var name_label := Label.new()
	name_label.text = cfg.attachment_name
	name_label.add_theme_font_size_override("font_size", 14)
	name_label.add_theme_color_override("font_color", COL_ACCENT if installed else COL_TEXT)
	info.add_child(name_label)

	var stat_label := Label.new()
	stat_label.text = _describe_modifiers(cfg)
	stat_label.add_theme_font_size_override("font_size", 11)
	stat_label.add_theme_color_override("font_color", COL_MUTED)
	info.add_child(stat_label)

	var action := Button.new()
	action.text = ModText.INSTALLED if installed else ModText.INSTALL
	action.custom_minimum_size = Vector2(78, 32)
	action.focus_mode = Control.FOCUS_NONE
	action.disabled = installed
	_style_button(action, not installed)
	if not installed:
		action.pressed.connect(func(): _do_equip(cfg, slot_name))
	hbox.add_child(action)


func _add_detach_row(slot_name: String) -> void:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", _box(COL_DANGER_DIM, COL_DANGER, 3))
	_detail_rows.add_child(row)
	var hbox := HBoxContainer.new()
	row.add_child(hbox)
	var label := Label.new()
	label.text = ModText.DETACH
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_DANGER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(label)
	var button := Button.new()
	button.text = ModText.DETACH_SHORT
	button.custom_minimum_size = Vector2(78, 32)
	button.focus_mode = Control.FOCUS_NONE
	_style_button(button, false)
	button.pressed.connect(func(): _do_detach(slot_name))
	hbox.add_child(button)


# ── 改装操作 ────────────────────────────────────────────────

func _do_equip(cfg: AttachmentConfig, slot_name: String) -> void:
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var attachment := AttachmentFactory.create(cfg, weapon)
	if not attachment or not weapon.attachment_manager.equip_to_slot(attachment, slot_name):
		if attachment:
			attachment.queue_free()
		_notice.text = ModText.EQUIP_FAILED % cfg.attachment_name
		_notice.visible = true
		return
	GlobalLogger.info("WeaponMod", "已安装 %s → %s" % [cfg.attachment_name, slot_name])
	_rebuild_all()


func _do_detach(slot_name: String) -> void:
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	weapon.attachment_manager.detach_from_slot(slot_name)
	GlobalLogger.info("WeaponMod", "已卸下 %s" % slot_name)
	_rebuild_all()


# ── 数据条 ──────────────────────────────────────────────────

func _refresh_stats() -> void:
	var weapon = _current_weapon()
	if not weapon or not weapon.config:
		return
	var cfg: WeaponConfig = weapon.config
	var am = weapon.attachment_manager
	var stats := [
		[ModText.STAT_SPREAD_HIP, weapon.get_current_spread(false), 6.0, true],
		[ModText.STAT_SPREAD_ADS, weapon.get_current_spread(true), 1.5, true],
		[ModText.STAT_RECOIL_V, cfg.recoil_vertical + (am.get_total_recoil_vertical_modifier() if am else 0.0), 4.0, true],
		[ModText.STAT_RECOIL_H, cfg.recoil_horizontal + (am.get_total_recoil_horizontal_modifier() if am else 0.0), 2.0, true],
		[ModText.STAT_WEIGHT, cfg.weight + (am.get_total_attachment_weight() if am else 0.0), 8.0, true],
	]
	for entry in stats:
		_upsert_stat_bar(entry[0], entry[1], entry[2], entry[3])


## 数值条：首次创建，之后用 tween 平滑过渡，让改装收益可见
func _upsert_stat_bar(label_text: String, value: float, max_value: float, lower_is_better: bool) -> void:
	var ratio: float = clampf(value / maxf(max_value, 0.0001), 0.0, 1.0)
	if not _stat_bar_rows.has(label_text):
		var col := VBoxContainer.new()
		col.custom_minimum_size = Vector2(150, 0)
		col.add_theme_constant_override("separation", 4)
		_stat_strip.add_child(col)

		var head := HBoxContainer.new()
		col.add_child(head)
		var name_label := Label.new()
		name_label.text = label_text
		name_label.add_theme_font_size_override("font_size", 12)
		name_label.add_theme_color_override("font_color", COL_MUTED)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		head.add_child(name_label)
		var value_label := Label.new()
		value_label.add_theme_font_size_override("font_size", 12)
		value_label.add_theme_color_override("font_color", COL_TEXT)
		head.add_child(value_label)

		var track := ProgressBar.new()
		track.custom_minimum_size = Vector2(0, 5)
		track.show_percentage = false
		track.max_value = 1.0
		track.add_theme_stylebox_override("background", _box(COL_SURFACE, COL_BORDER, 2, 0))
		track.add_theme_stylebox_override("fill", _box(COL_ACCENT, COL_ACCENT, 2, 0))
		col.add_child(track)

		_stat_bar_rows[label_text] = { "bar": track, "value": value_label }

	var row: Dictionary = _stat_bar_rows[label_text]
	var bar: ProgressBar = row["bar"]
	var value_label: Label = row["value"]
	value_label.text = "%.2f" % value
	# 数值越低越好时用冷色，越界用警示色
	var fill := COL_ACCENT if (ratio < 0.7) == lower_is_better else COL_DANGER
	bar.add_theme_stylebox_override("fill", _box(fill, fill, 2, 0))
	var tween := create_tween()
	tween.tween_property(bar, "value", ratio, 0.25).set_trans(Tween.TRANS_CUBIC)


func _describe_modifiers(cfg: AttachmentConfig) -> String:
	var parts: PackedStringArray = []
	if not is_zero_approx(cfg.hipfire_spread_modifier):
		parts.append("腰射 %+.2f" % cfg.hipfire_spread_modifier)
	if not is_zero_approx(cfg.ads_spread_modifier):
		parts.append("机瞄 %+.2f" % cfg.ads_spread_modifier)
	if not is_zero_approx(cfg.weight_kg):
		parts.append("重量 %+.2fkg" % cfg.weight_kg)
	if parts.is_empty():
		return ModText.NO_MODIFIER
	return " · ".join(parts)


# ── 样式 ────────────────────────────────────────────────────

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


## 槽位卡片：切角矩形（左上/右下切角），与常见的纯直角卡片拉开差异
func _style_chip(chip: PanelContainer, selected: bool) -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = COL_ACCENT_DIM if selected else COL_PANEL
	box.border_color = COL_ACCENT if selected else COL_BORDER
	box.set_border_width_all(1)
	box.corner_radius_top_left = 10
	box.corner_radius_bottom_right = 10
	box.corner_radius_top_right = 2
	box.corner_radius_bottom_left = 2
	chip.add_theme_stylebox_override("panel", box)


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
