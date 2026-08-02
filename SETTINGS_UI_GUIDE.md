# 设置界面手动绘制指南 (Godot 4.7)

> 已归档：当前设置系统由 PauseMenu、SettingsMenu 与 BasePlayer 持有的 SettingsService 以代码构建，玩家可见文本集中在 `classes/ui/settings/settings_text.gd`。本指南保留作早期 Theme/布局参考，不应再用于创建 `settings_menu.tscn`。

> 这份指南将带你在 Godot 编辑器中从零开始创建设置界面的场景文件。
> 预计耗时：30-45 分钟

---

## 开始之前

### 你需要知道的

- **什么是场景（Scene）**：Godot 中的 UI 布局文件，可以在编辑器中可视化编辑
- **什么是节点（Node）**：场景中的基本单元，如按钮、标签、容器等
- **什么是 Inspector**：右侧面板，用来设置节点的属性

### 编辑器布局确认

打开 Godot 项目后，确认你能看到：
- **左侧**: FileSystem 面板（文件浏览器）
- **中间上方**: Scene 面板（节点树）
- **中间下方**: 2D 视口（预览区域）
- **右侧**: Inspector 面板（属性编辑器）

如果布局不对，点击顶部菜单 **Editor → Editor Settings → Interface → Editor Layout** 选择 Default。

---

## 第一部分：创建主题资源（15 分钟）

主题定义了按钮、标签等控件的外观。我们先创建一个共享主题。

### 步骤 1：创建 themes 文件夹

1. 在 **FileSystem** 面板（左下角）中找到 `res://`
2. **右键点击** `res://` → 选择 **Create Folder**
3. 输入文件夹名 `themes`，按回车确认

### 步骤 2：新建主题文件

1. **右键点击** 刚创建的 `themes` 文件夹
2. 选择 **Create New** → **Resource...**
3. 在弹出的窗口中，**搜索框输入** `theme`
4. 选择 **Theme**（不是 ThemeDB），点击 **Create**
5. 文件名输入 `settings_theme.tres`，点击 **Save**

### 步骤 3：打开主题编辑器

1. 在 FileSystem 中 **双击** `themes/settings_theme.tres`
2. Inspector 面板会显示 Theme 的属性

### 步骤 4：设置默认字体

1. 在 Inspector 中找到 **Default Font** 字段（顶部附近）
2. 点击 **[empty]** 右侧的下拉箭头
3. 选择 **Quick Load**
4. 输入 `ConflictCJKUI` 搜索
5. 选择 `res://res/fonts/ConflictCJKUI.ttf`，点击 **Open**
6. 在 **Default Font Size** 字段输入 `15`

### 步骤 5：配置 Button 样式

现在开始配置按钮的外观。

#### 5.1 添加 Button 类型

1. 在 Inspector 底部找到 **Add Type** 按钮（大大的 + 号）
2. 点击后输入 `Button`，按回车

#### 5.2 创建 Normal 状态样式

1. 展开 **Button** → **Styles** → 点击 **normal** 右侧的下拉箭头
2. 选择 **New StyleBoxFlat**
3. 点击新创建的 **StyleBoxFlat** 图标，Inspector 会显示其属性

#### 5.3 配置 Normal 样式属性

**背景颜色**:
1. 找到 **Bg Color** 字段
2. 点击颜色方块，在弹出的颜色选择器中：
   - **R**: `41` (0.16 × 255)
   - **G**: `43` (0.17 × 255)
   - **B**: `51` (0.20 × 255)
   - **A**: `255` (1.0 × 255)
   - 或者切换到右上角的 **#** 模式，输入 `#292B33FF`

**边框**:
1. 展开 **Border** 部分
2. 点击 **Border Width All** 右侧的数字 `0`
3. 输入 `1`
4. 展开 **Border Color**，设置颜色：
   - 十六进制模式输入 `#FFFFFF12` (白色，透明度 7%)
   - 或者 RGBA: R=255, G=255, B=255, A=18

