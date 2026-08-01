# PhysicsShapeQueryParameters3D

Inherits: RefCounted < Object

Provides parameters for PhysicsDirectSpaceState3D's methods.

## Description

By changing various properties of this object, such as the shape, you can configure the parameters for PhysicsDirectSpaceState3D's methods.

## Properties

bool | collide_with_areas | false
bool | collide_with_bodies | true
int | collision_mask | 4294967295
Array[RID] | exclude | []
float | margin | 0.0
Vector3 | motion | Vector3(0, 0, 0)
Resource | shape |
RID | shape_rid | RID()
Transform3D | transform | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

---

## Property Descriptions

bool collide_with_areas = false 

- void set_collide_with_areas(value: bool)
- bool is_collide_with_areas_enabled()

If true, the query will take Area3Ds into account.

---

bool collide_with_bodies = true 

- void set_collide_with_bodies(value: bool)
- bool is_collide_with_bodies_enabled()

If true, the query will take PhysicsBody3Ds into account.

---

int collision_mask = 4294967295 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers the query will detect (as a bitmask). By default, all collision layers are detected. See Collision layers and masks in the documentation for more information.

---

Array[RID] exclude = [] 

- void set_exclude(value: Array[RID])
- Array[RID] get_exclude()

The list of object RIDs that will be excluded from collisions. Use CollisionObject3D.get_rid() to get the RID associated with a CollisionObject3D-derived node.

Note: The returned array is copied and any changes to it will not update the original property value. To update the value you need to modify the returned array, and then assign it to the property again.

---

float margin = 0.0 

- void set_margin(value: float)
- float get_margin()

The collision margin for the shape.

---

Vector3 motion = Vector3(0, 0, 0) 

- void set_motion(value: Vector3)
- Vector3 get_motion()

The motion of the shape being queried for.

---

Resource shape 

- void set_shape(value: Resource)
- Resource get_shape()

The Shape3D that will be used for collision/intersection queries. This stores the actual reference which avoids the shape to be released while being used for queries, so always prefer using this over shape_rid.

---

RID shape_rid = RID() 

- void set_shape_rid(value: RID)
- RID get_shape_rid()

The queried shape's RID that will be used for collision/intersection queries. Use this over shape if you want to optimize for performance using the Servers API:

```
var shape_rid = PhysicsServer3D.sphere_shape_create()
var radius = 2.0
PhysicsServer3D.shape_set_data(shape_rid, radius)
var params = PhysicsShapeQueryParameters3D.new()
params.shape_rid = shape_rid
# Execute physics queries here...
# Release the shape when done with physics queries.
PhysicsServer3D.free_rid(shape_rid)
```

```
RID shapeRid = PhysicsServer3D.SphereShapeCreate();
float radius = 2.0f;
PhysicsServer3D.ShapeSetData(shapeRid, radius);
var params = new PhysicsShapeQueryParameters3D();
params.ShapeRid = shapeRid;
// Execute physics queries here...
// Release the shape when done with physics queries.
PhysicsServer3D.FreeRid(shapeRid);
```

---

Transform3D transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_transform(value: Transform3D)
- Transform3D get_transform()

The queried shape's transform matrix.
