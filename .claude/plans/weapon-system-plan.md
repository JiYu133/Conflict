# 武器系统实现计划

## 现状分析

### 已实现（可用）
- `BaseWeapon` — 完整自动循环状态机（delay→moving_back→moving_forward）、击发、换弹、故障/排障
- `WeaponConfig` — 所有参数字段（含弹道学、故障概率、后座 kick 字段）
- `BoltComponent` — 枪机状态、故障枚举、hold-open
- `AmmoComponent` — 弹匣管理、托弹、进膛
- `FireControlComponent` — safe/semi/auto 扳机逻辑
- `GasComponent` — 导气延时公式
- `RecoilComponent` v2 — 每发 pitch/yaw kick 冲量（PlayerCameraController 消费）
- `EjectionComponent` — 抛壳位置/速度/卡壳概率
- `MalfunctionComponent` — 哑火/烟囱/双上膛排障流程
- `WeaponAnimationController` — 信号驱动动画（has_animation 守卫）
- `AttachmentManager` — 槽位扫描、装卸、数值汇总
- `AttachmentSlot` — 槽位占用检查
- `BaseAttachment` + 所有具体配件类 — 数值修正接口
- `AttachmentFactory` — 按类型创建实例（含 placeholder 几何体）
- `WeaponManager` — 装备/切换武器、ADS 状态路由

---

## 未实现 / 存在缺口的部分

### 1. 配件系统与武器数值的集成断层
**问题：**
- `WeaponConfig` 有 `supports_optic/muzzle/underbarrel/extended_mag` 字段，但 `initialize()` 中 `apply_magazine_attachments()` 调用注释说"当前 bonus 恒为 0"——扩容弹匣装/卸后不会重新结算容量
- `get_current_spread()` 调用了 `attachment_manager.get_total_spread_modifier()`，但 `_spawn_projectile()` 中的散布抖动尚未读取此值（Projectile/BallisticProjectile 模块不在此文件）
- ADS FOV 目前由 `WeaponManager._apply_ads_state()` 读 `config.ads_fov_override`，但 **配件（OpticAttachment）的 `fov_override` 没有被传入**；`AttachmentManager.get_fov_override()` 存在但没被 WeaponManager 使用

**修复：**
a) `AttachmentManager` 的 `attachments_changed` 信号连接到 `BaseWeapon._on_attachments_changed()`，重新结算弹匣容量（调用 `ammo_component.apply_magazine_attachments()`）
b) `WeaponManager._apply_ads_state()` 优先读配件 FOV，回退到 `config.ads_fov_override`
c) `BaseWeapon` 暴露 `get_effective_fov_override()` 和 `get_effective_ads_time()` 方便外部读取（含配件修正）

---

### 2. 可视化改装系统接口（核心新增）
**目标：** 为 UI 层预留足够的接口，让改装 UI 无需直接操作底层节点。

**新增 `WeaponManager` 接口：**
```gdscript
# 装配件（供改装UI调用）
func equip_attachment(slot_name: String, cfg: AttachmentConfig) -> bool
# 卸载配件（供改装UI调用）
func detach_attachment(slot_name: String) -> bool
# 查询当前武器所有槽位状态
func get_attachment_slots() -> Array[Dictionary]
  # 返回: [{slot_name, slot_type, is_occupied, attachment_name, attachment_config}]
# 查询武器配置中允许的槽位（过滤 supports_* 字段）
func get_supported_slot_types() -> Array[AttachmentSlot.SlotType]
```

**新增信号（从 BaseWeapon 透传到 WeaponManager）：**
```gdscript
signal attachment_equipped(slot_name: String, attachment_name: String)
signal attachment_detached(slot_name: String)
signal weapon_stats_changed()   # 配件变更后武器数值重算完成
```

