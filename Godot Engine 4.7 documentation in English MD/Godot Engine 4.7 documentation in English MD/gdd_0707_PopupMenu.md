# PopupMenu

Inherits: Popup < Window < Viewport < Node < Object

A modal window used to display a list of options.

## Description

PopupMenu is a modal window used to display a list of options. Useful for toolbars and context menus.

The size of a PopupMenu can be limited by using Window.max_size. If the height of the list of items is larger than the maximum height of the PopupMenu, a ScrollContainer within the popup will allow the user to scroll the contents. If no maximum size is set, or if it is set to 0, the PopupMenu height will be limited by its parent rect.

All set_* methods allow negative item indices, i.e. -1 to access the last item, -2 to select the second-to-last item, and so on.

Incremental search: Like ItemList and Tree, PopupMenu supports searching within the list while the control is focused. Press a key that matches the first letter of an item's name to select the first item starting with the given letter. After that point, there are two ways to perform incremental search: 1) Press the same key again before the timeout duration to select the next item starting with the same letter. 2) Press letter keys that match the rest of the word before the timeout duration to match to select the item in question directly. Both of these actions will be reset to the beginning of the list if the timeout duration has passed since the last keystroke was registered. You can adjust the timeout duration by changing ProjectSettings.gui/timers/incremental_search_max_interval_msec.

Note: PopupMenu is invisible by default. To make it visible, call one of the popup_* methods from Window on the node, such as Window.popup_centered_clamped().

Note: The ID values used for items are limited to 32 bits, not full 64 bits of int. This has a range of -2^32 to 2^32 - 1, i.e. -2147483648 to 2147483647.

## Properties

bool | allow_search | true
DefaultCanvasItemTextureFilter | canvas_item_default_texture_filter | 4 (overrides Viewport)
DefaultCanvasItemTextureRepeat | canvas_item_default_texture_repeat | 3 (overrides Viewport)
bool | hide_on_checkable_item_selection | true
bool | hide_on_item_selection | true
bool | hide_on_state_item_selection | false
int | item_count | 0
int | item_{index}/checkable | 0
bool | item_{index}/checked | false
bool | item_{index}/disabled | false
Texture2D | item_{index}/icon |
int | item_{index}/id | 0
bool | item_{index}/separator | false
String | item_{index}/text | ""
bool | prefer_native_menu | false
bool | search_bar_enabled | false
bool | search_bar_fuzzy_search_enabled | true
int | search_bar_fuzzy_search_max_misses | 2
int | search_bar_min_item_count | 0
bool | shrink_height | true
bool | shrink_width | true
float | submenu_popup_delay | 0.2
SystemMenus | system_menu_id | 0
bool | transparent | true (overrides Window)
bool | transparent_bg | true (overrides Viewport)

## Methods

