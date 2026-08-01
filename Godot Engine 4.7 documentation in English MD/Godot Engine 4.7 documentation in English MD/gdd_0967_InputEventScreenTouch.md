# InputEventScreenTouch

Inherits: InputEventFromWindow < InputEvent < Resource < RefCounted < Object

Represents a screen touch event.

## Description

Stores information about multi-touch press/release input events. Supports touch press, touch release and index for multi-touch count and order.

## Tutorials

- Using InputEvent

## Properties

bool | canceled | false
bool | double_tap | false
int | index | 0
Vector2 | position | Vector2(0, 0)
bool | pressed | false

---

## Property Descriptions

bool canceled = false 

- void set_canceled(value: bool)
- bool is_canceled()

If true, the touch event has been canceled.

---

bool double_tap = false 

- void set_double_tap(value: bool)
- bool is_double_tap()

If true, the touch's state is a double tap.

---

int index = 0 

- void set_index(value: int)
- int get_index()

The touch index in the case of a multi-touch event. One index = one finger.

---

Vector2 position = Vector2(0, 0) 

- void set_position(value: Vector2)
- Vector2 get_position()

The touch position in the viewport the node is in, using the coordinate system of this viewport.

---

bool pressed = false 

- void set_pressed(value: bool)
- bool is_pressed()

If true, the touch's state is pressed. If false, the touch's state is released.
