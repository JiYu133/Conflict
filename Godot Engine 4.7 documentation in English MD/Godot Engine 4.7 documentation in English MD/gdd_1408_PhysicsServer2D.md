# PhysicsServer2D

Inherits: Object

Inherited By: PhysicsServer2DExtension

A server interface for low-level 2D physics access.

## Description

PhysicsServer2D is the server responsible for all 2D physics. It can directly create and manipulate all physics objects:

- A space is a self-contained world for a physics simulation. It contains bodies, areas, and joints. Its state can be queried for collision and intersection information, and several parameters of the simulation can be modified.
- A shape is a geometric shape such as a circle, a rectangle, a capsule, or a polygon. It can be used for collision detection by adding it to a body/area, possibly with an extra transformation relative to the body/area's origin. Bodies/areas can have multiple (transformed) shapes added to them, and a single shape can be added to bodies/areas multiple times with different local transformations.
- A body is a physical object which can be in static, kinematic, or rigid mode. Its state (such as position and velocity) can be queried and updated. A force integration callback can be set to customize the body's physics.
- An area is a region in space which can be used to detect bodies and areas entering and exiting it. A body monitoring callback can be set to report entering/exiting body shapes, and similarly an area monitoring callback can be set. Gravity and damping can be overridden within the area by setting area parameters.
- A joint is a constraint, either between two bodies or on one body relative to a point. Parameters such as the joint bias and the rest length of a spring joint can be adjusted.

Physics objects in PhysicsServer2D may be created and manipulated independently; they do not have to be tied to nodes in the scene tree.

Note: All the 2D physics nodes use the physics server internally. Adding a physics node to the scene tree will cause a corresponding physics object to be created in the physics server. A rigid body node registers a callback that updates the node's transform with the transform of the respective body object in the physics server (every physics update). An area node registers a callback to inform the area node about overlaps with the respective area object in the physics server. The raycast node queries the direct state of the relevant space in the physics server.

## Methods

void | area_add_shape(area: RID, shape: RID, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), disabled: bool = false)
void | area_attach_canvas_instance_id(area: RID, id: int)
void | area_attach_object_instance_id(area: RID, id: int)
void | area_clear_shapes(area: RID)
RID | area_create()
int | area_get_canvas_instance_id(area: RID) const
int | area_get_collision_layer(area: RID) const
int | area_get_collision_mask(area: RID) const
int | area_get_object_instance_id(area: RID) const
Variant | area_get_param(area: RID, param: AreaParameter) const
RID | area_get_shape(area: RID, shape_idx: int) const
int | area_get_shape_count(area: RID) const
Transform2D | area_get_shape_transform(area: RID, shape_idx: int) const
RID | area_get_space(area: RID) const
Transform2D | area_get_transform(area: RID) const
void | area_remove_shape(area: RID, shape_idx: int)
void | area_set_area_monitor_callback(area: RID, callback: Callable)
void | area_set_collision_layer(area: RID, layer: int)
void | area_set_collision_mask(area: RID, mask: int)
void | area_set_monitor_callback(area: RID, callback: Callable)
void | area_set_monitorable(area: RID, monitorable: bool)
void | area_set_param(area: RID, param: AreaParameter, value: Variant)
void | area_set_shape(area: RID, shape_idx: int, shape: RID)
void | area_set_shape_disabled(area: RID, shape_idx: int, disabled: bool)
void | area_set_shape_transform(area: RID, shape_idx: int, transform: Transform2D)
void | area_set_space(area: RID, space: RID)
void | area_set_transform(area: RID, transform: Transform2D)
void | body_add_collision_exception(body: RID, excepted_body: RID)
void | body_add_constant_central_force(body: RID, force: Vector2)
void | body_add_constant_force(body: RID, force: Vector2, position: Vector2 = Vector2(0, 0))
void | body_add_constant_torque(body: RID, torque: float)
void | body_add_shape(body: RID, shape: RID, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), disabled: bool = false)
void | body_apply_central_force(body: RID, force: Vector2)
void | body_apply_central_impulse(body: RID, impulse: Vector2)
void | body_apply_force(body: RID, force: Vector2, position: Vector2 = Vector2(0, 0))
void | body_apply_impulse(body: RID, impulse: Vector2, position: Vector2 = Vector2(0, 0))
void | body_apply_torque(body: RID, torque: float)
void | body_apply_torque_impulse(body: RID, impulse: float)
void | body_attach_canvas_instance_id(body: RID, id: int)
void | body_attach_object_instance_id(body: RID, id: int)
void | body_clear_shapes(body: RID)
RID | body_create()
int | body_get_canvas_instance_id(body: RID) const
int | body_get_collision_layer(body: RID) const
int | body_get_collision_mask(body: RID) const
float | body_get_collision_priority(body: RID) const
Vector2 | body_get_constant_force(body: RID) const
float | body_get_constant_torque(body: RID) const
CCDMode | body_get_continuous_collision_detection_mode(body: RID) const
PhysicsDirectBodyState2D | body_get_direct_state(body: RID)
int | body_get_max_contacts_reported(body: RID) const
BodyMode | body_get_mode(body: RID) const
int | body_get_object_instance_id(body: RID) const
Variant | body_get_param(body: RID, param: BodyParameter) const
RID | body_get_shape(body: RID, shape_idx: int) const
int | body_get_shape_count(body: RID) const
Transform2D | body_get_shape_transform(body: RID, shape_idx: int) const
RID | body_get_space(body: RID) const
Variant | body_get_state(body: RID, state: BodyState) const
bool | body_is_omitting_force_integration(body: RID) const
void | body_remove_collision_exception(body: RID, excepted_body: RID)
void | body_remove_shape(body: RID, shape_idx: int)
void | body_reset_mass_properties(body: RID)
void | body_set_axis_velocity(body: RID, axis_velocity: Vector2)
void | body_set_collision_layer(body: RID, layer: int)
void | body_set_collision_mask(body: RID, mask: int)
void | body_set_collision_priority(body: RID, priority: float)
void | body_set_constant_force(body: RID, force: Vector2)
void | body_set_constant_torque(body: RID, torque: float)
void | body_set_continuous_collision_detection_mode(body: RID, mode: CCDMode)
void | body_set_force_integration_callback(body: RID, callable: Callable, userdata: Variant = null)
void | body_set_max_contacts_reported(body: RID, amount: int)
void | body_set_mode(body: RID, mode: BodyMode)
void | body_set_omit_force_integration(body: RID, enable: bool)
void | body_set_param(body: RID, param: BodyParameter, value: Variant)
void | body_set_shape(body: RID, shape_idx: int, shape: RID)
void | body_set_shape_as_one_way_collision(body: RID, shape_idx: int, enable: bool, margin: float, direction: Vector2 = Vector2(0, 1))
void | body_set_shape_disabled(body: RID, shape_idx: int, disabled: bool)
void | body_set_shape_transform(body: RID, shape_idx: int, transform: Transform2D)
void | body_set_space(body: RID, space: RID)
void | body_set_state(body: RID, state: BodyState, value: Variant)
void | body_set_state_sync_callback(body: RID, callable: Callable)
bool | body_test_motion(body: RID, parameters: PhysicsTestMotionParameters2D, result: PhysicsTestMotionResult2D = null)
RID | capsule_shape_create()
RID | circle_shape_create()
RID | concave_polygon_shape_create()
RID | convex_polygon_shape_create()
float | damped_spring_joint_get_param(joint: RID, param: DampedSpringParam) const
void | damped_spring_joint_set_param(joint: RID, param: DampedSpringParam, value: float)
void | free_rid(rid: RID)
int | get_process_info(process_info: ProcessInfo)
void | joint_clear(joint: RID)
RID | joint_create()
void | joint_disable_collisions_between_bodies(joint: RID, disable: bool)
float | joint_get_param(joint: RID, param: JointParam) const
JointType | joint_get_type(joint: RID) const
bool | joint_is_disabled_collisions_between_bodies(joint: RID) const
void | joint_make_damped_spring(joint: RID, anchor_a: Vector2, anchor_b: Vector2, body_a: RID, body_b: RID = RID())
void | joint_make_groove(joint: RID, groove1_a: Vector2, groove2_a: Vector2, anchor_b: Vector2, body_a: RID = RID(), body_b: RID = RID())
void | joint_make_pin(joint: RID, anchor: Vector2, body_a: RID, body_b: RID = RID())
void | joint_set_param(joint: RID, param: JointParam, value: float)
bool | pin_joint_get_flag(joint: RID, flag: PinJointFlag) const
float | pin_joint_get_param(joint: RID, param: PinJointParam) const
void | pin_joint_set_flag(joint: RID, flag: PinJointFlag, enabled: bool)
void | pin_joint_set_param(joint: RID, param: PinJointParam, value: float)
RID | rectangle_shape_create()
RID | segment_shape_create()
RID | separation_ray_shape_create()
void | set_active(active: bool)
Variant | shape_get_data(shape: RID) const
ShapeType | shape_get_type(shape: RID) const
void | shape_set_data(shape: RID, data: Variant)
RID | space_create()
PhysicsDirectSpaceState2D | space_get_direct_state(space: RID)
float | space_get_param(space: RID, param: SpaceParameter) const
bool | space_is_active(space: RID) const
void | space_set_active(space: RID, active: bool)
void | space_set_param(space: RID, param: SpaceParameter, value: float)
RID | world_boundary_shape_create()

