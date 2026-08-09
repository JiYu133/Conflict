# BaseButton

Inherits: Control < CanvasItem < Node < Object

Inherited By: Button, LinkButton, TextureButton

Abstract base class for GUI buttons.

## Description

BaseButton is an abstract base class for GUI buttons. It doesn't display anything by itself.

## Properties

ActionMode | action_mode | 1
ButtonGroup | button_group |
BitField[MouseButtonMask] | button_mask | 1
bool | button_pressed | false
bool | disabled | false
FocusMode | focus_mode | 2 (overrides Control)
bool | keep_pressed_outside | false
Shortcut | shortcut |
bool | shortcut_feedback | true
bool | shortcut_in_tooltip | true
bool | toggle_mode | false

## Methods

void | _pressed() virtual
void | _toggled(toggled_on: bool) virtual
DrawMode | get_draw_mode() const
bool | is_hovered() const
void | set_pressed_no_signal(pressed: bool)

---

## Signals

button_down() 

Emitted when the button starts being held down.

---

button_up() 

Emitted when the button stops being held down.

---

pressed() 

Emitted when the button is toggled or pressed. This is on button_down if action_mode is ACTION_MODE_BUTTON_PRESS and on button_up otherwise.

If you need to know the button's pressed state (and toggle_mode is active), use toggled instead.

---

toggled(toggled_on: bool) 

Emitted when the button was just toggled between pressed and normal states (only if toggle_mode is active). The new state is contained in the toggled_on argument.

---

## Enumerations

enum DrawMode
DrawMode DRAW_NORMAL = 0

The normal state (i.e. not pressed, not hovered, not toggled and enabled) of buttons.

DrawMode DRAW_PRESSED = 1

The state of buttons are pressed.

DrawMode DRAW_HOVER = 2

The state of buttons are hovered.

DrawMode DRAW_DISABLED = 3

The state of buttons are disabled.

DrawMode DRAW_HOVER_PRESSED = 4

The state of buttons are both hovered and pressed.

---

enum ActionMode
ActionMode ACTION_MODE_BUTTON_PRESS = 0

Require just a press to consider the button clicked.

ActionMode ACTION_MODE_BUTTON_RELEASE = 1

Require a press and a subsequent release before considering the button clicked.

---

## Property Descriptions

ActionMode action_mode = 1 

- void set_action_mode(value: ActionMode)
- ActionMode get_action_mode()

Determines when the button is considered clicked.

---

ButtonGroup button_group 

- void set_button_group(value: ButtonGroup)
- ButtonGroup get_button_group()

The ButtonGroup associated with the button. Not to be confused with node groups.

Note: The button will be configured as a radio button if a ButtonGroup is assigned to it.

---

BitField[MouseButtonMask] button_mask = 1 

- void set_button_mask(value: BitField[MouseButtonMask])
- BitField[MouseButtonMask] get_button_mask()

Binary mask to choose which mouse buttons this button will respond to.

To allow both left-click and right-click, use MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT.

---

bool button_pressed = false 

- void set_pressed(value: bool)
- bool is_pressed()

If true, the button's state is pressed. Means the button is pressed down or toggled (if toggle_mode is active). Only works if toggle_mode is true.

Note: Changing the value of button_pressed will result in toggled to be emitted. If you want to change the pressed state without emitting that signal, use set_pressed_no_signal().

---

bool disabled = false 

- void set_disabled(value: bool)
- bool is_disabled()

If true, the button is in disabled state and can't be clicked or toggled.

Note: If the button is disabled while held down, button_up will be emitted.

---

bool keep_pressed_outside = false 

- void set_keep_pressed_outside(value: bool)
- bool is_keep_pressed_outside()

If true, the button stays pressed when moving the cursor outside the button while pressing it.

Note: This property only affects the button's visual appearance. Signals will be emitted at the same moment regardless of this property's value.

---

Shortcut shortcut 

- void set_shortcut(value: Shortcut)
- Shortcut get_shortcut()

Shortcut associated to the button.

---

bool shortcut_feedback = true 

- void set_shortcut_feedback(value: bool)
- bool is_shortcut_feedback()

If true, the button will highlight for a short amount of time when its shortcut is activated. If false and toggle_mode is false, the shortcut will activate without any visual feedback.

---

bool shortcut_in_tooltip = true 

- void set_shortcut_in_tooltip(value: bool)
- bool is_shortcut_in_tooltip_enabled()

If true, the button will add information about its shortcut in the tooltip. This includes the shortcut's events and its Resource.resource_name. If both events and name are empty, the shortcut will not be included.

Note: This property does nothing when the tooltip control is customized using Control._make_custom_tooltip().

---

bool toggle_mode = false 

- void set_toggle_mode(value: bool)
- bool is_toggle_mode()

If true, the button is in toggle mode. Makes the button flip state between pressed and unpressed each time its area is clicked.

---

## Method Descriptions

void _pressed() virtual 

Called when the button is pressed. If you need to know the button's pressed state (and toggle_mode is active), use _toggled() instead.

---

void _toggled(toggled_on: bool) virtual 

Called when the button is toggled (only if toggle_mode is active).

---

DrawMode get_draw_mode() const 

Returns the visual state used to draw the button. This is useful mainly when implementing your own draw code by either overriding _draw() or connecting to "draw" signal. The visual state of the button is defined by the DrawMode enum.

---

bool is_hovered() const 

Returns true if the mouse has entered the button and has not left it yet.

---

void set_pressed_no_signal(pressed: bool) 

Changes the button_pressed state of the button, without emitting toggled. Use when you just want to change the state of the button without sending the pressed event (e.g. when initializing scene). Only works if toggle_mode is true.

Note: This method doesn't unpress other buttons in button_group.
