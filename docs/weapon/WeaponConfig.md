# WeaponConfig

**文件路径：** `classes/weapon/weapon_config.gd`

**继承自：** `Resource`

保存机匣基础、散布、后坐物理基准、表现与默认配件引用。下表为脚本默认值，武器 .tres 可覆盖；logic_enabled 默认为 false，纯预览资源不会自动成为可击发武器。

| 字段 | 类型 | 脚本默认值 |
|---|---|---|
| `weapon_name` | `String` | `"Unnamed Weapon"` |
| `weapon_type` | `String` | `"rifle"` |
| `logic_enabled` | `bool` | `false` |
| `action_type` | `String` | `"gas_operated"` |
| `open_bolt` | `bool` | `false` |
| `cycle_rate` | `float` | `600.0` |
| `fire_modes` | `Array[String]` | `["safe", "semi", "auto"]` |
| `burst_count` | `int` | `3` |
| `default_fire_mode` | `String` | `"semi"` |
| `recoil_vertical` | `float` | `2.0` |
| `recoil_horizontal` | `float` | `0.5` |
| `recoil_recovery_speed` | `float` | `5.0` |
| `kick_pitch_deg` | `float` | `0.8` |
| `kick_yaw_deg` | `float` | `0.12` |
| `kick_yaw_random_deg` | `float` | `0.35` |
| `hipfire_spread` | `float` | `3.0` |
| `ads_spread` | `float` | `0.1` |
| `weight` | `float` | `3.5` |
| `weight_affects_movement` | `bool` | `true` |
| `receiver_mass_kg` | `float` | `2.2` |
| `receiver_com_local` | `Vector3` | `Vector3.ZERO` |
| `bore_point_local` | `Vector3` | `Vector3(0, 0.06, -0.35)` |
| `bore_axis_height_m` | `float` | `0.06` |
| `shoulder_pivot_local` | `Vector3` | `Vector3(0, -0.04, 0.35)` |
| `recoil_control_stiffness` | `float` | `120.0` |
| `recoil_control_damping` | `float` | `18.0` |
| `shooter_impulse_noise` | `float` | `0.03` |
| `weapon_scene` | `PackedScene` | `null` |
| `fx_config` | `WeaponFXConfig` | `null` |
| `weapon_length` | `float` | `0.75` |
| `ads_time` | `float` | `0.25` |
| `ads_center_offset` | `Vector3` | `Vector3(0.0, -0.1, -0.05)` |
| `ads_fov_override` | `float` | `-1.0` |
| `presentation_config` | `WeaponPresentationConfig` | `null` |
| `dropped_collision_shape` | `Shape3D` | `null` |
| `dropped_collision_offset` | `Vector3` | `Vector3.ZERO` |
| `grip_alignment_offset` | `Vector3` | `Vector3.ZERO` |
| `left_hand_ik_weight` | `float` | `1.0` |
| `supported_slots` | `Array[AttachmentSlot.SlotType]` | `[]` |
| `default_attachment_slots` | `Array[String]` | `[]` |
| `default_attachment_configs` | `Array[AttachmentConfig]` | `[]` |
| `origin_country` | `String` | `"Russia"` |
| `era` | `String` | `"Modern"` |
| `use_ballistic_simulation` | `bool` | `true` |


## 参数所有权

- BarrelConfig：口径、初速、弹头/装药质量、弹道系数、膛线及哑火等。
- BoltCarrierConfig：枪机框质量、复进簧、行程和部分故障概率。
- MagazineConfig：容量、备用弹匣、空仓挂机、整段/分段换弹时间。
- WeaponConfig.weight 加附件重量供 get_total_weight()/体力使用；力学模型按 receiver_mass_kg 加附件质量计算，二者不是同一个字段。

hipfire_spread / ads_spread 及配件散布修正为兼容数据，不参与当前发射路径。弹道随机性由 BarrelConfig 控制，ADS 只改变持枪/观察姿态，不修改精度。弹丸从实际枪口位置与轴向发射；use_ballistic_simulation 只切换仿真方式。

grip_alignment_offset 是挂载对齐数据，left_hand_ik_weight 是单武器基础手 IK 权重；腕骨目标由武器/配件 Marker 决定。presentation_config 提供 WeaponPresentationConfig；没有 ADS 锚点时，WeaponPresentationController 使用完整 ads_center_offset 作为回退偏移。AimConfig 的抬枪/收枪倍率由玩家配置提供。

supported_slots 是旧兼容字段；运行时可用槽位扫描实际 AttachmentSlot。默认配件按数组顺序装配，父件先于其子槽附件。

recoil_vertical / recoil_horizontal / recoil_recovery_speed / kick_* 为旧资源兼容值，不参与当前物理后坐。Resource 在 Godot 中可能共享；需要独立修改时应明确 duplicate()，不能假定每个武器天然拥有独立 .tres 实例。
