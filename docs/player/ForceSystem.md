# 通用力反馈系统（ForceReceiver）

**文件路径：** `classes/player/force/`
**首期范围：** 只接入受击反馈（`HealthSystem.damage_taken`）；不接开火，不碰摄像机。

## 功能概述

与伤害来源解耦的通用力系统。任何系统把“力”交给 `ForceReceiver`，力沿骨骼链按层级距离衰减
传播，在动画姿态之上叠加旋转与限幅位移；IK 独立运行，形成自然对抗（被推开的左手仍会被
`TwoBoneIK3D` 拉回武器握把）。

存活姿态受力与死亡倒下受力同源：力载荷同时携带归一化强度与真实物理量，布娃娃死亡时优先
消费力系统缓存的冲量。

## 模块

| 文件 | 类型 | 职责 |
|---|---|---|
| `force_types.gd` | `ForceTypes` / `ForceTypes.ForcePayload` | 力载荷数据结构、衰减曲线枚举、`BodyPartId → 骨骼名` 兜底映射 |
| `force_config.gd` | `ForceConfig`（Resource） | 衰减、传播深度、姿态增益与上限、冲量换算比例 |
| `force_propagation.gd` | `ForcePropagation` | 深度受限 BFS，按层级距离给出逐骨骼权重（带缓存） |
| `force_receiver.gd` | `ForceReceiver`（Node） | 受力入口、姿态偏移求解、待用冲量缓存 |
| `force_body_modifier.gd` | `ForceBodyModifier`（SkeletonModifier3D） | 每帧还原基准姿态后重新叠加旋转与限幅位移 |

## 力的表示

`ForceTypes.ForcePayload` 字段分为两组：

- **归一化量**：`magnitude`（0–1，驱动姿态偏移，便于调参）、`duration`、`decay_curve`、`elapsed`；
- **物理量**：`mass_kg`、`speed_mps`、`impulse_ns`（驱动布娃娃并对外暴露）。

方向语义：

- `has_origin = false` → 全局同向（子弹/近战）；
- `has_origin = true` → 以 `origin_world` 为点源径向发力（爆炸）。

`Space.LOCAL` 时，`direction` 与 `origin` 会先按玩家世界朝向换算。

## 传播

从作用点骨骼出发对骨骼树做深度受限 BFS，**父与子都走**，因此链条天然覆盖到
`Neck`/`Head`，也能反向覆盖到手/脚。权重 = `decay_per_level ^ depth`，
超过 `max_propagation_depth` 的骨骼不参与。结果按作用点骨骼索引缓存
（`ForcePropagation.weights_for()`）。

默认 `decay_per_level = 0.67`、`max_propagation_depth = 6`。

## 姿态偏移

旋转与位移都施加：

- **旋转**：`bone_chain_direction × force_direction` 得到世界空间旋转轴，
  角度 = `rotation_gain × effective`。沿用了 `SpineAimModifier` 已验证的
  “父骨骼 basis⁻¹ → 全局旋转 → 骨骼局部”换算。
- **位移**：按骨骼深度限制（`translation_max_depth`，默认仅 depth ≤ 1），
  并硬性钳制到 `max_translation_m`，防止骨骼拉伸/穿插。

骨骼链条朝向取自**静止姿态**并缓存，不随每帧偏移变化，避免正反馈。

## 叠加与上限

多力独立衰减、逐骨骼求和。求和后若超过 `pose_cap`，偏移量不再增加，仅发
`overload_triggered`（边沿触发，默认振幅 0 的微幅抖动可选用）。

`overload_threshold` 与 `pose_cap` 作用在同一量纲上——**受力最重的单块骨骼的累计强度**，
因此默认两者相等，含义为“某块骨骼刚到偏移上限时触发 overload”。

## 公开 API（`ForceReceiver`）

### `apply_force(...) -> void`

```gdscript
apply_force(
    direction: Vector3,
    magnitude: float,
    hit_bone: String = "",
    duration: float = 0.0,
    decay_curve: String = "exponential",
    origin: Vector3 = Vector3.ZERO,
    space: ForceTypes.Space = ForceTypes.Space.WORLD,
    mass_kg: float = 0.0,
    speed_mps: float = 0.0,
    impulse_ns: float = -1.0
) -> void
```

前五个参数为稳定签名。`duration <= 0` 时使用 `ForceConfig.default_duration`。
`hit_bone` 为空或解析不到骨骼时静默丢弃并记 `GlobalLogger.warn`。