**圆角**:
1. 展开 **Corner Radius** 部分
2. 找到 **Corner Radius All** 字段
3. 输入 `6`

**内容边距**:
1. 展开 **Content Margin** 部分
2. 设置以下值：
   - **Left**: `12`
   - **Right**: `12`
   - **Top**: `8`
   - **Bottom**: `8`

#### 5.4 创建 Hover 状态样式

1. 在 Button → Styles 中，**右键点击** **normal** 那一行的 StyleBoxFlat 图标
2. 选择 **Duplicate**
3. 将复制的 StyleBox 拖动到 **hover** 槽位（或点击 hover 下拉选择刚复制的）
4. 点击 hover 的 StyleBoxFlat 图标
5. 修改 **Bg Color** 为 `#383B45FF` (稍亮一些)

#### 5.5 创建 Pressed 状态样式

1. **右键点击** hover 的 StyleBoxFlat
2. 选择 **Copy**
3. 点击 **pressed** 右侧的下拉箭头
4. 选择 **Paste**

#### 5.6 设置字体颜色

1. 展开 **Button** → **Colors** → 点击 **font_color** 右侧的下拉
2. 选择 **New Color**
3. 设置颜色为 `#EBECF2FF` (浅灰白色)

### 步骤 6：创建 AccentButton 变体（金色按钮）

#### 6.1 添加变体

1. 在 Inspector 底部，再次点击 **Add Type**
2. 输入 `Button`，但**不要按回车**
3. 注意到输入框右侧有一个小图标，**点击它**
4. 在弹出的 **Theme Type Variation** 对话框中输入 `AccentButton`
5. 点击 **OK**

#### 6.2 配置 AccentButton Normal 样式

1. 展开 **AccentButton** → **Styles** → **normal**
2. 创建 **New StyleBoxFlat**
3. 配置：
   - **Bg Color**: `#D9B833FF` (金色)
   - **Border Width All**: `0` (无边框)
   - **Corner Radius All**: `6`
   - **Content Margin**: Left/Right `12`, Top/Bottom `8`

#### 6.3 配置 Hover 样式

1. 复制 normal 的 StyleBox 到 hover
2. 修改 **Bg Color** 为 `#F2D14DFF` (亮金色)

#### 6.4 设置字体颜色

1. **AccentButton** → **Colors** → **font_color**
2. 设置为 `#1A1A1AFF` (深色文字，在金色背景上清晰)

### 步骤 7：创建 GhostButton 变体（幽灵按钮）

#### 7.1 添加变体

1. 同样点击 **Add Type**，输入 `Button`
2. 点击右侧小图标，输入变体名 `GhostButton`

#### 7.2 配置样式

**Normal**:
- **Bg Color**: `#00000000` (完全透明)
- **Border Width All**: `1`
- **Border Color**: `#D9B87F` (金色半透明)
- **Corner Radius All**: `6`
- **Content Margin**: 同上

**Hover**:
- 复制 normal，修改 **Bg Color** 为 `#D9B82929` (淡金色背景)

**Font Color**:
- 设置为 `#D9B833FF` (金色文字)

### 步骤 8：配置 Label 样式

#### 8.1 添加默认 Label

1. **Add Type** → 输入 `Label`
2. **Colors** → **font_color** → `#EBECF2FF` (同 Button)

#### 8.2 创建 TitleLabel 变体

1. **Add Type** → `Label` → 变体名 `TitleLabel`
2. **Font Sizes** → **font_size** → `22`

#### 8.3 创建 SubtitleLabel 变体

1. 变体名 `SubtitleLabel`
2. **font_size** → `13`
3. **font_color** → `#8C949FFF` (中灰色)

#### 8.4 创建 MutedLabel 变体

1. 变体名 `MutedLabel`
2. **font_size** → `14`
3. **font_color** → `#8C949FFF`

### 步骤 9：保存主题

