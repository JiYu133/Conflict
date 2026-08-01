# SpinBox

Inherits: Range < Control < CanvasItem < Node < Object

An input field for numbers.

## Description

SpinBox is a numerical input text field. It allows entering integers and floating-point numbers. The SpinBox also has up and down buttons that can be clicked to increase or decrease the value. The value can also be changed by dragging the mouse up or down over the SpinBox's arrows.

Additionally, mathematical expressions can be entered. These are evaluated when the user presses Enter while editing the SpinBox's text field. This uses the Expression class to parse and evaluate the expression. The result of the expression is then set as the value of the SpinBox. Some examples of valid expressions are 5 + 2 * 3, pow(2, 4), and PI + sin(0.5). Expressions are case-sensitive.

Example: Create a SpinBox, disable its context menu and set its text alignment to right.

```
var spin_box = SpinBox.new()
add_child(spin_box)
var line_edit = spin_box.get_line_edit()
line_edit.context_menu_enabled = false
spin_box.horizontal_alignment = LineEdit.HORIZONTAL_ALIGNMENT_RIGHT
```

```
var spinBox = new SpinBox();
AddChild(spinBox);
var lineEdit = spinBox.GetLineEdit();
lineEdit.ContextMenuEnabled = false;
spinBox.AlignHorizontal = LineEdit.HorizontalAlignEnum.Right;
```

See Range class for more options over the SpinBox.

Note: With the SpinBox's context menu disabled, you can right-click the bottom half of the spinbox to set the value to its minimum, while right-clicking the top half sets the value to its maximum.

Note: SpinBox relies on an underlying LineEdit node. To theme a SpinBox's background, add theme items for LineEdit and customize them. The LineEdit has the SpinBoxInnerLineEdit theme variation, so that you can give it a distinct appearance from regular LineEdits.

Note: If you want to implement drag and drop for the underlying LineEdit, you can use Control.set_drag_forwarding() on the node returned by get_line_edit().

## Properties

HorizontalAlignment | alignment | 0
bool | custom_arrow_round | false
float | custom_arrow_step | 0.0
bool | editable | true
String | prefix | ""
bool | select_all_on_focus | false
BitField[SizeFlags] | size_flags_vertical | 1 (overrides Control)
float | step | 1.0 (overrides Range)
String | suffix | ""
bool | update_on_text_changed | false

## Methods

void | apply()
LineEdit | get_line_edit()

## Theme Properties

Color | down_disabled_icon_modulate | Color(0.875, 0.875, 0.875, 0.5)
Color | down_hover_icon_modulate | Color(0.95, 0.95, 0.95, 1)
Color | down_icon_modulate | Color(0.875, 0.875, 0.875, 1)
Color | down_pressed_icon_modulate | Color(0.95, 0.95, 0.95, 1)
Color | up_disabled_icon_modulate | Color(0.875, 0.875, 0.875, 0.5)
Color | up_hover_icon_modulate | Color(0.95, 0.95, 0.95, 1)
Color | up_icon_modulate | Color(0.875, 0.875, 0.875, 1)
Color | up_pressed_icon_modulate | Color(0.95, 0.95, 0.95, 1)
int | buttons_vertical_separation | 0
int | buttons_width | 16
int | field_and_buttons_separation | 2
int | set_min_buttons_width_from_icons | 1
Texture2D | down |
Texture2D | down_disabled |
Texture2D | down_hover |
Texture2D | down_pressed |
Texture2D | up |
Texture2D | up_disabled |
Texture2D | up_hover |
Texture2D | up_pressed |
Texture2D | updown |
StyleBox | down_background |
StyleBox | down_background_disabled |
StyleBox | down_background_hovered |
StyleBox | down_background_pressed |
StyleBox | field_and_buttons_separator |
StyleBox | up_background |
StyleBox | up_background_disabled |
StyleBox | up_background_hovered |
StyleBox | up_background_pressed |
StyleBox | up_down_buttons_separator |

---

## Property Descriptions

HorizontalAlignment alignment = 0 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

Changes the alignment of the underlying LineEdit.

---

bool custom_arrow_round = false 

- void set_custom_arrow_round(value: bool)
- bool is_custom_arrow_rounding()

If true, the value will be rounded to a multiple of custom_arrow_step when interacting with the arrow buttons. Otherwise, increments the value by custom_arrow_step and then rounds it according to Range.step.

---

float custom_arrow_step = 0.0 

- void set_custom_arrow_step(value: float)
- float get_custom_arrow_step()

If not 0, sets the step when interacting with the arrow buttons of the SpinBox.

Note: Range.value will still be rounded to a multiple of Range.step.

---

bool editable = true 

- void set_editable(value: bool)
- bool is_editable()

