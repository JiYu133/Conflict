# ThemeDB

Inherits: Object

A singleton that provides access to static information about Theme resources used by the engine and by your project.

## Description

This singleton provides access to static information about Theme resources used by the engine and by your projects. You can fetch the default engine theme, as well as your project configured theme.

ThemeDB also contains fallback values for theme properties.

## Properties

float | fallback_base_scale | 1.0
Font | fallback_font |
int | fallback_font_size | 16
Texture2D | fallback_icon |
StyleBox | fallback_stylebox |

## Methods

Theme | get_default_theme()
Theme | get_project_theme()

---

## Signals

fallback_changed() 

Emitted when one of the fallback values had been changed. Use it to refresh the look of controls that may rely on the fallback theme items.

---

## Property Descriptions

float fallback_base_scale = 1.0 

- void set_fallback_base_scale(value: float)
- float get_fallback_base_scale()

The fallback base scale factor of every Control node and Theme resource. Used when no other value is available to the control.

See also Theme.default_base_scale.

---

Font fallback_font 

- void set_fallback_font(value: Font)
- Font get_fallback_font()

The fallback font of every Control node and Theme resource. Used when no other value is available to the control.

See also Theme.default_font.

---

int fallback_font_size = 16 

- void set_fallback_font_size(value: int)
- int get_fallback_font_size()

The fallback font size of every Control node and Theme resource. Used when no other value is available to the control.

See also Theme.default_font_size.

---

Texture2D fallback_icon 

- void set_fallback_icon(value: Texture2D)
- Texture2D get_fallback_icon()

The fallback icon of every Control node and Theme resource. Used when no other value is available to the control.

---

StyleBox fallback_stylebox 

- void set_fallback_stylebox(value: StyleBox)
- StyleBox get_fallback_stylebox()

The fallback stylebox of every Control node and Theme resource. Used when no other value is available to the control.

---

## Method Descriptions

Theme get_default_theme() 

Returns a reference to the default engine Theme. This theme resource is responsible for the out-of-the-box look of Control nodes and cannot be overridden.

---

Theme get_project_theme() 

Returns a reference to the custom project Theme. This theme resources allows to override the default engine theme for every control node in the project.

To set the project theme, see ProjectSettings.gui/theme/custom.
