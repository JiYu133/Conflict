# 武器改装界面

## 概述

武器改装界面以“军械档案”为视觉主题，在独立的 3D 预览中复制当前武器，并将实体挂载点投影为可交互的二维标注。玩家可以旋转预览、替换或卸下配件、调整配件在导轨上的位置，并在提交前查看改装后的武器参数。

界面采用**草稿后应用**的工作流：选择配件只会修改预览副本；只有点击“应用更改”后，草稿才会写回玩家持有的武器。关闭界面不会自动提交尚未应用的修改。

---

## 入口与操作

当前入口是调试动作 `weapon_mod_menu`，默认按键为 `N`，可以在设置界面的调试键位分类中重新绑定。正式的军械库或装备界面接入后，可以直接调用 `WeaponModMenu.open()`。

| 操作 | 结果 |
|---|---|
| `N`（默认） | 打开或关闭改装界面 |
| 鼠标左键拖拽预览空白处 | 水平或垂直旋转武器 |
| 点击“复位视角” | 恢复自动取景的侧视角度 |
| 点击挂载点卡片 | 打开该挂载点的配件列表 |
| 拖动“导轨位置”滑块 | 在配件允许的范围内调整前后位置 |
| 点击“应用更改” | 校验草稿并写回当前武器 |
| 点击“放弃更改” | 从当前武器重新读取装配状态 |
| `Esc` 或“关闭” | 关闭界面，不提交当前草稿 |

界面打开时会保存玩家原本的控制状态、停止角色移动并显示鼠标；关闭时仅在玩家仍然存活且打开前可控制的情况下恢复控制。界面使用 `CanvasLayer` 22，位于暂停菜单和设置页面之上。

---

## 界面结构

```text
WeaponModMenu (CanvasLayer, layer 22)
├── 背景模糊层
├── 蓝图网格（GPU shader）
├── WeaponPreview (SubViewport)
│   ├── 独立 World3D
│   ├── Camera3D + 展示灯光
│   └── BaseWeapon 预览副本
├── WeaponCalloutLayer
│   ├── 贝塞尔引线
│   ├── 挂载点圆环
│   └── 四角取景标记
├── 挂载点卡片层
├── 配件详情面板
├── 武器参数条
└── 应用 / 放弃 / 关闭操作区
```

`WeaponPreview` 根据武器可视节点的包围盒自动选择侧视轴、中心和距离，因此不同长度与朝向的武器都能进入画面。武器或配件变化时，镜头使用缓动过渡到新的取景范围。挂载点卡片围绕其投影位置自动布局并进行轻量碰撞避让；旋转武器或缩放窗口时，引线和卡片会持续更新。

卡片首次出现时从挂载点方向淡入并缩放，后续投影位置变化使用较短的移动动画。碰撞避让最多执行四轮，并将卡片限制在舞台边缘 8 px 以内；不可投影或位于相机背后的挂载点不会生成卡片和引线。详情面板跟随选中卡片移动。引线会根据挂载点相对卡片的位置连接最近的水平或垂直边，不再假定卡片只位于武器左右两列。

左右侧导轨在运行时仍是两个独立技术槽位，但界面将它们合并为一张“侧导轨”卡片。展开卡片后，左右槽位分别显示，并各自保留独立的配件、引线和导轨偏移。

---

## 草稿与应用流程

```text
open()
  ├── 读取真枪配件配置 → _draft
  ├── 读取运行时导轨偏移 → _draft_rail_offsets
  └── 重建预览武器

选择 / 卸下 / 移动配件
  ├── 只修改草稿
  ├── 重建或更新预览副本
  ├── 刷新挂载点与引线
  └── 刷新参数条和应用按钮

apply_changes()
  ├── 拒绝缺少核心配件的草稿
  ├── 按层级反复扫描并写回配件
  ├── 写回各槽位的运行时导轨偏移
  └── 从真枪重新建立干净草稿
```