If true, the SpinBox will be editable. Otherwise, it will be read only.

---

String prefix = "" 

- void set_prefix(value: String)
- String get_prefix()

Adds the specified prefix string before the numerical value of the SpinBox.

---

bool select_all_on_focus = false 

- void set_select_all_on_focus(value: bool)
- bool is_select_all_on_focus()

If true, the SpinBox will select the whole text when the LineEdit gains focus. Clicking the up and down arrows won't trigger this behavior.

---

String suffix = "" 

- void set_suffix(value: String)
- String get_suffix()

Adds the specified suffix string after the numerical value of the SpinBox.

---

bool update_on_text_changed = false 

- void set_update_on_text_changed(value: bool)
- bool get_update_on_text_changed()

Sets the value of the Range for this SpinBox when the LineEdit text is changed instead of submitted. See LineEdit.text_changed and LineEdit.text_submitted.

Note: If set to true, this will interfere with entering mathematical expressions in the SpinBox. The SpinBox will try to evaluate the expression as you type, which means symbols like a trailing + are removed immediately by the expression being evaluated.

---

## Method Descriptions

void apply() 

Applies the current value of this SpinBox. This is equivalent to pressing Enter while editing the LineEdit used by the SpinBox. This will cause LineEdit.text_submitted to be emitted and its currently contained expression to be evaluated.

---

LineEdit get_line_edit() 

Returns the LineEdit instance from this SpinBox. You can use it to access properties and methods of LineEdit.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

## Theme Property Descriptions

Color down_disabled_icon_modulate = Color(0.875, 0.875, 0.875, 0.5) 

Down button icon modulation color, when the button is disabled.

---

Color down_hover_icon_modulate = Color(0.95, 0.95, 0.95, 1) 

Down button icon modulation color, when the button is hovered.

---

Color down_icon_modulate = Color(0.875, 0.875, 0.875, 1) 

Down button icon modulation color.

---

Color down_pressed_icon_modulate = Color(0.95, 0.95, 0.95, 1) 

Down button icon modulation color, when the button is being pressed.

---

Color up_disabled_icon_modulate = Color(0.875, 0.875, 0.875, 0.5) 

Up button icon modulation color, when the button is disabled.

---

Color up_hover_icon_modulate = Color(0.95, 0.95, 0.95, 1) 

Up button icon modulation color, when the button is hovered.

---

Color up_icon_modulate = Color(0.875, 0.875, 0.875, 1) 

Up button icon modulation color.

---

Color up_pressed_icon_modulate = Color(0.95, 0.95, 0.95, 1) 

Up button icon modulation color, when the button is being pressed.

---

int buttons_vertical_separation = 0 

Vertical separation between the up and down buttons.

---

int buttons_width = 16 

Width of the up and down buttons. If smaller than any icon set on the buttons, the respective icon may overlap neighboring elements. If smaller than 0, the width is automatically adjusted from the icon size.

---

int field_and_buttons_separation = 2 

Width of the horizontal separation between the text input field (LineEdit) and the buttons.

---

int set_min_buttons_width_from_icons = 1 

If not 0, the minimum button width corresponds to the widest of all icons set on those buttons, even if buttons_width is smaller.

---

Texture2D down 

Down button icon, displayed in the middle of the down (value-decreasing) button.

---

Texture2D down_disabled 

Down button icon when the button is disabled.

---

Texture2D down_hover 

Down button icon when the button is hovered.

---

Texture2D down_pressed 

Down button icon when the button is being pressed.

---

Texture2D up 

Up button icon, displayed in the middle of the up (value-increasing) button.

---

Texture2D up_disabled 

Up button icon when the button is disabled.

---

Texture2D up_hover 

Up button icon when the button is hovered.

---

Texture2D up_pressed 

Up button icon when the button is being pressed.

---

Texture2D updown 

Single texture representing both the up and down buttons icons. It is displayed in the middle of the buttons and does not change upon interaction. If a valid icon is assigned, it will replace up and down.

---

StyleBox down_background 

Background style of the down button.

---

StyleBox down_background_disabled 

Background style of the down button when disabled.

---

StyleBox down_background_hovered 

Background style of the down button when hovered.

---

StyleBox down_background_pressed 

Background style of the down button when being pressed.

---

StyleBox field_and_buttons_separator 

StyleBox drawn in the space occupied by the separation between the input field and the buttons.

---

StyleBox up_background 

Background style of the up button.

---

StyleBox up_background_disabled 

Background style of the up button when disabled.

---

StyleBox up_background_hovered 

Background style of the up button when hovered.

---

StyleBox up_background_pressed 

Background style of the up button when being pressed.

---

StyleBox up_down_buttons_separator 

StyleBox drawn in the space occupied by the separation between the up and down buttons.
