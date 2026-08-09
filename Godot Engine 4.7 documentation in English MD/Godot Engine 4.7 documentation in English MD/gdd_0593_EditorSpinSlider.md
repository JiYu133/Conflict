# EditorSpinSlider

Inherits: Range < Control < CanvasItem < Node < Object

Godot editor's control for editing numeric values.

## Description

This Control node is used in the editor's Inspector dock to allow editing of numeric values. Can be used with EditorInspectorPlugin to recreate the same behavior.

If the Range.step value is 1, the EditorSpinSlider will display up/down arrows, similar to SpinBox. If the Range.step value is not 1, a slider will be displayed instead.

## Properties

ControlState | control_state | 0
bool | deferred_drag_mode | false
bool | editing_integer | false
bool | flat | false
FocusMode | focus_mode | 2 (overrides Control)
bool | hide_slider | false
String | label | ""
bool | read_only | false
BitField[SizeFlags] | size_flags_vertical | 1 (overrides Control)
float | step | 1.0 (overrides Range)
String | suffix | ""

## Theme Properties

Texture2D | updown
Texture2D | updown_disabled

---

## Signals

grabbed() 

Emitted when the spinner/slider is grabbed.

---

ungrabbed() 

Emitted when the spinner/slider is ungrabbed.

---

updown_pressed() 

Emitted when the updown button is pressed.

---

value_focus_entered() 

Emitted when the value form gains focus.

---

value_focus_exited() 

Emitted when the value form loses focus.

---

## Enumerations

enum ControlState
ControlState CONTROL_STATE_DEFAULT = 0

The type of control used will depend on the value of editing_integer. Up-down arrows if true, a slider if false.

ControlState CONTROL_STATE_PREFER_SLIDER = 1

A slider will always be used, even if editing_integer is enabled.

ControlState CONTROL_STATE_HIDE = 2

Neither the up-down arrows nor the slider will be shown.

---

## Property Descriptions

ControlState control_state = 0 

- void set_control_state(value: ControlState)
- ControlState get_control_state()

The state in which the control used to manipulate the value will be.

---

bool deferred_drag_mode = false 

- void set_deferred_drag_mode_enabled(value: bool)
- bool is_deferred_drag_mode_enabled()

If true, changing via dragging is applied only at the end of the input (for example, when the user releases a mouse button).

---

bool editing_integer = false 

- void set_editing_integer(value: bool)
- bool is_editing_integer()

If true, the EditorSpinSlider is considered to be editing an integer value. If false, the EditorSpinSlider is considered to be editing a floating-point value. This is used to determine whether a slider should be drawn by default. The slider is only drawn for floats; integers use up-down arrows similar to SpinBox instead, unless control_state is set to CONTROL_STATE_PREFER_SLIDER. It will also use EditorSettings.interface/inspector/integer_drag_speed instead of EditorSettings.interface/inspector/float_drag_speed if the slider is available.

---

bool flat = false 

- void set_flat(value: bool)
- bool is_flat()

If true, the slider will not draw background.

---

bool hide_slider = false 

- void set_hide_slider(value: bool)
- bool is_hiding_slider()

Deprecated: Use control_state instead.

If true, the slider and up/down arrows are hidden.

---

String label = "" 

- void set_label(value: String)
- String get_label()

The text that displays to the left of the value.

---

bool read_only = false 

- void set_read_only(value: bool)
- bool is_read_only()

If true, the slider can't be interacted with.

---

String suffix = "" 

- void set_suffix(value: String)
- String get_suffix()

The suffix to display after the value (in a faded color). This should generally be a plural word. You may have to use an abbreviation if the suffix is too long to be displayed.

---

## Theme Property Descriptions

Texture2D updown 

Single texture representing both the up and down buttons.

---

Texture2D updown_disabled 

Single texture representing both the up and down buttons, when the control is readonly or disabled.
