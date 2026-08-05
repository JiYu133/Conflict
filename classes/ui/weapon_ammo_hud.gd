extends CanvasLayer

## 弹药 HUD（右下角）
## 显示：膛内标记 + 当前弹匣余弹 / 备用弹总数 + 射击模式
## 数据来自 BaseWeapon.ammo_component，通过 ammo_count_changed 信号刷新，
## 换武器时自动重新挂接。
##
## 配色沿用设置页/改装界面，保持整体一致。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const COL_TEXT := Color(0.945, 0.953, 0.961)
const COL_MUTED := Color(0.61, 0.64, 0.68)
const COL_LOW := Color(0.90, 0.62, 0.30)      # 余弹偏低
const COL_EMPTY := Color(0.84, 0.42, 0.39)    # 打空
const COL_PANEL := Color(0.063, 0.067, 0.075, 0.72)
const COL_BORDER := Color(1.0, 1.0, 1.0, 0.11)

## 余弹低于弹匣容量的该比例时变色提示
const LOW_AMMO_RATIO := 0.3

var _player
var _weapon: BaseWeapon
var _mag_label: Label
var _reserve_label: Label
var _mode_label: Label
var _chamber_dot: Panel


func initialize(player) -> void:
	_player = player
	if _player.weapon_manager:
		_player.weapon_manager.weapon_changed.connect(_on_weapon_changed)
		# 初始化时武器可能已装备
		_on_weapon_changed(_player.weapon_manager.current_weapon)


func _ready() -> void:
	layer = 8  # 低于通知(10)与各类菜单
	_build_ui()


func _build_ui() -> void:
	var theme := Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		theme.default_font = load(FONT_PATH)

	var panel := PanelContainer.new()
	panel.theme = theme
	var box := StyleBoxFlat.new()
	box.bg_color = COL_PANEL
	box.border_color = COL_BORDER
	box.set_border_width_all(1)
	box.set_corner_radius_all(4)
	box.content_margin_left = 16
	box.content_margin_right = 16
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", box)
	# 右下角
	panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	panel.offset_left = -230.0
	panel.offset_top = -92.0
	panel.offset_right = -28.0
	panel.offset_bottom = -28.0
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	panel.add_child(vbox)

	# 上排：膛内指示点 + 弹匣余弹 / 备弹
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	vbox.add_child(row)

	_chamber_dot = Panel.new()
	_chamber_dot.custom_minimum_size = Vector2(8, 8)
	_chamber_dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_chamber_dot.tooltip_text = "膛内有弹"
	row.add_child(_chamber_dot)

	_mag_label = Label.new()
	_mag_label.add_theme_font_size_override("font_size", 34)
	_mag_label.add_theme_color_override("font_color", COL_TEXT)
	row.add_child(_mag_label)

	_reserve_label = Label.new()
	_reserve_label.add_theme_font_size_override("font_size", 17)
	_reserve_label.add_theme_color_override("font_color", COL_MUTED)
	_reserve_label.size_flags_vertical = Control.SIZE_SHRINK_END
	row.add_child(_reserve_label)

	_mode_label = Label.new()
	_mode_label.add_theme_font_size_override("font_size", 12)
	_mode_label.add_theme_color_override("font_color", COL_MUTED)
	vbox.add_child(_mode_label)

	_refresh()


func _on_weapon_changed(weapon) -> void:
	# 断开旧武器的信号，避免换枪后重复刷新
	if is_instance_valid(_weapon) and _weapon.ammo_component:
		if _weapon.ammo_component.ammo_count_changed.is_connected(_on_ammo_changed):
			_weapon.ammo_component.ammo_count_changed.disconnect(_on_ammo_changed)
		if _weapon.fire_mode_changed.is_connected(_on_fire_mode_changed):
			_weapon.fire_mode_changed.disconnect(_on_fire_mode_changed)

	_weapon = weapon as BaseWeapon
	if is_instance_valid(_weapon):
		if _weapon.ammo_component:
			_weapon.ammo_component.ammo_count_changed.connect(_on_ammo_changed)
		_weapon.fire_mode_changed.connect(_on_fire_mode_changed)
	_refresh()


func _on_ammo_changed(_current: int, _reserve: int) -> void:
	_refresh()


func _on_fire_mode_changed(_mode: String) -> void:
	_refresh()


## 主动刷新（外部改动弹药后可调用，例如调试重置）
func refresh() -> void:
	_refresh()


func _refresh() -> void:
	if not _mag_label:
		return
	if not is_instance_valid(_weapon) or not _weapon.ammo_component:
		_mag_label.text = "--"
		_reserve_label.text = ""
		_mode_label.text = ""
		_set_dot(false)
		return

	var ammo := _weapon.ammo_component
	var in_mag: int = ammo.get_current_magazine_count()
	var reserve: int = ammo.get_reserve_count()
	_mag_label.text = str(in_mag)
	_reserve_label.text = "/ %d" % reserve

	# 余弹配色：空 → 红，低 → 橙，正常 → 白
	var capacity: float = float(_magazine_capacity())
	var col := COL_TEXT
	if in_mag <= 0:
		col = COL_EMPTY
	elif capacity > 0.0 and float(in_mag) / capacity <= LOW_AMMO_RATIO:
		col = COL_LOW
	_mag_label.add_theme_color_override("font_color", col)

	_set_dot(ammo.has_chambered_round())
	_mode_label.text = _mode_display(_weapon.current_fire_mode)


func _magazine_capacity() -> int:
	if not is_instance_valid(_weapon):
		return 0
	var mag := _weapon._get_attachment_config_of_type(MagazineConfig) as MagazineConfig
	if mag:
		return mag.magazine_capacity
	return 30


## 膛内指示点：有弹亮，空膛暗
func _set_dot(lit: bool) -> void:
	if not _chamber_dot:
		return
	var box := StyleBoxFlat.new()
	box.bg_color = COL_TEXT if lit else Color(1, 1, 1, 0.13)
	box.set_corner_radius_all(4)
	_chamber_dot.add_theme_stylebox_override("panel", box)


func _mode_display(mode: String) -> String:
	match mode:
		"safe": return "保险"
		"semi": return "单发"
		"auto": return "连发"
		"burst": return "点射"
		_: return mode
