# UI 系统文档

## 概述

Conflict 的 UI 系统采用**统一的视觉语言**：扁平、克制、单一强调色（金色），细描边、充足留白，使用 `ConflictCJKUI.ttf` 字体支持中日韩文字。

所有 UI 组件遵循一致的配色方案和动画风格，确保玩家在不同界面间获得连贯的视觉体验。

---

## 架构特点

- **混合模式**：部分 UI 纯代码构建（通知系统），部分使用场景文件（设置菜单）
- **统一配色**：所有组件共享相同的颜色常量和样式约定
- **信号驱动**：UI 响应游戏逻辑事件（玩家死亡、键位冲突等）
- **层级管理**：通过 CanvasLayer 控制渲染顺序

---

## 配色规范

### 基础色板

```gdscript
# 背景
背景遮罩:    Color(0, 0, 0, 0.72)            # 半透明黑
主面板:      Color(0.086, 0.098, 0.118, 0.98) # 深蓝灰

# 边框与分隔
细边框:      Color(1, 1, 1, 0.07)            # 微妙白边
分隔线:      Color(1, 1, 1, 0.07)            # 同细边框

# 文字
主文字:      Color(0.92, 0.93, 0.95, 1.0)    # 浅灰白
次要文字:    Color(0.55, 0.58, 0.63, 1.0)    # 中灰
反色文字:    Color(0.1, 0.1, 0.1, 1.0)       # 深色（用于金色按钮）

# 强调色
金色主色:    Color(0.85, 0.72, 0.20, 1.0)    # 按钮、高亮
金色悬停:    Color(0.95, 0.82, 0.30, 1.0)    # 鼠标悬停
金色半透:    Color(0.85, 0.72, 0.20, 0.5)    # 边框、幽灵按钮

# 状态色
危险/警告:   Color(0.90, 0.36, 0.33, 1.0)    # 红色
健康:        Color(0, 1, 0, 1.0)              # 绿色
受伤:        Color(1, 1, 0, 1.0)              # 黄色
```

### 按钮样式变体

1. **AccentButton** - 金色主要操作按钮
   - Normal: 金色背景，深色文字
   - Hover: 亮金色背景
   - 用途: "完成"、"确认"等主要操作

2. **GhostButton** - 幽灵按钮（次要操作）
   - Normal: 透明背景，金色边框和文字
   - Hover: 淡金色背景
   - 用途: "取消"、"重置"等次要操作

3. **Default Button** - 标准按钮
   - Normal: 深灰背景，浅色文字
   - Hover: 稍亮灰色背景
   - 用途: 通用按钮

---

## 核心组件

### 1. 设置菜单 (SettingsMenu)

**文件位置**:
- 脚本: `classes/ui/settings/settings_menu.gd`
- 场景: `res/ui/settings_menu.tscn`
- 主题: `res/themes/settings_theme.tres`
- 数据: `classes/ui/settings/keybind_store.gd`

**功能**:
- 键位重新绑定（点击监听模式）
- 实时冲突检测（红色警告）
- 持久化到 `user://keybinds.cfg`
- ESC 键打开/关闭

**设计特点**:
- 场景文件定义固定 UI 结构
- 代码动态生成键位行（基于 `KeybindStore.ACTIONS`）
- 分类标题组织（移动、姿态、战斗、调试）
- 单项/全局恢复默认功能

**手动绘制指南**: 见 [SETTINGS_UI_GUIDE.md](../SETTINGS_UI_GUIDE.md)

**CanvasLayer**: 20

---

### 2. 键位提示管理器 (KeyPromptManager)

**文件位置**:
- `classes/ui/key_prompt_manager.gd`
- `classes/ui/key_prompt_card.gd`
- `classes/ui/key_prompt_entry.gd`
- `classes/ui/key_prompt_config.gd`

**功能**:
- 屏幕左下角显示动态键位提示
- 卡片式布局，多条目聚合
- 基于游戏状态自动显示/隐藏
- 键帽图标 + 操作描述

**配置**:
```gdscript
var config = KeyPromptConfig.new()
config.title = "武器"
config.entries = [
    KeyPromptEntry.new("fire", "射击"),
    KeyPromptEntry.new("reload", "换弹"),
]
KeyPromptManager.show_card("weapon", config)
```

**CanvasLayer**: 10

---

### 3. 右上角通知系统 (TopRightNotificationManager)

**文件位置**:
- `classes/ui/top_right_notification_manager.gd`
- `classes/ui/top_right_notification_card.gd`
- `classes/ui/top_right_notification_entry.gd`
- `classes/ui/top_right_notification_config.gd`

**功能**:
- 右上角堆叠式通知卡片
- 自动淡入淡出动画
- 支持状态色（健康、受伤、危险等）
- 3 秒后自动消失

**使用示例**:
```gdscript
var config = TopRightNotificationConfig.new()
config.title = "装备"
config.entries = [
    TopRightNotificationEntry.new("已装备: AK-74M", HEALTHY)
]
TopRightNotificationManager.show_notification("equip", config)
```

**CanvasLayer**: 15

---

### 4. 死亡屏幕 (DeathScreen)

**文件位置**:
- `classes/ui/death_screen.gd`

**功能**:
- 全屏半透明红色遮罩
- 死亡原因文字显示
- 渐变淡入效果