---

## Enumerations

enum SpaceParameter
SpaceParameter SPACE_PARAM_CONTACT_RECYCLE_RADIUS = 0

Constant to set/get the maximum distance a pair of bodies has to move before their collision status has to be recalculated. The default value of this parameter is ProjectSettings.physics/2d/solver/contact_recycle_radius.

SpaceParameter SPACE_PARAM_CONTACT_MAX_SEPARATION = 1

Constant to set/get the maximum distance a shape can be from another before they are considered separated and the contact is discarded. The default value of this parameter is ProjectSettings.physics/2d/solver/contact_max_separation.

SpaceParameter SPACE_PARAM_CONTACT_MAX_ALLOWED_PENETRATION = 2

Constant to set/get the maximum distance a shape can penetrate another shape before it is considered a collision. The default value of this parameter is ProjectSettings.physics/2d/solver/contact_max_allowed_penetration.

SpaceParameter SPACE_PARAM_CONTACT_DEFAULT_BIAS = 3

Constant to set/get the default solver bias for all physics contacts. A solver bias is a factor controlling how much two objects "rebound", after overlapping, to avoid leaving them in that state because of numerical imprecision. The default value of this parameter is ProjectSettings.physics/2d/solver/default_contact_bias.

SpaceParameter SPACE_PARAM_BODY_LINEAR_VELOCITY_SLEEP_THRESHOLD = 4

Constant to set/get the threshold linear velocity of activity. A body marked as potentially inactive for both linear and angular velocity will be put to sleep after the time given. The default value of this parameter is ProjectSettings.physics/2d/sleep_threshold_linear.

SpaceParameter SPACE_PARAM_BODY_ANGULAR_VELOCITY_SLEEP_THRESHOLD = 5

Constant to set/get the threshold angular velocity of activity. A body marked as potentially inactive for both linear and angular velocity will be put to sleep after the time given. The default value of this parameter is ProjectSettings.physics/2d/sleep_threshold_angular.

SpaceParameter SPACE_PARAM_BODY_TIME_TO_SLEEP = 6

Constant to set/get the maximum time of activity. A body marked as potentially inactive for both linear and angular velocity will be put to sleep after this time. The default value of this parameter is ProjectSettings.physics/2d/time_before_sleep.

SpaceParameter SPACE_PARAM_CONSTRAINT_DEFAULT_BIAS = 7

Constant to set/get the default solver bias for all physics constraints. A solver bias is a factor controlling how much two objects "rebound", after violating a constraint, to avoid leaving them in that state because of numerical imprecision. The default value of this parameter is ProjectSettings.physics/2d/solver/default_constraint_bias.

SpaceParameter SPACE_PARAM_SOLVER_ITERATIONS = 8

Constant to set/get the number of solver iterations for all contacts and constraints. The greater the number of iterations, the more accurate the collisions will be. However, a greater number of iterations requires more CPU power, which can decrease performance. The default value of this parameter is ProjectSettings.physics/2d/solver/solver_iterations.

