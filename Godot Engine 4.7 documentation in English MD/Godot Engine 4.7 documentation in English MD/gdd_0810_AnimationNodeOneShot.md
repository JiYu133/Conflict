# AnimationNodeOneShot

Inherits: AnimationNodeSync < AnimationNode < Resource < RefCounted < Object

Plays an animation once in an AnimationNodeBlendTree.

## Description

A resource to add to an AnimationNodeBlendTree. This animation node will execute a sub-animation and return once it finishes. Blend times for fading in and out can be customized, as well as filters.

After setting the request and changing the animation playback, the one-shot node automatically clears the request on the next process frame by setting its request value to ONE_SHOT_REQUEST_NONE.

```
# Play child animation connected to "shot" port.
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
# Abort child animation connected to "shot" port.
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
# Abort child animation with fading out connected to "shot" port.
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
# Get current state (read-only).
animation_tree.get("parameters/OneShot/active")
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/active"]
# Get current internal state (read-only).
animation_tree.get("parameters/OneShot/internal_active")
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/internal_active"]
```

```
// Play child animation connected to "shot" port.
animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.Fire);
// Abort child animation connected to "shot" port.
animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.Abort);
// Abort child animation with fading out connected to "shot" port.
animationTree.Set("parameters/OneShot/request", (int)AnimationNodeOneShot.OneShotRequest.FadeOut);
// Get current state (read-only).
animationTree.Get("parameters/OneShot/active");
// Get current internal state (read-only).
animationTree.Get("parameters/OneShot/internal_active");
```

## Tutorials

- Using AnimationTree
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

bool | abort_on_reset | false
bool | autorestart | false
float | autorestart_delay | 1.0
float | autorestart_random_delay | 0.0
bool | break_loop_at_end | false
Curve | fadein_curve |
float | fadein_time | 0.0
Curve | fadeout_curve |
float | fadeout_time | 0.0
MixMode | mix_mode | 0

---

## Enumerations

enum OneShotRequest
OneShotRequest ONE_SHOT_REQUEST_NONE = 0

The default state of the request. Nothing is done.

OneShotRequest ONE_SHOT_REQUEST_FIRE = 1

The request to play the animation connected to "shot" port.

OneShotRequest ONE_SHOT_REQUEST_ABORT = 2

The request to stop the animation connected to "shot" port.

OneShotRequest ONE_SHOT_REQUEST_FADE_OUT = 3

The request to fade out the animation connected to "shot" port.

---

enum MixMode
MixMode MIX_MODE_BLEND = 0

Blends two animations. See also AnimationNodeBlend2.

MixMode MIX_MODE_ADD = 1

Blends two animations additively. See also AnimationNodeAdd2.

---

## Property Descriptions

bool abort_on_reset = false 

- void set_abort_on_reset(value: bool)
- bool is_aborted_on_reset()

If true, the sub-animation will abort if resumed with a reset after a prior interruption.

---

bool autorestart = false 

- void set_autorestart(value: bool)
- bool has_autorestart()

If true, the sub-animation will restart automatically after finishing.

In other words, to start auto restarting, the animation must be played once with the ONE_SHOT_REQUEST_FIRE request. The ONE_SHOT_REQUEST_ABORT request stops the auto restarting, but it does not disable the autorestart itself. So, the ONE_SHOT_REQUEST_FIRE request will start auto restarting again.

---

float autorestart_delay = 1.0 

- void set_autorestart_delay(value: float)
- float get_autorestart_delay()

The delay after which the automatic restart is triggered, in seconds.

---

float autorestart_random_delay = 0.0 

- void set_autorestart_random_delay(value: float)
- float get_autorestart_random_delay()

If autorestart is true, a random additional delay (in seconds) between 0 and this value will be added to autorestart_delay.

---

bool break_loop_at_end = false 

- void set_break_loop_at_end(value: bool)
- bool is_loop_broken_at_end()

If true, breaks the loop at the end of the loop cycle for transition, even if the animation is looping.

---

Curve fadein_curve 

- void set_fadein_curve(value: Curve)
- Curve get_fadein_curve()

Determines how cross-fading between animations is eased. If empty, the transition will be linear. Should be a unit Curve.

---

float fadein_time = 0.0 

- void set_fadein_time(value: float)
- float get_fadein_time()

The fade-in duration. For example, setting this to 1.0 for a 5 second length animation will produce a cross-fade that starts at 0 second and ends at 1 second during the animation.

Note: AnimationNodeOneShot transitions the current state after the fading has finished.

---

Curve fadeout_curve 

- void set_fadeout_curve(value: Curve)
- Curve get_fadeout_curve()

Determines how cross-fading between animations is eased. If empty, the transition will be linear. Should be a unit Curve.

---

float fadeout_time = 0.0 

- void set_fadeout_time(value: float)
- float get_fadeout_time()

The fade-out duration. For example, setting this to 1.0 for a 5 second length animation will produce a cross-fade that starts at 4 second and ends at 5 second during the animation.

Note: AnimationNodeOneShot transitions the current state after the fading has finished.

---

MixMode mix_mode = 0 

- void set_mix_mode(value: MixMode)
- MixMode get_mix_mode()

The blend type.
