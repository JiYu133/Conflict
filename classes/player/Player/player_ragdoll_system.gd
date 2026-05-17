class_name PlayerRagdollSystem
extends Node

## 信号
signal ragdoll_enabled
signal ragdoll_disabled

## 公开属性
var is_active: bool:
	get: return _is_active

## 私有变量
var _is_active: bool = false
var _skeleton: Skeleton3D
var _animator: AnimationPlayer
var _physical_simulator: Node  # PhysicalBoneSimulator3D

## 初始化
func initialize(skeleton: Skeleton3D, animator: AnimationPlayer = null) -> void:
	_skeleton = skeleton
	_animator = animator
	
	# 查找物理骨骼模拟器（Godot 4.x 自动生成的那个节点）
	if skeleton and skeleton.get_parent():
		var simulators = skeleton.get_parent().find_children(
			"PhysicalBoneSimulator3D", "", false, false
		)
		_physical_simulator = simulators[0] if simulators.size() > 0 else null

## 启用布娃娃
func enable() -> void:
	if _is_active or not _skeleton:
		return
	
	_is_active = true
	
	# 停止动画
	if _animator:
		_animator.stop()
		_animator.active = false
	
	# 启动物理模拟
	if _physical_simulator:
		_physical_simulator.physical_bones_start_simulation()
	elif _skeleton.has_method("physical_bones_start_simulation"):
		_skeleton.physical_bones_start_simulation()
	else:
		push_error("无法启动布娃娃：找不到物理骨骼系统")
		return
	
	ragdoll_enabled.emit()
	print("布娃娃系统已激活")

## 禁用布娃娃
func disable() -> void:
	if not _is_active or not _skeleton:
		return
	
	_is_active = false
	
	if _physical_simulator:
		_physical_simulator.physical_bones_stop_simulation()
	elif _skeleton.has_method("physical_bones_stop_simulation"):
		_skeleton.physical_bones_stop_simulation()
	
	# 恢复动画
	if _animator:
		_animator.active = true
		# TODO: 播放站立动画，需要从布娃娃状态恢复到动画状态
	
	ragdoll_disabled.emit()
	print("布娃娃系统已停用")
