# ParticleProcessMaterial

Inherits: Material < Resource < RefCounted < Object

Holds a particle configuration for GPUParticles2D or GPUParticles3D nodes.

## Description

ParticleProcessMaterial defines particle properties and behavior. It is used in the process_material of the GPUParticles2D and GPUParticles3D nodes. Some of this material's properties are applied to each particle when emitted, while others can have a CurveTexture or a GradientTexture1D applied to vary numerical or color values over the lifetime of the particle.

## Properties

Texture2D | alpha_curve |
Texture2D | angle_curve |
float | angle_max | 0.0
float | angle_min | 0.0
Texture2D | angular_velocity_curve |
float | angular_velocity_max | 0.0
float | angular_velocity_min | 0.0
Texture2D | anim_offset_curve |
float | anim_offset_max | 0.0
float | anim_offset_min | 0.0
Texture2D | anim_speed_curve |
float | anim_speed_max | 0.0
float | anim_speed_min | 0.0
bool | attractor_interaction_enabled | true
float | collision_bounce |
float | collision_friction |
CollisionMode | collision_mode | 0
bool | collision_use_scale | false
Color | color | Color(1, 1, 1, 1)
Texture2D | color_initial_ramp |
Texture2D | color_ramp |
Texture2D | damping_curve |
float | damping_max | 0.0
float | damping_min | 0.0
Vector3 | direction | Vector3(1, 0, 0)
Texture2D | directional_velocity_curve |
float | directional_velocity_max |
float | directional_velocity_min |
Vector3 | emission_box_extents |
Texture2D | emission_color_texture |
Texture2D | emission_curve |
Texture2D | emission_normal_texture |
int | emission_point_count |
Texture2D | emission_point_texture |
Vector3 | emission_ring_axis |
float | emission_ring_cone_angle |
float | emission_ring_height |
float | emission_ring_inner_radius |
float | emission_ring_radius |
EmissionShape | emission_shape | 0
Vector3 | emission_shape_offset | Vector3(0, 0, 0)
Vector3 | emission_shape_scale | Vector3(1, 1, 1)
float | emission_sphere_radius |
float | flatness | 0.0
Vector3 | gravity | Vector3(0, -9.8, 0)
Texture2D | hue_variation_curve |
float | hue_variation_max | 0.0
float | hue_variation_min | 0.0
float | inherit_velocity_ratio | 0.0
float | initial_velocity_max | 0.0
float | initial_velocity_min | 0.0
float | lifetime_randomness | 0.0
Texture2D | linear_accel_curve |
float | linear_accel_max | 0.0
float | linear_accel_min | 0.0
Texture2D | orbit_velocity_curve |
float | orbit_velocity_max | 0.0
float | orbit_velocity_min | 0.0
bool | particle_flag_align_y | false
bool | particle_flag_damping_as_friction | false
bool | particle_flag_disable_z | false
bool | particle_flag_inherit_emitter_scale | false
bool | particle_flag_rotate_y | false
Texture2D | radial_accel_curve |
float | radial_accel_max | 0.0
float | radial_accel_min | 0.0
Texture2D | radial_velocity_curve |
float | radial_velocity_max | 0.0
float | radial_velocity_min | 0.0
Vector3 | rotation_3d_max |
Vector3 | rotation_3d_min |
Texture2D | rotation_velocity_3d_curve |
Vector3 | rotation_velocity_3d_max |
Vector3 | rotation_velocity_3d_min |
Vector3 | scale_3d_max |
Vector3 | scale_3d_min |
Texture2D | scale_curve |
float | scale_max | 1.0
float | scale_min | 1.0
Texture2D | scale_over_velocity_curve |
float | scale_over_velocity_max | 0.0
float | scale_over_velocity_min | 0.0
float | spread | 45.0
int | sub_emitter_amount_at_collision |
int | sub_emitter_amount_at_end |
int | sub_emitter_amount_at_start |
float | sub_emitter_frequency |
bool | sub_emitter_keep_velocity | false
SubEmitterMode | sub_emitter_mode | 0
Texture2D | tangential_accel_curve |
float | tangential_accel_max | 0.0
float | tangential_accel_min | 0.0
bool | turbulence_enabled | false
float | turbulence_influence_max | 0.1
float | turbulence_influence_min | 0.1
Texture2D | turbulence_influence_over_life |
float | turbulence_initial_displacement_max | 0.0
float | turbulence_initial_displacement_min | 0.0
float | turbulence_noise_scale | 9.0
Vector3 | turbulence_noise_speed | Vector3(0, 0, 0)
float | turbulence_noise_speed_random | 0.2
float | turbulence_noise_strength | 1.0
bool | use_rotation_3d | false
bool | use_rotation_velocity_3d | false
bool | use_scale_3d | false
Texture2D | velocity_limit_curve |
Vector3 | velocity_pivot | Vector3(0, 0, 0)

