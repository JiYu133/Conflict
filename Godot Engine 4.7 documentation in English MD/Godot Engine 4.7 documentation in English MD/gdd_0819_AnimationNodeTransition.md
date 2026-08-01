# AnimationNodeTransition

Inherits: AnimationNodeSync < AnimationNode < Resource < RefCounted < Object

A transition within an AnimationTree connecting two AnimationNodes.

## Description

Simple state machine for cases which don't require a more advanced AnimationNodeStateMachine. Animations can be connected to the inputs and transition times can be specified.

After setting the request and changing the animation playback, the transition node automatically clears the request on the next process frame by setting its transition_request value to empty.

Note: When using a cross-fade, current_state and current_index change to the next state immediately after the cross-fade begins.

```
# Play child animation connected to "state_2" port.
animation_tree.set("parameters/Transition/transition_request", "state_2")
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/transition_request"] = "state_2"
# Get current state name (read-only).
animation_tree.get("parameters/Transition/current_state")
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/current_state"]
# Get current state index (read-only).
animation_tree.get("parameters/Transition/current_index")
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/current_index"]
```

```
// Play child animation connected to "state_2" port.
animationTree.Set("parameters/Transition/transition_request", "state_2");
// Get current state name (read-only).
animationTree.Get("parameters/Transition/current_state");
// Get current state index (read-only).
animationTree.Get("parameters/Transition/current_index");
```

## Tutorials

- Using AnimationTree
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

bool | allow_transition_to_self | false
int | input_count | 0
Curve | xfade_curve |
float | xfade_time | 0.0

## Methods

bool | is_input_loop_broken_at_end(input: int) const
bool | is_input_reset(input: int) const
bool | is_input_set_as_auto_advance(input: int) const
void | set_input_as_auto_advance(input: int, enable: bool)
void | set_input_break_loop_at_end(input: int, enable: bool)
void | set_input_reset(input: int, enable: bool)

---

## Property Descriptions

bool allow_transition_to_self = false 

- void set_allow_transition_to_self(value: bool)
- bool is_allow_transition_to_self()

If true, allows transition to the self state. When the reset option is enabled in input, the animation is restarted. If false, nothing happens on the transition to the self state.

---

int input_count = 0 

- void set_input_count(value: int)
- int get_input_count()

The number of enabled input ports for this animation node.

---

Curve xfade_curve 

- void set_xfade_curve(value: Curve)
- Curve get_xfade_curve()

Determines how cross-fading between animations is eased. If empty, the transition will be linear. Should be a unit Curve.

---

float xfade_time = 0.0 

- void set_xfade_time(value: float)
- float get_xfade_time()

Cross-fading time (in seconds) between each animation connected to the inputs.

Note: AnimationNodeTransition transitions the current state immediately after the start of the fading. The precise remaining time can only be inferred from the main animation. When AnimationNodeOutput is considered as the most upstream, so the xfade_time is not scaled depending on the downstream delta. See also AnimationNodeOneShot.fadeout_time.

---

## Method Descriptions

bool is_input_loop_broken_at_end(input: int) const 

Returns whether the animation breaks the loop at the end of the loop cycle for transition.

---

bool is_input_reset(input: int) const 

Returns whether the animation restarts when the animation transitions from the other animation.

---

bool is_input_set_as_auto_advance(input: int) const 

Returns true if auto-advance is enabled for the given input index.

---

void set_input_as_auto_advance(input: int, enable: bool) 

Enables or disables auto-advance for the given input index. If enabled, state changes to the next input after playing the animation once. If enabled for the last input state, it loops to the first.

---

void set_input_break_loop_at_end(input: int, enable: bool) 

If true, breaks the loop at the end of the loop cycle for transition, even if the animation is looping.

---

void set_input_reset(input: int, enable: bool) 

If true, the destination animation is restarted when the animation transitions.
