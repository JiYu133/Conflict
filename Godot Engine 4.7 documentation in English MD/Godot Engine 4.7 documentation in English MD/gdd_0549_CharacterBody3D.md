# CharacterBody3D

Inherits: PhysicsBody3D < CollisionObject3D < Node3D < Node < Object

A 3D physics body specialized for characters moved by script.

## Description

CharacterBody3D is a specialized class for physics bodies that are meant to be user-controlled. They are not affected by physics at all, but they affect other physics bodies in their path. They are mainly used to provide high-level API to move objects with wall and slope detection (move_and_slide() method) in addition to the general collision detection provided by PhysicsBody3D.move_and_collide(). This makes it useful for highly configurable physics bodies that must move in specific ways and collide with the world, as is often the case with user-controlled characters.

For game objects that don't require complex movement or collision detection, such as moving platforms, AnimatableBody3D is simpler to configure.

## Tutorials

- Physics introduction
- Troubleshooting physics issues
- Kinematic character (2D)
- 3D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2739]
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]
- 3D Voxel Demo [https://godotengine.org/asset-library/asset/2755]
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

bool | floor_block_on_wall | true
bool | floor_constant_speed | false
float | floor_max_angle | 0.7853982
float | floor_snap_length | 0.1
bool | floor_stop_on_slope | true
int | max_slides | 6
MotionMode | motion_mode | 0
int | platform_floor_layers | 4294967295
PlatformOnLeave | platform_on_leave | 0
int | platform_wall_layers | 0
float | safe_margin | 0.001
bool | slide_on_ceiling | true
Vector3 | up_direction | Vector3(0, 1, 0)
Vector3 | velocity | Vector3(0, 0, 0)
float | wall_min_slide_angle | 0.2617994

## Methods

void | apply_floor_snap()
float | get_floor_angle(up_direction: Vector3 = Vector3(0, 1, 0)) const
Vector3 | get_floor_normal() const
Vector3 | get_last_motion() const
KinematicCollision3D | get_last_slide_collision()
Vector3 | get_platform_angular_velocity() const
Vector3 | get_platform_velocity() const
Vector3 | get_position_delta() const
Vector3 | get_real_velocity() const
KinematicCollision3D | get_slide_collision(slide_idx: int)
int | get_slide_collision_count() const
Vector3 | get_wall_normal() const
bool | is_on_ceiling() const
bool | is_on_ceiling_only() const
bool | is_on_floor() const
bool | is_on_floor_only() const
bool | is_on_wall() const
bool | is_on_wall_only() const
bool | move_and_slide()

---

## Enumerations

enum MotionMode
MotionMode MOTION_MODE_GROUNDED = 0

Apply when notions of walls, ceiling and floor are relevant. In this mode the body motion will react to slopes (acceleration/slowdown). This mode is suitable for grounded games like platformers.

MotionMode MOTION_MODE_FLOATING = 1

Apply when there is no notion of floor or ceiling. All collisions will be reported as on_wall. In this mode, when you slide, the speed will always be constant. This mode is suitable for games without ground like space games.

---

enum PlatformOnLeave
PlatformOnLeave PLATFORM_ON_LEAVE_ADD_VELOCITY = 0

Add the last platform velocity to the velocity when you leave a moving platform.

PlatformOnLeave PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY = 1

Add the last platform velocity to the velocity when you leave a moving platform, but any downward motion is ignored. It's useful to keep full jump height even when the platform is moving down.

PlatformOnLeave PLATFORM_ON_LEAVE_DO_NOTHING = 2

Do nothing when leaving a platform.

---

## Property Descriptions

bool floor_block_on_wall = true 

- void set_floor_block_on_wall_enabled(value: bool)
- bool is_floor_block_on_wall_enabled()

If true, the body will be able to move on the floor only. This option avoids to be able to walk on walls, it will however allow to slide down along them.

---

bool floor_constant_speed = false 

- void set_floor_constant_speed_enabled(value: bool)
- bool is_floor_constant_speed_enabled()

If false (by default), the body will move faster on downward slopes and slower on upward slopes.

If true, the body will always move at the same speed on the ground no matter the slope. Note that you need to use floor_snap_length to stick along a downward slope at constant speed.

---

float floor_max_angle = 0.7853982 

- void set_floor_max_angle(value: float)
- float get_floor_max_angle()

Maximum angle (in radians) where a slope is still considered a floor (or a ceiling), rather than a wall, when calling move_and_slide(). The default value equals 45 degrees.

---

float floor_snap_length = 0.1 

- void set_floor_snap_length(value: float)
- float get_floor_snap_length()

Sets a snapping distance. When set to a value different from 0.0, the body is kept attached to slopes when calling move_and_slide(). The snapping vector is determined by the given distance along the opposite direction of the up_direction.

As long as the snapping vector is in contact with the ground and the body moves against up_direction, the body will remain attached to the surface. Snapping is not applied if the body moves along up_direction, meaning it contains vertical rising velocity, so it will be able to detach from the ground when jumping or when the body is pushed up by something. If you want to apply a snap without taking into account the velocity, use apply_floor_snap().

---

bool floor_stop_on_slope = true 

- void set_floor_stop_on_slope_enabled(value: bool)
- bool is_floor_stop_on_slope_enabled()

If true, the body will not slide on slopes when calling move_and_slide() when the body is standing still.

If false, the body will slide on floor's slopes when velocity applies a downward force.

---

int max_slides = 6 

- void set_max_slides(value: int)
- int get_max_slides()

Maximum number of times the body can change direction before it stops when calling move_and_slide(). Must be greater than zero.

---

MotionMode motion_mode = 0 

- void set_motion_mode(value: MotionMode)
- MotionMode get_motion_mode()

Sets the motion mode which defines the behavior of move_and_slide().

---

int platform_floor_layers = 4294967295 

- void set_platform_floor_layers(value: int)
- int get_platform_floor_layers()

Collision layers that will be included for detecting floor bodies that will act as moving platforms to be followed by the CharacterBody3D. By default, all floor bodies are detected and propagate their velocity.

---

PlatformOnLeave platform_on_leave = 0 

- void set_platform_on_leave(value: PlatformOnLeave)
- PlatformOnLeave get_platform_on_leave()

Sets the behavior to apply when you leave a moving platform. By default, to be physically accurate, when you leave the last platform velocity is applied.

---

int platform_wall_layers = 0 

- void set_platform_wall_layers(value: int)
- int get_platform_wall_layers()

Collision layers that will be included for detecting wall bodies that will act as moving platforms to be followed by the CharacterBody3D. By default, all wall bodies are ignored.

---

float safe_margin = 0.001 

- void set_safe_margin(value: float)
- float get_safe_margin()

Extra margin used for collision recovery when calling move_and_slide().

If the body is at least this close to another body, it will consider them to be colliding and will be pushed away before performing the actual motion.

A higher value means it's more flexible for detecting collision, which helps with consistently detecting walls and floors.

A lower value forces the collision algorithm to use more exact detection, so it can be used in cases that specifically require precision, e.g at very low scale to avoid visible jittering, or for stability with a stack of character bodies.

---

bool slide_on_ceiling = true 

- void set_slide_on_ceiling_enabled(value: bool)
- bool is_slide_on_ceiling_enabled()

If true, during a jump against the ceiling, the body will slide, if false it will be stopped and will fall vertically.

---

Vector3 up_direction = Vector3(0, 1, 0) 

- void set_up_direction(value: Vector3)
- Vector3 get_up_direction()

Vector pointing upwards, used to determine what is a wall and what is a floor (or a ceiling) when calling move_and_slide(). Defaults to Vector3.UP. As the vector will be normalized it can't be equal to Vector3.ZERO, if you want all collisions to be reported as walls, consider using MOTION_MODE_FLOATING as motion_mode.

---

Vector3 velocity = Vector3(0, 0, 0) 

- void set_velocity(value: Vector3)
- Vector3 get_velocity()

Current velocity vector (typically meters per second), used and modified during calls to move_and_slide().

Note: A common mistake is setting this property to the desired velocity multiplied by delta, which produces a motion vector (typically in meters).

---

float wall_min_slide_angle = 0.2617994 

- void set_wall_min_slide_angle(value: float)
- float get_wall_min_slide_angle()

Minimum angle (in radians) where the body is allowed to slide when it encounters a wall. The default value equals 15 degrees. When motion_mode is MOTION_MODE_GROUNDED, it only affects movement if floor_block_on_wall is true.

---

## Method Descriptions

void apply_floor_snap() 

Allows to manually apply a snap to the floor regardless of the body's velocity. This function does nothing when is_on_floor() returns true.

---

float get_floor_angle(up_direction: Vector3 = Vector3(0, 1, 0)) const 

Returns the floor's collision angle at the last collision point according to up_direction, which is Vector3.UP by default. This value is always positive and only valid after calling move_and_slide() and when is_on_floor() returns true.

---

Vector3 get_floor_normal() const 

Returns the collision normal of the floor at the last collision point. Only valid after calling move_and_slide() and when is_on_floor() returns true.

Warning: The collision normal is not always the same as the surface normal.

---

Vector3 get_last_motion() const 

Returns the last motion applied to the CharacterBody3D during the last call to move_and_slide(). The movement can be split into multiple motions when sliding occurs, and this method return the last one, which is useful to retrieve the current direction of the movement.

---

KinematicCollision3D get_last_slide_collision() 

Returns a KinematicCollision3D if a collision occurred. The returned value contains information about the latest collision that occurred during the last call to move_and_slide(). Returns null if no collision occurred. See also get_slide_collision().

---

Vector3 get_platform_angular_velocity() const 

Returns the angular velocity of the platform at the last collision point. Only valid after calling move_and_slide().

---

Vector3 get_platform_velocity() const 

Returns the linear velocity of the platform at the last collision point. Only valid after calling move_and_slide().

---

Vector3 get_position_delta() const 

Returns the travel (position delta) that occurred during the last call to move_and_slide().

---

Vector3 get_real_velocity() const 

Returns the current real velocity since the last call to move_and_slide(). For example, when you climb a slope, you will move diagonally even though the velocity is horizontal. This method returns the diagonal movement, as opposed to velocity which returns the requested velocity.

---

KinematicCollision3D get_slide_collision(slide_idx: int) 

Returns a KinematicCollision3D, which contains information about a collision that occurred during the last call to move_and_slide(). Since the body can collide several times in a single call to move_and_slide(), you must specify the index of the collision in the range 0 to (get_slide_collision_count() - 1). See also get_last_slide_collision().

---

int get_slide_collision_count() const 

Returns the number of times the body collided and changed direction during the last call to move_and_slide().

---

Vector3 get_wall_normal() const 

Returns the collision normal of the wall at the last collision point. Only valid after calling move_and_slide() and when is_on_wall() returns true.

Warning: The collision normal is not always the same as the surface normal.

---

bool is_on_ceiling() const 

Returns true if the body collided with the ceiling on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "ceiling" or not.

---

bool is_on_ceiling_only() const 

Returns true if the body collided only with the ceiling on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "ceiling" or not.

---

bool is_on_floor() const 

Returns true if the body collided with the floor on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "floor" or not.

---

bool is_on_floor_only() const 

Returns true if the body collided only with the floor on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "floor" or not.

---

bool is_on_wall() const 

Returns true if the body collided with a wall on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "wall" or not.

---

bool is_on_wall_only() const 

Returns true if the body collided only with a wall on the last call of move_and_slide(). Otherwise, returns false. The up_direction and floor_max_angle are used to determine whether a surface is "wall" or not.

---

bool move_and_slide() 

Moves the body based on velocity. If the body collides with another, it will slide along the other body rather than stop immediately. If the other body is a CharacterBody3D or RigidBody3D, it will also be affected by the motion of the other body. You can use this to make moving and rotating platforms, or to make nodes push other nodes.

This method should be used in Node._physics_process() (or in a method called by Node._physics_process()), as it uses the physics step's delta value automatically in calculations. Otherwise, the simulation will run at an incorrect speed.

Modifies velocity if a slide collision occurred. To get the latest collision call get_last_slide_collision(), for more detailed information about collisions that occurred, use get_slide_collision().

When the body touches a moving platform, the platform's velocity is automatically added to the body motion. If a collision occurs due to the platform's motion, it will always be first in the slide collisions.

Returns true if the body collided, otherwise, returns false.
