# TabContainer

Inherits: Container < Control < CanvasItem < Node < Object

A container that creates a tab for each child control, displaying only the active tab's control.

## Description

Arranges child controls into a tabbed view, creating a tab for each one. The active tab's corresponding control is made visible, while all other child controls are hidden. Ignores non-control children.

Note: The drawing of the clickable tabs is handled by this node; TabBar is not needed.

## Tutorials

- Using Containers

## Properties

bool | all_tabs_in_front |
bool | clip_tabs | true
int | current_tab | -1
bool | deselect_enabled | false
bool | drag_to_rearrange_enabled | false
bool | switch_on_drag_hover | true
AlignmentMode | tab_alignment | 0
FocusMode | tab_focus_mode | 2
bool | tab_{index}/disabled | false
bool | tab_{index}/hidden | false
Texture2D | tab_{index}/icon |
String | tab_{index}/title | ""
TabPosition | tabs_position | 0
int | tabs_rearrange_group | -1
bool | tabs_visible | true
bool | use_hidden_tabs_for_min_size | false

## Methods

Control | get_current_tab_control() const
Popup | get_popup() const
int | get_previous_tab() const
TabBar | get_tab_bar() const
Texture2D | get_tab_button_icon(tab_idx: int) const
Control | get_tab_control(tab_idx: int) const
int | get_tab_count() const
Texture2D | get_tab_icon(tab_idx: int) const
int | get_tab_icon_max_width(tab_idx: int) const
int | get_tab_idx_at_point(point: Vector2) const
int | get_tab_idx_from_control(control: Control) const
Variant | get_tab_metadata(tab_idx: int) const
String | get_tab_title(tab_idx: int) const
String | get_tab_tooltip(tab_idx: int) const
bool | is_tab_disabled(tab_idx: int) const
bool | is_tab_hidden(tab_idx: int) const
bool | select_next_available()
bool | select_previous_available()
void | set_popup(popup: Node)
void | set_tab_button_icon(tab_idx: int, icon: Texture2D)
void | set_tab_disabled(tab_idx: int, disabled: bool)
void | set_tab_hidden(tab_idx: int, hidden: bool)
void | set_tab_icon(tab_idx: int, icon: Texture2D)
void | set_tab_icon_max_width(tab_idx: int, width: int)
void | set_tab_metadata(tab_idx: int, metadata: Variant)
void | set_tab_title(tab_idx: int, title: String)
void | set_tab_tooltip(tab_idx: int, tooltip: String)

## Theme Properties

