# 医疗与解剖系统（Medical & Anatomy System）

**核心文件：**

| 文件 | 类名 | 说明 |
|------|------|------|
| `classes/player/medical/health_system.gd` | `HealthSystem` | 伤害入口、生理 tick、器官/骨骼/血管损伤与死亡判定 |
| `classes/player/medical/anatomy_structure.gd` | `AnatomyStructure` | 单个器官、骨骼或大血管的几何与损伤参数 |
| `classes/player/medical/anatomy_config.gd` | `AnatomyConfig` | 解剖结构集合与伤道参数；提供 27 结构的默认人体模板 |
| `classes/player/medical/anatomy_solver.gd` | `AnatomySolver` | 伤道—内部结构相交求解器及无伤道盲判回退 |
| `classes/player/medical/vitals_model.gd` | `VitalsModel` | 血量、呼吸效率与 10 个身体部位的数据容器 |
| `classes/player/medical/body_region.gd` | `BodyRegion` | 单个部位的伤口、器官累计损伤和骨折记录 |
| `classes/player/medical/wound.gd` | `Wound` | 单条伤口的外部/内部出血与处置状态 |
| `classes/player/medical/health_config.gd` | `HealthConfig` | 碰撞体、解剖、软组织出血、生理与致死参数 |
| `classes/player/medical/medical_enums.gd` | `MedicalEnums` | 医疗系统全部枚举 |
| `classes/player/medical/damage_info.gd` | `DamageInfo` | 单次伤害及可选局部伤道信息 |
| `classes/combat/hit_resolver.gd` | `HitResolver` | 将物理查询结果转换为 `DamageInfo` |
| `classes/combat/body_hitbox.gd` | `BodyHitbox` | 存活角色的部位碰撞体与解剖调试几何 |
| `classes/debug/free_camera_controller.gd` | `FreeCameraController` | 自由视角射击测试；统一通过 `HitResolver` 生成伤害 |
| `classes/ui/medical_debug_hud.gd` | — | 显示外/内出血、呼吸、器官损伤和骨折 |

---

## 功能概述

医疗系统不使用传统 HP 条。命中首先形成伤口，再由伤道决定是否伤及器官、骨骼或大血管。外部出血和内部出血持续消耗血量；心脏或脑被摧毁、头/躯干伤情超过阈值，或血量低于致死阈值均会触发死亡并进入布娃娃系统。

P2 已实现：

- 以胶囊体近似的内部解剖结构。
- 由入射点、方向和动能构造的局部伤道。
- 直接贯穿、临时空腔波及与无伤道盲判。
- 器官累计损伤、关键器官致死、肺部呼吸惩罚。
- 骨折记录和大血管专属动脉出血。
- 内部出血参与生理 tick、HUD 和预计死亡时间。
- `H` 键调试显示部位 hitbox 与内部结构。

治疗、昏迷、氧合、完整呼吸生理、骨折对移动的影响仍属于后续阶段；当前数据和接口只为这些阶段预留。

---

## 伤害数据流

```text
物理射线命中 Dictionary
  └─ HitResolver.resolve(result, energy, type, source, travel_dir)
       ├─ BodyHitbox → body_part
       ├─ PhysicalBone3D → 骨骼名映射 body_part
       └─ BodyHitbox + BoneAttachment3D
            → anchor_bone + local_entry + local_direction
                 └─ DamageInfo
                      └─ HealthSystem.apply_damage(info)
                           ├─ severity = energy / ke_per_severity_unit
                           ├─ 创建 Wound + 软组织出血
                           ├─ 有伤道 → AnatomySolver.solve_channel()
                           │    └─ 只检查同一 anchor_bone 的结构
                           └─ 无伤道 → AnatomySolver.solve_blind()
                                └─ 检查同一 body_part 的结构
                                     ├─ ORGAN → 累计损伤、内出血、呼吸惩罚
                                     ├─ BONE → 骨折、伤口疼痛 +0.3
                                     └─ MAJOR_VESSEL → 外部或内部出血升级
```

`HealthSystem._physics_process()` 按 `tick_interval` 执行：

```text
外部出血总量 + 内部出血总量
  └─ blood_volume_ml -= total_rate × dt
       ├─ blood_changed(pct)
       └─ _evaluate_state()
```

---

## DamageInfo 与 HitResolver

