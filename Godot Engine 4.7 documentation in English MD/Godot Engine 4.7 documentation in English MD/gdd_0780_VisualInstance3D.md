# VisualInstance3D

Inherits: Node3D < Node < Object

Inherited By: Decal, FogVolume, GeometryInstance3D, GPUParticlesAttractor3D, GPUParticlesCollision3D, Light3D, LightmapGI, OccluderInstance3D, OpenXRVisibilityMask, ReflectionProbe, RootMotionView, VisibleOnScreenNotifier3D, VoxelGI

Parent of all visual 3D nodes.

## Description

The VisualInstance3D is used to connect a resource to a visual representation. All visual 3D nodes inherit from the VisualInstance3D. In general, you should not access the VisualInstance3D properties directly as they are accessed and managed by the nodes that inherit from VisualInstance3D. VisualInstance3D is the node representation of the RenderingServer instance.

## Properties

int | layers | 1
float | sorting_offset | 0.0
bool | sorting_use_aabb_center |

## Methods

AABB | _get_aabb() virtual const
AABB | get_aabb() const
RID | get_base() const
RID | get_instance() const
bool | get_layer_mask_value(layer_number: int) const
void | set_base(base: RID)
void | set_layer_mask_value(layer_number: int, value: bool)

---

## Property Descriptions

int layers = 1 

- void set_layer_mask(value: int)
- int get_layer_mask()

The render layer(s) this VisualInstance3D is drawn on.

This object will only be visible for Camera3Ds whose cull mask includes any of the render layers this VisualInstance3D is set to.

For Light3Ds, this can be used to control which VisualInstance3Ds are affected by a specific light. For GPUParticles3D, this can be used to control which particles are effected by a specific attractor. For Decals, this can be used to control which VisualInstance3Ds are affected by a specific decal.

To adjust layers more easily using a script, use get_layer_mask_value() and set_layer_mask_value().

Note: VoxelGI, SDFGI and LightmapGI will always take all layers into account to determine what contributes to global illumination. If this is an issue, set GeometryInstance3D.gi_mode to GeometryInstance3D.GI_MODE_DISABLED for meshes and Light3D.light_bake_mode to Light3D.BAKE_DISABLED for lights to exclude them from global illumination.

---

float sorting_offset = 0.0 

- void set_sorting_offset(value: float)
- float get_sorting_offset()

The amount by which the depth of this VisualInstance3D will be adjusted when sorting by depth. Uses the same units as the engine (which are typically meters). Adjusting it to a higher value will make the VisualInstance3D reliably draw on top of other VisualInstance3Ds that are otherwise positioned at the same spot. To ensure it always draws on top of other objects around it (not positioned at the same spot), set the value to be greater than the distance between this VisualInstance3D and the other nearby VisualInstance3Ds.

---

bool sorting_use_aabb_center 

- void set_sorting_use_aabb_center(value: bool)
- bool is_sorting_use_aabb_center()

If true, the object is sorted based on the AABB center. The object will be sorted based on the global position otherwise.

The AABB center based sorting is generally more accurate for 3D models. The position based sorting instead allows to better control the drawing order when working with GPUParticles3D and CPUParticles3D.

---

## Method Descriptions

AABB _get_aabb() virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

AABB get_aabb() const 

Returns the AABB (also known as the bounding box) for this VisualInstance3D.

---

RID get_base() const 

Returns the RID of the resource associated with this VisualInstance3D. For example, if the Node is a MeshInstance3D, this will return the RID of the associated Mesh.

---

RID get_instance() const 

Returns the RID of this instance. This RID is the same as the RID returned by RenderingServer.instance_create(). This RID is needed if you want to call RenderingServer functions directly on this VisualInstance3D.

---

bool get_layer_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the layers is enabled, given a layer_number between 1 and 20.

---

void set_base(base: RID) 

Sets the resource that is instantiated by this VisualInstance3D, which changes how the engine handles the VisualInstance3D under the hood. Equivalent to RenderingServer.instance_set_base().

---

void set_layer_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the layers, given a layer_number between 1 and 20.
