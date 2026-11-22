# Animation Retargeting Guide

给后续 AI 的重要说明：

## 当前资源

- 项目角色：`assets/models/player/test_model/Swat.fbx`
- 项目角色骨架：Mixamo 命名，根骨骼是 `mixamorig_Hips`，共 69 根骨骼。
- 项目实际使用的旧待机：`assets/animations/player/idle.tres`。
- 项目实际使用的旧向前冲刺：`assets/animations/player/[old]sprint forward.fbx`，由 `swat.tscn` 的 `sprint_fwd` 入口引用。
- 新源动画：桌面 `idle.fbx` 与 `sprint forward.fbx`。
- 新源骨架：`Bip001`，共 65 根骨骼；人物网格为 `SK_Mannequin`，枪械是独立网格。

## 当前状态

项目当前仍使用旧动画。之前生成的 `retargeted_sprint.tres` 以及桌面上的 `idle_Bip001.fbx`、`sprint forward_Bip001.fbx` 只作为源文件或失败测试结果，不能直接接入游戏。

旧动画备份在：

`assets/animations/player/backups/before_bip001_retarget/`

## 禁止的错误操作

1. 不要把 `Bip001` 骨骼名字简单替换为 `mixamorig_*`。
2. 不要直接复制源骨骼的全局旋转、pose quaternion 或局部 quaternion。
3. 不要把 FBX 的绑定姿势当成 Mixamo 的绑定姿势。两套骨架的轴向、父子层级和绑定姿态不同。
4. 不要删除旧动画备份。
5. 不要修改 `classes/player` 代码来解决动画重定向问题。
6. 不要只替换 `assets/animations/player/idle.fbx`；游戏实际待机入口是 `idle.tres`。

## 正确工作流

使用 Blender 的 AnimChar Tools 或等效的骨骼重定向工具：

1. 在 Blender 中导入项目 `Swat.fbx` 作为目标骨架。
2. 导入桌面 `idle.fbx` 或 `sprint forward.fbx` 作为源骨架。
3. 将源 `Bip001` 与目标 `mixamorig_*` 建立明确的骨骼映射，检查 T/A 姿势、骨骼轴向和根骨骼方向。
4. 用插件生成重定向动作并烘焙关键帧；先单独预览双脚、髋部、头部和双手，确认角色没有翻倒、扭曲或漂浮。
5. 导出只包含目标 Mixamo 骨架动作的 FBX，或导入 Godot 后生成 `AnimationLibrary`。
6. 在 Godot 中验证轨道路径必须是 `Skeleton3D:mixamorig_*`，不能出现 `Bip001`。
7. 仅在 idle 和 sprint 都通过预览后替换 `idle.tres` 与 `sprint_fwd` 引用，并保留旧资源备份。

## 推荐映射

| Mixamo 目标 | Bip001 源 |
|---|---|
| `mixamorig_Hips` | `Bip001 Pelvis` |
| `mixamorig_Spine` | `Bip001 Spine` |
| `mixamorig_Spine1` | `Bip001 Spine1` |
| `mixamorig_Spine2` | `Bip001 Spine2` |
| `mixamorig_Neck` | `Bip001 Neck` |
| `mixamorig_Head` | `Bip001 Head` |
| `mixamorig_LeftShoulder` / `RightShoulder` | `Bip001 L/R Clavicle` |
| `mixamorig_LeftArm` / `RightArm` | `Bip001 L/R UpperArm` |
| `mixamorig_LeftForeArm` / `RightForeArm` | `Bip001 L/R Forearm` |
| `mixamorig_LeftHand` / `RightHand` | `Bip001 L/R Hand` |
| `mixamorig_LeftUpLeg` / `RightUpLeg` | `Bip001 L/R Thigh` |
| `mixamorig_LeftLeg` / `RightLeg` | `Bip001 L/R Calf` |
| `mixamorig_LeftFoot` / `RightFoot` | `Bip001 L/R Foot` |
| `mixamorig_LeftToeBase` / `RightToeBase` | `Bip001 L/R Toe0` |

## 工具版本

优先使用 Steam 版 Blender 5.3.0：

`G:\SteamLibrary\steamapps\common\Blender\blender.exe`

只有 AnimChar Tools 明确不兼容 5.3 时，才使用 Blender 3.6：

`C:\Program Files\Blender Foundation\Blender 3.6\blender.exe`

当前没有检测到 AnimChar Tools。拿到插件 `.zip` 后先确认插件版本和支持的 Blender 版本，再执行重定向。
