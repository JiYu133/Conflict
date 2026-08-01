# CPUParticles2D

Inherits: Node2D < CanvasItem < Node < Object

A CPU-based 2D particle emitter.

## Description

CPU-based 2D particle node used to create a variety of particle systems and effects.

See also GPUParticles2D, which provides the same functionality with hardware acceleration, but may not run on older devices.

## Tutorials

- Particle systems (2D)

## Properties

int | amount | 8
Curve | angle_curve |
float | angle_max | 0.0
float | angle_min | 0.0
Curve | angular_velocity_curve |
float | angular_velocity_max | 0.0
float | angular_velocity_min | 0.0
Curve | anim_offset_curve |
float | anim_offset_max | 0.0
float | anim_offset_min | 0.0
Curve | anim_speed_curve |
float | anim_speed_max | 0.0
float | anim_speed_min | 0.0
Color | color | Color(1, 1, 1, 1)
Gradient | color_initial_ramp |
Gradient | color_ramp |
Curve | damping_curve |
float | damping_max | 0.0
float | damping_min | 0.0
Vector2 | direction | Vector2(1, 0)
DrawOrder | draw_order | 0
PackedColorArray | emission_colors |
PackedVector2Array | emission_normals |
PackedVector2Array | emission_points |
Vector2 | emission_rect_extents |
float | emission_ring_inner_radius |
float | emission_ring_radius |
EmissionShape | emission_shape | 0
float | emission_sphere_radius |
bool | emitting | true
float | explosiveness | 0.0
int | fixed_fps | 0
bool | fract_delta | true
Vector2 | gravity | Vector2(0, 980)
Curve | hue_variation_curve |
float | hue_variation_max | 0.0
float | hue_variation_min | 0.0
float | initial_velocity_max | 0.0
float | initial_velocity_min | 0.0
float | lifetime | 1.0
float | lifetime_randomness | 0.0
Curve | linear_accel_curve |
float | linear_accel_max | 0.0
float | linear_accel_min | 0.0
bool | local_coords | false
bool | one_shot | false
Curve | orbit_velocity_curve |
float | orbit_velocity_max | 0.0
float | orbit_velocity_min | 0.0
bool | particle_flag_align_y | false
PhysicsInterpolationMode | physics_interpolation_mode | 2 (overrides Node)
float | preprocess | 0.0
Curve | radial_accel_curve |
float | radial_accel_max | 0.0
float | radial_accel_min | 0.0
float | randomness | 0.0
Curve | scale_amount_curve |
float | scale_amount_max | 1.0
float | scale_amount_min | 1.0
Curve | scale_curve_x |
Curve | scale_curve_y |
int | seed | 0
float | speed_scale | 1.0
bool | split_scale | false
float | spread | 45.0
Curve | tangential_accel_curve |
float | tangential_accel_max | 0.0
float | tangential_accel_min | 0.0
Texture2D | texture |
bool | use_fixed_seed | false

## Methods

void | convert_from_particles(particles: Node)
Curve | get_param_curve(param: Parameter) const
float | get_param_max(param: Parameter) const
float | get_param_min(param: Parameter) const
bool | get_particle_flag(particle_flag: ParticleFlags) const
void | request_particles_process(process_time: float, process_time_residual: float = 0.0)
void | restart(keep_seed: bool = false)
void | set_param_curve(param: Parameter, curve: Curve)
void | set_param_max(param: Parameter, value: float)
void | set_param_min(param: Parameter, value: float)
void | set_particle_flag(particle_flag: ParticleFlags, enable: bool)

---

## Signals

finished() 

Emitted when all active particles have finished processing. When one_shot is disabled, particles will process continuously, so this is never emitted.

---

## Enumerations

enum DrawOrder
DrawOrder DRAW_ORDER_INDEX = 0

Particles are drawn in the order emitted.

DrawOrder DRAW_ORDER_LIFETIME = 1

Particles are drawn in order of remaining lifetime. In other words, the particle with the highest lifetime is drawn at the front.

---

enum Parameter
Parameter PARAM_INITIAL_LINEAR_VELOCITY = 0

Use with set_param_min(), set_param_max(), and set_param_curve() to set initial velocity properties.

Parameter PARAM_ANGULAR_VELOCITY = 1

Use with set_param_min(), set_param_max(), and set_param_curve() to set angular velocity properties.

Parameter PARAM_ORBIT_VELOCITY = 2

Use with set_param_min(), set_param_max(), and set_param_curve() to set orbital velocity properties.

Parameter PARAM_LINEAR_ACCEL = 3

Use with set_param_min(), set_param_max(), and set_param_curve() to set linear acceleration properties.

Parameter PARAM_RADIAL_ACCEL = 4

Use with set_param_min(), set_param_max(), and set_param_curve() to set radial acceleration properties.

