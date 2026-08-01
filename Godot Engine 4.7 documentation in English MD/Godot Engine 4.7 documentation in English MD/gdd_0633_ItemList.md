# ItemList

Inherits: Control < CanvasItem < Node < Object

A vertical list of selectable items with one or multiple columns.

## Description

This control provides a vertical list of selectable items that may be in a single or in multiple columns, with each item having options for text and an icon. Tooltips are supported and may be different for every item in the list.

Selectable items in the list may be selected or deselected and multiple selection may be enabled. Selection with right mouse button may also be enabled to allow use of popup context menus. Items may also be "activated" by double-clicking them or by pressing Enter.

Item text only supports single-line strings. Newline characters (e.g. \n) in the string won't produce a newline. Text wrapping is enabled in ICON_MODE_TOP mode, but the column's width is adjusted to fully fit its content by default. You need to set fixed_column_width greater than zero to wrap the text.

All set_* methods allow negative item indices, i.e. -1 to access the last item, -2 to select the second-to-last item, and so on.

Incremental search: Like PopupMenu and Tree, ItemList supports searching within the list while the control is focused. Press a key that matches the first letter of an item's name to select the first item starting with the given letter. After that point, there are two ways to perform incremental search: 1) Press the same key again before the timeout duration to select the next item starting with the same letter. 2) Press letter keys that match the rest of the word before the timeout duration to match to select the item in question directly. Both of these actions will be reset to the beginning of the list if the timeout duration has passed since the last keystroke was registered. You can adjust the timeout duration by changing ProjectSettings.gui/timers/incremental_search_max_interval_msec.

## Properties

bool | allow_reselect | false
bool | allow_rmb_select | false
bool | allow_search | true
bool | auto_height | false
bool | auto_width | false
bool | clip_contents | true (overrides Control)
int | fixed_column_width | 0
Vector2i | fixed_icon_size | Vector2i(0, 0)
FocusMode | focus_mode | 2 (overrides Control)
IconMode | icon_mode | 1
float | icon_scale | 1.0
int | item_count | 0
bool | item_{index}/disabled | false
Texture2D | item_{index}/icon |
bool | item_{index}/selectable | true
String | item_{index}/text | ""
int | max_columns | 1
int | max_text_lines | 1
bool | same_column_width | false
ScrollHintMode | scroll_hint_mode | 0
SelectMode | select_mode | 0
OverrunBehavior | text_overrun_behavior | 3
bool | tile_scroll_hint | false
bool | wraparound_items | true

## Methods

int | add_icon_item(icon: Texture2D, selectable: bool = true)
int | add_item(text: String, icon: Texture2D = null, selectable: bool = true)
void | center_on_current(center_verically: bool = true, center_horizontally: bool = true)
void | clear()
void | deselect(idx: int)
void | deselect_all()
void | ensure_current_is_visible()
void | force_update_list_size()
HScrollBar | get_h_scroll_bar()
int | get_item_at_position(position: Vector2, exact: bool = false) const
AutoTranslateMode | get_item_auto_translate_mode(idx: int) const
Color | get_item_custom_bg_color(idx: int) const
Color | get_item_custom_fg_color(idx: int) const
Texture2D | get_item_icon(idx: int) const
Color | get_item_icon_modulate(idx: int) const
Rect2 | get_item_icon_region(idx: int) const
String | get_item_language(idx: int) const
Variant | get_item_metadata(idx: int) const
Rect2 | get_item_rect(idx: int, expand: bool = true) const
String | get_item_text(idx: int) const
TextDirection | get_item_text_direction(idx: int) const
String | get_item_tooltip(idx: int) const
PackedInt32Array | get_selected_items()
VScrollBar | get_v_scroll_bar()
bool | is_anything_selected()
bool | is_item_disabled(idx: int) const
bool | is_item_icon_transposed(idx: int) const
bool | is_item_selectable(idx: int) const
bool | is_item_tooltip_enabled(idx: int) const
bool | is_selected(idx: int) const
void | move_item(from_idx: int, to_idx: int)
void | remove_item(idx: int)
void | select(idx: int, single: bool = true)
void | set_item_auto_translate_mode(idx: int, mode: AutoTranslateMode)
void | set_item_custom_bg_color(idx: int, custom_bg_color: Color)
void | set_item_custom_fg_color(idx: int, custom_fg_color: Color)
void | set_item_disabled(idx: int, disabled: bool)
void | set_item_icon(idx: int, icon: Texture2D)
void | set_item_icon_modulate(idx: int, modulate: Color)
void | set_item_icon_region(idx: int, rect: Rect2)
void | set_item_icon_transposed(idx: int, transposed: bool)
void | set_item_language(idx: int, language: String)
void | set_item_metadata(idx: int, metadata: Variant)
void | set_item_selectable(idx: int, selectable: bool)
void | set_item_text(idx: int, text: String)
void | set_item_text_direction(idx: int, direction: TextDirection)
void | set_item_tooltip(idx: int, tooltip: String)
void | set_item_tooltip_enabled(idx: int, enable: bool)
void | sort_items_by_text()

