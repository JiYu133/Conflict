# Geometry2D

Inherits: Object

Provides methods for some common 2D geometric operations.

## Description

Provides a set of helper functions to create geometric shapes, compute intersections between shapes, and process various other geometric operations in 2D.

## Methods

Array[Vector2i] | bresenham_line(from: Vector2i, to: Vector2i)
Array[PackedVector2Array] | clip_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array)
Array[PackedVector2Array] | clip_polyline_with_polygon(polyline: PackedVector2Array, polygon: PackedVector2Array)
PackedVector2Array | convex_hull(points: PackedVector2Array)
Array[PackedVector2Array] | decompose_polygon_in_convex(polygon: PackedVector2Array)
Array[PackedVector2Array] | exclude_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array)
Vector2 | get_closest_point_to_segment(point: Vector2, s1: Vector2, s2: Vector2)
Vector2 | get_closest_point_to_segment_uncapped(point: Vector2, s1: Vector2, s2: Vector2)
PackedVector2Array | get_closest_points_between_segments(p1: Vector2, q1: Vector2, p2: Vector2, q2: Vector2)
Array[PackedVector2Array] | intersect_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array)
Array[PackedVector2Array] | intersect_polyline_with_polygon(polyline: PackedVector2Array, polygon: PackedVector2Array)
bool | is_point_in_circle(point: Vector2, circle_position: Vector2, circle_radius: float)
bool | is_point_in_polygon(point: Vector2, polygon: PackedVector2Array)
bool | is_polygon_clockwise(polygon: PackedVector2Array)
Variant | line_intersects_line(from_a: Vector2, dir_a: Vector2, from_b: Vector2, dir_b: Vector2)
Dictionary | make_atlas(sizes: PackedVector2Array)
Array[PackedVector2Array] | merge_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array)
Array[PackedVector2Array] | offset_polygon(polygon: PackedVector2Array, delta: float, join_type: PolyJoinType = 0)
Array[PackedVector2Array] | offset_polyline(polyline: PackedVector2Array, delta: float, join_type: PolyJoinType = 0, end_type: PolyEndType = 3)
bool | point_is_inside_triangle(point: Vector2, a: Vector2, b: Vector2, c: Vector2) const
float | segment_intersects_circle(segment_from: Vector2, segment_to: Vector2, circle_position: Vector2, circle_radius: float)
Variant | segment_intersects_segment(from_a: Vector2, to_a: Vector2, from_b: Vector2, to_b: Vector2)
PackedInt32Array | triangulate_delaunay(points: PackedVector2Array)
PackedInt32Array | triangulate_polygon(polygon: PackedVector2Array)

---

## Enumerations

enum PolyBooleanOperation
PolyBooleanOperation OPERATION_UNION = 0

Create regions where either subject or clip polygons (or both) are filled.

PolyBooleanOperation OPERATION_DIFFERENCE = 1

Create regions where subject polygons are filled except where clip polygons are filled.

PolyBooleanOperation OPERATION_INTERSECTION = 2

Create regions where both subject and clip polygons are filled.

PolyBooleanOperation OPERATION_XOR = 3

Create regions where either subject or clip polygons are filled but not where both are filled.

---

enum PolyJoinType
PolyJoinType JOIN_SQUARE = 0

Squaring is applied uniformally at all convex edge joins at 1 * delta.

PolyJoinType JOIN_ROUND = 1

While flattened paths can never perfectly trace an arc, they are approximated by a series of arc chords.

PolyJoinType JOIN_MITER = 2

There's a necessary limit to mitered joins since offsetting edges that join at very acute angles will produce excessively long and narrow "spikes". For any given edge join, when miter offsetting would exceed that maximum distance, "square" joining is applied.

---

enum PolyEndType
PolyEndType END_POLYGON = 0

Endpoints are joined using the PolyJoinType value and the path filled as a polygon.

PolyEndType END_JOINED = 1

Endpoints are joined using the PolyJoinType value and the path filled as a polyline.

PolyEndType END_BUTT = 2

Endpoints are squared off with no extension.

PolyEndType END_SQUARE = 3

Endpoints are squared off and extended by delta units.

PolyEndType END_ROUND = 4

Endpoints are rounded off and extended by delta units.

---

## Method Descriptions

Array[Vector2i] bresenham_line(from: Vector2i, to: Vector2i) 

Returns the Bresenham line [https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm] between the from and to points. A Bresenham line is a series of pixels that draws a line and is always 1-pixel thick on every row and column of the drawing (never more, never less).

Example code to draw a line between two Marker2D nodes using a series of CanvasItem.draw_rect() calls:

```gdscript
func _draw():
    for pixel in Geometry2D.bresenham_line($MarkerA.position, $MarkerB.position):
        draw_rect(Rect2(pixel, Vector2.ONE), Color.WHITE)
```

---

