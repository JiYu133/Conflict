class_name BaseAttachment
extends Node3D

# ════════════════════════════════════════════════════════════════════════
# 配件基类 (BaseAttachment)
# ════════════════════════════════════════════════════════════════════════
# 作用：所有武器配件（瞄具/握把/枪口/弹匣）的根节点。
#       每个配件实例化时挂一个配置 (AttachmentConfig)，就能在武器上工作。
#
# 用法：
#   1. 在 Godot 编辑器创建 .tscn 场景，根节点挂这个脚本
#   2. 添加子节点做模型（BoxMesh/CylinderMesh 等）
#   3. WeaponManager 通过 AttachmentManager.equip() 把配件装到对应槽位
#
# 数值计算方式：
#   武器原始值 + 配件修正值 = 实际值
#   例：原散布 3.0°，红点修正 -0.5° → 实际 2.5°
# ════════════════════════════════════════════════════════════════════════

# ──────────────────────────── 公开属性 ────────────────────────────
var config: AttachmentConfig
## 当前配件的配置资源

var parent_weapon: BaseWeapon = null
## 所属武器的引用（用于回传数值修正）

# ──────────────────────────── 初始化 ────────────────────────────
## 用配置资源初始化配件
func initialize(cfg: AttachmentConfig, weapon: BaseWeapon) -> void:
	config = cfg
	parent_weapon = weapon
	_on_initialized()
	GlobalLogger.debug("BaseAttachment", "配件 %s 初始化完成" % cfg.attachment_name)

## 子类可重写：自定义初始化逻辑（例如实例化模型）
func _on_initialized() -> void:
	pass

# ──────────────────────────── 数值计算接口 ────────────────────────────
## 返回对散布的总修正（度）
## 子类可重写以加入特殊逻辑（如：ACOG只在ADS时生效）
func get_spread_modifier(is_ads: bool) -> float:
	if is_ads:
		return config.ads_spread_modifier
	return config.hipfire_spread_modifier

## 返回瞄准速度的修正
func get_ads_speed_modifier() -> float:
	return config.ads_speed_modifier

## 返回配件重量（kg）
func get_weight() -> float:
	return config.weight_kg

## 是否抑制枪口火光
func suppresses_muzzle_flash() -> bool:
	return config.suppresses_flash

## 是否抑制枪声
func suppresses_sound() -> bool:
	return config.suppresses_sound

## 返回枪口长度修正（m），消音器等枪口装置有值
func get_length_modifier() -> float:
	return config.length_modifier

## 获取放大倍率
func get_magnification() -> float:
	return config.magnification

## 获取视野覆盖（-1表示用摄像机默认FOV）
func get_fov_override() -> float:
	return config.fov_override

# ──────────────────────────── 视觉接口 ────────────────────────────
## 隐藏/显示准星（机瞄时显示瞄具准星，隐藏默认准星）
func set_reticle_visible(visible: bool) -> void:
	# 默认无准星节点，子类按需重写
	pass