### DamageInfo

**文件路径：** `classes/player/medical/damage_info.gd`

**继承自：** `RefCounted`

| 字段 | 类型 | 说明 |
|------|------|------|
| `amount` | `float` | 命中动能，单位 J |
| `type` | `DamageType` | 子弹、爆炸、破片、近战、坠落或火焰 |
| `body_part` | `BodyPartId` | 受伤部位 |
| `direction` | `Vector3` | 世界空间受击方向，用于死亡表现 |
| `hit_position` | `Vector3` | 世界空间命中点 |
| `source` | `Node` | 伤害来源 |
| `is_penetrating` | `bool` | 是否为穿透伤；当前不直接参与 P2 求解 |
| `impact_velocity` | `float` | 撞击速度；当前预留 |
| `anchor_bone` | `String` | 伤道所属的骨骼/hitbox 名称 |
| `local_entry` | `Vector3` | 命中点在 hitbox 局部空间中的位置 |
| `local_direction` | `Vector3` | 弹道在 hitbox 局部空间中的方向 |

`has_wound_channel()` 仅在 `anchor_bone` 非空且 `local_direction != Vector3.ZERO` 时返回 `true`。`local_entry` 可以是零向量，因为命中点可能正好位于局部原点。

### HitResolver

**文件路径：** `classes/combat/hit_resolver.gd`

**类型：** 无状态静态工具类

```gdscript
HitResolver.resolve(
    ray_result: Dictionary,
    damage_amount: float,
    damage_type: MedicalEnums.DamageType,
    source: Node = null,
    travel_dir: Vector3 = Vector3.ZERO
) -> DamageInfo
```

- 优先使用调用者传入的 `travel_dir`；未提供时使用 `-result.normal`。
- 命中 `BodyHitbox` 时直接读取 `get_body_part_id()`。
- 命中尸体的 `PhysicalBone3D` 时通过 `BONE_PART_MAP` 映射身体部位。
- 只有 `BodyHitbox` 会生成局部伤道；其父 `BoneAttachment3D` 的 `bone_name` 成为 `anchor_bone`。
- 物理骨骼命中仍可造成部位伤害，但没有局部伤道，因此使用盲判回退。

---

## AnatomyStructure

**文件路径：** `classes/player/medical/anatomy_structure.gd`

**继承自：** `Resource`

单个内部结构使用“局部空间线段 + 半径”近似为胶囊体。起点和终点相同时退化为球体。

### 标识与几何

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `structure_id` | `&""` | 唯一 ID；用作器官损伤和骨折字典键 |
| `display_name` | `""` | 调试显示名称 |
| `type` | `ORGAN` | `ORGAN` / `BONE` / `MAJOR_VESSEL` |
| `body_part` | `TORSO` | 伤情归属的 `BodyRegion` |
| `anchor_bone` | `""` | 几何所在的 hitbox/骨骼局部空间 |
| `start_point` / `end_point` | `Vector3.ZERO` | 胶囊中轴线端点，单位 m |
| `radius` | `0.03` | 胶囊半径，单位 m |

### 损伤门槛

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `min_damage_energy` | `50.0` | 低于该动能时结构不受损 |
| `direct_hit_probability` | `1.0` | 伤道直接贯穿后的命中概率 |
| `cavity_hit_probability` | `0.35` | 临时空腔波及的基础概率，另乘距离衰减 |
| `blind_hit_probability` | `0.1` | 无伤道信息时的独立盲判概率 |

### 血管与器官参数

| 字段 | 适用类型 | 说明 |
|------|----------|------|
| `severed_bleed` | `MAJOR_VESSEL` | 血管破裂后的出血等级 |
| `bleed_is_internal` | `MAJOR_VESSEL` | 出血记入内部还是外部 |
| `destroy_damage_threshold` | `ORGAN` | 累计损伤达到该值进入 `DESTROYED` |
| `lethal_when_destroyed` | `ORGAN` | 摧毁后是否直接致死 |
| `internal_bleed_damaged` | `ORGAN` | `DAMAGED` 状态的内出血等级 |
| `internal_bleed_destroyed` | `ORGAN` | `DESTROYED` 状态的内出血等级 |
| `breathing_penalty` | `ORGAN` | 每次有效损伤从呼吸效率扣除的比例 |

---

## AnatomyConfig

