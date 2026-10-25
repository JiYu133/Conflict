# 通用力反馈系统

**文件路径：** `classes/player/force/`

ForceTypes 定义载荷与衰减曲线，ForcePropagation 缓存骨骼链传播权重，ForceReceiver 接受受击/后坐力并求解偏移，ForceBodyModifier 将结果叠加到本帧上游动画姿态。

## 受力入口

`apply_force(direction: Vector3, magnitude: float, hit_bone: String = "", duration: float = 0.0, decay_curve: String = "exponential", origin: Vector3 = Vector3.ZERO, space: ForceTypes.Space = ForceTypes.Space.WORLD, mass_kg: float = 0.0, speed_mps: float = 0.0, impulse_ns: float = -1.0, angular_impulse: Vector3 = Vector3.ZERO) -> ForceTypes.ForcePayload`

前五个参数为稳定位置参数。duration<=0 使用配置默认值；输入不合法、骨骼缺失或无有效强度/角冲量时返回 null，骨骼问题会记警告。成功返回接受的载荷；载荷由对象池复用，不能长期持有或修改。

Space.LOCAL 的方向/点源先按玩家变换转为世界空间。非零有限 origin 表示点源，传播到各骨骼时计算径向方向。零点目前作为“无点源”的哨兵。

`apply_impact(info: DamageInfo) -> void` 从命中动能和有效质量推导 p=sqrt(2*m*E)*transfer_ratio，再按 pose_reference_impulse 换为姿态强度，并缓存一次性布娃娃冲量。缺少弹头质量的 BULLET/FRAGMENT 不制造假定冲量。默认资源可覆盖 ForceConfig 的脚本传递比例。

## 传播与坐标

骨骼树按父/子双向 BFS 传播，权重为 decay_per_level^depth，超过 max_propagation_depth 截断。普通受力随曲线衰减、逐骨骼求和；rotation_gain、translation_gain、pose_cap 与 max_translation_m 限制表现。骨骼链方向取 rest 并缓存。

执行顺序：SpineAim → ForceBodyModifier → IKLegs → IKArms。修饰器读取当前帧姿态，不缓存/写回上一帧动画。世界位移通过包含 Skeleton3D 变换的当前父骨骼 basis 反变换；世界旋转通过父世界朝向转换，不再次叠加 rest basis。

overload_threshold 对受力最重骨骼的累计强度做边沿判定并发 overload_triggered。overload_jitter 仍导出但当前没有抖动消费路径。

## 武器后坐力

`apply_recoil_impulse(linear_impulse: Vector3, angular_impulse: Vector3, hit_bone: String, duration: float = 0.12) -> void`

BasePlayer.apply_weapon_recoil() 委托 PlayerWeaponFeedback，将同一发武器局部冲量转为世界空间，按有效肩部、主手和辅手接触刚度分配。角冲量累加到骨骼的持续 angle/velocity 状态，使用解析临界阻尼回正；武器惯量、刚度/阻尼和 decay_floor 决定持续时间。松扳机或单个载荷回收不会硬切该状态。

max_active_forces 满时会接纳新载荷并淘汰最旧项，数组长度不增长不代表拒绝。后坐力通过接受载荷的身份继续累加，不依赖数组长度变化。物理后坐不使用普通受击的经验性平移/旋转增益，不改变玩家根速度。

相机独立订阅 RecoilComponent.physical_recoil_applied，不通过 ForceBodyModifier 写镜头。

## 清理、查询与信号

| 方法或信号 | 行为 |
|---|---|
| `set_skeleton(skeleton)` | 重新绑定骨架/传播缓存 |
| `consume_pending_impulse()` | 取走 direction / impulse_ns / hit_bone，第二次为空 |
| `clear_pending_impulse()` | 只清待用布娃娃冲量 |
| `clear_forces()` | 清生效载荷、后坐状态和姿态偏移，不影响待用冲量 |
| `clear_recoil_state()` | 只清后坐状态及后坐载荷，保留普通受击载荷 |
| `get_pose_offsets()` / `get_pose_snapshot()` | 骨骼偏移或完整调试快照 |
| `get_total_magnitude()` / `get_active_force_count()` | 峰值累计强度与活动载荷数 |
| `force_applied(payload)` / `overload_triggered(total)` | 接纳与过载边沿通知 |

布娃娃通过 set_force_provider() 接入，命中有能量时优先消费待用冲量；缺失时回退 energy→impulse 路径。复活和 prepare_for_encounter_spawn() 清理力与待用冲量。测试为 force_system_runner / force_integration_runner，见 [Testing](../Testing.md)。
