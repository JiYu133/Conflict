# Tree

Inherits: Control < CanvasItem < Node < Object

A control used to show a set of internal TreeItems in a hierarchical structure.

## Description

A control used to show a set of internal TreeItems in a hierarchical structure. The tree items can be selected, expanded and collapsed. The tree can have multiple columns with custom controls like LineEdits, buttons and popups. It can be useful for structured displays and interactions.

Trees are built via code, using TreeItem objects to create the structure. They have a single root, but multiple roots can be simulated with hide_root:

```
func _ready():
    var tree = Tree.new()
    var root = tree.create_item()
    tree.hide_root = true
    var child1 = tree.create_item(root)
    var child2 = tree.create_item(root)
    var subchild1 = tree.create_item(child1)
    subchild1.set_text(0, "Subchild1")
```

```
public override void _Ready()
{
    var tree = new Tree();
    TreeItem root = tree.CreateItem();
    tree.HideRoot = true;
    TreeItem child1 = tree.CreateItem(root);
    TreeItem child2 = tree.CreateItem(root);
    TreeItem subchild1 = tree.CreateItem(child1);
    subchild1.SetText(0, "Subchild1");
}
```

To iterate over all the TreeItem objects in a Tree object, use TreeItem.get_next() and TreeItem.get_first_child() after getting the root through get_root(). You can use Object.free() on a TreeItem to remove it from the Tree.

Incremental search: Like ItemList and PopupMenu, Tree supports searching within the list while the control is focused. Press a key that matches the first letter of an item's name to select the first item starting with the given letter. After that point, there are two ways to perform incremental search: 1) Press the same key again before the timeout duration to select the next item starting with the same letter. 2) Press letter keys that match the rest of the word before the timeout duration to match to select the item in question directly. Both of these actions will be reset to the beginning of the list if the timeout duration has passed since the last keystroke was registered. You can adjust the timeout duration by changing ProjectSettings.gui/timers/incremental_search_max_interval_msec.

## Properties

bool | allow_reselect | false
bool | allow_rmb_select | false
bool | allow_search | true
bool | auto_tooltip | true
bool | clip_contents | true (overrides Control)
bool | column_titles_visible | false
int | columns | 1
int | drop_mode_flags | 0
bool | enable_drag_unfolding | true
bool | enable_recursive_folding | true
FocusMode | focus_mode | 2 (overrides Control)
bool | hide_folding | false
bool | hide_root | false
ScrollHintMode | scroll_hint_mode | 0
bool | scroll_horizontal_enabled | true
bool | scroll_vertical_enabled | true
SelectMode | select_mode | 0
bool | tile_scroll_hint | false

## Methods

void | clear()
TreeItem | create_item(parent: TreeItem = null, index: int = -1)
void | deselect_all()
bool | edit_selected(force_edit: bool = false)
void | ensure_cursor_is_visible()
int | get_button_id_at_position(position: Vector2) const
int | get_column_at_position(position: Vector2) const
int | get_column_expand_ratio(column: int) const
String | get_column_title(column: int) const
HorizontalAlignment | get_column_title_alignment(column: int) const
TextDirection | get_column_title_direction(column: int) const
String | get_column_title_language(column: int) const
String | get_column_title_tooltip_text(column: int) const
int | get_column_width(column: int) const
RID | get_custom_drawing_canvas_item() const
Rect2 | get_custom_popup_rect() const
int | get_drop_section_at_position(position: Vector2) const
TreeItem | get_edited() const
int | get_edited_column() const
Rect2 | get_item_area_rect(item: TreeItem, column: int = -1, button_index: int = -1) const
TreeItem | get_item_at_position(position: Vector2) const
TreeItem | get_next_selected(from: TreeItem)
int | get_pressed_button() const
TreeItem | get_root() const
Vector2 | get_scroll() const
TreeItem | get_selected() const
int | get_selected_column() const
bool | is_column_clipping_content(column: int) const
bool | is_column_expanding(column: int) const
void | scroll_to_item(item: TreeItem, center_on_item: bool = false)
void | set_column_clip_content(column: int, enable: bool)
void | set_column_custom_minimum_width(column: int, min_width: int)
void | set_column_expand(column: int, expand: bool)
void | set_column_expand_ratio(column: int, ratio: int)
void | set_column_title(column: int, title: String)
void | set_column_title_alignment(column: int, title_alignment: HorizontalAlignment)
void | set_column_title_direction(column: int, direction: TextDirection)
void | set_column_title_language(column: int, language: String)
void | set_column_title_tooltip_text(column: int, tooltip_text: String)
void | set_selected(item: TreeItem, column: int)

