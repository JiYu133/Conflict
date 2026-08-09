# ScrollBar

Inherits: Range < Control < CanvasItem < Node < Object

Inherited By: HScrollBar, VScrollBar

Abstract base class for scrollbars.

## Description

Abstract base class for scrollbars, typically used to navigate through content that extends beyond the visible area of a control. Scrollbars are Range-based controls.

## Properties

float | custom_step | -1.0
FocusMode | focus_mode | 3 (overrides Control)
float | step | 0.0 (overrides Range)

## Theme Properties

Texture2D | decrement
Texture2D | decrement_highlight
Texture2D | decrement_pressed
Texture2D | increment
Texture2D | increment_highlight
Texture2D | increment_pressed
StyleBox | grabber
StyleBox | grabber_highlight
StyleBox | grabber_pressed
StyleBox | scroll
StyleBox | scroll_focus

---

## Signals

scrolling() 

Emitted when the scrollbar is being scrolled.

---

## Property Descriptions

float custom_step = -1.0 

- void set_custom_step(value: float)
- float get_custom_step()

Overrides the step used when clicking increment and decrement buttons or when using arrow keys when the ScrollBar is focused.

---

## Theme Property Descriptions

Texture2D decrement 

Icon used as a button to scroll the ScrollBar left/up. Supports custom step using the custom_step property.

---

Texture2D decrement_highlight 

Displayed when the mouse cursor hovers over the decrement button.

---

Texture2D decrement_pressed 

Displayed when the decrement button is being pressed.

---

Texture2D increment 

Icon used as a button to scroll the ScrollBar right/down. Supports custom step using the custom_step property.

---

Texture2D increment_highlight 

Displayed when the mouse cursor hovers over the increment button.

---

Texture2D increment_pressed 

Displayed when the increment button is being pressed.

---

StyleBox grabber 

Used as texture for the grabber, the draggable element representing current scroll.

---

StyleBox grabber_highlight 

Used when the mouse hovers over the grabber.

---

StyleBox grabber_pressed 

Used when the grabber is being dragged.

---

StyleBox scroll 

Used as background of this ScrollBar.

---

StyleBox scroll_focus 

Used as background when the ScrollBar has the GUI focus.