bool | activate_item_by_event(event: InputEvent, for_global_only: bool = false)
void | add_check_item(label: String, id: int = -1, accel: Key = 0)
void | add_check_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false)
void | add_icon_check_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0)
void | add_icon_check_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false)
void | add_icon_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0)
void | add_icon_radio_check_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0)
void | add_icon_radio_check_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false)
void | add_icon_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false, allow_echo: bool = false)
void | add_item(label: String, id: int = -1, accel: Key = 0)
void | add_multistate_item(label: String, max_states: int, default_state: int = 0, id: int = -1, accel: Key = 0)
void | add_radio_check_item(label: String, id: int = -1, accel: Key = 0)
void | add_radio_check_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false)
void | add_separator(label: String = "", id: int = -1)
void | add_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false, allow_echo: bool = false)
void | add_submenu_item(label: String, submenu: String, id: int = -1)
void | add_submenu_node_item(label: String, submenu: PopupMenu, id: int = -1)
void | clear(free_submenus: bool = false)
int | get_focused_item() const
Key | get_item_accelerator(index: int) const
AutoTranslateMode | get_item_auto_translate_mode(index: int) const
Texture2D | get_item_icon(index: int) const
int | get_item_icon_max_width(index: int) const
Color | get_item_icon_modulate(index: int) const
int | get_item_id(index: int) const
int | get_item_indent(index: int) const
int | get_item_index(id: int) const
String | get_item_language(index: int) const
Variant | get_item_metadata(index: int) const
int | get_item_multistate(index: int) const
int | get_item_multistate_max(index: int) const
Shortcut | get_item_shortcut(index: int) const
String | get_item_submenu(index: int) const
PopupMenu | get_item_submenu_node(index: int) const
String | get_item_text(index: int) const
TextDirection | get_item_text_direction(index: int) const
String | get_item_tooltip(index: int) const
bool | is_item_checkable(index: int) const
bool | is_item_checked(index: int) const
bool | is_item_disabled(index: int) const
bool | is_item_radio_checkable(index: int) const
bool | is_item_separator(index: int) const
bool | is_item_shortcut_disabled(index: int) const
bool | is_native_menu() const
bool | is_system_menu() const
void | remove_item(index: int)
void | scroll_to_item(index: int)
void | set_focused_item(index: int)
void | set_item_accelerator(index: int, accel: Key)
void | set_item_as_checkable(index: int, enable: bool)
void | set_item_as_radio_checkable(index: int, enable: bool)
void | set_item_as_separator(index: int, enable: bool)
void | set_item_auto_translate_mode(index: int, mode: AutoTranslateMode)
void | set_item_checked(index: int, checked: bool)
void | set_item_disabled(index: int, disabled: bool)
void | set_item_icon(index: int, icon: Texture2D)
void | set_item_icon_max_width(index: int, width: int)
void | set_item_icon_modulate(index: int, modulate: Color)
void | set_item_id(index: int, id: int)
void | set_item_indent(index: int, indent: int)
void | set_item_index(index: int, target_index: int)
void | set_item_language(index: int, language: String)
void | set_item_metadata(index: int, metadata: Variant)
void | set_item_multistate(index: int, state: int)
void | set_item_multistate_max(index: int, max_states: int)
void | set_item_shortcut(index: int, shortcut: Shortcut, global: bool = false)
void | set_item_shortcut_disabled(index: int, disabled: bool)
void | set_item_submenu(index: int, submenu: String)
void | set_item_submenu_node(index: int, submenu: PopupMenu)
void | set_item_text(index: int, text: String)
void | set_item_text_direction(index: int, direction: TextDirection)
void | set_item_tooltip(index: int, tooltip: String)
void | toggle_item_checked(index: int)
void | toggle_item_multistate(index: int)

## Theme Properties