按 **Ctrl+S** 保存。主题资源完成！

---

## 第二部分：创建场景文件（20 分钟）

现在开始构建设置界面的场景结构。

### 步骤 1：新建场景

1. 点击顶部菜单 **Scene** → **New Scene**
2. 在弹出的 **Create Root Node** 对话框中，点击 **Other Node**
3. 搜索框输入 `CanvasLayer`
4. 选择后点击 **Create**

### 步骤 2：命名根节点

1. 在 Scene 面板中，根节点默认叫 `CanvasLayer`
2. **右键点击** → **Rename** (或按 F2)
3. 改名为 `SettingsMenu`

### 步骤 3：设置 CanvasLayer 属性

1. 确保 `SettingsMenu` 节点被选中
2. 在 Inspector 中找到 **Layer** 字段
3. 输入 `20`

### 步骤 4：附加脚本

1. 点击 Inspector 顶部的 **Attach Script** 图标（📜 卷轴图标）
2. 在弹出的对话框中，**不要** 点击 Create
3. 点击右侧的 **Load** 按钮（文件夹图标）
4. 导航到 `classes/ui/settings/settings_menu.gd`
5. 点击 **Open**，然后点击 **OK**

### 步骤 5：创建 Backdrop（背景遮罩）

1. **右键点击** `SettingsMenu` 节点
2. 选择 **Add Child Node** (或按 Ctrl+A)
3. 搜索 `ColorRect`，选择后回车
4. 将新节点重命名为 `Backdrop`

#### 配置 Backdrop 属性

**布局**:
1. 选中 Backdrop 节点
2. 在 Inspector 顶部找到 **Layout** 下拉菜单（或工具栏）
3. 点击 **Anchors Preset**，选择最后一个 **Full Rect** (铺满整个屏幕)

**颜色**:
1. Inspector 中找到 **Color** 字段
2. 设置为 `#000000B8` (黑色，透明度 72%)

**鼠标过滤**:
1. 展开 **Mouse** 部分
2. 将 **Filter** 设置为 **Stop** (阻止点击穿透)

### 步骤 6：创建中心容器

1. **右键点击** `SettingsMenu`（不是 Backdrop）
2. **Add Child Node** → 搜索 `CenterContainer`
3. 回车创建，名字保持 `CenterContainer`

#### 配置 CenterContainer

1. **Layout** → **Anchors Preset** → **Full Rect**

### 步骤 7：创建主面板

1. **右键点击** `CenterContainer`
2. **Add Child Node** → `PanelContainer`

#### 配置 PanelContainer

**主题**:
1. Inspector → **Theme** → **Theme** 字段
2. 点击 **[empty]** 右侧的下拉
3. 选择 **Quick Load**
4. 输入 `settings_theme` 搜索，选择 `themes/settings_theme.tres`

**最小尺寸**:
1. 展开 **Control** 部分
2. 找到 **Custom Minimum Size** 
3. X 设为 `600`, Y 设为 `0`

**面板样式**:
1. 展开 **Theme Overrides** → **Styles**
2. 点击 **panel** 右侧的下拉 → **New StyleBoxFlat**
3. 点击新创建的 StyleBoxFlat 图标
4. 配置：
   - **Bg Color**: `#161921FA` (深蓝灰)
   - **Border Width All**: `1`
   - **Border Color**: `#FFFFFF12` (微妙白边)
   - **Corner Radius All**: `12`

### 步骤 8：创建内边距容器

1. **右键点击** `PanelContainer`
2. **Add Child Node** → `MarginContainer`

#### 配置 MarginContainer

1. 展开 **Theme Overrides** → **Constants**
2. 设置所有边距为 `26`:
   - **margin_left**: `26`
   - **margin_right**: `26`
   - **margin_top**: `26`
   - **margin_bottom**: `26`

### 步骤 9：创建根垂直布局

1. **右键点击** `MarginContainer`
2. **Add Child Node** → `VBoxContainer`