## Methods

Vector2 | get_param(param: Parameter) const
float | get_param_max(param: Parameter) const
float | get_param_min(param: Parameter) const
Texture2D | get_param_texture(param: Parameter) const
bool | get_particle_flag(particle_flag: ParticleFlags) const
void | set_param(param: Parameter, value: Vector2)
void | set_param_max(param: Parameter, value: float)
void | set_param_min(param: Parameter, value: float)
void | set_param_texture(param: Parameter, texture: Texture2D)
void | set_particle_flag(particle_flag: ParticleFlags, enable: bool)

---

## Signals

emission_shape_changed() 

Emitted when this material's emission shape is changed in any way. This includes changes to emission_shape, emission_shape_scale, or emission_sphere_radius, and any other property that affects the emission shape's offset, size, scale, or orientation.

Note: This signal is only emitted inside the editor for performance reasons.

---

## Enumerations

enum Parameter
Parameter PARAM_INITIAL_LINEAR_VELOCITY = 0

Use with set_param_min(), set_param_max(), and set_param_texture() to set initial velocity properties.

Parameter PARAM_ANGULAR_VELOCITY = 1

Use with set_param_min(), set_param_max(), and set_param_texture() to set angular velocity properties.

Parameter PARAM_ORBIT_VELOCITY = 2

Use with set_param_min(), set_param_max(), and set_param_texture() to set orbital velocity properties.

Parameter PARAM_LINEAR_ACCEL = 3

Use with set_param_min(), set_param_max(), and set_param_texture() to set linear acceleration properties.

Parameter PARAM_RADIAL_ACCEL = 4

Use with set_param_min(), set_param_max(), and set_param_texture() to set radial acceleration properties.

Parameter PARAM_TANGENTIAL_ACCEL = 5

Use with set_param_min(), set_param_max(), and set_param_texture() to set tangential acceleration properties.

Parameter PARAM_DAMPING = 6

Use with set_param_min(), set_param_max(), and set_param_texture() to set damping properties.

Parameter PARAM_ANGLE = 7

Use with set_param_min(), set_param_max(), and set_param_texture() to set angle properties.

Parameter PARAM_SCALE = 8

Use with set_param_min(), set_param_max(), and set_param_texture() to set scale properties.

Parameter PARAM_HUE_VARIATION = 9

Use with set_param_min(), set_param_max(), and set_param_texture() to set hue variation properties.

Parameter PARAM_ANIM_SPEED = 10

Use with set_param_min(), set_param_max(), and set_param_texture() to set animation speed properties.

Parameter PARAM_ANIM_OFFSET = 11

Use with set_param_min(), set_param_max(), and set_param_texture() to set animation offset properties.

Parameter PARAM_RADIAL_VELOCITY = 15

Use with set_param_min(), set_param_max(), and set_param_texture() to set radial velocity properties.

Parameter PARAM_DIRECTIONAL_VELOCITY = 16

Use with set_param_min(), set_param_max(), and set_param_texture() to set directional velocity properties.

Parameter PARAM_SCALE_OVER_VELOCITY = 17

Use with set_param_min(), set_param_max(), and set_param_texture() to set scale over velocity properties.

Parameter PARAM_MAX = 18

Represents the size of the Parameter enum.

Parameter PARAM_TURB_VEL_INFLUENCE = 13

Use with set_param_min() and set_param_max() to set the turbulence minimum und maximum influence on each particles velocity.

Parameter PARAM_TURB_INIT_DISPLACEMENT = 14

Use with set_param_min() and set_param_max() to set the turbulence minimum and maximum displacement of the particles spawn position.

Parameter PARAM_TURB_INFLUENCE_OVER_LIFE = 12

