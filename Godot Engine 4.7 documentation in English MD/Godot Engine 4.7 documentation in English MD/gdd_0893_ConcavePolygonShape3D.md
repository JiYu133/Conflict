# ConcavePolygonShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D trimesh shape used for physics collision.

## Description

A 3D trimesh shape, intended for use in physics. Usually used to provide a shape for a CollisionShape3D.

Being just a collection of interconnected triangles, ConcavePolygonShape3D is the most freely configurable single 3D shape. It can be used to form polyhedra of any nature, or even shapes that don't enclose a volume. However, ConcavePolygonShape3D is hollow even if the interconnected triangles do enclose a volume, which often makes it unsuitable for physics or detection.

Note: When used for collision, ConcavePolygonShape3D is intended to work with static CollisionShape3D nodes like StaticBody3D and will likely not behave well for CharacterBody3Ds or RigidBody3Ds in a mode other than Static.

Warning: Physics bodies that are small have a chance to clip through this shape when moving fast. This happens because on one frame, the physics body may be on the "outside" of the shape, and on the next frame it may be "inside" it. ConcavePolygonShape3D is hollow, so it won't detect a collision.

Performance: Due to its complexity, ConcavePolygonShape3D is the slowest 3D collision shape to check collisions against. Its use should generally be limited to level geometry. For convex geometry, ConvexPolygonShape3D should be used. For dynamic physics bodies that need concave collision, several ConvexPolygonShape3Ds can be used to represent its collision by using convex decomposition; see ConvexPolygonShape3D's documentation for instructions.

## Tutorials

- 3D Physics Tests Demo [https://godotengine.org/asset-library/asset/2747]

## Properties

bool | backface_collision | false

## Methods

PackedVector3Array | get_faces() const
void | set_faces(faces: PackedVector3Array)

---

## Property Descriptions

bool backface_collision = false 

- void set_backface_collision_enabled(value: bool)
- bool is_backface_collision_enabled()

If set to true, collisions occur on both sides of the concave shape faces. Otherwise they occur only along the face normals.

---

## Method Descriptions

PackedVector3Array get_faces() const 

Returns the faces of the trimesh shape as an array of vertices. The array (of length divisible by three) is naturally divided into triples; each triple of vertices defines a triangle.

---

void set_faces(faces: PackedVector3Array) 

Sets the faces of the trimesh shape from an array of vertices. The faces array should be composed of triples such that each triple of vertices defines a triangle.
