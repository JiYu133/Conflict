# AccessibilityServer

Inherits: Object

A server interface for screen reader support.

## Methods

RID | create_element(window_id: int, role: AccessibilityRole)
RID | create_sub_element(parent_rid: RID, role: AccessibilityRole, insert_pos: int = -1)
RID | create_sub_text_edit_elements(parent_rid: RID, shaped_text: RID, min_height: float, insert_pos: int = -1, is_last_line: bool = false)
Variant | element_get_meta(id: RID) const
void | element_set_meta(id: RID, meta: Variant)
void | free_element(id: RID)
RID | get_window_root(window_id: int) const
bool | has_element(id: RID) const
bool | is_supported() const
void | set_window_focused(window_id: int, focused: bool)
void | set_window_rect(window_id: int, rect_out: Rect2, rect_in: Rect2)
void | update_add_action(id: RID, action: AccessibilityAction, callable: Callable)
void | update_add_child(id: RID, child_id: RID)
void | update_add_custom_action(id: RID, action_id: int, action_description: String)
void | update_add_related_controls(id: RID, related_id: RID)
void | update_add_related_described_by(id: RID, related_id: RID)
void | update_add_related_details(id: RID, related_id: RID)
void | update_add_related_flow_to(id: RID, related_id: RID)
void | update_add_related_labeled_by(id: RID, related_id: RID)
void | update_add_related_radio_group(id: RID, related_id: RID)
void | update_set_active_descendant(id: RID, other_id: RID)
void | update_set_background_color(id: RID, color: Color)
void | update_set_bounds(id: RID, rect: Rect2)
void | update_set_braille_label(id: RID, name: String)
void | update_set_braille_role_description(id: RID, description: String)
void | update_set_checked(id: RID, checekd: bool)
void | update_set_classname(id: RID, classname: String)
void | update_set_color_value(id: RID, color: Color)
void | update_set_description(id: RID, description: String)
void | update_set_error_message(id: RID, other_id: RID)
void | update_set_extra_info(id: RID, name: String)
void | update_set_flag(id: RID, flag: AccessibilityFlags, value: bool)
void | update_set_focus(id: RID)
void | update_set_foreground_color(id: RID, color: Color)
void | update_set_in_page_link_target(id: RID, other_id: RID)
void | update_set_language(id: RID, language: String)
void | update_set_list_item_count(id: RID, size: int)
void | update_set_list_item_expanded(id: RID, expanded: bool)
void | update_set_list_item_index(id: RID, index: int)
void | update_set_list_item_level(id: RID, level: int)
void | update_set_list_item_selected(id: RID, selected: bool)
void | update_set_list_orientation(id: RID, vertical: bool)
void | update_set_live(id: RID, live: AccessibilityLiveMode)
void | update_set_member_of(id: RID, group_id: RID)
void | update_set_name(id: RID, name: String)
void | update_set_next_on_line(id: RID, other_id: RID)
void | update_set_num_jump(id: RID, jump: float)
void | update_set_num_range(id: RID, min: float, max: float)
void | update_set_num_step(id: RID, step: float)
void | update_set_num_value(id: RID, position: float)
void | update_set_placeholder(id: RID, placeholder: String)
void | update_set_popup_type(id: RID, popup: AccessibilityPopupType)
void | update_set_previous_on_line(id: RID, other_id: RID)
void | update_set_role(id: RID, role: AccessibilityRole)
void | update_set_role_description(id: RID, description: String)
void | update_set_scroll_x(id: RID, position: float)
void | update_set_scroll_x_range(id: RID, min: float, max: float)
void | update_set_scroll_y(id: RID, position: float)
void | update_set_scroll_y_range(id: RID, min: float, max: float)
void | update_set_shortcut(id: RID, shortcut: String)
void | update_set_state_description(id: RID, description: String)
void | update_set_table_cell_position(id: RID, row_index: int, column_index: int)
void | update_set_table_cell_span(id: RID, row_span: int, column_span: int)
void | update_set_table_column_count(id: RID, count: int)
void | update_set_table_column_index(id: RID, index: int)
void | update_set_table_row_count(id: RID, count: int)
void | update_set_table_row_index(id: RID, index: int)
void | update_set_text_align(id: RID, align: HorizontalAlignment)
void | update_set_text_decorations(id: RID, underline: bool, strikethrough: bool, overline: bool, color: Color = Color(0, 0, 0, 1))
void | update_set_text_orientation(id: RID, vertical: bool)
void | update_set_text_selection(id: RID, text_start_id: RID, start_char: int, text_end_id: RID, end_char: int)
void | update_set_tooltip(id: RID, tooltip: String)
void | update_set_transform(id: RID, transform: Transform2D)
void | update_set_url(id: RID, url: String)
void | update_set_value(id: RID, value: String)