## Theme Properties

Color | font_color | Color(0.65, 0.65, 0.65, 1)
Color | font_hovered_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hovered_selected_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_selected_color | Color(1, 1, 1, 1)
Color | guide_color | Color(0.7, 0.7, 0.7, 0.25)
Color | scroll_hint_color | Color(0, 0, 0, 1)
int | h_separation | 4
int | icon_margin | 4
int | line_separation | 2
int | outline_size | 0
int | v_separation | 4
Font | font |
int | font_size |
Texture2D | scroll_hint |
StyleBox | cursor |
StyleBox | cursor_unfocused |
StyleBox | focus |
StyleBox | hovered |
StyleBox | hovered_selected |
StyleBox | hovered_selected_focus |
StyleBox | panel |
StyleBox | selected |
StyleBox | selected_focus |

---

## Signals

empty_clicked(at_position: Vector2, mouse_button_index: int) 

Emitted when any mouse click is issued within the rect of the list but on empty space.

at_position is the click position in this control's local coordinate system.

---

item_activated(index: int) 

Emitted when specified list item is activated via double-clicking or by pressing Enter.

---

item_clicked(index: int, at_position: Vector2, mouse_button_index: int) 

Emitted when specified list item has been clicked with any mouse button.

at_position is the click position in this control's local coordinate system.

---

item_selected(index: int) 

Emitted when specified item has been selected. Only applicable in single selection mode.

allow_reselect must be enabled to reselect an item.

---

multi_selected(index: int, selected: bool) 

Emitted when a multiple selection is altered on a list allowing multiple selection.

---

## Enumerations

enum IconMode
IconMode ICON_MODE_TOP = 0

Icon is drawn above the text.

IconMode ICON_MODE_LEFT = 1

Icon is drawn to the left of the text.

---

enum SelectMode
SelectMode SELECT_SINGLE = 0

Only allow selecting a single item.

SelectMode SELECT_MULTI = 1

Allows selecting multiple items by holding Ctrl or Shift.

SelectMode SELECT_TOGGLE = 2

Allows selecting multiple items by toggling them on and off.

---

enum ScrollHintMode
ScrollHintMode SCROLL_HINT_MODE_DISABLED = 0

Scroll hints will never be shown.

ScrollHintMode SCROLL_HINT_MODE_BOTH = 1

Scroll hints will be shown at the top and bottom.

ScrollHintMode SCROLL_HINT_MODE_TOP = 2

Only the top scroll hint will be shown.

ScrollHintMode SCROLL_HINT_MODE_BOTTOM = 3

Only the bottom scroll hint will be shown.

---

## Property Descriptions

bool allow_reselect = false 

- void set_allow_reselect(value: bool)
- bool get_allow_reselect()

If true, the currently selected item can be selected again.

---

bool allow_rmb_select = false 

- void set_allow_rmb_select(value: bool)
- bool get_allow_rmb_select()

If true, right mouse button click can select items.

---

bool allow_search = true 

- void set_allow_search(value: bool)
- bool get_allow_search()

