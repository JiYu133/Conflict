# WeaponManager

**文件路径：** `classes/weapon/weapon_manager.gd`
**继承自：** `Node`

## 功能概述

武器持有者的门面控制器。管理当前装备的武器实例，转发玩家输入，暴露改装接口。一个角色挂一个即可，不需要直接操作 BaseWeapon 或 AttachmentManager。

## 信号

| 信号 | 参数 | 说明 |
|------|------|------|
| `weapon_changed` | `new_weapon: BaseWeapon` | 装备新武器时 |
| `weapon_fired` | `weapon: BaseWeapon` | 预留 |
| `attachment_equipped` | `slot_name, attachment_name` | 配件装备后 |
| `attachment_detached` | `slot_name` | 配件卸下后 |
| `weapon_stats_changed` | — | 配件变更导致数值重算后 |

## 武器操作

```gdscript
weapon_manager.press_trigger()          # 按下扳机
weapon_manager.release_trigger()        # 松开扳机
weapon_manager.reload()                 # 换弹
weapon_manager.cycle_fire_mode()        # 切换射击模式
weapon_manager.set_aiming(true/false)   # 切换 ADS 状态
weapon_manager.attempt_malfunction_clearance()  # 排障
```

## 动态改装接口

```gdscript
# 装上配件
weapon_manager.equip_attachment("Barrel", barrel_config) -> bool

# 不指定槽位，自动匹配第一个可用槽位（父配件装上后其子槽也会进入匹配）
weapon_manager.equip_attachment_auto(barrel_config) -> bool

# 卸下配件，返回被卸下的实例
weapon_manager.detach_attachment("Barrel") -> BaseAttachment

# 查询所有槽位状态（供改装 UI 渲染）
# 每项: { slot_name, slot_type, allowed_attachment_types, is_occupied, attachment_name, attachment_config }
weapon_manager.get_attachment_slots() -> Array[Dictionary]

# 查询当前场景中已注册槽位的类型列表；来源是 AttachmentSlot Marker3D，不再读取 WeaponConfig
weapon_manager.get_supported_slot_types() -> Array[AttachmentSlot.SlotType]

# 调整导轨配件前后位置（供改装 UI 滑动条）
weapon_manager.set_rail_offset("OpticRail", 0.02)
weapon_manager.get_rail_offset("OpticRail") -> float
```

## 武器数值快照（供改装 UI 装前/装后对比）

```gdscript
var snapshot := weapon_manager.current_weapon.get_stats_snapshot()
# 返回: { spread_ads, spread_hip, recoil_v, recoil_h, ads_time, weight, suppressed, fov_override }
```

## 预设配件

`load_and_equip()` 装备武器后自动调用 `_equip_default_attachments()`，
按 `WeaponConfig.default_attachment_configs` 顺序自动匹配当前可用槽位。

在 `WeaponConfig.tres` 里配置：
```
default_attachment_configs = [barrel_cfg, mag_cfg, handguard_cfg, dust_cover_cfg, iron_sight_cfg, ...]
```
列表顺序即装配顺序：先装父配件，再装父配件子槽上的配件，例如 `dust_cover_cfg` 后接 `iron_sight_cfg`，游戏会先把机匣盖装到 `ReceiverCover`，随后自动识别机匣盖场景里的 `OpticRail` 子槽并装入照门。

`default_attachment_slots` 仍是旧版显式槽位名的兼容写法；新方案建议留空，让代码自动匹配。

自动匹配会先按 `AttachmentConfig.preferred_slot_names` 找指定槽位，再按当前场景顺序回退。左右侧导轨这类同名类型配件，应在配置里显式填 `["SideRailLeft"]` 或 `["SideRailRight"]`，避免预设时选错边。

## ADS 相关

`set_aiming()` 会触发 `_apply_ads_state()`，自动读取：
- 配件瞄具的 `fov_override`（优先于 `config.ads_fov_override`）
- 配件的 `ads_speed_modifier`（叠加到 `config.ads_time`）
