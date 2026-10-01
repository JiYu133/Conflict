class_name StaminaConfig
extends Resource

# ============================================================
# 体力系统配置
# 功能：定义体力上限、消耗、恢复、耗尽惩罚及行为约束等全部参数。
# 用法：在编辑器中创建 .tres 资源，挂载到 PlayerConfig.stamina_config。
#       未挂载时 StaminaSystem 以本文件默认值运行。
# ============================================================

# 体力上限 ────────────────────────────────────────────────────
@export_group("体力上限")
## 正常状态下的体力上限
@export var max_stamina: float = 100.0
## 呼吸受损时体力上限最低可降至正常上限的倍率
## （breathing_effectiveness=0 时上限 = max_stamina * breathing_stamina_min_factor）
@export var breathing_stamina_min_factor: float = 0.5

# 体力消耗 ────────────────────────────────────────────────────
@export_group("体力消耗")
## 冲刺时每秒消耗体力
@export var sprint_cost_per_sec: float = 20.0
## 奔跑时每秒消耗体力
@export var run_cost_per_sec: float = 8.0
## 行走时每秒消耗体力（满体力时仍按此值扣除）
@export var walk_cost_per_sec: float = 0.5
## 跳跃瞬间消耗体力
@export var jump_cost: float = 15.0
## 半蹲持续消耗倍率（walk_cost_per_sec × stance_value × 此倍率）
@export var crouch_cost_multiplier: float = 3.0
## 趴下/起身过渡期间的体力消耗倍率（walk_cost_per_sec × 此倍率）。稳定趴下时不消耗体力。
@export var prone_transition_cost_multiplier: float = 3.0
## 俯卧翻滚首次消耗的体力值。
@export var prone_roll_base_cost: float = 12.0
## 连续翻滚时每增加一次连滚计数所增加的体力消耗。
@export var prone_roll_increment_cost: float = 4.0
## 单次俯卧翻滚允许消耗的最大体力值。
@export var prone_roll_max_cost: float = 28.0

## 进入负重耐力惩罚的参考重量（kg）
@export var carry_weight_reference_kg: float = 3.5
## 每超过参考重量 1 kg，运动耐力消耗增加的比例
@export_range(0.0, 1.0, 0.01) var carry_weight_cost_per_kg: float = 0.08
## 防止极端重量配置让耐力消耗失控
@export var carry_weight_max_multiplier: float = 2.0

# 体力恢复 ────────────────────────────────────────────────────
@export_group("体力恢复")
## 静止时每秒恢复体力
@export var recovery_rate_idle: float = 25.0
## 行走时每秒恢复体力
@export var recovery_rate_walk: float = 12.0
## 停止运动后到开始恢复之间的延迟（秒）
@export var recovery_delay: float = 1.0

# 耗尽阈值 ────────────────────────────────────────────────────
@export_group("耗尽阈值")
## 体力降至此值时进入耗尽状态
@export var exhaustion_threshold: float = 0.0
## 体力恢复至此值后解除耗尽（滞回区间，防止在阈值附近反复抖动）
@export var recovery_threshold: float = 20.0

# 耗尽惩罚 ────────────────────────────────────────────────────
@export_group("耗尽惩罚")
## 耗尽时瞄准稳定性乘数（<1.0 = 晃动增大）
@export var exhausted_aim_penalty: float = 0.5
## 耗尽时换弹速度乘数（<1.0 = 换弹变慢）
@export var exhausted_reload_speed_mult: float = 0.7

# 耗尽行为约束 ────────────────────────────────────────────────
@export_group("耗尽行为约束")
## 耗尽时禁止奔跑（快步行走）
@export var exhausted_disable_run: bool = true
## 耗尽时禁止冲刺
@export var exhausted_disable_sprint: bool = true
## 耗尽时禁止跳跃
@export var exhausted_disable_jump: bool = false

# 体力阈值行为 ────────────────────────────────────────────────
@export_group("体力阈值行为")
## 低于此体力百分比时禁止冲刺（0 = 仅耗尽时禁止）
@export var sprint_disable_below: float = 0.0
## 低于此体力百分比时禁止奔跑（0 = 仅耗尽时禁止）
@export var run_disable_below: float = 0.0
## 低于此体力百分比时发出喘气信号
@export var breath_signal_threshold: float = 0.3