If true, allows navigating the ItemList with letter keys through incremental search.

---

bool auto_height = false 

- void set_auto_height(value: bool)
- bool has_auto_height()

If true, the control will automatically resize the height to fit its content.

---

bool auto_width = false 

- void set_auto_width(value: bool)
- bool has_auto_width()

If true, the control will automatically resize the width to fit its content.

---

int fixed_column_width = 0 

- void set_fixed_column_width(value: int)
- int get_fixed_column_width()

The width all columns will be adjusted to.

A value of zero disables the adjustment, each item will have a width equal to the width of its content and the columns will have an uneven width.

---

Vector2i fixed_icon_size = Vector2i(0, 0) 

- void set_fixed_icon_size(value: Vector2i)
- Vector2i get_fixed_icon_size()

The size all icons will be adjusted to.

If either X or Y component is not greater than zero, icon size won't be affected.

---

IconMode icon_mode = 1 

- void set_icon_mode(value: IconMode)
- IconMode get_icon_mode()

The icon position, whether above or to the left of the text. See the IconMode constants.

---

float icon_scale = 1.0 

- void set_icon_scale(value: float)
- float get_icon_scale()

The scale of icon applied after fixed_icon_size and transposing takes effect.

---

int item_count = 0 

- void set_item_count(value: int)
- int get_item_count()

The number of items currently in the list.

---

bool item_{index}/disabled = false 

If true, the item at index is disabled.

Note: index is a value in the 0 .. item_count - 1 range.

---

Texture2D item_{index}/icon 

The icon of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

bool item_{index}/selectable = true 

If true, the item at index is selectable.

Note: index is a value in the 0 .. item_count - 1 range.

---

String item_{index}/text = "" 

The text of the item at index.

Note: index is a value in the 0 .. item_count - 1 range.

---

int max_columns = 1 

- void set_max_columns(value: int)
- int get_max_columns()

Maximum columns the list will have.

If greater than zero, the content will be split among the specified columns.

A value of zero means unlimited columns, i.e. all items will be put in the same row.

---

int max_text_lines = 1 

- void set_max_text_lines(value: int)
- int get_max_text_lines()

Maximum lines of text allowed in each item. Space will be reserved even when there is not enough lines of text to display.

Note: This property takes effect only when icon_mode is ICON_MODE_TOP. To make the text wrap, fixed_column_width should be greater than zero.

---

bool same_column_width = false 

- void set_same_column_width(value: bool)
- bool is_same_column_width()

Whether all columns will have the same width.

If true, the width is equal to the largest column width of all columns.

---

ScrollHintMode scroll_hint_mode = 0 

- void set_scroll_hint_mode(value: ScrollHintMode)
- ScrollHintMode get_scroll_hint_mode()

The way which scroll hints (indicators that show that the content can still be scrolled in a certain direction) will be shown.

---

SelectMode select_mode = 0 

- void set_select_mode(value: SelectMode)
- SelectMode get_select_mode()

Allows single or multiple item selection. See the SelectMode constants.

---

OverrunBehavior text_overrun_behavior = 3 

- void set_text_overrun_behavior(value: OverrunBehavior)
- OverrunBehavior get_text_overrun_behavior()

The clipping behavior when the text exceeds an item's bounding rectangle.

---

bool tile_scroll_hint = false 

- void set_tile_scroll_hint(value: bool)
- bool is_scroll_hint_tiled()

If true, the scroll hint texture will be tiled instead of stretched. See scroll_hint_mode.

---

bool wraparound_items = true 

- void set_wraparound_items(value: bool)
- bool has_wraparound_items()

If true, the control will automatically move items into a new row to fit its content. See also HFlowContainer for this behavior.

If false, the control will add a horizontal scrollbar to make all items visible.

---

## Method Descriptions

int add_icon_item(icon: Texture2D, selectable: bool = true) 

Adds an item to the item list with no text, only an icon. Returns the index of an added item.

---

int add_item(text: String, icon: Texture2D = null, selectable: bool = true) 

Adds an item to the item list with specified text. Returns the index of an added item.

