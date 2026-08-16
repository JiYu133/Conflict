# Conflict — 开发文档

多人战术射击游戏，基于 Godot 4 GDScript 开发。

---

## 模块索引

- [Player 系统](#player-系统)
- [医疗与伤害系统](#医疗与伤害系统)
- [UI 系统](#ui-系统)
- [Weapon 核心](#weapon-核心)
- [Weapon 配件](#weapon-配件)
- [工具类](#工具类)

---

## 架构概览

```
BasePlayer (CharacterBody3D)
├── PlayerConfig               移动/模型/武器参数
│   ├── ModelLookupConfig      模型节点查找规则
│   └── CameraConfig           摄像机效果参数
│
├── PlayerModelManager         模型加载与骨骼缓存
├── PlayerMovementController   移动物理（起步/步态/转向/制动）
├── PlayerCollisionController  hitbox 驱动的主环境碰撞体
├── PlayerCameraController     摄像机效果（5层叠加）
├── PlayerAnimationController  动画状态机
├── PlayerRagdollSystem        死亡布娃娃
├── FootIKController           脚部 IK（预留）
├── HealthSystem               伤害、生理状态与医疗死亡
│   ├── VitalsModel            血量、呼吸与身体部位状态
│   └── AnatomyConfig          器官/骨骼/大血管及伤道参数
│
└── WeaponManager              武器装备/切换/改装接口
    ├── WeaponObstructionDetector  顶墙收枪射线检测
    │
    └── BaseWeapon (Node3D)        ← 机匣场景根节点
        ├── AmmoComponent          弹药管理
        ├── BoltComponent          枪机自动循环
        ├── FireControlComponent   扳机/保险/射击模式
        ├── GasComponent           导气延时
        ├── RecoilComponent        后座（摄像机 kick）
        ├── EjectionComponent      抛壳位置/速度
        ├── MalfunctionComponent   故障与排障
        ├── WeaponAnimationController  信号驱动动画
        ├── WeaponMovingPartsController  枪机/拉机柄位移
        │
        └── AttachmentManager      配件管理（层级槽位）
            ├── AttachmentSlot     直连机匣的槽位（Barrel/Stock/...）
            │   └── BaseAttachment（配件实例）
            │       └── AttachmentSlot（配件自带的子槽，如机匣盖→导轨）
            │           └── BaseAttachment（子配件实例）
            └── ...
```

---

## 初始化流程

```
BasePlayer._ready()
  └── _initialize_subsystems()          创建并初始化所有子系统
        ├── camera_controller.initialize()
        ├── movement_controller.initialize()
        ├── foot_ik_controller.initialize()
        └── connect_movement_signals()   落地/起跳信号接入摄像机
  └── model_manager.load_model()        异步加载模型场景
        └── model_loaded 信号 →  _on_model_loaded()
              ├── ragdoll_system.initialize()
              ├── animation_controller.initialize()
              ├── camera_controller._find_camera_nodes()
              ├── setup_weapon_sway_pivot()
              ├── obstruction_detector.initialize()
              └── weapon_manager.load_and_equip()
```

---

## 关键信号流

```
PlayerMovementController
  jumped          → PlayerAnimationController._on_jumped()
                  → PlayerCameraController.on_jumped()
  landed          → PlayerAnimationController._on_landed()
                  → PlayerCameraController.on_landed()
  started_running → PlayerAnimationController._on_started_running()
  stopped_running → PlayerAnimationController._on_stopped_running()

BasePlayer
  died            → PlayerAnimationController._on_died()
  revived         → PlayerAnimationController._on_revived()

HealthSystem
  wound_added     → 医疗 HUD / 后续治疗系统
  organ_damaged  → 医疗 HUD / 后续器官机能系统
  bone_fractured → 医疗 HUD / 后续移动惩罚系统
  medically_died → 死亡类型/方向观察者
  医疗死亡判定    → BasePlayer.die() → PlayerRagdollSystem

WeaponManager
  weapon_changed  → BasePlayer._on_weapon_changed()
                    → PlayerCameraController.set_recoil_component()

BaseWeapon
  fired           → RecoilComponent.apply_recoil()
```

---

## Player 系统

| 类 | 文件 | 说明 |
|---|---|---|
| [BasePlayer](player/BasePlayer.md) | `Classes/Player/base_player.gd` | 玩家根节点，协调所有子系统 |
| [PlayerConfig](player/PlayerConfig.md) | `Classes/Player/player_config.gd` | 移动/模型/武器参数数据档案 |
| [CameraConfig](player/CameraConfig.md) | `Classes/Player/camera_config.gd` | 摄像机效果参数数据档案 |
| [ModelLookupConfig](player/ModelLookupConfig.md) | `Classes/Player/model_lookup_config.gd` | 模型节点自动查找规则 |
| [PlayerModelManager](player/PlayerModelManager.md) | `Classes/Player/player_model_manager.gd` | 模型加载与骨骼缓存 |
| [PlayerMovementController](player/PlayerMovementController.md) | `Classes/Player/player_movement_controller.gd` | 移动物理与信号发射 |
| [PlayerCollisionController](player/PlayerCollisionController.md) | `classes/player/player_collision_controller.gd` | 主碰撞体唯一所有者、实时 hitbox 边界追随 |
| [PlayerCameraController](player/PlayerCameraController.md) | `Classes/Player/player_camera_controller.gd` | 摄像机挂载与5层程序化效果 |
| [PlayerAnimationController](player/PlayerAnimationController.md) | `Classes/Player/player_animation_controller.gd` | 信号驱动的动画状态机 |
| [PlayerRagdollSystem](player/PlayerRagdollSystem.md) | `Classes/Player/player_ragdoll_system.gd` | 死亡布娃娃开关 |
| [FootIKController](player/FootIKController.md) | `Classes/Player/foot_ik_controller.gd` | 脚部 IK（存根，未实现） |
| [WeaponObstructionDetector](player/WeaponObstructionDetector.md) | `Classes/Weapon/Weapon/weapon_obstruction_detector.gd` | 顶墙收枪射线检测 |

---

## 医疗与伤害系统

| 文档 | 核心文件 | 说明 |
|------|----------|------|
| [Medical & Anatomy System](player/MedicalSystem.md) | `classes/player/medical/health_system.gd` | P1/P2 伤害管线、27 结构解剖模型、伤道、器官损伤、骨折、内外出血与调试工具 |

---

## UI 系统

| 文档 | 说明 |
|------|------|
| [UI System Overview](ui/UISystem.md) | UI 架构、配色规范、组件索引、主题使用、CanvasLayer 层级管理 |
| [Settings UI Guide](../SETTINGS_UI_GUIDE.md) | 设置界面手动绘制指南（Godot 编辑器操作步骤） |
| [Weapon Mod Menu](ui/WeaponModMenu.md) | 3D 改装预览、草稿应用流程、操作说明与配件接入指南 |

**核心组件**:
- **SettingsMenu** (`classes/ui/settings/settings_menu.gd`) - 键位绑定设置面板
- **KeyPromptManager** (`classes/ui/key_prompt_manager.gd`) - 左下角键位提示卡片
- **TopRightNotificationManager** (`classes/ui/top_right_notification_manager.gd`) - 右上角通知系统
- **DeathScreen** (`classes/ui/death_screen.gd`) - 死亡屏幕遮罩
- **MedicalDebugHUD** (`classes/ui/medical_debug_hud.gd`) - 医疗调试面板
- **WeaponModMenu** (`classes/ui/weapon_mod/weapon_mod_menu.gd`) - 草稿式 3D 武器改装界面

---

## Weapon 核心

| 类 | 文件 | 说明 |
|---|---|---|
| [BaseWeapon](weapon/BaseWeapon.md) | `classes/weapon/base_weapon.gd` | 枪械根节点，管理组件与自动循环状态机 |
| [WeaponConfig](weapon/WeaponConfig.md) | `classes/weapon/weapon_config.gd` | 武器基础参数（待重构，部分属性将移至配件） |
| [WeaponManager](weapon/WeaponManager.md) | `classes/weapon/weapon_manager.gd` | 武器装备/切换/改装接口 |
| [武器交互与携行系统设计](weapon/WeaponInteractionDesign.md) | 概念设计 | 非格子背包、身体选弹匣、换弹/战术配件轮盘与单武器快捷键 |
| [WeaponMovingPartsController](weapon/WeaponMovingPartsController.md) | `classes/weapon/weapon_moving_parts_controller.gd` | 枪机框/拉机柄位移驱动 |
| [AmmoComponent](weapon/AmmoComponent.md) | `classes/weapon/ammo_component.gd` | 弹匣/膛内弹药状态 |
| [BoltComponent](weapon/BoltComponent.md) | `classes/weapon/bolt_component.gd` | 枪机自动循环仿真 |
| [FireControlComponent](weapon/FireControlComponent.md) | `classes/weapon/fire_control_component.gd` | 扳机/保险/射击模式控制 |
| [GasComponent](weapon/GasComponent.md) | `classes/weapon/gas_component.gd` | 导气延时计算 |
| [RecoilComponent](weapon/RecoilComponent.md) | `classes/weapon/recoil_component.gd` | 摄像机 kick 冲量（pitch/yaw） |
| [EjectionComponent](weapon/EjectionComponent.md) | `classes/weapon/ejection_component.gd` | 抛壳位置与速度 |

---

## 改装系统

| 文档 | 说明 |
|------|------|
| [改装系统概览](attachments/AttachmentSystemOverview.md) | 设计理念、层级槽位、文件结构、Mod 指南 |

| 类 | 文件 | 说明 |
|---|---|---|
| [AttachmentConfig](attachments/AttachmentConfig.md) | `classes/weapon/weaponattachments/attachment_config.gd` | 配件参数数据档案 |
| [BaseAttachment](attachments/BaseAttachment.md) | `classes/weapon/weaponattachments/base_attachment.gd` | 配件抽象基类 |
| [AttachmentSlot](attachments/AttachmentSlot.md) | `classes/weapon/weaponattachments/attachment_slot.gd` | 挂载点节点（即对齐锚点） |
| [AttachmentManager](attachments/AttachmentManager.md) | `classes/weapon/weaponattachments/attachment_manager.gd` | 层级槽位扫描/装卸/数值缓存 |
| [AttachmentFactory](attachments/AttachmentFactory.md) | `classes/weapon/weaponattachments/attachment_factory.gd` | 配件实例化工厂 |
| [OpticAttachment](attachments/OpticAttachment.md) | `classes/weapon/weaponattachments/scopes/optic_attachment.gd` | 瞄具基类 |

---

## 工具类

| 类 | 文件 | 说明 |
|---|---|---|
| [GameLogger](utils/GameLogger.md) | `Classes/GameLogger/game_logger.gd` | 分级日志（DEBUG/INFO/WARN/ERROR） |
