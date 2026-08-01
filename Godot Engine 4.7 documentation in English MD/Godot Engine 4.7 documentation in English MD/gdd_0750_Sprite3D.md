# Sprite3D

Inherits: SpriteBase3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

2D sprite node in a 3D world.

## Description

A node that displays a 2D texture in a 3D environment. The texture displayed can be a region from a larger atlas texture, or a frame from a sprite sheet animation. See also SpriteBase3D where properties such as the billboard mode are defined.

## Properties

int | frame | 0
Vector2i | frame_coords | Vector2i(0, 0)
int | hframes | 1
bool | region_enabled | false
Rect2 | region_rect | Rect2(0, 0, 0, 0)
Texture2D | texture |
int | vframes | 1

---

## Signals

frame_changed() 

Emitted when the frame changes.

---

texture_changed() 

Emitted when the texture changes.

---

## Property Descriptions

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

bool region_enabled = false 

- void set_region_enabled(value: bool)
- bool is_region_enabled()

If true, the sprite will use region_rect and display only the specified part of its texture.

---

Rect2 region_rect = Rect2(0, 0, 0, 0) 

- void set_region_rect(value: Rect2)
- Rect2 get_region_rect()

The region of the atlas texture to display. region_enabled must be true.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

Texture2D object to draw. If GeometryInstance3D.material_override is used, this will be overridden. The size information is still used.

---

int vframes = 1 

- void set_vframes(value: int)
- int get_vframes()

The number of rows in the sprite sheet. When this property is changed, frame is adjusted so that the same visual frame is maintained (same row and column). If that's impossible, frame is reset to 0.