Use with set_param_texture() to set the turbulence influence over the particles life time.

---

enum ParticleFlags
ParticleFlags PARTICLE_FLAG_ALIGN_Y_TO_VELOCITY = 0

Use with set_particle_flag() to set particle_flag_align_y.

ParticleFlags PARTICLE_FLAG_ROTATE_Y = 1

Use with set_particle_flag() to set particle_flag_rotate_y.

ParticleFlags PARTICLE_FLAG_DISABLE_Z = 2

Use with set_particle_flag() to set particle_flag_disable_z.

ParticleFlags PARTICLE_FLAG_DAMPING_AS_FRICTION = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ParticleFlags PARTICLE_FLAG_INHERIT_EMITTER_SCALE = 4

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ParticleFlags PARTICLE_FLAG_MAX = 5

Represents the size of the ParticleFlags enum.

---

enum EmissionShape
EmissionShape EMISSION_SHAPE_POINT = 0

All particles will be emitted from a single point.

EmissionShape EMISSION_SHAPE_SPHERE = 1

Particles will be emitted in the volume of a sphere.

EmissionShape EMISSION_SHAPE_SPHERE_SURFACE = 2

Particles will be emitted on the surface of a sphere.

EmissionShape EMISSION_SHAPE_BOX = 3

Particles will be emitted in the volume of a box.

EmissionShape EMISSION_SHAPE_POINTS = 4

Particles will be emitted at a position determined by sampling a random point on the emission_point_texture. Particle color will be modulated by emission_color_texture.

EmissionShape EMISSION_SHAPE_DIRECTED_POINTS = 5

Particles will be emitted at a position determined by sampling a random point on the emission_point_texture. Particle velocity and rotation will be set based on emission_normal_texture. Particle color will be modulated by emission_color_texture.

EmissionShape EMISSION_SHAPE_RING = 6

Particles will be emitted in a ring or cylinder.

EmissionShape EMISSION_SHAPE_MAX = 7

Represents the size of the EmissionShape enum.

---

enum SubEmitterMode
SubEmitterMode SUB_EMITTER_DISABLED = 0

The subemitter is disabled.

SubEmitterMode SUB_EMITTER_CONSTANT = 1

The submitter is emitted on the constant interval defined by sub_emitter_frequency.

SubEmitterMode SUB_EMITTER_AT_END = 2

The subemitter is emitted at the end of the particle's lifetime.

SubEmitterMode SUB_EMITTER_AT_COLLISION = 3

The subemitter is emitted when the particle collides.

SubEmitterMode SUB_EMITTER_AT_START = 4

The subemitter is emitted when the particle spawns.

SubEmitterMode SUB_EMITTER_MAX = 5

Represents the size of the SubEmitterMode enum.

---

enum CollisionMode
CollisionMode COLLISION_DISABLED = 0

No collision for particles. Particles will go through GPUParticlesCollision3D nodes.

CollisionMode COLLISION_RIGID = 1

RigidBody3D-style collision for particles using GPUParticlesCollision3D nodes.

CollisionMode COLLISION_HIDE_ON_CONTACT = 2

Hide particles instantly when colliding with a GPUParticlesCollision3D node. This can be combined with a subemitter that uses the COLLISION_RIGID collision mode to "replace" the parent particle with the subemitter on impact.

CollisionMode COLLISION_MAX = 3

Represents the size of the CollisionMode enum.

---

## Property Descriptions

Texture2D alpha_curve 

- void set_alpha_curve(value: Texture2D)
- Texture2D get_alpha_curve()

The alpha value of each particle's color will be multiplied by this CurveTexture over its lifetime.

Note: alpha_curve multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALPHA *= COLOR.a; must be inserted in the shader's fragment() function. Otherwise, alpha_curve will have no visible effect.

---

Texture2D angle_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's rotation will be animated along this CurveTexture.

---

float angle_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial rotation applied to each particle, in degrees.

Only applied when particle_flag_disable_z or particle_flag_rotate_y are true or the BaseMaterial3D being used to draw the particle is using BaseMaterial3D.BILLBOARD_PARTICLES.

---

float angle_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of angle_max.

---

Texture2D angular_velocity_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's angular velocity (rotation speed) will vary along this CurveTexture over its lifetime.