Specify an icon, or use null as the icon for a list item with no icon.

If selectable is true, the list item will be selectable.

---

void center_on_current(center_verically: bool = true, center_horizontally: bool = true) 

Ensures the currently selected item (the first selected item if multiple selection is enabled) is visible, adjusting the scroll position as necessary to place the item at the center of the list if possible. See also ensure_current_is_visible().

Fails and prints an error if both arguments are false.

---

void clear() 

Removes all items from the list.

---

void deselect(idx: int) 

Ensures the item associated with the specified index is not selected.

---

void deselect_all() 

Ensures there are no items selected.

---

void ensure_current_is_visible() 

Ensures the currently selected item (the first selected item if multiple selection is enabled) is visible, adjusting the scroll position as necessary. See also center_on_current().

---

void force_update_list_size() 

Forces an update to the list size based on its items. This happens automatically whenever size of the items, or other relevant settings like auto_height, change. The method can be used to trigger the update ahead of next drawing pass.

---

HScrollBar get_h_scroll_bar() 

Returns the horizontal scrollbar.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

int get_item_at_position(position: Vector2, exact: bool = false) const 

Returns the item index at the given position.

When there is no item at that point, -1 will be returned if exact is true, and the closest item index will be returned otherwise.

Note: The returned value is unreliable if called right after modifying the ItemList, before it redraws in the next frame.

---

AutoTranslateMode get_item_auto_translate_mode(idx: int) const 

Returns item's auto translate mode.

---

Color get_item_custom_bg_color(idx: int) const 

Returns the custom background color of the item specified by idx index.

---

Color get_item_custom_fg_color(idx: int) const 

Returns the custom foreground color of the item specified by idx index.

---

Texture2D get_item_icon(idx: int) const 

Returns the icon associated with the specified index.

---

Color get_item_icon_modulate(idx: int) const 

Returns a Color modulating item's icon at the specified index.

---

Rect2 get_item_icon_region(idx: int) const 

Returns the region of item's icon used. The whole icon will be used if the region has no area.

---

String get_item_language(idx: int) const 

Returns item's text language code.

---

Variant get_item_metadata(idx: int) const 

Returns the metadata value of the specified index.

---

Rect2 get_item_rect(idx: int, expand: bool = true) const 

Returns the position and size of the item with the specified index, in the coordinate system of the ItemList node. If expand is true the last column expands to fill the rest of the row.

Note: The returned value is unreliable if called right after modifying the ItemList, before it redraws in the next frame.

---

String get_item_text(idx: int) const 

Returns the text associated with the specified index.

---

TextDirection get_item_text_direction(idx: int) const 

Returns item's text base writing direction.

---

String get_item_tooltip(idx: int) const 

Returns the tooltip hint associated with the specified index.

---

PackedInt32Array get_selected_items() 

Returns an array with the indexes of the selected items.

---

VScrollBar get_v_scroll_bar() 

Returns the vertical scrollbar.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

bool is_anything_selected() 

Returns true if one or more items are selected.

---

bool is_item_disabled(idx: int) const 

Returns true if the item at the specified index is disabled.

---

bool is_item_icon_transposed(idx: int) const 

Returns true if the item icon will be drawn transposed, i.e. the X and Y axes are swapped.

---

bool is_item_selectable(idx: int) const 

Returns true if the item at the specified index is selectable.

---

bool is_item_tooltip_enabled(idx: int) const 

Returns true if the tooltip is enabled for specified item index.

---

bool is_selected(idx: int) const 

Returns true if the item at the specified index is currently selected.

---

void move_item(from_idx: int, to_idx: int) 

Moves item from index from_idx to to_idx.

---

void remove_item(idx: int) 

Removes the item specified by idx index from the list.

---

void select(idx: int, single: bool = true) 

Selects the item at the specified index.

Note: This method does not trigger the item selection signal.

---

void set_item_auto_translate_mode(idx: int, mode: AutoTranslateMode) 

Sets the auto translate mode of the item associated with the specified index.

