# PlayerLookController

`PlayerLookController` owns player view input and keeps it separate from camera placement and body turning.

## Behavior

- Normal mouse input changes the base view. While airborne, it never synchronizes the body yaw.
- During standing/crouched locomotion, the body yaw follows the actual horizontal velocity direction with a configurable turn rate (`MovementConfig.moving_body_turn_speed_degrees`) while the velocity remains inside `moving_body_velocity_yaw_threshold_degrees` of the view. Movement in the rear sector keeps the body view-aligned so the locomotion tree can play backward animations.
- The remaining view-to-body yaw offset is consumed by `SpineAimController`, so the upper body and weapon can keep pointing toward the aim direction while the lower body follows movement.
- Holding `free_look` (default: middle mouse button) changes only a temporary visual offset.
- Temporary free-look yaw is limited by `MovementConfig.turn_view_limit_degrees`.
- Releasing `free_look` smoothly returns the temporary yaw and pitch offsets to zero.
- `PlayerTurnController` reads the base view yaw, so free look cannot trigger an unwanted turn.

## Related configuration

| Configuration | Meaning |
| --- | --- |
| `MovementConfig.turn_view_limit_degrees` | Maximum view offset from the body, in degrees. |
| `MovementConfig.moving_body_velocity_yaw_threshold_degrees` | Maximum velocity-to-view angle that turns the lower body toward velocity; movement beyond it uses backward locomotion. |
| `SpineAimConfig.max_look_yaw_degrees` | Maximum horizontal rotation distributed across the spine, neck, and head, in degrees. |
| `SpineAimConfig.bone_names` | Normal aiming spine/neck bones; these can affect the weapon pose. |
| `SpineAimConfig.bone_weights` | Normal aiming weights corresponding to `bone_names`. |
| `SpineAimConfig.free_look_bone_names` | Free-look-only bones; default is `Head`, so free look cannot change the gun direction. |
| `SpineAimConfig.free_look_bone_weights` | Free-look weights corresponding to `free_look_bone_names`. |
