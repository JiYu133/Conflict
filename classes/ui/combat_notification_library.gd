class_name CombatNotificationLibrary
extends Resource

# ============================================================
# 战斗通知条目库
# 存储所有固定战斗提示的 TopRightNotificationEntry 配置。
# 在编辑器中编辑 .tres 文件即可调整文字、颜色、显示时长。
#
# 动态通知（出血、骨折）因需要拼接部位名，
# 只存储颜色和时长，文字由代码生成。
# ============================================================

# ── 固定通知条目 ─────────────────────────────────────────────

@export_group("状态通知")
## 玩家进入危重状态（大量失血）
@export var critical: TopRightNotificationEntry
## 玩家失去意识（昏迷）
@export var unconscious: TopRightNotificationEntry
## 玩家阵亡
@export var dead: TopRightNotificationEntry

# ── 动态通知样式（颜色 + 时长，文字由代码拼接）────────────────

@export_group("出血通知样式")
## 动脉出血文字模板，{part} 会被替换为部位名
@export var arterial_text: String = "⚠ 动脉出血！立即止血！  {part}"
## 动脉出血 accent 颜色
@export var arterial_color: Color = Color(1.0, 0.22, 0.22)
## 动脉出血显示时长（秒）
@export var arterial_duration: float = 8.0
## 静脉出血文字模板，{part} 会被替换为部位名
@export var venous_text: String = "静脉出血  {part}"
## 静脉出血 accent 颜色
@export var venous_color: Color = Color(0.85, 0.45, 0.25)
## 静脉出血显示时长（秒）
@export var venous_duration: float = 5.0
## 毛细/渗血文字模板，{part} 会被替换为部位名
@export var capillary_text: String = "渗血  {part}"
## 毛细/渗血 accent 颜色
@export var capillary_color: Color = Color(0.72, 0.72, 0.60)
## 毛细/渗血显示时长（秒）
@export var capillary_duration: float = 3.5

@export_group("骨折通知样式")
## 骨折文字模板，{part} 会被替换为部位名
@export var fracture_text: String = "骨折：{part}"
## 骨折 accent 颜色
@export var fracture_color: Color = Color(0.95, 0.62, 0.20)
## 骨折显示时长（秒）
@export var fracture_duration: float = 6.0