配件可以产生子槽位，例如机匣盖提供瞄具导轨、护木提供下导轨和侧导轨。预览恢复与正式应用都会分轮扫描当前可见槽位，直到嵌套配件全部安装完成或不再有进展。卸下父配件时，暂时失去挂载位置的子配件草稿会被保留；把父配件装回后，系统会尽可能自动恢复这些子配件。

### 核心配件约束

标记为核心的槽位可以在草稿中临时清空，方便查看或更换部件，但核心槽位为空时“应用更改”会被禁用并显示缺失列表。当前核心定义来自 `AttachmentSlot.is_core()`，而不是 UI 内的硬编码名称。

---

## 参数预览

底部参数条读取**预览副本**的 `BaseWeapon.get_stats_snapshot()`，因此会即时反映尚未应用的草稿。后座条展示物理模型计算出的单发俯仰/偏航角速度冲量，不读取旧的角度修正字段。当前展示以下数据：

- 腰射散布；
- 机瞄散布；
- 垂直后座；
- 水平后座；
- 总重量；
- 武器全长。

参数值变化时使用 Tween 平滑插值。散布与后座属于数值越低越好的指标；重量和全长作为结构参数展示，不使用同一优劣含义。

---

## 组件职责

| 文件 | 职责 |
|---|---|
| `classes/ui/weapon_mod/weapon_mod_menu.gd` | 生命周期、界面构建、草稿状态、槽位布局、校验与应用 |
| `classes/ui/weapon_mod/weapon_preview.gd` | 在独立世界中重建武器、自动取景、旋转视角、投影挂载点 |
| `classes/ui/weapon_mod/weapon_callout_layer.gd` | 绘制动态引线、节点圆环与取景角标 |
| `classes/ui/weapon_mod/attachment_catalog.gd` | 扫描并缓存可用的 `AttachmentConfig` 资源，按槽位过滤和排序 |
| `classes/ui/weapon_mod/weapon_mod_text.gd` | 集中维护所有玩家可见文案，便于后续本地化 |
| `res/shaders/blueprint_grid.gdshader` | 在 GPU 上绘制蓝图网格背景，避免逐帧 `_draw()` 网格循环 |

### 对外接口

```gdscript
weapon_mod_menu.initialize(player)
weapon_mod_menu.open()
weapon_mod_menu.close()
weapon_mod_menu.toggle()
weapon_mod_menu.is_open()

weapon_mod_menu.opened.connect(_on_mod_menu_opened)
weapon_mod_menu.closed.connect(_on_mod_menu_closed)
```

`initialize(player)` 必须在第一次打开前调用。`player` 需要提供 `controllable`、`is_alive`、`set_controllable()` 和当前 `weapon_manager`。

---

## 添加可被界面发现的配件

1. 创建一个 `AttachmentConfig` 的 `.tres` 或 `.res` 资源。
2. 将资源放在 `res://res/config/weapons/attachments/` 或其子目录。
3. 确保目标 `AttachmentSlot.allowed_attachment_types` 接受该配件的 `attachment_type`。
4. 若配件只能安装在特定实体槽位，填写 `preferred_slot_names`；目录会排除首选列表不包含当前槽名的资源。左右侧专用配件应明确指定对应槽位，例如右侧 AK-12 导轨使用 `SideRailRight`。
5. 若配件可以沿导轨移动，启用 `rail_adjustable`，并设置 `rail_offset_min`、`rail_offset_max` 和默认 `rail_offset`（单位均为米）。
6. 重新进入游戏，让 `AttachmentCatalog` 重新扫描资源。编辑器调试期间也可以调用 `AttachmentCatalog.invalidate()` 清除缓存。

配件列表按 `attachment_name` 排序。目录只负责发现资源，最终兼容性仍由挂载点的 `can_accept_attachment()` 判定，因此新增资源不需要修改界面代码。

---

## 已知边界

- 当前入口属于调试功能，尚未接入正式的军械库或部署流程。
- 配件目录在首次读取后缓存；运行中新增资源不会自动出现，除非显式清除缓存。
- 关闭界面会丢弃未应用草稿；界面目前不会弹出二次确认。
- 导轨偏移保存在已安装配件节点的运行时元数据中，不会修改共享的 `AttachmentConfig` 资源。
