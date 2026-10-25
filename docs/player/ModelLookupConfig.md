# ModelLookupConfig

**文件路径：** `classes/player/config/model_lookup_config.gd`

**继承自：** `Resource`

通过 PlayerConfig.model_config 配置模型搜索。skeleton_name / animation_tree_name 是节点名；相机挂点/头骨候选按优先级匹配。AnimationPlayer 按类型搜索，没有 animator_name 字段。

| 字段 | 类型 | 脚本默认值 |
|---|---|---|
| `skeleton_name` | `String` | `"Skeleton3D"` |
| `animation_tree_name` | `String` | `"AnimationTree"` |
| `camera_mount_names` | `Array[String]` | `[ 	"CameraMount", "Camera_Mount", "EyeMount", 	"Camera", "camera", "Camera3D", "Marker3D" ]` |
| `head_bone_names` | `Array[String]` | `[ 	"mixamorig_Head", "mixamorig:Head", "Head", "head", "Eye", "eye" ]` |


旧脚部射线和手臂候选名称字段已经移除。IK 骨骼链使用 IKRigConfig，不从本配置搜索 RayCast3D 或场景 TwoBoneIK3D。

参见 [PlayerModelManager](PlayerModelManager.md) 和 [IKRig](IKRig.md)。