Parameter PARAM_TANGENTIAL_ACCEL = 5

Use with set_param_min(), set_param_max(), and set_param_curve() to set tangential acceleration properties.

Parameter PARAM_DAMPING = 6

Use with set_param_min(), set_param_max(), and set_param_curve() to set damping properties.

Parameter PARAM_ANGLE = 7

Use with set_param_min(), set_param_max(), and set_param_curve() to set angle properties.

Parameter PARAM_SCALE = 8

Use with set_param_min(), set_param_max(), and set_param_curve() to set scale properties.

Parameter PARAM_HUE_VARIATION = 9

Use with set_param_min(), set_param_max(), and set_param_curve() to set hue variation properties.

Parameter PARAM_ANIM_SPEED = 10

Use with set_param_min(), set_param_max(), and set_param_curve() to set animation speed properties.

Parameter PARAM_ANIM_OFFSET = 11

Use with set_param_min(), set_param_max(), and set_param_curve() to set animation offset properties.

Parameter PARAM_MAX = 12

Represents the size of the Parameter enum.

---

enum ParticleFlags
ParticleFlags PARTICLE_FLAG_ALIGN_Y_TO_VELOCITY = 0

Use with set_particle_flag() to set particle_flag_align_y.

ParticleFlags PARTICLE_FLAG_ROTATE_Y = 1

Present for consistency with 3D particle nodes, not used in 2D.

ParticleFlags PARTICLE_FLAG_DISABLE_Z = 2

Present for consistency with 3D particle nodes, not used in 2D.

ParticleFlags PARTICLE_FLAG_MAX = 3

Represents the size of the ParticleFlags enum.

---

enum EmissionShape
EmissionShape EMISSION_SHAPE_POINT = 0

All particles will be emitted from a single point.

EmissionShape EMISSION_SHAPE_SPHERE = 1

Particles will be emitted in the volume of a sphere flattened to two dimensions.

EmissionShape EMISSION_SHAPE_SPHERE_SURFACE = 2

Particles will be emitted on the surface of a sphere flattened to two dimensions.

EmissionShape EMISSION_SHAPE_RECTANGLE = 3

Particles will be emitted in the area of a rectangle.

EmissionShape EMISSION_SHAPE_POINTS = 4

Particles will be emitted at a position chosen randomly among emission_points. Particle color will be modulated by emission_colors.

EmissionShape EMISSION_SHAPE_DIRECTED_POINTS = 5

Particles will be emitted at a position chosen randomly among emission_points. Particle velocity and rotation will be set based on emission_normals. Particle color will be modulated by emission_colors.

EmissionShape EMISSION_SHAPE_RING = 6

Particles will be emitted in the area of a ring parameterized by its outer and inner radius.

EmissionShape EMISSION_SHAPE_MAX = 7

Represents the size of the EmissionShape enum.

---

## Property Descriptions

int amount = 8 

- void set_amount(value: int)
- int get_amount()

Number of particles emitted in one emission cycle.

---

Curve angle_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's rotation will be animated along this Curve. Should be a unit Curve.

---

float angle_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial rotation applied to each particle, in degrees.

---

float angle_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of angle_max.

---

Curve angular_velocity_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's angular velocity will vary along this Curve. Should be a unit Curve.

---

float angular_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial angular velocity (rotation speed) applied to each particle in degrees per second.

---

float angular_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of angular_velocity_max.

---

Curve anim_offset_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's animation offset will vary along this Curve. Should be a unit Curve.

---

float anim_offset_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum animation offset that corresponds to frame index in the texture. 0 is the first frame, 1 is the last one. See CanvasItemMaterial.particles_animation.

---

float anim_offset_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of anim_offset_max.

---

Curve anim_speed_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's animation speed will vary along this Curve. Should be a unit Curve.

---

float anim_speed_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum particle animation speed. Animation speed of 1 means that the particles will make full 0 to 1 offset cycle during lifetime, 2 means 2 cycles etc.

With animation speed greater than 1, remember to enable CanvasItemMaterial.particles_anim_loop property if you want the animation to repeat.

---

float anim_speed_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of anim_speed_max.

---

Color color = Color(1, 1, 1, 1) 

- void set_color(value: Color)
- Color get_color()

Each particle's initial color. If texture is defined, it will be multiplied by this color.

---

Gradient color_initial_ramp 

- void set_color_initial_ramp(value: Gradient)
- Gradient get_color_initial_ramp()

Each particle's initial color will vary along this Gradient (multiplied with color).

---

Gradient color_ramp 

- void set_color_ramp(value: Gradient)
- Gradient get_color_ramp()

Each particle's color will vary along this Gradient over its lifetime (multiplied with color).

---

Curve damping_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Damping will vary along this Curve. Should be a unit Curve.

