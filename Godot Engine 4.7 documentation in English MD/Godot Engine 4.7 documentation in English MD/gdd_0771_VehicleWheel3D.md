# VehicleWheel3D

Inherits: Node3D < Node < Object

A 3D physics body for a VehicleBody3D that simulates the behavior of a wheel.

## Description

A node used as a child of a VehicleBody3D parent to simulate the behavior of one of its wheels. This node also acts as a collider to detect if the wheel is touching a surface.

Note: This class has known issues and isn't designed to provide realistic 3D vehicle physics. If you want advanced vehicle physics, you may need to write your own physics integration using another PhysicsBody3D class.

## Tutorials

- 3D Truck Town Demo [https://godotengine.org/asset-library/asset/2752]

## Properties

float | brake | 0.0
float | damping_compression | 0.83
float | damping_relaxation | 0.88
float | engine_force | 0.0
PhysicsInterpolationMode | physics_interpolation_mode | 2 (overrides Node)
float | steering | 0.0
float | suspension_max_force | 6000.0
float | suspension_stiffness | 5.88
float | suspension_travel | 0.2
bool | use_as_steering | false
bool | use_as_traction | false
float | wheel_friction_slip | 10.5
float | wheel_radius | 0.5
float | wheel_rest_length | 0.15
float | wheel_roll_influence | 0.1

## Methods

Node3D | get_contact_body() const
Vector3 | get_contact_normal() const
Vector3 | get_contact_point() const
float | get_rpm() const
float | get_skidinfo() const
bool | is_in_contact() const

---

## Property Descriptions

float brake = 0.0 

- void set_brake(value: float)
- float get_brake()

Slows down the wheel by applying a braking force. The wheel is only slowed down if it is in contact with a surface. The force you need to apply to adequately slow down your vehicle depends on the RigidBody3D.mass of the vehicle. For a vehicle with a mass set to 1000, try a value in the 25 - 30 range for hard braking.

---

float damping_compression = 0.83 

- void set_damping_compression(value: float)
- float get_damping_compression()

The damping applied to the suspension spring when being compressed, meaning when the wheel is moving up relative to the vehicle. It is measured in Newton-seconds per millimeter (N⋅s/mm), or megagrams per second (Mg/s). This value should be between 0.0 (no damping) and 1.0, but may be more. A value of 0.0 means the car will keep bouncing as the spring keeps its energy. A good value for this is around 0.3 for a normal car, 0.5 for a race car.

---

float damping_relaxation = 0.88 

- void set_damping_relaxation(value: float)
- float get_damping_relaxation()

The damping applied to the suspension spring when rebounding or extending, meaning when the wheel is moving down relative to the vehicle. It is measured in Newton-seconds per millimeter (N⋅s/mm), or megagrams per second (Mg/s). This value should be between 0.0 (no damping) and 1.0, but may be more. This value should always be slightly higher than the damping_compression property. For a damping_compression value of 0.3, try a relaxation value of 0.5.

---

float engine_force = 0.0 

- void set_engine_force(value: float)
- float get_engine_force()

Accelerates the wheel by applying an engine force. The wheel is only sped up if it is in contact with a surface. The RigidBody3D.mass of the vehicle has an effect on the acceleration of the vehicle. For a vehicle with a mass set to 1000, try a value in the 25 - 50 range for acceleration.

Note: The simulation does not take the effect of gears into account, you will need to add logic for this if you wish to simulate gears.

A negative value will result in the wheel reversing.

---

float steering = 0.0 

- void set_steering(value: float)
- float get_steering()

The steering angle for the wheel, in radians. Setting this to a non-zero value will result in the vehicle turning when it's moving.

---

float suspension_max_force = 6000.0 

- void set_suspension_max_force(value: float)
- float get_suspension_max_force()

The maximum force the spring can resist. This value should be higher than a quarter of the RigidBody3D.mass of the VehicleBody3D or the spring will not carry the weight of the vehicle. Good results are often obtained by a value that is about 3× to 4× this number.

---

float suspension_stiffness = 5.88 

- void set_suspension_stiffness(value: float)
- float get_suspension_stiffness()

The stiffness of the suspension, measured in Newtons per millimeter (N/mm), or megagrams per second squared (Mg/s²). Use a value lower than 50 for an off-road car, a value between 50 and 100 for a race car and try something around 200 for something like a Formula 1 car.

---

float suspension_travel = 0.2 

- void set_suspension_travel(value: float)
- float get_suspension_travel()

This is the distance the suspension can travel. As Godot units are equivalent to meters, keep this setting relatively low. Try a value between 0.1 and 0.3 depending on the type of car.

---

bool use_as_steering = false 

- void set_use_as_steering(value: bool)
- bool is_used_as_steering()

If true, this wheel will be turned when the car steers. This value is used in conjunction with VehicleBody3D.steering and ignored if you are using the per-wheel steering value instead.

---

bool use_as_traction = false 

- void set_use_as_traction(value: bool)
- bool is_used_as_traction()

If true, this wheel transfers engine force to the ground to propel the vehicle forward. This value is used in conjunction with VehicleBody3D.engine_force and ignored if you are using the per-wheel engine_force value instead.

---

float wheel_friction_slip = 10.5 

- void set_friction_slip(value: float)
- float get_friction_slip()

This determines how much grip this wheel has. It is combined with the friction setting of the surface the wheel is in contact with. 0.0 means no grip, 1.0 is normal grip. For a drift car setup, try setting the grip of the rear wheels slightly lower than the front wheels, or use a lower value to simulate tire wear.

It's best to set this to 1.0 when starting out.

---

float wheel_radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The radius of the wheel in meters.

---

float wheel_rest_length = 0.15 

- void set_suspension_rest_length(value: float)
- float get_suspension_rest_length()

This is the distance in meters the wheel is lowered from its origin point. Don't set this to 0.0 and move the wheel into position, instead move the origin point of your wheel (the gizmo in Godot) to the position the wheel will take when bottoming out, then use the rest length to move the wheel down to the position it should be in when the car is in rest.

---

float wheel_roll_influence = 0.1 

- void set_roll_influence(value: float)
- float get_roll_influence()

This value affects the roll of your vehicle. If set to 1.0 for all wheels, your vehicle will resist body roll, while a value of 0.0 will be prone to rolling over.

---

## Method Descriptions

Node3D get_contact_body() const 

Returns the contacting body node if valid in the tree, as Node3D. At the moment, GridMap is not supported so the node will be always of type PhysicsBody3D.

Returns null if the wheel is not in contact with a surface, or the contact body is not a PhysicsBody3D.

---

Vector3 get_contact_normal() const 

Returns the normal of the suspension's collision in world space if the wheel is in contact. If the wheel isn't in contact with anything, returns a vector pointing directly along the suspension axis toward the vehicle in world space.

---

Vector3 get_contact_point() const 

Returns the point of the suspension's collision in world space if the wheel is in contact. If the wheel isn't in contact with anything, returns the maximum point of the wheel's ray cast in world space, which is defined by wheel_rest_length + wheel_radius.

---

float get_rpm() const 

Returns the rotational speed of the wheel in revolutions per minute.

---

float get_skidinfo() const 

Returns a value between 0.0 and 1.0 that indicates whether this wheel is skidding. 0.0 is skidding (the wheel has lost grip, e.g. icy terrain), 1.0 means not skidding (the wheel has full grip, e.g. dry asphalt road).

---

bool is_in_contact() const 

Returns true if this wheel is in contact with a surface.
