# SubViewport

Inherits: Viewport < Node < Object

An interface to a game world that doesn't create a window or draw to the screen directly.

## Description

SubViewport Isolates a rectangular region of a scene to be displayed independently. This can be used, for example, to display UI in 3D space.

Note: SubViewport is a Viewport that isn't a Window, i.e. it doesn't draw anything by itself. To display anything, SubViewport must have a non-zero size and be either put inside a SubViewportContainer or assigned to a ViewportTexture.

Note: InputEvents are not passed to a standalone SubViewport by default. To ensure InputEvent propagation, a SubViewport can be placed inside of a SubViewportContainer.

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

ClearMode | render_target_clear_mode | 0
UpdateMode | render_target_update_mode | 2
Vector2i | size | Vector2i(512, 512)
Vector2i | size_2d_override | Vector2i(0, 0)
bool | size_2d_override_stretch | false
int | view_count | 1

---

## Enumerations

enum ClearMode
ClearMode CLEAR_MODE_ALWAYS = 0

Always clear the render target before drawing.

ClearMode CLEAR_MODE_NEVER = 1

Never clear the render target.

ClearMode CLEAR_MODE_ONCE = 2

Clear the render target on the next frame, then switch to CLEAR_MODE_NEVER.

---

enum UpdateMode
UpdateMode UPDATE_DISABLED = 0

Do not update the render target.

UpdateMode UPDATE_ONCE = 1

Update the render target once, then switch to UPDATE_DISABLED.

UpdateMode UPDATE_WHEN_VISIBLE = 2

Update the render target only when it is visible. This is the default value.

UpdateMode UPDATE_WHEN_PARENT_VISIBLE = 3

Update the render target only when its parent is visible.

UpdateMode UPDATE_ALWAYS = 4

Always update the render target.

---

## Property Descriptions

ClearMode render_target_clear_mode = 0 

- void set_clear_mode(value: ClearMode)
- ClearMode get_clear_mode()

The clear mode when the sub-viewport is used as a render target.

Note: This property is intended for 2D usage.

---

UpdateMode render_target_update_mode = 2 

- void set_update_mode(value: UpdateMode)
- UpdateMode get_update_mode()

The update mode when the sub-viewport is used as a render target.

---

Vector2i size = Vector2i(512, 512) 

- void set_size(value: Vector2i)
- Vector2i get_size()

The width and height of the sub-viewport. Must be set to a value greater than or equal to 2 pixels on both dimensions. Otherwise, nothing will be displayed.

Note: If the parent node is a SubViewportContainer and its SubViewportContainer.stretch is true, the viewport size cannot be changed manually.

---

Vector2i size_2d_override = Vector2i(0, 0) 

- void set_size_2d_override(value: Vector2i)
- Vector2i get_size_2d_override()

The 2D size override of the sub-viewport. If either the width or height is 0, the override is disabled.

---

bool size_2d_override_stretch = false 

- void set_size_2d_override_stretch(value: bool)
- bool is_size_2d_override_stretch_enabled()

If true, the 2D size override affects stretch as well.

---

int view_count = 1 

- void set_view_count(value: int)
- int get_view_count()

The number of view layers we are rendering to. Set this to 2 to enable stereo rendering.