Items use Node.AUTO_TRANSLATE_MODE_INHERIT by default, which uses the same auto translate mode as the ItemList itself.

---

void set_item_custom_bg_color(idx: int, custom_bg_color: Color) 

Sets the background color of the item specified by idx index to the specified Color.

---

void set_item_custom_fg_color(idx: int, custom_fg_color: Color) 

Sets the foreground color of the item specified by idx index to the specified Color.

---

void set_item_disabled(idx: int, disabled: bool) 

Disables (or enables) the item at the specified index.

Disabled items cannot be selected and do not trigger activation signals (when double-clicking or pressing Enter).

---

void set_item_icon(idx: int, icon: Texture2D) 

Sets (or replaces) the icon's Texture2D associated with the specified index.

---

void set_item_icon_modulate(idx: int, modulate: Color) 

Sets a modulating Color of the item associated with the specified index.

---

void set_item_icon_region(idx: int, rect: Rect2) 

Sets the region of item's icon used. The whole icon will be used if the region has no area.

---

void set_item_icon_transposed(idx: int, transposed: bool) 

Sets whether the item icon will be drawn transposed.

---

void set_item_language(idx: int, language: String) 

Sets the language code of the text for the item at the given index to language. This is used for line-breaking and text shaping algorithms. If language is empty, the current locale is used.

---

void set_item_metadata(idx: int, metadata: Variant) 

Sets a value (of any type) to be stored with the item associated with the specified index.

---

void set_item_selectable(idx: int, selectable: bool) 

Allows or disallows selection of the item associated with the specified index.

---

void set_item_text(idx: int, text: String) 

Sets text of the item associated with the specified index.

---

void set_item_text_direction(idx: int, direction: TextDirection) 

Sets item's text base writing direction.

---

void set_item_tooltip(idx: int, tooltip: String) 

Sets the tooltip hint for the item associated with the specified index.

---

void set_item_tooltip_enabled(idx: int, enable: bool) 

Sets whether the tooltip hint is enabled for specified item index.

---

void sort_items_by_text() 

Sorts items in the list by their text.

---

## Theme Property Descriptions

Color font_color = Color(0.65, 0.65, 0.65, 1) 

Default text Color of the item.

---

Color font_hovered_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the item is hovered and not selected yet.

---

Color font_hovered_selected_color = Color(1, 1, 1, 1) 

Text Color used when the item is hovered and selected.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the item.

---

Color font_selected_color = Color(1, 1, 1, 1) 

Text Color used when the item is selected, but not hovered.

---

Color guide_color = Color(0.7, 0.7, 0.7, 0.25) 

Color of the guideline. The guideline is a line drawn between each row of items.

---

Color scroll_hint_color = Color(0, 0, 0, 1) 

Color used to modulate the scroll_hint texture.

---

int h_separation = 4 

The horizontal spacing between items.

---

int icon_margin = 4 

The spacing between item's icon and text.

---

int line_separation = 2 

The vertical spacing between each line of text.

---

int outline_size = 0 

The size of the item text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int v_separation = 4 

The vertical spacing between items.

---

Font font 

Font of the item's text.

---

int font_size 

Font size of the item's text.

---

Texture2D scroll_hint 

The indicator that will be shown when the content can still be scrolled. See scroll_hint_mode.

---

StyleBox cursor 

StyleBox used for the cursor, when the ItemList is being focused.

---

StyleBox cursor_unfocused 

StyleBox used for the cursor, when the ItemList is not being focused.

---

StyleBox focus 

The focused style for the ItemList, drawn on top of everything.

---

StyleBox hovered 

StyleBox for the hovered, but not selected items.

---

StyleBox hovered_selected 

StyleBox for the hovered and selected items, used when the ItemList is not being focused.

---

StyleBox hovered_selected_focus 

StyleBox for the hovered and selected items, used when the ItemList is being focused.

---

StyleBox panel 

The background style for the ItemList.

---

StyleBox selected 

StyleBox for the selected items, used when the ItemList is not being focused.

---

StyleBox selected_focus 

StyleBox for the selected items, used when the ItemList is being focused.