**新增 `BaseWeapon` 数值快照接口（供改装UI对比"装前/装后"）：**
```gdscript
func get_stats_snapshot() -> Dictionary
# 返回当前武器实际生效数值：
# { spread_ads, spread_hip, recoil_v, recoil_h, ads_time, weight, suppressed }
```

---

### 3. `WeaponAnimationController` 缺失的信号连接
**问题：** `_connect_weapon_signals()` 没有连接 `bolt_moving`（枪机位移动画驱动）和 `magazine_changed`（弹匣更换动画）。
**修复：** 
- 连接 `bolt_moving` → 设置 AnimationPlayer 的 playback_position（或用 blend_tree 参数）
- 连接 `magazine_changed` → 已由 `reload_started` 处理，无需额外连接，但可选加防御注释

---

### 4. 扩容弹匣（ExtendedMagAttachment）运行时动态结算
**问题：** `ammo_component.apply_magazine_attachments()` 在初始化时调用但彼时无配件，装上扩容弹匣后容量不变。
**修复：** `attachments_changed` 信号触发重算（见缺口1a），同时在 `AmmoComponent` 中加 `recalculate_capacity(base_cap, bonus)` 方法，保证切换弹匣数量不被截断。

---

### 5. `WeaponConfig` 允许的槽位与 `AttachmentSlot.SlotType` 的绑定
**问题：** `supports_optic/muzzle/underbarrel/extended_mag` 是 bool 字段，但 `AttachmentSlot.SlotType` 有 5 个枚举值（OPTIC_RAIL / MUZZLE / UNDERBARREL / MAGAZINE_WELL / SIDE_RAIL），没有统一的"config 允许 → slot 可用"映射。
**修复：** 在 `WeaponConfig` 中新增工具方法 `get_allowed_slot_types() -> Array[AttachmentSlot.SlotType]`，将 bool 字段映射到枚举数组，供改装 UI 过滤可用槽位。

---

## 实现顺序

| 步骤 | 文件 | 内容 |
|------|------|------|
| 1 | `weapon_config.gd` | 新增 `get_allowed_slot_types()` |
| 2 | `ammo_component.gd` | 新增 `recalculate_capacity()` |
| 3 | `base_weapon.gd` | 连接 `attachments_changed`，新增 `get_stats_snapshot()`、`get_effective_fov_override()`、`get_effective_ads_time()` |
| 4 | `weapon_manager.gd` | 新增改装接口、信号透传、`_apply_ads_state()` 读配件 FOV |
| 5 | `weapon_animation_controller.gd` | 连接 `bolt_moving` 信号驱动 AnimationTree 参数 |

---

## 改装 UI 调用示例（接口说明）

```gdscript
# 打开改装界面时：
var slots = weapon_manager.get_attachment_slots()
for s in slots:
    print(s.slot_name, s.is_occupied, s.attachment_name)

# 玩家选择装红点：
var cfg = preload("res://res/attachments/red_dot.tres")
weapon_manager.equip_attachment("OpticRail", cfg)
# → 内部: AttachmentFactory.create(cfg, weapon) → weapon.attachment_manager.equip_to_slot()
# → attachments_changed 触发 → 弹匣容量/武器数值重算
# → weapon_stats_changed 信号 → UI 刷新对比数值

# 显示装前/装后数值对比：
var snapshot_before = weapon_manager.current_weapon.get_stats_snapshot()
# （模拟装上后）
var snapshot_after = ...
```

---

## 不在本轮实现的部分

- Projectile/BallisticProjectile 系统（已有 `_spawn_projectile()` 接口，弹道模块独立）
- 改装 UI 的具体 Control 节点和布局（只留接口，不做 UI）
- `requires_existing_attachment` 约束检查（`AttachmentConfig` 有字段，`AttachmentSlot.attach()` 中标注 TODO）
- burst（三发点射）射击模式（`FireControlComponent` 中有注释 placeholder）
- 弹种切换（`WeaponConfig` 中有注释 placeholder）
