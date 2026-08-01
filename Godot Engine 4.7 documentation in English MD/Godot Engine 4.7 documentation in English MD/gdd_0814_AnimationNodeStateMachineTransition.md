# AnimationNodeStateMachineTransition

Inherits: Resource < RefCounted < Object

A transition within an AnimationNodeStateMachine connecting two AnimationRootNodes.

## Description

The path generated when using AnimationNodeStateMachinePlayback.travel() is limited to the nodes connected by AnimationNodeStateMachineTransition.

You can set the timing and conditions of the transition in detail.

## Tutorials

- Using AnimationTree

## Properties

StringName | advance_condition | &""
String | advance_expression | ""
AdvanceMode | advance_mode | 1
bool | break_loop_at_end | false
int | priority | 1
bool | reset | true
SwitchMode | switch_mode | 0
Curve | xfade_curve |
float | xfade_time | 0.0

---

## Signals

advance_condition_changed() 

Emitted when advance_condition is changed.

---

## Enumerations

enum SwitchMode
SwitchMode SWITCH_MODE_IMMEDIATE = 0

Switch to the next state immediately. The current state will end and blend into the beginning of the new one.

SwitchMode SWITCH_MODE_SYNC = 1

Switch to the next state immediately, but will seek the new state to the playback position of the old state.

SwitchMode SWITCH_MODE_AT_END = 2

Wait for the current state playback to end, then switch to the beginning of the next state animation.

---

enum AdvanceMode
AdvanceMode ADVANCE_MODE_DISABLED = 0

Don't use this transition.

AdvanceMode ADVANCE_MODE_ENABLED = 1

Only use this transition during AnimationNodeStateMachinePlayback.travel().

AdvanceMode ADVANCE_MODE_AUTO = 2

Automatically use this transition if the advance_condition and advance_expression checks are true (if assigned).

---

## Property Descriptions

StringName advance_condition = &"" 

- void set_advance_condition(value: StringName)
- StringName get_advance_condition()

Turn on auto advance when this condition is set. The provided name will become a boolean parameter on the AnimationTree that can be controlled from code (see Using AnimationTree). For example, if AnimationTree.tree_root is an AnimationNodeStateMachine and advance_condition is set to "idle":

```
$animation_tree.set("parameters/conditions/idle", is_on_floor and (linear_velocity.x == 0))
```

```
GetNode("animation_tree").Set("parameters/conditions/idle", IsOnFloor && (LinearVelocity.X == 0));
```

---

String advance_expression = "" 

- void set_advance_expression(value: String)
- String get_advance_expression()

Use an expression as a condition for state machine transitions. It is possible to create complex animation advance conditions for switching between states and gives much greater flexibility for creating complex state machines by directly interfacing with the script code.

---

AdvanceMode advance_mode = 1 

- void set_advance_mode(value: AdvanceMode)
- AdvanceMode get_advance_mode()

Determines whether the transition should be disabled, enabled when using AnimationNodeStateMachinePlayback.travel(), or traversed automatically if the advance_condition and advance_expression checks are true (if assigned).

---

bool break_loop_at_end = false 

- void set_break_loop_at_end(value: bool)
- bool is_loop_broken_at_end()

If true, breaks the loop at the end of the loop cycle for transition, even if the animation is looping.

---

int priority = 1 

- void set_priority(value: int)
- int get_priority()

Lower priority transitions are preferred when travelling through the tree via AnimationNodeStateMachinePlayback.travel() or advance_mode is set to ADVANCE_MODE_AUTO.

---

bool reset = true 

- void set_reset(value: bool)
- bool is_reset()

If true, the destination animation is played back from the beginning when switched.

---

SwitchMode switch_mode = 0 

- void set_switch_mode(value: SwitchMode)
- SwitchMode get_switch_mode()

The transition type.

---

Curve xfade_curve 

- void set_xfade_curve(value: Curve)
- Curve get_xfade_curve()

Ease curve for better control over cross-fade between this state and the next. Should be a unit Curve.

---

float xfade_time = 0.0 

- void set_xfade_time(value: float)
- float get_xfade_time()

The time to cross-fade between this state and the next.

Note: AnimationNodeStateMachine transitions the current state immediately after the start of the fading. The precise remaining time can only be inferred from the main animation. When AnimationNodeOutput is considered as the most upstream, so the xfade_time is not scaled depending on the downstream delta. See also AnimationNodeOneShot.fadeout_time.
