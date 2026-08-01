# Line2D

Inherits: Node2D < CanvasItem < Node < Object

A 2D polyline that can optionally be textured.

## Description

This node draws a 2D polyline, i.e. a shape consisting of several points connected by segments. Line2D is not a mathematical polyline, i.e. the segments are not infinitely thin. It is intended for rendering and it can be colored and optionally textured.

Warning: Certain configurations may be impossible to draw nicely, such as very sharp angles. In these situations, the node uses fallback drawing logic to look decent.

Note: Line2D is drawn using a 2D mesh.

## Tutorials

- Matrix Transform Demo [https://godotengine.org/asset-library/asset/2787]
- 2.5D Game Demo [https://godotengine.org/asset-library/asset/2783]

## Properties

bool | antialiased | false
LineCapMode | begin_cap_mode | 0
bool | closed | false
Color | default_color | Color(1, 1, 1, 1)
LineCapMode | end_cap_mode | 0
Gradient | gradient |
LineJointMode | joint_mode | 0
PackedVector2Array | points | PackedVector2Array()
int | round_precision | 8
float | sharp_limit | 2.0
Texture2D | texture |
LineTextureMode | texture_mode | 0
float | width | 10.0
Curve | width_curve |

## Methods

void | add_point(position: Vector2, index: int = -1)
void | clear_points()
int | get_point_count() const
Vector2 | get_point_position(index: int) const
void | remove_point(index: int)
void | set_point_position(index: int, position: Vector2)

---

## Enumerations

enum LineJointMode
LineJointMode LINE_JOINT_SHARP = 0

Makes the polyline's joints pointy, connecting the sides of the two segments by extending them until they intersect. If the rotation of a joint is too big (based on sharp_limit), the joint falls back to LINE_JOINT_BEVEL to prevent very long miters.

LineJointMode LINE_JOINT_BEVEL = 1

Makes the polyline's joints bevelled/chamfered, connecting the sides of the two segments with a simple line.

LineJointMode LINE_JOINT_ROUND = 2

Makes the polyline's joints rounded, connecting the sides of the two segments with an arc. The detail of this arc depends on round_precision.

---

enum LineCapMode
LineCapMode LINE_CAP_NONE = 0

Draws no line cap.

LineCapMode LINE_CAP_BOX = 1

Draws the line cap as a box, slightly extending the first/last segment.

LineCapMode LINE_CAP_ROUND = 2

Draws the line cap as a semicircle attached to the first/last segment.

---

enum LineTextureMode
LineTextureMode LINE_TEXTURE_NONE = 0

Takes the left pixels of the texture and renders them over the whole polyline.

LineTextureMode LINE_TEXTURE_TILE = 1

Tiles the texture over the polyline. CanvasItem.texture_repeat of the Line2D node must be CanvasItem.TEXTURE_REPEAT_ENABLED or CanvasItem.TEXTURE_REPEAT_MIRROR for it to work properly.

LineTextureMode LINE_TEXTURE_STRETCH = 2

Stretches the texture across the polyline. CanvasItem.texture_repeat of the Line2D node must be CanvasItem.TEXTURE_REPEAT_DISABLED for best results.

---

## Property Descriptions

bool antialiased = false 

- void set_antialiased(value: bool)
- bool get_antialiased()

If true, the polyline's border will be anti-aliased.

Note: Line2D is not accelerated by batching when being anti-aliased.

---

LineCapMode begin_cap_mode = 0 

- void set_begin_cap_mode(value: LineCapMode)
- LineCapMode get_begin_cap_mode()

The style of the beginning of the polyline, if closed is false.

---

bool closed = false 

- void set_closed(value: bool)
- bool is_closed()

If true and the polyline has more than 2 points, the last point and the first one will be connected by a segment.

Note: The shape of the closing segment is not guaranteed to be seamless if a width_curve is provided.

Note: The joint between the closing segment and the first segment is drawn first and it samples the gradient and the width_curve at the beginning. This is an implementation detail that might change in a future version.

---

Color default_color = Color(1, 1, 1, 1) 

- void set_default_color(value: Color)
- Color get_default_color()

The color of the polyline. Will not be used if a gradient is set.

---

LineCapMode end_cap_mode = 0 

- void set_end_cap_mode(value: LineCapMode)
- LineCapMode get_end_cap_mode()

The style of the end of the polyline, if closed is false.

---

Gradient gradient 

- void set_gradient(value: Gradient)
- Gradient get_gradient()

The gradient is drawn through the whole line from start to finish. The default_color will not be used if this property is set.

---

LineJointMode joint_mode = 0 

- void set_joint_mode(value: LineJointMode)
- LineJointMode get_joint_mode()

The style of the connections between segments of the polyline.

---

PackedVector2Array points = PackedVector2Array() 

- void set_points(value: PackedVector2Array)
- PackedVector2Array get_points()

The points of the polyline, interpreted in local 2D coordinates. Segments are drawn between the adjacent points in this array.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

int round_precision = 8 

- void set_round_precision(value: int)
- int get_round_precision()

The smoothness used for rounded joints and caps. Higher values result in smoother corners, but are more demanding to render and update.

---

float sharp_limit = 2.0 

- void set_sharp_limit(value: float)
- float get_sharp_limit()

Determines the miter limit of the polyline. Normally, when joint_mode is set to LINE_JOINT_SHARP, sharp angles fall back to using the logic of LINE_JOINT_BEVEL joints to prevent very long miters. Higher values of this property mean that the fallback to a bevel joint will happen at sharper angles.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

The texture used for the polyline. Uses texture_mode for drawing style.

---

LineTextureMode texture_mode = 0 

- void set_texture_mode(value: LineTextureMode)
- LineTextureMode get_texture_mode()

The style to render the texture of the polyline.

---

float width = 10.0 

- void set_width(value: float)
- float get_width()

The polyline's width.

---

Curve width_curve 

- void set_curve(value: Curve)
- Curve get_curve()

The polyline's width curve. The width of the polyline over its length will be equivalent to the value of the width curve over its domain. The width curve should be a unit Curve.

---

## Method Descriptions

void add_point(position: Vector2, index: int = -1) 

Adds a point with the specified position relative to the polyline's own position. If no index is provided, the new point will be added to the end of the points array.

If index is given, the new point is inserted before the existing point identified by index index. The indices of the points after the new point get increased by 1. The provided index must not exceed the number of existing points in the polyline. See get_point_count().

---

void clear_points() 

Removes all points from the polyline, making it empty.

---

int get_point_count() const 

Returns the number of points in the polyline.

---

Vector2 get_point_position(index: int) const 

Returns the position of the point at index index.

---

void remove_point(index: int) 

Removes the point at index index from the polyline.

---

void set_point_position(index: int, position: Vector2) 

Overwrites the position of the point at the given index with the supplied position.
