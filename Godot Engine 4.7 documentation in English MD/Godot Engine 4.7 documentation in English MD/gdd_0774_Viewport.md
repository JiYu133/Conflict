# Viewport

Inherits: Node < Object

Inherited By: SubViewport, Window

Abstract base class for viewports. Encapsulates drawing and interaction with a game world.

## Description

A Viewport creates a different view into the screen, or a sub-view inside another viewport. Child 2D nodes will display on it, and child Camera3D 3D nodes will render on it too.

Optionally, a viewport can have its own 2D or 3D world, so it doesn't share what it draws with other viewports.

Viewports can also choose to be audio listeners, so they generate positional audio depending on a 2D or 3D camera child of it.

Also, viewports can be assigned to different screens in case the devices have multiple screens.

Finally, viewports can also behave as render targets, in which case they will not be visible unless the associated texture is used to draw.

## Tutorials

- Using Viewports
- Viewport and canvas transforms
- GUI in 3D Viewport Demo [https://godotengine.org/asset-library/asset/2807]
- 3D in 2D Viewport Demo [https://godotengine.org/asset-library/asset/2804]
- 2D in 3D Viewport Demo [https://godotengine.org/asset-library/asset/2803]
- Screen Capture Demo [https://godotengine.org/asset-library/asset/2808]
- Dynamic Split Screen Demo [https://godotengine.org/asset-library/asset/2806]
- 3D Resolution Scaling Demo [https://godotengine.org/asset-library/asset/2805]

## Properties

AnisotropicFiltering | anisotropic_filtering_level | 2
bool | audio_listener_enable_2d | false
bool | audio_listener_enable_3d | false
int | canvas_cull_mask | 4294967295
DefaultCanvasItemTextureFilter | canvas_item_default_texture_filter | 1
DefaultCanvasItemTextureRepeat | canvas_item_default_texture_repeat | 0
Transform2D | canvas_transform |
DebugDraw | debug_draw | 0
bool | disable_3d | false
float | fsr_sharpness | 0.2
Transform2D | global_canvas_transform |
bool | gui_disable_input | false
int | gui_drag_threshold | 10
bool | gui_embed_subwindows | false
bool | gui_snap_controls_to_pixels | true
bool | handle_input_locally | true
float | mesh_lod_threshold | 1.0
MSAA | msaa_2d | 0
MSAA | msaa_3d | 0
bool | oversampling | true
float | oversampling_override | 0.0
bool | own_world_3d | false
PhysicsInterpolationMode | physics_interpolation_mode | 1 (overrides Node)
bool | physics_object_picking | false
bool | physics_object_picking_first_only | false
bool | physics_object_picking_sort | false
bool | positional_shadow_atlas_16_bits | true
PositionalShadowAtlasQuadrantSubdiv | positional_shadow_atlas_quad_0 | 2
PositionalShadowAtlasQuadrantSubdiv | positional_shadow_atlas_quad_1 | 2
PositionalShadowAtlasQuadrantSubdiv | positional_shadow_atlas_quad_2 | 3
PositionalShadowAtlasQuadrantSubdiv | positional_shadow_atlas_quad_3 | 4
int | positional_shadow_atlas_size | 2048
Scaling3DMode | scaling_3d_mode | 0
float | scaling_3d_scale | 1.0
ScreenSpaceAA | screen_space_aa | 0
SDFOversize | sdf_oversize | 1
SDFScale | sdf_scale | 1
bool | snap_2d_transforms_to_pixel | false
bool | snap_2d_vertices_to_pixel | false
float | texture_mipmap_bias | 0.0
bool | transparent_bg | false
bool | use_debanding | false
bool | use_hdr_2d | false
bool | use_occlusion_culling | false
bool | use_taa | false
bool | use_xr | false
VRSMode | vrs_mode | 0
Texture2D | vrs_texture |
VRSUpdateMode | vrs_update_mode | 1
World2D | world_2d |
World3D | world_3d |

## Methods

World2D | find_world_2d() const
World3D | find_world_3d() const
AudioListener2D | get_audio_listener_2d() const
AudioListener3D | get_audio_listener_3d() const
Camera2D | get_camera_2d() const
Camera3D | get_camera_3d() const
bool | get_canvas_cull_mask_bit(layer: int) const
Array[Window] | get_embedded_subwindows() const
Transform2D | get_final_transform() const
Vector2 | get_mouse_position() const
float | get_oversampling() const
PositionalShadowAtlasQuadrantSubdiv | get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const
int | get_render_info(type: RenderInfoType, info: RenderInfo)
Transform2D | get_screen_transform() const
Transform2D | get_stretch_transform() const
ViewportTexture | get_texture() const
RID | get_viewport_rid() const
Rect2 | get_visible_rect() const
void | gui_cancel_drag()
Variant | gui_get_drag_data() const
String | gui_get_drag_description() const
Control | gui_get_focus_owner() const
Control | gui_get_hovered_control() const
bool | gui_is_drag_successful() const
bool | gui_is_dragging() const
void | gui_release_focus()
void | gui_set_drag_description(description: String)
bool | is_input_handled() const
void | notify_mouse_entered()
void | notify_mouse_exited()
void | push_input(event: InputEvent, in_local_coords: bool = false)
void | push_text_input(text: String)
void | push_unhandled_input(event: InputEvent, in_local_coords: bool = false)
void | set_canvas_cull_mask_bit(layer: int, enable: bool)
void | set_input_as_handled()
void | set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv)
void | update_mouse_cursor_state()
void | warp_mouse(position: Vector2)

---

## Signals

gui_focus_changed(node: Control) 

Emitted when a Control node grabs keyboard focus.

Note: A Control node losing focus doesn't cause this signal to be emitted.

---

size_changed() 

Emitted when the size of the viewport is changed, whether by resizing of window, or some other means.

---

## Enumerations

enum PositionalShadowAtlasQuadrantSubdiv
PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED = 0

This quadrant will not be used.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_1 = 1

This quadrant will only be used by one shadow map.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_4 = 2

This quadrant will be split in 4 and used by up to 4 shadow maps.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_16 = 3

This quadrant will be split 16 ways and used by up to 16 shadow maps.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_64 = 4

This quadrant will be split 64 ways and used by up to 64 shadow maps.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_256 = 5

This quadrant will be split 256 ways and used by up to 256 shadow maps. Unless the positional_shadow_atlas_size is very high, the shadows in this quadrant will be very low resolution.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_1024 = 6

This quadrant will be split 1024 ways and used by up to 1024 shadow maps. Unless the positional_shadow_atlas_size is very high, the shadows in this quadrant will be very low resolution.

PositionalShadowAtlasQuadrantSubdiv SHADOW_ATLAS_QUADRANT_SUBDIV_MAX = 7

Represents the size of the PositionalShadowAtlasQuadrantSubdiv enum.

---

enum Scaling3DMode
Scaling3DMode SCALING_3D_MODE_BILINEAR = 0

Use bilinear scaling for the viewport's 3D buffer. The amount of scaling can be set using scaling_3d_scale. Values less than 1.0 will result in undersampling while values greater than 1.0 will result in supersampling. A value of 1.0 disables scaling.

Scaling3DMode SCALING_3D_MODE_FSR = 1

Use AMD FidelityFX Super Resolution 1.0 upscaling for the viewport's 3D buffer. The amount of scaling can be set using scaling_3d_scale. Values less than 1.0 will result in the viewport being upscaled using FSR. Values greater than 1.0 are not supported and bilinear downsampling will be used instead. A value of 1.0 disables scaling.

Scaling3DMode SCALING_3D_MODE_FSR2 = 2

Use AMD FidelityFX Super Resolution 2.2 upscaling for the viewport's 3D buffer. The amount of scaling can be set using scaling_3d_scale. Values less than 1.0 will result in the viewport being upscaled using FSR2. Values greater than 1.0 are not supported and bilinear downsampling will be used instead. A value of 1.0 will use FSR2 at native resolution as a TAA solution.

Scaling3DMode SCALING_3D_MODE_METALFX_SPATIAL = 3

Use the MetalFX spatial upscaler [https://developer.apple.com/documentation/metalfx/mtlfxspatialscaler#overview] for the viewport's 3D buffer.

The amount of scaling can be set using scaling_3d_scale.

Values less than 1.0 will result in the viewport being upscaled using MetalFX. Values greater than 1.0 are not supported and bilinear downsampling will be used instead. A value of 1.0 disables scaling.

More information: MetalFX [https://developer.apple.com/documentation/metalfx].

Note: Only supported when the Metal rendering driver is in use, which limits this scaling mode to macOS and iOS.

Scaling3DMode SCALING_3D_MODE_METALFX_TEMPORAL = 4

Use the MetalFX temporal upscaler [https://developer.apple.com/documentation/metalfx/mtlfxtemporalscaler#overview] for the viewport's 3D buffer.

The amount of scaling can be set using scaling_3d_scale. To determine the minimum input scale, use the RenderingDevice.limit_get() method with RenderingDevice.LIMIT_METALFX_TEMPORAL_SCALER_MIN_SCALE.

Values less than 1.0 will result in the viewport being upscaled using MetalFX. Values greater than 1.0 are not supported and bilinear downsampling will be used instead. A value of 1.0 will use MetalFX at native resolution as a TAA solution.

More information: MetalFX [https://developer.apple.com/documentation/metalfx].

Note: Only supported when the Metal rendering driver is in use, which limits this scaling mode to macOS and iOS.

Scaling3DMode SCALING_3D_MODE_NEAREST = 5

Use nearest-neighbor filtering for the viewport's 3D buffer. This looks crisper than SCALING_3D_MODE_BILINEAR and has no additional rendering cost. The amount of scaling can be set using scaling_3d_scale. Values greater than 1.0 are not supported and bilinear downsampling will be used instead. A value of 1.0 disables scaling.

Note: When using the Nearest scaling mode, to avoid uneven pixel scaling, it's highly recommended to use a value equal to an integer divisor with a dividend of 1. For example, it's best to use a scale of 0.5 (1/2), 0.3333 (1/3), 0.25 (1/4), 0.2 (1/5), and so on.

Scaling3DMode SCALING_3D_MODE_MAX = 6

Represents the size of the Scaling3DMode enum.

---

enum MSAA
MSAA MSAA_DISABLED = 0

Multisample antialiasing mode disabled. This is the default value, and is also the fastest setting.

MSAA MSAA_2X = 1

Use 2× Multisample Antialiasing. This has a moderate performance cost. It helps reduce aliasing noticeably, but 4× MSAA still looks substantially better.

MSAA MSAA_4X = 2

Use 4× Multisample Antialiasing. This has a significant performance cost, and is generally a good compromise between performance and quality.

MSAA MSAA_8X = 3

Use 8× Multisample Antialiasing. This has a very high performance cost. The difference between 4× and 8× MSAA may not always be visible in real gameplay conditions. Likely unsupported on low-end and older hardware.

MSAA MSAA_MAX = 4

Represents the size of the MSAA enum.

---

enum AnisotropicFiltering
AnisotropicFiltering ANISOTROPY_DISABLED = 0

Anisotropic filtering is disabled.

AnisotropicFiltering ANISOTROPY_2X = 1

Use 2× anisotropic filtering.

AnisotropicFiltering ANISOTROPY_4X = 2

Use 4× anisotropic filtering. This is the default value.

AnisotropicFiltering ANISOTROPY_8X = 3

Use 8× anisotropic filtering.

AnisotropicFiltering ANISOTROPY_16X = 4

Use 16× anisotropic filtering.

AnisotropicFiltering ANISOTROPY_MAX = 5

Represents the size of the AnisotropicFiltering enum.

---

enum ScreenSpaceAA
ScreenSpaceAA SCREEN_SPACE_AA_DISABLED = 0

Do not perform any antialiasing in the full screen post-process.

ScreenSpaceAA SCREEN_SPACE_AA_FXAA = 1

Use fast approximate antialiasing. FXAA is a popular screen-space antialiasing method, which is fast but will make the image look blurry, especially at lower resolutions. It can still work relatively well at large resolutions such as 1440p and 4K.

ScreenSpaceAA SCREEN_SPACE_AA_SMAA = 2

Use subpixel morphological antialiasing. SMAA may produce clearer results than FXAA, but at a slightly higher performance cost.

ScreenSpaceAA SCREEN_SPACE_AA_MAX = 3

Represents the size of the ScreenSpaceAA enum.

---

enum RenderInfo
RenderInfo RENDER_INFO_OBJECTS_IN_FRAME = 0

Amount of objects in frame.

RenderInfo RENDER_INFO_PRIMITIVES_IN_FRAME = 1

Amount of vertices in frame.

RenderInfo RENDER_INFO_DRAW_CALLS_IN_FRAME = 2

Amount of draw calls in frame.

RenderInfo RENDER_INFO_MAX = 3

Represents the size of the RenderInfo enum.

---

enum RenderInfoType
RenderInfoType RENDER_INFO_TYPE_VISIBLE = 0

Visible render pass (excluding shadows).

RenderInfoType RENDER_INFO_TYPE_SHADOW = 1

Shadow render pass. Objects will be rendered several times depending on the number of amounts of lights with shadows and the number of directional shadow splits.

RenderInfoType RENDER_INFO_TYPE_CANVAS = 2

Canvas item rendering. This includes all 2D rendering.

RenderInfoType RENDER_INFO_TYPE_MAX = 3

Represents the size of the RenderInfoType enum.

---

enum DebugDraw
DebugDraw DEBUG_DRAW_DISABLED = 0

Objects are displayed normally.

DebugDraw DEBUG_DRAW_UNSHADED = 1

Objects are displayed without light information.

DebugDraw DEBUG_DRAW_LIGHTING = 2

Objects are displayed without textures and only with lighting information.

Note: When using this debug draw mode, custom shaders are ignored since all materials in the scene temporarily use a debug material. This means the result from custom shader functions (such as vertex displacement) won't be visible anymore when using this debug draw mode.

DebugDraw DEBUG_DRAW_OVERDRAW = 3

Objects are displayed semi-transparent with additive blending so you can see where they are drawing over top of one another. A higher overdraw means you are wasting performance on drawing pixels that are being hidden behind others.

Note: When using this debug draw mode, custom shaders are ignored since all materials in the scene temporarily use a debug material. This means the result from custom shader functions (such as vertex displacement) won't be visible anymore when using this debug draw mode.

DebugDraw DEBUG_DRAW_WIREFRAME = 4

Objects are displayed as wireframe models.

Note: RenderingServer.set_debug_generate_wireframes() must be called before loading any meshes for wireframes to be visible when using the Compatibility renderer.

Note: In the Compatibility renderer, backfaces are always visible when using wireframe rendering. In the Forward+ and Mobile renderers, wireframes follow the material's backface culling properties instead.

DebugDraw DEBUG_DRAW_NORMAL_BUFFER = 5

Objects are displayed without lighting information and their textures replaced by normal mapping.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_VOXEL_GI_ALBEDO = 6

Objects are displayed with only the albedo value from VoxelGIs. Requires at least one visible VoxelGI node that has been baked to have a visible effect.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_VOXEL_GI_LIGHTING = 7

Objects are displayed with only the lighting value from VoxelGIs. Requires at least one visible VoxelGI node that has been baked to have a visible effect.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_VOXEL_GI_EMISSION = 8

Objects are displayed with only the emission color from VoxelGIs. Requires at least one visible VoxelGI node that has been baked to have a visible effect.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_SHADOW_ATLAS = 9

Draws the shadow atlas that stores shadows from OmniLight3Ds and SpotLight3Ds in the upper left quadrant of the Viewport.

DebugDraw DEBUG_DRAW_DIRECTIONAL_SHADOW_ATLAS = 10

Draws the shadow atlas that stores shadows from DirectionalLight3Ds in the upper left quadrant of the Viewport.

DebugDraw DEBUG_DRAW_SCENE_LUMINANCE = 11

Draws the scene luminance buffer (if available) in the upper left quadrant of the Viewport.

Note: Only supported when using the Forward+ or Mobile rendering methods.

DebugDraw DEBUG_DRAW_SSAO = 12

Draws the screen-space ambient occlusion texture instead of the scene so that you can clearly see how it is affecting objects. In order for this display mode to work, you must have Environment.ssao_enabled set in your WorldEnvironment.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_SSIL = 13

Draws the screen-space indirect lighting texture instead of the scene so that you can clearly see how it is affecting objects. In order for this display mode to work, you must have Environment.ssil_enabled set in your WorldEnvironment.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_PSSM_SPLITS = 14

Colors each PSSM split for the DirectionalLight3Ds in the scene a different color so you can see where the splits are. In order (from closest to furthest from the camera), they are colored red, green, blue, and yellow.

Note: When using this debug draw mode, custom shaders are ignored since all materials in the scene temporarily use a debug material. This means the result from custom shader functions (such as vertex displacement) won't be visible anymore when using this debug draw mode.

Note: Only supported when using the Forward+ or Mobile rendering methods.

DebugDraw DEBUG_DRAW_DECAL_ATLAS = 15

Draws the decal atlas used by Decals and light projector textures in the upper left quadrant of the Viewport.

Note: Only supported when using the Forward+ or Mobile rendering methods.

DebugDraw DEBUG_DRAW_SDFGI = 16

Draws the cascades used to render signed distance field global illumination (SDFGI).

Does nothing if the current environment's Environment.sdfgi_enabled is false.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_SDFGI_PROBES = 17

Draws the probes used for signed distance field global illumination (SDFGI).

When in the editor, left-clicking a probe will display additional bright dots that show its occlusion information. A white dot means the light is not occluded at all at the dot's position, while a red dot means the light is fully occluded. Intermediate values are possible.

Does nothing if the current environment's Environment.sdfgi_enabled is false.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_GI_BUFFER = 18

Draws the buffer used for global illumination from VoxelGI or SDFGI. Requires VoxelGI (at least one visible baked VoxelGI node) or SDFGI (Environment.sdfgi_enabled) to be enabled to have a visible effect.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_DISABLE_LOD = 19

Draws all of the objects at their highest polycount regardless of their distance from the camera. No low level of detail (LOD) is applied.

DebugDraw DEBUG_DRAW_CLUSTER_OMNI_LIGHTS = 20

Draws the cluster used by OmniLight3D nodes to optimize light rendering.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_CLUSTER_SPOT_LIGHTS = 21

Draws the cluster used by SpotLight3D nodes to optimize light rendering.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_CLUSTER_DECALS = 22

Draws the cluster used by Decal nodes to optimize decal rendering.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_CLUSTER_REFLECTION_PROBES = 23

Draws the cluster used by ReflectionProbe nodes to optimize reflection probes.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_OCCLUDERS = 24

Draws the buffer used for occlusion culling.

Note: Only supported when using the Forward+ or Mobile rendering methods.

DebugDraw DEBUG_DRAW_MOTION_VECTORS = 25

Draws vector lines over the viewport to indicate the movement of pixels between frames.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_INTERNAL_BUFFER = 26

Draws the internal resolution buffer of the scene in linear colorspace before tonemapping or post-processing is applied.

Note: Only supported when using the Forward+ or Mobile rendering methods.

DebugDraw DEBUG_DRAW_CLUSTER_AREA_LIGHTS = 27

Draws the cluster used by AreaLight3D nodes to optimize light rendering.

Note: Only supported when using the Forward+ rendering method.

DebugDraw DEBUG_DRAW_AREA_LIGHT_ATLAS = 28

Draws the atlas used by AreaLight3D nodes in the upper left quadrant of the Viewport.

Note: Only supported when using the Forward+ or Mobile rendering method.

---

enum DefaultCanvasItemTextureFilter
DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST = 0

The texture filter reads from the nearest pixel only. This makes the texture look pixelated from up close, and grainy from a distance (due to mipmaps not being sampled).

DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR = 1

The texture filter blends between the nearest 4 pixels. This makes the texture look smooth from up close, and grainy from a distance (due to mipmaps not being sampled).

DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS = 2

The texture filter blends between the nearest 4 pixels and between the nearest 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true). This makes the texture look smooth from up close, and smooth from a distance.

Use this for non-pixel art textures that may be viewed at a low scale (e.g. due to Camera2D zoom or sprite scaling), as mipmaps are important to smooth out pixels that are smaller than on-screen pixels.

DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST_WITH_MIPMAPS = 3

The texture filter reads from the nearest pixel and blends between the nearest 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true). This makes the texture look pixelated from up close, and smooth from a distance.

Use this for non-pixel art textures that may be viewed at a low scale (e.g. due to Camera2D zoom or sprite scaling), as mipmaps are important to smooth out pixels that are smaller than on-screen pixels.

DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_PARENT_NODE = 4

The Viewport will inherit the filter from its parent CanvasItem or Viewport.

DefaultCanvasItemTextureFilter DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_MAX = 5

Represents the size of the DefaultCanvasItemTextureFilter enum.

---

enum DefaultCanvasItemTextureRepeat
DefaultCanvasItemTextureRepeat DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_DISABLED = 0

Disables textures repeating. Instead, when reading UVs outside the 0-1 range, the value will be clamped to the edge of the texture, resulting in a stretched out look at the borders of the texture.

DefaultCanvasItemTextureRepeat DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED = 1

Enables the texture to repeat when UV coordinates are outside the 0-1 range. If using one of the linear filtering modes, this can result in artifacts at the edges of a texture when the sampler filters across the edges of the texture.

DefaultCanvasItemTextureRepeat DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR = 2

Flip the texture when repeating so that the edge lines up instead of abruptly changing.

DefaultCanvasItemTextureRepeat DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_PARENT_NODE = 3

The Viewport will inherit the repeat mode from its parent CanvasItem or Viewport.

DefaultCanvasItemTextureRepeat DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MAX = 4

Represents the size of the DefaultCanvasItemTextureRepeat enum.

---

enum SDFOversize
SDFOversize SDF_OVERSIZE_100_PERCENT = 0

The signed distance field only covers the viewport's own rectangle.

SDFOversize SDF_OVERSIZE_120_PERCENT = 1

The signed distance field is expanded to cover 20% of the viewport's size around the borders.

SDFOversize SDF_OVERSIZE_150_PERCENT = 2

The signed distance field is expanded to cover 50% of the viewport's size around the borders.

SDFOversize SDF_OVERSIZE_200_PERCENT = 3

The signed distance field is expanded to cover 100% (double) of the viewport's size around the borders.

SDFOversize SDF_OVERSIZE_MAX = 4

Represents the size of the SDFOversize enum.

---

enum SDFScale
SDFScale SDF_SCALE_100_PERCENT = 0

The signed distance field is rendered at full resolution.

SDFScale SDF_SCALE_50_PERCENT = 1

The signed distance field is rendered at half the resolution of this viewport.

SDFScale SDF_SCALE_25_PERCENT = 2

The signed distance field is rendered at a quarter the resolution of this viewport.

SDFScale SDF_SCALE_MAX = 3

Represents the size of the SDFScale enum.

---

enum VRSMode
VRSMode VRS_DISABLED = 0

Variable Rate Shading is disabled.

VRSMode VRS_TEXTURE = 1

Variable Rate Shading uses a texture. Note, for stereoscopic use a texture atlas with a texture for each view.

VRSMode VRS_XR = 2

Variable Rate Shading's texture is supplied by the primary XRInterface.

VRSMode VRS_MAX = 3

Represents the size of the VRSMode enum.

---

enum VRSUpdateMode
VRSUpdateMode VRS_UPDATE_DISABLED = 0

The input texture for variable rate shading will not be processed.

VRSUpdateMode VRS_UPDATE_ONCE = 1

The input texture for variable rate shading will be processed once.

VRSUpdateMode VRS_UPDATE_ALWAYS = 2

The input texture for variable rate shading will be processed each frame.

VRSUpdateMode VRS_UPDATE_MAX = 3

Represents the size of the VRSUpdateMode enum.

---

## Property Descriptions

AnisotropicFiltering anisotropic_filtering_level = 2 

- void set_anisotropic_filtering_level(value: AnisotropicFiltering)
- AnisotropicFiltering get_anisotropic_filtering_level()

Sets the maximum number of samples to take when using anisotropic filtering on textures (as a power of two). A higher sample count will result in sharper textures at oblique angles, but is more expensive to compute. A value of 0 forcibly disables anisotropic filtering, even on materials where it is enabled.

The anisotropic filtering level also affects decals and light projectors if they are configured to use anisotropic filtering. See ProjectSettings.rendering/textures/decals/filter and ProjectSettings.rendering/textures/light_projectors/filter.

Note: In 3D, for this setting to have an effect, set BaseMaterial3D.texture_filter to BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC or BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC on materials.

Note: In 2D, for this setting to have an effect, set CanvasItem.texture_filter to CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC or CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC on the CanvasItem node displaying the texture (or in CanvasTexture). However, anisotropic filtering is rarely useful in 2D, so only enable it for textures in 2D if it makes a meaningful visual difference.

---

bool audio_listener_enable_2d = false 

- void set_as_audio_listener_2d(value: bool)
- bool is_audio_listener_2d()

If true, the viewport will process 2D audio streams.

---

bool audio_listener_enable_3d = false 

- void set_as_audio_listener_3d(value: bool)
- bool is_audio_listener_3d()

If true, the viewport will process 3D audio streams.

---

int canvas_cull_mask = 4294967295 

- void set_canvas_cull_mask(value: int)
- int get_canvas_cull_mask()

The rendering layers in which this Viewport renders CanvasItem nodes.

Note: A CanvasItem does not inherit its parents' visibility layers. See CanvasItem.visibility_layer's description for details.

---

DefaultCanvasItemTextureFilter canvas_item_default_texture_filter = 1 

- void set_default_canvas_item_texture_filter(value: DefaultCanvasItemTextureFilter)
- DefaultCanvasItemTextureFilter get_default_canvas_item_texture_filter()

The default filter mode used by CanvasItem nodes in this viewport.

---

DefaultCanvasItemTextureRepeat canvas_item_default_texture_repeat = 0 

- void set_default_canvas_item_texture_repeat(value: DefaultCanvasItemTextureRepeat)
- DefaultCanvasItemTextureRepeat get_default_canvas_item_texture_repeat()

The default repeat mode used by CanvasItem nodes in this viewport.

---

Transform2D canvas_transform 

- void set_canvas_transform(value: Transform2D)
- Transform2D get_canvas_transform()

The canvas transform of the viewport, useful for changing the on-screen positions of all child CanvasItems. This is relative to the global canvas transform of the viewport.

---

DebugDraw debug_draw = 0 

- void set_debug_draw(value: DebugDraw)
- DebugDraw get_debug_draw()

The overlay mode for test rendered geometry in debug purposes.

---

bool disable_3d = false 

- void set_disable_3d(value: bool)
- bool is_3d_disabled()

Disable 3D rendering (but keep 2D rendering).

---

float fsr_sharpness = 0.2 

- void set_fsr_sharpness(value: float)
- float get_fsr_sharpness()

Determines how sharp the upscaled image will be when using the FSR upscaling mode. Sharpness halves with every whole number. Values go from 0.0 (sharpest) to 2.0. Values above 2.0 won't make a visible difference.

To control this property on the root viewport, set the ProjectSettings.rendering/scaling_3d/fsr_sharpness project setting.

---

Transform2D global_canvas_transform 

- void set_global_canvas_transform(value: Transform2D)
- Transform2D get_global_canvas_transform()

The global canvas transform of the viewport. The canvas transform is relative to this.

---

bool gui_disable_input = false 

- void set_disable_input(value: bool)
- bool is_input_disabled()

If true, the viewport will not receive input events.

---

int gui_drag_threshold = 10 

- void set_drag_threshold(value: int)
- int get_drag_threshold()

The minimum distance the mouse cursor must move while pressed before a drag operation begins.

---

bool gui_embed_subwindows = false 

- void set_embedding_subwindows(value: bool)
- bool is_embedding_subwindows()

If true, sub-windows (popups and dialogs) will be embedded inside application window as control-like nodes. If false, they will appear as separate windows handled by the operating system.

---

bool gui_snap_controls_to_pixels = true 

- void set_snap_controls_to_pixels(value: bool)
- bool is_snap_controls_to_pixels_enabled()

If true, the GUI controls on the viewport will lay pixel perfectly.

---

bool handle_input_locally = true 

- void set_handle_input_locally(value: bool)
- bool is_handling_input_locally()

If true, this viewport will mark incoming input events as handled by itself. If false, this is instead done by the first parent viewport that is set to handle input locally.

A SubViewportContainer will automatically set this property to false for the Viewport contained inside of it.

See also set_input_as_handled() and is_input_handled().

---

float mesh_lod_threshold = 1.0 

- void set_mesh_lod_threshold(value: float)
- float get_mesh_lod_threshold()

The automatic LOD bias to use for meshes rendered within the Viewport (this is analogous to ReflectionProbe.mesh_lod_threshold). Higher values will use less detailed versions of meshes that have LOD variations generated. If set to 0.0, automatic LOD is disabled. Increase mesh_lod_threshold to improve performance at the cost of geometry detail.

To control this property on the root viewport, set the ProjectSettings.rendering/mesh_lod/lod_change/threshold_pixels project setting.

Note: Depending on the mesh's attributes (vertex colors, blend shapes, ...), a mesh may have fewer levels of LOD generated to avoid visible distortion of the mesh once it is affected by vertex colors or blend shapes. Meshes with a very low vertex count will also not have any LODs generated, which means this setting will not affect them at all. In general, this setting makes the largest impact on static meshes with a high vertex count.

Note: mesh_lod_threshold does not affect GeometryInstance3D visibility ranges (also known as "manual" LOD or hierarchical LOD).

---

MSAA msaa_2d = 0 

- void set_msaa_2d(value: MSAA)
- MSAA get_msaa_2d()

The multisample antialiasing mode for 2D/Canvas rendering. A higher number results in smoother edges at the cost of significantly worse performance. A value of MSAA_2X or MSAA_4X is best unless targeting very high-end systems. This has no effect on shader-induced aliasing or texture aliasing.

See also ProjectSettings.rendering/anti_aliasing/quality/msaa_2d and RenderingServer.viewport_set_msaa_2d().

---

MSAA msaa_3d = 0 

- void set_msaa_3d(value: MSAA)
- MSAA get_msaa_3d()

The multisample antialiasing mode for 3D rendering. A higher number results in smoother edges at the cost of significantly worse performance. A value of MSAA_2X or MSAA_4X is best unless targeting very high-end systems. See also bilinear scaling 3D scaling_3d_mode for supersampling, which provides higher quality but is much more expensive. This has no effect on shader-induced aliasing or texture aliasing.

See also ProjectSettings.rendering/anti_aliasing/quality/msaa_3d and RenderingServer.viewport_set_msaa_3d().

---

bool oversampling = true 

- void set_use_oversampling(value: bool)
- bool is_using_oversampling()

If true and one of the following conditions are true: SubViewport.size_2d_override_stretch and SubViewport.size_2d_override are set, Window.content_scale_factor is set and scaling is enabled, oversampling_override is set, font and DPITexture oversampling are enabled.

---

float oversampling_override = 0.0 

- void set_oversampling_override(value: float)
- float get_oversampling_override()

If greater than zero, this value is used as the font oversampling factor, otherwise oversampling is equal to viewport scale.

---

bool own_world_3d = false 

- void set_use_own_world_3d(value: bool)
- bool is_using_own_world_3d()

If true, the viewport will use a unique copy of the World3D defined in world_3d.

---

bool physics_object_picking = false 

- void set_physics_object_picking(value: bool)
- bool get_physics_object_picking()

If true, the objects rendered by viewport become subjects of mouse picking process.

Note: The number of simultaneously pickable objects is limited to 64 and they are selected in a non-deterministic order, which can be different in each picking process.

---

bool physics_object_picking_first_only = false 

- void set_physics_object_picking_first_only(value: bool)
- bool get_physics_object_picking_first_only()

If true, the input_event signal will only be sent to one physics object in the mouse picking process. If you want to get the top object only, you must also enable physics_object_picking_sort.

If false, an input_event signal will be sent to all physics objects in the mouse picking process.

This applies to 2D CanvasItem object picking only.

---

bool physics_object_picking_sort = false 

- void set_physics_object_picking_sort(value: bool)
- bool get_physics_object_picking_sort()

If true, objects receive mouse picking events sorted primarily by their CanvasItem.z_index and secondarily by their position in the scene tree. If false, the order is undetermined.

Note: This setting is disabled by default because of its potential expensive computational cost.

Note: Sorting happens after selecting the pickable objects. Because of the limitation of 64 simultaneously pickable objects, it is not guaranteed that the object with the highest CanvasItem.z_index receives the picking event.

---

bool positional_shadow_atlas_16_bits = true 

- void set_positional_shadow_atlas_16_bits(value: bool)
- bool get_positional_shadow_atlas_16_bits()

Use 16 bits for the omni/spot shadow depth map. Enabling this results in shadows having less precision and may result in shadow acne, but can lead to performance improvements on some devices.

---

PositionalShadowAtlasQuadrantSubdiv positional_shadow_atlas_quad_0 = 2 

- void set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv)
- PositionalShadowAtlasQuadrantSubdiv get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const

The subdivision amount of the first quadrant on the shadow atlas.

---

PositionalShadowAtlasQuadrantSubdiv positional_shadow_atlas_quad_1 = 2 

- void set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv)
- PositionalShadowAtlasQuadrantSubdiv get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const

The subdivision amount of the second quadrant on the shadow atlas.

---

PositionalShadowAtlasQuadrantSubdiv positional_shadow_atlas_quad_2 = 3 

- void set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv)
- PositionalShadowAtlasQuadrantSubdiv get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const

The subdivision amount of the third quadrant on the shadow atlas.

---

PositionalShadowAtlasQuadrantSubdiv positional_shadow_atlas_quad_3 = 4 

- void set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv)
- PositionalShadowAtlasQuadrantSubdiv get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const

The subdivision amount of the fourth quadrant on the shadow atlas.

---

int positional_shadow_atlas_size = 2048 

- void set_positional_shadow_atlas_size(value: int)
- int get_positional_shadow_atlas_size()

The shadow atlas' resolution (used for omni and spot lights). The value is rounded up to the nearest power of 2.

Note: If this is set to 0, no positional shadows will be visible at all. This can improve performance significantly on low-end systems by reducing both the CPU and GPU load (as fewer draw calls are needed to draw the scene without shadows).

---

Scaling3DMode scaling_3d_mode = 0 

- void set_scaling_3d_mode(value: Scaling3DMode)
- Scaling3DMode get_scaling_3d_mode()

Sets scaling 3D mode. Bilinear scaling renders at different resolution to either undersample or supersample the viewport. FidelityFX Super Resolution 1.0, abbreviated to FSR, is an upscaling technology that produces high quality images at fast framerates by using a spatially aware upscaling algorithm. FSR is slightly more expensive than bilinear, but it produces significantly higher image quality. FSR should be used where possible.

To control this property on the root viewport, set the ProjectSettings.rendering/scaling_3d/mode project setting.

---

float scaling_3d_scale = 1.0 

- void set_scaling_3d_scale(value: float)
- float get_scaling_3d_scale()

Scales the 3D render buffer based on the viewport size uses an image filter specified in ProjectSettings.rendering/scaling_3d/mode to scale the output image to the full viewport size. Values lower than 1.0 can be used to speed up 3D rendering at the cost of quality (undersampling). Values greater than 1.0 are only valid for bilinear mode and can be used to improve 3D rendering quality at a high performance cost (supersampling). See also ProjectSettings.rendering/anti_aliasing/quality/msaa_3d for multi-sample antialiasing, which is significantly cheaper but only smooths the edges of polygons.

When using FSR upscaling, AMD recommends exposing the following values as preset options to users "Ultra Quality: 0.77", "Quality: 0.67", "Balanced: 0.59", "Performance: 0.5" instead of exposing the entire scale.

To control this property on the root viewport, set the ProjectSettings.rendering/scaling_3d/scale project setting.

---

ScreenSpaceAA screen_space_aa = 0 

- void set_screen_space_aa(value: ScreenSpaceAA)
- ScreenSpaceAA get_screen_space_aa()

Sets the screen-space antialiasing method used. Screen-space antialiasing works by selectively blurring edges in a post-process shader. It differs from MSAA which takes multiple coverage samples while rendering objects. Screen-space AA methods are typically faster than MSAA and will smooth out specular aliasing, but tend to make scenes appear blurry.

See also ProjectSettings.rendering/anti_aliasing/quality/screen_space_aa and RenderingServer.viewport_set_screen_space_aa().

---

SDFOversize sdf_oversize = 1 

- void set_sdf_oversize(value: SDFOversize)
- SDFOversize get_sdf_oversize()

Controls how much of the original viewport's size should be covered by the 2D signed distance field. This SDF can be sampled in CanvasItem shaders and is also used for GPUParticles2D collision. Higher values allow portions of occluders located outside the viewport to still be taken into account in the generated signed distance field, at the cost of performance. If you notice particles falling through LightOccluder2Ds as the occluders leave the viewport, increase this setting.

The percentage is added on each axis and on both sides. For example, with the default SDF_OVERSIZE_120_PERCENT, the signed distance field will cover 20% of the viewport's size outside the viewport on each side (top, right, bottom, left).

---

SDFScale sdf_scale = 1 

- void set_sdf_scale(value: SDFScale)
- SDFScale get_sdf_scale()

The resolution scale to use for the 2D signed distance field. Higher values lead to a more precise and more stable signed distance field as the camera moves, at the cost of performance.

---

bool snap_2d_transforms_to_pixel = false 

- void set_snap_2d_transforms_to_pixel(value: bool)
- bool is_snap_2d_transforms_to_pixel_enabled()

If true, CanvasItem nodes will internally snap to full pixels. Their position can still be sub-pixel, but the decimals will not have effect. This can lead to a crisper appearance at the cost of less smooth movement, especially when Camera2D smoothing is enabled.

---

bool snap_2d_vertices_to_pixel = false 

- void set_snap_2d_vertices_to_pixel(value: bool)
- bool is_snap_2d_vertices_to_pixel_enabled()

If true, vertices of CanvasItem nodes will snap to full pixels. Only affects the final vertex positions, not the transforms. This can lead to a crisper appearance at the cost of less smooth movement, especially when Camera2D smoothing is enabled.

---

float texture_mipmap_bias = 0.0 

- void set_texture_mipmap_bias(value: float)
- float get_texture_mipmap_bias()

Affects the final texture sharpness by reading from a lower or higher mipmap (also called "texture LOD bias"). Negative values make mipmapped textures sharper but grainier when viewed at a distance, while positive values make mipmapped textures blurrier (even when up close).

Enabling temporal antialiasing (use_taa) will automatically apply a -0.5 offset to this value, while enabling FXAA (screen_space_aa) will automatically apply a -0.25 offset to this value. If both TAA and FXAA are enabled at the same time, an offset of -0.75 is applied to this value.

To control this property on the root viewport, set the ProjectSettings.rendering/textures/default_filters/texture_mipmap_bias project setting.

Note: If scaling_3d_scale is lower than 1.0 (exclusive), texture_mipmap_bias is used to adjust the automatic mipmap bias which is calculated internally based on the scale factor. The formula for this is log2(scaling_3d_scale) + mipmap_bias.

Note: This property is only supported in the Forward+ and Mobile renderers, not Compatibility. In Compatibility, this property is always treated as if it was set to 0.0.

---

bool transparent_bg = false 

- void set_transparent_background(value: bool)
- bool has_transparent_background()

If true, the viewport should render its background as transparent.

Note: Due to technical limitations, certain rendering features are disabled when a viewport has a transparent background. This currently applies to screen-space reflections, subsurface scattering, and depth of field.

---

bool use_debanding = false 

- void set_use_debanding(value: bool)
- bool is_using_debanding()

When using the Mobile or Forward+ renderers, set use_debanding to enable or disable the debanding feature of this Viewport. If use_hdr_2d is false, 2D rendering is not affected by debanding unless the Environment.background_mode is Environment.BG_CANVAS. If use_hdr_2d is true, debanding will only be applied if this is the root Viewport and will affect all 2D and 3D rendering, including canvas items.

use_debanding has no effect when using the Compatibility rendering method. The Mobile renderer can also use material debanding, which can be set with RenderingServer.material_set_use_debanding() or configured with ProjectSettings.rendering/anti_aliasing/quality/use_debanding.

See also ProjectSettings.rendering/anti_aliasing/quality/use_debanding, RenderingServer.material_set_use_debanding(), and RenderingServer.viewport_set_use_debanding().

---

bool use_hdr_2d = false 

- void set_use_hdr_2d(value: bool)
- bool is_using_hdr_2d()

If true, 2D rendering will use a high dynamic range (HDR) RGBA16 format framebuffer. Additionally, 2D rendering will be performed on linear values and will be converted using the appropriate transfer function immediately before blitting to the screen (if the Viewport is attached to the screen).

Practically speaking, this means that the end result of the Viewport will not be clamped to the 0-1 range and can be used in 3D rendering without color encoding adjustments. This allows 2D rendering to take advantage of effects requiring high dynamic range (e.g. 2D glow) as well as substantially improves the appearance of effects requiring highly detailed gradients.

---

bool use_occlusion_culling = false 

- void set_use_occlusion_culling(value: bool)
- bool is_using_occlusion_culling()

If true, OccluderInstance3D nodes will be usable for occlusion culling in 3D for this viewport. For the root viewport, ProjectSettings.rendering/occlusion_culling/use_occlusion_culling must be set to true instead.

Note: Enabling occlusion culling has a cost on the CPU. Only enable occlusion culling if you actually plan to use it, and think whether your scene can actually benefit from occlusion culling. Large, open scenes with few or no objects blocking the view will generally not benefit much from occlusion culling. Large open scenes generally benefit more from mesh LOD and visibility ranges (GeometryInstance3D.visibility_range_begin and GeometryInstance3D.visibility_range_end) compared to occlusion culling.

Note: Due to memory constraints, occlusion culling is not supported by default in Web export templates. It can be enabled by compiling custom Web export templates with module_raycast_enabled=yes.

---

bool use_taa = false 

- void set_use_taa(value: bool)
- bool is_using_taa()

Enables temporal antialiasing for this viewport. TAA works by jittering the camera and accumulating the images of the last rendered frames, motion vector rendering is used to account for camera and object motion.

Note: The implementation is not complete yet, some visual instances such as particles and skinned meshes may show artifacts.

See also ProjectSettings.rendering/anti_aliasing/quality/use_taa and RenderingServer.viewport_set_use_taa().

---

bool use_xr = false 

- void set_use_xr(value: bool)
- bool is_using_xr()

If true, the viewport will use the primary XR interface to render XR output. When applicable this can result in a stereoscopic image and the resulting render being output to a headset.

---

VRSMode vrs_mode = 0 

- void set_vrs_mode(value: VRSMode)
- VRSMode get_vrs_mode()

The Variable Rate Shading (VRS) mode that is used for this viewport. Note, if hardware does not support VRS this property is ignored.

---

Texture2D vrs_texture 

- void set_vrs_texture(value: Texture2D)
- Texture2D get_vrs_texture()

Texture to use when vrs_mode is set to VRS_TEXTURE.

The texture must use a lossless compression format so that colors can be matched precisely. The following VRS densities are mapped to various colors, with brighter colors representing a lower level of shading precision:

```
- 1×1 = rgb(0, 0, 0)     - #000000
- 1×2 = rgb(0, 85, 0)    - #005500
- 2×1 = rgb(85, 0, 0)    - #550000
- 2×2 = rgb(85, 85, 0)   - #555500
- 2×4 = rgb(85, 170, 0)  - #55aa00
- 4×2 = rgb(170, 85, 0)  - #aa5500
- 4×4 = rgb(170, 170, 0) - #aaaa00
- 4×8 = rgb(170, 255, 0) - #aaff00 - Not supported on most hardware
- 8×4 = rgb(255, 170, 0) - #ffaa00 - Not supported on most hardware
- 8×8 = rgb(255, 255, 0) - #ffff00 - Not supported on most hardware
```

---

VRSUpdateMode vrs_update_mode = 1 

- void set_vrs_update_mode(value: VRSUpdateMode)
- VRSUpdateMode get_vrs_update_mode()

Sets the update mode for Variable Rate Shading (VRS) for the viewport. VRS requires the input texture to be converted to the format usable by the VRS method supported by the hardware. The update mode defines how often this happens. If the GPU does not support VRS, or VRS is not enabled, this property is ignored.

---

World2D world_2d 

- void set_world_2d(value: World2D)
- World2D get_world_2d()

The custom World2D which can be used as 2D environment source.

---

World3D world_3d 

- void set_world_3d(value: World3D)
- World3D get_world_3d()

The custom World3D which can be used as 3D environment source.

---

## Method Descriptions

World2D find_world_2d() const 

Returns the first valid World2D for this viewport, searching the world_2d property of itself and any Viewport ancestor.

---

World3D find_world_3d() const 

Returns the first valid World3D for this viewport, searching the world_3d property of itself and any Viewport ancestor.

---

AudioListener2D get_audio_listener_2d() const 

Returns the currently active 2D audio listener. Returns null if there are no active 2D audio listeners, in which case the active 2D camera will be treated as listener.

---

AudioListener3D get_audio_listener_3d() const 

Returns the currently active 3D audio listener. Returns null if there are no active 3D audio listeners, in which case the active 3D camera will be treated as listener.

---

Camera2D get_camera_2d() const 

Returns the currently active 2D camera. Returns null if there are no active cameras.

Note: If called while the Camera Override system is active in editor, this will return the internally managed override camera. It is therefore advised to avoid caching the return value, or to check that the cached value is still a valid instance and is the current camera before use. See @GlobalScope.is_instance_valid() and Camera2D.is_current().

---

Camera3D get_camera_3d() const 

Returns the currently active 3D camera. Returns null if there are no active cameras.

Note: If called while the Camera Override system is active in editor, this will return the internally managed override camera. It is therefore advised to avoid caching the return value, or to check that the cached value is a valid instance and is the current camera before use. See @GlobalScope.is_instance_valid() and Camera3D.current.

---

bool get_canvas_cull_mask_bit(layer: int) const 

Returns an individual bit on the rendering layer mask.

---

Array[Window] get_embedded_subwindows() const 

Returns a list of the visible embedded Windows inside the viewport.

Note: Windows inside other viewports will not be listed.

---

Transform2D get_final_transform() const 

Returns the transform from the viewport's coordinate system to the embedder's coordinate system.

---

Vector2 get_mouse_position() const 

Returns the mouse's position in this Viewport using the coordinate system of this Viewport.

---

float get_oversampling() const 

Returns viewport oversampling factor.

---

PositionalShadowAtlasQuadrantSubdiv get_positional_shadow_atlas_quadrant_subdiv(quadrant: int) const 

Returns the positional shadow atlas quadrant subdivision of the specified quadrant.

---

int get_render_info(type: RenderInfoType, info: RenderInfo) 

Returns rendering statistics of the given type.

---

Transform2D get_screen_transform() const 

Returns the transform from the Viewport's coordinates to the screen coordinates of the containing window manager window.

---

Transform2D get_stretch_transform() const 

Returns the automatically computed 2D stretch transform, taking the Viewport's stretch settings into account. The final value is multiplied by Window.content_scale_factor, but only for the root viewport. If this method is called on a SubViewport (e.g., in a scene tree with SubViewportContainer and SubViewport), the scale factor of the root window will not be applied. Using Transform2D.get_scale() on the returned value, this can be used to compensate for scaling when zooming a Camera2D node, or to scale down a TextureRect to be pixel-perfect regardless of the automatically computed scale factor.

Note: Due to how pixel scaling works, the returned transform's X and Y scale may differ slightly, even when Window.content_scale_aspect is set to a mode that preserves the pixels' aspect ratio. If Window.content_scale_aspect is Window.CONTENT_SCALE_ASPECT_IGNORE, the X and Y scale may differ significantly.

---

ViewportTexture get_texture() const 

Returns the viewport's texture.

Note: When trying to store the current texture (e.g. in a file), it might be completely black or outdated if used too early, especially when used in e.g. Node._ready(). To make sure the texture you get is correct, you can await RenderingServer.frame_post_draw signal.

```
func _ready():
    await RenderingServer.frame_post_draw
    $Viewport.get_texture().get_image().save_png("user://Screenshot.png")
```

```
public async override void _Ready()
{
    await ToSignal(RenderingServer.Singleton, RenderingServer.SignalName.FramePostDraw);
    var viewport = GetNode("Viewport");
    viewport.GetTexture().GetImage().SavePng("user://Screenshot.png");
}
```

Note: When use_hdr_2d is true the returned texture will be an HDR image using linear encoding.

---

RID get_viewport_rid() const 

Returns the viewport's RID from the RenderingServer.

---

Rect2 get_visible_rect() const 

Returns the visible rectangle in global screen coordinates.

---

void gui_cancel_drag() 

Cancels the drag operation that was previously started through Control._get_drag_data() or forced with Control.force_drag().

---

Variant gui_get_drag_data() const 

Returns the drag data from the GUI, that was previously returned by Control._get_drag_data().

---

String gui_get_drag_description() const 

Returns the human-readable description of the drag data, used for assistive apps.

---

Control gui_get_focus_owner() const 

Returns the currently focused Control within this viewport. If no Control is focused, returns null.

---

Control gui_get_hovered_control() const 

Returns the Control that the mouse is currently hovering over in this viewport. If no Control has the cursor, returns null.

Typically the leaf Control node or deepest level of the subtree which claims hover. This is very useful when used together with Node.is_ancestor_of() to find if the mouse is within a control tree.

---

bool gui_is_drag_successful() const 

Returns true if the drag operation is successful.

---

bool gui_is_dragging() const 

Returns true if a drag operation is currently ongoing and where the drop action could happen in this viewport.

Alternative to Node.NOTIFICATION_DRAG_BEGIN and Node.NOTIFICATION_DRAG_END when you prefer polling the value.

---

void gui_release_focus() 

Removes the focus from the currently focused Control within this viewport. If no Control has the focus, does nothing.

---

void gui_set_drag_description(description: String) 

Sets the human-readable description of the drag data to description, used for assistive apps.

---

bool is_input_handled() const 

Returns whether the current InputEvent has been handled. Input events are not handled until set_input_as_handled() has been called during the lifetime of an InputEvent.

This is usually done as part of input handling methods like Node._input(), Control._gui_input() or others, as well as in corresponding signal handlers.

If handle_input_locally is set to false, this method will try finding the first parent viewport that is set to handle input locally, and return its value for is_input_handled() instead.

---

void notify_mouse_entered() 

Inform the Viewport that the mouse has entered its area. Use this function before sending an InputEventMouseButton or InputEventMouseMotion to the Viewport with push_input(). See also notify_mouse_exited().

Note: In most cases, it is not necessary to call this function because SubViewport nodes that are children of SubViewportContainer are notified automatically. This is only necessary when interacting with viewports in non-default ways, for example as textures in TextureRect or with an Area3D that forwards input events.

---

void notify_mouse_exited() 

Inform the Viewport that the mouse has left its area. Use this function when the node that displays the viewport notices the mouse has left the area of the displayed viewport. See also notify_mouse_entered().

Note: In most cases, it is not necessary to call this function because SubViewport nodes that are children of SubViewportContainer are notified automatically. This is only necessary when interacting with viewports in non-default ways, for example as textures in TextureRect or with an Area3D that forwards input events.

---

void push_input(event: InputEvent, in_local_coords: bool = false) 

Triggers the given event in this Viewport. This can be used to pass an InputEvent between viewports, or to locally apply inputs that were sent over the network or saved to a file.

If in_local_coords is false, the event's position is in the embedder's coordinates and will be converted to viewport coordinates. If in_local_coords is true, the event's position is in viewport coordinates.

While this method serves a similar purpose as Input.parse_input_event(), it does not remap the specified event based on project settings like ProjectSettings.input_devices/pointing/emulate_touch_from_mouse.

Calling this method will propagate calls to child nodes for following methods in the given order:

- Node._input()
- Control._gui_input() for Control nodes
- Node._shortcut_input()
- Node._unhandled_key_input()
- Node._unhandled_input()

If an earlier method marks the input as handled via set_input_as_handled(), any later method in this list will not be called.

If none of the methods handle the event and physics_object_picking is true, the event is used for physics object picking.

---

void push_text_input(text: String) 

Helper method which calls the set_text() method on the currently focused Control, provided that it is defined (e.g. if the focused Control is Button or LineEdit).

---

void push_unhandled_input(event: InputEvent, in_local_coords: bool = false) 

Deprecated: Use push_input() instead.

Triggers the given event in this Viewport. This can be used to pass an InputEvent between viewports, or to locally apply inputs that were sent over the network or saved to a file.

If in_local_coords is false, the event's position is in the embedder's coordinates and will be converted to viewport coordinates. If in_local_coords is true, the event's position is in viewport coordinates.

Calling this method will propagate calls to child nodes for following methods in the given order:

- Node._shortcut_input()
- Node._unhandled_key_input()
- Node._unhandled_input()

If an earlier method marks the input as handled via set_input_as_handled(), any later method in this list will not be called.

If none of the methods handle the event and physics_object_picking is true, the event is used for physics object picking.

Note: This method doesn't propagate input events to embedded Windows or SubViewports.

---

void set_canvas_cull_mask_bit(layer: int, enable: bool) 

Set/clear individual bits on the rendering layer mask. This simplifies editing this Viewport's layers.

---

void set_input_as_handled() 

Stops the input from propagating further up the SceneTree.

Note: This does not affect the methods in Input, only the way events are propagated.

---

void set_positional_shadow_atlas_quadrant_subdiv(quadrant: int, subdiv: PositionalShadowAtlasQuadrantSubdiv) 

Sets the number of subdivisions to use in the specified quadrant. A higher number of subdivisions allows you to have more shadows in the scene at once, but reduces the quality of the shadows. A good practice is to have quadrants with a varying number of subdivisions and to have as few subdivisions as possible.

---

void update_mouse_cursor_state() 

Force instantly updating the display based on the current mouse cursor position. This includes updating the mouse cursor shape and sending necessary Control.mouse_entered, CollisionObject2D.mouse_entered, CollisionObject3D.mouse_entered and Window.mouse_entered signals and their respective mouse_exited counterparts.

---

void warp_mouse(position: Vector2) 

Moves the mouse pointer to the specified position in this Viewport using the coordinate system of this Viewport.

Note: warp_mouse() is only supported on Windows, macOS and Linux. It has no effect on Android, iOS and Web.
