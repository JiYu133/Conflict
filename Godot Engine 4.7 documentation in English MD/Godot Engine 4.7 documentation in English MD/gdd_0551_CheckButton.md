# CheckButton

Inherits: Button < BaseButton < Control < CanvasItem < Node < Object

A button that represents a binary choice.

## Description

CheckButton is a toggle button displayed as a check field. It's similar to CheckBox in functionality, but it has a different appearance. To follow established UX patterns, it's recommended to use CheckButton when toggling it has an immediate effect on something. For example, it can be used when pressing it shows or hides advanced settings, without asking the user to confirm this action.

See also BaseButton which contains common properties and methods associated with this node.

## Properties

HorizontalAlignment | alignment | 0 (overrides Button)
bool | toggle_mode | true (overrides BaseButton)

## Theme Properties

Color | button_checked_color | Color(1, 1, 1, 1)
Color | button_unchecked_color | Color(1, 1, 1, 1)
int | check_v_offset | 0
Texture2D | checked |
Texture2D | checked_disabled |
Texture2D | checked_disabled_mirrored |
Texture2D | checked_mirrored |
Texture2D | unchecked |
Texture2D | unchecked_disabled |
Texture2D | unchecked_disabled_mirrored |
Texture2D | unchecked_mirrored |

---

## Theme Property Descriptions

Color button_checked_color = Color(1, 1, 1, 1) 

The color of the checked icon when the checkbox is pressed.

---

Color button_unchecked_color = Color(1, 1, 1, 1) 

The color of the unchecked icon when the checkbox is not pressed.

---

int check_v_offset = 0 

The vertical offset used when rendering the toggle icons (in pixels).

---

Texture2D checked 

The icon to display when the CheckButton is checked (for left-to-right layouts).

---

Texture2D checked_disabled 

The icon to display when the CheckButton is checked and disabled (for left-to-right layouts).

---

Texture2D checked_disabled_mirrored 

The icon to display when the CheckButton is checked and disabled (for right-to-left layouts).

---

Texture2D checked_mirrored 

The icon to display when the CheckButton is checked (for right-to-left layouts).

---

Texture2D unchecked 

The icon to display when the CheckButton is unchecked (for left-to-right layouts).

---

Texture2D unchecked_disabled 

The icon to display when the CheckButton is unchecked and disabled (for left-to-right layouts).

---

Texture2D unchecked_disabled_mirrored 

The icon to display when the CheckButton is unchecked and disabled (for right-to-left layouts).

---

Texture2D unchecked_mirrored 

The icon to display when the CheckButton is unchecked (for right-to-left layouts).
