# ProgressBar

Inherits: Range < Control < CanvasItem < Node < Object

A control used for visual representation of a percentage.

## Description

A control used for visual representation of a percentage. Shows the fill percentage in the center. Can also be used to show indeterminate progress. For more fill modes, use TextureProgressBar instead.

## Properties

bool | editor_preview_indeterminate |
int | fill_mode | 0
bool | indeterminate | false
bool | show_percentage | true

## Theme Properties

Color | font_color | Color(0.95, 0.95, 0.95, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
int | outline_size | 0
Font | font |
int | font_size |
StyleBox | background |
StyleBox | fill |

---

## Enumerations

enum FillMode
FillMode FILL_BEGIN_TO_END = 0

The progress bar fills from begin to end horizontally, according to the language direction. If Control.is_layout_rtl() returns false, it fills from left to right, and if it returns true, it fills from right to left.

FillMode FILL_END_TO_BEGIN = 1

The progress bar fills from end to begin horizontally, according to the language direction. If Control.is_layout_rtl() returns false, it fills from right to left, and if it returns true, it fills from left to right.

FillMode FILL_TOP_TO_BOTTOM = 2

The progress fills from top to bottom.

FillMode FILL_BOTTOM_TO_TOP = 3

The progress fills from bottom to top.

---

## Property Descriptions

bool editor_preview_indeterminate 

- void set_editor_preview_indeterminate(value: bool)
- bool is_editor_preview_indeterminate_enabled()

If false, the indeterminate animation will be paused in the editor.

---

int fill_mode = 0 

- void set_fill_mode(value: int)
- int get_fill_mode()

The fill direction. See FillMode for possible values.

---

bool indeterminate = false 

- void set_indeterminate(value: bool)
- bool is_indeterminate()

When set to true, the progress bar indicates that something is happening with an animation, but does not show the fill percentage or value.

---

bool show_percentage = true 

- void set_show_percentage(value: bool)
- bool is_percentage_shown()

If true, the fill percentage is displayed on the bar.

---

## Theme Property Descriptions

Color font_color = Color(0.95, 0.95, 0.95, 1) 

The color of the text.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the ProgressBar.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

Font font 

Font used to draw the fill percentage if show_percentage is true.

---

int font_size 

Font size used to draw the fill percentage if show_percentage is true.

---

StyleBox background 

The style of the background.

---

StyleBox fill 

The style of the progress (i.e. the part that fills the bar).
