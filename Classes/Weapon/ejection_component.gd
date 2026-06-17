class_name EjectionComponent
extends Node

# ============================================================
# 抛壳组件
# 功能：确定弹壳从抛壳窗飞出时的位置和初始速度。
#       被击发后的弹壳由枪机后坐抽出→抛壳挺撞击→抛出枪身。
# 依赖：WeaponConfig（需要 weapon_type 以确定抛壳窗位置）
# 说明：当前为硬编码位置，后续应根据武器模型自动检测抛壳窗挂载点。
# ============================================================

var config: WeaponConfig

# 抛壳参数（世界空间坐标偏移，相对武器节点原点）
var _ejection_port_position: Vector3 = Vector3(0.05, 0.0, 0.2)
## 抛壳窗位置偏移：向右 5cm，向前 20cm（右手枪、AR 布局的常见位置）

var _ejection_velocity: Vector3 = Vector3(1.0, 2.0, -0.5)
## 弹壳抛出速度：向右 1m/s + 向上 2m/s + 向后 0.5m/s


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("EjectionComponent 初始化完成")


# ============================================================
# 抛壳参数查询
# ============================================================

## 获取弹壳弹出位置（相对武器节点的偏移）
func get_ejection_position() -> Vector3:
	return _ejection_port_position

## 获取弹壳初始速度（世界空间方向）
func get_ejection_velocity() -> Vector3:
	return _ejection_velocity
