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
const GRID_SHADER_PATH := "res://res/shaders/blueprint_grid.gdshader"
const AttachmentCatalog = preload("res://classes/ui/weapon_mod/attachment_catalog.gd")
const WeaponPreviewScript = preload("res://classes/ui/weapon_mod/weapon_preview.gd")
const CalloutLayerScript = preload("res://classes/ui/weapon_mod/weapon_callout_layer.gd")
const MOD_CONFIG: WeaponModConfig = preload("res://res/config/ui/weapon_mod_config.tres")

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

const SIDE_RAIL_GROUP := "__side_rail__"

signal opened
signal closed

var _player
var _open := false
var _was_controllable := false
var _theme: Theme
var _config: WeaponModConfig = MOD_CONFIG
var _background_blur_layer: CanvasLayer

var _preview: WeaponPreview
var _preview_display: TextureRect
var _grid_rect: ColorRect
var _callout_layer: WeaponCalloutLayer
var _stage: Control
var _chip_layer: Control

## 改装草稿：{ slot_name: AttachmentConfig }。所有操作只改这里，
## 预览实时反映草稿；点"应用更改"才写回真枪。核心槽位空缺时禁止应用。
var _draft: Dictionary = {}
## { slot_name: float }，与配件配置分离，避免改动共享资源
var _draft_rail_offsets: Dictionary = {}
var _dirty := false
var _apply_button: Button
var _revert_button: Button

var _active_slot := ""
var _slot_chips: Dictionary = {}   # slot_name -> PanelContainer
var _slot_groups: Dictionary = {}  # 显示项 -> 技术槽位名数组
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
var _dragging_view := false
var _view_drag_start := Vector2.ZERO
var _view_dragged := false


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
	_draft = _capture_attachment_state()
	_draft_rail_offsets = _capture_rail_offsets()
	_dirty = false
	_active_slot = ""
	_rebuild_all()
	opened.emit()


func close() -> void:
	if not _open:
		return
	_dragging_view = false
	_view_dragged = false
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
		_layout_chips()
		_update_callouts()


func _input(event: InputEvent) -> void:
	if not _open:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed and _dragging_view:
		# 鼠标释放在舞台外时，舞台本身可能收不到释放事件；这里补充收尾。
		if not _view_dragged:
			_clear_slot_selection()
		_dragging_view = false
		_view_dragged = false
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


## 在预览空白区域拖拽旋转武器；配件卡片自身仍保留点击选择行为。
func _on_stage_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging_view = true
			_view_drag_start = event.position
			_view_dragged = false
			get_viewport().set_input_as_handled()
		else:
			# 没有超过移动阈值才算点击空白区域，拖动旋转不会清除选中状态。
			if not _view_dragged:
				_clear_slot_selection()
			_dragging_view = false
		return
	if event is InputEventMouseMotion and _dragging_view:
		if not _view_dragged and event.position.distance_to(_view_drag_start) >= _config.view_drag_threshold:
			_view_dragged = true
		if _view_dragged:
			_preview.rotate_view(
				-event.relative.x * _config.view_rotation_sensitivity,
				-event.relative.y * _config.view_rotation_sensitivity
			)
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
	_stage.gui_input.connect(_on_stage_gui_input)
	root.add_child(_stage)

	# 蓝图网格：着色器实现，铺在最底层（放在预览与引线之前加入即可压在下面）
	_grid_rect = ColorRect.new()
	_grid_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_grid_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grid_rect.color = Color(1, 1, 1, 1)
	var grid_shader := load(GRID_SHADER_PATH) as Shader
	if grid_shader:
		var mat := ShaderMaterial.new()
		mat.shader = grid_shader
		mat.set_shader_parameter("grid_step", 46.0)
		mat.set_shader_parameter("major_every", 4.0)
		mat.set_shader_parameter("minor_color", Color(1, 1, 1, 0.030))
		mat.set_shader_parameter("major_color", Color(1, 1, 1, 0.055))
		_grid_rect.material = mat
	_stage.add_child(_grid_rect)
	# rect_size 需与控件实际像素尺寸同步，否则网格会被拉伸
	_grid_rect.resized.connect(_sync_grid_size)
	_sync_grid_size.call_deferred()

	_preview = WeaponPreviewScript.new()
	_preview.mod_config = _config
	_stage.add_child(_preview)

	_preview_display = TextureRect.new()
	_preview_display.set_anchors_preset(Control.PRESET_FULL_RECT)
	_preview_display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_preview_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_preview_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview_display.texture = _preview.get_texture()
	_stage.add_child(_preview_display)

	_callout_layer = CalloutLayerScript.new()
	_callout_layer.mod_config = _config
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