Array[PackedVector2Array] clip_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) 

Clips polygon_a against polygon_b and returns an array of clipped polygons. This performs OPERATION_DIFFERENCE between polygons. Returns an empty array if polygon_b completely overlaps polygon_a.

If polygon_b is enclosed by polygon_a, returns an outer polygon (boundary) and inner polygon (hole) which could be distinguished by calling is_polygon_clockwise().

---

Array[PackedVector2Array] clip_polyline_with_polygon(polyline: PackedVector2Array, polygon: PackedVector2Array) 

Clips polyline against polygon and returns an array of clipped polylines. This performs OPERATION_DIFFERENCE between the polyline and the polygon. This operation can be thought of as cutting a line with a closed shape.

---

PackedVector2Array convex_hull(points: PackedVector2Array) 

Given an array of Vector2s, returns the convex hull as a list of points in counterclockwise order. The last point is the same as the first one.

---

Array[PackedVector2Array] decompose_polygon_in_convex(polygon: PackedVector2Array) 

Decomposes the polygon into multiple convex hulls and returns an array of PackedVector2Array.

---

Array[PackedVector2Array] exclude_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) 

Mutually excludes common area defined by intersection of polygon_a and polygon_b (see intersect_polygons()) and returns an array of excluded polygons. This performs OPERATION_XOR between polygons. In other words, returns all but common area between polygons.

The operation may result in an outer polygon (boundary) and inner polygon (hole) produced which could be distinguished by calling is_polygon_clockwise().

---

Vector2 get_closest_point_to_segment(point: Vector2, s1: Vector2, s2: Vector2) 

Returns the 2D point on the 2D segment (s1, s2) that is closest to point. The returned point will always be inside the specified segment.

---

Vector2 get_closest_point_to_segment_uncapped(point: Vector2, s1: Vector2, s2: Vector2) 

Returns the 2D point on the 2D line defined by (s1, s2) that is closest to point. The returned point can be inside the segment (s1, s2) or outside of it, i.e. somewhere on the line extending from the segment.

---

PackedVector2Array get_closest_points_between_segments(p1: Vector2, q1: Vector2, p2: Vector2, q2: Vector2) 

Given the two 2D segments (p1, q1) and (p2, q2), finds those two points on the two segments that are closest to each other. Returns a PackedVector2Array that contains this point on (p1, q1) as well the accompanying point on (p2, q2).

---

Array[PackedVector2Array] intersect_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) 

Intersects polygon_a with polygon_b and returns an array of intersected polygons. This performs OPERATION_INTERSECTION between polygons. In other words, returns common area shared by polygons. Returns an empty array if no intersection occurs.

The operation may result in an outer polygon (boundary) and inner polygon (hole) produced which could be distinguished by calling is_polygon_clockwise().

---

Array[PackedVector2Array] intersect_polyline_with_polygon(polyline: PackedVector2Array, polygon: PackedVector2Array) 

Intersects polyline with polygon and returns an array of intersected polylines. This performs OPERATION_INTERSECTION between the polyline and the polygon. This operation can be thought of as chopping a line with a closed shape.

---

bool is_point_in_circle(point: Vector2, circle_position: Vector2, circle_radius: float) 

Returns true if point is inside the circle or if it's located exactly on the circle's boundary, otherwise returns false.

---

bool is_point_in_polygon(point: Vector2, polygon: PackedVector2Array) 

Returns true if point is inside polygon or if it's located exactly on polygon's boundary, otherwise returns false.

---

bool is_polygon_clockwise(polygon: PackedVector2Array) 

Returns true if polygon's vertices are ordered in clockwise order, otherwise returns false.

Note: Assumes a Cartesian coordinate system where +x is right and +y is up. If using screen coordinates (+y is down), the result will need to be flipped (i.e. a true result will indicate counter-clockwise).

---

Variant line_intersects_line(from_a: Vector2, dir_a: Vector2, from_b: Vector2, dir_b: Vector2) 

Returns the point of intersection between the two lines (from_a, dir_a) and (from_b, dir_b). Returns a Vector2, or null if the lines are parallel.

from and dir are not endpoints of a line segment or ray but the slope (dir) and a known point (from) on that line. To get the intersection between two line segments, use segment_intersects_segment().

```
var from_a = Vector2.ZERO
var dir_a = Vector2.RIGHT
var from_b = Vector2.DOWN
# Returns Vector2(1, 0)
Geometry2D.line_intersects_line(from_a, dir_a, from_b, Vector2(1, -1))
# Returns Vector2(-1, 0)
Geometry2D.line_intersects_line(from_a, dir_a, from_b, Vector2(-1, -1))
# Returns null
Geometry2D.line_intersects_line(from_a, dir_a, from_b, Vector2.RIGHT)
```