---

## Enumerations

enum AccessibilityRole
AccessibilityRole ROLE_UNKNOWN = 0

Unknown or custom role.

AccessibilityRole ROLE_DEFAULT_BUTTON = 1

Default dialog button element.

AccessibilityRole ROLE_AUDIO = 2

Audio player element.

AccessibilityRole ROLE_VIDEO = 3

Video player element.

AccessibilityRole ROLE_STATIC_TEXT = 4

Non-editable text label.

AccessibilityRole ROLE_CONTAINER = 5

Container element. Elements with this role are used for internal structure and ignored by screen readers.

AccessibilityRole ROLE_PANEL = 6

Panel container element.

AccessibilityRole ROLE_BUTTON = 7

Button element.

AccessibilityRole ROLE_LINK = 8

Link element.

AccessibilityRole ROLE_CHECK_BOX = 9

Check box element.

AccessibilityRole ROLE_RADIO_BUTTON = 10

Radio button element.

AccessibilityRole ROLE_CHECK_BUTTON = 11

Check button element.

AccessibilityRole ROLE_SCROLL_BAR = 12

Scroll bar element.

AccessibilityRole ROLE_SCROLL_VIEW = 13

Scroll container element.

AccessibilityRole ROLE_SPLITTER = 14

Container splitter handle element.

AccessibilityRole ROLE_SLIDER = 15

Slider element.

AccessibilityRole ROLE_SPIN_BUTTON = 16

Spin box element.

AccessibilityRole ROLE_PROGRESS_INDICATOR = 17

Progress indicator element.

AccessibilityRole ROLE_TEXT_FIELD = 18

Editable text field element.

AccessibilityRole ROLE_MULTILINE_TEXT_FIELD = 19

Multiline editable text field element.

AccessibilityRole ROLE_COLOR_PICKER = 20

Color picker element.

AccessibilityRole ROLE_TABLE = 21

Table element.

AccessibilityRole ROLE_CELL = 22

Table/tree cell element.

AccessibilityRole ROLE_ROW = 23

Table/tree row element.

AccessibilityRole ROLE_ROW_GROUP = 24

Table/tree row group element.

AccessibilityRole ROLE_ROW_HEADER = 25

Table/tree row header element.

AccessibilityRole ROLE_COLUMN_HEADER = 26

Table/tree column header element.

AccessibilityRole ROLE_TREE = 27

Tree view element.

AccessibilityRole ROLE_TREE_ITEM = 28

Tree view item element.

AccessibilityRole ROLE_LIST = 29

List element.

AccessibilityRole ROLE_LIST_ITEM = 30

List item element.

AccessibilityRole ROLE_LIST_BOX = 31

List view element.

AccessibilityRole ROLE_LIST_BOX_OPTION = 32

List view item element.

AccessibilityRole ROLE_TAB_BAR = 33

Tab bar element.

AccessibilityRole ROLE_TAB = 34

Tab bar item element.

AccessibilityRole ROLE_TAB_PANEL = 35

Tab panel element.

AccessibilityRole ROLE_MENU_BAR = 36

Menu bar element.

