# ConvexPolygonShape2D

Inherits: Shape2D < Resource < RefCounted < Object

A 2D convex polygon shape used for physics collision.

## Description

A 2D convex polygon shape, intended for use in physics. Used internally in CollisionPolygon2D when it's in CollisionPolygon2D.BUILD_SOLIDS mode.

ConvexPolygonShape2D is solid, which means it detects collisions from objects that are fully inside it, unlike ConcavePolygonShape2D which is hollow. This makes it more suitable for both detection and physics.

Convex decomposition: A concave polygon can be split up into several convex polygons. This allows dynamic physics bodies to have complex concave collisions (at a performance cost) and can be achieved by using several ConvexPolygonShape2D nodes or by using the CollisionPolygon2D node in CollisionPolygon2D.BUILD_SOLIDS mode. To generate a collision polygon from a sprite, select the Sprite2D node, go to the Sprite2D menu that appears above the viewport, and choose Create Polygon2D Sibling.

Performance: ConvexPolygonShape2D is faster to check collisions against compared to ConcavePolygonShape2D, but it is slower than primitive collision shapes such as CircleShape2D and RectangleShape2D. Its use should generally be limited to medium-sized objects that cannot have their collision accurately represented by primitive shapes.

## Properties

PackedVector2Array | points | PackedVector2Array()

## Methods

void | set_point_cloud(point_cloud: PackedVector2Array)

---

## Property Descriptions

PackedVector2Array points = PackedVector2Array() 

- void set_points(value: PackedVector2Array)
- PackedVector2Array get_points()

The polygon's list of vertices that form a convex hull. Can be in either clockwise or counterclockwise order.

Warning: Only set this property to a list of points that actually form a convex hull. Use set_point_cloud() to generate the convex hull of an arbitrary set of points.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

## Method Descriptions

void set_point_cloud(point_cloud: PackedVector2Array) 

Based on the set of points provided, this assigns the points property using the convex hull algorithm, removing all unneeded points. See Geometry2D.convex_hull() for details.