---

float damping_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

The maximum rate at which particles lose velocity. For example value of 100 means that the particle will go from 100 velocity to 0 in 1 second.

---

float damping_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of damping_max.

---

Vector2 direction = Vector2(1, 0) 

- void set_direction(value: Vector2)
- Vector2 get_direction()

Unit vector specifying the particles' emission direction.

---

DrawOrder draw_order = 0 

- void set_draw_order(value: DrawOrder)
- DrawOrder get_draw_order()

Particle draw order.

---

PackedColorArray emission_colors 

- void set_emission_colors(value: PackedColorArray)
- PackedColorArray get_emission_colors()

Sets the Colors to modulate particles by when using EMISSION_SHAPE_POINTS or EMISSION_SHAPE_DIRECTED_POINTS.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedColorArray for more details.

---

PackedVector2Array emission_normals 

- void set_emission_normals(value: PackedVector2Array)
- PackedVector2Array get_emission_normals()

Sets the direction the particles will be emitted in when using EMISSION_SHAPE_DIRECTED_POINTS.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

PackedVector2Array emission_points 

- void set_emission_points(value: PackedVector2Array)
- PackedVector2Array get_emission_points()

Sets the initial positions to spawn particles when using EMISSION_SHAPE_POINTS or EMISSION_SHAPE_DIRECTED_POINTS.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

Vector2 emission_rect_extents 

- void set_emission_rect_extents(value: Vector2)
- Vector2 get_emission_rect_extents()

The rectangle's extents if emission_shape is set to EMISSION_SHAPE_RECTANGLE.

---

float emission_ring_inner_radius 

- void set_emission_ring_inner_radius(value: float)
- float get_emission_ring_inner_radius()

The ring's inner radius if emission_shape is set to EMISSION_SHAPE_RING.

---

float emission_ring_radius 

- void set_emission_ring_radius(value: float)
- float get_emission_ring_radius()

The ring's outer radius if emission_shape is set to EMISSION_SHAPE_RING.

---

EmissionShape emission_shape = 0 

- void set_emission_shape(value: EmissionShape)
- EmissionShape get_emission_shape()

Particles will be emitted inside this region.

---

float emission_sphere_radius 

- void set_emission_sphere_radius(value: float)
- float get_emission_sphere_radius()

The sphere's radius if emission_shape is set to EMISSION_SHAPE_SPHERE.

---

bool emitting = true 

- void set_emitting(value: bool)
- bool is_emitting()

If true, particles are being emitted. emitting can be used to start and stop particles from emitting. However, if one_shot is true setting emitting to true will not restart the emission cycle until after all active particles finish processing. You can use the finished signal to be notified once all active particles finish processing.

---

float explosiveness = 0.0 

- void set_explosiveness_ratio(value: float)
- float get_explosiveness_ratio()

How rapidly particles in an emission cycle are emitted. If greater than 0, there will be a gap in emissions before the next cycle begins.

---

int fixed_fps = 0 

- void set_fixed_fps(value: int)
- int get_fixed_fps()

The particle system's frame rate is fixed to a value. For example, changing the value to 2 will make the particles render at 2 frames per second. Note this does not slow down the simulation of the particle system itself.

---

bool fract_delta = true 

- void set_fractional_delta(value: bool)
- bool get_fractional_delta()

If true, results in fractional delta calculation which has a smoother particles display effect.

---

Vector2 gravity = Vector2(0, 980) 

- void set_gravity(value: Vector2)
- Vector2 get_gravity()

Gravity applied to every particle.

---

Curve hue_variation_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's hue will vary along this Curve. Should be a unit Curve.

---

float hue_variation_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial hue variation applied to each particle. It will shift the particle color's hue.

---

float hue_variation_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of hue_variation_max.

---

float initial_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial velocity magnitude for each particle. Direction comes from direction and spread.

---

float initial_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of initial_velocity_max.

---

float lifetime = 1.0 

- void set_lifetime(value: float)
- float get_lifetime()

Amount of time each particle will exist.

---

float lifetime_randomness = 0.0 

- void set_lifetime_randomness(value: float)
- float get_lifetime_randomness()

Particle lifetime randomness ratio.

---

Curve linear_accel_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's linear acceleration will vary along this Curve. Should be a unit Curve.

---

float linear_accel_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum linear acceleration applied to each particle in the direction of motion.

---

float linear_accel_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of linear_accel_max.

---

bool local_coords = false 

- void set_use_local_coordinates(value: bool)
- bool get_use_local_coordinates()

If true, particles use the parent node's coordinate space (known as local coordinates). This will cause particles to move and rotate along the CPUParticles2D node (and its parents) when it is moved or rotated. If false, particles use global coordinates; they will not move or rotate along the CPUParticles2D node (and its parents) when it is moved or rotated.

