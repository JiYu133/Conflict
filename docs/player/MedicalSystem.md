# 医疗系统（Medical System）

**核心文件：**

| 文件 | 类名 | 说明 |
|------|------|------|
| `Classes/Player/Medical/health_system.gd` | `HealthSystem` | 主控子系统，伤害处理、生理 tick、状态机、hitbox 管理 |
| `Classes/Player/Medical/vitals_model.gd` | `VitalsModel` | 纯数据模型（无信号），存储血量与各部位状态 |
| `Classes/Player/Medical/body_region.gd` | `BodyRegion` | 单个身体部位的伤口列表与聚合查询 |
| `Classes/Player/Medical/wound.gd` | `Wound` | 单条伤口的持久状态（出血等级、处置标志等） |
| `Classes/Player/Medical/health_config.gd` | `HealthConfig` | 全部可调参数（Resource），可在编辑器 Inspector 面板修改 |
| `Classes/Player/Medical/medical_enums.gd` | `MedicalEnums` | 所有枚举定义，集中放置以避免循环依赖 |
| `Classes/Combat/hit_resolver.gd` | `HitResolver` | 静态工具：将射线命中结果转化为 `DamageInfo` |
| `Classes/Combat/ballistics.gd` | `Ballistics` | 静态工具：动能公式、弹道速度衰减 |
| `Classes/Combat/damage_info.gd` | `DamageInfo` | 不可变值对象，携带单次伤害事件的全部信息 |
| `Classes/Combat/body_hitbox.gd` | `BodyHitbox` | 存活状态下骨骼上的 Area3D 碰撞体 |

---

## 设计原则

- **无 HP 条**：伤情由各部位伤口的 `severity` 累积决定，没有传统 HP 数值。
- **伤害来自物理**：弹药威力通过 `KE = ½mv²` 计算，不依赖手工填写的"伤害值"，不同口径自然产生不同效果。
- **分阶段实现**：P1 为循环系统（出血→死亡），P2 起逐步加入内部出血、治疗、呼吸、神经等系统，数据模型已预留存根。

---

## 数据流

```
武器开火
  └─► Ballistics.kinetic_energy(mass, velocity)  → 动能（焦耳）
        └─► HitResolver.resolve(ray_result, joules, type, source)
                  ├─ 存活：BodyHitbox.get_body_part_id()
                  └─ 死亡后：PhysicalBone3D 骨骼名 → BONE_PART_MAP
              └─► DamageInfo（部位、能量、方向、来源…）
                    └─► HealthSystem.apply_damage(info)
                              ├─ _apply_structural_damage()
                              │     ├─ severity = KE / ke_per_severity_unit
                              │     ├─ _build_wound()  → Wound
                              │     ├─ _classify_bleed()  → BleedRate
                              │     └─ 立即失血（液压冲击近似）
                              └─ _evaluate_state()
                                    ├─ 单发致命伤 / 累积致命 → DEAD
                                    ├─ 血量 < fatal_threshold → DEAD
                                    ├─ 血量 < critical_threshold → CRITICAL
                                    └─ 有伤口 → INJURED

HealthSystem._physics_process()（每 tick_interval 秒）
  └─► VitalsModel.total_bleed_rate() → blood_volume_ml -= bleed × dt
        └─► blood_changed 信号（驱动 HUD / 死亡判定）
```

---

## HealthSystem

**文件路径：** `Classes/Player/Medical/health_system.gd`  
**继承自：** `Node`  
**由谁创建：** `BasePlayer._initialize_subsystems()`

### 信号

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `damage_taken` | `info: DamageInfo` | 每次调用 `apply_damage()` 后 |
| `wound_added` | `wound: Wound` | 新伤口加入 BodyRegion 后 |
| `bleeding_changed` | `total_rate_ml_per_sec: float` | 出血状态变化时 |
| `blood_changed` | `pct: float` | 每次生理 tick 扣血后 |
| `state_changed` | `new_state: HealthState` | 状态机发生跳转时 |
| `went_unconscious` | 无 | 首次进入 UNCONSCIOUS（P3） |
| `medically_died` | `death_type, direction` | 医疗判定死亡，调用前 |

### 公开方法