## 把控件像素尺寸传给网格着色器，保证格子是正方形而非被拉伸
func _sync_grid_size() -> void:
	if not _grid_rect or not _grid_rect.material:
		return
	(_grid_rect.material as ShaderMaterial).set_shader_parameter("rect_size", _grid_rect.size)


func _build_header(parent: Control) -> void:
	var header := HBoxContainer.new()
	parent.add_child(header)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	titles.add_theme_constant_override("separation", 2)
	header.add_child(titles)

	_title_label = Label.new()
	_title_label.text = _config.title
	_title_label.add_theme_font_size_override("font_size", 26)
	_title_label.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(_title_label)

	_subtitle_label = Label.new()
	_subtitle_label.text = _config.subtitle
	_subtitle_label.add_theme_font_size_override("font_size", 13)
	_subtitle_label.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(_subtitle_label)

	# 视角复位按钮（自由旋转接入后更有用）
	var reset := Button.new()
	reset.text = _config.reset_view
	reset.custom_minimum_size = Vector2(108, 34)
	reset.focus_mode = Control.FOCUS_NONE
	_style_button(reset, false)
	reset.pressed.connect(func():
		_preview.reset_view()
		_layout_chips()
		_update_callouts()
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
	hint.text = _config.footer_hint
	hint.add_theme_font_size_override("font_size", 13)
	hint.add_theme_color_override("font_color", COL_MUTED)
	hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(hint)

	_revert_button = Button.new()
	_revert_button.text = _config.revert
	_revert_button.custom_minimum_size = Vector2(112, 38)
	_revert_button.focus_mode = Control.FOCUS_NONE
	_revert_button.disabled = true
	_style_button(_revert_button, false)
	_revert_button.pressed.connect(_revert_changes)
	row.add_child(_revert_button)

	var close_button := Button.new()
	close_button.text = _config.close
	close_button.custom_minimum_size = Vector2(112, 38)
	close_button.focus_mode = Control.FOCUS_NONE
	_style_button(close_button, false)
	close_button.pressed.connect(close)
	row.add_child(close_button)

	_apply_button = Button.new()
	_apply_button.text = _config.apply
	_apply_button.custom_minimum_size = Vector2(148, 38)
	_apply_button.focus_mode = Control.FOCUS_NONE
	_apply_button.disabled = true
	_style_button(_apply_button, true)
	_apply_button.pressed.connect(_apply_changes)
	row.add_child(_apply_button)


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


## 采集当前武器中可调配件的导轨位置
func _capture_rail_offsets() -> Dictionary:
	var offsets := {}
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return offsets
	for slot in weapon.attachment_manager.get_slots():
		var s := slot as AttachmentSlot
		var att := s.current_attachment
		if att and att.config and att.config.rail_adjustable:
			offsets[s.get_slot_key()] = weapon.attachment_manager.get_rail_offset(s.get_slot_key())
	return offsets


func _rebuild_all() -> void:
	_notice.visible = false
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		_title_label.text = _config.no_weapon
		_subtitle_label.text = _config.no_weapon_hint
		_clear_chips()
		_detail_panel.visible = false
		return

	_title_label.text = weapon.config.weapon_name if weapon.config else _config.title
	_subtitle_label.text = _config.subtitle

	# 预览按草稿重建；槽位清单也取自预览——因为可用槽位本身取决于装了什么
	# （机匣盖带出 OpticRail、护木带出 Underbarrel）
	_preview.rebuild(weapon.config, _draft, _draft_rail_offsets)
	var preview_weapon = _preview.get_weapon()
	if preview_weapon:
		_build_chips(preview_weapon)
	_refresh_stats()
	_refresh_apply_state()
	if _active_slot != "" and _slot_chips.has(_active_slot):
		_show_slot_detail(_active_slot)
	else:
		_active_slot = ""
		_detail_panel.visible = false
		_refresh_chip_focus()


func _clear_chips() -> void:
	for child in _chip_layer.get_children():
		child.queue_free()
	_slot_chips.clear()
	_slot_groups.clear()
	_slot_order.clear()
	_callout_layer.set_callouts([])


func _build_chips(weapon) -> void:
	_clear_chips()
	var slots: Array = weapon.attachment_manager.get_slots()
	for slot in slots:
		var s := slot as AttachmentSlot
		var key := s.get_slot_key()
		if _is_side_rail_slot(s):
			key = SIDE_RAIL_GROUP
			if not _slot_groups.has(key):
				_slot_groups[key] = []
				_slot_order.append(key)
			(_slot_groups[key] as Array).append(s.get_slot_key())
		else:
			_slot_groups[key] = [key]
			_slot_order.append(key)

	for key in _slot_order:
		var chip := _make_chip(key, _slot_groups[key], weapon)
		_chip_layer.add_child(chip)
		_slot_chips[key] = chip
	_refresh_chip_focus()

	_layout_chips.call_deferred()


func _make_chip(group_key: String, slot_names: Array, weapon) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.custom_minimum_size = _config.chip_size
	chip.size = _config.chip_size
	chip.mouse_filter = Control.MOUSE_FILTER_STOP
	_style_chip(chip, group_key == _active_slot)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	chip.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	margin.add_child(vbox)

	var slot: AttachmentSlot = weapon.attachment_manager.get_slot(slot_names[0]) if not slot_names.is_empty() else null
	var is_core: bool = slot_names.size() == 1 and slot != null and slot.is_core()
	var name_label := Label.new()
	var display_name := _group_display_name(group_key, slot_names)
	name_label.text = "%s %s" % [display_name, _config.core_tag] if is_core else display_name
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.add_theme_color_override("font_color", COL_MUTED)
	vbox.add_child(name_label)

	# 卡片显示的是草稿状态（预览武器上的实际装配）
	var installed := slot.current_attachment if slot else null
	var installed_count := 0
	for slot_name in slot_names:
		var grouped_slot: AttachmentSlot = weapon.attachment_manager.get_slot(slot_name)
		if grouped_slot and grouped_slot.current_attachment:
			installed_count += 1
	var missing_core: bool = is_core and installed == null
	var value_label := Label.new()
	if group_key == SIDE_RAIL_GROUP:
		value_label.text = _config.side_rail_status % installed_count
	else:
		value_label.text = installed.config.attachment_name if (installed and installed.config) else _config.slot_empty
	value_label.add_theme_font_size_override("font_size", 14)
	var value_col := COL_TEXT if installed else COL_MUTED.darkened(0.15)
	if missing_core:
		value_col = COL_DANGER
		value_label.text = _config.core_missing
	value_label.add_theme_color_override("font_color", value_col)
	value_label.clip_text = true
	vbox.add_child(value_label)

	chip.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed \
				and event.button_index == MOUSE_BUTTON_LEFT:
			_show_slot_detail(group_key)
	)
	return chip


