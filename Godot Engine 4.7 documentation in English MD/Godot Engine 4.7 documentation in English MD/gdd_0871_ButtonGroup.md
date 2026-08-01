# ButtonGroup

Inherits: Resource < RefCounted < Object

A group of buttons that doesn't allow more than one button to be pressed at a time.

## Description

A group of BaseButton-derived buttons. The buttons in a ButtonGroup are treated like radio buttons: No more than one button can be pressed at a time. Some types of buttons (such as CheckBox) may have a special appearance in this state.

Every member of a ButtonGroup should have BaseButton.toggle_mode set to true.

## Properties

bool | allow_unpress | false
bool | resource_local_to_scene | true (overrides Resource)

## Methods

Array[BaseButton] | get_buttons()
BaseButton | get_pressed_button()

---

## Signals

pressed(button: BaseButton) 

Emitted when one of the buttons of the group is pressed.

---

## Property Descriptions

bool allow_unpress = false 

- void set_allow_unpress(value: bool)
- bool is_allow_unpress()

If true, it is possible to unpress all buttons in this ButtonGroup.

---

## Method Descriptions

Array[BaseButton] get_buttons() 

Returns an Array of Buttons who have this as their ButtonGroup (see BaseButton.button_group).

---

BaseButton get_pressed_button() 

Returns the current pressed button.
