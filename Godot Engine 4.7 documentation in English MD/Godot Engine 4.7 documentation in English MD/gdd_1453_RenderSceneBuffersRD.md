# RenderSceneBuffersRD

Inherits: RenderSceneBuffers < RefCounted < Object

Render scene buffer implementation for the RenderingDevice based renderers.

## Description

This object manages all 3D rendering buffers for the rendering device based renderers. An instance of this object is created for every viewport that has 3D rendering enabled. See also RenderSceneBuffers.

All buffers are organized in contexts. The default context is called render_buffers and can contain amongst others the color buffer, depth buffer, velocity buffers, VRS density map and MSAA variants of these buffers.

Buffers are only guaranteed to exist during rendering of the viewport.

Note: This is an internal rendering server object. Do not instantiate this class from a script.

## Methods

void | clear_context(context: StringName)
RID | create_texture(context: StringName, name: StringName, data_format: DataFormat, usage_bits: int, texture_samples: TextureSamples, size: Vector2i, layers: int, mipmaps: int, unique: bool, discardable: bool)
RID | create_texture_from_format(context: StringName, name: StringName, format: RDTextureFormat, view: RDTextureView, unique: bool)
RID | create_texture_view(context: StringName, name: StringName, view_name: StringName, view: RDTextureView)
RID | get_color_layer(layer: int, msaa: bool = false)
RID | get_color_texture(msaa: bool = false)
RID | get_depth_layer(layer: int, msaa: bool = false)
RID | get_depth_texture(msaa: bool = false)
float | get_fsr_sharpness() const
Vector2i | get_internal_size() const
ViewportMSAA | get_msaa_3d() const
RID | get_render_target() const
ViewportScaling3DMode | get_scaling_3d_mode() const
ViewportScreenSpaceAA | get_screen_space_aa() const
Vector2i | get_target_size() const
RID | get_texture(context: StringName, name: StringName) const
RDTextureFormat | get_texture_format(context: StringName, name: StringName) const
TextureSamples | get_texture_samples() const
RID | get_texture_slice(context: StringName, name: StringName, layer: int, mipmap: int, layers: int, mipmaps: int)
Vector2i | get_texture_slice_size(context: StringName, name: StringName, mipmap: int)
RID | get_texture_slice_view(context: StringName, name: StringName, layer: int, mipmap: int, layers: int, mipmaps: int, view: RDTextureView)
bool | get_use_debanding() const
bool | get_use_taa() const
RID | get_velocity_layer(layer: int, msaa: bool = false)
RID | get_velocity_texture(msaa: bool = false)
int | get_view_count() const
bool | has_texture(context: StringName, name: StringName) const

---

## Method Descriptions

void clear_context(context: StringName) 

Frees all buffers related to this context.

---

RID create_texture(context: StringName, name: StringName, data_format: DataFormat, usage_bits: int, texture_samples: TextureSamples, size: Vector2i, layers: int, mipmaps: int, unique: bool, discardable: bool) 

Create a new texture with the given definition and cache this under the given name. Will return the existing texture if it already exists.

---

RID create_texture_from_format(context: StringName, name: StringName, format: RDTextureFormat, view: RDTextureView, unique: bool) 

Create a new texture using the given format and view and cache this under the given name. Will return the existing texture if it already exists.

---

RID create_texture_view(context: StringName, name: StringName, view_name: StringName, view: RDTextureView) 

Create a new texture view for an existing texture and cache this under the given view_name. Will return the existing texture view if it already exists. Will error if the source texture doesn't exist.

---

RID get_color_layer(layer: int, msaa: bool = false) 

Returns the specified layer from the color texture we are rendering 3D content to.

If msaa is true and MSAA is enabled, this returns the MSAA variant of the buffer.

---

RID get_color_texture(msaa: bool = false) 

Returns the color texture we are rendering 3D content to. If multiview is used this will be a texture array with all views.

If msaa is true and MSAA is enabled, this returns the MSAA variant of the buffer.

---

RID get_depth_layer(layer: int, msaa: bool = false) 

Returns the specified layer from the depth texture we are rendering 3D content to.

If msaa is true and MSAA is enabled, this returns the MSAA variant of the buffer.

---

RID get_depth_texture(msaa: bool = false) 

Returns the depth texture we are rendering 3D content to. If multiview is used this will be a texture array with all views.

If msaa is true and MSAA is enabled, this returns the MSAA variant of the buffer.

---

float get_fsr_sharpness() const 

Returns the FSR sharpness value used while rendering the 3D content (if get_scaling_3d_mode() is an FSR mode).

---

Vector2i get_internal_size() const 

Returns the internal size of the render buffer (size before upscaling) with which textures are created by default.

---

ViewportMSAA get_msaa_3d() const 

Returns the applied 3D MSAA mode for this viewport.

---

RID get_render_target() const 

Returns the render target associated with this buffers object.

---

ViewportScaling3DMode get_scaling_3d_mode() const 

Returns the scaling mode used for upscaling.

---

ViewportScreenSpaceAA get_screen_space_aa() const 

Returns the screen-space antialiasing method applied.

---

Vector2i get_target_size() const 

Returns the target size of the render buffer (size after upscaling).

---

RID get_texture(context: StringName, name: StringName) const 

Returns a cached texture with this name.

---

RDTextureFormat get_texture_format(context: StringName, name: StringName) const 

Returns the texture format information with which a cached texture was created.

---

TextureSamples get_texture_samples() const 

Returns the number of MSAA samples used.

---

RID get_texture_slice(context: StringName, name: StringName, layer: int, mipmap: int, layers: int, mipmaps: int) 

Returns a specific slice (layer or mipmap) for a cached texture.

---

Vector2i get_texture_slice_size(context: StringName, name: StringName, mipmap: int) 

Returns the texture size of a given slice of a cached texture.

---

RID get_texture_slice_view(context: StringName, name: StringName, layer: int, mipmap: int, layers: int, mipmaps: int, view: RDTextureView) 

Returns a specific view of a slice (layer or mipmap) for a cached texture.

---

bool get_use_debanding() const 

Returns true if debanding is enabled.

---

bool get_use_taa() const 

Returns true if TAA is enabled.

---

RID get_velocity_layer(layer: int, msaa: bool = false) 

Returns the specified layer from the velocity texture we are rendering 3D content to.

---

RID get_velocity_texture(msaa: bool = false) 

Returns the velocity texture we are rendering 3D content to. If multiview is used this will be a texture array with all views.

If msaa is true and MSAA is enabled, this returns the MSAA variant of the buffer.

---

int get_view_count() const 

Returns the view count for the associated viewport.

---

bool has_texture(context: StringName, name: StringName) const 

Returns true if a cached texture exists for this name.
