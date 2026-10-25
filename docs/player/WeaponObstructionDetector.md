# WeaponObstructionDetector

**文件路径：** `classes/weapon/weapon_obstruction_detector.gd`

仅负责物理探测，不直接写武器变换。默认 BasePlayer 在控制器初始化阶段创建并接线。

`initialize(body: Node3D, eye_provider: Callable, muzzle_provider: Callable, radius_provider: Callable)` 注入物理主体、眼部原点、枪口数据和球形半径。muzzle_provider 返回 position、direction，可选 length；缺少依赖/物理世界/武器时返回权重 0，并只记录一次调试消息。

refresh() 每物理帧更新并发出 obstruction_changed(weight)，get_obstruction_weight() 返回最近结果。先 intersect_shape 检查起点重叠，再沿枪口方向 cast_motion 扫掠球体；掩码为 PhysicsLayers.WEAPON_OBSTRUCTION，排除角色及其所有子 CollisionObject3D。返回 1 − 安全移动比例，范围 0–1。

BasePlayer 将探测结果送到 WeaponPresentationController，后者按 WeaponPresentationConfig 平滑收枪并提供阻挡开火阈值。实际枪口随收枪姿态改变；探测器不拥有旧版 MAX_RETRACT/RETRACT_SPEED 常量，也不直接修改 sway_pivot.position.z。

回归见 [Testing](../Testing.md) 的 ads_system_runner 与 player_components_runner。
