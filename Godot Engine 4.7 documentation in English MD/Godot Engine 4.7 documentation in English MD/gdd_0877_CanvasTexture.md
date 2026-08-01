# CanvasTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Texture with optional normal and specular maps for use in 2D rendering.

## Description

CanvasTexture is an alternative to ImageTexture for 2D rendering. It allows using normal maps and specular maps in any node that inherits from CanvasItem. CanvasTexture also allows overriding the texture's filter and repeat mode independently of the node's properties (or the project settings).

Note: CanvasTexture cannot be used in 3D. It will not display correctly when applied to any VisualInstance3D, such as Sprite3D or Decal. For physically-based materials in 3D, use BaseMaterial3D instead.

## Tutorials

- 2D Lights and Shadows

## Properties

Texture2D | diffuse_texture |
Texture2D | normal_texture |
bool | resource_local_to_scene | false (overrides Resource)
Color | specular_color | Color(1, 1, 1, 1)
float | specular_shininess | 1.0
Texture2D | specular_texture |
TextureFilter | texture_filter | 0
TextureRepeat | texture_repeat | 0

---

## Property Descriptions

Texture2D diffuse_texture 

- void set_diffuse_texture(value: Texture2D)
- Texture2D get_diffuse_texture()

The diffuse (color) texture to use. This is the main texture you want to set in most cases.

---

Texture2D normal_texture 

- void set_normal_texture(value: Texture2D)
- Texture2D get_normal_texture()

The normal map texture to use. Only has a visible effect if Light2Ds are affecting this CanvasTexture.

Note: Godot expects the normal map to use X+, Y+, and Z+ coordinates. See this page [http://wiki.polycount.com/wiki/Normal_Map_Technical_Details#Common_Swizzle_Coordinates] for a comparison of normal map coordinates expected by popular engines.

---

Color specular_color = Color(1, 1, 1, 1) 

- void set_specular_color(value: Color)
- Color get_specular_color()

The multiplier for specular reflection colors. The Light2D's color is also taken into account when determining the reflection color. Only has a visible effect if Light2Ds are affecting this CanvasTexture.

---

float specular_shininess = 1.0 

- void set_specular_shininess(value: float)
- float get_specular_shininess()

The specular exponent for Light2D specular reflections. Higher values result in a more glossy/"wet" look, with reflections becoming more localized and less visible overall. The default value of 1.0 disables specular reflections entirely. Only has a visible effect if Light2Ds are affecting this CanvasTexture.

---

Texture2D specular_texture 

- void set_specular_texture(value: Texture2D)
- Texture2D get_specular_texture()

The specular map to use for Light2D specular reflections. This should be a grayscale or colored texture, with brighter areas resulting in a higher specular_shininess value. Using a colored specular_texture allows controlling specular shininess on a per-channel basis. Only has a visible effect if Light2Ds are affecting this CanvasTexture.

---

TextureFilter texture_filter = 0 

- void set_texture_filter(value: TextureFilter)
- TextureFilter get_texture_filter()

The texture filtering mode to use when drawing this CanvasTexture.

---

TextureRepeat texture_repeat = 0 

- void set_texture_repeat(value: TextureRepeat)
- TextureRepeat get_texture_repeat()

The texture repeat mode to use when drawing this CanvasTexture.
