class_name MedicalDebugMenu
extends CanvasLayer

# ============================================================
# 医疗调试菜单（仅 debug 构建；M 键开关）
# 功能：把所有"临时测试用"的医疗操作集中到一个菜单里，
#       避免调试快捷键散落在正常游戏输入路径中与后续玩法冲突：
#   - 原地复活并清除全部伤情
#   - 注入指定部位/严重度/出血等级的伤口
#   - 直接设置血量百分比
#   - 清除全部伤口
#   - 触发三种死亡类型
# 用法：由 BasePlayer 在 debug 构建下创建并 initialize(player)。
#       打开时显示鼠标并冻结玩家输入，关闭时恢复。
# ============================================================

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"

const PART_ITEMS: Array = [
	["头部",   MedicalEnums.BodyPartId.HEAD],
	["躯干",   MedicalEnums.BodyPartId.TORSO],
	["左上臂", MedicalEnums.BodyPartId.LEFT_UPPER_ARM],
	["左前臂", MedicalEnums.BodyPartId.LEFT_FOREARM],
	["右上臂", MedicalEnums.BodyPartId.RIGHT_UPPER_ARM],
	["右前臂", MedicalEnums.BodyPartId.RIGHT_FOREARM],
	["左大腿", MedicalEnums.BodyPartId.LEFT_THIGH],
	["左小腿", MedicalEnums.BodyPartId.LEFT_CALF],
	["右大腿", MedicalEnums.BodyPartId.RIGHT_THIGH],
	["右小腿", MedicalEnums.BodyPartId.RIGHT_CALF],
]

## 出血等级下拉项；-1 = 按严重度自动分类（走 HealthSystem._classify_bleed）
const BLEED_ITEMS: Array = [
	["自动（按严重度）", -1],
	["不出血",           MedicalEnums.BleedRate.NONE],
	["毛细血管出血",     MedicalEnums.BleedRate.CAPILLARY],
	["静脉出血",         MedicalEnums.BleedRate.VENOUS],
	["动脉出血",         MedicalEnums.BleedRate.ARTERIAL],
]

var _player: BasePlayer = null
var _was_controllable: bool = false

var _part_option: OptionButton
var _bleed_option: OptionButton
var _severity_slider: HSlider
var _severity_label: Label
var _blood_slider: HSlider
var _blood_label: Label


func initialize(player: BasePlayer) -> void:
	_player = player


func _ready() -> void:
	layer = 12  # 在死亡黑屏(9)与通知(10)之上
	visible = false
	_build_ui()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		toggle()


func toggle() -> void:
	if visible:
		_close()
	else:
		_open()


func _open() -> void:
	visible = true
	if _player:
		_was_controllable = _player.controllable
		_player.set_controllable(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _close() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if _player:
		# 死亡玩家保持不可控（与 FreeCameraController 的恢复逻辑一致）
		_player.set_controllable(_was_controllable and _player.is_alive)


# ── UI 构建（纯代码，与项目其他 UI 一致）────────────────────

func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.anchor_left = 0.0
	panel.anchor_top = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = 16.0
	panel.offset_top = -220.0
	panel.offset_bottom = 220.0
	panel.custom_minimum_size = Vector2(320, 0)
	if ResourceLoader.exists(FONT_PATH):
		var theme := Theme.new()
		theme.default_font = load(FONT_PATH)
		theme.default_font_size = 14
		panel.theme = theme
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	_add_title(vbox, "医疗调试菜单（M 关闭）")

	# ── 状态操作 ──
	_add_section(vbox, "状态操作")
	_add_button(vbox, "原地复活并清除全部伤情 (R)", _on_revive_pressed)
	_add_button(vbox, "清除全部伤口", _on_clear_wounds_pressed)

	# ── 击杀测试 ──
	_add_section(vbox, "击杀测试")
	var kill_row := HBoxContainer.new()
	kill_row.add_theme_constant_override("separation", 6)
	vbox.add_child(kill_row)
	_add_button(kill_row, "正面死亡", func(): _kill(PlayerRagdollSystem.DeathType.FRONT))
	_add_button(kill_row, "正面爆头", func(): _kill(PlayerRagdollSystem.DeathType.FRONT_HEADSHOT))
	_add_button(kill_row, "爆炸", func(): _kill(PlayerRagdollSystem.DeathType.EXPLOSION))

	# ── 伤情注入 ──
	_add_section(vbox, "伤情注入")
	_part_option = OptionButton.new()
	for item in PART_ITEMS:
		_part_option.add_item(item[0])
	vbox.add_child(_part_option)

	_bleed_option = OptionButton.new()
	for item in BLEED_ITEMS:
		_bleed_option.add_item(item[0])
	vbox.add_child(_bleed_option)

	_severity_label = Label.new()
	vbox.add_child(_severity_label)
	_severity_slider = HSlider.new()
	_severity_slider.min_value = 0.05
	_severity_slider.max_value = 2.0
	_severity_slider.step = 0.05
	_severity_slider.value = 0.5
	_severity_slider.value_changed.connect(func(_v): _update_labels())
	vbox.add_child(_severity_slider)
	_add_button(vbox, "注入伤口", _on_spawn_wound_pressed)

	# ── 血量 ──
	_add_section(vbox, "血量")
	_blood_label = Label.new()
	vbox.add_child(_blood_label)
	_blood_slider = HSlider.new()
	_blood_slider.min_value = 0.0
	_blood_slider.max_value = 100.0
	_blood_slider.step = 1.0
	_blood_slider.value = 100.0
	_blood_slider.value_changed.connect(func(_v): _update_labels())
	vbox.add_child(_blood_slider)
	_add_button(vbox, "设置血量", _on_set_blood_pressed)

	_update_labels()


func _add_title(parent: Control, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 16)
	parent.add_child(label)


func _add_section(parent: Control, text: String) -> void:
	var label := Label.new()
	label.text = "── " + text + " ──"
	label.add_theme_color_override("font_color", Color(0.7, 0.85, 1.0))
	parent.add_child(label)


func _add_button(parent: Control, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)


func _update_labels() -> void:
	_severity_label.text = "严重度: %.2f" % _severity_slider.value
	_blood_label.text = "血量: %d%%" % int(_blood_slider.value)


# ── 按钮回调 ───────────────────────────────────────────────

func _get_health() -> HealthSystem:
	return _player.health_system if _player else null


func _on_revive_pressed() -> void:
	if not _player or _player.is_alive:
		return
	_player.revive()
	# 复活后玩家恢复可控；菜单保持打开，关闭时以存活状态恢复输入
	_was_controllable = true
	_player.set_controllable(false)  # 菜单仍开着，先保持冻结


func _on_clear_wounds_pressed() -> void:
	var health := _get_health()
	if health:
		health.debug_clear_wounds()


func _kill(death_type: PlayerRagdollSystem.DeathType) -> void:
	if _player and _player.is_alive:
		_player.die(death_type)


func _on_spawn_wound_pressed() -> void:
	var health := _get_health()
	if not health:
		return
	var part: MedicalEnums.BodyPartId = PART_ITEMS[_part_option.selected][1]
	var bleed_override: int = BLEED_ITEMS[_bleed_option.selected][1]
	health.debug_add_wound(part, _severity_slider.value, bleed_override)


func _on_set_blood_pressed() -> void:
	var health := _get_health()
	if health:
		health.debug_set_blood_pct(_blood_slider.value / 100.0)