Color | font_accelerator_color | Color(0.7, 0.7, 0.7, 0.8)
Color | font_color | Color(0.875, 0.875, 0.875, 1)
Color | font_disabled_color | Color(0.4, 0.4, 0.4, 0.8)
Color | font_hover_color | Color(0.875, 0.875, 0.875, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_separator_color | Color(0.875, 0.875, 0.875, 1)
Color | font_separator_outline_color | Color(0, 0, 0, 1)
int | gutter_compact | 1
int | h_separation | 4
int | icon_max_width | 0
int | indent | 10
int | item_end_padding | 2
int | item_start_padding | 2
int | outline_size | 0
int | search_bar_separation | 4
int | separator_outline_size | 0
int | v_separation | 4
Font | font |
Font | font_separator |
int | font_separator_size |
int | font_size |
Texture2D | checked |
Texture2D | checked_disabled |
Texture2D | radio_checked |
Texture2D | radio_checked_disabled |
Texture2D | radio_unchecked |
Texture2D | radio_unchecked_disabled |
Texture2D | search |
Texture2D | submenu |
Texture2D | submenu_mirrored |
Texture2D | unchecked |
Texture2D | unchecked_disabled |
StyleBox | hover |
StyleBox | labeled_separator_left |
StyleBox | labeled_separator_right |
StyleBox | panel |
StyleBox | separator |

---

## Signals

id_focused(id: int) 

Emitted when the user navigated to an item of some id using the ProjectSettings.input/ui_up or ProjectSettings.input/ui_down input action.

---

id_pressed(id: int) 

Emitted when an item of some id is pressed. Also emitted when its accelerator is activated on macOS.

Note: If id is negative (either explicitly or due to overflow), this will return the corresponding index instead.

---

index_pressed(index: int) 

Emitted when an item of some index is pressed. Also emitted when its accelerator is activated on macOS.

---

menu_changed() 

Emitted when any item is added, modified or removed.

---

## Property Descriptions

bool allow_search = true 

- void set_allow_search(value: bool)
- bool get_allow_search()

If true, allows navigating PopupMenu with letter keys.

---

bool hide_on_checkable_item_selection = true 

- void set_hide_on_checkable_item_selection(value: bool)
- bool is_hide_on_checkable_item_selection()

If true, hides the PopupMenu when a checkbox or radio button is selected.

---

bool hide_on_item_selection = true 

- void set_hide_on_item_selection(value: bool)
- bool is_hide_on_item_selection()

If true, hides the PopupMenu when an item is selected.

---

bool hide_on_state_item_selection = false 

- void set_hide_on_state_item_selection(value: bool)
- bool is_hide_on_state_item_selection()

If true, hides the PopupMenu when a state item is selected.

---

int item_count = 0 

- void set_item_count(value: int)
- int get_item_count()

The number of items currently in the list.

---

int item_{index}/checkable = 0 

The checkable item type of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

bool item_{index}/checked = false 

If true, the item at index is checked.

Note: index is a value in the 0 .. item_count - 1 range.

---

bool item_{index}/disabled = false 

If true, the item at index is disabled.

Note: index is a value in the 0 .. item_count - 1 range.

---

Texture2D item_{index}/icon 

The icon of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

int item_{index}/id = 0 

The ID of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

bool item_{index}/separator = false 

If true, the item at index is a separator.

Note: index is a value in the 0 .. item_count - 1 range.

---

String item_{index}/text = "" 

The text of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

bool prefer_native_menu = false 

- void set_prefer_native_menu(value: bool)
- bool is_prefer_native_menu()

If true, MenuBar will use native menu when supported.

Note: If PopupMenu is linked to StatusIndicator, MenuBar, or another PopupMenu item it can use native menu regardless of this property, use is_native_menu() to check it.

---

bool search_bar_enabled = false 

- void set_search_bar_enabled(value: bool)
- bool is_search_bar_enabled()

If true, shows a search bar at the top of the PopupMenu for filtering items. See search_bar_min_item_count for dynamically controlling its visibility based on the number of items.

Note: When enabled, allow_search is ignored.

---

bool search_bar_fuzzy_search_enabled = true 

- void set_search_bar_fuzzy_search_enabled(value: bool)
- bool is_search_bar_fuzzy_search_enabled()

If true, enables fuzzy searching in the PopupMenu search bar. This allows the search results to include items that almost match the search query, as well items that match the individual characters of the search query, but not in sequence.

Use search_bar_fuzzy_search_max_misses to set the maximum number of mismatches allowed in the search results.

---

int search_bar_fuzzy_search_max_misses = 2 

- void set_search_bar_fuzzy_search_max_misses(value: int)
- int get_search_bar_fuzzy_search_max_misses()

Sets the maximum number of mismatches allowed in each search result when fuzzy searching is enabled for the PopupMenu search bar. Any item with more mismatches will be hidden from the search results.

---

int search_bar_min_item_count = 0 

- void set_search_bar_min_item_count(value: int)
- int get_search_bar_min_item_count()

Sets the minimum number of items required for the search bar to be visible. search_bar_enabled must be true for this to have any effect. Separator items are not counted.

---

bool shrink_height = true 

- void set_shrink_height(value: bool)
- bool get_shrink_height()

If true, shrinks PopupMenu to minimum height when it's shown.

---

bool shrink_width = true 

- void set_shrink_width(value: bool)
- bool get_shrink_width()

If true, shrinks PopupMenu to minimum width when it's shown.

---

float submenu_popup_delay = 0.2 

- void set_submenu_popup_delay(value: float)
- float get_submenu_popup_delay()

Sets the delay time in seconds for the submenu item to popup on mouse hovering. If the popup menu is added as a child of another (acting as a submenu), it will inherit the delay time of the parent menu item.

Note: If the mouse is exiting a submenu item with an open submenu and enters a different submenu item, the submenu popup delay time is affected by the direction of the mouse movement toward the open submenu. If the mouse is moving toward the submenu, the open submenu will wait approximately 0.5 seconds before closing, which then allows the hovered submenu item to open. This additional delay allows the mouse time to move to the open submenu across other menu items without prematurely closing. If the mouse is not moving toward the open submenu, for example in a downward direction, the open submenu will close immediately.

---

SystemMenus system_menu_id = 0 

- void set_system_menu(value: SystemMenus)
- SystemMenus get_system_menu()

If set to one of the values of SystemMenus, this PopupMenu is bound to the special system menu. Only one PopupMenu can be bound to each special menu at a time.

---

## Method Descriptions

bool activate_item_by_event(event: InputEvent, for_global_only: bool = false) 

Checks the provided event against the PopupMenu's shortcuts and accelerators, and activates the first item with matching events. If for_global_only is true, only shortcuts and accelerators with global set to true will be called.

Returns true if an item was successfully activated.

Note: Certain Controls, such as MenuButton, will call this method automatically.

---

void add_check_item(label: String, id: int = -1, accel: Key = 0) 

Adds a new checkable item with text label.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_check_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false) 