---

float angular_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial angular velocity (rotation speed) applied to each particle in degrees per second.

Only applied when particle_flag_disable_z or particle_flag_rotate_y are true or the BaseMaterial3D being used to draw the particle is using BaseMaterial3D.BILLBOARD_PARTICLES.

---

float angular_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of angular_velocity_max.

---

Texture2D anim_offset_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's animation offset will vary along this CurveTexture.

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

Texture2D anim_speed_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's animation speed will vary along this CurveTexture.

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

bool attractor_interaction_enabled = true 

- void set_attractor_interaction_enabled(value: bool)
- bool is_attractor_interaction_enabled()

If true, interaction with particle attractors is enabled. In 3D, attraction only occurs within the area defined by the GPUParticles3D node's GPUParticles3D.visibility_aabb.

---

float collision_bounce 

- void set_collision_bounce(value: float)
- float get_collision_bounce()

The particles' bounciness. Values range from 0 (no bounce) to 1 (full bounciness). Only effective if collision_mode is COLLISION_RIGID.

---

float collision_friction 

- void set_collision_friction(value: float)
- float get_collision_friction()

The particles' friction. Values range from 0 (frictionless) to 1 (maximum friction). Only effective if collision_mode is COLLISION_RIGID.

---

CollisionMode collision_mode = 0 

- void set_collision_mode(value: CollisionMode)
- CollisionMode get_collision_mode()

The particles' collision mode.

Note: 3D Particles can only collide with GPUParticlesCollision3D nodes, not PhysicsBody3D nodes. To make particles collide with various objects, you can add GPUParticlesCollision3D nodes as children of PhysicsBody3D nodes. In 3D, collisions only occur within the area defined by the GPUParticles3D node's GPUParticles3D.visibility_aabb.

Note: 2D Particles can only collide with LightOccluder2D nodes, not PhysicsBody2D nodes.

---

bool collision_use_scale = false 

- void set_collision_use_scale(value: bool)
- bool is_collision_using_scale()

If true, GPUParticles3D.collision_base_size is multiplied by the particle's effective scale (see scale_min, scale_max, scale_curve, and scale_over_velocity_curve).

---

Color color = Color(1, 1, 1, 1) 

- void set_color(value: Color)
- Color get_color()

Each particle's initial color. If the GPUParticles2D's texture is defined, it will be multiplied by this color.

Note: color multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function. Otherwise, color will have no visible effect.

---

Texture2D color_initial_ramp 

- void set_color_initial_ramp(value: Texture2D)
- Texture2D get_color_initial_ramp()

Each particle's initial color will vary along this GradientTexture1D (multiplied with color).

Note: color_initial_ramp multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function. Otherwise, color_initial_ramp will have no visible effect.

---

Texture2D color_ramp 

- void set_color_ramp(value: Texture2D)
- Texture2D get_color_ramp()

Each particle's color will vary along this GradientTexture1D over its lifetime (multiplied with color).

Note: color_ramp multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function. Otherwise, color_ramp will have no visible effect.

---

Texture2D damping_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Damping will vary along this CurveTexture.

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

Vector3 direction = Vector3(1, 0, 0) 

- void set_direction(value: Vector3)
- Vector3 get_direction()

Unit vector specifying the particles' emission direction.

---

Texture2D directional_velocity_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

A curve that specifies the velocity along each of the axes of the particle system along its lifetime.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float directional_velocity_max 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum directional velocity value, which is multiplied by directional_velocity_curve.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float directional_velocity_min 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum directional velocity value, which is multiplied by directional_velocity_curve.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

Vector3 emission_box_extents 

- void set_emission_box_extents(value: Vector3)
- Vector3 get_emission_box_extents()

The box's extents if emission_shape is set to EMISSION_SHAPE_BOX.

Note: emission_box_extents starts from the center point and applies the X, Y, and Z values in both directions. The size is twice the area of the extents.

---

Texture2D emission_color_texture 

- void set_emission_color_texture(value: Texture2D)
- Texture2D get_emission_color_texture()

Particle color will be modulated by color determined by sampling this texture at the same point as the emission_point_texture.

Note: emission_color_texture multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function. Otherwise, emission_color_texture will have no visible effect.

---

Texture2D emission_curve 

