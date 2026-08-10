class_name AttachmentFactory
extends RefCounted

# ════════════════════════════════════════════════════════════════════════
# 配件工厂 (AttachmentFactory)
# ════════════════════════════════════════════════════════════════════════
# 作用：统一创建配件实例的入口。
#       根据 AttachmentConfig 中的 attachment_type 自动选择正确的子类。
#
# 优势：
#   - 调用方无需关心具体类型，传 Config 即可
#   - 未来新增配件类型只需在这里加一个分支
#
# 用法：
#   var att = AttachmentFactory.create(red_dot_config, weapon)
#   weapon.attachment_manager.equip_to_slot(att, "OpticRail")
# ════════════════════════════════════════════════════════════════════════

## 根据配置创建一个配件实例
## 入参：cfg = 配件配置；weapon = 所属武器（用于回传）
## 返回：BaseAttachment 子类实例，失败返回 null
static func create(cfg: AttachmentConfig, weapon: BaseWeapon) -> BaseAttachment:
	# 纯数值配件：不生成任何模型节点，直接返回空 BaseAttachment
	if cfg.no_visual and cfg.attachment_type != AttachmentConfig.AttachmentType.SELECTOR_SWITCH:
		var att := BaseAttachment.new()
		att.name = cfg.attachment_name
		att.initialize(cfg, weapon)
		return att

	# 先尝试加载模型场景（如果有）
	var attachment_root: BaseAttachment = null

	# 优先用 config 里指定的场景
	if cfg.attachment_scene:
		var inst = cfg.attachment_scene.instantiate()
		if inst == null:
			# 场景损坏/实例化失败：告警后留空，回退到占位符创建
			push_warning("配件场景实例化失败: %s" % cfg.attachment_name)
		elif inst is BaseAttachment:
			attachment_root = inst
		else:
			push_warning("配件场景根节点不是 BaseAttachment: %s" % cfg.attachment_name)
			inst.queue_free()
			return null

	# 兜底：没有场景时用代码动态创建（用基础几何体占位）
	if not attachment_root:
		attachment_root = _create_default_placeholder(cfg)

	if not attachment_root:
		push_error("无法创建配件: %s" % cfg.attachment_name)
		return null

	# 注入配置
	attachment_root.initialize(cfg, weapon)
	return attachment_root

## 当没有 .tscn 场景时，用基础几何体动态拼一个占位模型
## 这样即使没有美术资源也能用，且能根据配置调整大小/颜色
static func _create_default_placeholder(cfg: AttachmentConfig) -> BaseAttachment:
	var script_class: Script = null
	match cfg.attachment_type:
		AttachmentConfig.AttachmentType.OPTIC:
			script_class = load("res://classes/weapon/weaponattachments/scopes/iron_sight.gd")
		AttachmentConfig.AttachmentType.GRIP:
			script_class = load("res://classes/weapon/weaponattachments/grips/vertical_grip.gd")
		AttachmentConfig.AttachmentType.MUZZLE:
			script_class = load("res://classes/weapon/weaponattachments/muzzles/suppressor.gd")
		AttachmentConfig.AttachmentType.BARREL_ASSEMBLY:
			script_class = load("res://classes/weapon/weaponattachments/barrel_config.gd")
		AttachmentConfig.AttachmentType.BOLT_CARRIER:
			script_class = load("res://classes/weapon/weaponattachments/bolt_carrier_config.gd")
		AttachmentConfig.AttachmentType.MAGAZINE:
			script_class = load("res://classes/weapon/weaponattachments/magazine_config.gd")
		AttachmentConfig.AttachmentType.SELECTOR_SWITCH:
			script_class = load("res://classes/weapon/weaponattachments/selector_switch.gd")
		_:
			script_class = load("res://classes/weapon/weaponattachments/base_attachment.gd")

	var att = Node3D.new()
	att.set_script(script_class)
	att.name = cfg.attachment_name

	var mesh_inst = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.05, 0.05, 0.1)
	mesh_inst.mesh = box
	mesh_inst.name = "PlaceholderMesh"
	att.add_child(mesh_inst)

	return att
