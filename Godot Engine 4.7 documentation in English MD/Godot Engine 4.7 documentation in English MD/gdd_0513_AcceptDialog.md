# AcceptDialog

Inherits: Window < Viewport < Node < Object

Inherited By: ConfirmationDialog

A base dialog used for user notification.

## Description

The default use of AcceptDialog is to allow it to only be accepted or closed, with the same result. However, the confirmed and canceled signals allow to make the two actions different, and the add_button() method allows to add custom buttons and actions.

Note: AcceptDialog is invisible by default. To make it visible, call one of the popup_* methods from Window on the node, such as Window.popup_centered_clamped().

## Properties

bool | dialog_autowrap | false
bool | dialog_close_on_escape | true
bool | dialog_hide_on_ok | true
String | dialog_text | ""
bool | exclusive | true (overrides Window)
bool | keep_title_visible | true (overrides Window)
bool | maximize_disabled | true (overrides Window)
bool | minimize_disabled | true (overrides Window)
String | ok_button_text | ""
String | title | "Alert!" (overrides Window)
bool | transient | true (overrides Window)
bool | visible | false (overrides Window)
bool | wrap_controls | true (overrides Window)

## Methods

Button | add_button(text: String, right: bool = false, action: String = "")
Button | add_cancel_button(name: String)
Label | get_label()
Button | get_ok_button()
void | register_text_enter(line_edit: LineEdit)
void | remove_button(button: Button)

## Theme Properties

int | buttons_min_height | 0
int | buttons_min_width | 0
int | buttons_separation | 10
StyleBox | panel |

---

## Signals

canceled() 

Emitted when the dialog is closed or the button created with add_cancel_button() is pressed.

---

confirmed() 

Emitted when the dialog is accepted, i.e. the OK button is pressed.

---

custom_action(action: StringName) 

Emitted when a custom button with an action is pressed. See add_button().

---

## Property Descriptions

bool dialog_autowrap = false 

- void set_autowrap(value: bool)
- bool has_autowrap()

Sets autowrapping for the text in the dialog.

---

bool dialog_close_on_escape = true 

- void set_close_on_escape(value: bool)
- bool get_close_on_escape()

If true, the dialog will be hidden when the ui_close_dialog action is pressed (by default, this action is bound to Escape, or Cmd + W on macOS).

---

bool dialog_hide_on_ok = true 

- void set_hide_on_ok(value: bool)
- bool get_hide_on_ok()

If true, the dialog is hidden when the OK button is pressed. You can set it to false if you want to do e.g. input validation when receiving the confirmed signal, and handle hiding the dialog in your own logic.

Note: Some nodes derived from this class can have a different default value, and potentially their own built-in logic overriding this setting. For example FileDialog defaults to false, and has its own input validation code that is called when you press OK, which eventually hides the dialog if the input is valid. As such, this property can't be used in FileDialog to disable hiding the dialog when pressing OK.

---

String dialog_text = "" 

- void set_text(value: String)
- String get_text()

The text displayed by the dialog.

---

String ok_button_text = "" 

- void set_ok_button_text(value: String)
- String get_ok_button_text()

The text displayed by the OK button (see get_ok_button()). If empty, a default text will be used.

---

## Method Descriptions

Button add_button(text: String, right: bool = false, action: String = "") 

Adds a button with label text and a custom action to the dialog and returns the created button.

If action is not empty, pressing the button will emit the custom_action signal with the specified action string.

If true, right will place the button to the right of any sibling buttons.

You can use remove_button() method to remove a button created with this method from the dialog.

---

Button add_cancel_button(name: String) 

Adds a button with label name and a cancel action to the dialog and returns the created button.

You can use remove_button() method to remove a button created with this method from the dialog.

---

Label get_label() 

Returns the label used for built-in text.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

Button get_ok_button() 

Returns the OK Button instance.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

void register_text_enter(line_edit: LineEdit) 

Registers a LineEdit in the dialog. When the enter key is pressed, the dialog will be accepted.

---

void remove_button(button: Button) 

Removes the button from the dialog. Does NOT free the button. The button must be a Button added with add_button() or add_cancel_button() method. After removal, pressing the button will no longer emit this dialog's custom_action or canceled signals.

---

## Theme Property Descriptions

int buttons_min_height = 0 

The minimum height of each button in the bottom row (such as OK/Cancel) in pixels. This can be increased to make buttons with short texts easier to click/tap.

---

int buttons_min_width = 0 

The minimum width of each button in the bottom row (such as OK/Cancel) in pixels. This can be increased to make buttons with short texts easier to click/tap.

---

int buttons_separation = 10 

The size of the vertical space between the dialog's content and the button row.

---

StyleBox panel 

The panel that fills the background of the window.