---

enum ShapeType
ShapeType SHAPE_WORLD_BOUNDARY = 0

This is the constant for creating world boundary shapes. A world boundary shape is an infinite line with an origin point, and a normal. Thus, it can be used for front/behind checks.

ShapeType SHAPE_SEPARATION_RAY = 1

This is the constant for creating separation ray shapes. A separation ray is defined by a length and separates itself from what is touching its far endpoint. Useful for character controllers.

ShapeType SHAPE_SEGMENT = 2

This is the constant for creating segment shapes. A segment shape is a finite line from a point A to a point B. It can be checked for intersections.

ShapeType SHAPE_CIRCLE = 3

This is the constant for creating circle shapes. A circle shape only has a radius. It can be used for intersections and inside/outside checks.

ShapeType SHAPE_RECTANGLE = 4

This is the constant for creating rectangle shapes. A rectangle shape is defined by a width and a height. It can be used for intersections and inside/outside checks.

ShapeType SHAPE_CAPSULE = 5

This is the constant for creating capsule shapes. A capsule shape is defined by a radius and a length. It can be used for intersections and inside/outside checks.

ShapeType SHAPE_CONVEX_POLYGON = 6

This is the constant for creating convex polygon shapes. A polygon is defined by a list of points. It can be used for intersections and inside/outside checks.

ShapeType SHAPE_CONCAVE_POLYGON = 7

This is the constant for creating concave polygon shapes. A polygon is defined by a list of points. It can be used for intersections checks, but not for inside/outside checks.

ShapeType SHAPE_CUSTOM = 8

This constant is used internally by the engine. Any attempt to create this kind of shape results in an error.

---

enum AreaParameter
AreaParameter AREA_PARAM_GRAVITY_OVERRIDE_MODE = 0

Constant to set/get gravity override mode in an area. See AreaSpaceOverrideMode for possible values. The default value of this parameter is AREA_SPACE_OVERRIDE_DISABLED.

AreaParameter AREA_PARAM_GRAVITY = 1

Constant to set/get gravity strength in an area. The default value of this parameter is 9.80665.

AreaParameter AREA_PARAM_GRAVITY_VECTOR = 2

Constant to set/get gravity vector/center in an area. The default value of this parameter is Vector2(0, -1).

AreaParameter AREA_PARAM_GRAVITY_IS_POINT = 3

Constant to set/get whether the gravity vector of an area is a direction, or a center point. The default value of this parameter is false.

AreaParameter AREA_PARAM_GRAVITY_POINT_UNIT_DISTANCE = 4

Constant to set/get the distance at which the gravity strength is equal to the gravity controlled by AREA_PARAM_GRAVITY. For example, on a planet 100 pixels in radius with a surface gravity of 4.0 px/s², set the gravity to 4.0 and the unit distance to 100.0. The gravity will have falloff according to the inverse square law, so in the example, at 200 pixels from the center the gravity will be 1.0 px/s² (twice the distance, 1/4th the gravity), at 50 pixels it will be 16.0 px/s² (half the distance, 4x the gravity), and so on.

The above is true only when the unit distance is a positive number. When the unit distance is set to 0.0, the gravity will be constant regardless of distance. The default value of this parameter is 0.0.

AreaParameter AREA_PARAM_LINEAR_DAMP_OVERRIDE_MODE = 5

Constant to set/get linear damping override mode in an area. See AreaSpaceOverrideMode for possible values. The default value of this parameter is AREA_SPACE_OVERRIDE_DISABLED.

AreaParameter AREA_PARAM_LINEAR_DAMP = 6

Constant to set/get the linear damping factor of an area. The default value of this parameter is 0.1.

AreaParameter AREA_PARAM_ANGULAR_DAMP_OVERRIDE_MODE = 7

Constant to set/get angular damping override mode in an area. See AreaSpaceOverrideMode for possible values. The default value of this parameter is AREA_SPACE_OVERRIDE_DISABLED.

AreaParameter AREA_PARAM_ANGULAR_DAMP = 8

Constant to set/get the angular damping factor of an area. The default value of this parameter is 1.0.

AreaParameter AREA_PARAM_PRIORITY = 9

Constant to set/get the priority (order of processing) of an area. The default value of this parameter is 0.

---

enum AreaSpaceOverrideMode
AreaSpaceOverrideMode AREA_SPACE_OVERRIDE_DISABLED = 0

This area does not affect gravity/damp. These are generally areas that exist only to detect collisions, and objects entering or exiting them.

AreaSpaceOverrideMode AREA_SPACE_OVERRIDE_COMBINE = 1

This area adds its gravity/damp values to whatever has been calculated so far. This way, many overlapping areas can combine their physics to make interesting effects.

AreaSpaceOverrideMode AREA_SPACE_OVERRIDE_COMBINE_REPLACE = 2

This area adds its gravity/damp values to whatever has been calculated so far. Then stops taking into account the rest of the areas, even the default one.

AreaSpaceOverrideMode AREA_SPACE_OVERRIDE_REPLACE = 3

This area replaces any gravity/damp, even the default one, and stops taking into account the rest of the areas.

AreaSpaceOverrideMode AREA_SPACE_OVERRIDE_REPLACE_COMBINE = 4

This area replaces any gravity/damp calculated so far, but keeps calculating the rest of the areas, down to the default one.

---

enum BodyMode
BodyMode BODY_MODE_STATIC = 0

Constant for static bodies. In this mode, a body can be only moved by user code and doesn't collide with other bodies along its path when moved.

BodyMode BODY_MODE_KINEMATIC = 1

Constant for kinematic bodies. In this mode, a body can be only moved by user code and collides with other bodies along its path.

BodyMode BODY_MODE_RIGID = 2

Constant for rigid bodies. In this mode, a body can be pushed by other bodies and has forces applied.

BodyMode BODY_MODE_RIGID_LINEAR = 3

Constant for linear rigid bodies. In this mode, a body can not rotate, and only its linear velocity is affected by external forces.

---

enum BodyParameter
BodyParameter BODY_PARAM_BOUNCE = 0

Constant to set/get a body's bounce factor. The default value of this parameter is 0.0.

BodyParameter BODY_PARAM_FRICTION = 1

