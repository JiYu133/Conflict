# MarginContainer

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: EditorDock

A container that keeps a margin around its child controls.

## Description

MarginContainer adds an adjustable margin on each side of its child controls. The margins are added around all children, not around each individual one. To control the MarginContainer's margins, use the margin_* theme properties listed below.

Note: The margin sizes are theme overrides, not normal properties. This is an example of how to change them in code:

```
# This code sample assumes the current script is extending MarginContainer.
var margin_value = 100
add_theme_constant_override("margin_top", margin_value)
add_theme_constant_override("margin_left", margin_value)
add_theme_constant_override("margin_bottom", margin_value)
add_theme_constant_override("margin_right", margin_value)
```

```
// This code sample assumes the current script is extending MarginContainer.
int marginValue = 100;
AddThemeConstantOverride("margin_top", marginValue);
AddThemeConstantOverride("margin_left", marginValue);
AddThemeConstantOverride("margin_bottom", marginValue);
AddThemeConstantOverride("margin_right", marginValue);
```

## Tutorials

- Using Containers

## Theme Properties

int | margin_bottom | 0
int | margin_left | 0
int | margin_right | 0
int | margin_top | 0

---

## Theme Property Descriptions

int margin_bottom = 0 

Offsets towards the inside direct children of the container by this amount of pixels from the bottom.

---

int margin_left = 0 

Offsets towards the inside direct children of the container by this amount of pixels from the left.

---

int margin_right = 0 

Offsets towards the inside direct children of the container by this amount of pixels from the right.

---

int margin_top = 0 

Offsets towards the inside direct children of the container by this amount of pixels from the top.