Color | drop_mark_color | Color(1, 1, 1, 1)
Color | font_disabled_color | Color(0.875, 0.875, 0.875, 0.5)
Color | font_hovered_color | Color(0.95, 0.95, 0.95, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_selected_color | Color(0.95, 0.95, 0.95, 1)
Color | font_unselected_color | Color(0.7, 0.7, 0.7, 1)
Color | icon_disabled_color | Color(1, 1, 1, 1)
Color | icon_hovered_color | Color(1, 1, 1, 1)
Color | icon_selected_color | Color(1, 1, 1, 1)
Color | icon_unselected_color | Color(1, 1, 1, 1)
int | icon_max_width | 0
int | icon_separation | 4
int | outline_size | 0
int | side_margin | 8
int | tab_separation | 0
Font | font |
int | font_size |
Texture2D | decrement |
Texture2D | decrement_highlight |
Texture2D | drop_mark |
Texture2D | increment |
Texture2D | increment_highlight |
Texture2D | menu |
Texture2D | menu_highlight |
StyleBox | panel |
StyleBox | tab_disabled |
StyleBox | tab_focus |
StyleBox | tab_hovered |
StyleBox | tab_selected |
StyleBox | tab_unselected |
StyleBox | tabbar_background |

---

## Signals

active_tab_rearranged(idx_to: int) 

Emitted when the active tab is rearranged via mouse drag. See drag_to_rearrange_enabled.

---

pre_popup_pressed() 

Emitted when the TabContainer's Popup button is clicked. See set_popup() for details.

---

tab_button_pressed(tab: int) 

Emitted when the user clicks on the button icon on this tab.

---

tab_changed(tab: int) 

Emitted when switching to another tab.

---

tab_clicked(tab: int) 

Emitted when a tab is clicked, even if it is the current tab.

---

tab_hovered(tab: int) 

Emitted when a tab is hovered by the mouse.

---

tab_selected(tab: int) 

Emitted when a tab is selected via click, directional input, or script, even if it is the current tab.

---

## Enumerations

enum TabPosition
TabPosition POSITION_TOP = 0

Places the tab bar at the top.

TabPosition POSITION_BOTTOM = 1

Places the tab bar at the bottom. The tab bar's StyleBox will be flipped vertically.

TabPosition POSITION_MAX = 2

Represents the size of the TabPosition enum.

---

## Property Descriptions

bool all_tabs_in_front 

- void set_all_tabs_in_front(value: bool)
- bool is_all_tabs_in_front()

Deprecated: Due to internal changes this doesn't do anything anymore, as they're always in front.

This doesn't do anything.

---

bool clip_tabs = true 

- void set_clip_tabs(value: bool)
- bool get_clip_tabs()

If true, tabs overflowing this node's width will be hidden, displaying two navigation buttons instead. Otherwise, this node's minimum size is updated so that all tabs are visible.

---

int current_tab = -1 

- void set_current_tab(value: int)
- int get_current_tab()

The current tab index. When set, this index's Control node's visible property is set to true and all others are set to false.

A value of -1 means that no tab is selected.

---

bool deselect_enabled = false 

- void set_deselect_enabled(value: bool)
- bool get_deselect_enabled()

If true, all tabs can be deselected so that no tab is selected. Click on the current_tab to deselect it.

Only the tab header will be shown if no tabs are selected.

---

bool drag_to_rearrange_enabled = false 

- void set_drag_to_rearrange_enabled(value: bool)
- bool get_drag_to_rearrange_enabled()

If true, tabs can be rearranged with mouse drag.

---

bool switch_on_drag_hover = true 

- void set_switch_on_drag_hover(value: bool)
- bool get_switch_on_drag_hover()

If true, hovering over a tab while dragging something will switch to that tab. Does not have effect when hovering another tab to rearrange.

---

AlignmentMode tab_alignment = 0 

- void set_tab_alignment(value: AlignmentMode)
- AlignmentMode get_tab_alignment()

The position at which tabs will be placed.

---

FocusMode tab_focus_mode = 2 

- void set_tab_focus_mode(value: FocusMode)
- FocusMode get_tab_focus_mode()

The focus access mode for the internal TabBar node.

---

bool tab_{index}/disabled = false 

If true, the tab at index is disabled.

Note: index is a value in the 0 .. get_tab_count() - 1 range.

---

bool tab_{index}/hidden = false 

If true, the tab at index is hidden.

Note: index is a value in the 0 .. get_tab_count() - 1 range.

---

Texture2D tab_{index}/icon 

The title text of the tab at index.

Note: index is a value in the 0 .. get_tab_count() - 1 range.

---

String tab_{index}/title = "" 

The tooltip text of the tab at index.

Note: index is a value in the 0 .. get_tab_count() - 1 range.

---

TabPosition tabs_position = 0 

- void set_tabs_position(value: TabPosition)
- TabPosition get_tabs_position()

The horizontal alignment of the tabs.

---

int tabs_rearrange_group = -1 

- void set_tabs_rearrange_group(value: int)
- int get_tabs_rearrange_group()

TabContainers with the same rearrange group ID will allow dragging the tabs between them. Enable drag with drag_to_rearrange_enabled.

Setting this to -1 will disable rearranging between TabContainers.

---

bool tabs_visible = true 

- void set_tabs_visible(value: bool)
- bool are_tabs_visible()

If true, tabs are visible. If false, tabs' content and titles are hidden.

---

bool use_hidden_tabs_for_min_size = false 

- void set_use_hidden_tabs_for_min_size(value: bool)
- bool get_use_hidden_tabs_for_min_size()

If true, child Control nodes that are hidden have their minimum size take into account in the total, instead of only the currently visible one.

---

## Method Descriptions

Control get_current_tab_control() const 

Returns the child Control node located at the active tab index.

---

Popup get_popup() const 

Returns the Popup node instance if one has been set already with set_popup().

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their Window.visible property.

---

int get_previous_tab() const 

Returns the previously active tab index.

---

TabBar get_tab_bar() const 

Returns the TabBar contained in this container.

Warning: This is a required internal node, removing and freeing it or editing its tabs may cause a crash. If you wish to edit the tabs, use the methods provided in TabContainer.

---

Texture2D get_tab_button_icon(tab_idx: int) const 

Returns the button icon from the tab at index tab_idx.

---

Control get_tab_control(tab_idx: int) const 

Returns the Control node from the tab at index tab_idx.

---

int get_tab_count() const 

Returns the number of tabs.

---

Texture2D get_tab_icon(tab_idx: int) const 

Returns the Texture2D for the tab at index tab_idx or null if the tab has no Texture2D.

---

int get_tab_icon_max_width(tab_idx: int) const 

Returns the maximum allowed width of the icon for the tab at index tab_idx.

---

int get_tab_idx_at_point(point: Vector2) const 

Returns the index of the tab at local coordinates point. Returns -1 if the point is outside the control boundaries or if there's no tab at the queried position.

---

int get_tab_idx_from_control(control: Control) const 

Returns the index of the tab tied to the given control. The control must be a child of the TabContainer.

---

Variant get_tab_metadata(tab_idx: int) const 

Returns the metadata value set to the tab at index tab_idx using set_tab_metadata(). If no metadata was previously set, returns null by default.

---

String get_tab_title(tab_idx: int) const 

Returns the title of the tab at index tab_idx. Tab titles default to the name of the indexed child node, but this can be overridden with set_tab_title().

---

String get_tab_tooltip(tab_idx: int) const 

Returns the tooltip text of the tab at index tab_idx.

---

bool is_tab_disabled(tab_idx: int) const 

Returns true if the tab at index tab_idx is disabled.

---

bool is_tab_hidden(tab_idx: int) const 

Returns true if the tab at index tab_idx is hidden.

---

bool select_next_available() 

Selects the first available tab with greater index than the currently selected. Returns true if tab selection changed.

---

bool select_previous_available() 

Selects the first available tab with lower index than the currently selected. Returns true if tab selection changed.

---

void set_popup(popup: Node) 

If set on a Popup node instance, a popup menu icon appears in the top-right corner of the TabContainer (setting it to null will make it go away). Clicking it will expand the Popup node.

---

void set_tab_button_icon(tab_idx: int, icon: Texture2D) 

Sets the button icon from the tab at index tab_idx.

---

void set_tab_disabled(tab_idx: int, disabled: bool) 

If disabled is true, disables the tab at index tab_idx, making it non-interactable.

---

void set_tab_hidden(tab_idx: int, hidden: bool) 

If hidden is true, hides the tab at index tab_idx, making it disappear from the tab area.

---

void set_tab_icon(tab_idx: int, icon: Texture2D) 

Sets an icon for the tab at index tab_idx.

---

void set_tab_icon_max_width(tab_idx: int, width: int) 

Sets the maximum allowed width of the icon for the tab at index tab_idx. This limit is applied on top of the default size of the icon and on top of icon_max_width. The height is adjusted according to the icon's ratio.

---

void set_tab_metadata(tab_idx: int, metadata: Variant) 

Sets the metadata value for the tab at index tab_idx, which can be retrieved later using get_tab_metadata().

---

void set_tab_title(tab_idx: int, title: String) 

Sets a custom title for the tab at index tab_idx (tab titles default to the name of the indexed child node). Set it back to the child's name to make the tab default to it again.

---

void set_tab_tooltip(tab_idx: int, tooltip: String) 

Sets a custom tooltip text for tab at index tab_idx.

Note: By default, if the tooltip is empty and the tab text is truncated (not all characters fit into the tab), the title will be displayed as a tooltip. To hide the tooltip, assign " " as the tooltip text.

---

## Theme Property Descriptions

Color drop_mark_color = Color(1, 1, 1, 1) 

Modulation color for the drop_mark icon.

---

Color font_disabled_color = Color(0.875, 0.875, 0.875, 0.5) 

Font color of disabled tabs.

---

Color font_hovered_color = Color(0.95, 0.95, 0.95, 1) 

Font color of the currently hovered tab. Does not apply to the selected tab.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the tab name.

---

Color font_selected_color = Color(0.95, 0.95, 0.95, 1) 

Font color of the currently selected tab.

---

Color font_unselected_color = Color(0.7, 0.7, 0.7, 1) 

Font color of the other, unselected tabs.

---

Color icon_disabled_color = Color(1, 1, 1, 1) 

Icon color of disabled tabs.

---

Color icon_hovered_color = Color(1, 1, 1, 1) 

Icon color of the currently hovered tab. Does not apply to the selected tab.

---

Color icon_selected_color = Color(1, 1, 1, 1) 

Icon color of the currently selected tab.

---

Color icon_unselected_color = Color(1, 1, 1, 1) 

Icon color of the other, unselected tabs.

---

int icon_max_width = 0 

The maximum allowed width of the tab's icon. This limit is applied on top of the default size of the icon, but before the value set with TabBar.set_tab_icon_max_width(). The height is adjusted according to the icon's ratio.

---

int icon_separation = 4 

Space between tab's name and its icon.

---

int outline_size = 0 

The size of the tab text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int side_margin = 8 

The space at the left or right edges of the tab bar, accordingly with the current tab_alignment.

The margin is ignored with TabBar.ALIGNMENT_RIGHT if the tabs are clipped (see clip_tabs) or a popup has been set (see set_popup()). The margin is always ignored with TabBar.ALIGNMENT_CENTER.

---

int tab_separation = 0 

The space between tabs in the tab bar.

---

Font font 

The font used to draw tab names.

---

int font_size 

Font size of the tab names.

---

Texture2D decrement 

Icon for the left arrow button that appears when there are too many tabs to fit in the container width. When the button is disabled (i.e. the first tab is visible), it appears semi-transparent.

---

Texture2D decrement_highlight 

Icon for the left arrow button that appears when there are too many tabs to fit in the container width. Used when the button is being hovered with the cursor.

---

Texture2D drop_mark 

Icon shown to indicate where a dragged tab will be dropped (see drag_to_rearrange_enabled).

---

Texture2D increment 

Icon for the right arrow button that appears when there are too many tabs to fit in the container width. When the button is disabled (i.e. the last tab is visible) it appears semi-transparent.

---

Texture2D increment_highlight 

Icon for the right arrow button that appears when there are too many tabs to fit in the container width. Used when the button is being hovered with the cursor.

---

Texture2D menu 

The icon for the menu button (see set_popup()).

---

Texture2D menu_highlight 

The icon for the menu button (see set_popup()) when it's being hovered with the cursor.

---

StyleBox panel 

The style for the background fill.

---

StyleBox tab_disabled 

The style of disabled tabs.

---

StyleBox tab_focus 

StyleBox used when the TabBar is focused. The tab_focus StyleBox is displayed over the base StyleBox of the selected tab, so a partially transparent StyleBox should be used to ensure the base StyleBox remains visible. A StyleBox that represents an outline or an underline works well for this purpose. To disable the focus visual effect, assign a StyleBoxEmpty resource. Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.

---

StyleBox tab_hovered 

The style of the currently hovered tab.

Note: This style will be drawn with the same width as tab_unselected at minimum.

---

StyleBox tab_selected 

The style of the currently selected tab.

---

StyleBox tab_unselected 

The style of the other, unselected tabs.

---

StyleBox tabbar_background 

The style for the background fill of the TabBar area.
