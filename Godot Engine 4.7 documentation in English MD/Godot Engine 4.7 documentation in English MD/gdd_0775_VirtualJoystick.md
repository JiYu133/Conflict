# VirtualJoystick

Inherits: Control < CanvasItem < Node < Object

A virtual joystick control for touchscreen devices.

## Description

A customizable on-screen joystick control designed for touchscreen devices. It allows users to provide directional input by dragging a virtual tip within a defined circular area.

This control can simulate directional actions (see action_up, action_down, action_left, and action_right), which are triggered when the joystick is moved in the corresponding directions.

## Properties

StringName | action_down | &"ui_down"
StringName | action_left | &"ui_left"
StringName | action_right | &"ui_right"
StringName | action_up | &"ui_up"
float | clampzone_ratio | 1.0
float | deadzone_ratio | 0.0
Vector2 | initial_offset_ratio | Vector2(0.5, 0.5)
JoystickMode | joystick_mode | 0
float | joystick_size | 100.0
float | tip_size | 50.0
VisibilityMode | visibility_mode | 0

## Theme Properties

StyleBox | normal_joystick
StyleBox | normal_tip
StyleBox | pressed_joystick
StyleBox | pressed_tip

---

## Signals

flick_canceled() 

Emitted when the tip enters the deadzone after being outside of it.

---

flicked(input_vector: Vector2) 

Emitted when the tip moved outside the deadzone and the joystick is released. The input_vector contains the last input direction and strength before release. Its length is between 0.0 and 1.0.

---

pressed() 

Emitted when the joystick is pressed.

---

released(input_vector: Vector2) 

Emitted when the joystick is released. The input_vector is the final input direction and strength, with a length between 0.0 and 1.0.

---

tapped() 

Emitted when the joystick is released without moving the tip.

---

## Enumerations

enum JoystickMode
JoystickMode JOYSTICK_FIXED = 0

The joystick doesn't move.

JoystickMode JOYSTICK_DYNAMIC = 1

The joystick is moved to the initial touch position as long as it's within the joystick's bounds. It moves back to its original position when released.

JoystickMode JOYSTICK_FOLLOWING = 2

The joystick is moved to the initial touch position as long as it's within the joystick's bounds. It will follow the touch input if it goes outside the joystick's range. It moves back to its original position when released.

---

enum VisibilityMode
VisibilityMode VISIBILITY_ALWAYS = 0

The joystick is always visible.

VisibilityMode VISIBILITY_WHEN_TOUCHED = 1

The joystick is only visible when being touched.

---

## Property Descriptions

StringName action_down = &"ui_down" 

- void set_action_down(value: StringName)
- StringName get_action_down()

The action to trigger when the joystick is moved down.

---

StringName action_left = &"ui_left" 

- void set_action_left(value: StringName)
- StringName get_action_left()

The action to trigger when the joystick is moved left.

---

StringName action_right = &"ui_right" 

- void set_action_right(value: StringName)
- StringName get_action_right()

The action to trigger when the joystick is moved right.

---

StringName action_up = &"ui_up" 

- void set_action_up(value: StringName)
- StringName get_action_up()

The action to trigger when the joystick is moved up.

---

float clampzone_ratio = 1.0 

- void set_clampzone_ratio(value: float)
- float get_clampzone_ratio()

The multiplier applied to the joystick's radius that defines the clamp zone.

This zone limits how far the joystick tip can move from its center before being clamped.

A value of 1.0 means the tip can move up to the edge of the joystick's visual size.

In JOYSTICK_FOLLOWING mode, this radius also determines how far the finger can move before the joystick base starts following the touch input.

---

float deadzone_ratio = 0.0 

- void set_deadzone_ratio(value: float)
- float get_deadzone_ratio()

The ratio of the joystick size that defines the joystick deadzone. The joystick tip must move beyond this ratio before being considered active.

This deadzone is applied before triggering input actions and affects the joystick's input vector and all related signals.

Note that input actions may also define their own deadzones in the InputMap. If both are set, the joystick deadzone is applied first, followed by the action's deadzone.

By default, this value is 0.0, meaning the joystick does not apply its own deadzone and relies entirely on the InputMap action deadzones.

---

Vector2 initial_offset_ratio = Vector2(0.5, 0.5) 

- void set_initial_offset_ratio(value: Vector2)
- Vector2 get_initial_offset_ratio()

The initial position of the joystick as a ratio of the control's size. (0, 0) is top-left and (1, 1) is bottom-right.

---

JoystickMode joystick_mode = 0 

- void set_joystick_mode(value: JoystickMode)
- JoystickMode get_joystick_mode()

The joystick mode to use.

---

float joystick_size = 100.0 

- void set_joystick_size(value: float)
- float get_joystick_size()

The size of the joystick in pixels.

---

float tip_size = 50.0 

- void set_tip_size(value: float)
- float get_tip_size()

The size of the joystick tip in pixels.

---

VisibilityMode visibility_mode = 0 

- void set_visibility_mode(value: VisibilityMode)
- VisibilityMode get_visibility_mode()

The visibility mode to use.

---

## Theme Property Descriptions

StyleBox normal_joystick 

Base joystick StyleBox.

---

StyleBox normal_tip 

Tip joystick StyleBox.

---

StyleBox pressed_joystick 

Base joystick StyleBox when pressed.

---

StyleBox pressed_tip 

Tip joystick StyleBox when pressed.