### `apply_impact(info: DamageInfo) -> void`

由 `impact_mass_kg` 与 `amount`(J) 推出 `impulse_ns = sqrt(2·m·E)·transfer_ratio`，
并换算归一化 `magnitude`；同时缓存“待用冲量”供布娃娃消费。

传递比例按情形选择：爆头 → `headshot_energy_transfer`；爆炸 →
`explosion_energy_transfer`；其余 → `impact_energy_transfer`。

弹道伤害缺少弹头质量时不猜质量，直接返回（与布娃娃原有策略一致）。

### 布娃娃接口

| 方法 | 说明 |
|---|---|
| `consume_pending_impulse() -> Dictionary` | 一次性取走 `{direction, impulse_ns, hit_bone}`，第二次返回空 |
| `clear_pending_impulse() -> void` | 只清冲量 |
| `clear_forces() -> void` | 清空所有生效中的力与姿态偏移（不影响待用冲量） |

### 查询与信号

| 成员 | 说明 |
|---|---|
| `get_total_magnitude() -> float` | 受力最重骨骼的累计强度，overload 判定依据 |
| `get_pose_offsets() -> Dictionary` | 逐骨骼 `{axis, angle, translation, depth}` |
| `get_pose_snapshot() -> Dictionary` | 调试/测试用完整快照 |
| `force_applied(payload)` | 新力被接受 |
| `overload_triggered(total)` | 累计强度越过阈值（边沿触发一次） |

## 执行顺序

`BasePlayer._on_model_loaded()` 把 `ForceBodyModifier` 插在 `SpineAimModifier` 之后、
第一个 `TwoBoneIK3D` 之前。`SkeletonModifier3D` 的兄弟顺序即执行顺序，因此
**IK 拥有最终发言权**。

每帧流程：还原上一帧动过的骨骼到基准姿态 → 重新应用当前力的旋转/位移。
还原步骤是“每帧累加漂移”问题的根因修复。

## 配置依赖

`ForceConfig` 参数组：

- **传播**：`decay_per_level`、`max_propagation_depth`、`default_duration`、`decay_floor`
- **姿态偏移**：`rotation_gain`、`translation_gain`、`max_translation_m`、`translation_max_depth`
- **叠加与上限**：`pose_cap`、`overload_threshold`、`overload_jitter`、`max_active_forces`
- **冲量换算**：`pose_reference_impulse`、`impact_energy_transfer`、`headshot_energy_transfer`、
  `explosion_energy_transfer`、`fallback_impact_mass_kg`、`headshot_extra_impulse_ratio`、
  `upper_body_keywords`

默认资源：`assets/config/player/force_config_default.tres`，
挂载于 `PlayerConfig.force_config`。

## 与布娃娃的衔接

`PlayerRagdollSystem.set_force_provider(receiver)` 接入后，`_apply_impact_impulse()`
在 `impact_energy_j > 0` 时优先使用 `consume_pending_impulse()` 的方向与总冲量，
其余逻辑（按骨骼质量分配、爆头额外冲量）保持不变。

未接入提供者或无待用冲量时**完全回退**到原有 energy→impulse 路径，因此控制台
`die()` 与失血死亡行为不变。

## 注意事项

- 本期**不接摄像机**；塔科夫式头部弹簧摄像机是独立的后续步骤，
  `camera_force_weight` 相应延后。
- 武器后坐力集成延后到下个里程碑；现有接口（尤其位移限幅）已按后坐力需求预留。
- `revive()` 与 `prepare_for_encounter_spawn()` 都会清空力与待用冲量。

## 测试

```
godot --headless --path . --script res://tests/force_system_runner.gd
godot --headless --path . --script res://tests/force_integration_runner.gd
```

`force_system_runner.gd` 为单位/回归用例（衰减曲线、传播权重与深度截断、
姿态上限与 overload、跨帧漂移守卫、非有限输入稳健性、冲量推导、一次性消费、
`Local` 空间换算、生效力上限、修饰器姿态还原与真实骨骼姿态漂移守卫、
布娃娃提供者契约）。

`force_integration_runner.gd` 加载真实 `assets/map/test_map.tscn` 玩家场景，
验证修饰器插槽顺序（SpineAim → Force → IK）、受击后真实骨骼姿态变化、
冲量缓存与复活清理。

两个运行器都打印 JSON 并以退出码返回结果。注意 `--script` 模式下 autoload
标识符在 `_init()` 编译期不可解析，因此测试体必须在延迟调用中执行。