- void set_emission_curve(value: Texture2D)
- Texture2D get_emission_curve()

Each particle's color will be multiplied by this CurveTexture over its lifetime.

Note: emission_curve multiplies the particle mesh's vertex colors. To have a visible effect on a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function. Otherwise, emission_curve will have no visible effect.

---

Texture2D emission_normal_texture 

- void set_emission_normal_texture(value: Texture2D)
- Texture2D get_emission_normal_texture()

Particle velocity and rotation will be set by sampling this texture at the same point as the emission_point_texture. Used only in EMISSION_SHAPE_DIRECTED_POINTS. Can be created automatically from mesh or node by selecting "Create Emission Points from Mesh/Node" under the "Particles" tool in the toolbar.

---

int emission_point_count 

- void set_emission_point_count(value: int)
- int get_emission_point_count()

The number of emission points if emission_shape is set to EMISSION_SHAPE_POINTS or EMISSION_SHAPE_DIRECTED_POINTS.

---

Texture2D emission_point_texture 

- void set_emission_point_texture(value: Texture2D)
- Texture2D get_emission_point_texture()

Particles will be emitted at positions determined by sampling this texture at a random position. Used with EMISSION_SHAPE_POINTS and EMISSION_SHAPE_DIRECTED_POINTS. Can be created automatically from mesh or node by selecting "Create Emission Points from Mesh/Node" under the "Particles" tool in the toolbar.

---

Vector3 emission_ring_axis 

- void set_emission_ring_axis(value: Vector3)
- Vector3 get_emission_ring_axis()

The axis of the ring when using the emitter EMISSION_SHAPE_RING.

---

float emission_ring_cone_angle 

- void set_emission_ring_cone_angle(value: float)
- float get_emission_ring_cone_angle()

The angle of the cone when using the emitter EMISSION_SHAPE_RING. The default angle of 90 degrees results in a ring, while an angle of 0 degrees results in a cone. Intermediate values will result in a ring where one end is larger than the other.

Note: Depending on emission_ring_height, the angle may be clamped if the ring's end is reached to form a perfect cone.

---

float emission_ring_height 

- void set_emission_ring_height(value: float)
- float get_emission_ring_height()

The height of the ring when using the emitter EMISSION_SHAPE_RING.

---

float emission_ring_inner_radius 

- void set_emission_ring_inner_radius(value: float)
- float get_emission_ring_inner_radius()

The inner radius of the ring when using the emitter EMISSION_SHAPE_RING.

---

float emission_ring_radius 

- void set_emission_ring_radius(value: float)
- float get_emission_ring_radius()

The radius of the ring when using the emitter EMISSION_SHAPE_RING.

---

EmissionShape emission_shape = 0 

- void set_emission_shape(value: EmissionShape)
- EmissionShape get_emission_shape()

Particles will be emitted inside this region.

---

Vector3 emission_shape_offset = Vector3(0, 0, 0) 

- void set_emission_shape_offset(value: Vector3)
- Vector3 get_emission_shape_offset()

The offset for the emission_shape, in local space.

---

Vector3 emission_shape_scale = Vector3(1, 1, 1) 

- void set_emission_shape_scale(value: Vector3)
- Vector3 get_emission_shape_scale()

The scale of the emission_shape, in local space.

---

float emission_sphere_radius 

- void set_emission_sphere_radius(value: float)
- float get_emission_sphere_radius()

The sphere's radius if emission_shape is set to EMISSION_SHAPE_SPHERE.

---

float flatness = 0.0 

- void set_flatness(value: float)
- float get_flatness()

Amount of spread along the Y axis.

---

Vector3 gravity = Vector3(0, -9.8, 0) 

- void set_gravity(value: Vector3)
- Vector3 get_gravity()

Gravity applied to every particle.

---

Texture2D hue_variation_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's hue will vary along this CurveTexture.

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

float inherit_velocity_ratio = 0.0 

- void set_inherit_velocity_ratio(value: float)
- float get_inherit_velocity_ratio()

Percentage of the velocity of the respective GPUParticles2D or GPUParticles3D inherited by each particle when spawning.

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

float lifetime_randomness = 0.0 

- void set_lifetime_randomness(value: float)
- float get_lifetime_randomness()