Constant to set/get a body's friction. The default value of this parameter is 1.0.

BodyParameter BODY_PARAM_MASS = 2

Constant to set/get a body's mass. The default value of this parameter is 1.0. If the body's mode is set to BODY_MODE_RIGID, then setting this parameter will have the following additional effects:

- If the parameter BODY_PARAM_CENTER_OF_MASS has never been set explicitly, then the value of that parameter will be recalculated based on the body's shapes.
- If the parameter BODY_PARAM_INERTIA is set to a value <= 0.0, then the value of that parameter will be recalculated based on the body's shapes, mass, and center of mass.

BodyParameter BODY_PARAM_INERTIA = 3

Constant to set/get a body's inertia. The default value of this parameter is 0.0. If the body's inertia is set to a value <= 0.0, then the inertia will be recalculated based on the body's shapes, mass, and center of mass.

BodyParameter BODY_PARAM_CENTER_OF_MASS = 4

Constant to set/get a body's center of mass position in the body's local coordinate system. The default value of this parameter is Vector2(0, 0). If this parameter is never set explicitly, then it is recalculated based on the body's shapes when setting the parameter BODY_PARAM_MASS or when calling body_set_space().

BodyParameter BODY_PARAM_GRAVITY_SCALE = 5

Constant to set/get a body's gravity multiplier. The default value of this parameter is 1.0.

BodyParameter BODY_PARAM_LINEAR_DAMP_MODE = 6

Constant to set/get a body's linear damping mode. See BodyDampMode for possible values. The default value of this parameter is BODY_DAMP_MODE_COMBINE.

BodyParameter BODY_PARAM_ANGULAR_DAMP_MODE = 7

Constant to set/get a body's angular damping mode. See BodyDampMode for possible values. The default value of this parameter is BODY_DAMP_MODE_COMBINE.

BodyParameter BODY_PARAM_LINEAR_DAMP = 8

Constant to set/get a body's linear damping factor. The default value of this parameter is 0.0.

BodyParameter BODY_PARAM_ANGULAR_DAMP = 9

Constant to set/get a body's angular damping factor. The default value of this parameter is 0.0.

BodyParameter BODY_PARAM_MAX = 10

Represents the size of the BodyParameter enum.

---

enum BodyDampMode
BodyDampMode BODY_DAMP_MODE_COMBINE = 0

The body's damping value is added to any value set in areas or the default value.

BodyDampMode BODY_DAMP_MODE_REPLACE = 1

The body's damping value replaces any value set in areas or the default value.

---

enum BodyState
BodyState BODY_STATE_TRANSFORM = 0

Constant to set/get the current transform matrix of the body.

BodyState BODY_STATE_LINEAR_VELOCITY = 1

Constant to set/get the current linear velocity of the body.

BodyState BODY_STATE_ANGULAR_VELOCITY = 2

Constant to set/get the current angular velocity of the body.

BodyState BODY_STATE_SLEEPING = 3

Constant to sleep/wake up a body, or to get whether it is sleeping.

BodyState BODY_STATE_CAN_SLEEP = 4

Constant to set/get whether the body can sleep.

---

enum JointType
JointType JOINT_TYPE_PIN = 0

Constant to create pin joints.

JointType JOINT_TYPE_GROOVE = 1

Constant to create groove joints.

JointType JOINT_TYPE_DAMPED_SPRING = 2

Constant to create damped spring joints.

JointType JOINT_TYPE_MAX = 3

Represents the size of the JointType enum.

---

enum JointParam
JointParam JOINT_PARAM_BIAS = 0

Constant to set/get how fast the joint pulls the bodies back to satisfy the joint constraint. The lower the value, the more the two bodies can pull on the joint. The default value of this parameter is 0.0.

Note: In Godot Physics, this parameter is only used for pin joints and groove joints.

JointParam JOINT_PARAM_MAX_BIAS = 1

Constant to set/get the maximum speed with which the joint can apply corrections. The default value of this parameter is 3.40282e+38.

Note: In Godot Physics, this parameter is only used for groove joints.

JointParam JOINT_PARAM_MAX_FORCE = 2

Constant to set/get the maximum force that the joint can use to act on the two bodies. The default value of this parameter is 3.40282e+38.

Note: In Godot Physics, this parameter is only used for groove joints.

---

enum PinJointParam
PinJointParam PIN_JOINT_SOFTNESS = 0

Constant to set/get a how much the bond of the pin joint can flex. The default value of this parameter is 0.0.

PinJointParam PIN_JOINT_LIMIT_UPPER = 1

The maximum rotation around the pin.

PinJointParam PIN_JOINT_LIMIT_LOWER = 2

The minimum rotation around the pin.

PinJointParam PIN_JOINT_MOTOR_TARGET_VELOCITY = 3

Target speed for the motor. In radians per second.

---

enum PinJointFlag
PinJointFlag PIN_JOINT_FLAG_ANGULAR_LIMIT_ENABLED = 0

If true, the pin has a maximum and a minimum rotation.

PinJointFlag PIN_JOINT_FLAG_MOTOR_ENABLED = 1

If true, a motor turns the pin.

---

enum DampedSpringParam
DampedSpringParam DAMPED_SPRING_REST_LENGTH = 0

Sets the resting length of the spring joint. The joint will always try to go to back this length when pulled apart. The default value of this parameter is the distance between the joint's anchor points.

DampedSpringParam DAMPED_SPRING_STIFFNESS = 1

Sets the stiffness of the spring joint. The joint applies a force equal to the stiffness times the distance from its resting length. The default value of this parameter is 20.0.

DampedSpringParam DAMPED_SPRING_DAMPING = 2

Sets the damping ratio of the spring joint. A value of 0 indicates an undamped spring, while 1 causes the system to reach equilibrium as fast as possible (critical damping). The default value of this parameter is 1.5.

---

enum CCDMode
CCDMode CCD_MODE_DISABLED = 0

Disables continuous collision detection. This is the fastest way to detect body collisions, but it can miss small and/or fast-moving objects.

CCDMode CCD_MODE_CAST_RAY = 1

Enables continuous collision detection by raycasting. It is faster than shapecasting, but less precise.

CCDMode CCD_MODE_CAST_SHAPE = 2

