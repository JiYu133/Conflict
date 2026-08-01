# InputEventMouseButton

Inherits: InputEventMouse < InputEventWithModifiers < InputEventFromWindow < InputEvent < Resource < RefCounted < Object

Represents a mouse button being pressed or released.

## Description

Stores information about mouse click events. See Node._input().

Note: On Wear OS devices, rotary input is mapped to @GlobalScope.MOUSE_BUTTON_WHEEL_UP and @GlobalScope.MOUSE_BUTTON_WHEEL_DOWN. This can be changed to @GlobalScope.MOUSE_BUTTON_WHEEL_LEFT and @GlobalScope.MOUSE_BUTTON_WHEEL_RIGHT with the ProjectSettings.input_devices/pointing/android/rotary_input_scroll_axis setting.

## Tutorials

- Using InputEvent
- Mouse and input coordinates

## Properties

MouseButton | button_index | 0
bool | canceled | false
bool | double_click | false
float | factor | 1.0
bool | pressed | false

---

## Property Descriptions

MouseButton button_index = 0 

- void set_button_index(value: MouseButton)
- MouseButton get_button_index()

The mouse button identifier, one of the MouseButton button or button wheel constants.

---

bool canceled = false 

- void set_canceled(value: bool)
- bool is_canceled()

If true, the mouse button event has been canceled.

---

bool double_click = false 

- void set_double_click(value: bool)
- bool is_double_click()

If true, the mouse button's state is a double-click.

---

float factor = 1.0 

- void set_factor(value: float)
- float get_factor()

The amount (or delta) of the event. When used for high-precision scroll events, this indicates the scroll amount (vertical or horizontal). This is only supported on some platforms; the reported sensitivity varies depending on the platform. May be 0 if not supported.

---

bool pressed = false 

- void set_pressed(value: bool)
- bool is_pressed()

If true, the mouse button's state is pressed. If false, the mouse button's state is released.
