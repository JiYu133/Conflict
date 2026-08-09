# ColorPickerButton

Inherits: Button < BaseButton < Control < CanvasItem < Node < Object

A button that brings up a ColorPicker when pressed.

## Description

Encapsulates a ColorPicker, making it accessible by pressing a button. Pressing the button will toggle the ColorPicker's visibility.

See also BaseButton which contains common properties and methods associated with this node.

Note: By default, the button may not be wide enough for the color preview swatch to be visible. Make sure to set Control.custom_minimum_size to a big enough value to give the button enough space.

## Tutorials

- 2D GD Paint Demo [https://godotengine.org/asset-library/asset/2768]
- GUI Drag And Drop Demo [https://godotengine.org/asset-library/asset/2767]

## Properties

Color | color | Color(0, 0, 0, 1)
bool | edit_alpha | true
bool | edit_intensity | true
bool | toggle_mode | true (overrides BaseButton)

## Methods

ColorPicker | get_picker()
PopupPanel | get_popup()

## Theme Properties

Texture2D | bg

---

## Signals

color_changed(color: Color) 

Emitted when the color changes.

---

picker_created() 

Emitted when the ColorPicker is created (the button is pressed for the first time).

---

popup_closed() 

Emitted when the ColorPicker is closed.

---

## Property Descriptions

Color color = Color(0, 0, 0, 1) 

- void set_pick_color(value: Color)
- Color get_pick_color()

The currently selected color.

---

bool edit_alpha = true 

- void set_edit_alpha(value: bool)
- bool is_editing_alpha()

If true, the alpha channel in the displayed ColorPicker will be visible.

---

bool edit_intensity = true 

- void set_edit_intensity(value: bool)
- bool is_editing_intensity()

If true, the intensity slider in the displayed ColorPicker will be visible.

---

## Method Descriptions

ColorPicker get_picker() 

Returns the ColorPicker that this node toggles.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

PopupPanel get_popup() 

Returns the control's PopupPanel which allows you to connect to popup signals. This allows you to handle events when the ColorPicker is shown or hidden.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their Window.visible property.

---

## Theme Property Descriptions

Texture2D bg 

The background of the color preview rect on the button.