Enables continuous collision detection by shapecasting. It is the slowest CCD method, and the most precise.

---

enum AreaBodyStatus
AreaBodyStatus AREA_BODY_ADDED = 0

The value of the first parameter and area callback function receives, when an object enters one of its shapes.

AreaBodyStatus AREA_BODY_REMOVED = 1

The value of the first parameter and area callback function receives, when an object exits one of its shapes.

---

enum ProcessInfo
ProcessInfo INFO_ACTIVE_OBJECTS = 0

Constant to get the number of objects that are not sleeping.

ProcessInfo INFO_COLLISION_PAIRS = 1

Constant to get the number of possible collisions.

ProcessInfo INFO_ISLAND_COUNT = 2

Constant to get the number of space regions where a collision could occur.

---

## Method Descriptions

void area_add_shape(area: RID, shape: RID, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), disabled: bool = false) 

Adds a shape to the area, with the given local transform. The shape (together with its transform and disabled properties) is added to an array of shapes, and the shapes of an area are usually referenced by their index in this array.

---

void area_attach_canvas_instance_id(area: RID, id: int) 

Attaches the ObjectID of a canvas to the area. Use Object.get_instance_id() to get the ObjectID of a CanvasLayer.

---

void area_attach_object_instance_id(area: RID, id: int) 

Attaches the ObjectID of an Object to the area. Use Object.get_instance_id() to get the ObjectID of a CollisionObject2D.

---

void area_clear_shapes(area: RID) 

Removes all shapes from the area. This does not delete the shapes themselves, so they can continue to be used elsewhere or added back later.

---

RID area_create() 

Creates a 2D area object in the physics server, and returns the RID that identifies it. The default settings for the created area include a collision layer and mask set to 1, and monitorable set to false.

Use area_add_shape() to add shapes to it, use area_set_transform() to set its transform, and use area_set_space() to add the area to a space. If you want the area to be detectable use area_set_monitorable().

---

int area_get_canvas_instance_id(area: RID) const 

Returns the ObjectID of the canvas attached to the area. Use @GlobalScope.instance_from_id() to retrieve a CanvasLayer from a nonzero ObjectID.

---

int area_get_collision_layer(area: RID) const 

Returns the physics layer or layers the area belongs to, as a bitmask.

---

int area_get_collision_mask(area: RID) const 

Returns the physics layer or layers the area can contact with, as a bitmask.

---

int area_get_object_instance_id(area: RID) const 

Returns the ObjectID attached to the area. Use @GlobalScope.instance_from_id() to retrieve an Object from a nonzero ObjectID.

---

Variant area_get_param(area: RID, param: AreaParameter) const 

Returns the value of the given area parameter.

---

RID area_get_shape(area: RID, shape_idx: int) const 

Returns the RID of the shape with the given index in the area's array of shapes.

---

int area_get_shape_count(area: RID) const 

Returns the number of shapes added to the area.

---

Transform2D area_get_shape_transform(area: RID, shape_idx: int) const 

Returns the local transform matrix of the shape with the given index in the area's array of shapes.

---

RID area_get_space(area: RID) const 

Returns the RID of the space assigned to the area. Returns an empty RID if no space is assigned.

---

Transform2D area_get_transform(area: RID) const 

Returns the transform matrix of the area.

---

void area_remove_shape(area: RID, shape_idx: int) 

Removes the shape with the given index from the area's array of shapes. The shape itself is not deleted, so it can continue to be used elsewhere or added back later. As a result of this operation, the area's shapes which used to have indices higher than shape_idx will have their index decreased by one.

---

void area_set_area_monitor_callback(area: RID, callback: Callable) 

Sets the area's area monitor callback. This callback will be called when any other (shape of an) area enters or exits (a shape of) the given area, and must take the following five parameters:

1. an integer status: either AREA_BODY_ADDED or AREA_BODY_REMOVED depending on whether the other area's shape entered or exited the area,
2. an RID area_rid: the RID of the other area that entered or exited the area,
3. an integer instance_id: the ObjectID attached to the other area,
4. an integer area_shape_idx: the index of the shape of the other area that entered or exited the area,
5. an integer self_shape_idx: the index of the shape of the area where the other area entered or exited.

By counting (or keeping track of) the shapes that enter and exit, it can be determined if an area (with all its shapes) is entering for the first time or exiting for the last time.

---

void area_set_collision_layer(area: RID, layer: int) 

Assigns the area to one or many physics layers, via a bitmask.

---

void area_set_collision_mask(area: RID, mask: int) 

Sets which physics layers the area will monitor, via a bitmask.

---

void area_set_monitor_callback(area: RID, callback: Callable) 

Sets the area's body monitor callback. This callback will be called when any other (shape of a) body enters or exits (a shape of) the given area, and must take the following five parameters:

1. an integer status: either AREA_BODY_ADDED or AREA_BODY_REMOVED depending on whether the other body shape entered or exited the area,
2. an RID body_rid: the RID of the body that entered or exited the area,
3. an integer instance_id: the ObjectID attached to the body,
4. an integer body_shape_idx: the index of the shape of the body that entered or exited the area,
5. an integer self_shape_idx: the index of the shape of the area where the body entered or exited.

By counting (or keeping track of) the shapes that enter and exit, it can be determined if a body (with all its shapes) is entering for the first time or exiting for the last time.

---

void area_set_monitorable(area: RID, monitorable: bool) 

Sets whether the area is monitorable or not. If monitorable is true, the area monitoring callback of other areas will be called when this area enters or exits them.

---

void area_set_param(area: RID, param: AreaParameter, value: Variant) 

Sets the value of the given area parameter.

---

void area_set_shape(area: RID, shape_idx: int, shape: RID) 

Replaces the area's shape at the given index by another shape, while not affecting the transform and disabled properties at the same index.

---

void area_set_shape_disabled(area: RID, shape_idx: int, disabled: bool) 

Sets the disabled property of the area's shape with the given index. If disabled is true, then the shape will not detect any other shapes entering or exiting it.

---

void area_set_shape_transform(area: RID, shape_idx: int, transform: Transform2D) 

Sets the local transform matrix of the area's shape with the given index.

---

void area_set_space(area: RID, space: RID) 

Adds the area to the given space, after removing the area from the previously assigned space (if any).

