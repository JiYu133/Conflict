class_name GasComponent
extends Node

# ============================================================
# 导气组件
# 功能：模拟导气式自动武器的"导气孔→导气管→活塞"延时。
# 依赖：BarrelConfig（barrel_length / muzzle_velocity）
#       初始化时用 WeaponConfig 保持接口兼容，配件装上后通过 reconfigure() 更新
# ============================================================

var config: WeaponConfig

# 当前生效的枪管参数（由 reconfigure() 更新）
var _barrel_length: float = 0.415
var _muzzle_velocity: float = 900.0


func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	GlobalLogger.debug("GasComponent", "初始化完成")


## 枪管配件装卸后调用，更新导气延时所用的枪管参数
func reconfigure(barrel_cfg: BarrelConfig) -> void:
	_barrel_length   = barrel_cfg.barrel_length
	_muzzle_velocity = barrel_cfg.muzzle_velocity


## 计算从子弹经过导气孔到枪机开始后坐的延时（秒）
## 枪管参数由最近一次 reconfigure() 决定；未配置时使用默认值
func get_delay_time() -> float:
	if _muzzle_velocity <= 0.0:
		return 0.001
	return (_barrel_length / _muzzle_velocity) * 0.3
