# Conflict — 开发文档

多人战术射击游戏，基于 Godot 4 GDScript 开发。

---

## 模块索引

- [Player 系统](#player-系统)
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
├── PlayerCameraController     摄像机效果（5层叠加）
├── PlayerAnimationController  动画状态机
├── PlayerRagdollSystem        死亡布娃娃
├── FootIKController           脚部 IK（预留）
│
├── WeaponManager              武器装备/切换
│   └── WeaponObstructionDetector  顶墙收枪射线检测
│
└── BaseWeapon (Node3D)
    ├── AmmoComponent          弹药管理
    ├── BoltComponent          枪机自动循环
    ├── FireControlComponent   扳机/保险/射击模式
    ├── GasComponent           导气延时
    ├── RecoilComponent        后座累积与回正
    ├── EjectionComponent      抛壳位置/速度
    └── AttachmentManager      配件管理
        └── AttachmentSlot × N 挂载点
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
| [PlayerCameraController](player/PlayerCameraController.md) | `Classes/Player/player_camera_controller.gd` | 摄像机挂载与5层程序化效果 |
| [PlayerAnimationController](player/PlayerAnimationController.md) | `Classes/Player/player_animation_controller.gd` | 信号驱动的动画状态机 |
| [PlayerRagdollSystem](player/PlayerRagdollSystem.md) | `Classes/Player/player_ragdoll_system.gd` | 死亡布娃娃开关 |
| [FootIKController](player/FootIKController.md) | `Classes/Player/foot_ik_controller.gd` | 脚部 IK（存根，未实现） |
| [WeaponObstructionDetector](player/WeaponObstructionDetector.md) | `Classes/Weapon/Weapon/weapon_obstruction_detector.gd` | 顶墙收枪射线检测 |

---

## Weapon 核心

| 类 | 文件 | 说明 |
|---|---|---|
| [BaseWeapon](weapon/BaseWeapon.md) | `Classes/Weapon/Weapon/base_weapon.gd` | 枪械根节点，管理组件与自动循环状态机 |
| [WeaponConfig](weapon/WeaponConfig.md) | `Classes/Weapon/Weapon/weapon_config.gd` | 武器参数数据档案 |
| [WeaponManager](weapon/WeaponManager.md) | `Classes/Weapon/Weapon/weapon_manager.gd` | 当前武器装备/切换管理 |
| [AmmoComponent](weapon/AmmoComponent.md) | `Classes/Weapon/Weapon/ammo_component.gd` | 弹匣/膛内弹药状态 |
| [BoltComponent](weapon/BoltComponent.md) | `Classes/Weapon/Weapon/bolt_component.gd` | 枪机自动循环仿真 |
| [FireControlComponent](weapon/FireControlComponent.md) | `Classes/Weapon/Weapon/fire_control_component.gd` | 扳机/保险/射击模式控制 |
| [GasComponent](weapon/GasComponent.md) | `Classes/Weapon/Weapon/gas_component.gd` | 导气延时计算 |
| [RecoilComponent](weapon/RecoilComponent.md) | `Classes/Weapon/Weapon/recoil_component.gd` | 后座累积与回正 |
| [EjectionComponent](weapon/EjectionComponent.md) | `Classes/Weapon/Weapon/ejection_component.gd` | 抛壳位置与速度 |

---

## Weapon 配件

| 类 | 文件 | 说明 |
|---|---|---|
| [AttachmentConfig](attachments/AttachmentConfig.md) | `Classes/Weapon/WeaponAttachments/attachment_config.gd` | 配件参数数据档案 |
| [BaseAttachment](attachments/BaseAttachment.md) | `Classes/Weapon/WeaponAttachments/base_attachment.gd` | 配件抽象基类 |
| [AttachmentSlot](attachments/AttachmentSlot.md) | `Classes/Weapon/WeaponAttachments/attachment_slot.gd` | 武器挂载点节点 |
| [AttachmentManager](attachments/AttachmentManager.md) | `Classes/Weapon/WeaponAttachments/attachment_manager.gd` | 配件扫描/装备/数值汇总 |
| [AttachmentFactory](attachments/AttachmentFactory.md) | `Classes/Weapon/WeaponAttachments/attachment_factory.gd` | 配件实例化工厂 |
| [OpticAttachment](attachments/OpticAttachment.md) | `scopes/optic_attachment.gd` | 瞄具基类 |
| [IronSightAttachment](attachments/IronSightAttachment.md) | `scopes/iron_sight.gd` | 机械瞄具（默认，不可卸） |
| [RedDotAttachment](attachments/RedDotAttachment.md) | `scopes/red_dot.gd` | 1× 红点瞄具 |
| [HolographicAttachment](attachments/HolographicAttachment.md) | `scopes/holographic.gd` | 1× 全息瞄具 |
| [ACOGAttachment](attachments/ACOGAttachment.md) | `scopes/acog.gd` | 4× 棱镜瞄具 |
| [VerticalGripAttachment](attachments/VerticalGripAttachment.md) | `grips/vertical_grip.gd` | 垂直前握把 |
| [SuppressorAttachment](attachments/SuppressorAttachment.md) | `muzzles/suppressor.gd` | 螺纹消音器 |
| [ExtendedMagAttachment](attachments/ExtendedMagAttachment.md) | `magazines/extended_mag.gd` | 加长弹匣 (+10) |

---

## 工具类

| 类 | 文件 | 说明 |
|---|---|---|
| [GameLogger](utils/GameLogger.md) | `Classes/GameLogger/game_logger.gd` | 分级日志（DEBUG/INFO/WARN/ERROR） |
