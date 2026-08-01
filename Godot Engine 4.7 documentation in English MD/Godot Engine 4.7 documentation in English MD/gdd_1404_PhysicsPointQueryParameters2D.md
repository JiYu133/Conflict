# PhysicsPointQueryParameters2D

Inherits: RefCounted < Object

Provides parameters for PhysicsDirectSpaceState2D.intersect_point().

## Description

By changing various properties of this object, such as the point position, you can configure the parameters for PhysicsDirectSpaceState2D.intersect_point().

## Properties

int | canvas_instance_id | 0
bool | collide_with_areas | false
bool | collide_with_bodies | true
int | collision_mask | 4294967295
Array[RID] | exclude | []
Vector2 | position | Vector2(0, 0)

---

## Property Descriptions

int canvas_instance_id = 0 

- void set_canvas_instance_id(value: int)
- int get_canvas_instance_id()

If different from 0, restricts the query to a specific canvas layer specified by its instance ID. See Object.get_instance_id().

If 0, restricts the query to the Viewport's default canvas layer.

---

bool collide_with_areas = false 

- void set_collide_with_areas(value: bool)
- bool is_collide_with_areas_enabled()

If true, the query will take Area2Ds into account.

---

bool collide_with_bodies = true 

- void set_collide_with_bodies(value: bool)
- bool is_collide_with_bodies_enabled()

If true, the query will take PhysicsBody2Ds into account.

---

int collision_mask = 4294967295 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers the query will detect (as a bitmask). By default, all collision layers are detected. See Collision layers and masks in the documentation for more information.

---

Array[RID] exclude = [] 

- void set_exclude(value: Array[RID])
- Array[RID] get_exclude()

The list of object RIDs that will be excluded from collisions. Use CollisionObject2D.get_rid() to get the RID associated with a CollisionObject2D-derived node.

Note: The returned array is copied and any changes to it will not update the original property value. To update the value you need to modify the returned array, and then assign it to the property again.

---

Vector2 position = Vector2(0, 0) 

- void set_position(value: Vector2)
- Vector2 get_position()

The position being queried for, in global coordinates.