#### 配置 VBoxContainer

1. **Theme Overrides** → **Constants** → **separation**: `14`

### 步骤 10：构建 Header（标题区）

现在开始构建界面内容。

#### 10.1 创建 Header 容器

1. **右键点击** `VBoxContainer`
2. **Add Child Node** → `HBoxContainer`
3. 重命名为 `Header`

#### 10.2 创建标题盒子

1. **右键点击** `Header`
2. **Add Child Node** → `VBoxContainer`
3. 重命名为 `TitleBox`

**配置 TitleBox**:
1. **Control** → **Size Flags** → **Horizontal** → 勾选 **Expand** 和 **Fill**
2. **Theme Overrides** → **Constants** → **separation**: `2`

#### 10.3 创建标题标签

1. **右键点击** `TitleBox`
2. **Add Child Node** → `Label`
3. 重命名为 `TitleLabel`

**配置 TitleLabel**:
1. **Text** 字段输入：`设置`
2. **Theme** → **Theme Type Variation** 输入 `TitleLabel`

#### 10.4 创建副标题标签

1. 同样在 `TitleBox` 下创建 `Label`
2. 重命名为 `SubtitleLabel`
3. **Text**: `控制 CONTROLS`
4. **Theme Type Variation**: `SubtitleLabel`

### 步骤 11：创建分隔线

1. **右键点击** `VBoxContainer`（根布局）
2. **Add Child Node** → `HSeparator`
3. 重命名为 `HSeparator1`

**配置分隔线样式**:
1. **Theme Overrides** → **Styles** → **separator** → **New StyleBoxFlat**
2. 配置：
   - **Bg Color**: `#FFFFFF12`
   - **Content Margin Top**: `10`
   - **Content Margin Bottom**: `10`
   - **Expand Margin Top**: `1` (这是分隔线的实际高度)

### 步骤 12：创建滚动区域

1. **右键点击** `VBoxContainer`
2. **Add Child Node** → `ScrollContainer`

**配置 ScrollContainer**:
1. **Control** → **Custom Minimum Size** → Y: `400`
2. **Scroll** → **Horizontal Scroll Mode**: `Disabled`

### 步骤 13：创建键位行容器（重要！）

1. **右键点击** `ScrollContainer`
2. **Add Child Node** → `VBoxContainer`
3. **必须重命名为** `RowsContainer` (代码会引用这个名字)

**配置 RowsContainer**:
1. **Theme Overrides** → **Constants** → **separation**: `2`

### 步骤 14：创建警告标签

1. **右键点击** `VBoxContainer`（根布局）
2. **Add Child Node** → `Label`
3. **必须重命名为** `WarningLabel`

**配置 WarningLabel**:
1. **Visibility** → 取消勾选 **Visible** (默认隐藏)
2. **Theme Type Variation**: `MutedLabel`
3. **Text** → **Horizontal Alignment**: `Center`
4. **Text** → **Autowrap Mode**: `Word`

### 步骤 15：创建第二条分隔线

1. 同步骤 11，在 `VBoxContainer` 下创建 `HSeparator`
2. 重命名为 `HSeparator2`
3. 应用相同的样式配置

### 步骤 16：创建 Footer（底部按钮区）

1. **右键点击** `VBoxContainer`
2. **Add Child Node** → `HBoxContainer`
3. 重命名为 `Footer`

#### 16.1 创建重置按钮

1. **右键点击** `Footer`
2. **Add Child Node** → `Button`
3. **必须重命名为** `ResetAllButton`

**配置**:
1. **Text**: `恢复全部默认`
2. **Theme Type Variation**: `GhostButton`

#### 16.2 创建间隔控件

1. **右键点击** `Footer`
2. **Add Child Node** → `Control`
3. 重命名为 `Spacer`

**配置**:
1. **Size Flags** → **Horizontal** → 勾选 **Expand** 和 **Fill**

#### 16.3 创建完成按钮