Adds a new checkable item and assigns the specified Shortcut to it. Sets the label of the checkbox to the Shortcut's name.

An id can optionally be provided. If no id is provided, one will be created from the index.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_icon_check_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0) 

Adds a new checkable item with text label and icon texture.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_icon_check_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false) 

Adds a new checkable item and assigns the specified Shortcut and icon texture to it. Sets the label of the checkbox to the Shortcut's name.

An id can optionally be provided. If no id is provided, one will be created from the index.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_icon_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0) 

Adds a new item with text label and icon texture.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

---

void add_icon_radio_check_item(texture: Texture2D, label: String, id: int = -1, accel: Key = 0) 

Same as add_icon_check_item(), but uses a radio check button.

---

void add_icon_radio_check_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false) 

Same as add_icon_check_shortcut(), but uses a radio check button.

---

void add_icon_shortcut(texture: Texture2D, shortcut: Shortcut, id: int = -1, global: bool = false, allow_echo: bool = false) 

Adds a new item and assigns the specified Shortcut and icon texture to it. Sets the label of the checkbox to the Shortcut's name.

An id can optionally be provided. If no id is provided, one will be created from the index.

If allow_echo is true, the shortcut can be activated with echo events.

---

void add_item(label: String, id: int = -1, accel: Key = 0) 

Adds a new item with text label.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

Note: The provided id is used only in id_pressed and id_focused signals. It's not related to the index arguments in e.g. set_item_checked().

---

void add_multistate_item(label: String, max_states: int, default_state: int = 0, id: int = -1, accel: Key = 0) 

Adds a new multistate item with text label.

Contrarily to normal binary items, multistate items can have more than two states, as defined by max_states. The default value is defined by default_state.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

```gdscript
func _ready():
    add_multistate_item("Item", 3, 0)
    index_pressed.connect(func(index: int):
            toggle_item_multistate(index)
            match get_item_multistate(index):
                0:
                    print("First state")
                1:
                    print("Second state")
                2:
                    print("Third state")
        )
```

Note: Multistate items don't update their state automatically and must be done manually. See toggle_item_multistate(), set_item_multistate() and get_item_multistate() for more info on how to control it.

---

void add_radio_check_item(label: String, id: int = -1, accel: Key = 0) 

Adds a new radio check button with text label.