## Theme Properties

Color | children_hl_line_color | Color(0.27, 0.27, 0.27, 1)
Color | custom_button_font_highlight | Color(0.95, 0.95, 0.95, 1)
Color | drop_on_item_color | Color(1, 1, 1, 1)
Color | drop_position_color | Color(1, 1, 1, 1)
Color | font_color | Color(0.7, 0.7, 0.7, 1)
Color | font_disabled_color | Color(0.875, 0.875, 0.875, 0.5)
Color | font_hovered_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hovered_dimmed_color | Color(0.875, 0.875, 0.875, 1)
Color | font_hovered_selected_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_selected_color | Color(1, 1, 1, 1)
Color | guide_color | Color(0.7, 0.7, 0.7, 0.25)
Color | parent_hl_line_color | Color(0.27, 0.27, 0.27, 1)
Color | relationship_line_color | Color(0.27, 0.27, 0.27, 1)
Color | scroll_hint_color | Color(0, 0, 0, 1)
Color | title_button_color | Color(0.875, 0.875, 0.875, 1)
int | button_margin | 4
int | check_h_separation | 4
int | children_hl_line_width | 1
int | dragging_unfold_wait_msec | 500
int | draw_guides | 1
int | draw_relationship_lines | 0
int | h_separation | 4
int | icon_h_separation | 4
int | icon_max_width | 0
int | inner_item_margin_bottom | 0
int | inner_item_margin_left | 0
int | inner_item_margin_right | 0
int | inner_item_margin_top | 0
int | item_margin | 16
int | outline_size | 0
int | parent_hl_line_margin | 0
int | parent_hl_line_width | 1
int | relationship_line_width | 1
int | scroll_border | 4
int | scroll_speed | 12
int | scrollbar_h_separation | 4
int | scrollbar_margin_bottom | -1
int | scrollbar_margin_left | -1
int | scrollbar_margin_right | -1
int | scrollbar_margin_top | -1
int | scrollbar_v_separation | 4
int | v_separation | 4
Font | font |
Font | title_button_font |
int | font_size |
int | title_button_font_size |
Texture2D | arrow |
Texture2D | arrow_collapsed |
Texture2D | arrow_collapsed_mirrored |
Texture2D | checked |
Texture2D | checked_disabled |
Texture2D | indeterminate |
Texture2D | indeterminate_disabled |
Texture2D | scroll_hint |
Texture2D | select_arrow |
Texture2D | unchecked |
Texture2D | unchecked_disabled |
Texture2D | updown |
StyleBox | button_hover |
StyleBox | button_pressed |
StyleBox | cursor |
StyleBox | cursor_unfocused |
StyleBox | custom_button |
StyleBox | custom_button_hover |
StyleBox | custom_button_pressed |
StyleBox | focus |
StyleBox | hovered |
StyleBox | hovered_dimmed |
StyleBox | hovered_selected |
StyleBox | hovered_selected_focus |
StyleBox | panel |
StyleBox | selected |
StyleBox | selected_focus |
StyleBox | title_button_hover |
StyleBox | title_button_normal |
StyleBox | title_button_pressed |

---

## Signals

button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) 

Emitted when a button on the tree was pressed (see TreeItem.add_button()).

---

cell_selected() 

Emitted when a cell is selected.

---

check_propagated_to_item(item: TreeItem, column: int) 

Emitted when TreeItem.propagate_check() is called. Connect to this signal to process the items that are affected when TreeItem.propagate_check() is invoked. The order that the items affected will be processed is as follows: the item that invoked the method, children of that item, and finally parents of that item.

---

column_title_clicked(column: int, mouse_button_index: int) 

Emitted when a column's title is clicked with either @GlobalScope.MOUSE_BUTTON_LEFT or @GlobalScope.MOUSE_BUTTON_RIGHT.

---

custom_item_clicked(mouse_button_index: int) 

Emitted when an item with TreeItem.CELL_MODE_CUSTOM is clicked with a mouse button.

---

