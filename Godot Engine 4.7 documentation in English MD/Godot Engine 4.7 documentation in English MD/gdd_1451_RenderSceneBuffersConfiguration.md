# RenderSceneBuffersConfiguration

Inherits: RefCounted < Object

Configuration object used to setup a RenderSceneBuffers object.

## Description

This configuration object is created and populated by the render engine on a viewport change and used to (re)configure a RenderSceneBuffers object.

## Properties

ViewportAnisotropicFiltering | anisotropic_filtering_level | 2
float | fsr_sharpness | 0.0
Vector2i | internal_size | Vector2i(0, 0)
ViewportMSAA | msaa_3d | 0
RID | render_target | RID()
ViewportScaling3DMode | scaling_3d_mode | 255
ViewportScreenSpaceAA | screen_space_aa | 0
Vector2i | target_size | Vector2i(0, 0)
float | texture_mipmap_bias | 0.0
int | view_count | 1

---

## Property Descriptions

ViewportAnisotropicFiltering anisotropic_filtering_level = 2 

- void set_anisotropic_filtering_level(value: ViewportAnisotropicFiltering)
- ViewportAnisotropicFiltering get_anisotropic_filtering_level()

Level of the anisotropic filter.

---

float fsr_sharpness = 0.0 

- void set_fsr_sharpness(value: float)
- float get_fsr_sharpness()

FSR Sharpness applicable if FSR upscaling is used.

---

Vector2i internal_size = Vector2i(0, 0) 

- void set_internal_size(value: Vector2i)
- Vector2i get_internal_size()

The size of the 3D render buffer used for rendering.

---

ViewportMSAA msaa_3d = 0 

- void set_msaa_3d(value: ViewportMSAA)
- ViewportMSAA get_msaa_3d()

The MSAA mode we're using for 3D rendering.

---

RID render_target = RID() 

- void set_render_target(value: RID)
- RID get_render_target()

The render target associated with these buffer.

---

ViewportScaling3DMode scaling_3d_mode = 255 

- void set_scaling_3d_mode(value: ViewportScaling3DMode)
- ViewportScaling3DMode get_scaling_3d_mode()

The requested scaling mode with which we upscale/downscale if internal_size and target_size are not equal.

---

ViewportScreenSpaceAA screen_space_aa = 0 

- void set_screen_space_aa(value: ViewportScreenSpaceAA)
- ViewportScreenSpaceAA get_screen_space_aa()

The requested screen space AA applied in post processing.

---

Vector2i target_size = Vector2i(0, 0) 

- void set_target_size(value: Vector2i)
- Vector2i get_target_size()

The target (upscale) size if scaling is used.

---

float texture_mipmap_bias = 0.0 

- void set_texture_mipmap_bias(value: float)
- float get_texture_mipmap_bias()

Bias applied to mipmaps.

Note: This property is only supported in the Forward+ and Mobile renderers, not Compatibility. In Compatibility, this property is always treated as if it was set to 0.0.

---

int view_count = 1 

- void set_view_count(value: int)
- int get_view_count()

The number of views we're rendering.