AccessibilityRole ROLE_MENU = 37

Popup menu element.

AccessibilityRole ROLE_MENU_ITEM = 38

Popup menu item element.

AccessibilityRole ROLE_MENU_ITEM_CHECK_BOX = 39

Popup menu check button item element.

AccessibilityRole ROLE_MENU_ITEM_RADIO = 40

Popup menu radio button item element.

AccessibilityRole ROLE_IMAGE = 41

Image element.

AccessibilityRole ROLE_WINDOW = 42

Window element.

AccessibilityRole ROLE_TITLE_BAR = 43

Embedded window title bar element.

AccessibilityRole ROLE_DIALOG = 44

Dialog window element.

AccessibilityRole ROLE_TOOLTIP = 45

Tooltip element.

AccessibilityRole ROLE_REGION = 46

Region/landmark element. Screen readers can navigate between regions using landmark navigation.

AccessibilityRole ROLE_TEXT_RUN = 47

Unifor text run.

Note: This role is used for internal text elements, and should not be assigned to nodes.

---

enum AccessibilityPopupType
AccessibilityPopupType POPUP_MENU = 0

Popup menu.

AccessibilityPopupType POPUP_LIST = 1

Popup list.

AccessibilityPopupType POPUP_TREE = 2

Popup tree view.

AccessibilityPopupType POPUP_DIALOG = 3

Popup dialog.

---

enum AccessibilityFlags
AccessibilityFlags FLAG_HIDDEN = 0

Element is hidden for accessibility tools.

AccessibilityFlags FLAG_MULTISELECTABLE = 1

Element supports multiple item selection.

AccessibilityFlags FLAG_REQUIRED = 2

Element require user input.

AccessibilityFlags FLAG_VISITED = 3

Element is a visited link.

AccessibilityFlags FLAG_BUSY = 4

Element content is not ready (e.g. loading).

AccessibilityFlags FLAG_MODAL = 5

Element is modal window.

AccessibilityFlags FLAG_TOUCH_PASSTHROUGH = 6

Element allows touches to be passed through when a screen reader is in touch exploration mode.

AccessibilityFlags FLAG_READONLY = 7

Element is text field with selectable but read-only text.

AccessibilityFlags FLAG_DISABLED = 8

Element is disabled.

AccessibilityFlags FLAG_CLIPS_CHILDREN = 9

Element clips children.

---

enum AccessibilityAction
AccessibilityAction ACTION_CLICK = 0

Single click action, callback argument is not set.

AccessibilityAction ACTION_FOCUS = 1

Focus action, callback argument is not set.

AccessibilityAction ACTION_BLUR = 2

Blur action, callback argument is not set.

AccessibilityAction ACTION_COLLAPSE = 3

Collapse action, callback argument is not set.

AccessibilityAction ACTION_EXPAND = 4

Expand action, callback argument is not set.

AccessibilityAction ACTION_DECREMENT = 5

Decrement action, callback argument is not set.

AccessibilityAction ACTION_INCREMENT = 6

Increment action, callback argument is not set.

AccessibilityAction ACTION_HIDE_TOOLTIP = 7

Hide tooltip action, callback argument is not set.

AccessibilityAction ACTION_SHOW_TOOLTIP = 8

Show tooltip action, callback argument is not set.

AccessibilityAction ACTION_SET_TEXT_SELECTION = 9

Set text selection action, callback argument is set to Dictionary with the following keys:

- "start_element" accessibility element of the selection start.
- "start_char" character offset relative to the accessibility element of the selection start.
- "end_element" accessibility element of the selection end.
- "end_char" character offset relative to the accessibility element of the selection end.

AccessibilityAction ACTION_REPLACE_SELECTED_TEXT = 10

Replace text action, callback argument is set to String with the replacement text.

AccessibilityAction ACTION_SCROLL_BACKWARD = 11

Scroll backward action, callback argument is not set.

AccessibilityAction ACTION_SCROLL_DOWN = 12