| 方法 | 返回 | 说明 |
|------|------|------|
| `initialize(player, config)` | `void` | 创建 VitalsModel，监听 model_loaded |
| `apply_damage(info: DamageInfo)` | `void` | **唯一伤害入口**，所有伤害必须经此进入 |
| `apply_treatment(type, part)` | `bool` | P3 存根，当前返回 false |
| `get_blood_pct()` | `float` | 0.0–1.0 血量百分比 |
| `get_part_health(part)` | `float` | 0.0–1.0 部位健康度（基于累积 severity） |
| `get_state()` | `HealthState` | 当前生理状态 |
| `set_hitboxes_visible(visible)` | `void` | 调试：切换碰撞体可视化 |
| `get_movement_speed_multiplier()` | `float` | P4 存根，当前返回 1.0 |
| `get_aim_stability_multiplier()` | `float` | P4 存根，当前返回 1.0 |
| `can_sprint()` | `bool` | P4 存根，当前返回 true |

### 死亡判定逻辑（`_compute_state`）

按优先级顺序：

1. 头部单发 severity ≥ `head_lethal_severity` → **DEAD**
2. 躯干单发 severity ≥ `torso_lethal_severity` → **DEAD**
3. 头部累积 severity ≥ `head_cumulative_lethal` → **DEAD**
4. 躯干累积 severity ≥ `torso_cumulative_lethal` → **DEAD**
5. 血量 ≤ `fatal_blood_threshold_pct` → **DEAD**
6. 血量 ≤ `critical_blood_threshold_pct` → **CRITICAL**
7. 任意部位有伤口 → **INJURED**
8. 否则 → **HEALTHY**

### 死亡动画桥（`_resolve_death_type`）

将致命原因 + 最后命中方向映射为 `PlayerRagdollSystem.DeathType`：

- 头部致命 + 蹲姿 → `CROUCHING_HEADSHOT`
- 头部致命 + 正面 → `FRONT_HEADSHOT`；背面 → `BACK_HEADSHOT`
- 存在 BLAST_TRAUMA 伤口 → `EXPLOSION`
- 正面命中 → `FRONT`；背面 → `BACK`；方向未知 → `GENERIC`

---

## HealthConfig

**文件路径：** `Classes/Player/Medical/health_config.gd`  
**资源文件：** `res/config/player/health_config_default.tres`

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `blood_volume_ml` | 5000.0 | 最大血量（ml） |
| `critical_blood_threshold_pct` | 0.6 | 血量低于此比例进入 CRITICAL |
| `fatal_blood_threshold_pct` | 0.3 | 血量低于此比例判定死亡 |
| `head_lethal_severity` | 0.7 | 头部单发即死阈值 |
| `torso_lethal_severity` | 0.85 | 躯干单发即死阈值 |
| `head_cumulative_lethal` | 1.2 | 头部累积致死阈值 |
| `torso_cumulative_lethal` | 2.5 | 躯干累积致死阈值 |
| `ke_per_severity_unit` | 600.0 | 每 1.0 severity 对应的动能（J） |
| `immediate_blood_loss_per_severity` | 150.0 | 每点 severity 造成的即时失血（ml） |
| `tick_interval` | 0.2 | 生理 tick 间隔（秒），即 5 Hz |
| `hitbox_config` | null | HitboxConfig 资源引用 |

> **注意：** `health_config_default.tres` 中 `ke_per_severity_unit = 1200.0`（比代码默认值严格 2 倍），使得造成 1.0 severity 需要 1200J，实际游戏中子弹威力更难致命。

---

## VitalsModel

**文件路径：** `Classes/Player/Medical/vitals_model.gd`  
**继承自：** `RefCounted`（纯数据，无信号）

### 关键字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `blood_volume_ml` | `float` | 当前血量（ml） |
| `max_blood_volume_ml` | `float` | 最大血量，初始化后固定 |
| `regions` | `Dictionary` | `int(BodyPartId)` → `BodyRegion`，共 10 个部位 |
| `breathing_effectiveness` | `float` | 呼吸效率（P3 存根，默认 1.0） |
| `oxygenation` | `float` | 氧合水平（P4 存根，默认 1.0） |
| `consciousness_level` | `float` | 意识等级（P4 存根，默认 1.0） |
| `pain_level` | `float` | 疼痛等级（P4 存根，默认 0.0） |

### 关键方法

