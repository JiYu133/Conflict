# GPUParticlesCollisionSDF3D

Inherits: GPUParticlesCollision3D < VisualInstance3D < Node3D < Node < Object

A baked signed distance field 3D particle collision shape affecting GPUParticles3D nodes.

## Description

A baked signed distance field 3D particle collision shape affecting GPUParticles3D nodes.

Signed distance fields (SDF) allow for efficiently representing approximate collision shapes for convex and concave objects of any shape. This is more flexible than GPUParticlesCollisionHeightField3D, but it requires a baking step.

Baking: The signed distance field texture can be baked by selecting the GPUParticlesCollisionSDF3D node in the editor, then clicking Bake SDF at the top of the 3D viewport. Any visible MeshInstance3Ds within the size will be taken into account for baking, regardless of their GeometryInstance3D.gi_mode.

Note: Baking a GPUParticlesCollisionSDF3D's texture is only possible within the editor, as there is no bake method exposed for use in exported projects. However, it's still possible to load pre-baked Texture3Ds into its texture property in an exported project.

Note: ParticleProcessMaterial.collision_mode must be ParticleProcessMaterial.COLLISION_RIGID or ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT on the GPUParticles3D's process material for collision to work.

Note: Particle collision only affects GPUParticles3D, not CPUParticles3D.

## Properties

int | bake_mask | 4294967295
Resolution | resolution | 2
Vector3 | size | Vector3(2, 2, 2)
Texture3D | texture |
float | thickness | 1.0

## Methods

bool | get_bake_mask_value(layer_number: int) const
void | set_bake_mask_value(layer_number: int, value: bool)

---

## Enumerations

enum Resolution
Resolution RESOLUTION_16 = 0

Bake a 16×16×16 signed distance field. This is the fastest option, but also the least precise.

Resolution RESOLUTION_32 = 1

Bake a 32×32×32 signed distance field.

Resolution RESOLUTION_64 = 2

Bake a 64×64×64 signed distance field.

Resolution RESOLUTION_128 = 3

Bake a 128×128×128 signed distance field.

Resolution RESOLUTION_256 = 4

Bake a 256×256×256 signed distance field.

Resolution RESOLUTION_512 = 5

Bake a 512×512×512 signed distance field. This is the slowest option, but also the most precise.

Resolution RESOLUTION_MAX = 6

Represents the size of the Resolution enum.

---

## Property Descriptions

int bake_mask = 4294967295 

- void set_bake_mask(value: int)
- int get_bake_mask()

The visual layers to account for when baking the particle collision SDF. Only MeshInstance3Ds whose VisualInstance3D.layers match with this bake_mask will be included in the generated particle collision SDF. By default, all objects are taken into account for the particle collision SDF baking.

---

Resolution resolution = 2 

- void set_resolution(value: Resolution)
- Resolution get_resolution()

The bake resolution to use for the signed distance field texture. The texture must be baked again for changes to the resolution property to be effective. Higher resolutions have a greater performance cost and take more time to bake. Higher resolutions also result in larger baked textures, leading to increased VRAM and storage space requirements. To improve performance and reduce bake times, use the lowest resolution possible for the object you're representing the collision of.

---

Vector3 size = Vector3(2, 2, 2) 

- void set_size(value: Vector3)
- Vector3 get_size()

The collision SDF's size in 3D units. To improve SDF quality, the size should be set as small as possible while covering the parts of the scene you need.

---

Texture3D texture 

- void set_texture(value: Texture3D)
- Texture3D get_texture()

The 3D texture representing the signed distance field.

---

float thickness = 1.0 

- void set_thickness(value: float)
- float get_thickness()

The collision shape's thickness. Unlike other particle colliders, GPUParticlesCollisionSDF3D is actually hollow on the inside. thickness can be increased to prevent particles from tunneling through the collision shape at high speeds, or when the GPUParticlesCollisionSDF3D is moved.

---

## Method Descriptions

bool get_bake_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the bake_mask is enabled, given a layer_number between 1 and 32.

---

void set_bake_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the bake_mask, given a layer_number between 1 and 32.