```
var fromA = Vector2.Zero;
var dirA = Vector2.Right;
var fromB = Vector2.Down;
// Returns new Vector2(1, 0)
Geometry2D.LineIntersectsLine(fromA, dirA, fromB, new Vector2(1, -1));
// Returns new Vector2(-1, 0)
Geometry2D.LineIntersectsLine(fromA, dirA, fromB, new Vector2(-1, -1));
// Returns null
Geometry2D.LineIntersectsLine(fromA, dirA, fromB, Vector2.Right);
```

---

Dictionary make_atlas(sizes: PackedVector2Array) 

Given an array of Vector2s representing tiles, builds an atlas. The returned dictionary has two keys: points is a PackedVector2Array that specifies the positions of each tile, size contains the overall size of the whole atlas as Vector2i.

---

Array[PackedVector2Array] merge_polygons(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) 

Merges (combines) polygon_a and polygon_b and returns an array of merged polygons. This performs OPERATION_UNION between polygons.

The operation may result in an outer polygon (boundary) and multiple inner polygons (holes) produced which could be distinguished by calling is_polygon_clockwise().

---

Array[PackedVector2Array] offset_polygon(polygon: PackedVector2Array, delta: float, join_type: PolyJoinType = 0) 

Inflates or deflates polygon by delta units (pixels). If delta is positive, makes the polygon grow outward. If delta is negative, shrinks the polygon inward. Returns an array of polygons because inflating/deflating may result in multiple discrete polygons. Returns an empty array if delta is negative and the absolute value of it approximately exceeds the minimum bounding rectangle dimensions of the polygon.

Each polygon's vertices will be rounded as determined by join_type.

The operation may result in an outer polygon (boundary) and inner polygon (hole) produced which could be distinguished by calling is_polygon_clockwise().

Note: To translate the polygon's vertices specifically, multiply them to a Transform2D:

```
var polygon = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100), Vector2(0, 100)])
var offset = Vector2(50, 50)
polygon = Transform2D(0, offset) * polygon
print(polygon) # Prints [(50.0, 50.0), (150.0, 50.0), (150.0, 150.0), (50.0, 150.0)]
```

```
Vector2[] polygon = [new Vector2(0, 0), new Vector2(100, 0), new Vector2(100, 100), new Vector2(0, 100)];
var offset = new Vector2(50, 50);
polygon = new Transform2D(0, offset) * polygon;
GD.Print((Variant)polygon); // Prints [(50, 50), (150, 50), (150, 150), (50, 150)]
```

---

Array[PackedVector2Array] offset_polyline(polyline: PackedVector2Array, delta: float, join_type: PolyJoinType = 0, end_type: PolyEndType = 3) 

Inflates or deflates polyline by delta units (pixels), producing polygons. If delta is positive, makes the polyline grow outward. Returns an array of polygons because inflating/deflating may result in multiple discrete polygons. If delta is negative, returns an empty array.

Each polygon's vertices will be rounded as determined by join_type.

Each polygon's endpoints will be rounded as determined by end_type.

The operation may result in an outer polygon (boundary) and inner polygon (hole) produced which could be distinguished by calling is_polygon_clockwise().

---

bool point_is_inside_triangle(point: Vector2, a: Vector2, b: Vector2, c: Vector2) const 

Returns if point is inside the triangle specified by a, b and c.

---

float segment_intersects_circle(segment_from: Vector2, segment_to: Vector2, circle_position: Vector2, circle_radius: float) 

Given the 2D segment (segment_from, segment_to), returns the position on the segment (as a number between 0 and 1) at which the segment hits the circle that is located at position circle_position and has radius circle_radius. If the segment does not intersect the circle, -1 is returned (this is also the case if the line extending the segment would intersect the circle, but the segment does not).

---

Variant segment_intersects_segment(from_a: Vector2, to_a: Vector2, from_b: Vector2, to_b: Vector2) 

Checks if two line segments intersect, with line a between from_a and to_a and line b between from_b and to_b. If the line segments intersect, the point of intersection is returned as a Vector2. If no intersection takes place, null is returned.

---

PackedInt32Array triangulate_delaunay(points: PackedVector2Array) 

Triangulates the area specified by discrete set of points such that no point is inside the circumcircle of any resulting triangle. Returns a PackedInt32Array where each triangle consists of three consecutive point indices into points (i.e. the returned array will have n * 3 elements, with n being the number of found triangles). If the triangulation did not succeed, an empty PackedInt32Array is returned.

---

PackedInt32Array triangulate_polygon(polygon: PackedVector2Array) 

Triangulates the polygon specified by the points in polygon. Returns a PackedInt32Array where each triangle consists of three consecutive point indices into polygon (i.e. the returned array will have n * 3 elements, with n being the number of found triangles). Output triangles will always be counter clockwise, and the contour will be flipped if it's clockwise. If the triangulation did not succeed, an empty PackedInt32Array is returned.