Note: To remove an area from a space without immediately adding it back elsewhere, use PhysicsServer2D.area_set_space(area, RID()).

---

void area_set_transform(area: RID, transform: Transform2D) 

Sets the transform matrix of the area.

---

void body_add_collision_exception(body: RID, excepted_body: RID) 

Adds excepted_body to the body's list of collision exceptions, so that collisions with it are ignored.

---

void body_add_constant_central_force(body: RID, force: Vector2) 

Adds a constant directional force to the body. The force does not affect rotation. The force remains applied over time until cleared with PhysicsServer2D.body_set_constant_force(body, Vector2(0, 0)).

This is equivalent to using body_add_constant_force() at the body's center of mass.

---

void body_add_constant_force(body: RID, force: Vector2, position: Vector2 = Vector2(0, 0)) 

Adds a constant positioned force to the body. The force can affect rotation if position is different from the body's center of mass. The force remains applied over time until cleared with PhysicsServer2D.body_set_constant_force(body, Vector2(0, 0)).

position is the offset from the body origin in global coordinates.

---

void body_add_constant_torque(body: RID, torque: float) 

Adds a constant rotational force to the body. The force does not affect position. The force remains applied over time until cleared with PhysicsServer2D.body_set_constant_torque(body, 0).

---

void body_add_shape(body: RID, shape: RID, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), disabled: bool = false) 

Adds a shape to the area, with the given local transform. The shape (together with its transform and disabled properties) is added to an array of shapes, and the shapes of a body are usually referenced by their index in this array.

---

void body_apply_central_force(body: RID, force: Vector2) 

Applies a directional force to the body, at the body's center of mass. The force does not affect rotation. A force is time dependent and meant to be applied every physics update.

This is equivalent to using body_apply_force() at the body's center of mass.

---

void body_apply_central_impulse(body: RID, impulse: Vector2) 

Applies a directional impulse to the body, at the body's center of mass. The impulse does not affect rotation.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

This is equivalent to using body_apply_impulse() at the body's center of mass.

---

void body_apply_force(body: RID, force: Vector2, position: Vector2 = Vector2(0, 0)) 

Applies a positioned force to the body. The force can affect rotation if position is different from the body's center of mass. A force is time dependent and meant to be applied every physics update.

position is the offset from the body origin in global coordinates.

---

void body_apply_impulse(body: RID, impulse: Vector2, position: Vector2 = Vector2(0, 0)) 

Applies a positioned impulse to the body. The impulse can affect rotation if position is different from the body's center of mass.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

position is the offset from the body origin in global coordinates.

---

void body_apply_torque(body: RID, torque: float) 

Applies a rotational force to the body. The force does not affect position. A force is time dependent and meant to be applied every physics update.

---

void body_apply_torque_impulse(body: RID, impulse: float) 

Applies a rotational impulse to the body. The impulse does not affect position.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

---

void body_attach_canvas_instance_id(body: RID, id: int) 

Attaches the ObjectID of a canvas to the body. Use Object.get_instance_id() to get the ObjectID of a CanvasLayer.

---

void body_attach_object_instance_id(body: RID, id: int) 

Attaches the ObjectID of an Object to the body. Use Object.get_instance_id() to get the ObjectID of a CollisionObject2D.

---

void body_clear_shapes(body: RID) 

Removes all shapes from the body. This does not delete the shapes themselves, so they can continue to be used elsewhere or added back later.

---

RID body_create() 

Creates a 2D body object in the physics server, and returns the RID that identifies it. The default settings for the created area include a collision layer and mask set to 1, and body mode set to BODY_MODE_RIGID.

Use body_add_shape() to add shapes to it, use body_set_state() to set its transform, and use body_set_space() to add the body to a space.

---

int body_get_canvas_instance_id(body: RID) const 

Returns the ObjectID of the canvas attached to the body. Use @GlobalScope.instance_from_id() to retrieve a CanvasLayer from a nonzero ObjectID.

---

int body_get_collision_layer(body: RID) const 

Returns the physics layer or layers the body belongs to, as a bitmask.

---

int body_get_collision_mask(body: RID) const 

Returns the physics layer or layers the body can collide with, as a bitmask.

---

float body_get_collision_priority(body: RID) const 

Returns the body's collision priority. This is used in the depenetration phase of body_test_motion(). The higher the priority is, the lower the penetration into the body will be.

---

Vector2 body_get_constant_force(body: RID) const 

Returns the body's total constant positional force applied during each physics update.

See body_add_constant_force() and body_add_constant_central_force().

---

float body_get_constant_torque(body: RID) const 

Returns the body's total constant rotational force applied during each physics update.

See body_add_constant_torque().

---

CCDMode body_get_continuous_collision_detection_mode(body: RID) const 

Returns the body's continuous collision detection mode.

---

PhysicsDirectBodyState2D body_get_direct_state(body: RID) 

Returns the PhysicsDirectBodyState2D of the body. Returns null if the body is destroyed or not assigned to a space.

---

int body_get_max_contacts_reported(body: RID) const 

Returns the maximum number of contacts that the body can report. See body_set_max_contacts_reported().

---

BodyMode body_get_mode(body: RID) const 

Returns the body's mode.

---

int body_get_object_instance_id(body: RID) const 

Returns the ObjectID attached to the body. Use @GlobalScope.instance_from_id() to retrieve an Object from a nonzero ObjectID.

---

Variant body_get_param(body: RID, param: BodyParameter) const 

Returns the value of the given body parameter.

---

RID body_get_shape(body: RID, shape_idx: int) const 

Returns the RID of the shape with the given index in the body's array of shapes.

---

int body_get_shape_count(body: RID) const 

Returns the number of shapes added to the body.

---

Transform2D body_get_shape_transform(body: RID, shape_idx: int) const 

Returns the local transform matrix of the shape with the given index in the area's array of shapes.

---

RID body_get_space(body: RID) const 

Returns the RID of the space assigned to the body. Returns an empty RID if no space is assigned.

---

Variant body_get_state(body: RID, state: BodyState) const 

Returns the value of the given state of the body.

---

bool body_is_omitting_force_integration(body: RID) const 

Returns true if the body is omitting the standard force integration. See body_set_omit_force_integration().