custom_popup_edited(arrow_clicked: bool) 

Emitted when a cell with the TreeItem.CELL_MODE_CUSTOM is clicked to be edited.

---

empty_clicked(click_position: Vector2, mouse_button_index: int) 

Emitted when a mouse button is clicked in the empty space of the tree.

---

item_activated() 

Emitted when an item is double-clicked, or selected with a ui_accept input event (e.g. using Enter or Space on the keyboard).

---

item_collapsed(item: TreeItem) 

Emitted when an item is expanded or collapsed by clicking on the folding arrow or through code.

Note: Despite its name, this signal is also emitted when an item is expanded.

---

item_edited() 

Emitted when an item is edited.

---

item_icon_double_clicked() 

Emitted when an item's icon is double-clicked. For a signal that emits when any part of the item is double-clicked, see item_activated.

---

item_mouse_selected(mouse_position: Vector2, mouse_button_index: int) 

Emitted when an item is selected with a mouse button.

---

item_selected() 

Emitted when an item is selected.

---

multi_selected(item: TreeItem, column: int, selected: bool) 

Emitted instead of item_selected if select_mode is set to SELECT_MULTI.

---

nothing_selected() 

Emitted when a left mouse button click does not select any item.

---

## Enumerations

enum SelectMode
SelectMode SELECT_SINGLE = 0

Allows selection of a single cell at a time. From the perspective of items, only a single item is allowed to be selected. And there is only one column selected in the selected item.

The focus cursor is always hidden in this mode, but it is positioned at the current selection, making the currently selected item the currently focused item.

SelectMode SELECT_ROW = 1

Allows selection of a single row at a time. From the perspective of items, only a single items is allowed to be selected. And all the columns are selected in the selected item.

The focus cursor is always hidden in this mode, but it is positioned at the first column of the current selection, making the currently selected item the currently focused item.

SelectMode SELECT_MULTI = 2

Allows selection of multiple cells at the same time. From the perspective of items, multiple items are allowed to be selected. And there can be multiple columns selected in each selected item.

The focus cursor is visible in this mode, the item or column under the cursor is not necessarily selected.

---

enum DropModeFlags
DropModeFlags DROP_MODE_DISABLED = 0

Disables all drop sections.

Note: This is the default flag, it has no effect when combined with other flags.

DropModeFlags DROP_MODE_ON_ITEM = 1

Enables the "on item" drop section. This drop section covers the entire item.

When combined with DROP_MODE_INBETWEEN, this drop section halves in height and stays centered vertically.

DropModeFlags DROP_MODE_INBETWEEN = 2

Enables "above item" and "below item" drop sections. The "above item" drop section covers the top half of the item, while the "below item" drop section covers the bottom half, and extends downward to the left of any children.

When combined with DROP_MODE_ON_ITEM, these drop sections halve in height and stay at the top and bottom respectively.

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

If true, the currently selected cell may be selected again.

---

bool allow_rmb_select = false 

- void set_allow_rmb_select(value: bool)
- bool get_allow_rmb_select()

If true, a right mouse button click can select items.

---

bool allow_search = true 

- void set_allow_search(value: bool)
- bool get_allow_search()

If true, allows navigating the Tree with letter keys through incremental search.

---

bool auto_tooltip = true 

- void set_auto_tooltip(value: bool)
- bool is_auto_tooltip_enabled()

If true, tree items with no tooltip assigned display their text as their tooltip. See also TreeItem.get_tooltip_text() and TreeItem.get_button_tooltip_text().

---

bool column_titles_visible = false 

- void set_column_titles_visible(value: bool)
- bool are_column_titles_visible()

If true, column titles are visible.

---

int columns = 1 

- void set_columns(value: int)
- int get_columns()

The number of columns.

Prints an error and does not allow setting the columns during mouse selection.

---

int drop_mode_flags = 0 

- void set_drop_mode_flags(value: int)
- int get_drop_mode_flags()

The drop mode as an OR combination of flags. See DropModeFlags constants. Once dropping is done, reverts to DROP_MODE_DISABLED. Setting this during Control._can_drop_data() is recommended.

This controls the drop sections, i.e. the decision and drawing of possible drop locations based on the mouse position.

---

bool enable_drag_unfolding = true 

- void set_enable_drag_unfolding(value: bool)
- bool is_drag_unfolding_enabled()

