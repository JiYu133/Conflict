# Sprite2D

Inherits: Node2D < CanvasItem < Node < Object

General-purpose sprite node.

## Description

A node that displays a 2D texture. The texture displayed can be a region from a larger atlas texture, or a frame from a sprite sheet animation.

## Tutorials

- Instancing Demo [https://godotengine.org/asset-library/asset/2716]

## Properties

bool | centered | true
bool | flip_h | false
bool | flip_v | false
int | frame | 0
Vector2i | frame_coords | Vector2i(0, 0)
int | hframes | 1
Vector2 | offset | Vector2(0, 0)
bool | region_enabled | false
bool | region_filter_clip_enabled | false
Rect2 | region_rect | Rect2(0, 0, 0, 0)
Texture2D | texture |
int | vframes | 1

## Methods

Rect2 | get_rect() const
bool | is_pixel_opaque(pos: Vector2) const

---

## Signals

frame_changed() 

Emitted when the frame changes.

---

texture_changed() 

Emitted when the texture changes.

---

## Property Descriptions

bool centered = true 

- void set_centered(value: bool)
- bool is_centered()

If true, texture is centered.

Note: For games with a pixel art aesthetic, textures may appear deformed when centered. This is caused by their position being between pixels. To prevent this, set this property to false, or consider enabling ProjectSettings.rendering/2d/snap/snap_2d_vertices_to_pixel and ProjectSettings.rendering/2d/snap/snap_2d_transforms_to_pixel.

---

bool flip_h = false 

- void set_flip_h(value: bool)
- bool is_flipped_h()

If true, texture is flipped horizontally.

---

bool flip_v = false 

- void set_flip_v(value: bool)
- bool is_flipped_v()

If true, texture is flipped vertically.

---

int frame = 0 

- void set_frame(value: int)
- int get_frame()

Current frame to display from sprite sheet. hframes or vframes must be greater than 1. This property is automatically adjusted when hframes or vframes are changed to keep pointing to the same visual frame (same column and row). If that's impossible, this value is reset to 0.

---

Vector2i frame_coords = Vector2i(0, 0) 

- void set_frame_coords(value: Vector2i)
- Vector2i get_frame_coords()

Coordinates of the frame to display from sprite sheet. This is as an alias for the frame property. hframes or vframes must be greater than 1.

---

int hframes = 1 

- void set_hframes(value: int)
- int get_hframes()

The number of columns in the sprite sheet. When this property is changed, frame is adjusted so that the same visual frame is maintained (same row and column). If that's impossible, frame is reset to 0.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The texture's drawing offset.

Note: When you increase offset.y in Sprite2D, the sprite moves downward on screen (i.e., +Y is down).

---

bool region_enabled = false 

- void set_region_enabled(value: bool)
- bool is_region_enabled()

If true, texture is cut from a larger atlas texture. See region_rect.

Note: When using a custom Shader on a Sprite2D, the UV shader built-in will refer to the entire texture space. Use the REGION_RECT built-in to get the currently visible region defined in region_rect instead. See CanvasItem shaders for details.

---

bool region_filter_clip_enabled = false 

- void set_region_filter_clip_enabled(value: bool)
- bool is_region_filter_clip_enabled()

If true, the area outside of the region_rect is clipped to avoid bleeding of the surrounding texture pixels. region_enabled must be true.

---

Rect2 region_rect = Rect2(0, 0, 0, 0) 

- void set_region_rect(value: Rect2)
- Rect2 get_region_rect()

The region of the atlas texture to display. region_enabled must be true.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

Texture2D object to draw.

---

int vframes = 1 

- void set_vframes(value: int)
- int get_vframes()

The number of rows in the sprite sheet. When this property is changed, frame is adjusted so that the same visual frame is maintained (same row and column). If that's impossible, frame is reset to 0.

---

## Method Descriptions

Rect2 get_rect() const 

Returns a Rect2 representing the Sprite2D's boundary in local coordinates.

Example: Detect if the Sprite2D was clicked:

```
func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if get_rect().has_point(to_local(event.position)):
            print("A click!")
```

```
public override void _Input(InputEvent @event)
{
    if (@event is InputEventMouseButton inputEventMouse)
    {
        if (inputEventMouse.Pressed && inputEventMouse.ButtonIndex == MouseButton.Left)
        {
            if (GetRect().HasPoint(ToLocal(inputEventMouse.Position)))
            {
                GD.Print("A click!");
            }
        }
    }
}
```

---

bool is_pixel_opaque(pos: Vector2) const 

Returns true if the pixel at the given position is opaque, false otherwise. Also returns false if the given position is out of bounds or this sprite's texture is null. pos is in local coordinates.
