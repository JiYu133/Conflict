# InputEvent

Inherits: Resource < RefCounted < Object

Inherited By: InputEventAction, InputEventFromWindow, InputEventJoypadButton, InputEventJoypadMotion, InputEventMIDI, InputEventShortcut

Abstract base class for input events.

## Description

Abstract base class of all types of input events. See Node._input().

## Tutorials

- Using InputEvent
- Viewport and canvas transforms
- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]
- 3D Voxel Demo [https://godotengine.org/asset-library/asset/2755]

## Properties

int | device | 0

## Methods

bool | accumulate(with_event: InputEvent)
String | as_text() const
float | get_action_strength(action: StringName, exact_match: bool = false) const
bool | is_action(action: StringName, exact_match: bool = false) const
bool | is_action_pressed(action: StringName, allow_echo: bool = false, exact_match: bool = false) const
bool | is_action_released(action: StringName, exact_match: bool = false) const
bool | is_action_type() const
bool | is_canceled() const
bool | is_echo() const
bool | is_match(event: InputEvent, exact_match: bool = true) const
bool | is_pressed() const
bool | is_released() const
InputEvent | xformed_by(xform: Transform2D, local_ofs: Vector2 = Vector2(0, 0)) const

---

## Constants

DEVICE_ID_EMULATION = -1 

Device ID used for emulated mouse input from a touchscreen, or for emulated touch input from a mouse. This can be used to distinguish emulated mouse input from physical mouse input, or emulated touch input from physical touch input.

DEVICE_ID_KEYBOARD = 16 

Device ID used for input from a keyboard. This can be used to distinguish keyboard input events from joypad input events.

DEVICE_ID_MOUSE = 32 

Device ID used for input from a mouse. This can be used to distinguish mouse input events from joypad input events.

---

## Property Descriptions

int device = 0 

- void set_device(value: int)
- int get_device()

The event's device ID.

Note: device can be negative for special use cases that don't refer to devices physically present on the system. See DEVICE_ID_EMULATION.

---

## Method Descriptions

bool accumulate(with_event: InputEvent) 

Returns true if the given input event and this input event can be added together (only for events of type InputEventMouseMotion).

The given input event's position, global position and speed will be copied. The resulting relative is a sum of both events. Both events' modifiers have to be identical.

---

String as_text() const 

Returns a String representation of the event.

---

float get_action_strength(action: StringName, exact_match: bool = false) const 

Returns a value between 0.0 and 1.0 depending on the given actions' state. Useful for getting the value of events of type InputEventJoypadMotion.

If exact_match is false, it ignores additional input modifiers for InputEventKey and InputEventMouseButton events, and the direction for InputEventJoypadMotion events.

---

bool is_action(action: StringName, exact_match: bool = false) const 

Returns true if this input event matches a pre-defined action of any type.

If exact_match is false, it ignores additional input modifiers for InputEventKey and InputEventMouseButton events, and the direction for InputEventJoypadMotion events.

---

bool is_action_pressed(action: StringName, allow_echo: bool = false, exact_match: bool = false) const 

Returns true if the given action matches this event and is being pressed (and is not an echo event for InputEventKey events, unless allow_echo is true). Not relevant for events of type InputEventMouseMotion or InputEventScreenDrag.

If exact_match is false, it ignores additional input modifiers for InputEventKey and InputEventMouseButton events, and the direction for InputEventJoypadMotion events.

Note: Due to keyboard ghosting, is_action_pressed() may return false even if one of the action's keys is pressed. See Input examples in the documentation for more information.

---

bool is_action_released(action: StringName, exact_match: bool = false) const 

Returns true if the given action matches this event and is released (i.e. not pressed). Not relevant for events of type InputEventMouseMotion or InputEventScreenDrag.

If exact_match is false, it ignores additional input modifiers for InputEventKey and InputEventMouseButton events, and the direction for InputEventJoypadMotion events.

---

bool is_action_type() const 

Returns true if this input event's type is one that can be assigned to an input action: InputEventKey, InputEventMouseButton, InputEventJoypadButton, InputEventJoypadMotion, InputEventAction. Returns false for all other input event types.

---

bool is_canceled() const 

Returns true if this input event has been canceled.

---

bool is_echo() const 

Returns true if this input event is an echo event (only for events of type InputEventKey). An echo event is a repeated key event sent when the user is holding down the key. Any other event type returns false.

Note: The rate at which echo events are sent is typically around 20 events per second (after holding down the key for roughly half a second). However, the key repeat delay/speed can be changed by the user or disabled entirely in the operating system settings. To ensure your project works correctly on all configurations, do not assume the user has a specific key repeat configuration in your project's behavior.

---

bool is_match(event: InputEvent, exact_match: bool = true) const 

Returns true if the specified event matches this event. Only valid for action events, which include key (InputEventKey), button (InputEventMouseButton or InputEventJoypadButton), axis InputEventJoypadMotion, and action (InputEventAction) events.

If exact_match is false, the check ignores additional input modifiers for InputEventKey and InputEventMouseButton events, and the direction for InputEventJoypadMotion events.

Note: This method only considers the event configuration (such as the keyboard key or the joypad axis), not state information like is_pressed(), is_released(), is_echo(), or is_canceled().

---

bool is_pressed() const 

Returns true if this input event is pressed. Not relevant for events of type InputEventMouseMotion or InputEventScreenDrag.

Note: Due to keyboard ghosting, is_pressed() may return false even if one of the action's keys is pressed. See Input examples in the documentation for more information.

---

bool is_released() const 

Returns true if this input event is released. Not relevant for events of type InputEventMouseMotion or InputEventScreenDrag.

---

InputEvent xformed_by(xform: Transform2D, local_ofs: Vector2 = Vector2(0, 0)) const 

Returns a copy of the given input event which has been offset by local_ofs and transformed by xform. Relevant for events of type InputEventMouseButton, InputEventMouseMotion, InputEventScreenTouch, InputEventScreenDrag, InputEventMagnifyGesture and InputEventPanGesture.
