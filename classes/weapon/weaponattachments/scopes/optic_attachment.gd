class_name OpticAttachment
extends BaseAttachment

# ════════════════════════════════════════════════════════════════════════
# 瞄具基类 (OpticAttachment)
# ════════════════════════════════════════════════════════════════════════
# 作用：所有瞄具（机械瞄具/红点/全息/ACOG）的共同父类。
#       提供机瞄状态（ADS）下的准星/视野相关接口。
#
# 关键概念：机瞄（ADS, Aim Down Sights）
#   - ADS 状态由上层 WeaponManager 控制
#   - 摄像机/武器对齐到瞄具的 ADSAnchor
#   - 光学瞄具可通过独立 SubViewport 在 LensSurface 内成像
#   - ADS 只改变观察方式，不改变弹道精度
# ════════════════════════════════════════════════════════════════════════

## 瞄具激活时返回 true
## 子类可重写以实现特殊条件（如：低倍瞄具可在任何距离使用）
func is_optic_active() -> bool:
	return true


func get_ads_anchor() -> Node3D:
	return find_child("ADSAnchor", true, false) as Node3D


func get_optic_camera_anchor() -> Node3D:
	return find_child("OpticCameraAnchor", true, false) as Node3D


func get_lens_surface() -> MeshInstance3D:
	return find_child("LensSurface", true, false) as MeshInstance3D


func supports_scope_rendering() -> bool:
	return is_instance_valid(get_optic_camera_anchor()) and is_instance_valid(get_lens_surface())
