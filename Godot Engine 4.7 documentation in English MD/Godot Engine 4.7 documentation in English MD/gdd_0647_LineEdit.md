# LineEdit

Inherits: Control < CanvasItem < Node < Object

An input field for single-line text.

## Description

LineEdit provides an input field for editing a single line of text.

- When the LineEdit control is focused using the keyboard arrow keys, it will only gain focus and not enter edit mode.
- To enter edit mode, click on the control with the mouse, see also keep_editing_on_text_submit.
- To exit edit mode, press ui_text_submit or ui_cancel (by default Escape) actions.
- Check edit(), unedit(), is_editing(), and editing_toggled for more information.

While entering text, it is possible to insert special characters using Unicode, OEM or Windows alt codes:

- To enter Unicode codepoints, hold Alt and type the codepoint on the numpad. For example, to enter the character á (U+00E1), hold Alt and type +E1 on the numpad (the leading zeroes can be omitted).
- To enter OEM codepoints, hold Alt and type the code on the numpad. For example, to enter the character á (OEM 160), hold Alt and type 160 on the numpad.
- To enter Windows codepoints, hold Alt and type the code on the numpad. For example, to enter the character á (Windows 0225), hold Alt and type 0, 2, 2, 5 on the numpad. The leading zero here must not be omitted, as this is how Windows codepoints are distinguished from OEM codepoints.

Important:

- Focusing the LineEdit with ui_focus_next (by default Tab) or ui_focus_prev (by default Shift + Tab) or Control.grab_focus() still enters edit mode (for compatibility).

LineEdit features many built-in shortcuts that are always available (Ctrl here maps to Cmd on macOS):

- Ctrl + C: Copy
- Ctrl + X: Cut
- Ctrl + V or Ctrl + Y: Paste/"yank"
- Ctrl + Z: Undo
- Ctrl + ~: Swap input direction.
- Ctrl + Shift + Z: Redo
- Ctrl + U: Delete text from the caret position to the beginning of the line
- Ctrl + K: Delete text from the caret position to the end of the line
- Ctrl + A: Select all text
- Up Arrow/Down Arrow: Move the caret to the beginning/end of the line

On macOS, some extra keyboard shortcuts are available:

- Cmd + F: Same as Right Arrow, move the caret one character right
- Cmd + B: Same as Left Arrow, move the caret one character left
- Cmd + P: Same as Up Arrow, move the caret to the previous line
- Cmd + N: Same as Down Arrow, move the caret to the next line
- Cmd + D: Same as Delete, delete the character on the right side of caret
- Cmd + H: Same as Backspace, delete the character on the left side of the caret
- Cmd + A: Same as Home, move the caret to the beginning of the line
- Cmd + E: Same as End, move the caret to the end of the line
- Cmd + Left Arrow: Same as Home, move the caret to the beginning of the line
- Cmd + Right Arrow: Same as End, move the caret to the end of the line

Note: Caret movement shortcuts listed above are not affected by shortcut_keys_enabled.

## Properties

HorizontalAlignment | alignment | 0
bool | backspace_deletes_composite_character_enabled | false
bool | caret_blink | false
float | caret_blink_interval | 0.65
int | caret_column | 0
bool | caret_force_displayed | false
bool | caret_mid_grapheme | false
bool | clear_button_enabled | false
bool | context_menu_enabled | true
bool | deselect_on_focus_loss_enabled | true
bool | drag_and_drop_selection_enabled | true
bool | draw_control_chars | false
bool | editable | true
bool | emoji_menu_enabled | true
bool | expand_to_text_length | false
bool | flat | false
FocusMode | focus_mode | 2 (overrides Control)
ExpandMode | icon_expand_mode | 0
bool | keep_editing_on_text_submit | false
String | language | ""
int | max_length | 0
bool | middle_mouse_paste_enabled | true
CursorShape | mouse_default_cursor_shape | 1 (overrides Control)
String | placeholder_text | ""
Texture2D | right_icon |
float | right_icon_scale | 1.0
bool | secret | false
String | secret_character | "•"
bool | select_all_on_focus | false
bool | selecting_enabled | true
bool | shortcut_keys_enabled | true
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
String | text | ""
TextDirection | text_direction | 0
bool | virtual_keyboard_enabled | true
bool | virtual_keyboard_show_on_focus | true
VirtualKeyboardType | virtual_keyboard_type | 0

