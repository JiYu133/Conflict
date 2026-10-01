# ADS System

## Design rules

- ADS is an observation and weapon-presentation state. It never changes projectile dispersion, muzzle direction sampling, or the per-shot recoil impulse.
- Projectiles continue to originate at `Muzzle` and travel along that marker's world-space `-Z` axis.
- Crouch and prone permit ADS. Sprint, reload, malfunction clearance, death, weapon drop, and control-locking menus cancel it.
- Local input supports `hold` and `toggle` modes through `controls/ads_input_mode`. AI and debug tools keep using `WeaponManager.set_aiming()`.
- ADS timing is linear internally, but weapon pose and FOV use smoothstep easing so raising and lowering have zero endpoint velocity.

## Weapon pose and hand IK

`WeaponMount` under the animated right-hand attachment is now a pose source only. The equipped weapon lives under an independent `WeaponPoseRoot/WeaponSwayPivot` hierarchy. At hip, `WeaponPoseRoot` copies the authored hand mount. During ADS it blends toward the transform that places the active `ADSAnchor` exactly on the camera transform.

Both arms use `TwoBoneIK3D`. `HandTargetSync` refreshes the independent weapon pose and both hand targets after spine/force modifiers and before the arm solvers. The controller does not call `set_bone_pose_rotation()` for either hand; wrist rotation remains owned by the base animation.

This separation avoids the former right-hand -> weapon -> grip -> right-hand feedback loop and lets the weapon remain camera-centred while the hands follow it in real time.

## Authored node contract

Mechanical sights and optics may provide these descendants:

- `ADSAnchor` (`Marker3D`): the desired player-eye transform at full ADS. Its `-Z` axis is the sight line.
- `OpticCameraAnchor` (`Marker3D`): the secondary camera transform used for lens rendering.
- `LensSurface` (`MeshInstance3D`): a UV-mapped lens receiving the `SubViewportTexture` while ADS.

`ADSAnchor` is sufficient for mechanical sights. An optic participates in independent-view rendering only when both `OpticCameraAnchor` and `LensSurface` exist. Missing optical nodes disable lens rendering without disabling ADS or firing.

## Rendering lifecycle

`OpticRenderController` belongs only to the local player and reuses one 512x512 `SubViewport` and one secondary `Camera3D` across equipped optics. The viewport shares the gameplay `World3D`, updates during ADS transitions, and stops updating after ADS-out completes.

Local weapon meshes use visual layer 20 while an optical sight is bound. The main camera renders that layer; the optic camera excludes it to prevent the receiver, lens, or reticle from recursively appearing inside the scope image. Outside ADS, `LensSurface` restores its authored glass material.

For a 1x optic, the secondary camera copies the main-camera FOV. Mechanical sights do not use the optic renderer.

Magnified optics (`magnification > 1`) use the player setting `graphics/magnified_scope_mode`:

- `pixel_zoom` (default): samples and enlarges pixels from the main view with a screen-texture shader. The optic `SubViewport` stays disabled, so no extra scene render occurs.
- `dual_camera`: renders the shared optic `SubViewport` with a secondary camera whose FOV is derived from the configured magnification.

The setting is deliberately ignored by 1x optics and mechanical sights.

## Sight calibration

Adjust sight alignment in the sight scene, not in camera code. Move or rotate the sight's `ADSAnchor`; its transform is the desired eye position and its local `-Z` axis is the sight line. The current open iron sight is authored at `assets/models/attachments/optics/iron_sight_open/iron_sight_open.tscn`.

For magnified optics, author `OpticCameraAnchor` for the independent camera origin and `LensSurface` for the rendered lens. `WeaponConfig.ads_center_offset` remains only a fallback for weapons without an `ADSAnchor`.