## 更新卡片焦点状态：名称始终可见，未选中项只降低对比度，不移除节点。
func _refresh_chip_focus() -> void:
	var has_active := _active_slot != ""
	for key in _slot_chips:
		var chip: PanelContainer = _slot_chips[key]
		var focused: bool = not has_active or String(key) == _active_slot
		_style_chip(chip, focused and key == _active_slot)
		var target_modulate := Color.WHITE if focused else Color(0.62, 0.67, 0.74, _config.unfocused_chip_alpha)
		var target_scale := Vector2.ONE if focused else Vector2(_config.unfocused_chip_scale, _config.unfocused_chip_scale)
		var previous_tween = chip.get_meta("_focus_tween") if chip.has_meta("_focus_tween") else null
		if previous_tween is Tween and previous_tween.is_running():
			previous_tween.kill()
		var tween := chip.create_tween().set_parallel()
		tween.tween_property(chip, "self_modulate", target_modulate, _config.chip_focus_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(chip, "scale", target_scale, _config.chip_focus_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		chip.set_meta("_focus_tween", tween)


func _is_side_rail_slot(slot: AttachmentSlot) -> bool:
	return slot.slot_type == AttachmentSlot.SlotType.SIDE_RAIL_LEFT \
			or slot.slot_type == AttachmentSlot.SlotType.SIDE_RAIL_RIGHT


func _group_display_name(group_key: String, slot_names: Array) -> String:
	if group_key == SIDE_RAIL_GROUP:
		return _config.side_rail
	return slot_names[0] if not slot_names.is_empty() else group_key


## 卡片围绕挂载点自由排布；武器旋转后重新投影，卡片随挂载点移动。
func _layout_chips() -> void:
	if _slot_order.is_empty() or not is_instance_valid(_stage):
		return
	var stage_size := _stage.size
	if stage_size.x <= 0.0:
		return

	var display_size := _preview_display.size
	var placements: Array = []
	for key in _slot_order:
		var proj: Dictionary = _project_group(key, display_size, stage_size)
		if not proj.get("visible", false):
			continue
		var anchor: Vector2 = proj["position"]
		var direction := anchor - stage_size * 0.5
		if direction.length_squared() < 1.0:
			direction = Vector2.RIGHT
		direction = direction.normalized()
		var offset := Vector2(
			direction.x * (_config.chip_size.x * 0.5 + _config.chip_anchor_gap),
			direction.y * (_config.chip_size.y * 0.5 + _config.chip_anchor_gap)
		)
		var position := anchor + offset - _config.chip_size * 0.5
		position.x = clampf(position.x, _config.stage_margin, maxf(stage_size.x - _config.chip_size.x - _config.stage_margin, _config.stage_margin))
		position.y = clampf(position.y, _config.stage_margin, maxf(stage_size.y - _config.chip_size.y - _config.stage_margin, _config.stage_margin))
		placements.append({ "key": key, "position": position, "anchor": anchor })

	_resolve_chip_overlaps(placements, stage_size)
	for placement in placements:
		var chip: PanelContainer = _slot_chips.get(placement["key"])
		if not chip:
			continue
		_animate_chip_to(chip, placement["position"], placement["anchor"])
		var target_position: Vector2 = placement["position"]
		chip.set_meta("side", -1 if target_position.x + chip.size.x * 0.5 < stage_size.x * 0.5 else 1)
	_position_detail_panel()


func _animate_chip_to(chip: PanelContainer, target: Vector2, anchor: Vector2) -> void:
	var previous_target = chip.get_meta("_chip_target") if chip.has_meta("_chip_target") else null
	var is_new := previous_target == null
	if not is_new and (previous_target as Vector2).distance_to(target) < 0.75:
		# 目标没有变化时不要中断正在进行的淡入/缩放动画。
		return
	var previous_tween = chip.get_meta("_chip_tween") if chip.has_meta("_chip_tween") else null
	if previous_tween is Tween and previous_tween.is_running():
		previous_tween.kill()

	chip.pivot_offset = _config.chip_size * 0.5
	var start := target
	if is_new:
		var direction := target - anchor
		if direction.length_squared() < 1.0:
			direction = Vector2.RIGHT
		start = target + direction.normalized() * _config.chip_anchor_gap * 0.27
		chip.position = start
		chip.modulate = Color(1.0, 1.0, 1.0, 0.0)
		chip.scale = Vector2(0.92, 0.92)

	var duration := _config.chip_appearance_duration if is_new else _config.chip_move_duration
	var tween := chip.create_tween().set_parallel()
	tween.tween_property(chip, "position", target, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# 相机取景过渡会让目标位置连续变化；若因此打断首次动画，
	# 仍要把卡片从透明/缩小状态恢复到正常显示。
	var needs_appearance := is_new or chip.modulate.a < 0.99 or chip.scale.distance_to(Vector2.ONE) > 0.01
	if needs_appearance:
		tween.tween_property(chip, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(chip, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	chip.set_meta("_chip_tween", tween)
	chip.set_meta("_chip_target", target)


## 轻量避让：优先沿离挂载点较远的轴推开重叠卡片，再限制在舞台内。
func _resolve_chip_overlaps(placements: Array, stage_size: Vector2) -> void:
	for _pass in 4:
		for i in placements.size():
			var current: Dictionary = placements[i]
			var current_rect := Rect2(current["position"], _config.chip_size)
			for j in i:
				var other: Dictionary = placements[j]
				var other_rect := Rect2(other["position"], _config.chip_size)
				if not current_rect.intersects(other_rect):
					continue
				var overlap_x := minf(current_rect.end.x, other_rect.end.x) - maxf(current_rect.position.x, other_rect.position.x)
				var overlap_y := minf(current_rect.end.y, other_rect.end.y) - maxf(current_rect.position.y, other_rect.position.y)
				var current_pos: Vector2 = current["position"]
				if overlap_y <= overlap_x:
					var direction_y := 1.0 if current_rect.get_center().y >= other_rect.get_center().y else -1.0
					current_pos.y += direction_y * (overlap_y + _config.chip_gap)
				else:
					var direction_x := 1.0 if current_rect.get_center().x >= other_rect.get_center().x else -1.0
					current_pos.x += direction_x * (overlap_x + _config.chip_gap)
				current_pos.x = clampf(current_pos.x, _config.stage_margin, maxf(stage_size.x - _config.chip_size.x - _config.stage_margin, _config.stage_margin))
				current_pos.y = clampf(current_pos.y, _config.stage_margin, maxf(stage_size.y - _config.chip_size.y - _config.stage_margin, _config.stage_margin))
				current["position"] = current_pos
				current_rect = Rect2(current_pos, _config.chip_size)


func _project_group(group_key: String, display_size: Vector2, fallback: Vector2) -> Dictionary:
	var names: Array = _slot_groups.get(group_key, [group_key])
	var positions: Array[Vector2] = []
	for slot_name in names:
		var projection := _preview.project_slot(slot_name, display_size)
		if projection.get("visible", false):
			positions.append(projection["position"])
	if positions.is_empty():
		return { "position": fallback, "visible": false }
	var center := Vector2.ZERO
	for position in positions:
		center += position
	center /= positions.size()
	return { "position": center, "visible": true }


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
		# 一个概念卡片可能对应多个技术槽位（例如左右侧导轨），
		# 每个实体挂载点都独立连线，避免把引线锚在两者之间的虚构位置。
		for actual_slot_name in _slot_groups.get(key, [key]):
			var proj: Dictionary = _preview.project_slot(actual_slot_name, display_size)
			if not proj.get("visible", false):
				continue
			var anchor: Vector2 = proj["position"]
			data.append({
				"anchor": anchor,
				"target": _get_card_edge_target(chip, anchor),
				"active": key == _active_slot,
			})
	_callout_layer.set_callouts(data)


func _get_card_edge_target(chip: PanelContainer, anchor: Vector2) -> Vector2:
	var rect := Rect2(chip.position, chip.size)
	var center := rect.get_center()
	var delta := anchor - center
	if absf(delta.x) / maxf(rect.size.x, 1.0) >= absf(delta.y) / maxf(rect.size.y, 1.0):
		return Vector2(
			rect.end.x if delta.x >= 0.0 else rect.position.x,
			clampf(anchor.y, rect.position.y + 6.0, rect.end.y - 6.0)
		)
	return Vector2(
		clampf(anchor.x, rect.position.x + 6.0, rect.end.x - 6.0),
			rect.end.y if delta.y >= 0.0 else rect.position.y
	)


# ── 配件列表 ────────────────────────────────────────────────

func _show_slot_detail(slot_name: String) -> void:
	_active_slot = slot_name
	_refresh_chip_focus()

	# 槽位取自预览武器（草稿状态），因为部分槽位由已装配件带出
	var preview_weapon = _preview.get_weapon()
	if not preview_weapon or not preview_weapon.attachment_manager:
		return
	var slot_names: Array = _slot_groups.get(slot_name, [slot_name])
	if slot_names.is_empty():
		return

	_detail_title.text = _group_display_name(slot_name, slot_names)

	for child in _detail_rows.get_children():
		child.queue_free()

	var option_count := 0
	for actual_slot_name in slot_names:
		var slot: AttachmentSlot = preview_weapon.attachment_manager.get_slot(actual_slot_name)
		if not slot:
			continue
		if slot_names.size() > 1:
			_add_slot_heading(_slot_side_display_name(slot), slot.is_core())
		option_count += _add_slot_options(slot)
	_detail_sub.text = _config.option_count % option_count

	_detail_panel.visible = true
	_position_detail_panel()


func _clear_slot_selection() -> void:
	if _active_slot == "" and (not _detail_panel or not _detail_panel.visible):
		return
	_active_slot = ""
	if _detail_panel:
		_detail_panel.visible = false
	_refresh_chip_focus()
	_update_callouts()


## 详情面板跟随自由布局中的卡片移动，避免配件卡片旋转后面板脱节。
func _position_detail_panel() -> void:
	if not _detail_panel or not _detail_panel.visible:
		return
	var chip: PanelContainer = _slot_chips.get(_active_slot)
	if not chip:
		return
	var side: int = chip.get_meta("side") if chip.has_meta("side") else 1
	var target := Vector2(
		_config.chip_size.x + _config.detail_panel_offset if side < 0 else _stage.size.x - _config.chip_size.x - _config.detail_panel_width,
		clampf(chip.position.y - 40.0, 0.0, maxf(_stage.size.y - _config.detail_panel_height, 0.0))
	)
	var previous_target = _detail_panel.get_meta("_detail_target") if _detail_panel.has_meta("_detail_target") else null
	if previous_target is Vector2 and previous_target.distance_to(target) < 0.75:
		return
	_detail_panel.set_meta("_detail_target", target)
	var previous_tween = _detail_panel.get_meta("_detail_tween") if _detail_panel.has_meta("_detail_tween") else null
	if previous_tween is Tween and previous_tween.is_running():
		previous_tween.kill()
	if _detail_panel.position.distance_to(target) < 0.75:
		_detail_panel.position = target
		return
	var tween := _detail_panel.create_tween()
	tween.tween_property(_detail_panel, "position", target, _config.detail_panel_move_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_detail_panel.set_meta("_detail_tween", tween)


func _add_slot_heading(text: String, core: bool) -> void:
	var heading := Label.new()
	heading.text = "%s %s" % [text, _config.core_tag] if core else text
	heading.add_theme_font_size_override("font_size", 13)
	heading.add_theme_color_override("font_color", COL_ACCENT)
	_detail_rows.add_child(heading)


func _slot_side_display_name(slot: AttachmentSlot) -> String:
	if slot.slot_type == AttachmentSlot.SlotType.SIDE_RAIL_LEFT:
		return _config.side_rail_left
	if slot.slot_type == AttachmentSlot.SlotType.SIDE_RAIL_RIGHT:
		return _config.side_rail_right
	return slot.get_slot_key()


func _add_slot_options(slot: AttachmentSlot) -> int:
	var slot_name := slot.get_slot_key()
	var options := AttachmentCatalog.for_slot(slot)
	var current: AttachmentConfig = _draft.get(slot_name, null)

	if current:
		# 核心配件允许在草稿中卸下；真正应用时由 _missing_core_slots() 拦截。
		if slot.is_core():
			var core_hint := Label.new()
			core_hint.text = _config.core_hint
			core_hint.add_theme_font_size_override("font_size", 12)
			core_hint.add_theme_color_override("font_color", COL_MUTED)
			_detail_rows.add_child(core_hint)
		_add_detach_row(slot_name)
		if current.rail_adjustable:
			_add_rail_offset_row(slot_name, current)

	if options.is_empty():
		var empty := Label.new()
		empty.text = _config.list_empty
		empty.add_theme_font_size_override("font_size", 13)
		empty.add_theme_color_override("font_color", COL_MUTED)
		_detail_rows.add_child(empty)
	else:
		for cfg in options:
			_add_option_row(cfg, current, slot_name)
	return options.size()


## current: 该槽位草稿中已装的配件（null = 空）。
## 已装的这一件显示"已安装"；槽位空 → "安装"；槽位已有别的件 → "更换"，直接顶替，
## 不需要先卸下再装。
func _add_option_row(cfg: AttachmentConfig, current: AttachmentConfig, slot_name: String) -> void:
	var installed: bool = current == cfg
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
	if installed:
		action.text = _config.installed
	elif current != null:
		action.text = _config.replace
	else:
		action.text = _config.install
	action.custom_minimum_size = Vector2(78, 32)
	action.focus_mode = Control.FOCUS_NONE
	action.disabled = installed
	_style_button(action, not installed)
	if not installed:
		action.pressed.connect(func(): _set_draft_slot(slot_name, cfg))
	hbox.add_child(action)


func _add_detach_row(slot_name: String) -> void:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", _box(COL_DANGER_DIM, COL_DANGER, 3))
	_detail_rows.add_child(row)
	var hbox := HBoxContainer.new()
	row.add_child(hbox)
	var label := Label.new()
	label.text = _config.detach
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_DANGER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(label)
	var button := Button.new()
	button.text = _config.detach_short
	button.custom_minimum_size = Vector2(78, 32)
	button.focus_mode = Control.FOCUS_NONE
	_style_button(button, false)
	button.pressed.connect(func(): _clear_draft_slot(slot_name))
	hbox.add_child(button)


func _add_rail_offset_row(slot_name: String, cfg: AttachmentConfig) -> void:
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 3)
	_detail_rows.add_child(section)

	var header := HBoxContainer.new()
	section.add_child(header)
	var label := Label.new()
	label.text = _config.rail_position
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", COL_MUTED)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(label)
	var value_label := Label.new()
	value_label.add_theme_font_size_override("font_size", 12)
	value_label.add_theme_color_override("font_color", COL_TEXT)
	header.add_child(value_label)

	var slider := HSlider.new()
	slider.min_value = cfg.rail_offset_min
	slider.max_value = cfg.rail_offset_max
	slider.step = _config.rail_slider_step
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var offset := clampf(float(_draft_rail_offsets.get(slot_name, cfg.rail_offset)), slider.min_value, slider.max_value)
	slider.value = offset
	value_label.text = _format_rail_offset(offset)
	slider.tooltip_text = _config.rail_position_hint
	slider.value_changed.connect(func(value: float):
		value_label.text = _format_rail_offset(value)
		_set_draft_rail_offset(slot_name, value)
	)
	section.add_child(slider)


func _format_rail_offset(offset: float) -> String:
	return "%+.0f mm" % (offset * 1000.0)


# ── 草稿编辑（不动真枪）──────────────────────────────────────

func _set_draft_slot(slot_name: String, cfg: AttachmentConfig) -> void:
	_draft[slot_name] = cfg
	if cfg.rail_adjustable:
		_draft_rail_offsets[slot_name] = clampf(cfg.rail_offset, cfg.rail_offset_min, cfg.rail_offset_max)
	else:
		_draft_rail_offsets.erase(slot_name)
	_dirty = true
	_rebuild_all()


func _clear_draft_slot(slot_name: String) -> void:
	if not _draft.has(slot_name) and not _draft_rail_offsets.has(slot_name):
		return
	_draft.erase(slot_name)
	_draft_rail_offsets.erase(slot_name)
	# 挂在该配件子槽位上的草稿项会暂时"无处安放"，故意保留：
	# 若玩家又把父件装回来，这些配件会自动复位（见 _restore_attachments）
	_dirty = true
	_rebuild_all()


func _set_draft_rail_offset(slot_name: String, offset: float) -> void:
	var cfg: AttachmentConfig = _draft.get(slot_name, null)
	if not cfg or not cfg.rail_adjustable:
		return
	var clamped := clampf(offset, cfg.rail_offset_min, cfg.rail_offset_max)
	_draft_rail_offsets[slot_name] = clamped
	_dirty = true
	_preview.set_rail_offset(slot_name, clamped)
	_refresh_stats()
	_refresh_apply_state()
	_update_callouts()


## 草稿中仍空缺的核心槽位（读预览武器，即草稿的实际装配结果）
func _missing_core_slots() -> Array[String]:
	var missing: Array[String] = []
	var preview_weapon = _preview.get_weapon()
	if not preview_weapon or not preview_weapon.attachment_manager:
		return missing
	for slot in preview_weapon.attachment_manager.get_slots():
		var s := slot as AttachmentSlot
		if s.is_core() and s.current_attachment == null:
			missing.append(s.get_slot_key())
	return missing


func _refresh_apply_state() -> void:
	if not _apply_button:
		return
	var missing := _missing_core_slots()
	var blocked := not missing.is_empty()
	_apply_button.disabled = blocked or not _dirty
	_revert_button.disabled = not _dirty
	if blocked:
		_notice.text = _config.core_blocked % ", ".join(missing)
		_notice.visible = true
	else:
		_notice.visible = false


## 把草稿写回真枪：逐槽比对，不同就先卸后装；反复扫描直到稳定，
## 保证嵌套槽位（机匣盖→导轨、护木→下挂）也能正确落位。
func _apply_changes() -> void:
	if not _missing_core_slots().is_empty():
		return
	var weapon = _current_weapon()
	if not weapon or not weapon.attachment_manager:
		return
	var am = weapon.attachment_manager
	var guard := 0
	var progressed := true
	while progressed and guard < 16:
		guard += 1
		progressed = false
		var keys: Array[String] = []
		for slot in am.get_slots():
			keys.append((slot as AttachmentSlot).get_slot_key())
		for key in keys:
			var slot: AttachmentSlot = am.get_slot(key)
			if not slot:
				continue
			var want: AttachmentConfig = _draft.get(key, null)
			var have: AttachmentConfig = slot.current_attachment.config \
				if slot.current_attachment else null
			if want == have:
				continue
			if slot.current_attachment:
				am.detach_from_slot(key)
				progressed = true
			if want:
				var att := AttachmentFactory.create(want, weapon)
				if att and am.equip_to_slot(att, key):
					progressed = true
				elif att:
					att.queue_free()
	for slot_name in _draft_rail_offsets:
		am.set_rail_offset(slot_name, float(_draft_rail_offsets[slot_name]))
	_dirty = false
	GlobalLogger.info("WeaponMod", "改装已应用到武器")
	_rebuild_all()


func _revert_changes() -> void:
	_draft = _capture_attachment_state()
	_draft_rail_offsets = _capture_rail_offsets()
	_dirty = false
	_rebuild_all()


# ── 数据条 ──────────────────────────────────────────────────

## 数据条读预览武器 —— 即草稿装配后的结果，改装收益立刻可见
func _refresh_stats() -> void:
	var weapon = _preview.get_weapon()
	if not weapon or not weapon.config:
		return
	var cfg: WeaponConfig = weapon.config
	var am = weapon.attachment_manager
	var snapshot := weapon.get_stats_snapshot()
	var stats := [
		[_config.stat_spread_hip, weapon.get_current_spread(false), 6.0, true],
		[_config.stat_spread_ads, weapon.get_current_spread(true), 1.5, true],
		[_config.stat_recoil_v, float(snapshot.get("recoil_v", 0.0)), 180.0, true],
		[_config.stat_recoil_h, float(snapshot.get("recoil_h", 0.0)), 90.0, true],
		[_config.stat_weight, cfg.weight + (am.get_total_attachment_weight() if am else 0.0), 8.0, true],
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
	tween.tween_property(bar, "value", ratio, _config.stat_bar_duration).set_trans(Tween.TRANS_CUBIC)


func _describe_modifiers(cfg: AttachmentConfig) -> String:
	var parts: PackedStringArray = []
	if not is_zero_approx(cfg.hipfire_spread_modifier):
		parts.append("%s %+.2f" % [_config.modifier_hipfire, cfg.hipfire_spread_modifier])
	if not is_zero_approx(cfg.ads_spread_modifier):
		parts.append("%s %+.2f" % [_config.modifier_ads, cfg.ads_spread_modifier])
	if not is_zero_approx(cfg.weight_kg):
		parts.append("%s %+.2fkg" % [_config.modifier_weight, cfg.weight_kg])
	if parts.is_empty():
		return _config.no_modifier
	return _config.modifier_separator.join(parts)


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