---

void body_remove_collision_exception(body: RID, excepted_body: RID) 

Removes excepted_body from the body's list of collision exceptions, so that collisions with it are no longer ignored.

---

void body_remove_shape(body: RID, shape_idx: int) 

Removes the shape with the given index from the body's array of shapes. The shape itself is not deleted, so it can continue to be used elsewhere or added back later. As a result of this operation, the body's shapes which used to have indices higher than shape_idx will have their index decreased by one.

---

void body_reset_mass_properties(body: RID) 

Restores the default inertia and center of mass of the body based on its shapes. This undoes any custom values previously set using body_set_param().

---

void body_set_axis_velocity(body: RID, axis_velocity: Vector2) 

Modifies the body's linear velocity so that its projection to the axis axis_velocity.normalized() is exactly axis_velocity.length(). This is useful for jumping behavior.

---

void body_set_collision_layer(body: RID, layer: int) 

Sets the physics layer or layers the body belongs to, via a bitmask.

---

void body_set_collision_mask(body: RID, mask: int) 

Sets the physics layer or layers the body can collide with, via a bitmask.

---

void body_set_collision_priority(body: RID, priority: float) 

Sets the body's collision priority. This is used in the depenetration phase of body_test_motion(). The higher the priority is, the lower the penetration into the body will be.

---

void body_set_constant_force(body: RID, force: Vector2) 

Sets the body's total constant positional force applied during each physics update.

See body_add_constant_force() and body_add_constant_central_force().

---

void body_set_constant_torque(body: RID, torque: float) 

Sets the body's total constant rotational force applied during each physics update.

See body_add_constant_torque().

---

void body_set_continuous_collision_detection_mode(body: RID, mode: CCDMode) 

Sets the continuous collision detection mode.

Continuous collision detection tries to predict where a moving body would collide in between physics updates, instead of moving it and correcting its movement if it collided.

---

void body_set_force_integration_callback(body: RID, callable: Callable, userdata: Variant = null) 

Sets the body's custom force integration callback function to callable. Use an empty Callable (Callable()) to clear the custom callback.

The function callable will be called every physics tick, before the standard force integration (see body_set_omit_force_integration()). It can be used for example to update the body's linear and angular velocity based on contact with other bodies.

If userdata is not null, the function callable must take the following two parameters:

1. state: a PhysicsDirectBodyState2D used to retrieve and modify the body's state,
2. userdata: a Variant; its value will be the userdata passed into this method.

If userdata is null, then callable must take only the state parameter.

---

void body_set_max_contacts_reported(body: RID, amount: int) 

Sets the maximum number of contacts that the body can report. If amount is greater than zero, then the body will keep track of at most this many contacts with other bodies.

---

void body_set_mode(body: RID, mode: BodyMode) 

Sets the body's mode.

---

void body_set_omit_force_integration(body: RID, enable: bool) 

Sets whether the body omits the standard force integration. If enable is true, the body will not automatically use applied forces, torques, and damping to update the body's linear and angular velocity. In this case, body_set_force_integration_callback() can be used to manually update the linear and angular velocity instead.

This method is called when the property RigidBody2D.custom_integrator is set.

---

void body_set_param(body: RID, param: BodyParameter, value: Variant) 

Sets the value of the given body parameter.

---

void body_set_shape(body: RID, shape_idx: int, shape: RID) 

Replaces the body's shape at the given index by another shape, while not affecting the transform, disabled, and one-way collision properties at the same index.

---

void body_set_shape_as_one_way_collision(body: RID, shape_idx: int, enable: bool, margin: float, direction: Vector2 = Vector2(0, 1)) 

