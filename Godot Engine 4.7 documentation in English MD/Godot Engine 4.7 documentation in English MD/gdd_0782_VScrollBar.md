# VScrollBar

Inherits: ScrollBar < Range < Control < CanvasItem < Node < Object

A vertical scrollbar that goes from top (min) to bottom (max).

## Description

A vertical scrollbar, typically used to navigate through content that extends beyond the visible height of a control. It is a Range-based control and goes from top (min) to bottom (max). Note that this direction is the opposite of VSlider's.

## Properties

BitField[SizeFlags] | size_flags_horizontal | 0 (overrides Control)
BitField[SizeFlags] | size_flags_vertical | 1 (overrides Control)

## Theme Properties

int | padding_left | 0
int | padding_right | 0

---

## Theme Property Descriptions

int padding_left = 0 

Padding between the left of the ScrollBar.scroll element and the ScrollBar.grabber.

Note: To apply vertical padding, modify the top/bottom content margins of ScrollBar.scroll instead.

---

int padding_right = 0 

Padding between the right of the ScrollBar.scroll element and the ScrollBar.grabber.

Note: To apply vertical padding, modify the top/bottom content margins of ScrollBar.scroll instead.
