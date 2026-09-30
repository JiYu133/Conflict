# ADS Rework Handoff

Status recorded on 2026-09-30 for branch `feat/gamelogic-local-sync`.

Before opening a fresh clone, run `git lfs install` and `git lfs pull`; UI audio such as `assets/audio/menu.wav` is stored through Git LFS.

## Runnable baseline

- ADS input, eased transition timing, independent `WeaponPoseRoot`, two-hand IK, and the two magnified-optic rendering modes are present.
- Projectiles originate from the live `Muzzle` transform. ADS does not select a different mechanical accuracy value.
- `pixel_zoom` avoids an additional scene render; `dual_camera` uses the optic `SubViewport`. The player choice only applies above 1x magnification.
- The currently connected weapon pose still aligns `ADSAnchor` rigidly to the active camera. This is intentionally left as the runnable baseline until the presentation controller rework is integrated end to end.

## Work in progress

`WeaponPresentationConfig` and `WeaponPresentationController` are initial, parseable building blocks for the Tarkov-style presentation pass. They are not yet connected to `BasePlayer`, `HandIKController`, obstruction detection, or optic rendering.

Do not remove the existing camera-controller pose path until all consumers have moved to the new controller and the ADS/IK regression scenes pass.

## Required implementation order

1. Add a model-authored `EyeAnchor` under the head `BoneAttachment3D`. Make camera position use it, with a zero-horizontal-offset fallback. Keep look input authoritative for camera rotation.
2. Instantiate `WeaponPresentationController` in `BasePlayer`, create `WeaponPoseRoot/WeaponSwayPivot` through it, bind equipped weapons, and point the weapon manager and ragdoll system at the new rig.
3. Remove the rigid per-frame `PlayerCameraController.refresh_weapon_pose()` update only after compatibility getters delegate to the presentation controller.
4. Change `HandIKController` to sample the final presentation pose every frame. Keep both hands on `TwoBoneIK3D`; do not directly rotate hand bones.
5. Replace the unused ray obstruction code with a swept sphere from the eye/weapon origin toward the live muzzle. Exclude every player-owned collision RID, feed a continuous obstruction weight to the pose controller, and block firing before ammunition consumption.
6. Hide the local head/body from the first-person camera using the existing local visual layer while retaining shadows. Set a small configurable camera near plane to reduce weapon clipping.
7. Add magnified-optic eye-box parameters (lateral tolerance, eye relief, angular tolerance, softness). Apply the same scope-shadow model to both pixel and dual-camera modes. In pixel mode, sample around the projected optic axis instead of fixed screen center.
8. Update `ads_system_runner.gd`: full ADS must remain close to the sight line but must not assert exact camera/anchor equality. Add bounded-motion, eye-anchor, obstruction/fire-gate, scope-shadow, and 1x-unaffected checks.

## Acceptance criteria

- Camera and sight are not rigidly locked; the weapon has bounded inertia and breathing at hip and ADS.
- The authored sight anchor remains the calibration point, while actual muzzle motion changes projectile direction.
- Camera never renders inside the local head, the weapon does not enter the camera, and wall obstruction visibly raises/retracts the weapon and prevents firing.
- Magnified optics show eye-box shadow/parallax as eye alignment drifts. Iron sights and 1x optics ignore the high-magnification mode setting.
- `ads_system_runner.tscn`, `ik_regression_check.tscn`, `ai_aim_check.tscn`, and `force_integration_runner.gd` pass. The known foot-IK stance-return assertion in `crouch_ik_check.tscn` is unrelated to this ADS pass.