---

bool one_shot = false 

- void set_one_shot(value: bool)
- bool get_one_shot()

If true, only one emission cycle occurs. If set true during a cycle, emission will stop at the cycle's end.

---

Curve orbit_velocity_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's orbital velocity will vary along this Curve. Should be a unit Curve.

---

float orbit_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum orbital velocity applied to each particle. Makes the particles circle around origin. Specified in number of full rotations around origin per second.

---

float orbit_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of orbit_velocity_max.

---

bool particle_flag_align_y = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

Align Y axis of particle with the direction of its velocity.

---

float preprocess = 0.0 

- void set_pre_process_time(value: float)
- float get_pre_process_time()

Particle system starts as if it had already run for this many seconds.

---

Curve radial_accel_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's radial acceleration will vary along this Curve. Should be a unit Curve.

---

float radial_accel_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum radial acceleration applied to each particle. Makes particle accelerate away from the origin or towards it if negative.

---

float radial_accel_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of radial_accel_max.

---

float randomness = 0.0 

- void set_randomness_ratio(value: float)
- float get_randomness_ratio()

Emission lifetime randomness ratio.

---

Curve scale_amount_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's scale will vary along this Curve. Should be a unit Curve.

---

float scale_amount_max = 1.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial scale applied to each particle.

---

float scale_amount_min = 1.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of scale_amount_max.

---

Curve scale_curve_x 

- void set_scale_curve_x(value: Curve)
- Curve get_scale_curve_x()

Each particle's horizontal scale will vary along this Curve. Should be a unit Curve.

split_scale must be enabled.

---

Curve scale_curve_y 

- void set_scale_curve_y(value: Curve)
- Curve get_scale_curve_y()

Each particle's vertical scale will vary along this Curve. Should be a unit Curve.

split_scale must be enabled.

---

int seed = 0 

- void set_seed(value: int)
- int get_seed()

Sets the random seed used by the particle system. Only effective if use_fixed_seed is true.

---

float speed_scale = 1.0 

- void set_speed_scale(value: float)
- float get_speed_scale()

Particle system's running speed scaling ratio. A value of 0 can be used to pause the particles.

---

bool split_scale = false 

- void set_split_scale(value: bool)
- bool get_split_scale()

If true, the scale curve will be split into x and y components. See scale_curve_x and scale_curve_y.

---

float spread = 45.0 

- void set_spread(value: float)
- float get_spread()

Each particle's initial direction range from +spread to -spread degrees.

---

Curve tangential_accel_curve 

- void set_param_curve(param: Parameter, curve: Curve)
- Curve get_param_curve(param: Parameter) const

Each particle's tangential acceleration will vary along this Curve. Should be a unit Curve.

---

float tangential_accel_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum tangential acceleration applied to each particle. Tangential acceleration is perpendicular to the particle's velocity giving the particles a swirling motion.

---

float tangential_accel_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of tangential_accel_max.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

Particle texture. If null, particles will be squares.

---

bool use_fixed_seed = false 

- void set_use_fixed_seed(value: bool)
- bool get_use_fixed_seed()

If true, particles will use the same seed for every simulation using the seed defined in seed. This is useful for situations where the visual outcome should be consistent across replays, for example when using Movie Maker mode.

---

## Method Descriptions

void convert_from_particles(particles: Node) 

Sets this node's properties to match a given GPUParticles2D node with an assigned ParticleProcessMaterial.

---

Curve get_param_curve(param: Parameter) const 

Returns the Curve of the parameter specified by Parameter.

---

float get_param_max(param: Parameter) const 

Returns the maximum value range for the given parameter.

---

float get_param_min(param: Parameter) const 

Returns the minimum value range for the given parameter.

---

bool get_particle_flag(particle_flag: ParticleFlags) const 

Returns the enabled state of the given particle flag.

---

void request_particles_process(process_time: float, process_time_residual: float = 0.0) 

Requests the particles to process for extra process time during a single frame.

process_time defines the time that the particles will process while emitting is on. process_time_residual defines the time that particles will process with emitting turned off for the simulation. When combined with speed_scale set to 0.0, this is useful to be able to seek a particle system timeline.

---

void restart(keep_seed: bool = false) 

Restarts the particle emitter.

If keep_seed is true, the current random seed will be preserved. Useful for seeking and playback.

---

void set_param_curve(param: Parameter, curve: Curve) 

Sets the Curve of the parameter specified by Parameter. Should be a unit Curve.

---

void set_param_max(param: Parameter, value: float) 

Sets the maximum value for the given parameter.

---

void set_param_min(param: Parameter, value: float) 

Sets the minimum value for the given parameter.

---

void set_particle_flag(particle_flag: ParticleFlags, enable: bool) 

Enables or disables the given particle flag.