**文件路径：** `classes/player/medical/anatomy_config.gd`

**继承自：** `Resource`

### 伤道参数

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `structures` | `[]` | 全部内部结构 |
| `penetration_m_per_kj` | `0.6` | 每 kJ 动能对应的伤道长度 |
| `min_channel_length` | `0.05` | 最短伤道，单位 m |
| `max_channel_length` | `1.5` | 最长伤道，单位 m |
| `channel_radius` | `0.006` | 永久伤道半径，单位 m |
| `cavity_radius_per_kj` | `0.03` | 每 kJ 对应的临时空腔半径 |

伤道长度公式：

```text
channel_length = clamp(
    penetration_m_per_kj × energy_joules / 1000,
    min_channel_length,
    max_channel_length
)
```

### 查询方法

| 方法 | 说明 |
|------|------|
| `get_structures_for_bone(bone_name)` | 按完全一致的 `anchor_bone` 查询；首次查询时构建缓存 |
| `get_structures_for_part(part)` | 按身体部位线性查询 |
| `create_default()` | 创建内置 27 结构人体模板 |

### 内置人体模板

| 部位 | 结构 |
|------|------|
| 头部（2） | 脑、颅骨 |
| 胸部（5） | 心脏、左肺、右肺、胸主动脉、胸椎 |
| 腹部（4） | 肝脏、肠、腹主动脉、腰椎 |
| 左右大腿（4） | 左/右股动脉、左/右股骨 |
| 左右小腿（4） | 左/右胫后动脉、左/右胫骨 |
| 左右上臂（4） | 左/右肱动脉、左/右肱骨 |
| 左右前臂（4） | 左/右桡动脉、左/右尺桡骨 |

左右肢体由 `_append_limb_pair()` 生成：右侧 X 坐标镜像，ID 自动追加 `_l` / `_r`。

> **校准要求：** 默认坐标基于 `HitboxConfig` 默认尺寸估算，不是从模型网格或骨骼自动生成。更换模型或 hitbox 尺寸后，应按 `H` 打开可视化，在 Godot 中校准每个结构的局部位置和半径。

---

## AnatomySolver

**文件路径：** `classes/player/medical/anatomy_solver.gd`

**继承自：** `RefCounted`（全部方法为静态方法）

### `StructureHit`

| 字段 | 说明 |
|------|------|
| `structure` | 被伤及的 `AnatomyStructure` |
| `direct` | `true` 为直接贯穿；`false` 为临时空腔或盲判 |
| `damage_factor` | 直接命中为 `1.0`；空腔为 `0.2–0.6`；盲判为 `0.5` |

### 求解流程

`solve_channel(entry_local, dir_local, energy, candidates, config, rng)`：

1. 根据动能计算伤道长度和临时空腔半径。
2. 计算伤道线段与结构中轴线段的最近距离。
3. 距离不超过 `structure.radius + channel_radius` 时进行直接命中概率判定。
4. 距离位于永久伤道外、临时空腔内时，按距离衰减判定空腔损伤。
5. 动能低于结构的 `min_damage_energy` 时跳过。

`solve_blind(energy, candidates, rng)` 用于缺少有效局部伤道的命中。它对部位内每个结构独立检查动能门槛和 `blind_hit_probability`，成功后返回 `damage_factor = 0.5`。

---

## HealthSystem

**文件路径：** `classes/player/medical/health_system.gd`

**继承自：** `Node`

**由谁创建：** `BasePlayer._initialize_subsystems()`

### 信号

| 信号 | 参数 | 触发时机 |
|------|------|----------|
| `damage_taken` | `info: DamageInfo` | 每次接受有效伤害后 |
| `wound_added` | `wound: Wound` | 新伤口加入部位后 |
| `bleeding_changed` | `total_rate_ml_per_sec: float` | 新伤口处理完成后；当前参数仅为外部出血总量 |
| `blood_changed` | `pct: float` | 生理 tick 扣血或调试设置血量后 |
| `state_changed` | `new_state: HealthState` | 整体生理状态变化时 |
| `went_unconscious` | — | 首次进入 `UNCONSCIOUS`；当前阶段未主动进入 |
| `medically_died` | `death_type, direction` | 医疗死亡触发时 |
| `organ_damaged` | `part, structure_id, new_state` | 每次器官受到有效损伤后 |
| `bone_fractured` | `part, structure_id` | 某骨骼首次骨折时 |