1. **右键点击** `Footer`
2. **Add Child Node** → `Button`
3. **必须重命名为** `DoneButton`

**配置**:
1. **Text**: `完成 DONE`
2. **Theme Type Variation**: `AccentButton`

---

## 第三部分：保存与预览（5 分钟）

### 步骤 1：保存场景

1. 按 **Ctrl+S**
2. 在弹出的保存对话框中：
   - 导航到 `res://` 根目录
   - 如果没有 `ui` 文件夹，点击右上角的 **创建文件夹** 图标
   - 进入 `ui` 文件夹
3. 文件名输入 `settings_menu.tscn`
4. 点击 **Save**

### 步骤 2：预览场景

1. 点击编辑器右上角的 **Run Current Scene** 按钮（▶️ 图标）
2. 或按 **F6** 键

**你应该看到**:
- 居中的深色面板
- 顶部标题 "设置" 和副标题 "控制 CONTROLS"
- 中间空白区域（键位行将由代码生成）
- 底部两个按钮："恢复全部默认"（金色边框）和 "完成 DONE"（金色实心）

按 **ESC** 或点击 **Stop** 关闭预览。

---

## 最终检查清单

在继续代码适配之前，确认以下项目：

**主题资源** (`themes/settings_theme.tres`):
- [ ] 默认字体设为 ConflictCJKUI.ttf
- [ ] Button 默认样式完整（Normal/Hover/Pressed）
- [ ] AccentButton 变体存在且配置正确
- [ ] GhostButton 变体存在且配置正确
- [ ] Label 的 3 个变体都已创建

**场景文件** (`ui/settings_menu.tscn`):
- [ ] 根节点是 CanvasLayer，名为 SettingsMenu
- [ ] Layer 设为 20
- [ ] 附加了 settings_menu.gd 脚本
- [ ] Backdrop 的 Mouse Filter 是 Stop
- [ ] PanelContainer 加载了 settings_theme.tres
- [ ] **RowsContainer** 节点名称正确（区分大小写）
- [ ] **WarningLabel** 节点名称正确
- [ ] **ResetAllButton** 节点名称正确
- [ ] **DoneButton** 节点名称正确

**场景预览**:
- [ ] 面板居中显示
- [ ] 背景是半透明黑色遮罩
- [ ] 标题和副标题字体大小不同
- [ ] "完成" 按钮是金色实心
- [ ] "恢复全部默认" 按钮是金色边框

---

## 下一步

场景绘制完成！现在需要修改代码以适配这个新界面。

告诉我你已完成，我会为你修改 `classes/ui/settings/settings_menu.gd` 文件，让它从场景加载节点而不是用代码构建。

---

## 常见问题

**Q: 找不到 Theme Type Variation 选项？**  
A: 确保你先选中了节点，并且该节点的类型支持变体（Button、Label 等）。变体输入框在 Inspector 的 Theme 部分顶部。

**Q: 颜色输入太麻烦？**  
A: 点击颜色选择器右上角的 **#** 图标切换到十六进制模式，直接复制粘贴 `#D9B833FF` 这样的值。

**Q: 节点名称重要吗？**  
A: 是的！`RowsContainer`、`WarningLabel`、`ResetAllButton`、`DoneButton` 这四个名称必须准确，代码会用 `$` 路径引用它们。

**Q: 预览时面板太大或太小？**  
A: 调整 PanelContainer 的 **Custom Minimum Size** (步骤 7)，或者修改 MarginContainer 的边距 (步骤 8)。

**Q: 按钮点击没反应？**  
A: 这是正常的！按钮的功能由代码控制，场景只定义外观。在代码适配完成后就会有响应。

**Q: 如何撤销操作？**  
A: **Ctrl+Z** 撤销，**Ctrl+Shift+Z** 重做。

**Q: 场景树节点顺序重要吗？**  
A: 从上到下的渲染顺序会受影响，但功能不会。建议按指南顺序创建。