If true, tree items will unfold when hovered over during a drag-and-drop. The delay for when this happens is dictated by dragging_unfold_wait_msec.

---

bool enable_recursive_folding = true 

- void set_enable_recursive_folding(value: bool)
- bool is_recursive_folding_enabled()

If true, recursive folding is enabled for this Tree. Holding down Shift while clicking the fold arrow or using ui_right/ui_left shortcuts collapses or uncollapses the TreeItem and all its descendants.

---

bool hide_folding = false 

- void set_hide_folding(value: bool)
- bool is_folding_hidden()

If true, the folding arrow is hidden.

---

bool hide_root = false 

- void set_hide_root(value: bool)
- bool is_root_hidden()

If true, the tree's root is hidden.

---

ScrollHintMode scroll_hint_mode = 0 

- void set_scroll_hint_mode(value: ScrollHintMode)
- ScrollHintMode get_scroll_hint_mode()

The way which scroll hints (indicators that show that the content can still be scrolled in a certain direction) will be shown.

---

bool scroll_horizontal_enabled = true 

- void set_h_scroll_enabled(value: bool)
- bool is_h_scroll_enabled()

If true, enables horizontal scrolling.

---

bool scroll_vertical_enabled = true 

- void set_v_scroll_enabled(value: bool)
- bool is_v_scroll_enabled()

If true, enables vertical scrolling.

---

SelectMode select_mode = 0 

- void set_select_mode(value: SelectMode)
- SelectMode get_select_mode()

Allows single or multiple selection. See the SelectMode constants.

---

bool tile_scroll_hint = false 

- void set_tile_scroll_hint(value: bool)
- bool is_scroll_hint_tiled()

If true, the scroll hint texture will be tiled instead of stretched. See scroll_hint_mode.

---

## Method Descriptions

void clear() 

Clears the tree. This removes all items.

Prints an error and does not allow clearing the tree if called during mouse selection.

---

TreeItem create_item(parent: TreeItem = null, index: int = -1) 

Creates an item in the tree and adds it as a child of parent, which can be either a valid TreeItem or null.

If parent is null, the root item will be the parent, or the new item will be the root itself if the tree is empty.

The new item will be the index-th child of parent, or it will be the last child if there are not enough siblings.

Prints an error and returns null if called during mouse selection, or if the parent does not belong to this tree.

---

void deselect_all() 

Deselects all tree items (rows and columns). In SELECT_MULTI mode also removes selection cursor.

---

bool edit_selected(force_edit: bool = false) 

Edits the selected tree item as if it was clicked.

Either the item must be set editable with TreeItem.set_editable() or force_edit must be true.

Returns true if the item could be edited. Fails if no item is selected.

---

void ensure_cursor_is_visible() 

Makes the currently focused cell visible.

This will scroll the tree if necessary. In SELECT_ROW mode, this will not do horizontal scrolling, as all the cells in the selected row is focused logically.

Note: Despite the name of this method, the focus cursor itself is only visible in SELECT_MULTI mode.

---

int get_button_id_at_position(position: Vector2) const 

Returns the button ID at position, or -1 if no button is there.

---

int get_column_at_position(position: Vector2) const 

Returns the column index at position, or -1 if no item is there.

---

int get_column_expand_ratio(column: int) const 

Returns the expand ratio assigned to the column.

---

String get_column_title(column: int) const 

Returns the column's title.

---

HorizontalAlignment get_column_title_alignment(column: int) const 

Returns the column title alignment.

---

TextDirection get_column_title_direction(column: int) const 

Returns column title base writing direction.

---

String get_column_title_language(column: int) const 

Returns column title language code.

---

String get_column_title_tooltip_text(column: int) const 

Returns the column title's tooltip text.

---

int get_column_width(column: int) const 

Returns the column's width in pixels.

---

RID get_custom_drawing_canvas_item() const 

Returns the internal canvas item designated for custom drawing. See TreeItem.set_custom_draw_callback().

Note: This canvas item clears automatically on each Tree draw call.

---

Rect2 get_custom_popup_rect() const 

Returns the rectangle for custom popups. Helper to create custom cell controls that display a popup. See TreeItem.set_cell_mode().

---

int get_drop_section_at_position(position: Vector2) const 

