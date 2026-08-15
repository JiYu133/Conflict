# PlayerLookController

`PlayerLookController` owns player view input and keeps it separate from camera placement and body turning.

## Behavior

- Normal mouse input changes the base view. While airborne, it never synchronizes the body yaw.
- Holding `free_look` (default: middle mouse button) changes only a temporary visual offset.
- Temporary free-look yaw is limited by `MovementConfig.turn_view_limit_degrees`.
- Releasing `free_look` smoothly returns the temporary yaw and pitch offsets to zero.
- `PlayerTurnController` reads the base view yaw, so free look cannot trigger an unwanted turn.

## Related configuration

| Configuration | Meaning |
| --- | --- |
| `MovementConfig.turn_view_limit_degrees` | Maximum view offset from the body, in degrees. |
| `SpineAimConfig.max_look_yaw_degrees` | Maximum horizontal rotation distributed across the spine, neck, and head, in degrees. |
| `SpineAimConfig.bone_names` | Normal aiming spine/neck bones; these can affect the weapon pose. |
| `SpineAimConfig.bone_weights` | Normal aiming weights corresponding to `bone_names`. |
| `SpineAimConfig.free_look_bone_names` | Free-look-only bones; default is `Head`, so free look cannot change the gun direction. |
| `SpineAimConfig.free_look_bone_weights` | Free-look weights corresponding to `free_look_bone_names`. |