Particle lifetime randomness ratio. The equation for the lifetime of a particle is lifetime * (1.0 - randf() * lifetime_randomness). For example, a lifetime_randomness of 0.4 scales the lifetime between 0.6 to 1.0 of its original value.

---

Texture2D linear_accel_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's linear acceleration will vary along this CurveTexture.

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

Texture2D orbit_velocity_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's orbital velocity will vary along this CurveTexture.

Note: For 3D orbital velocity, use a CurveXYZTexture.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float orbit_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum orbital velocity applied to each particle. Makes the particles circle around origin. Specified in number of full rotations around origin per second.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float orbit_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of orbit_velocity_max.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

bool particle_flag_align_y = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

Align Y axis of particle with the direction of its velocity.

---

bool particle_flag_damping_as_friction = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

Changes the behavior of the damping properties from a linear deceleration to a deceleration based on speed percentage.

---

bool particle_flag_disable_z = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

If true, particles will not move on the z axis.

---

bool particle_flag_inherit_emitter_scale = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

If true, particles will inherit the scale of the emitter.

Note: This has no effect when GPUParticles3D.local_coords is true, since particles in local space are already affected by the emitter's scale.

---

bool particle_flag_rotate_y = false 

- void set_particle_flag(particle_flag: ParticleFlags, enable: bool)
- bool get_particle_flag(particle_flag: ParticleFlags) const

If true, particles rotate around Y axis by angle_min.

---

Texture2D radial_accel_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's radial acceleration will vary along this CurveTexture.

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

Texture2D radial_velocity_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

A CurveTexture that defines the velocity over the particle's lifetime away (or toward) the velocity_pivot.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float radial_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum radial velocity applied to each particle. Makes particles move away from the velocity_pivot, or toward it if negative.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

float radial_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum radial velocity applied to each particle. Makes particles move away from the velocity_pivot, or toward it if negative.

Note: Animated velocities will not be affected by damping, use velocity_limit_curve instead.

---

Vector3 rotation_3d_max 

- void set_rotation_3d_max(value: Vector3)
- Vector3 get_rotation_3d_max()

The maximum 3D orientation, in degrees. Works only in 3D and if use_rotation_3d is enabled.

---

Vector3 rotation_3d_min 

- void set_rotation_3d_min(value: Vector3)
- Vector3 get_rotation_3d_min()

The minimum 3D orientation, in degrees. Works only in 3D and if use_rotation_3d is enabled.

---

Texture2D rotation_velocity_3d_curve 

- void set_rotation_velocity_3d_curve(value: Texture2D)
- Texture2D get_rotation_velocity_3d_curve()

Rotation velocity curve over lifetime, per-axis. Enable use_rotation_velocity_3d to use this.

---

Vector3 rotation_velocity_3d_max 

- void set_rotation_velocity_3d_max(value: Vector3)
- Vector3 get_rotation_velocity_3d_max()

Maximum 3D rotation velocity on the particle's local axis. Enable use_rotation_velocity_3d to use this.

---

Vector3 rotation_velocity_3d_min 

- void set_rotation_velocity_3d_min(value: Vector3)
- Vector3 get_rotation_velocity_3d_min()

Minimum 3D rotation velocity on the particle's local axis. Enable use_rotation_velocity_3d to use this.

---

Vector3 scale_3d_max 

- void set_scale_3d_max(value: Vector3)
- Vector3 get_scale_3d_max()

The maximum value of the random scale vector for each particle.

Works only if use_scale_3d is enabled.

---

Vector3 scale_3d_min 

- void set_scale_3d_min(value: Vector3)
- Vector3 get_scale_3d_min()

The minimum value of the random scale vector for each particle.

Works only if use_scale_3d is enabled.

---

Texture2D scale_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's scale will vary along this CurveTexture over its lifetime. If a CurveXYZTexture is supplied instead, the scale will be separated per-axis.

---

float scale_max = 1.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum initial scale applied to each particle.

---

float scale_min = 1.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum equivalent of scale_max.

---

Texture2D scale_over_velocity_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Either a CurveTexture or a CurveXYZTexture that scales each particle based on its velocity.

---

float scale_over_velocity_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum velocity value reference for scale_over_velocity_curve.

scale_over_velocity_curve will be interpolated between scale_over_velocity_min and scale_over_velocity_max.

