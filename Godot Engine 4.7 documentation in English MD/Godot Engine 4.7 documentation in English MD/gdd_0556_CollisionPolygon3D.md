# CollisionPolygon3D

Inherits: Node3D < Node < Object

A node that provides a thickened polygon shape (a prism) to a CollisionObject3D parent.

## Description

A node that provides a thickened polygon shape (a prism) to a CollisionObject3D parent and allows it to be edited. The polygon can be concave or convex. This can give a detection shape to an Area3D or turn a PhysicsBody3D into a solid object.

Warning: A non-uniformly scaled CollisionShape3D will likely not behave as expected. Make sure to keep its scale the same on all axes and adjust its shape resource instead.

## Properties

Color | debug_color | Color(0, 0, 0, 0)
bool | debug_fill | true
float | depth | 1.0
bool | disabled | false
float | margin | 0.04
PackedVector2Array | polygon | PackedVector2Array()

---

## Property Descriptions

Color debug_color = Color(0, 0, 0, 0) 

- void set_debug_color(value: Color)
- Color get_debug_color()

The collision shape color that is displayed in the editor, or in the running project if Debug > Visible Collision Shapes is checked at the top of the editor.

Note: The default value is ProjectSettings.debug/shapes/collision/shape_color. The Color(0, 0, 0, 0) value documented here is a placeholder, and not the actual default debug color.

---

bool debug_fill = true 

- void set_enable_debug_fill(value: bool)
- bool get_enable_debug_fill()

If true, when the shape is displayed, it will show a solid fill color in addition to its wireframe.

---

float depth = 1.0 

- void set_depth(value: float)
- float get_depth()

Length that the resulting collision extends in either direction perpendicular to its 2D polygon.

---

bool disabled = false 

- void set_disabled(value: bool)
- bool is_disabled()

If true, no collision will be produced. This property should be changed with Object.set_deferred().

---

float margin = 0.04 

- void set_margin(value: float)
- float get_margin()

The collision margin for the generated Shape3D. See Shape3D.margin for more details.

---

PackedVector2Array polygon = PackedVector2Array() 

- void set_polygon(value: PackedVector2Array)
- PackedVector2Array get_polygon()

Array of vertices which define the 2D polygon in the local XY plane.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.
