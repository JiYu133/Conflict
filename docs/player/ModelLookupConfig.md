# ModelLookupConfig

**文件路径：** `Classes/Player/model_lookup_config.gd`
**继承自：** `Resource`

## 功能概述

定义如何从导入的 3D 模型场景（.glb / .tscn）中自动定位关键节点的规则配置资源。每个字段是一个候选名称数组，按优先级排列，遍历找到第一个匹配项即停止。通过 `PlayerConfig.model_config` 引用，由 `PlayerModelManager` 在 `load_model()` 时读取执行查找。

## 配置参数（@export var）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `skeleton_name` | `String` | `"Skeleton3D"` | 骨骼系统节点名称，通常是 Godot 导入 .glb 时自动生成的名称 |
| `animator_name` | `String` | `"AnimationPlayer"` | 动画播放器节点名称 |
| `camera_mount_names` | `Array[String]` | `["CameraMount", "Camera_Mount", "EyeMount", "Camera", "camera", "Camera3D", "Marker3D"]` | 第一人称摄像机挂载点候选名称列表，按优先级排列 |
| `left_foot_ray_names` | `Array[String]` | `["RayCast_LeftFoot", "LeftFootRay", "LeftRay", "leftray"]` | 左脚 RayCast 节点候选名称，用于脚步 IK 地面适配 |
| `right_foot_ray_names` | `Array[String]` | `["RayCast_RightFoot", "RightFootRay", "RightRay", "rightray"]` | 右脚 RayCast 节点候选名称，用于脚步 IK 地面适配 |
| `head_bone_names` | `Array[String]` | `["Head", "head", "Eye", "eye", "mixamorig_Head"]` | 头部骨骼候选名称，当模型没有 CameraMount 时作为回退方案自动创建摄像机挂载点 |

## 依赖关系

- **依赖：** 无（纯数据资源）
- **被依赖：** `PlayerConfig`（通过 `model_config` 字段引用）、`PlayerModelManager`（执行节点查找）、`PlayerCameraController`、`FootIKController`

## 注意事项

- 候选名称数组按优先级从前到后匹配，模型制作者只需确保节点名称在对应列表中即可被自动识别，无需严格遵循单一命名规范。
- 若模型中不存在任何 `camera_mount_names` 中的节点，系统会回退到 `head_bone_names` 在骨骼上自动创建挂载点。
- `skeleton_name` 和 `animator_name` 为单一字符串而非数组，若模型使用非默认名称需手动修改资源。