| 方法 | 返回 | 说明 |
|------|------|------|
| `initialize(config)` | `void` | 构建 10 个 BodyRegion，设定血量 |
| `allocate_wound_id()` | `int` | 单调递增，分配全局唯一伤口 ID |
| `get_region(part)` | `BodyRegion?` | 按部位取 BodyRegion，找不到返回 null |
| `get_blood_pct()` | `float` | blood_volume_ml / max_blood_volume_ml |
| `total_bleed_rate()` | `float` | 全身外部出血速率之和（ml/s） |
| `total_internal_bleed_rate()` | `float` | 全身内部出血速率（P2 存根，当前恒为 0） |

---

## Wound

**文件路径：** `Classes/Player/Medical/wound.gd`  
**继承自：** `RefCounted`

| 字段 | 类型 | 说明 |
|------|------|------|
| `wound_id` | `int` | 唯一 ID，由 VitalsModel 分配 |
| `body_part` | `BodyPartId` | 所在部位 |
| `type` | `WoundType` | 伤口类型 |
| `severity` | `float` | 严重度（0.0–∞），由动能除以 ke_per_severity_unit 得到 |
| `bleed_rate` | `BleedRate` | 外部出血等级 |
| `internal_bleed_rate` | `BleedRate` | 内部出血等级（P2，默认 NONE） |
| `is_bandaged` | `bool` | 是否已包扎（外部出血清零） |
| `is_tourniqueted` | `bool` | 是否已上止血带（外部出血清零） |
| `is_packed` | `bool` | 是否已填塞（内部出血清零） |
| `pain_contribution` | `float` | 疼痛贡献值（P4 神经系统） |

**出血速率常量（`BLEED_RATE_ML_PER_SEC`）：**

| 等级 | ml/s |
|------|------|
| NONE | 0.0 |
| CAPILLARY | 0.5 |
| VENOUS | 3.0 |
| ARTERIAL | 15.0 |

---

## MedicalEnums — 枚举速查

### BodyPartId

`HEAD` / `TORSO` / `LEFT_UPPER_ARM` / `LEFT_FOREARM` / `RIGHT_UPPER_ARM` / `RIGHT_FOREARM` / `LEFT_THIGH` / `LEFT_CALF` / `RIGHT_THIGH` / `RIGHT_CALF`

### DamageType

`BULLET` / `EXPLOSION` / `FRAGMENT` / `MELEE` / `FALL` / `FIRE`

### HealthState

`HEALTHY` → `INJURED` → `CRITICAL` → `UNCONSCIOUS`(P3) → `DEAD`

### WoundType

`PENETRATING` / `LACERATION` / `BLUNT_TRAUMA` / `FRACTURE`(P4) / `BURN`(P4) / `BLAST_TRAUMA`

### BleedRate

`NONE` / `CAPILLARY` / `VENOUS` / `ARTERIAL`

### TreatmentType

`BANDAGE` / `TOURNIQUET` / `WOUND_PACKING` / `CHEST_SEAL`(P3) / `MORPHINE`(P4) / `EPINEPHRINE`(P4) / `BLOOD_BAG`(P4) / `SPLINT`(P4)

---

## 实现阶段（Phase）

| 阶段 | 状态 | 内容 |
|------|------|------|
| P1 | ✅ 已实现 | 伤害管线、10 部位 hitbox、外部出血 tick、死亡桥 |
| P2 | 🔲 存根 | 内部出血（`Wound.internal_bleed_rate`）、弹道速度衰减 |
| P3 | 🔲 存根 | 治疗系统（`apply_treatment`）、UNCONSCIOUS 状态连接、呼吸系统 |
| P4 | 🔲 存根 | 疼痛/神经系统、移动/瞄准乘数、骨折/烧伤 |

---

## 依赖关系

```
BasePlayer
  └─ HealthSystem (Node)
       ├─ 读写 → VitalsModel
       │           └─ 包含 BodyRegion[]
       │                   └─ 包含 Wound[]
       ├─ 读取 → HealthConfig
       ├─ 创建 → BodyHitbox[] (Area3D on Skeleton)
       └─ 死亡时调用 → BasePlayer.die()
                         └─ PlayerRagdollSystem.enable()

Projectile → Ballistics → HitResolver → DamageInfo → HealthSystem
```