Sets the one-way collision properties of the body's shape with the given index. If enable is true, the one-way collision direction given by direction in the shape's local space (that is body_get_shape_transform(body, shape_idx).basis_xform(direction).normalized() in the body's local space) will be used to ignore collisions with the shape in the opposite direction, and to ensure depenetration of kinematic bodies happens in this direction.

---

void body_set_shape_disabled(body: RID, shape_idx: int, disabled: bool) 

Sets the disabled property of the body's shape with the given index. If disabled is true, then the shape will be ignored in all collision detection.

---

void body_set_shape_transform(body: RID, shape_idx: int, transform: Transform2D) 

Sets the local transform matrix of the body's shape with the given index.

---

void body_set_space(body: RID, space: RID) 

Adds the body to the given space, after removing the body from the previously assigned space (if any). If the body's mode is set to BODY_MODE_RIGID, then adding the body to a space will have the following additional effects:

- If the parameter BODY_PARAM_CENTER_OF_MASS has never been set explicitly, then the value of that parameter will be recalculated based on the body's shapes.
- If the parameter BODY_PARAM_INERTIA is set to a value <= 0.0, then the value of that parameter will be recalculated based on the body's shapes, mass, and center of mass.

Note: To remove a body from a space without immediately adding it back elsewhere, use PhysicsServer2D.body_set_space(body, RID()).

---

void body_set_state(body: RID, state: BodyState, value: Variant) 

Sets the value of a body's state.

Note: The state change doesn't take effect immediately. The state will change on the next physics frame.

---

void body_set_state_sync_callback(body: RID, callable: Callable) 

Sets the body's state synchronization callback function to callable. Use an empty Callable (Callable()) to clear the callback.

The function callable will be called every physics frame, assuming that the body was active during the previous physics tick, and can be used to fetch the latest state from the physics server.

The function callable must take the following parameters:

1. state: a PhysicsDirectBodyState2D, used to retrieve the body's state.

---

bool body_test_motion(body: RID, parameters: PhysicsTestMotionParameters2D, result: PhysicsTestMotionResult2D = null) 

Returns true if a collision would result from moving the body along a motion vector from a given point in space. See PhysicsTestMotionParameters2D for the available motion parameters. Optionally a PhysicsTestMotionResult2D object can be passed, which will be used to store the information about the resulting collision.

---

RID capsule_shape_create() 

Creates a 2D capsule shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the capsule's height and radius.

---

RID circle_shape_create() 

Creates a 2D circle shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the circle's radius.

---

RID concave_polygon_shape_create() 

Creates a 2D concave polygon shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the concave polygon's segments.

---

RID convex_polygon_shape_create() 

Creates a 2D convex polygon shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the convex polygon's points.

---

float damped_spring_joint_get_param(joint: RID, param: DampedSpringParam) const 

Returns the value of the given damped spring joint parameter.

---

void damped_spring_joint_set_param(joint: RID, param: DampedSpringParam, value: float) 

Sets the value of the given damped spring joint parameter.

---

void free_rid(rid: RID) 

Destroys any of the objects created by PhysicsServer2D. If the RID passed is not one of the objects that can be created by PhysicsServer2D, an error will be printed to the console.

---

int get_process_info(process_info: ProcessInfo) 

Returns the value of a physics engine state specified by process_info.

---

void joint_clear(joint: RID) 

Destroys the joint with the given RID, creates a new uninitialized joint, and makes the RID refer to this new joint.

---

RID joint_create() 

Creates a 2D joint in the physics server, and returns the RID that identifies it. To set the joint type, use joint_make_damped_spring(), joint_make_groove() or joint_make_pin(). Use joint_set_param() to set generic joint parameters.

---

void joint_disable_collisions_between_bodies(joint: RID, disable: bool) 

Sets whether the bodies attached to the Joint2D will collide with each other.

---

float joint_get_param(joint: RID, param: JointParam) const 

Returns the value of the given joint parameter.

---

JointType joint_get_type(joint: RID) const 

Returns the joint's type.

---

bool joint_is_disabled_collisions_between_bodies(joint: RID) const 

Returns whether the bodies attached to the Joint2D will collide with each other.

---

void joint_make_damped_spring(joint: RID, anchor_a: Vector2, anchor_b: Vector2, body_a: RID, body_b: RID = RID()) 

Makes the joint a damped spring joint, attached at the point anchor_a (given in global coordinates) on the body body_a and at the point anchor_b (given in global coordinates) on the body body_b. To set the parameters which are specific to the damped spring, see damped_spring_joint_set_param().

---

void joint_make_groove(joint: RID, groove1_a: Vector2, groove2_a: Vector2, anchor_b: Vector2, body_a: RID = RID(), body_b: RID = RID()) 

Makes the joint a groove joint.

---

void joint_make_pin(joint: RID, anchor: Vector2, body_a: RID, body_b: RID = RID()) 

Makes the joint a pin joint. If body_b is an empty RID, then body_a is pinned to the point anchor (given in global coordinates); otherwise, body_a is pinned to body_b at the point anchor (given in global coordinates). To set the parameters which are specific to the pin joint, see pin_joint_set_param().

---

void joint_set_param(joint: RID, param: JointParam, value: float) 

Sets the value of the given joint parameter.

---

bool pin_joint_get_flag(joint: RID, flag: PinJointFlag) const 

Gets a pin joint flag.

---

float pin_joint_get_param(joint: RID, param: PinJointParam) const 

Returns the value of a pin joint parameter.

---

void pin_joint_set_flag(joint: RID, flag: PinJointFlag, enabled: bool) 

Sets a pin joint flag.

---

void pin_joint_set_param(joint: RID, param: PinJointParam, value: float) 

Sets a pin joint parameter.

---

RID rectangle_shape_create() 

Creates a 2D rectangle shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the rectangle's half-extents.

---

RID segment_shape_create() 

Creates a 2D segment shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the segment's start and end points.

---

RID separation_ray_shape_create() 

Creates a 2D separation ray shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the shape's length and slide_on_slope properties.

---

void set_active(active: bool) 

Activates or deactivates the 2D physics server. If active is false, then the physics server will not do anything in its physics step.

---

Variant shape_get_data(shape: RID) const 

Returns the shape data that defines the configuration of the shape, such as the half-extents of a rectangle or the segments of a concave shape. See shape_set_data() for the precise format of this data in each case.

---

ShapeType shape_get_type(shape: RID) const 

Returns the shape's type.

---

void shape_set_data(shape: RID, data: Variant) 

Sets the shape data that defines the configuration of the shape. The data to be passed depends on the shape's type (see shape_get_type()):

- SHAPE_WORLD_BOUNDARY: an array of length two containing a Vector2 normal direction and a float distance d,
- SHAPE_SEPARATION_RAY: a dictionary containing the key length with a float value and the key slide_on_slope with a bool value,
- SHAPE_SEGMENT: a Rect2 rect containing the first point of the segment in rect.position and the second point of the segment in rect.size,
- SHAPE_CIRCLE: a float radius,
- SHAPE_RECTANGLE: a Vector2 half_extents,
- SHAPE_CAPSULE: an array of length two (or a Vector2) containing a float height and a float radius,
- SHAPE_CONVEX_POLYGON: either a PackedVector2Array of points defining a convex polygon in counterclockwise order (the clockwise outward normal of each segment formed by consecutive points is calculated internally), or a PackedFloat32Array of length divisible by four so that every 4-tuple of floats contains the coordinates of a point followed by the coordinates of the clockwise outward normal vector to the segment between the current point and the next point,
- SHAPE_CONCAVE_POLYGON: a PackedVector2Array of length divisible by two (each pair of points forms one segment).

Warning: In the case of SHAPE_CONVEX_POLYGON, this method does not check if the points supplied actually form a convex polygon (unlike the CollisionPolygon2D.polygon property).

---

RID space_create() 

Creates a 2D space in the physics server, and returns the RID that identifies it. A space contains bodies and areas, and controls the stepping of the physics simulation of the objects in it.

---

PhysicsDirectSpaceState2D space_get_direct_state(space: RID) 

Returns the state of a space, a PhysicsDirectSpaceState2D. This object can be used for collision/intersection queries.

---

float space_get_param(space: RID, param: SpaceParameter) const 

Returns the value of the given space parameter.

---

bool space_is_active(space: RID) const 

Returns true if the space is active.

---

void space_set_active(space: RID, active: bool) 

Activates or deactivates the space. If active is false, then the physics server will not do anything with this space in its physics step.

---

void space_set_param(space: RID, param: SpaceParameter, value: float) 

Sets the value of the given space parameter.

---

RID world_boundary_shape_create() 

Creates a 2D world boundary shape in the physics server, and returns the RID that identifies it. Use shape_set_data() to set the shape's normal direction and distance properties.