### 公开方法

| 方法 | 返回 | 说明 |
|------|------|------|
| `initialize(player, config)` | `void` | 初始化 vitals、解剖模板、随机数及玩家信号 |
| `apply_damage(info)` | `void` | 唯一正式伤害入口 |
| `apply_treatment(type, part)` | `bool` | 后续阶段接口，当前返回 `false` |
| `get_blood_pct()` | `float` | 当前血量百分比 |
| `get_part_health(part)` | `float` | 按伤口累计严重度估算部位健康度 |
| `get_state()` | `HealthState` | 当前整体状态 |
| `set_hitboxes_visible(visible)` | `void` | 同时切换部位碰撞体和内部结构可视化 |
| `get_hitbox_rids()` | `Array[RID]` | 返回全部部位 `Area3D` RID，供射线排除 |
| `get_collision_envelope()` | `AABB` | 合并当前全部 BodyHitbox，返回玩家局部空间的纯数据 3D 包络；不暴露 hitbox 节点 |
| `get_movement_speed_multiplier()` | `float` | 后续阶段接口，当前 `1.0` |
| `get_aim_stability_multiplier()` | `float` | 后续阶段接口，当前 `1.0` |
| `can_sprint()` | `bool` | 后续阶段接口，当前 `true` |

### 结构损伤

- **软组织：** severity 达 `capillary_severity_threshold` 产生毛细出血，达 `venous_severity_threshold` 产生静脉出血。软组织不会自行产生动脉出血。
- **大血管：** 将当前伤口对应的外部或内部出血等级升级至 `severed_bleed`，不会降低已有等级。
- **器官：** `severity × damage_factor` 累加到 `BodyRegion.organ_damage`。大于 0 为 `DAMAGED`，达到结构阈值为 `DESTROYED`；相应内部出血等级写入当前伤口。
- **肺部：** 每次有效损伤执行 `breathing_effectiveness -= breathing_penalty × damage_factor`，结果限制在 `0–1`。
- **骨骼：** 同一结构只记录一次骨折；首次骨折令当前伤口 `pain_contribution += 0.3`。
- **关键器官：** `lethal_when_destroyed = true` 的器官被摧毁后设置致死标志；默认模板中为心脏和脑。

### 死亡判定优先级

1. 关键器官被摧毁。
2. 头部或躯干存在超过单发致死阈值的伤口。
3. 头部或躯干累计 severity 超过累计致死阈值。
4. 血量低于 `fatal_blood_threshold_pct`。
5. 血量低于 `critical_blood_threshold_pct` → `CRITICAL`。
6. 任意部位有伤口 → `INJURED`；否则 `HEALTHY`。

复活会重新初始化 `VitalsModel`、清除关键器官致死标志并重建 hitbox。`debug_clear_wounds()` 还会清空器官损伤、骨折、所有伤口并将呼吸效率恢复为 `1.0`。

---

## BodyRegion、VitalsModel 与 Wound

### BodyRegion

**文件路径：** `classes/player/medical/body_region.gd`

**继承自：** `RefCounted`

| 字段 | 说明 |
|------|------|
| `part_id` | 当前身体部位 |
| `wounds` | 该部位的 `Wound` 列表 |
| `organ_damage` | `structure_id → 累计 float 损伤` |
| `fractured_bones` | 已骨折结构 ID；不重复添加 |

`total_bleed_ml_per_sec()` 与 `total_internal_bleed_ml_per_sec()` 分别聚合该部位所有伤口的外部和内部出血。

### VitalsModel

**文件路径：** `classes/player/medical/vitals_model.gd`

**继承自：** `RefCounted`

初始化时创建 10 个 `BodyRegion`，重置血量和 `breathing_effectiveness = 1.0`。`total_bleed_rate()` 聚合全身外部出血；`total_internal_bleed_rate()` 聚合全身内部出血。两者共同参与生理 tick。

`oxygenation`、`consciousness_level`、`perfusion`、`stress_level` 和 `adrenaline_level` 由 P3 生理 tick 持续更新；意识恢复必须满足灌注与氧合阈值并调用显式恢复接口。

### Wound

**文件路径：** `classes/player/medical/wound.gd`

**继承自：** `RefCounted`

