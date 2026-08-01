# FontVariation

Inherits: Font < Resource < RefCounted < Object

A variation of a font with additional settings.

## Description

Provides OpenType variations, simulated bold / slant, and additional font settings like OpenType features and extra spacing.

To use simulated bold font variant:

```
var fv = FontVariation.new()
fv.base_font = load("res://BarlowCondensed-Regular.ttf")
fv.variation_embolden = 1.2
$Label.add_theme_font_override("font", fv)
$Label.add_theme_font_size_override("font_size", 64)
```

```
var fv = new FontVariation();
fv.SetBaseFont(ResourceLoader.Load("res://BarlowCondensed-Regular.ttf"));
fv.SetVariationEmbolden(1.2);
GetNode("Label").AddThemeFontOverride("font", fv);
GetNode("Label").AddThemeFontSizeOverride("font_size", 64);
```

To set the coordinate of multiple variation axes:

```gdscript
var fv = FontVariation.new();
var ts = TextServerManager.get_primary_interface()
fv.base_font = load("res://BarlowCondensed-Regular.ttf")
fv.variation_opentype = { ts.name_to_tag("wght"): 900, ts.name_to_tag("custom_hght"): 900 }
```

## Properties

Font | base_font |
float | baseline_offset | 0.0
Dictionary | opentype_features | {}
PackedColorArray | palette_custom_colors | PackedColorArray()
int | palette_index | 0
int | spacing_bottom | 0
int | spacing_glyph | 0
int | spacing_space | 0
int | spacing_top | 0
float | variation_embolden | 0.0
int | variation_face_index | 0
Dictionary | variation_opentype | {}
Transform2D | variation_transform | Transform2D(1, 0, 0, 1, 0, 0)

## Methods

void | set_spacing(spacing: SpacingType, value: int)

---

## Property Descriptions

Font base_font 

- void set_base_font(value: Font)
- Font get_base_font()

Base font used to create a variation. If not set, default Theme font is used.

---

float baseline_offset = 0.0 

- void set_baseline_offset(value: float)
- float get_baseline_offset()

Extra baseline offset (as a fraction of font height).

---

Dictionary opentype_features = {} 

- void set_opentype_features(value: Dictionary)
- Dictionary get_opentype_features()

A set of OpenType feature tags. More info: OpenType feature tags [https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags].

---

PackedColorArray palette_custom_colors = PackedColorArray() 

- void set_palette_custom_colors(value: PackedColorArray)
- PackedColorArray get_palette_custom_colors()

An array of colors to override predefined palette. Use Color(0, 0, 0, 0), to keep predefined palette color at specific position.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedColorArray for more details.

---

int palette_index = 0 

- void set_palette_index(value: int)
- int get_palette_index()

A palette index.

---

int spacing_bottom = 0 

- void set_spacing(spacing: SpacingType, value: int)
- int get_spacing()

Extra spacing at the bottom of the line in pixels.

---

int spacing_glyph = 0 

- void set_spacing(spacing: SpacingType, value: int)
- int get_spacing()

Extra spacing between graphical glyphs.

---

int spacing_space = 0 

- void set_spacing(spacing: SpacingType, value: int)
- int get_spacing()

Extra width of the space glyphs.

---

int spacing_top = 0 

- void set_spacing(spacing: SpacingType, value: int)
- int get_spacing()

Extra spacing at the top of the line in pixels.

---

float variation_embolden = 0.0 

- void set_variation_embolden(value: float)
- float get_variation_embolden()

If is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

Note: Emboldened fonts might have self-intersecting outlines, which will prevent MSDF fonts and TextMesh from working correctly.

---

int variation_face_index = 0 

- void set_variation_face_index(value: int)
- int get_variation_face_index()

Active face index in the TrueType / OpenType collection file.

---

Dictionary variation_opentype = {} 

- void set_variation_opentype(value: Dictionary)
- Dictionary get_variation_opentype()

Font OpenType variation coordinates. More info: OpenType variation tags [https://docs.microsoft.com/en-us/typography/opentype/spec/dvaraxisreg].

Note: This Dictionary uses OpenType tags as keys. Variation axes can be identified both by tags (int, e.g. 0x77678674) and names (String, e.g. wght). Some axes might be accessible by multiple names. For example, wght refers to the same axis as weight. Tags on the other hand are unique. To convert between names and tags, use TextServer.name_to_tag() and TextServer.tag_to_name().

Note: To get available variation axes of a font, use Font.get_supported_variation_list().

---

Transform2D variation_transform = Transform2D(1, 0, 0, 1, 0, 0) 

- void set_variation_transform(value: Transform2D)
- Transform2D get_variation_transform()

2D transform, applied to the font outlines, can be used for slanting, flipping and rotating glyphs.

For example, to simulate italic typeface by slanting, apply the following transform Transform2D(1.0, slant, 0.0, 1.0, 0.0, 0.0).

---

## Method Descriptions

void set_spacing(spacing: SpacingType, value: int) 

Sets the spacing for spacing to value in pixels (not relative to the font size).
