class_name WeaponAnimationController
extends Node

# ============================================================
# 武器动画控制器
# 功能：订阅 BaseWeapon 的信号，驱动第一人称武器模型的
#       AnimationPlayer 播放对应动画片段。
#       所有动画均有 has_animation() 守卫，未制作时安全跳过。
# 用法：由 WeaponManager.equip_weapon() 创建并初始化。
#       生命周期与武器节点绑定，武器 queue_free 时自动销毁。
# ============================================================

# ---- 动画名称常量（需与武器场景 AnimationPlayer 中的名称完全一致） ----
## 待机微颤/呼吸循环
const ANIM_IDLE            := "weapon_idle"
## 每发击发：枪口上抬、枪机运动
const ANIM_FIRE            := "weapon_fire"
## 战术换弹（膛内有弹）：拔弹匣→插弹匣，不拉机柄
const ANIM_RELOAD_TACTICAL := "weapon_reload_tactical"
## 空仓换弹：拔弹匣→插弹匣→拉机柄
const ANIM_RELOAD_EMPTY    := "weapon_reload_empty"
## 进入 ADS
const ANIM_ADS_IN          := "weapon_ads_in"
## 退出 ADS
const ANIM_ADS_OUT         := "weapon_ads_out"
## 装备武器（从收枪位举起）
const ANIM_EQUIP           := "weapon_equip"
## 收枪（切换武器前放下）
const ANIM_HOLSTER         := "weapon_holster"
## 手动拉机柄（哑火/烟囱卡弹单步排障）
const ANIM_BOLT_PULL       := "weapon_bolt_pull"
## 双上膛完整排障（退弹匣→两次拉机柄）
const ANIM_MALFUNCTION_CLEAR := "weapon_malfunction_clear"

var _weapon: BaseWeapon
var _anim_player: AnimationPlayer
var _anim_tree: AnimationTree


## 初始化：传入武器节点，自动查找其下的 AnimationPlayer，并连接所有武器信号。
func initialize(weapon: BaseWeapon) -> void:
	_weapon = weapon
	_anim_player = weapon.find_child("AnimationPlayer", true, false) as AnimationPlayer
	_anim_tree = weapon.find_child("AnimationTree", true, false) as AnimationTree
	if not _anim_player:
		push_warning("WeaponAnimationController: 未找到 AnimationPlayer，所有武器动画将被跳过。")
	_connect_weapon_signals()
	_play_safe(ANIM_EQUIP)


func _connect_weapon_signals() -> void:
	_weapon.fired.connect(_on_fired)
	_weapon.bolt_moving.connect(_on_bolt_moving)
	_weapon.reload_started.connect(_on_reload_started)
	_weapon.bolt_hold_open.connect(_on_bolt_hold_open)
	_weapon.malfunction_occurred.connect(_on_malfunction_occurred)
	_weapon.malfunction_cleared.connect(_on_malfunction_cleared)


# ---- 信号回调 ------------------------------------------------

func _on_fired() -> void:
	_play_safe(ANIM_FIRE)


## bolt_moving(position: float) — 将枪机位置写入 AnimationTree 参数（如有）
## 约定参数路径："parameters/bolt_position/blend_position"（BlendSpace1D 节点）
## AnimationTree 属性路径不是场景节点，直接 set() 即可，不存在时静默忽略
func _on_bolt_moving(position: float) -> void:
	if _anim_tree and _anim_tree.active:
		_anim_tree.set("parameters/bolt_position/blend_position", position)


func _on_reload_started() -> void:
	if not _weapon or not _weapon.ammo_component:
		return
	if _weapon.ammo_component.has_chambered_round():
		_play_safe(ANIM_RELOAD_TACTICAL)
	else:
		_play_safe(ANIM_RELOAD_EMPTY)


func _on_bolt_hold_open() -> void:
	# 空仓挂机时可以播放一个"枪机到底"的静止姿势过渡，或直接跳到 idle
	_play_safe(ANIM_IDLE)


func _on_malfunction_occurred(_type: BoltComponent.JamType) -> void:
	# 故障发生时武器停在故障姿态，等待玩家触发排障
	pass


func _on_malfunction_cleared() -> void:
	_play_safe(ANIM_IDLE)


# ---- ADS 动画（由 WeaponManager.set_aiming() 调用） ----------

func play_ads_in() -> void:
	_play_safe(ANIM_ADS_IN)


func play_ads_out() -> void:
	_play_safe(ANIM_ADS_OUT)


# ---- 排障动画（由 WeaponAnimationController 或外部调用） ------

## 单步排障动画（哑火/烟囱卡弹）
func play_malfunction_bolt_pull() -> void:
	_play_safe(ANIM_BOLT_PULL)


## 多步排障动画（双上膛）
func play_malfunction_clear() -> void:
	_play_safe(ANIM_MALFUNCTION_CLEAR)


# ---- 装备/收枪（切换武器时由 WeaponManager 调用） -------------

func play_equip() -> void:
	_play_safe(ANIM_EQUIP)


func play_holster() -> void:
	_play_safe(ANIM_HOLSTER)


# ---- 内部工具 ------------------------------------------------

## 安全播放：无 AnimationPlayer 或动画不存在时静默跳过。
func _play_safe(anim_name: String) -> void:
	if not _anim_player:
		return
	if not _anim_player.has_animation(anim_name):
		return
	_anim_player.play(anim_name)
