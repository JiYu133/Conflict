# OpenXRCompositionLayer

Experimental: This class may be changed or removed in future versions.

Inherits: Node3D < Node < Object

Inherited By: OpenXRCompositionLayerCylinder, OpenXRCompositionLayerEquirect, OpenXRCompositionLayerQuad

The parent class of all OpenXR composition layer nodes.

## Description

Composition layers allow 2D viewports to be displayed inside of the headset by the XR compositor through special projections that retain their quality. This allows for rendering clear text while keeping the layer at a native resolution.

Note: If the OpenXR runtime doesn't support the given composition layer type, a fallback mesh can be generated with a ViewportTexture, in order to emulate the composition layer.

## Properties

bool | alpha_blend | false
Vector2i | android_surface_size | Vector2i(1024, 1024)
bool | enable_hole_punch | false
EyeVisibility | eye_visibility | 0
SubViewport | layer_viewport |
bool | protected_content | false
int | sort_order | 1
Swizzle | swapchain_state_alpha_swizzle | 3
Swizzle | swapchain_state_blue_swizzle | 2
Color | swapchain_state_border_color | Color(0, 0, 0, 0)
Swizzle | swapchain_state_green_swizzle | 1
Wrap | swapchain_state_horizontal_wrap | 0
Filter | swapchain_state_mag_filter | 1
float | swapchain_state_max_anisotropy | 1.0
Filter | swapchain_state_min_filter | 1
MipmapMode | swapchain_state_mipmap_mode | 2
Swizzle | swapchain_state_red_swizzle | 0
Wrap | swapchain_state_vertical_wrap | 0
bool | use_android_surface | false

## Methods

JavaObject | get_android_surface()
Vector2 | intersects_ray(origin: Vector3, direction: Vector3) const
bool | is_natively_supported() const

---

## Enumerations

enum Filter
Filter FILTER_NEAREST = 0

Perform nearest-neighbor filtering when sampling the texture.

Filter FILTER_LINEAR = 1

Perform linear filtering when sampling the texture.

Filter FILTER_CUBIC = 2

Perform cubic filtering when sampling the texture.

---

enum MipmapMode
MipmapMode MIPMAP_MODE_DISABLED = 0

Disable mipmapping.

Note: Mipmapping can only be disabled in the Compatibility renderer.

MipmapMode MIPMAP_MODE_NEAREST = 1

Use the mipmap of the nearest resolution.

MipmapMode MIPMAP_MODE_LINEAR = 2

Use linear interpolation of the two mipmaps of the nearest resolution.

---

enum Wrap
Wrap WRAP_CLAMP_TO_BORDER = 0

Clamp the texture to its specified border color.

Wrap WRAP_CLAMP_TO_EDGE = 1

Clamp the texture to its edge color.

Wrap WRAP_REPEAT = 2

Repeat the texture infinitely.

Wrap WRAP_MIRRORED_REPEAT = 3

Repeat the texture infinitely, mirroring it on each repeat.

Wrap WRAP_MIRROR_CLAMP_TO_EDGE = 4

Mirror the texture once and then clamp the texture to its edge color.

Note: This wrap mode is not available in the Compatibility renderer.

---

enum Swizzle
Swizzle SWIZZLE_RED = 0

Maps a color channel to the value of the red channel.

Swizzle SWIZZLE_GREEN = 1

Maps a color channel to the value of the green channel.

Swizzle SWIZZLE_BLUE = 2

Maps a color channel to the value of the blue channel.

Swizzle SWIZZLE_ALPHA = 3

Maps a color channel to the value of the alpha channel.

Swizzle SWIZZLE_ZERO = 4

Maps a color channel to the value of zero.

Swizzle SWIZZLE_ONE = 5

Maps a color channel to the value of one.

---

enum EyeVisibility
EyeVisibility EYE_VISIBILITY_BOTH = 0

The layer is visible to both the left and right eyes.

EyeVisibility EYE_VISIBILITY_LEFT = 1

The layer is visible only to the left eye.

EyeVisibility EYE_VISIBILITY_RIGHT = 2

The layer is visible only to the right eye.

---

## Property Descriptions

bool alpha_blend = false 

- void set_alpha_blend(value: bool)
- bool get_alpha_blend()

Enables the blending the layer using its alpha channel.

Can be combined with Viewport.transparent_bg to give the layer a transparent background.

---

Vector2i android_surface_size = Vector2i(1024, 1024) 

- void set_android_surface_size(value: Vector2i)
- Vector2i get_android_surface_size()

The size of the Android surface to create if use_android_surface is enabled.

---

bool enable_hole_punch = false 

- void set_enable_hole_punch(value: bool)
- bool get_enable_hole_punch()

