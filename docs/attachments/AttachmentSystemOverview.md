# 改装系统设计概览

## 核心理念

**配件是主体，武器没有名字。** 玩家从机匣开始，逐件组装出一把枪。机匣（Receiver）是组装基础，所有部件——包括枪管、护木、枪机框、拉机柄——都是"配件"，地位平等，可以拆卸更换。完全可以拿 A 型机匣配 B 型枪管和 C 型枪托，组装出一把无固定型号的武器。

## 文件结构

```
res/models/attachments/        ← 所有配件的 3D 场景，按类型分子目录
├── receivers/                 ← 机匣（BaseWeapon 根节点）
│   └── ak12_receiver/
│       ├── ak12_receiver.glb
│       └── ak12_receiver.tscn
├── bolt_carriers/             ← 枪机框（可动部件）
├── barrels/
├── handguards/                ← 护木，场景内含 Underbarrel 子槽
├── receiver_covers/           ← 机匣盖，场景内含 OpticRail 子槽
├── magazines/
├── muzzle_devices/
├── optics/
├── grips/
├── stocks/
├── side_rails/
├── triggers/                  ← 纯数值配件，no_visual = true
└── ammo/                      ← 弹壳视觉

res/config/weapons/attachments/
├── barrel_assemblies/         ← 枪管 .tres
├── bolt_carriers/             ← 枪机框 .tres
├── handguards/                ← 护木 .tres
├── receiver_covers/           ← 机匣盖 .tres
├── magazines/                 ← 弹匣 .tres
├── muzzle_devices/            ← 枪口装置 .tres
├── optics/                    ← 瞄具 .tres
├── grips/                     ← 握把 .tres
├── stocks/                    ← 枪托 .tres
├── side_rails/                ← 左右侧导轨 .tres
├── selector_switches/         ← 快慢机 .tres
└── triggers/                  ← 扳机组 .tres
```

每个配件独立一个子文件夹，内含：
- `*.glb` — 3D 模型
- `*.tscn` — 场景文件，根节点挂 `BaseAttachment` 脚本（机匣用 `BaseWeapon`）

## 槽位系统

### AttachmentSlot 即锚点

`AttachmentSlot` 继承 `Marker3D`，放置在武器场景或配件场景中的接口位置，本身就是挂载锚点。配件装入后作为 `AttachmentSlot` 的子节点，`transform = IDENTITY` 自动贴合。

槽位的数量和名字都以场景里的 `AttachmentSlot` Marker3D 为准：名字默认取节点名，也可以用 `slot_name` 覆盖。`WeaponConfig.supported_slots` 已不再是运行时槽位来源。

每个槽位在检查器里通过 `allowed_attachment_types` 多选限制可安装的配件类型。例如枪管场景里的 `MuzzleDevice` Marker 填 `[MUZZLE]`，就只能装枪口配件；护木 `Underbarrel` 可填 `[GRIP, TACTICAL_DEVICE]` 允许多种下挂配件。

### 层级槽位

配件场景内可包含子 `AttachmentSlot`，实现层级依赖：

```
机匣 (BaseWeapon)
├── Barrel          (AttachmentSlot) ← 直连机匣
│   └── MuzzleDevice (AttachmentSlot) ← 在枪管场景内定义，装枪管后动态注册
├── Handguard       (AttachmentSlot) ← 直连机匣
│   └── Underbarrel (AttachmentSlot) ← 在护木场景内定义，装护木后动态注册
│   ├── SideRailLeft (AttachmentSlot) ← 在护木场景内定义
│   └── SideRailRight (AttachmentSlot) ← 在护木场景内定义
├── ReceiverCover   (AttachmentSlot) ← 直连机匣
│   └── OpticRail   (AttachmentSlot) ← 在机匣盖场景内定义，装机匣盖后动态注册
├── MagazineWell    (AttachmentSlot)
├── Stock           (AttachmentSlot)
├── PistolGrip      (AttachmentSlot)
├── TriggerGroup    (AttachmentSlot)
└── BoltCarrierSlot (AttachmentSlot) ← 枪机框也是可替换配件
```