Scroll down action, callback argument is set to AccessibilityScrollUnit.

AccessibilityAction ACTION_SCROLL_FORWARD = 13

Scroll forward action, callback argument is not set.

AccessibilityAction ACTION_SCROLL_LEFT = 14

Scroll left action, callback argument is set to AccessibilityScrollUnit.

AccessibilityAction ACTION_SCROLL_RIGHT = 15

Scroll right action, callback argument is set to AccessibilityScrollUnit.

AccessibilityAction ACTION_SCROLL_UP = 16

Scroll up action, callback argument is set to AccessibilityScrollUnit.

AccessibilityAction ACTION_SCROLL_INTO_VIEW = 17

Scroll into view action, callback argument is set to AccessibilityScrollHint.

AccessibilityAction ACTION_SCROLL_TO_POINT = 18

Scroll to point action, callback argument is set to Vector2 with the relative point coordinates.

AccessibilityAction ACTION_SET_SCROLL_OFFSET = 19

Set scroll offset action, callback argument is set to Vector2 with the scroll offset.

AccessibilityAction ACTION_SET_VALUE = 20

Set value action, callback argument is set to String or number with the new value.

AccessibilityAction ACTION_SHOW_CONTEXT_MENU = 21

Show context menu action, callback argument is not set.

AccessibilityAction ACTION_CUSTOM = 22

Custom action, callback argument is set to the integer action ID.

---

enum AccessibilityLiveMode
AccessibilityLiveMode LIVE_OFF = 0

Indicates that updates to the live region should not be presented.

AccessibilityLiveMode LIVE_POLITE = 1

Indicates that updates to the live region should be presented at the next opportunity (for example at the end of speaking the current sentence).

AccessibilityLiveMode LIVE_ASSERTIVE = 2

Indicates that updates to the live region have the highest priority and should be presented immediately.

---

enum AccessibilityScrollUnit
AccessibilityScrollUnit SCROLL_UNIT_ITEM = 0

The amount by which to scroll. A single item of a list, line of text.

AccessibilityScrollUnit SCROLL_UNIT_PAGE = 1

The amount by which to scroll. A single page.

---

enum AccessibilityScrollHint
AccessibilityScrollHint SCROLL_HINT_TOP_LEFT = 0

A preferred position for the node scrolled into view. Top-left edge of the scroll container.

AccessibilityScrollHint SCROLL_HINT_BOTTOM_RIGHT = 1

A preferred position for the node scrolled into view. Bottom-right edge of the scroll container.

AccessibilityScrollHint SCROLL_HINT_TOP_EDGE = 2

A preferred position for the node scrolled into view. Top edge of the scroll container.

AccessibilityScrollHint SCROLL_HINT_BOTTOM_EDGE = 3

A preferred position for the node scrolled into view. Bottom edge of the scroll container.

AccessibilityScrollHint SCROLL_HINT_LEFT_EDGE = 4

A preferred position for the node scrolled into view. Left edge of the scroll container.

AccessibilityScrollHint SCROLL_HINT_RIGHT_EDGE = 5

A preferred position for the node scrolled into view. Right edge of the scroll container.

---

## Method Descriptions

RID create_element(window_id: int, role: AccessibilityRole) 

Creates a new, empty accessibility element resource.

Note: An accessibility element is created and freed automatically for each Node. In general, this function should not be called manually.

---

RID create_sub_element(parent_rid: RID, role: AccessibilityRole, insert_pos: int = -1) 

Creates a new, empty accessibility sub-element resource. Sub-elements can be used to provide accessibility information for objects which are not Nodes, such as list items, table cells, or menu items. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the free_element() method.

---

RID create_sub_text_edit_elements(parent_rid: RID, shaped_text: RID, min_height: float, insert_pos: int = -1, is_last_line: bool = false) 

Creates a new, empty accessibility sub-element from the shaped text buffer. Sub-elements are freed automatically when the parent element is freed, or can be freed early using the free_element() method.

