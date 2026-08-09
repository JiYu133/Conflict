# PhysicsTestMotionParameters2D

Inherits: RefCounted < Object

Provides parameters for PhysicsServer2D.body_test_motion().

## Description

By changing various properties of this object, such as the motion, you can configure the parameters for PhysicsServer2D.body_test_motion().

## Properties

bool | collide_separation_ray | false
Array[RID] | exclude_bodies | []
Array[int] | exclude_objects | []
Transform2D | from | Transform2D(1, 0, 0, 1, 0, 0)
float | margin | 0.08
Vector2 | motion | Vector2(0, 0)
bool | recovery_as_collision | false

---

## Property Descriptions

bool collide_separation_ray = false 

- void set_collide_separation_ray_enabled(value: bool)
- bool is_collide_separation_ray_enabled()

If set to true, shapes of type PhysicsServer2D.SHAPE_SEPARATION_RAY are used to detect collisions and can stop the motion. Can be useful when snapping to the ground.

If set to false, shapes of type PhysicsServer2D.SHAPE_SEPARATION_RAY are only used for separation when overlapping with other bodies. That's the main use for separation ray shapes.

---

Array[RID] exclude_bodies = [] 

- void set_exclude_bodies(value: Array[RID])
- Array[RID] get_exclude_bodies()

Optional array of body RID to exclude from collision. Use CollisionObject2D.get_rid() to get the RID associated with a CollisionObject2D-derived node.

---

Array[int] exclude_objects = [] 

- void set_exclude_objects(value: Array[int])
- Array[int] get_exclude_objects()

Optional array of object unique instance ID to exclude from collision. See Object.get_instance_id().

---

Transform2D from = Transform2D(1, 0, 0, 1, 0, 0) 

- void set_from(value: Transform2D)
- Transform2D get_from()

Transform in global space where the motion should start. Usually set to Node2D.global_transform for the current body's transform.

---

float margin = 0.08 

- void set_margin(value: float)
- float get_margin()

Increases the size of the shapes involved in the collision detection.

---

Vector2 motion = Vector2(0, 0) 

- void set_motion(value: Vector2)
- Vector2 get_motion()

Motion vector to define the length and direction of the motion to test.

---

bool recovery_as_collision = false 

- void set_recovery_as_collision_enabled(value: bool)
- bool is_recovery_as_collision_enabled()

If set to true, any depenetration from the recovery phase is reported as a collision; this is used e.g. by CharacterBody2D for improving floor detection during floor snapping.

If set to false, only collisions resulting from the motion are reported, which is generally the desired behavior.
