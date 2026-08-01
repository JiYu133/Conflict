# GPUParticles2D

Inherits: Node2D < CanvasItem < Node < Object

A 2D particle emitter.

## Description

2D particle node used to create a variety of particle systems and effects. GPUParticles2D features an emitter that generates some number of particles at a given rate.

Use the process_material property to add a ParticleProcessMaterial to configure particle appearance and behavior. Alternatively, you can add a ShaderMaterial which will be applied to all particles.

2D particles can optionally collide with LightOccluder2D, but they don't collide with PhysicsBody2D nodes.

## Tutorials

- Particle systems (2D)
- 2D Particles Demo [https://godotengine.org/asset-library/asset/2724]
- 2D Dodge The Creeps Demo (uses GPUParticles2D for the trail behind the player) [https://godotengine.org/asset-library/asset/2712]

## Properties

int | amount | 8
float | amount_ratio | 1.0
float | collision_base_size | 1.0
DrawOrder | draw_order | 1
bool | emitting | true
float | explosiveness | 0.0
int | fixed_fps | 30
bool | fract_delta | true
float | interp_to_end | 0.0
bool | interpolate | true
float | lifetime | 1.0
bool | local_coords | false
bool | one_shot | false
float | preprocess | 0.0
Material | process_material |
float | randomness | 0.0
int | seed | 0
float | speed_scale | 1.0
NodePath | sub_emitter | NodePath("")
Texture2D | texture |
bool | trail_enabled | false
float | trail_lifetime | 0.3
int | trail_section_subdivisions | 4
int | trail_sections | 8
bool | use_fixed_seed | false
Rect2 | visibility_rect | Rect2(-100, -100, 200, 200)

## Methods

Rect2 | capture_rect() const
void | convert_from_particles(particles: Node)
void | emit_particle(xform: Transform2D, velocity: Vector2, color: Color, custom: Color, flags: int)
void | request_particles_process(process_time: float, process_time_residual: float = 0)
void | restart(keep_seed: bool = false)

---

## Signals

finished() 

Emitted when all active particles have finished processing. To immediately restart the emission cycle, call restart().

This signal is never emitted when one_shot is disabled, as particles will be emitted and processed continuously.

Note: For one_shot emitters, due to the particles being computed on the GPU, there may be a short period after receiving the signal during which setting emitting to true will not restart the emission cycle. This delay is avoided by instead calling restart().

---

## Enumerations

enum DrawOrder
DrawOrder DRAW_ORDER_INDEX = 0

Particles are drawn in the order emitted.

DrawOrder DRAW_ORDER_LIFETIME = 1

Particles are drawn in order of remaining lifetime. In other words, the particle with the highest lifetime is drawn at the front.

DrawOrder DRAW_ORDER_REVERSE_LIFETIME = 2

Particles are drawn in reverse order of remaining lifetime. In other words, the particle with the lowest lifetime is drawn at the front.

---

enum EmitFlags
EmitFlags EMIT_FLAG_POSITION = 1

Particle starts at the specified position.

EmitFlags EMIT_FLAG_ROTATION_SCALE = 2

Particle starts with specified rotation and scale.

EmitFlags EMIT_FLAG_VELOCITY = 4

Particle starts with the specified velocity vector, which defines the emission direction and speed.

EmitFlags EMIT_FLAG_COLOR = 8

Particle starts with specified color.

EmitFlags EMIT_FLAG_CUSTOM = 16

Particle starts with specified CUSTOM data.

---

## Property Descriptions

int amount = 8 

- void set_amount(value: int)
- int get_amount()

The number of particles to emit in one emission cycle. The effective emission rate is (amount * amount_ratio) / lifetime particles per second. Higher values will increase GPU requirements, even if not all particles are visible at a given time or if amount_ratio is decreased.

Note: Changing this value will cause the particle system to restart. To avoid this, change amount_ratio instead.

---

float amount_ratio = 1.0 

- void set_amount_ratio(value: float)
- float get_amount_ratio()

The ratio of particles that should actually be emitted. If set to a value lower than 1.0, this will set the amount of emitted particles throughout the lifetime to amount * amount_ratio. Unlike changing amount, changing amount_ratio while emitting does not affect already-emitted particles and doesn't cause the particle system to restart. amount_ratio can be used to create effects that make the number of emitted particles vary over time.

Note: Reducing the amount_ratio has no performance benefit, since resources need to be allocated and processed for the total amount of particles regardless of the amount_ratio. If you don't intend to change the number of particles emitted while the particles are emitting, make sure amount_ratio is set to 1 and change amount to your liking instead.

---

float collision_base_size = 1.0 

- void set_collision_base_size(value: float)
- float get_collision_base_size()

Multiplier for particle's collision radius. 1.0 corresponds to the size of the sprite. If particles appear to sink into the ground when colliding, increase this value. If particles appear to float when colliding, decrease this value. Only effective if ParticleProcessMaterial.collision_mode is ParticleProcessMaterial.COLLISION_RIGID or ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT.

Note: Particles always have a spherical collision shape.

---

DrawOrder draw_order = 1 

- void set_draw_order(value: DrawOrder)
- DrawOrder get_draw_order()

Particle draw order.

---

bool emitting = true 

- void set_emitting(value: bool)
- bool is_emitting()

If true, particles are being emitted. emitting can be used to start and stop particles from emitting. However, if one_shot is true setting emitting to true will not restart the emission cycle unless all active particles have finished processing. Use the finished signal to be notified once all active particles finish processing.

Note: For one_shot emitters, due to the particles being computed on the GPU, there may be a short period after receiving the finished signal during which setting this to true will not restart the emission cycle.

Tip: If your one_shot emitter needs to immediately restart emitting particles once finished signal is received, consider calling restart() instead of setting emitting.

---

float explosiveness = 0.0 

- void set_explosiveness_ratio(value: float)
- float get_explosiveness_ratio()

How rapidly particles in an emission cycle are emitted. If greater than 0, there will be a gap in emissions before the next cycle begins.

---

int fixed_fps = 30 

- void set_fixed_fps(value: int)
- int get_fixed_fps()

The particle system's frame rate is fixed to a value. For example, changing the value to 2 will make the particles render at 2 frames per second. Note this does not slow down the simulation of the particle system itself.

---

bool fract_delta = true 

- void set_fractional_delta(value: bool)
- bool get_fractional_delta()

If true, results in fractional delta calculation which has a smoother particles display effect.

---

float interp_to_end = 0.0 

- void set_interp_to_end(value: float)
- float get_interp_to_end()

Causes all the particles in this node to interpolate towards the end of their lifetime.

Note: This only works when used with a ParticleProcessMaterial. It needs to be manually implemented for custom process shaders.

---

bool interpolate = true 

- void set_interpolate(value: bool)
- bool get_interpolate()

Enables particle interpolation, which makes the particle movement smoother when their fixed_fps is lower than the screen refresh rate.

---

float lifetime = 1.0 

- void set_lifetime(value: float)
- float get_lifetime()

The amount of time each particle will exist (in seconds). The effective emission rate is (amount * amount_ratio) / lifetime particles per second.

---

bool local_coords = false 

- void set_use_local_coordinates(value: bool)
- bool get_use_local_coordinates()

If true, particles use the parent node's coordinate space (known as local coordinates). This will cause particles to move and rotate along the GPUParticles2D node (and its parents) when it is moved or rotated. If false, particles use global coordinates; they will not move or rotate along the GPUParticles2D node (and its parents) when it is moved or rotated.

---

bool one_shot = false 

- void set_one_shot(value: bool)
- bool get_one_shot()

If true, only one emission cycle occurs. If set true during a cycle, emission will stop at the cycle's end.

---

float preprocess = 0.0 

- void set_pre_process_time(value: float)
- float get_pre_process_time()

Particle system starts as if it had already run for this many seconds.

Note: This can be very expensive if set to a high number as it requires running the particle shader a number of times equal to the fixed_fps (or 30, if fixed_fps is 0) for every second. In extreme cases it can even lead to a GPU crash due to the volume of work done in a single frame.

---

Material process_material 

- void set_process_material(value: Material)
- Material get_process_material()

Material for processing particles. Can be a ParticleProcessMaterial or a ShaderMaterial.

---

float randomness = 0.0 

- void set_randomness_ratio(value: float)
- float get_randomness_ratio()

Emission lifetime randomness ratio.

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

NodePath sub_emitter = NodePath("") 

- void set_sub_emitter(value: NodePath)
- NodePath get_sub_emitter()

Path to another GPUParticles2D node that will be used as a subemitter (see ParticleProcessMaterial.sub_emitter_mode). Subemitters can be used to achieve effects such as fireworks, sparks on collision, bubbles popping into water drops, and more.

Note: When sub_emitter is set, the target GPUParticles2D node will no longer emit particles on its own.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

Particle texture. If null, particles will be squares with a size of 1×1 pixels.

Note: To use a flipbook texture, assign a new CanvasItemMaterial to the GPUParticles2D's CanvasItem.material property, then enable CanvasItemMaterial.particles_animation and set CanvasItemMaterial.particles_anim_h_frames, CanvasItemMaterial.particles_anim_v_frames, and CanvasItemMaterial.particles_anim_loop to match the flipbook texture.

---

bool trail_enabled = false 

- void set_trail_enabled(value: bool)
- bool is_trail_enabled()

If true, enables particle trails using a mesh skinning system.

Note: Unlike GPUParticles3D, the number of trail sections and subdivisions is set with the trail_sections and trail_section_subdivisions properties.

---

float trail_lifetime = 0.3 

- void set_trail_lifetime(value: float)
- float get_trail_lifetime()

The amount of time the particle's trail should represent (in seconds). Only effective if trail_enabled is true.

---

int trail_section_subdivisions = 4 

- void set_trail_section_subdivisions(value: int)
- int get_trail_section_subdivisions()

The number of subdivisions to use for the particle trail rendering. Higher values can result in smoother trail curves, at the cost of performance due to increased mesh complexity. See also trail_sections. Only effective if trail_enabled is true.

---

int trail_sections = 8 

- void set_trail_sections(value: int)
- int get_trail_sections()

The number of sections to use for the particle trail rendering. Higher values can result in smoother trail curves, at the cost of performance due to increased mesh complexity. See also trail_section_subdivisions. Only effective if trail_enabled is true.

---

bool use_fixed_seed = false 

- void set_use_fixed_seed(value: bool)
- bool get_use_fixed_seed()

If true, particles will use the same seed for every simulation using the seed defined in seed. This is useful for situations where the visual outcome should be consistent across replays, for example when using Movie Maker mode.

---

Rect2 visibility_rect = Rect2(-100, -100, 200, 200) 

- void set_visibility_rect(value: Rect2)
- Rect2 get_visibility_rect()

The Rect2 that determines the node's region which needs to be visible on screen for the particle system to be active.

Grow the rect if particles suddenly appear/disappear when the node enters/exits the screen. The Rect2 can be grown via code or with the Particles → Generate Visibility Rect editor tool.

---

## Method Descriptions

Rect2 capture_rect() const 

Returns a rectangle containing the positions of all existing particles.

Note: When using threaded rendering this method synchronizes the rendering thread. Calling it often may have a negative impact on performance.

---

void convert_from_particles(particles: Node) 

Sets this node's properties to match a given CPUParticles2D node.

---

void emit_particle(xform: Transform2D, velocity: Vector2, color: Color, custom: Color, flags: int) 

Emits a single particle. Whether xform, velocity, color and custom are applied depends on the value of flags. See EmitFlags.

The default ParticleProcessMaterial will overwrite color and use the contents of custom as (rotation, age, animation, lifetime).

Note: emit_particle() is only supported on the Forward+ and Mobile rendering methods, not Compatibility.

---

void request_particles_process(process_time: float, process_time_residual: float = 0) 

Requests the particles to process for extra process time during a single frame.

process_time defines the time that the particles will process while emitting is on. process_time_residual defines the time that particles will process with emitting turned off for the simulation. When combined with speed_scale set to 0.0, this is useful to be able to seek a particle system timeline.

---

void restart(keep_seed: bool = false) 

Restarts the particle emission cycle, clearing existing particles. To avoid particles vanishing from the viewport, wait for the finished signal before calling.

Note: The finished signal is only emitted by one_shot emitters.

If keep_seed is true, the current random seed will be preserved. Useful for seeking and playback.