| 出血等级 | 速率 |
|----------|------|
| `NONE` | `0.0 ml/s` |
| `CAPILLARY` | `0.5 ml/s` |
| `VENOUS` | `3.0 ml/s` |
| `ARTERIAL` | `15.0 ml/s` |

`get_bleed_ml_per_sec()` 在伤口已包扎或已上止血带时返回 0；`get_internal_bleed_ml_per_sec()` 在伤口已填塞时返回 0。P2 仅计算这些状态，正式治疗入口仍未实现。

---

## HealthConfig

**文件路径：** `classes/player/medical/health_config.gd`

**资源文件：** `assets/config/player/health_config_default.tres`

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `hitbox_config` | `null` | 部位碰撞体配置；空时使用代码默认值 |
| `anatomy_config` | `null` | 解剖配置；空时使用 `AnatomyConfig.create_default()` |
| `venous_severity_threshold` | `0.4` | 软组织静脉出血阈值 |
| `capillary_severity_threshold` | `0.1` | 软组织毛细出血阈值 |
| `blood_volume_ml` | `5000.0` | 初始/最大血量 |
| `critical_blood_threshold_pct` | `0.6` | 进入 `CRITICAL` 的血量比例 |
| `fatal_blood_threshold_pct` | `0.3` | 失血死亡阈值 |
| `head_lethal_severity` | `0.7` | 头部单发致死阈值 |
| `torso_lethal_severity` | `0.85` | 躯干单发致死阈值 |
| `head_cumulative_lethal` | `1.2` | 头部累计致死阈值 |
| `torso_cumulative_lethal` | `2.5` | 躯干累计致死阈值 |
| `ke_per_severity_unit` | `1200.0` | `severity = KE / 此值` |
| `immediate_blood_loss_per_severity` | `150.0` | 每 severity 的即时失血量，单位 ml |
| `tick_interval` | `0.2` | 生理 tick 间隔，单位 s |

> **配置语义：** 只有 `anatomy_config == null` 才会启用内置模板。显式分配一个 `structures` 为空的 `AnatomyConfig` 会得到零结构配置，即完全不发生器官、骨折或大血管命中。

---

## MedicalEnums — 枚举速查

| 枚举 | 成员 |
|------|------|
| `BodyPartId` | `HEAD`、`TORSO`、左右上臂/前臂/大腿/小腿，共 10 部位 |
| `DamageType` | `BULLET`、`EXPLOSION`、`FRAGMENT`、`MELEE`、`FALL`、`FIRE` |
| `HealthState` | `HEALTHY`、`INJURED`、`CRITICAL`、`UNCONSCIOUS`、`DEAD` |
| `WoundType` | `PENETRATING`、`LACERATION`、`BLUNT_TRAUMA`、`FRACTURE`、`BURN`、`BLAST_TRAUMA` |
| `BleedRate` | `NONE`、`CAPILLARY`、`VENOUS`、`ARTERIAL` |
| `StructureType` | `ORGAN`、`BONE`、`MAJOR_VESSEL` |
| `OrganState` | `INTACT`、`DAMAGED`、`DESTROYED` |
| `TreatmentType` | `BANDAGE`、`TOURNIQUET`、`WOUND_PACKING`、`CHEST_SEAL`、`MORPHINE`、`EPINEPHRINE`、`BLOOD_BAG`、`SPLINT` |

---

## BodyHitbox 与调试可视化

**文件路径：** `classes/combat/body_hitbox.gd`

**继承自：** `Area3D`

`BodyHitbox` 保存所属 `BodyPartId`，并持有一个部位碰撞体调试网格和若干内部结构调试网格。`get_bounds(relative_to)` 仅供拥有它的 `HealthSystem` 计算 3D `AABB`；其他组件只能取得合并后的值，不能持有或修改 hitbox 节点。`add_anatomy_debug_mesh(start, end, radius, color)` 创建沿结构线段排列的半透明 `CapsuleMesh`；退化线段显示为最小高度胶囊。

`set_debug_visible()` 同时切换两类网格。`HealthSystem` 使用以下颜色：

| 类型 | 颜色 |
|------|------|
| 器官 | 半透明红色 |
| 骨骼 | 半透明白色 |
| 大血管 | 半透明深红色 |

可视化材质为无光照、关闭深度测试，因此会透过角色和环境显示，便于调参；它不参与物理碰撞。

