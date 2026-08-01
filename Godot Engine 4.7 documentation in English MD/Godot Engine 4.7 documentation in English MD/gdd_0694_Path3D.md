# Path3D

Inherits: Node3D < Node < Object

Contains a Curve3D path for PathFollow3D nodes to follow.

## Description

Can have PathFollow3D child nodes moving along the Curve3D. See PathFollow3D for more information on the usage.

Note that the path is considered as relative to the moved nodes (children of PathFollow3D). As such, the curve should usually start with a zero vector (0, 0, 0).

## Properties

Curve3D | curve |
Color | debug_custom_color | Color(0, 0, 0, 1)

---

## Signals

curve_changed() 

Emitted when the curve changes.

---

debug_color_changed() 

Emitted when the debug_custom_color changes.

---

## Property Descriptions

Curve3D curve 

- void set_curve(value: Curve3D)
- Curve3D get_curve()

A Curve3D describing the path.

---

Color debug_custom_color = Color(0, 0, 0, 1) 

- void set_debug_custom_color(value: Color)
- Color get_debug_custom_color()

The custom color used to draw the path in the editor. If set to Color.BLACK (as by default), the color set in ProjectSettings.debug/shapes/paths/geometry_color is used.
