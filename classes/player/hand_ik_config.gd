class_name HandIKConfig
extends Resource

# ============================================================
# 左手 IK 配置资源（TwoBoneIK3D 版本）
#
# 用法：
#   1. 在编辑器中右键 → New Resource → 选择 HandIKConfig
#   2. 将资源赋值给 PlayerConfig.hand_ik_config
#   3. 在 swat.tscn 的 Skeleton3D 下添加 TwoBoneIK3D，命名 LeftHandIK，
#      Root/Middle/Tip Bone 与下方骨骼名保持一致
# ============================================================


# ── 骨骼名称 ─────────────────────────────────────────────────
@export_group("骨骼名称")

## IK 链起点骨骼（肩膀），需与编辑器里 TwoBoneIK3D.Root Bone 一致
@export var root_bone_name: String = "mixamorig_LeftShoulder"

## IK 链终点骨骼（手腕），需与编辑器里 TwoBoneIK3D.Tip Bone 一致
@export var tip_bone_name: String = "mixamorig_LeftHand"

## 编辑器里 TwoBoneIK3D 节点的名称（Skeleton3D 的直接子节点）
@export var ik_node_name: String = "LeftHandIK"


# ── 混合强度 ─────────────────────────────────────────────────
@export_group("混合强度")

## 全局 IK 混合强度（0~1）
## 单把武器可在 WeaponConfig.left_hand_ik_weight 中覆盖此值
@export_range(0.0, 1.0) var default_ik_weight: float = 1.0


# ── 运动状态权重 ─────────────────────────────────────────────
@export_group("运动状态权重")

## 站立/行走时的 IK 权重上限
@export_range(0.0, 1.0) var walk_ik_weight: float = 1.0

## 奔跑（Run）时的 IK 权重
@export_range(0.0, 1.0) var run_ik_weight: float = 0.6

## 冲刺（Sprint）时的 IK 权重
@export_range(0.0, 1.0) var sprint_ik_weight: float = 0.1

## ADS 时的 IK 权重
@export_range(0.0, 1.0) var ads_ik_weight: float = 0.8

## 状态切换时权重平滑过渡时间（秒）
@export_range(0.0, 0.5) var weight_blend_time: float = 0.12


# ── 手腕朝向 ─────────────────────────────────────────────────
@export_group("手腕朝向")

## 手腕朝向模式：
## false =（默认，美术主导）直接使用握把 Marker 的朝向。手腕怎么握由美术在
##         handguard / 武器场景里摆 LeftHandGrip 决定，改 Marker 即时生效，
##         这是设计上的正确控制面。
## true  = 自动标定（应急）。装备武器/更换配件时记录「动画手腕朝向 相对于 握把朝向」
##         的差值并每帧还原，手腕保持动画姿态。可临时救场，但会【完全忽略】
##         美术对 Marker 朝向的调整——调 Marker 没反应时先检查这里是不是开着。
@export var auto_calibrate_wrist: bool = false

## 在上述基础上再叠加的手腕修正角（欧拉角，度）。自动标定后若仍需微调，改这里。
@export var wrist_rotation_offset: Vector3 = Vector3.ZERO
