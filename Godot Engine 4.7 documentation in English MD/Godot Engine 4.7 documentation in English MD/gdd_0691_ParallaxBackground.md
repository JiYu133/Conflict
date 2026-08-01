# ParallaxBackground

Deprecated: Use the Parallax2D node instead.

Inherits: CanvasLayer < Node < Object

A node used to create a parallax scrolling background.

## Description

A ParallaxBackground uses one or more ParallaxLayer child nodes to create a parallax effect. Each ParallaxLayer can move at a different speed using ParallaxLayer.motion_offset. This creates an illusion of depth in a 2D game. If not used with a Camera2D, you must manually calculate the scroll_offset.

Note: Each ParallaxBackground is drawn on one specific Viewport and cannot be shared between multiple Viewports, see CanvasLayer.custom_viewport. When using multiple Viewports, for example in a split-screen game, you need create an individual ParallaxBackground for each Viewport you want it to be drawn on.

## Properties

int | layer | -100 (overrides CanvasLayer)
Vector2 | scroll_base_offset | Vector2(0, 0)
Vector2 | scroll_base_scale | Vector2(1, 1)
bool | scroll_ignore_camera_zoom | false
Vector2 | scroll_limit_begin | Vector2(0, 0)
Vector2 | scroll_limit_end | Vector2(0, 0)
Vector2 | scroll_offset | Vector2(0, 0)

---

## Property Descriptions

Vector2 scroll_base_offset = Vector2(0, 0) 

- void set_scroll_base_offset(value: Vector2)
- Vector2 get_scroll_base_offset()

The base position offset for all ParallaxLayer children.

---

Vector2 scroll_base_scale = Vector2(1, 1) 

- void set_scroll_base_scale(value: Vector2)
- Vector2 get_scroll_base_scale()

The base motion scale for all ParallaxLayer children.

---

bool scroll_ignore_camera_zoom = false 

- void set_ignore_camera_zoom(value: bool)
- bool is_ignore_camera_zoom()

If true, elements in ParallaxLayer child aren't affected by the zoom level of the camera.

---

Vector2 scroll_limit_begin = Vector2(0, 0) 

- void set_limit_begin(value: Vector2)
- Vector2 get_limit_begin()

Top-left limits for scrolling to begin. If the camera is outside of this limit, the background will stop scrolling. Must be lower than scroll_limit_end to work.

---

Vector2 scroll_limit_end = Vector2(0, 0) 

- void set_limit_end(value: Vector2)
- Vector2 get_limit_end()

Bottom-right limits for scrolling to end. If the camera is outside of this limit, the background will stop scrolling. Must be higher than scroll_limit_begin to work.

---

Vector2 scroll_offset = Vector2(0, 0) 

- void set_scroll_offset(value: Vector2)
- Vector2 get_scroll_offset()

The ParallaxBackground's scroll value. Calculated automatically when using a Camera2D, but can be used to manually manage scrolling when no camera is present.