Returns the drop section at position, as permitted by enabled DropModeFlags.

- -1 if the position is above the item. Typically used to insert as the item's previous sibling.
- 0 if the position is on the item. Typically used to insert as the item's last child.
- 1 if the position is below the item, when the item has no children. Typically used to insert as the item's next sibling. If the item does have children, this section is still reachable by hovering to the left of the item's collapse arrow, and below.
- 2 if the position is below the item, when the item has children. Typically used to insert as the item's first child.
- -100 if the position is not over any item, or no DropModeFlags are set.

See DropModeFlags for a description of each drop region. To get the item which the returned drop section refers to, use get_item_at_position().

---

TreeItem get_edited() const 

Returns the currently edited item. Can be used with item_edited to get the item that was modified.

```
func _ready():
    $Tree.item_edited.connect(on_Tree_item_edited)
func on_Tree_item_edited():
    print($Tree.get_edited()) # This item just got edited (e.g. checked).
```

```
public override void _Ready()
{
    GetNode("Tree").ItemEdited += OnTreeItemEdited;
}
public void OnTreeItemEdited()
{
    GD.Print(GetNode("Tree").GetEdited()); // This item just got edited (e.g. checked).
}
```

---

int get_edited_column() const 

Returns the column for the currently edited item.

---

Rect2 get_item_area_rect(item: TreeItem, column: int = -1, button_index: int = -1) const 

Returns the rectangle area for the specified TreeItem. If column is specified, only get the position and size of that column, otherwise get the rectangle containing all columns. If a button index is specified, the rectangle of that button will be returned.

---

TreeItem get_item_at_position(position: Vector2) const 

Returns the tree item at the specified position (relative to the tree origin position).

---

TreeItem get_next_selected(from: TreeItem) 

Returns the next selected TreeItem after the given one, or null if the end is reached.

If from is null, this returns the first selected item.

---

int get_pressed_button() const 

Returns the last pressed button's index.

---

TreeItem get_root() const 

Returns the tree's root item, or null if the tree is empty.

---

Vector2 get_scroll() const 

Returns the current scrolling position.

---

TreeItem get_selected() const 

Returns the currently focused item, or null if no item is focused.

In SELECT_ROW and SELECT_SINGLE modes, the focused item is same as the selected item. In SELECT_MULTI mode, the focused item is the item under the focus cursor, not necessarily selected.

To get the currently selected item(s), use get_next_selected().

---

int get_selected_column() const 

Returns the currently focused column, or -1 if no column is focused.

In SELECT_SINGLE mode, the focused column is the selected column. In SELECT_ROW mode, the focused column is always 0 if any item is selected. In SELECT_MULTI mode, the focused column is the column under the focus cursor, and there are not necessarily any column selected.

To tell whether a column of an item is selected, use TreeItem.is_selected().

---

bool is_column_clipping_content(column: int) const 

Returns true if the column has enabled clipping (see set_column_clip_content()).

---

bool is_column_expanding(column: int) const 

Returns true if the column has enabled expanding (see set_column_expand()).

---

void scroll_to_item(item: TreeItem, center_on_item: bool = false) 

Causes the Tree to jump to the specified TreeItem.

---

void set_column_clip_content(column: int, enable: bool) 

Allows to enable clipping for column's content, making the content size ignored.

---

void set_column_custom_minimum_width(column: int, min_width: int) 

Overrides the calculated minimum width of a column. It can be set to 0 to restore the default behavior. Columns that have the "Expand" flag will use their "min_width" in a similar fashion to Control.size_flags_stretch_ratio.

---

void set_column_expand(column: int, expand: bool) 

If true, the column will have the "Expand" flag of Control. Columns that have the "Expand" flag will use their expand ratio in a similar fashion to Control.size_flags_stretch_ratio (see set_column_expand_ratio()).

---

void set_column_expand_ratio(column: int, ratio: int) 

Sets the relative expand ratio for a column. See set_column_expand().

---

void set_column_title(column: int, title: String) 

Sets the title of a column.

---

void set_column_title_alignment(column: int, title_alignment: HorizontalAlignment) 

Sets the column title alignment. Note that @GlobalScope.HORIZONTAL_ALIGNMENT_FILL is not supported for column titles.

---

void set_column_title_direction(column: int, direction: TextDirection) 

Sets column title base writing direction.

---

