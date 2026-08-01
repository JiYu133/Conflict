# DPITexture

Experimental: This class may be changed or removed in future versions.

Inherits: Texture2D < Texture < Resource < RefCounted < Object

An automatically scalable Texture2D based on an SVG image.

## Description

An automatically scalable Texture2D based on an SVG image. DPITextures are used to automatically re-rasterize icons and other texture based UI theme elements to match viewport scale and font oversampling. See also ProjectSettings.display/window/stretch/mode ("canvas_items" mode) and Viewport.oversampling_override.

## Properties

float | base_scale | 1.0
Dictionary | color_map | {}
bool | fix_alpha_border | false
bool | premult_alpha | false
bool | resource_local_to_scene | false (overrides Resource)
float | saturation | 1.0

## Methods

DPITexture | create_from_string(source: String, scale: float = 1.0, saturation: float = 1.0, color_map: Dictionary = {}) static
RID | get_scaled_rid() const
String | get_source() const
void | set_size_override(size: Vector2i)
void | set_source(source: String)

---

## Property Descriptions

float base_scale = 1.0 

- void set_base_scale(value: float)
- float get_base_scale()

Texture scale. 1.0 is the original SVG size. Higher values result in a larger image.

---

Dictionary color_map = {} 

- void set_color_map(value: Dictionary)
- Dictionary get_color_map()

If set, remaps texture colors according to Color-Color map.

---

bool fix_alpha_border = false 

- void set_fix_alpha_border(value: bool)
- bool get_fix_alpha_border()

If true, puts pixels of the same surrounding color in transition from transparent to opaque areas. For textures displayed with bilinear filtering, this helps to reduce the outline effect when exporting images from an image editor.

---

bool premult_alpha = false 

- void set_premult_alpha(value: bool)
- bool get_premult_alpha()

An alternative to fixing darkened borders with fix_alpha_border is to use premultiplied alpha. By enabling this option, the texture will be converted to this format. A premultiplied alpha texture requires specific materials to be displayed correctly:

- In 2D, a CanvasItemMaterial will need to be created and configured to use the CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA blend mode on CanvasItems that use this texture. In custom canvas_item shaders, render_mode blend_premul_alpha; should be used.
- In 3D, a BaseMaterial3D will need to be created and configured to use the BaseMaterial3D.BLEND_MODE_PREMULT_ALPHA blend mode on materials that use this texture. In custom spatial shaders, render_mode blend_premul_alpha; should be used.

---

float saturation = 1.0 

- void set_saturation(value: float)
- float get_saturation()

Overrides texture saturation.

---

## Method Descriptions

DPITexture create_from_string(source: String, scale: float = 1.0, saturation: float = 1.0, color_map: Dictionary = {}) static 

Creates a new DPITexture and initializes it by allocating and setting the SVG data to source.

---

RID get_scaled_rid() const 

Returns the RID of the texture rasterized to match the oversampling of the currently drawn canvas item.

---

String get_source() const 

Returns this SVG texture's source code.

---

void set_size_override(size: Vector2i) 

Resizes the texture to the specified dimensions.

---

void set_source(source: String) 

Sets this SVG texture's source code.
