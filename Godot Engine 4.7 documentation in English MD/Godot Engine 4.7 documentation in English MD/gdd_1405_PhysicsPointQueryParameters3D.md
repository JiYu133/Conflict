# PhysicsPointQueryParameters3D

Inherits: RefCounted < Object

Provides parameters for PhysicsDirectSpaceState3D.intersect_point().

## Description

By changing various properties of this object, such as the point position, you can configure the parameters for PhysicsDirectSpaceState3D.intersect_point().

## Properties

bool | collide_with_areas | false
bool | collide_with_bodies | true
int | collision_mask | 4294967295
Array[RID] | exclude | []
Vector3 | position | Vector3(0, 0, 0)

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

Vector3 position = Vector3(0, 0, 0) 

- void set_position(value: Vector3)
- Vector3 get_position()

The position being queried for, in global coordinates.