void set_column_title_language(column: int, language: String) 

Sets the language code of the given column's title to language. This is used for line-breaking and text shaping algorithms. If language is empty, the current locale is used.

---

void set_column_title_tooltip_text(column: int, tooltip_text: String) 

Sets the column title's tooltip text.

---

void set_selected(item: TreeItem, column: int) 

Selects the specified TreeItem and column.

---

## Theme Property Descriptions

Color children_hl_line_color = Color(0.27, 0.27, 0.27, 1) 

The Color of the relationship lines between the selected TreeItem and its children.

---

Color custom_button_font_highlight = Color(0.95, 0.95, 0.95, 1) 

Text Color for a TreeItem.CELL_MODE_CUSTOM mode cell when it's hovered.

---

Color drop_on_item_color = Color(1, 1, 1, 1) 

Color used to draw the highlight outline when dragging items that can only be dropped "on" other items.

---

Color drop_position_color = Color(1, 1, 1, 1) 

Color used to draw possible drop locations. See DropModeFlags constants for further description of drop locations.

---

Color font_color = Color(0.7, 0.7, 0.7, 1) 

Default text Color of the item.

---

Color font_disabled_color = Color(0.875, 0.875, 0.875, 0.5) 

Text Color for a TreeItem.CELL_MODE_CHECK mode cell when it's non-editable (see TreeItem.set_editable()).

---

Color font_hovered_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the item is hovered and not selected yet.

---

Color font_hovered_dimmed_color = Color(0.875, 0.875, 0.875, 1) 

Text Color used when the item is hovered, while a button of the same item is hovered as the same time.

---

Color font_hovered_selected_color = Color(1, 1, 1, 1) 

Text Color used when the item is hovered and selected.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the item.

---

Color font_selected_color = Color(1, 1, 1, 1) 

Text Color used when the item is selected.

---

Color guide_color = Color(0.7, 0.7, 0.7, 0.25) 

Color of the guideline.

---

Color parent_hl_line_color = Color(0.27, 0.27, 0.27, 1) 

The Color of the relationship lines between the selected TreeItem and its parents.

---

Color relationship_line_color = Color(0.27, 0.27, 0.27, 1) 

The default Color of the relationship lines.

---

Color scroll_hint_color = Color(0, 0, 0, 1) 

Color used to modulate the scroll_hint texture.

---

Color title_button_color = Color(0.875, 0.875, 0.875, 1) 

Default text Color of the title button.

---

int button_margin = 4 

The horizontal space between each button in a cell.

---

int check_h_separation = 4 

The horizontal space between the checkbox and the text in a TreeItem.CELL_MODE_CHECK mode cell.

---

int children_hl_line_width = 1 

The width of the relationship lines between the selected TreeItem and its children.

---

int dragging_unfold_wait_msec = 500 

During a drag-and-drop, this is how many milliseconds to wait over a section before the section unfolds.

---

int draw_guides = 1 

Draws the guidelines if not zero, this acts as a boolean. The guideline is a horizontal line drawn at the bottom of each item.

---

int draw_relationship_lines = 0 

Draws the relationship lines if not zero, this acts as a boolean. Relationship lines are drawn at the start of child items to show hierarchy.

---

int h_separation = 4 

The horizontal space between item cells. This is also used as the margin at the start of an item when folding is disabled.

---

int icon_h_separation = 4 

The horizontal space between the icon and the text in item's cells.

---

int icon_max_width = 0 

The maximum allowed width of the icon in item's cells. This limit is applied on top of the default size of the icon, but before the value set with TreeItem.set_icon_max_width(). The height is adjusted according to the icon's ratio.

---

int inner_item_margin_bottom = 0 

The inner bottom margin of a cell.

---

int inner_item_margin_left = 0 

The inner left margin of a cell.

---

int inner_item_margin_right = 0 

The inner right margin of a cell.

---

int inner_item_margin_top = 0 

The inner top margin of a cell.

---

int item_margin = 16 

The horizontal margin at the start of an item. This is used when folding is enabled for the item.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int parent_hl_line_margin = 0 

The space between the parent relationship lines for the selected TreeItem and the relationship lines to its siblings that are not selected.

---

int parent_hl_line_width = 1 

The width of the relationship lines between the selected TreeItem and its parents.

---

int relationship_line_width = 1 