`AttachmentManager` 在配件装入时自动扫描并注册子槽，卸下时自动递归清理。

### 导轨滑动

设置 `AttachmentConfig.rail_adjustable = true` 的配件可以沿导轨 Z 轴前后滑动。改装 UI 通过 `WeaponManager.set_rail_offset(slot_name, offset)` 实时调整位置。

如果同一配件类型存在多个槽位（左右侧导轨、多个导轨段），预设自动装配会优先读取 `AttachmentConfig.preferred_slot_names` 决定装到哪个槽，再读取 `rail_offset` 决定初始位置。`preferred_slot_names` 为空时才按场景中 Marker3D 的注册顺序回退。

## 配件挂载流程

```
equip_attachment("Barrel", barrel_cfg)
  → AttachmentFactory.create(cfg, weapon)     // 实例化配件节点
  → attachment_manager.equip_to_slot(att, "Barrel")
      → slot.attach(att)                      // 记录状态
      → _place_attachment(att, slot)          // add_child 到 AttachmentSlot 下
      → _scan_slots(att)                      // 扫描配件内的子槽位
      → attachment_equipped.emit()
      → attachments_changed.emit()            // 触发数值缓存重建
```

## 常规参数与物理计算

散布、瞄准速度、重量、长度和功能开关等常规参数在 `attachments_changed` 时一次性汇总到缓存，供对应系统 O(1) 查询。

后座不走“基础值 + 配件修正值”路径。`RecoilPhysicsModel` 会遍历当前配件实例，根据质量、质心位置、转动惯量、枪口燃气方向/比例、握把支撑和枪托肩部接触点计算单发冲量与恢复控制参数。改装改变的是物理输入，界面展示的是物理模型输出。

## Mod 开发指南

一个新配件 mod 只需提供：

1. **`*.glb`**：配件模型，原点放在与上级接口的接触面中心，-Z 朝枪口方向
2. **`*.tscn`**：配件场景，根节点挂 `BaseAttachment`（或子类）脚本；如果配件自身有可挂槽位（如带导轨的护木），在场景内加 `AttachmentSlot` 子节点
3. **`*.tres`**：`AttachmentConfig` 资源，填写 `attachment_type`、常规参数和对应子类的物理参数、`attachment_scene` 路径；槽位约束写在场景 Marker3D 的 `allowed_attachment_types` 上，可多选。同类多槽位用 `preferred_slot_names` 指定左/右或具体槽名，用 `rail_offset` 指定初始导轨位置

无需修改任何引擎 GDScript。

### 对齐与 SnapPoint

配件挂到槽位上后，位置有两种确定方式：

- **原点对齐（默认）**：配件根节点 `transform = IDENTITY`，原点贴合 `AttachmentSlot`。适用于模型原点已经精确设在接触面中心的配件。
- **SnapPoint 对齐**：在配件 `.tscn` 里加一个名为 `SnapPoint` 的 `Marker3D`，放到真实的装配接触点，代码会把它对准槽位。原点在哪都无所谓，且支持非对称配件（侧导轨、快慢机、枪托）。

推荐 mod 作者优先用 SnapPoint——不用在 Blender 里反复调原点，在 Godot 编辑器里拖一个点即可，所见即所得。

SnapPoint 放置参考：

| 配件类型 | SnapPoint 位置 |
|---|---|
| 枪管组 | 与机匣接触的后端面圆心 |
| 消音器/制退器 | 螺纹根部端面圆心 |
| 瞄具 | 底座导轨卡扣下表面中心 |
| 弹匣 | 弹匣口顶端接口面中心 |
| 握把 | 安装螺孔接触面中心 |
| 枪托 | 与机匣铰链接合面中心 |
| 侧导轨 / 快慢机等非对称件 | 安装面上实际接触点 |