## Methods

void | apply_ime()
void | cancel_ime()
void | clear()
void | delete_char_at_caret()
void | delete_text(from_column: int, to_column: int)
void | deselect()
void | edit(hide_focus: bool = false)
PopupMenu | get_menu() const
int | get_next_composite_character_column(column: int) const
int | get_previous_composite_character_column(column: int) const
float | get_scroll_offset() const
String | get_selected_text()
int | get_selection_from_column() const
int | get_selection_to_column() const
bool | has_ime_text() const
bool | has_redo() const
bool | has_selection() const
bool | has_undo() const
void | insert_text_at_caret(text: String)
bool | is_editing() const
bool | is_menu_visible() const
void | menu_option(option: int)
void | select(from: int = 0, to: int = -1)
void | select_all()
void | unedit()

## Theme Properties

Color | caret_color | Color(0.95, 0.95, 0.95, 1)
Color | clear_button_color | Color(0.875, 0.875, 0.875, 1)
Color | clear_button_color_pressed | Color(1, 1, 1, 1)
Color | font_color | Color(0.875, 0.875, 0.875, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_placeholder_color | Color(0.875, 0.875, 0.875, 0.6)
Color | font_selected_color | Color(1, 1, 1, 1)
Color | font_uneditable_color | Color(0.875, 0.875, 0.875, 0.5)
Color | selection_color | Color(0.5, 0.5, 0.5, 1)
int | caret_width | 1
int | minimum_character_width | 4
int | outline_size | 0
Font | font |
int | font_size |
Texture2D | clear |
StyleBox | focus |
StyleBox | normal |
StyleBox | read_only |

---

## Signals

editing_toggled(toggled_on: bool) 

Emitted when the LineEdit switches in or out of edit mode.

---

text_change_rejected(rejected_substring: String) 

Emitted when appending text that overflows the max_length. The appended text is truncated to fit max_length, and the part that couldn't fit is passed as the rejected_substring argument.

---

text_changed(new_text: String) 

Emitted when the text changes.

---

text_submitted(new_text: String) 

Emitted when the user presses the ui_text_submit action (by default: Enter or Kp Enter) while the LineEdit has focus.

---

## Enumerations

enum MenuItems
MenuItems MENU_CUT = 0

Cuts (copies and clears) the selected text.

MenuItems MENU_COPY = 1

Copies the selected text.

MenuItems MENU_PASTE = 2

Pastes the clipboard text over the selected text (or at the caret's position).

Non-printable escape characters are automatically stripped from the OS clipboard via String.strip_escapes().

MenuItems MENU_CLEAR = 3

Erases the whole LineEdit text.

MenuItems MENU_SELECT_ALL = 4

Selects the whole LineEdit text.

MenuItems MENU_UNDO = 5

Undoes the previous action.

MenuItems MENU_REDO = 6

Reverse the last undo action.

MenuItems MENU_SUBMENU_TEXT_DIR = 7

ID of "Text Writing Direction" submenu.

MenuItems MENU_DIR_INHERITED = 8

Sets text direction to inherited.

MenuItems MENU_DIR_AUTO = 9

Sets text direction to automatic.

MenuItems MENU_DIR_LTR = 10

Sets text direction to left-to-right.

MenuItems MENU_DIR_RTL = 11

Sets text direction to right-to-left.

MenuItems MENU_DISPLAY_UCC = 12

Toggles control character display.

MenuItems MENU_SUBMENU_INSERT_UCC = 13

ID of "Insert Control Character" submenu.

MenuItems MENU_INSERT_LRM = 14

Inserts left-to-right mark (LRM) character.

MenuItems MENU_INSERT_RLM = 15

Inserts right-to-left mark (RLM) character.

MenuItems MENU_INSERT_LRE = 16

Inserts start of left-to-right embedding (LRE) character.

MenuItems MENU_INSERT_RLE = 17

Inserts start of right-to-left embedding (RLE) character.

MenuItems MENU_INSERT_LRO = 18

Inserts start of left-to-right override (LRO) character.

MenuItems MENU_INSERT_RLO = 19

Inserts start of right-to-left override (RLO) character.

MenuItems MENU_INSERT_PDF = 20

Inserts pop direction formatting (PDF) character.

MenuItems MENU_INSERT_ALM = 21

Inserts Arabic letter mark (ALM) character.

MenuItems MENU_INSERT_LRI = 22

Inserts left-to-right isolate (LRI) character.

MenuItems MENU_INSERT_RLI = 23

Inserts right-to-left isolate (RLI) character.

MenuItems MENU_INSERT_FSI = 24

Inserts first strong isolate (FSI) character.

MenuItems MENU_INSERT_PDI = 25

Inserts pop direction isolate (PDI) character.

MenuItems MENU_INSERT_ZWJ = 26

Inserts zero width joiner (ZWJ) character.

MenuItems MENU_INSERT_ZWNJ = 27

Inserts zero width non-joiner (ZWNJ) character.

MenuItems MENU_INSERT_WJ = 28

Inserts word joiner (WJ) character.

MenuItems MENU_INSERT_SHY = 29

Inserts soft hyphen (SHY) character.

MenuItems MENU_EMOJI_AND_SYMBOL = 30

Opens system emoji and symbol picker.

MenuItems MENU_MAX = 31

Represents the size of the MenuItems enum.

---

enum VirtualKeyboardType
VirtualKeyboardType KEYBOARD_TYPE_DEFAULT = 0

Default text virtual keyboard.

VirtualKeyboardType KEYBOARD_TYPE_MULTILINE = 1

Multiline virtual keyboard.

VirtualKeyboardType KEYBOARD_TYPE_NUMBER = 2

Virtual number keypad, useful for PIN entry.

VirtualKeyboardType KEYBOARD_TYPE_NUMBER_DECIMAL = 3

Virtual number keypad, useful for entering fractional numbers.

VirtualKeyboardType KEYBOARD_TYPE_PHONE = 4

Virtual phone number keypad.

VirtualKeyboardType KEYBOARD_TYPE_EMAIL_ADDRESS = 5

Virtual keyboard with additional keys to assist with typing email addresses.

VirtualKeyboardType KEYBOARD_TYPE_PASSWORD = 6

Virtual keyboard for entering a password. On most platforms, this should disable autocomplete and autocapitalization.

Note: This is not supported on Web. Instead, this behaves identically to KEYBOARD_TYPE_DEFAULT.

VirtualKeyboardType KEYBOARD_TYPE_URL = 7

Virtual keyboard with additional keys to assist with typing URLs.

---

enum ExpandMode
ExpandMode EXPAND_MODE_ORIGINAL_SIZE = 0

Use the original size for the right icon.

ExpandMode EXPAND_MODE_FIT_TO_TEXT = 1

Scale the right icon's size to match the size of the text.

ExpandMode EXPAND_MODE_FIT_TO_LINE_EDIT = 2

Scale the right icon to fit the LineEdit.

---

## Property Descriptions

HorizontalAlignment alignment = 0 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

The text's horizontal alignment.

---

bool backspace_deletes_composite_character_enabled = false 

- void set_backspace_deletes_composite_character_enabled(value: bool)
- bool is_backspace_deletes_composite_character_enabled()

If true and caret_mid_grapheme is false, backspace deletes an entire composite character such as ❤️‍🩹, instead of deleting part of the composite character.

---

bool caret_blink = false 

- void set_caret_blink_enabled(value: bool)
- bool is_caret_blink_enabled()

If true, makes the caret blink.

---

float caret_blink_interval = 0.65 

- void set_caret_blink_interval(value: float)
- float get_caret_blink_interval()

The interval at which the caret blinks (in seconds).

---

int caret_column = 0 

- void set_caret_column(value: int)
- int get_caret_column()

The caret's column position inside the LineEdit. When set, the text may scroll to accommodate it.

---

bool caret_force_displayed = false 

- void set_caret_force_displayed(value: bool)
- bool is_caret_force_displayed()

If true, the LineEdit will always show the caret, even if not editing or focus is lost.

---

bool caret_mid_grapheme = false 

- void set_caret_mid_grapheme_enabled(value: bool)
- bool is_caret_mid_grapheme_enabled()

Allow moving caret, selecting and removing the individual composite character components.

Note: Backspace is always removing individual composite character components.

---

bool clear_button_enabled = false 

- void set_clear_button_enabled(value: bool)
- bool is_clear_button_enabled()

If true, the LineEdit will show a clear button if text is not empty, which can be used to clear the text quickly.

---

bool context_menu_enabled = true 

- void set_context_menu_enabled(value: bool)
- bool is_context_menu_enabled()

If true, the context menu will appear when right-clicked.

---

bool deselect_on_focus_loss_enabled = true 

- void set_deselect_on_focus_loss_enabled(value: bool)
- bool is_deselect_on_focus_loss_enabled()

If true, the selected text will be deselected when focus is lost.

---

bool drag_and_drop_selection_enabled = true 

- void set_drag_and_drop_selection_enabled(value: bool)
- bool is_drag_and_drop_selection_enabled()

If true, allow drag and drop of selected text.

---

bool draw_control_chars = false 

- void set_draw_control_chars(value: bool)
- bool get_draw_control_chars()

If true, control characters are displayed.

---

bool editable = true 

- void set_editable(value: bool)
- bool is_editable()

If false, existing text cannot be modified and new text cannot be added.

---

bool emoji_menu_enabled = true 

- void set_emoji_menu_enabled(value: bool)
- bool is_emoji_menu_enabled()

If true, "Emoji and Symbols" menu is enabled.

---

bool expand_to_text_length = false 

- void set_expand_to_text_length_enabled(value: bool)
- bool is_expand_to_text_length_enabled()

If true, the LineEdit width will increase to stay longer than the text. It will not compress if the text is shortened.

---

bool flat = false 

- void set_flat(value: bool)
- bool is_flat()

If true, the LineEdit doesn't display decoration.

---

ExpandMode icon_expand_mode = 0 

- void set_icon_expand_mode(value: ExpandMode)
- ExpandMode get_icon_expand_mode()

Define the scaling behavior of the right_icon.

---

bool keep_editing_on_text_submit = false 

- void set_keep_editing_on_text_submit(value: bool)
- bool is_editing_kept_on_text_submit()

If true, the LineEdit will not exit edit mode when text is submitted by pressing ui_text_submit action (by default: Enter or Kp Enter).

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

int max_length = 0 

- void set_max_length(value: int)
- int get_max_length()

Maximum number of characters that can be entered inside the LineEdit. If 0, there is no limit.

When a limit is defined, characters that would exceed max_length are truncated. This happens both for existing text contents when setting the max length, or for new text inserted in the LineEdit, including pasting.

If any input text is truncated, the text_change_rejected signal is emitted with the truncated substring as a parameter:

```
text = "Hello world"
max_length = 5
# `text` becomes "Hello".
max_length = 10
text += " goodbye"
# `text` becomes "Hello good".
# `text_change_rejected` is emitted with "bye" as a parameter.
```

```
Text = "Hello world";
MaxLength = 5;
// `Text` becomes "Hello".
MaxLength = 10;
Text += " goodbye";
// `Text` becomes "Hello good".
// `text_change_rejected` is emitted with "bye" as a parameter.
```

---

bool middle_mouse_paste_enabled = true 

- void set_middle_mouse_paste_enabled(value: bool)
- bool is_middle_mouse_paste_enabled()

If false, using middle mouse button to paste clipboard will be disabled.

Note: This method is only implemented on Linux.

---

String placeholder_text = "" 

- void set_placeholder(value: String)
- String get_placeholder()

Text shown when the LineEdit is empty. It is not the LineEdit's default value (see text).

---

Texture2D right_icon 

- void set_right_icon(value: Texture2D)
- Texture2D get_right_icon()

Sets the icon that will appear in the right end of the LineEdit if there's no text, or always, if clear_button_enabled is set to false.

---

float right_icon_scale = 1.0 

- void set_right_icon_scale(value: float)
- float get_right_icon_scale()

Scale ratio of the icon when icon_expand_mode is set to EXPAND_MODE_FIT_TO_LINE_EDIT.

---

bool secret = false 

- void set_secret(value: bool)
- bool is_secret()

If true, every character is replaced with the secret character (see secret_character).

---

String secret_character = "•" 

- void set_secret_character(value: String)
- String get_secret_character()

The character to use to mask secret input. Only a single character can be used as the secret character. If it is longer than one character, only the first one will be used. If it is empty, a space will be used instead.

---

bool select_all_on_focus = false 

- void set_select_all_on_focus(value: bool)
- bool is_select_all_on_focus()

If true, the LineEdit will select the whole text when it gains focus.

---

bool selecting_enabled = true 

- void set_selecting_enabled(value: bool)
- bool is_selecting_enabled()

If false, it's impossible to select the text using mouse nor keyboard.

---

bool shortcut_keys_enabled = true 

- void set_shortcut_keys_enabled(value: bool)
- bool is_shortcut_keys_enabled()

If true, shortcut keys for context menu items are enabled, even if the context menu is disabled.

---

StructuredTextParser structured_text_bidi_override = 0 

- void set_structured_text_bidi_override(value: StructuredTextParser)
- StructuredTextParser get_structured_text_bidi_override()

Set BiDi algorithm override for the structured text.

---

Array structured_text_bidi_override_options = [] 

- void set_structured_text_bidi_override_options(value: Array)
- Array get_structured_text_bidi_override_options()

Set additional options for BiDi override.

---

String text = "" 

- void set_text(value: String)
- String get_text()

String value of the LineEdit.

Note: Changing text using this property won't emit the text_changed signal.

---

TextDirection text_direction = 0 

- void set_text_direction(value: TextDirection)
- TextDirection get_text_direction()

Base text writing direction.

---

bool virtual_keyboard_enabled = true 

- void set_virtual_keyboard_enabled(value: bool)
- bool is_virtual_keyboard_enabled()

If true, the native virtual keyboard is enabled on platforms that support it.

---

bool virtual_keyboard_show_on_focus = true 

- void set_virtual_keyboard_show_on_focus(value: bool)
- bool get_virtual_keyboard_show_on_focus()

If true, the native virtual keyboard is shown on focus events on platforms that support it.

---

VirtualKeyboardType virtual_keyboard_type = 0 

- void set_virtual_keyboard_type(value: VirtualKeyboardType)
- VirtualKeyboardType get_virtual_keyboard_type()

Specifies the type of virtual keyboard to show.

---

## Method Descriptions

void apply_ime() 

Applies text from the Input Method Editor [https://en.wikipedia.org/wiki/Input_method] (IME) and closes the IME if it is open.

---

void cancel_ime() 

Closes the Input Method Editor [https://en.wikipedia.org/wiki/Input_method] (IME) if it is open. Any text in the IME will be lost.

---

void clear() 

Erases the LineEdit's text.

---

void delete_char_at_caret() 

Deletes one character at the caret's current position (equivalent to pressing Delete).

---

void delete_text(from_column: int, to_column: int) 

Deletes a section of the text going from position from_column to to_column. Both parameters should be within the text's length.

---

void deselect() 

Clears the current selection.

---

void edit(hide_focus: bool = false) 

Allows entering edit mode whether the LineEdit is focused or not. If hide_focus is true, the focused state will not be shown (see Control.grab_focus()).

See also keep_editing_on_text_submit.

---

PopupMenu get_menu() const 

Returns the PopupMenu of this LineEdit. By default, this menu is displayed when right-clicking on the LineEdit.

You can add custom menu items or remove standard ones. Make sure your IDs don't conflict with the standard ones (see MenuItems). For example:

```
func _ready():
    var menu = get_menu()
    # Remove all items after "Redo".
    menu.item_count = menu.get_item_index(MENU_REDO) + 1
    # Add custom items.
    menu.add_separator()
    menu.add_item("Insert Date", MENU_MAX + 1)
    # Connect callback.
    menu.id_pressed.connect(_on_item_pressed)
func _on_item_pressed(id):
    if id == MENU_MAX + 1:
        insert_text_at_caret(Time.get_date_string_from_system())
```

```
public override void _Ready()
{
    var menu = GetMenu();
    // Remove all items after "Redo".
    menu.ItemCount = menu.GetItemIndex(LineEdit.MenuItems.Redo) + 1;
    // Add custom items.
    menu.AddSeparator();
    menu.AddItem("Insert Date", LineEdit.MenuItems.Max + 1);
    // Add event handler.
    menu.IdPressed += OnItemPressed;
}
public void OnItemPressed(int id)
{
    if (id == LineEdit.MenuItems.Max + 1)
    {
        InsertTextAtCaret(Time.GetDateStringFromSystem());
    }
}
```

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their Window.visible property.

---

int get_next_composite_character_column(column: int) const 

Returns the correct column at the end of a composite character like ❤️‍🩹 (mending heart; Unicode: U+2764 U+FE0F U+200D U+1FA79) which is comprised of more than one Unicode code point, if the caret is at the start of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.

Note: To check at caret location use get_next_composite_character_column(get_caret_column())

---

int get_previous_composite_character_column(column: int) const 

Returns the correct column at the start of a composite character like ❤️‍🩹 (mending heart; Unicode: U+2764 U+FE0F U+200D U+1FA79) which is comprised of more than one Unicode code point, if the caret is at the end of the composite character. Also returns the correct column with the caret at mid grapheme and for non-composite characters.

Note: To check at caret location use get_previous_composite_character_column(get_caret_column())

---

float get_scroll_offset() const 

Returns the scroll offset due to caret_column, as a number of characters.

---

String get_selected_text() 

Returns the text inside the selection.

---

int get_selection_from_column() const 

Returns the selection begin column.

---

int get_selection_to_column() const 

Returns the selection end column.

---

bool has_ime_text() const 

Returns true if the user has text in the Input Method Editor [https://en.wikipedia.org/wiki/Input_method] (IME).

---

bool has_redo() const 

Returns true if a "redo" action is available.

---

bool has_selection() const 

Returns true if the user has selected text.

---

bool has_undo() const 

Returns true if an "undo" action is available.

---

void insert_text_at_caret(text: String) 

Inserts text at the caret. If the resulting value is longer than max_length, nothing happens.

---

bool is_editing() const 

Returns whether the LineEdit is being edited.

---

bool is_menu_visible() const 

Returns whether the menu is visible. Use this instead of get_menu().visible to improve performance (so the creation of the menu is avoided).

---

void menu_option(option: int) 

Executes a given action as defined in the MenuItems enum.

---

void select(from: int = 0, to: int = -1) 

Selects characters inside LineEdit between from and to. By default, from is at the beginning and to at the end.

```
text = "Welcome"
select() # Will select "Welcome".
select(4) # Will select "ome".
select(2, 5) # Will select "lco".
```

```
Text = "Welcome";
Select(); // Will select "Welcome".
Select(4); // Will select "ome".
Select(2, 5); // Will select "lco".
```

---

void select_all() 

Selects the whole String.

---

void unedit() 

Allows exiting edit mode while preserving focus.

---

## Theme Property Descriptions

Color caret_color = Color(0.95, 0.95, 0.95, 1) 

Color of the LineEdit's caret (text cursor). This can be set to a fully transparent color to hide the caret entirely.

---

Color clear_button_color = Color(0.875, 0.875, 0.875, 1) 

Color used as default tint for the clear button.

---

Color clear_button_color_pressed = Color(1, 1, 1, 1) 

Color used for the clear button when it's pressed.

---

Color font_color = Color(0.875, 0.875, 0.875, 1) 

Default font color.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the LineEdit.

---

Color font_placeholder_color = Color(0.875, 0.875, 0.875, 0.6) 

Font color for placeholder_text.

---

Color font_selected_color = Color(1, 1, 1, 1) 

Font color for selected text (inside the selection rectangle).

---

Color font_uneditable_color = Color(0.875, 0.875, 0.875, 0.5) 

Font color when editing is disabled.

---

Color selection_color = Color(0.5, 0.5, 0.5, 1) 

Color of the selection rectangle.

---

int caret_width = 1 

The caret's width in pixels. Greater values can be used to improve accessibility by ensuring the caret is easily visible, or to ensure consistency with a large font size.

---

int minimum_character_width = 4 

Minimum horizontal space for the text (not counting the clear button and content margins). This value is measured in count of 'M' characters (i.e. this number of 'M' characters can be displayed without scrolling).

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

Font font 

Font used for the text.

---

int font_size 

Font size of the LineEdit's text.

---

Texture2D clear 

Texture for the clear button. See clear_button_enabled.

---

StyleBox focus 

Background used when LineEdit has GUI focus. The focus StyleBox is displayed over the base StyleBox, so a partially transparent StyleBox should be used to ensure the base StyleBox remains visible. A StyleBox that represents an outline or an underline works well for this purpose. To disable the focus visual effect, assign a StyleBoxEmpty resource. Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.

---

StyleBox normal 

Default background for the LineEdit.

---

StyleBox read_only 

Background used when LineEdit is in read-only mode (editable is set to false).