The default width of the relationship lines.

---

int scroll_border = 4 

The maximum distance between the mouse cursor and the control's border to trigger border scrolling when dragging.

---

int scroll_speed = 12 

The speed of border scrolling.

---

int scrollbar_h_separation = 4 

The horizontal separation of tree content and scrollbar.

---

int scrollbar_margin_bottom = -1 

The bottom margin of the scrollbars. When negative, uses panel bottom margin.

---

int scrollbar_margin_left = -1 

The left margin of the horizontal scrollbar. When negative, uses panel left margin.

---

int scrollbar_margin_right = -1 

The right margin of the scrollbars. When negative, uses panel right margin.

---

int scrollbar_margin_top = -1 

The top margin of the vertical scrollbar. When negative, uses panel top margin.

---

int scrollbar_v_separation = 4 

The vertical separation of tree content and scrollbar.

---

int v_separation = 4 

The vertical padding inside each item, i.e. the distance between the item's content and top/bottom border.

---

Font font 

Font of the item's text.

---

Font title_button_font 

Font of the title button's text.

---

int font_size 

Font size of the item's text.

---

int title_button_font_size 

Font size of the title button's text.

---

Texture2D arrow 

The arrow icon used when a foldable item is not collapsed.

---

Texture2D arrow_collapsed 

The arrow icon used when a foldable item is collapsed (for left-to-right layouts).

---

Texture2D arrow_collapsed_mirrored 

The arrow icon used when a foldable item is collapsed (for right-to-left layouts).

---

Texture2D checked 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is checked and editable (see TreeItem.set_editable()).

---

Texture2D checked_disabled 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is checked and non-editable (see TreeItem.set_editable()).

---

Texture2D indeterminate 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is indeterminate and editable (see TreeItem.set_editable()).

---

Texture2D indeterminate_disabled 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is indeterminate and non-editable (see TreeItem.set_editable()).

---

Texture2D scroll_hint 

The indicator that will be shown when the content can still be scrolled. See scroll_hint_mode.

---

Texture2D select_arrow 

The arrow icon to display for the TreeItem.CELL_MODE_RANGE mode cell.

---

Texture2D unchecked 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is unchecked and editable (see TreeItem.set_editable()).

---

Texture2D unchecked_disabled 

The check icon to display when the TreeItem.CELL_MODE_CHECK mode cell is unchecked and non-editable (see TreeItem.set_editable()).

---

Texture2D updown 

The updown arrow icon to display for the TreeItem.CELL_MODE_RANGE mode cell.

---

StyleBox button_hover 

StyleBox used when a button in the tree is hovered.

---

StyleBox button_pressed 

StyleBox used when a button in the tree is pressed.

---

StyleBox cursor 

StyleBox used for the cursor, when the Tree is being focused.

---

StyleBox cursor_unfocused 

StyleBox used for the cursor, when the Tree is not being focused.

---

StyleBox custom_button 

Default StyleBox for a TreeItem.CELL_MODE_CUSTOM mode cell when button is enabled with TreeItem.set_custom_as_button().

---

StyleBox custom_button_hover 

StyleBox for a TreeItem.CELL_MODE_CUSTOM mode button cell when it's hovered.

---

StyleBox custom_button_pressed 

StyleBox for a TreeItem.CELL_MODE_CUSTOM mode button cell when it's pressed.

---

StyleBox focus 

The focused style for the Tree, drawn on top of everything.

---

StyleBox hovered 

StyleBox for the item being hovered, but not selected.

---

StyleBox hovered_dimmed 

StyleBox for the item being hovered, while a button of the same item is hovered as the same time.

---

StyleBox hovered_selected 

StyleBox for the hovered and selected items, used when the Tree is not being focused.

---

StyleBox hovered_selected_focus 

StyleBox for the hovered and selected items, used when the Tree is being focused.

---

StyleBox panel 

The background style for the Tree.

---

StyleBox selected 

StyleBox for the selected items, used when the Tree is not being focused.

---

StyleBox selected_focus 

StyleBox for the selected items, used when the Tree is being focused.

---

StyleBox title_button_hover 

StyleBox used when the title button is being hovered.

---

StyleBox title_button_normal 

Default StyleBox for the title button.

---

StyleBox title_button_pressed 

StyleBox used when the title button is being pressed.