If is_last_line is true, no trailing newline is appended to the text content. Set to true for the last line in multi-line text fields and for single-line text fields.

---

Variant element_get_meta(id: RID) const 

Returns the metadata of the accessibility element id.

---

void element_set_meta(id: RID, meta: Variant) 

Sets the metadata of the accessibility element id to meta.

---

void free_element(id: RID) 

Frees the accessibility element id created by create_element(), create_sub_element(), or create_sub_text_edit_elements().

---

RID get_window_root(window_id: int) const 

Returns the main accessibility element of the OS native window.

---

bool has_element(id: RID) const 

Returns true if id is a valid accessibility element.

---

bool is_supported() const 

Returns true if screen reader is support by this implementation.

---

void set_window_focused(window_id: int, focused: bool) 

Sets the window focused state for assistive apps.

Note: This method is implemented on Linux, macOS, and Windows.

Note: Advanced users only! Window objects call this method automatically.

---

void set_window_rect(window_id: int, rect_out: Rect2, rect_in: Rect2) 

Sets window outer (with decorations) and inner (without decorations) bounds for assistive apps.

Note: This method is implemented on Linux, macOS, and Windows.

Note: Advanced users only! Window objects call this method automatically.

---

void update_add_action(id: RID, action: AccessibilityAction, callable: Callable) 

Adds a callback for the accessibility action (action which can be performed by using a special screen reader command or buttons on the Braille display), and marks this action as supported. The action callback receives one Variant argument, which value depends on action type.

---

void update_add_child(id: RID, child_id: RID) 

Adds a child accessibility element.

Note: Node children and sub-elements are added to the child list automatically.

---

void update_add_custom_action(id: RID, action_id: int, action_description: String) 

Adds support for a custom accessibility action. action_id is passed as an argument to the callback of ACTION_CUSTOM action.

---

void update_add_related_controls(id: RID, related_id: RID) 

Adds an element that is controlled by this element.

---

void update_add_related_described_by(id: RID, related_id: RID) 

Adds an element that describes this element.

---

void update_add_related_details(id: RID, related_id: RID) 

Adds an element that details this element.

---

void update_add_related_flow_to(id: RID, related_id: RID) 

Adds an element that this element flow into.

---

void update_add_related_labeled_by(id: RID, related_id: RID) 

Adds an element that labels this element.

---

void update_add_related_radio_group(id: RID, related_id: RID) 

Adds an element that is part of the same radio group.

Note: This method should be called on each element of the group, using all other elements as related_id.

---

void update_set_active_descendant(id: RID, other_id: RID) 

Adds an element that is an active descendant of this element.

---

void update_set_background_color(id: RID, color: Color) 

Sets element background color.

---

void update_set_bounds(id: RID, rect: Rect2) 

Sets element bounding box, relative to the node position.

---

void update_set_braille_label(id: RID, name: String) 

Sets element accessibility label for Braille display.

---

void update_set_braille_role_description(id: RID, description: String) 

Sets element accessibility role description for Braille display.

---

void update_set_checked(id: RID, checekd: bool) 

Sets element checked state.

---

void update_set_classname(id: RID, classname: String) 

Sets element class name.

---

void update_set_color_value(id: RID, color: Color) 

Sets element color value.

---

void update_set_description(id: RID, description: String) 

Sets element accessibility description.

---

void update_set_error_message(id: RID, other_id: RID) 

Sets an element which contains an error message for this element.

---

void update_set_extra_info(id: RID, name: String) 

Sets element accessibility extra information added to the element name.

---

void update_set_flag(id: RID, flag: AccessibilityFlags, value: bool) 

Sets element flag.

---

void update_set_focus(id: RID) 

Sets currently focused element.

---

void update_set_foreground_color(id: RID, color: Color) 

Sets element foreground color.

---

void update_set_in_page_link_target(id: RID, other_id: RID) 

Sets target element for the link.

---

void update_set_language(id: RID, language: String) 

Sets element text language.

---