---

## 自由视角测试与医疗 HUD

### FreeCameraController

**文件路径：** `classes/debug/free_camera_controller.gd`

自由视角 hitscan 现在统一调用 `HitResolver.resolve()`，并传入相机前向方向，因此真实瞄准的 `BodyHitbox` 命中会携带局部伤道。强制部位测试 `T/Y/U` 会清空 `anchor_bone`，刻意改走部位盲判；这是因为强制覆盖的部位可能与射线实际命中的 hitbox 不一致。

### Medical Debug HUD

**文件路径：** `classes/ui/medical_debug_hud.gd`

HUD 每 `0.1 s` 更新一次，新增：

- 外部与内部出血速率分行显示。
- 预计死亡时间使用两类出血的总和计算。
- 显示 `breathing_effectiveness`。
- 每个伤口标记内部出血等级。
- 按部位列出器官累计损伤和骨折 ID。

---

## PR #13 文件覆盖表

以下表格用于保证该功能分支的全部改动均有文档归属：

| 改动文件 | 文档章节 |
|----------|----------|
| `classes/player/medical/anatomy_structure.gd`（新增） | [AnatomyStructure](#anatomystructure) |
| `classes/player/medical/anatomy_config.gd`（新增） | [AnatomyConfig](#anatomyconfig) |
| `classes/player/medical/anatomy_solver.gd`（新增） | [AnatomySolver](#anatomysolver) |
| `classes/player/medical/anatomy_structure.gd.uid`（新增） | Godot 资源身份文件，无独立运行时 API |
| `classes/player/medical/anatomy_config.gd.uid`（新增） | Godot 资源身份文件，无独立运行时 API |
| `classes/player/medical/anatomy_solver.gd.uid`（新增） | Godot 资源身份文件，无独立运行时 API |
| `classes/player/medical/medical_enums.gd` | [MedicalEnums](#medicalenums--枚举速查) |
| `classes/player/medical/damage_info.gd` | [DamageInfo 与 HitResolver](#damageinfo-与-hitresolver) |
| `classes/player/medical/body_region.gd` | [BodyRegion、VitalsModel 与 Wound](#bodyregionvitalsmodel-与-wound) |
| `classes/player/medical/vitals_model.gd` | [BodyRegion、VitalsModel 与 Wound](#bodyregionvitalsmodel-与-wound) |
| `classes/player/medical/health_config.gd` | [HealthConfig](#healthconfig) |
| `classes/player/medical/health_system.gd` | [HealthSystem](#healthsystem) |
| `classes/combat/body_hitbox.gd` | [BodyHitbox 与调试可视化](#bodyhitbox-与调试可视化) |
| `classes/combat/hit_resolver.gd` | [DamageInfo 与 HitResolver](#damageinfo-与-hitresolver) |
| `classes/debug/free_camera_controller.gd` | [自由视角测试与医疗 HUD](#自由视角测试与医疗-hud) |
| `classes/ui/medical_debug_hud.gd` | [自由视角测试与医疗 HUD](#自由视角测试与医疗-hud) |

---

## 当前限制与注意事项

- 默认解剖几何是近似值，必须针对实际角色模型目视校准；它不代表网格蒙皮、骨骼权重或真实医学几何。
- 伤道只在存活角色的 `BodyHitbox` 命中上生成；尸体物理骨骼和强制部位测试使用概率盲判。
- `bleeding_changed` 当前只发送外部出血总量；需要显示总失血的监听者应同时读取 `VitalsModel.total_internal_bleed_rate()`。
- `organ_damaged` 在每次有效器官命中后发出，并非只在 `INTACT → DAMAGED` 或 `DAMAGED → DESTROYED` 状态切换时发出。
- 解剖骨骼查询缓存首次建立后不会自动失效。若运行时修改 `AnatomyConfig.structures`，应重新创建配置/系统，而不是依赖现有缓存。
- HUD 用固定 `1.0` 将器官损伤着色为“摧毁”，但各器官实际 `destroy_damage_threshold` 不同；HUD 颜色仅供调试，状态应以 `organ_damaged` 信号及结构配置为准。
- `apply_treatment()`、`UNCONSCIOUS`、氧合、疼痛对操控的影响，以及骨折夹板处理尚未实现，不应在 P2 文档中视为可用玩法。