Enables a technique called "hole punching", which allows putting the composition layer behind the main projection layer (i.e. setting sort_order to a negative value) while "punching a hole" through everything rendered by Godot so that the layer is still visible.

This can be used to create the illusion that the composition layer exists in the same 3D space as everything rendered by Godot, allowing objects to appear to pass both behind or in front of the composition layer.

---

EyeVisibility eye_visibility = 0 

- void set_eye_visibility(value: EyeVisibility)
- EyeVisibility get_eye_visibility()

The eye(s) the composition layer is visible to.

Note: Not all composition layer types or runtimes support restricting visibility to a single eye.

---

SubViewport layer_viewport 

- void set_layer_viewport(value: SubViewport)
- SubViewport get_layer_viewport()

The SubViewport to render on the composition layer.

---

bool protected_content = false 

- void set_protected_content(value: bool)
- bool is_protected_content()

If enabled, the OpenXR swapchain will be created with the XR_SWAPCHAIN_CREATE_PROTECTED_CONTENT_BIT flag, which will protect its contents from CPU access.

When used with an Android Surface, this may allow DRM content to be presented, and will only take effect when the Surface is first created; later changes to this property will have no effect.

---

int sort_order = 1 

- void set_sort_order(value: int)
- int get_sort_order()

The sort order for this composition layer. Higher numbers will be shown in front of lower numbers.

Note: This will have no effect if a fallback mesh is being used.

---

Swizzle swapchain_state_alpha_swizzle = 3 

- void set_alpha_swizzle(value: Swizzle)
- Swizzle get_alpha_swizzle()

The swizzle value for the alpha channel of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Swizzle swapchain_state_blue_swizzle = 2 

- void set_blue_swizzle(value: Swizzle)
- Swizzle get_blue_swizzle()

The swizzle value for the blue channel of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Color swapchain_state_border_color = Color(0, 0, 0, 0) 

- void set_border_color(value: Color)
- Color get_border_color()

The border color of the swapchain state that is used when the wrap mode clamps to the border.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Swizzle swapchain_state_green_swizzle = 1 

- void set_green_swizzle(value: Swizzle)
- Swizzle get_green_swizzle()

The swizzle value for the green channel of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Wrap swapchain_state_horizontal_wrap = 0 

- void set_horizontal_wrap(value: Wrap)
- Wrap get_horizontal_wrap()

The horizontal wrap mode of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Filter swapchain_state_mag_filter = 1 

- void set_mag_filter(value: Filter)
- Filter get_mag_filter()

The magnification filter of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

float swapchain_state_max_anisotropy = 1.0 

- void set_max_anisotropy(value: float)
- float get_max_anisotropy()

The max anisotropy of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Filter swapchain_state_min_filter = 1 

- void set_min_filter(value: Filter)
- Filter get_min_filter()

The minification filter of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

MipmapMode swapchain_state_mipmap_mode = 2 

- void set_mipmap_mode(value: MipmapMode)
- MipmapMode get_mipmap_mode()

The mipmap mode of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Swizzle swapchain_state_red_swizzle = 0 

- void set_red_swizzle(value: Swizzle)
- Swizzle get_red_swizzle()

The swizzle value for the red channel of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

Wrap swapchain_state_vertical_wrap = 0 

- void set_vertical_wrap(value: Wrap)
- Wrap get_vertical_wrap()

The vertical wrap mode of the swapchain state.

Note: This property only has an effect on devices that support the OpenXR XR_FB_swapchain_update_state OpenGLES/Vulkan extensions.

---

bool use_android_surface = false 

- void set_use_android_surface(value: bool)
- bool get_use_android_surface()

If enabled, an Android surface will be created (with the dimensions from android_surface_size) which will provide the 2D content for the composition layer, rather than using layer_viewport.

See get_android_surface() for information about how to get the surface so that your application can draw to it.

Note: This will only work in Android builds.

---

## Method Descriptions

JavaObject get_android_surface() 

Returns a JavaObject representing an android.view.Surface if use_android_surface is enabled and OpenXR has created the surface. Otherwise, this will return null.

Note: The surface can only be created during an active OpenXR session. So, if use_android_surface is enabled outside of an OpenXR session, it won't be created until a new session fully starts.

---

Vector2 intersects_ray(origin: Vector3, direction: Vector3) const 

Returns UV coordinates where the given ray intersects with the composition layer. origin and direction must be in global space.

Returns Vector2(-1.0, -1.0) if the ray doesn't intersect.

---

bool is_natively_supported() const 

Returns true if the OpenXR runtime natively supports this composition layer type.

Note: This will only return an accurate result after the OpenXR session has started.