---

float scale_over_velocity_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum velocity value reference for scale_over_velocity_curve.

scale_over_velocity_curve will be interpolated between scale_over_velocity_min and scale_over_velocity_max.

---

float spread = 45.0 

- void set_spread(value: float)
- float get_spread()

Each particle's initial direction range from +spread to -spread degrees.

---

int sub_emitter_amount_at_collision 

- void set_sub_emitter_amount_at_collision(value: int)
- int get_sub_emitter_amount_at_collision()

The amount of particles to spawn from the subemitter node when a collision occurs. When combined with COLLISION_HIDE_ON_CONTACT on the main particles material, this can be used to achieve effects such as raindrops hitting the ground.

Note: This value shouldn't exceed GPUParticles2D.amount or GPUParticles3D.amount defined on the subemitter node (not the main node), relative to the subemitter's particle lifetime. If the number of particles is exceeded, no new particles will spawn from the subemitter until enough particles have expired.

---

int sub_emitter_amount_at_end 

- void set_sub_emitter_amount_at_end(value: int)
- int get_sub_emitter_amount_at_end()

The amount of particles to spawn from the subemitter node when the particle expires.

Note: This value shouldn't exceed GPUParticles2D.amount or GPUParticles3D.amount defined on the subemitter node (not the main node), relative to the subemitter's particle lifetime. If the number of particles is exceeded, no new particles will spawn from the subemitter until enough particles have expired.

---

int sub_emitter_amount_at_start 

- void set_sub_emitter_amount_at_start(value: int)
- int get_sub_emitter_amount_at_start()

The amount of particles to spawn from the subemitter node when the particle spawns.

Note: This value shouldn't exceed GPUParticles2D.amount or GPUParticles3D.amount defined on the subemitter node (not the main node), relative to the subemitter's particle lifetime. If the number of particles is exceeded, no new particles will spawn from the subemitter until enough particles have expired.

---

float sub_emitter_frequency 

- void set_sub_emitter_frequency(value: float)
- float get_sub_emitter_frequency()

The frequency at which particles should be emitted from the subemitter node. One particle will be spawned every sub_emitter_frequency seconds.

Note: This value shouldn't exceed GPUParticles2D.amount or GPUParticles3D.amount defined on the subemitter node (not the main node), relative to the subemitter's particle lifetime. If the number of particles is exceeded, no new particles will spawn from the subemitter until enough particles have expired.

---

bool sub_emitter_keep_velocity = false 

- void set_sub_emitter_keep_velocity(value: bool)
- bool get_sub_emitter_keep_velocity()

If true, the subemitter inherits the parent particle's velocity when it spawns.

---

SubEmitterMode sub_emitter_mode = 0 

- void set_sub_emitter_mode(value: SubEmitterMode)
- SubEmitterMode get_sub_emitter_mode()

The particle subemitter mode (see GPUParticles2D.sub_emitter and GPUParticles3D.sub_emitter).

---

Texture2D tangential_accel_curve 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's tangential acceleration will vary along this CurveTexture.

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

bool turbulence_enabled = false 

- void set_turbulence_enabled(value: bool)
- bool get_turbulence_enabled()

If true, enables turbulence for the particle system. Turbulence can be used to vary particle movement according to its position (based on a 3D noise pattern). In 3D, GPUParticlesAttractorVectorField3D with NoiseTexture3D can be used as an alternative to turbulence that works in world space and with multiple particle systems reacting in the same way.

Note: Enabling turbulence has a high performance cost on the GPU. Only enable turbulence on a few particle systems at once at most, and consider disabling it when targeting mobile/web platforms.

---

float turbulence_influence_max = 0.1 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum turbulence influence on each particle.

The actual amount of turbulence influence on each particle is calculated as a random value between turbulence_influence_min and turbulence_influence_max and multiplied by the amount of turbulence influence from turbulence_influence_over_life.

---

float turbulence_influence_min = 0.1 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum turbulence influence on each particle.

The actual amount of turbulence influence on each particle is calculated as a random value between turbulence_influence_min and turbulence_influence_max and multiplied by the amount of turbulence influence from turbulence_influence_over_life.

---

Texture2D turbulence_influence_over_life 

- void set_param_texture(param: Parameter, texture: Texture2D)
- Texture2D get_param_texture(param: Parameter) const