An id can optionally be provided, as well as an accelerator (accel). If no id is provided, one will be created from the index. If no accel is provided, then the default value of 0 (corresponding to @GlobalScope.KEY_NONE) will be assigned to the item (which means it won't have any accelerator). See get_item_accelerator() for more info on accelerators.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_radio_check_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false) 

Adds a new radio check button and assigns a Shortcut to it. Sets the label of the checkbox to the Shortcut's name.

An id can optionally be provided. If no id is provided, one will be created from the index.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually. See set_item_checked() for more info on how to control it.

---

void add_separator(label: String = "", id: int = -1) 

Adds a separator between items. Separators also occupy an index, which you can set by using the id parameter.

A label can optionally be provided, which will appear at the center of the separator.

---

void add_shortcut(shortcut: Shortcut, id: int = -1, global: bool = false, allow_echo: bool = false) 

Adds a Shortcut.

An id can optionally be provided. If no id is provided, one will be created from the index.

If allow_echo is true, the shortcut can be activated with echo events.

---

void add_submenu_item(label: String, submenu: String, id: int = -1) 

Deprecated: Prefer using add_submenu_node_item() instead.

Adds an item that will act as a submenu of the parent PopupMenu node when clicked. The submenu argument must be the name of an existing PopupMenu that has been added as a child to this node. This submenu will be shown when the item is clicked, hovered for long enough, or activated using the ui_select or ui_right input actions.

An id can optionally be provided. If no id is provided, one will be created from the index.

---

void add_submenu_node_item(label: String, submenu: PopupMenu, id: int = -1) 

Adds an item that will act as a submenu of the parent PopupMenu node when clicked. This submenu will be shown when the item is clicked, hovered for long enough, or activated using the ui_select or ui_right input actions.

submenu must be either child of this PopupMenu or has no parent node (in which case it will be automatically added as a child). If the submenu popup has another parent, this method will fail.

An id can optionally be provided. If no id is provided, one will be created from the index.

---

void clear(free_submenus: bool = false) 

Removes all items from the PopupMenu. If free_submenus is true, the submenu nodes are automatically freed.

---

int get_focused_item() const 

Returns the index of the currently focused item. Returns -1 if no item is focused.

---

Key get_item_accelerator(index: int) const 

Returns the accelerator of the item at the given index. An accelerator is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. The return value is an integer which is generally a combination of KeyModifierMasks and Keys using bitwise OR such as KEY_MASK_CTRL | KEY_A (Ctrl + A). If no accelerator is defined for the specified index, get_item_accelerator() returns 0 (corresponding to @GlobalScope.KEY_NONE).

---

AutoTranslateMode get_item_auto_translate_mode(index: int) const 

Returns the auto translate mode of the item at the given index.

---

Texture2D get_item_icon(index: int) const 

Returns the icon of the item at the given index.

---

int get_item_icon_max_width(index: int) const 

Returns the maximum allowed width of the icon for the item at the given index.

---

Color get_item_icon_modulate(index: int) const 

Returns a Color modulating the item's icon at the given index.

---

int get_item_id(index: int) const 

Returns the ID of the item at the given index.

---

int get_item_indent(index: int) const 

Returns the horizontal offset of the item at the given index.

---

int get_item_index(id: int) const 

Returns the index of the item containing the specified id. The index is automatically assigned to each item by the engine when added and represents the order items will be displayed.

---

String get_item_language(index: int) const 

Returns item's text language code.

---

Variant get_item_metadata(index: int) const 

Returns the metadata of the specified item, which might be of any type. You can set it with set_item_metadata(), which provides a simple way of assigning context data to items.

---

int get_item_multistate(index: int) const 

Returns the state of the item at the given index.

---

int get_item_multistate_max(index: int) const 

Returns the max states of the item at the given index.

---

Shortcut get_item_shortcut(index: int) const 

Returns the Shortcut associated with the item at the given index.

---

String get_item_submenu(index: int) const 

Deprecated: Prefer using get_item_submenu_node() instead.

Returns the submenu name of the item at the given index. See add_submenu_item() for more info on how to add a submenu.

---

PopupMenu get_item_submenu_node(index: int) const 

Returns the submenu of the item at the given index, or null if no submenu was added. See add_submenu_node_item() for more info on how to add a submenu.

---

String get_item_text(index: int) const 

Returns the text of the item at the given index.

---

TextDirection get_item_text_direction(index: int) const 

Returns item's text base writing direction.

---

String get_item_tooltip(index: int) const 

Returns the tooltip associated with the item at the given index.

---

bool is_item_checkable(index: int) const 

Returns true if the item at the given index is checkable in some way, i.e. if it has a checkbox or radio button.

Note: Checkable items just display a checkmark or radio button, but don't have any built-in checking behavior and must be checked/unchecked manually.

---

bool is_item_checked(index: int) const 

Returns true if the item at the given index is checked.

---

bool is_item_disabled(index: int) const 

Returns true if the item at the given index is disabled. When it is disabled it can't be selected, or its action invoked.

See set_item_disabled() for more info on how to disable an item.

---

bool is_item_radio_checkable(index: int) const 

Returns true if the item at the given index has radio button-style checkability.

Note: This is purely cosmetic; you must add the logic for checking/unchecking items in radio groups.

---

bool is_item_separator(index: int) const 

Returns true if the item is a separator. If it is, it will be displayed as a line. See add_separator() for more info on how to add a separator.

---

bool is_item_shortcut_disabled(index: int) const 

Returns true if the specified item's shortcut is disabled.

---

bool is_native_menu() const 

Returns true if the system native menu is supported and currently used by this PopupMenu.

---

bool is_system_menu() const 

Returns true if the menu is bound to the special system menu.

---

void remove_item(index: int) 

Removes the item at the given index from the menu.

Note: The indices of items after the removed item will be shifted by one.

---

void scroll_to_item(index: int) 

Moves the scroll view to make the item at the given index visible.

---

void set_focused_item(index: int) 

Sets the currently focused item as the given index.

Passing -1 as the index makes so that no item is focused.

---

void set_item_accelerator(index: int, accel: Key) 

Sets the accelerator of the item at the given index. An accelerator is a keyboard shortcut that can be pressed to trigger the menu button even if it's not currently open. accel is generally a combination of KeyModifierMasks and Keys using bitwise OR such as KEY_MASK_CTRL | KEY_A (Ctrl + A).

---

void set_item_as_checkable(index: int, enable: bool) 

Sets whether the item at the given index has a checkbox. If false, sets the type of the item to plain text.

Note: Checkable items just display a checkmark, but don't have any built-in checking behavior and must be checked/unchecked manually.

---

void set_item_as_radio_checkable(index: int, enable: bool) 

Sets the type of the item at the given index to radio button. If false, sets the type of the item to plain text.

---

void set_item_as_separator(index: int, enable: bool) 

Mark the item at the given index as a separator, which means that it would be displayed as a line. If false, sets the type of the item to plain text.

---

void set_item_auto_translate_mode(index: int, mode: AutoTranslateMode) 

Sets the auto translate mode of the item at the given index.

Items use Node.AUTO_TRANSLATE_MODE_INHERIT by default, which uses the same auto translate mode as the PopupMenu itself.

---

void set_item_checked(index: int, checked: bool) 

Sets the checkstate status of the item at the given index.

---

void set_item_disabled(index: int, disabled: bool) 

Enables/disables the item at the given index. When it is disabled, it can't be selected and its action can't be invoked.

---

void set_item_icon(index: int, icon: Texture2D) 

Replaces the Texture2D icon of the item at the given index.

---

void set_item_icon_max_width(index: int, width: int) 

Sets the maximum allowed width of the icon for the item at the given index. This limit is applied on top of the default size of the icon and on top of icon_max_width. The height is adjusted according to the icon's ratio.

---

void set_item_icon_modulate(index: int, modulate: Color) 

Sets a modulating Color of the item's icon at the given index.

---

void set_item_id(index: int, id: int) 

Sets the id of the item at the given index.

The id is used in id_pressed and id_focused signals.

---

void set_item_indent(index: int, indent: int) 

Sets the horizontal offset of the item at the given index.

---

void set_item_index(index: int, target_index: int) 

Changes the index of the item at index index to be at index target_index. This can be used to move an item above other items. The moved item will keep the same ID, even if it was generated from the original index.

Note: The indices of any items between index index and index target_index will be shifted by one.

---

void set_item_language(index: int, language: String) 

Sets the language code of the text for the item at the given index to language. This is used for line-breaking and text shaping algorithms. If language is empty, the current locale is used.

---

void set_item_metadata(index: int, metadata: Variant) 

Sets the metadata of an item, which may be of any type. You can later get it with get_item_metadata(), which provides a simple way of assigning context data to items.

---

void set_item_multistate(index: int, state: int) 

Sets the state of a multistate item. See add_multistate_item() for details.

---

void set_item_multistate_max(index: int, max_states: int) 

Sets the max states of a multistate item. See add_multistate_item() for details.

---

void set_item_shortcut(index: int, shortcut: Shortcut, global: bool = false) 

Sets a Shortcut for the item at the given index.

---

void set_item_shortcut_disabled(index: int, disabled: bool) 

Disables the Shortcut of the item at the given index.

---

void set_item_submenu(index: int, submenu: String) 

Deprecated: Prefer using set_item_submenu_node() instead.

Sets the submenu of the item at the given index. The submenu is the name of a child PopupMenu node that would be shown when the item is clicked.

---

void set_item_submenu_node(index: int, submenu: PopupMenu) 

Sets the submenu of the item at the given index. The submenu is a PopupMenu node that would be shown when the item is clicked. It must either be a child of this PopupMenu or has no parent (in which case it will be automatically added as a child). If the submenu popup has another parent, this method will fail.

---

void set_item_text(index: int, text: String) 

Sets the text of the item at the given index.

---

void set_item_text_direction(index: int, direction: TextDirection) 

Sets item's text base writing direction.

---

void set_item_tooltip(index: int, tooltip: String) 

Sets the String tooltip of the item at the given index.

---

void toggle_item_checked(index: int) 

Toggles the check state of the item at the given index.

---

void toggle_item_multistate(index: int) 

Cycle to the next state of a multistate item. See add_multistate_item() for details.

---

## Theme Property Descriptions

Color font_accelerator_color = Color(0.7, 0.7, 0.7, 0.8) 

The text Color used for shortcuts and accelerators that show next to the menu item name when defined. See get_item_accelerator() for more info on accelerators.

---

Color font_color = Color(0.875, 0.875, 0.875, 1) 

The default text Color for menu items' names.

---

Color font_disabled_color = Color(0.4, 0.4, 0.4, 0.8) 

Color used for disabled menu items' text.

---

Color font_hover_color = Color(0.875, 0.875, 0.875, 1) 

Color used for the hovered text.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the menu item.

---

Color font_separator_color = Color(0.875, 0.875, 0.875, 1) 

Color used for labeled separators' text. See add_separator().

---

Color font_separator_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the labeled separator.

---

int gutter_compact = 1 

If not 0, the icon gutter will be merged with the checkbox gutter when possible. This acts as a boolean.

---

int h_separation = 4 

The horizontal space between the item's elements.

---

int icon_max_width = 0 

The maximum allowed width of the item's icon. This limit is applied on top of the default size of the icon, but before the value set with set_item_icon_max_width(). The height is adjusted according to the icon's ratio.

---

int indent = 10 

Width of the single indentation level.

---

int item_end_padding = 2 

Horizontal padding to the right of the items (or left, in RTL layout).

---

int item_start_padding = 2 

Horizontal padding to the left of the items (or right, in RTL layout).

---

int outline_size = 0 

The size of the item text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int search_bar_separation = 4 

The vertical space between search bar and menu items.

---

int separator_outline_size = 0 

The size of the labeled separator text outline.

---

int v_separation = 4 

The vertical space between each menu item.

---

Font font 

Font used for the menu items.

---

Font font_separator 

Font used for the labeled separator.

---

int font_separator_size 

Font size of the labeled separator.

---

int font_size 

Font size of the menu items.

---

Texture2D checked 

Texture2D icon for the checked checkbox items.

---

Texture2D checked_disabled 

Texture2D icon for the checked checkbox items when they are disabled.

---

Texture2D radio_checked 

Texture2D icon for the checked radio button items.

---

Texture2D radio_checked_disabled 

Texture2D icon for the checked radio button items when they are disabled.

---

Texture2D radio_unchecked 

Texture2D icon for the unchecked radio button items.

---

Texture2D radio_unchecked_disabled 

Texture2D icon for the unchecked radio button items when they are disabled.

---

Texture2D search 

Texture2D icon for the search bar's search icon.

---

Texture2D submenu 

Texture2D icon for the submenu arrow (for left-to-right layouts).

---

Texture2D submenu_mirrored 

Texture2D icon for the submenu arrow (for right-to-left layouts).

---

Texture2D unchecked 

Texture2D icon for the unchecked checkbox items.

---

Texture2D unchecked_disabled 

Texture2D icon for the unchecked checkbox items when they are disabled.

---

StyleBox hover 

StyleBox displayed when the PopupMenu item is hovered.

---

StyleBox labeled_separator_left 

StyleBox for the left side of labeled separator. See add_separator().

---

StyleBox labeled_separator_right 

StyleBox for the right side of labeled separator. See add_separator().

---

StyleBox panel 

StyleBox for the background panel.

---

StyleBox separator 

StyleBox used for the separators. See add_separator().
