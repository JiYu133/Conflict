# TouchScreenButton

Inherits: Node2D < CanvasItem < Node < Object

Button for touch screen devices for gameplay use.

## Description

TouchScreenButton allows you to create on-screen buttons for touch devices. It's intended for gameplay use, such as a unit you have to touch to move. Unlike Button, TouchScreenButton supports multitouch out of the box. Several TouchScreenButtons can be pressed at the same time with touch input.

This node inherits from Node2D. Unlike with Control nodes, you cannot set anchors on it. If you want to create menus or user interfaces, you may want to use Button nodes instead. To make button nodes react to touch events, you can enable ProjectSettings.input_devices/pointing/emulate_mouse_from_touch in the Project Settings.

You can configure TouchScreenButton to be visible only on touch devices, helping you develop your game both for desktop and mobile devices.

## Properties

String | action | ""
BitMap | bitmask |
bool | passby_press | false
Shape2D | shape |
bool | shape_centered | true
bool | shape_visible | true
Texture2D | texture_normal |
Texture2D | texture_pressed |
VisibilityMode | visibility_mode | 0

## Methods

bool | is_pressed() const

---

## Signals

pressed() 

Emitted when the button is pressed (down).

---

released() 

Emitted when the button is released (up).

---

## Enumerations

enum VisibilityMode
VisibilityMode VISIBILITY_ALWAYS = 0

Always visible.

VisibilityMode VISIBILITY_TOUCHSCREEN_ONLY = 1

Visible on touch screens only.

---

## Property Descriptions

String action = "" 

- void set_action(value: String)
- String get_action()

The button's action. Actions can be handled with InputEventAction.

---

BitMap bitmask 

- void set_bitmask(value: BitMap)
- BitMap get_bitmask()

The button's bitmask.

---

bool passby_press = false 

- void set_passby_press(value: bool)
- bool is_passby_press_enabled()

If true, the pressed and released signals are emitted whenever a pressed finger goes in and out of the button, even if the pressure started outside the active area of the button.

Note: This is a "pass-by" (not "bypass") press mode.

---

Shape2D shape 

- void set_shape(value: Shape2D)
- Shape2D get_shape()

The button's shape.

---

bool shape_centered = true 

- void set_shape_centered(value: bool)
- bool is_shape_centered()

If true, the button's shape is centered in the provided texture. If no texture is used, this property has no effect.

---

bool shape_visible = true 

- void set_shape_visible(value: bool)
- bool is_shape_visible()

If true, the button's shape is visible in the editor.

---

Texture2D texture_normal 

- void set_texture_normal(value: Texture2D)
- Texture2D get_texture_normal()

The button's texture for the normal state.

---

Texture2D texture_pressed 

- void set_texture_pressed(value: Texture2D)
- Texture2D get_texture_pressed()

The button's texture for the pressed state.

---

VisibilityMode visibility_mode = 0 

- void set_visibility_mode(value: VisibilityMode)
- VisibilityMode get_visibility_mode()

The button's visibility mode.

---

## Method Descriptions

bool is_pressed() const 

Returns true if this button is currently pressed.