Each particle's amount of turbulence will be influenced along this CurveTexture over its life time.

---

float turbulence_initial_displacement_max = 0.0 

- void set_param_max(param: Parameter, value: float)
- float get_param_max(param: Parameter) const

Maximum displacement of each particle's spawn position by the turbulence.

The actual amount of displacement will be a factor of the underlying turbulence multiplied by a random value between turbulence_initial_displacement_min and turbulence_initial_displacement_max.

---

float turbulence_initial_displacement_min = 0.0 

- void set_param_min(param: Parameter, value: float)
- float get_param_min(param: Parameter) const

Minimum displacement of each particle's spawn position by the turbulence.

The actual amount of displacement will be a factor of the underlying turbulence multiplied by a random value between turbulence_initial_displacement_min and turbulence_initial_displacement_max.

---

float turbulence_noise_scale = 9.0 

- void set_turbulence_noise_scale(value: float)
- float get_turbulence_noise_scale()

This value controls the overall scale/frequency of the turbulence noise pattern.

A small scale will result in smaller features with more detail while a high scale will result in smoother noise with larger features.

---

Vector3 turbulence_noise_speed = Vector3(0, 0, 0) 

- void set_turbulence_noise_speed(value: Vector3)
- Vector3 get_turbulence_noise_speed()

A scrolling velocity for the turbulence field. This sets a directional trend for the pattern to move in over time.

The default value of Vector3(0, 0, 0) turns off the scrolling.

---

float turbulence_noise_speed_random = 0.2 

- void set_turbulence_noise_speed_random(value: float)
- float get_turbulence_noise_speed_random()

The in-place rate of change of the turbulence field. This defines how quickly the noise pattern varies over time.

A value of 0.0 will result in a fixed pattern.

---

float turbulence_noise_strength = 1.0 

- void set_turbulence_noise_strength(value: float)
- float get_turbulence_noise_strength()

The turbulence noise strength. Increasing this will result in a stronger, more contrasting, flow pattern.

---

bool use_rotation_3d = false 

- void set_use_rotation_3d(value: bool)
- bool is_using_rotation_3d()

Enable the usage of rotation_3d_min and rotation_3d_max.

---

bool use_rotation_velocity_3d = false 

- void set_using_rotation_velocity_3d(value: bool)
- bool is_using_rotation_velocity_3d()

Enable 3D rotation velocity.

---

bool use_scale_3d = false 

- void set_use_scale_3d(value: bool)
- bool is_using_scale_3d()

Enable the usage of scale_3d_min and scale_3d_max.

---

Texture2D velocity_limit_curve 

- void set_velocity_limit_curve(value: Texture2D)
- Texture2D get_velocity_limit_curve()

A CurveTexture that defines the maximum velocity of a particle during its lifetime.

---

Vector3 velocity_pivot = Vector3(0, 0, 0) 

- void set_velocity_pivot(value: Vector3)
- Vector3 get_velocity_pivot()

A pivot point used to calculate radial and orbital velocity of particles.

---

## Method Descriptions

Vector2 get_param(param: Parameter) const 

Returns the minimum and maximum values of the given param as a vector.

The x component of the returned vector corresponds to minimum and the y component corresponds to maximum.

---

float get_param_max(param: Parameter) const 

Returns the maximum value range for the given parameter.

---

float get_param_min(param: Parameter) const 

Returns the minimum value range for the given parameter.

---

Texture2D get_param_texture(param: Parameter) const 

Returns the Texture2D used by the specified parameter.

---

bool get_particle_flag(particle_flag: ParticleFlags) const 

Returns true if the specified particle flag is enabled.

---

void set_param(param: Parameter, value: Vector2) 

Sets the minimum and maximum values of the given param.

The x component of the argument vector corresponds to minimum and the y component corresponds to maximum.

---

void set_param_max(param: Parameter, value: float) 

Sets the maximum value range for the given parameter.

---

void set_param_min(param: Parameter, value: float) 

Sets the minimum value range for the given parameter.

---

void set_param_texture(param: Parameter, texture: Texture2D) 

Sets the Texture2D for the specified Parameter.

---

void set_particle_flag(particle_flag: ParticleFlags, enable: bool) 

Sets the particle_flag to enable.