**CanvasLayer**: 100

---

### 5. 医疗调试 HUD (MedicalDebugHUD)

**文件位置**:
- `classes/ui/medical_debug_hud.gd`

**功能**:
- 实时显示生理状态（心率、血压、呼吸）
- 伤口列表（位置、类型、出血量）
- 器官损伤状态
- 骨折与大血管损伤指示
- 仅 Debug 构建可见

**CanvasLayer**: 5

---

## CanvasLayer 层级规范

为避免 UI 元素互相遮挡，使用以下层级约定：

| Layer | 用途 | 组件 |
|-------|------|------|
| 5 | 调试信息 | MedicalDebugHUD |
| 10 | 游戏内 HUD | KeyPromptManager |
| 15 | 临时通知 | TopRightNotificationManager |
| 20 | 全屏菜单 | SettingsMenu |
| 100 | 遮罩与终局 | DeathScreen |

---

## 主题资源使用

### 创建自定义主题

1. FileSystem → `res/themes/` → New Resource → Theme
2. 设置 **Default Font**: `res/fonts/ConflictCJKUI.ttf`
3. 添加控件类型覆盖（Button, Label, Panel 等）
4. 使用 **Theme Type Variation** 创建变体（如 AccentButton）

### 应用主题

**场景节点**:
```
Inspector → Theme → [拖入 .tres 文件]
Inspector → Theme Type Variation → "AccentButton"
```

**代码动态应用**:
```gdscript
var button = Button.new()
button.theme = load("res://themes/settings_theme.tres")
button.theme_type_variation = "AccentButton"
```

---

## 字体资源

**文件**: `res/fonts/ConflictCJKUI.ttf`

**许可证**: OFL (SIL Open Font License)  
**来源**: Noto Sans CJK  
**支持**: 简体中文、繁体中文、日文、韩文、拉丁字母

**使用方式**:
- 在主题中设为 Default Font（推荐）
- 代码加载: `load("res://res/fonts/ConflictCJKUI.ttf")`

---

## 动画约定

### 缓动函数

统一使用 `Tween.TRANS_CUBIC` 和 `Tween.EASE_OUT` 获得一致的动画手感。

### 常用动画

1. **面板滑入**（设置菜单）:
   - 时长: 0.24s
   - From: `position.y - 15`
   - To: `position.y`
   - Easing: Cubic Out

2. **淡入淡出**（通知卡片）:
   - 时长: 0.2s
   - Modulate alpha: 0 → 1 → 0
   - Easing: Cubic Out

3. **脉冲缩放**（监听状态键帽）:
   - 时长: 0.8s
   - Scale: 0.92 ↔ 1.0
   - Loop: Ping-Pong
   - Easing: Cubic In/Out

---

## 开发指南

### 创建新 UI 组件

1. **确定显示模式**:
   - 固定布局 → 使用场景文件 (`.tscn`)
   - 动态内容 → 代码构建 + 场景框架混合

2. **遵循配色规范**:
   - 复用现有常量（参考 `settings_menu.gd` 顶部）
   - 金色用于强调和主要操作
   - 细边框与充足留白

3. **选择合适的 CanvasLayer**:
   - 参考层级规范表
   - 避免与现有 UI 冲突

4. **字体与主题**:
   - 使用 `ConflictCJKUI.ttf`
   - 可复用 `settings_theme.tres` 或创建专用主题

5. **信号响应**:
   - UI 通过信号接收游戏事件
   - 避免直接调用游戏逻辑（解耦）

### 测试检查清单

- [ ] 在不同分辨率下显示正常（1920×1080, 2560×1440）
- [ ] 鼠标悬停/点击反馈清晰
- [ ] 动画流畅，无卡顿
- [ ] 字体清晰可读，中英文混排正常
- [ ] 与其他 UI 层级无冲突
- [ ] ESC 键行为符合预期
- [ ] 调试/发布构建行为正确

---

## 已知问题与限制

1. **按键图标缺失**: `key_icons/` 目录尚未创建，KeyPromptEntry 当前回退到文本显示
2. **单键绑定**: 设置菜单仅支持单键绑定，不支持组合键（如 Ctrl+R）
3. **无搜索功能**: 键位列表较长时，缺少快速查找功能
4. **纯代码构建**: 部分组件（通知系统）仍完全由代码构建，设计师无法直接修改

---

## 未来扩展计划

1. **多分类设置**:
   - 标签式界面（控制、图形、音频、游戏性）
   - 图形设置: 分辨率、帧率上限、抗锯齿
   - 音频设置: 主音量、分轨音量、音频设备

2. **辅助功能**:
   - 色盲模式
   - 字体大小调整
   - UI 缩放

3. **键位冲突解决**:
   - 自动建议可用按键
   - 一键交换冲突键位

4. **本地化**:
   - 多语言支持（英文、中文、俄语等）
   - 动态切换语言

---

## 参考资源

- [设置界面手动绘制指南](../SETTINGS_UI_GUIDE.md)
- [Godot 主题系统文档](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html)
- [Godot CanvasLayer 文档](https://docs.godotengine.org/en/stable/classes/class_canvaslayer.html)

---

## 维护者

- UI 系统设计与实现: Claude Code
- 配色方案: 基于项目现有 UI 风格统一
- 字体资源: Noto Sans CJK (Google Fonts)