void update_set_list_item_count(id: RID, size: int) 

Sets number of items in the list.

---

void update_set_list_item_expanded(id: RID, expanded: bool) 

Sets list/tree item expanded status.

---

void update_set_list_item_index(id: RID, index: int) 

Sets the position of the element in the list.

---

void update_set_list_item_level(id: RID, level: int) 

Sets the hierarchical level of the element in the list.

---

void update_set_list_item_selected(id: RID, selected: bool) 

Sets list/tree item selected status.

---

void update_set_list_orientation(id: RID, vertical: bool) 

Sets the orientation of the list elements.

---

void update_set_live(id: RID, live: AccessibilityLiveMode) 

Sets the priority of the live region updates.

---

void update_set_member_of(id: RID, group_id: RID) 

Sets the element to be a member of the group.

---

void update_set_name(id: RID, name: String) 

Sets element accessibility name.

---

void update_set_next_on_line(id: RID, other_id: RID) 

Sets next element on the line.

---

void update_set_num_jump(id: RID, jump: float) 

Sets numeric value jump.

---

void update_set_num_range(id: RID, min: float, max: float) 

Sets numeric value range.

---

void update_set_num_step(id: RID, step: float) 

Sets numeric value step.

---

void update_set_num_value(id: RID, position: float) 

Sets numeric value.

---

void update_set_placeholder(id: RID, placeholder: String) 

Sets placeholder text.

---

void update_set_popup_type(id: RID, popup: AccessibilityPopupType) 

Sets popup type for popup buttons.

---

void update_set_previous_on_line(id: RID, other_id: RID) 

Sets previous element on the line.

---

void update_set_role(id: RID, role: AccessibilityRole) 

Sets element accessibility role.

---

void update_set_role_description(id: RID, description: String) 

Sets element accessibility role description text.

---

void update_set_scroll_x(id: RID, position: float) 

Sets scroll bar x position.

---

void update_set_scroll_x_range(id: RID, min: float, max: float) 

Sets scroll bar x range.

---

void update_set_scroll_y(id: RID, position: float) 

Sets scroll bar y position.

---

void update_set_scroll_y_range(id: RID, min: float, max: float) 

Sets scroll bar y range.

---

void update_set_shortcut(id: RID, shortcut: String) 

Sets the list of keyboard shortcuts used by element.

---

void update_set_state_description(id: RID, description: String) 

Sets human-readable description of the current checked state.

---

void update_set_table_cell_position(id: RID, row_index: int, column_index: int) 

Sets cell position in the table.

---

void update_set_table_cell_span(id: RID, row_span: int, column_span: int) 

Sets cell row/column span.

---

void update_set_table_column_count(id: RID, count: int) 

Sets number of columns in the table.

---

void update_set_table_column_index(id: RID, index: int) 

Sets position of the column.

---

void update_set_table_row_count(id: RID, count: int) 

Sets number of rows in the table.

---

void update_set_table_row_index(id: RID, index: int) 

Sets position of the row in the table.

---

void update_set_text_align(id: RID, align: HorizontalAlignment) 

Sets element text alignment.

---

void update_set_text_decorations(id: RID, underline: bool, strikethrough: bool, overline: bool, color: Color = Color(0, 0, 0, 1)) 

Sets text underline/overline/strikethrough.

---

void update_set_text_orientation(id: RID, vertical: bool) 

Sets text orientation.

---

void update_set_text_selection(id: RID, text_start_id: RID, start_char: int, text_end_id: RID, end_char: int) 

Sets text selection to the text field. text_start_id and text_end_id should be elements created by create_sub_text_edit_elements(). Character offsets are relative to the corresponding element.

---

void update_set_tooltip(id: RID, tooltip: String) 

Sets tooltip text.

---

void update_set_transform(id: RID, transform: Transform2D) 

Sets element 2D transform.

---

void update_set_url(id: RID, url: String) 

Sets link URL.

---

void update_set_value(id: RID, value: String) 

Sets element text value.
