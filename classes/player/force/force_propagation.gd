class_name ForcePropagation
extends RefCounted

# ============================================================
# 力的骨骼链传播求解器
# 功能：从作用点骨骼出发，对骨骼树做深度受限的 BFS（父与子都走），
#       按层级距离给出衰减权重。结果按作用点骨骼索引缓存。
# 说明：纯层级距离，不使用检查器权重表，因此链条沿脊柱自然覆盖到
#       Neck/Head，也能反向覆盖到手/脚。
# ============================================================

var _skeleton: Skeleton3D = null
var _decay_per_level: float = 0.67
var _max_depth: int = 6
var _children: Dictionary = {}  # int parent_idx → Array[int] child_idx
var _cache: Dictionary = {}     # int hit_bone_idx → Dictionary


## 绑定骨架与衰减参数；会清空已有缓存。
func configure(skeleton: Skeleton3D, decay_per_level: float, max_depth: int) -> void:
	_skeleton = skeleton
	_decay_per_level = clampf(decay_per_level, 0.0, 1.0)
	_max_depth = maxi(max_depth, 0)
	_rebuild_children()
	_cache.clear()


## 清空按作用点缓存的权重表（骨架或配置变化时调用）。
func invalidate() -> void:
	_cache.clear()


func is_configured() -> bool:
	return is_instance_valid(_skeleton)


func get_skeleton() -> Skeleton3D:
	return _skeleton


func get_max_depth() -> int:
	return _max_depth


## 返回作用点骨骼影响到的全部骨骼。
## 结构：{ bone_idx: {"depth": int, "weight": float} }
## 超出 max_propagation_depth 的骨骼不会出现在结果中（等价于权重 0）。
func weights_for(hit_bone_idx: int) -> Dictionary:
	if not is_instance_valid(_skeleton):
		return {}
	if hit_bone_idx < 0 or hit_bone_idx >= _skeleton.get_bone_count():
		return {}
	if _cache.has(hit_bone_idx):
		return _cache[hit_bone_idx]
	var result := _breadth_first(hit_bone_idx)
	_cache[hit_bone_idx] = result
	return result


func _rebuild_children() -> void:
	_children.clear()
	if not is_instance_valid(_skeleton):
		return
	for bone_idx in _skeleton.get_bone_count():
		var parent_idx := _skeleton.get_bone_parent(bone_idx)
		if not _children.has(parent_idx):
			_children[parent_idx] = []
		_children[parent_idx].append(bone_idx)


func _neighbors(bone_idx: int) -> Array:
	var result: Array = []
	var parent_idx := _skeleton.get_bone_parent(bone_idx)
	if parent_idx >= 0:
		result.append(parent_idx)
	for child_idx in _children.get(bone_idx, []):
		result.append(child_idx)
	return result


func _breadth_first(start_idx: int) -> Dictionary:
	var result: Dictionary = {}
	var visited: Dictionary = {start_idx: true}
	var depth_of: Dictionary = {start_idx: 0}
	var queue: Array[int] = [start_idx]
	var head := 0
	while head < queue.size():
		var bone_idx: int = queue[head]
		head += 1
		var depth: int = depth_of[bone_idx]
		result[bone_idx] = {
			"depth": depth,
			"weight": pow(_decay_per_level, float(depth)),
		}
		if depth >= _max_depth:
			continue
		for neighbor in _neighbors(bone_idx):
			var neighbor_idx: int = int(neighbor)
			if visited.has(neighbor_idx):
				continue
			visited[neighbor_idx] = true
			depth_of[neighbor_idx] = depth + 1
			queue.append(neighbor_idx)
	return result
