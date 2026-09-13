# RecoilComponent

Path: `classes/weapon/recoil_component.gd`

`RecoilComponent` consumes the physical recoil model for presentation. It never changes projectile input. `BaseWeapon` spawns from the runtime `Muzzle.global_position` along `-Muzzle.global_basis.z`, then applies recoil only after a successful spawn.

## Physical model

`RecoilPhysicsModel` derives each shot from bullet momentum, propellant-gas momentum, weapon and attachment mass, center of mass, bore-to-shoulder lever arm, and grip/stock support stiffness. The result includes:

- Linear impulse and velocity in weapon local space. Positive local Z is rearward compression into the shoulder.
- Angular impulse around local X/Y/Z for pitch, yaw, and roll. Yaw and roll are zero for a symmetric bore and become non-zero when bore, gas jet, or support points are asymmetric.
- Receiver and bolt-carrier mass. Bolt mass contributes a small mechanical counter-impulse; detailed bolt travel remains owned by `BoltComponent`.

The model uses a seeded random generator per weapon name for charge variation and shooter impulse noise. Rebuilding after attachment changes resets all derived mass, inertia, gas, torque, and mechanical impulse values.

## Pose integration

`apply_recoil(control_multiplier)` adds angular and linear shot velocities to damped springs. `get_pose_rotation()` returns local pitch/yaw/roll and `get_pose_translation()` returns three-axis local displacement. Grip and stock support constrain lateral and vertical motion more strongly than rearward compression.

Configuration fields on `WeaponConfig`:

```gdscript
recoil_pose_translation_scale
recoil_pose_rotation_scale
recoil_pose_linear_stiffness
recoil_pose_linear_damping
recoil_pose_max_translation_m
recoil_pose_max_pitch_rad
recoil_pose_max_yaw_rad
recoil_pose_max_roll_rad
```

`WeaponRecoilPoseController` applies this delta around `WeaponConfig.recoil_pivot_local` (or an authored `RecoilPivot`) without reparenting the weapon, grip markers, or attachment hierarchy. `WeaponManager` right-hand alignment and left-hand IK therefore remain independent from recoil presentation.

The camera receives only a small pitch/yaw/roll feedback value through `PlayerCameraController`; camera feedback does not determine muzzle transform or projectile trajectory.

## Public API

```gdscript
initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void
rebuild_physics() -> void
apply_recoil(control_multiplier: float = 1.0) -> void
reset() -> void
get_physics_snapshot() -> Dictionary
get_pose_rotation() -> Basis
get_pose_translation() -> Vector3
get_pose_snapshot() -> Dictionary
```

`get_physics_snapshot()` is intended for debug tools and customization UI. `get_pose_snapshot()` exposes `pitch_rad`, `yaw_rad`, `roll_rad`, `angular_velocity`, `position_local`, and `velocity_local`.
