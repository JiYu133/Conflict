# SpineAimController

**文件路径：** `classes/player/controller/spine_aim_controller.gd`

setup(skeleton, player, camera_controller, config = null) 创建 SpineAimModifier。process_aim(delta, enabled = true) 消费基础俯仰、身体 yaw 偏差和自由观察偏移，按 SpineAimConfig 的骨骼权重、角度限制及指数响应叠加到当前动画。

普通视角使用 bone_names/bone_weights；自由观察使用 free_look_bone_names/free_look_bone_weights。头部额外目标来自实际枪口位置加方向 × 1000 m；没有有效武器或枪口时不启用该目标。它不是从已移除的 get_aim_direction()/get_view_direction() 读取视角。

SpineAimModifier 首次采样头骨到视角的轴向关系，用于导入模型轴向对齐。这与旧 HandIKConfig 所描述、后来删除的自动左手腕校准开关无关；当前左手目标直接编辑 LeftHandWristTarget，见 [IKRig](IKRig.md)。右手握点有 IKRig 自身的运行时相对腕骨采样。

禁用时清空当前 pitch/yaw/free offsets 与头部目标。排序由 IKRig 维护：姿态叠加（SpineAim、Force）→ IKLegs → IKArms → 物理骨骼。验证见 [Testing](../Testing.md)。
