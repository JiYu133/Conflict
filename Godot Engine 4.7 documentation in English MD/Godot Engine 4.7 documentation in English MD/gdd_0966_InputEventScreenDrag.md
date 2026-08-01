# InputEventScreenDrag

Inherits: InputEventFromWindow < InputEvent < Resource < RefCounted < Object

Represents a screen drag event.

## Description

Stores information about screen drag events. See Node._input().

## Tutorials

- Using InputEvent

## Properties

int | index | 0
bool | pen_inverted | false
Vector2 | position | Vector2(0, 0)
float | pressure | 0.0
Vector2 | relative | Vector2(0, 0)
Vector2 | screen_relative | Vector2(0, 0)
Vector2 | screen_velocity | Vector2(0, 0)
Vector2 | tilt | Vector2(0, 0)
Vector2 | velocity | Vector2(0, 0)

---

## Property Descriptions

int index = 0 

- void set_index(value: int)
- int get_index()

The drag event index in the case of a multi-drag event.

---

bool pen_inverted = false 

- void set_pen_inverted(value: bool)
- bool get_pen_inverted()

Returns true when using the eraser end of a stylus pen.

---

Vector2 position = Vector2(0, 0) 

- void set_position(value: Vector2)
- Vector2 get_position()

The drag position in the viewport the node is in, using the coordinate system of this viewport.

---

float pressure = 0.0 

- void set_pressure(value: float)
- float get_pressure()

Represents the pressure the user puts on the pen. Ranges from 0.0 to 1.0.

---

Vector2 relative = Vector2(0, 0) 

- void set_relative(value: Vector2)
- Vector2 get_relative()

The drag position relative to the previous position (position at the last frame).

Note: relative is automatically scaled according to the content scale factor, which is defined by the project's stretch mode settings. This means touch sensitivity will appear different depending on resolution when using relative in a script that handles touch aiming. To avoid this, use screen_relative instead.

---

Vector2 screen_relative = Vector2(0, 0) 

- void set_screen_relative(value: Vector2)
- Vector2 get_screen_relative()

The unscaled drag position relative to the previous position in screen coordinates (position at the last frame). This position is not scaled according to the content scale factor or calls to InputEvent.xformed_by(). This should be preferred over relative for touch aiming regardless of the project's stretch mode.

---

Vector2 screen_velocity = Vector2(0, 0) 

- void set_screen_velocity(value: Vector2)
- Vector2 get_screen_velocity()

The unscaled drag velocity in pixels per second in screen coordinates. This velocity is not scaled according to the content scale factor or calls to InputEvent.xformed_by(). This should be preferred over velocity for touch aiming regardless of the project's stretch mode.

---

Vector2 tilt = Vector2(0, 0) 

- void set_tilt(value: Vector2)
- Vector2 get_tilt()

Represents the angles of tilt of the pen. Positive X-coordinate value indicates a tilt to the right. Positive Y-coordinate value indicates a tilt toward the user. Ranges from -1.0 to 1.0 for both axes.

---

Vector2 velocity = Vector2(0, 0) 

- void set_velocity(value: Vector2)
- Vector2 get_velocity()

The drag velocity.

Note: velocity is automatically scaled according to the content scale factor, which is defined by the project's stretch mode settings. This means touch sensitivity will appear different depending on resolution when using velocity in a script that handles touch aiming. To avoid this, use screen_velocity instead.
