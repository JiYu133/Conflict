# Control

Inherits: CanvasItem < Node < Object

Inherited By: BaseButton, ColorRect, Container, GraphEdit, ItemList, Label, LineEdit, MenuBar, NinePatchRect, Panel, Range, ReferenceRect, RichTextLabel, Separator, TabBar, TextEdit, TextureRect, Tree, VideoStreamPlayer, VirtualJoystick

Base class for all GUI controls. Adapts its position and size based on its parent control.

## Description

Base class for all UI-related nodes. Control features a bounding rectangle that defines its extents, an anchor position relative to its parent control or the current viewport, and offsets relative to the anchor. The offsets update automatically when the node, any of its parents, or the screen size change.

For more information on Godot's UI system, anchors, offsets, and containers, see the related tutorials in the manual. To build flexible UIs, you'll need a mix of UI elements that inherit from Control and Container nodes.

Note: Since both Node2D and Control inherit from CanvasItem, they share several concepts from the class such as the CanvasItem.z_index and CanvasItem.visible properties.

User Interface nodes and input

Godot propagates input events via viewports. Each Viewport is responsible for propagating InputEvents to their child nodes. As the SceneTree.root is a Window, this already happens automatically for all UI elements in your game.

Input events are propagated through the SceneTree from the root node to all child nodes by calling Node._input(). For UI elements specifically, it makes more sense to override the virtual method _gui_input(), which filters out unrelated input events, such as by checking z-order, mouse_filter, focus, or if the event was inside of the control's bounding box.

Call accept_event() so no other node receives the event. Once you accept an input, it becomes handled so Node._unhandled_input() will not process it.

Only one Control node can be in focus. Only the node in focus will receive events. To get the focus, call grab_focus(). Control nodes lose focus when another node grabs it, or if you hide the node in focus. Focus will not be represented visually if gained via mouse/touch input, only appearing with keyboard/gamepad input (for accessibility), or via grab_focus().

Set mouse_filter to MOUSE_FILTER_IGNORE to tell a Control node to ignore mouse or touch events. You'll need it if you place an icon on top of a button.

Theme resources change the control's appearance. The theme of a Control node affects all of its direct and indirect children (as long as a chain of controls is uninterrupted). To override some of the theme items, call one of the add_theme_*_override methods, like add_theme_font_override(). You can also override theme items in the Inspector.

Note: Theme items are not Object properties. This means you can't access their values using Object.get() and Object.set(). Instead, use the get_theme_* and add_theme_*_override methods provided by this class.

## Tutorials

- GUI documentation index
- Custom drawing in 2D
- Control node gallery
- Multiple resolutions
- All GUI Demos [https://github.com/godotengine/godot-demo-projects/tree/master/gui]

## Properties

Array[NodePath] | accessibility_controls_nodes | []
Array[NodePath] | accessibility_described_by_nodes | []
String | accessibility_description | ""
Array[NodePath] | accessibility_flow_to_nodes | []
Array[NodePath] | accessibility_labeled_by_nodes | []
AccessibilityLiveMode | accessibility_live | 0
String | accessibility_name | ""
float | anchor_bottom | 0.0
float | anchor_left | 0.0
float | anchor_right | 0.0
float | anchor_top | 0.0
bool | auto_translate |
bool | clip_contents | false
Vector2 | custom_maximum_size | Vector2(-1, -1)
Vector2 | custom_minimum_size | Vector2(0, 0)
FocusBehaviorRecursive | focus_behavior_recursive | 0
FocusMode | focus_mode | 0
NodePath | focus_neighbor_bottom | NodePath("")
NodePath | focus_neighbor_left | NodePath("")
NodePath | focus_neighbor_right | NodePath("")
NodePath | focus_neighbor_top | NodePath("")
NodePath | focus_next | NodePath("")
NodePath | focus_previous | NodePath("")
Vector2 | global_position |
GrowDirection | grow_horizontal | 1
GrowDirection | grow_vertical | 1
LayoutDirection | layout_direction | 0
bool | localize_numeral_system | true
MouseBehaviorRecursive | mouse_behavior_recursive | 0
CursorShape | mouse_default_cursor_shape | 0
MouseFilter | mouse_filter | 0
bool | mouse_force_pass_scroll_events | true
float | offset_bottom | 0.0
float | offset_left | 0.0
float | offset_right | 0.0
float | offset_top | 0.0
bool | offset_transform_enabled | false
Vector2 | offset_transform_pivot | Vector2(0, 0)
Vector2 | offset_transform_pivot_ratio | Vector2(0.5, 0.5)
Vector2 | offset_transform_position | Vector2(0, 0)
Vector2 | offset_transform_position_ratio | Vector2(0, 0)
float | offset_transform_rotation | 0.0
Vector2 | offset_transform_scale | Vector2(1, 1)
bool | offset_transform_visual_only | true
PhysicsInterpolationMode | physics_interpolation_mode | 2 (overrides Node)
Vector2 | pivot_offset | Vector2(0, 0)
Vector2 | pivot_offset_ratio | Vector2(0, 0)
Vector2 | position | Vector2(0, 0)
bool | propagate_maximum_size | false
float | rotation | 0.0
float | rotation_degrees |
Vector2 | scale | Vector2(1, 1)
Node | shortcut_context |
Vector2 | size | Vector2(0, 0)
BitField[SizeFlags] | size_flags_horizontal | 1
float | size_flags_stretch_ratio | 1.0
BitField[SizeFlags] | size_flags_vertical | 1
Theme | theme |
StringName | theme_type_variation | &""
AutoTranslateMode | tooltip_auto_translate_mode | 0
String | tooltip_text | ""
StringName | translation_context | &""

## Methods

String | _accessibility_get_contextual_info() virtual const
bool | _can_drop_data(at_position: Vector2, data: Variant) virtual const
void | _drop_data(at_position: Vector2, data: Variant) virtual
String | _get_accessibility_container_name(node: Node) virtual const
int | _get_cursor_shape(at_position: Vector2) virtual const
Variant | _get_drag_data(at_position: Vector2) virtual
Vector2 | _get_maximum_size() virtual const
Vector2 | _get_minimum_size() virtual const
String | _get_tooltip(at_position: Vector2) virtual const
AutoTranslateMode | _get_tooltip_auto_translate_mode_at(at_position: Vector2) virtual const
void | _gui_input(event: InputEvent) virtual
bool | _has_point(point: Vector2) virtual const
Object | _make_custom_tooltip(for_text: String) virtual const
Array[Vector3i] | _structured_text_parser(args: Array, text: String) virtual const
void | accept_event()
void | accessibility_drag()
void | accessibility_drop()
void | add_theme_color_override(name: StringName, color: Color)
void | add_theme_constant_override(name: StringName, constant: int)
void | add_theme_font_override(name: StringName, font: Font)
void | add_theme_font_size_override(name: StringName, font_size: int)
void | add_theme_icon_override(name: StringName, texture: Texture2D)
void | add_theme_stylebox_override(name: StringName, stylebox: StyleBox)
void | begin_bulk_theme_override()
void | end_bulk_theme_override()
Control | find_next_valid_focus() const
Control | find_prev_valid_focus() const
Control | find_valid_focus_neighbor(side: Side) const
void | force_drag(data: Variant, preview: Control)
float | get_anchor(side: Side) const
Vector2 | get_begin() const
Vector2 | get_bound_minimum_size() const
Vector2 | get_combined_maximum_size() const
Vector2 | get_combined_minimum_size() const
Vector2 | get_combined_pivot_offset() const
CursorShape | get_cursor_shape(at_position: Vector2 = Vector2(0, 0)) const
Vector2 | get_end() const
FocusMode | get_focus_mode_with_override() const
NodePath | get_focus_neighbor(side: Side) const
Rect2 | get_global_rect() const
Vector2 | get_maximum_size() const
Vector2 | get_minimum_size() const
MouseFilter | get_mouse_filter_with_override() const
float | get_offset(offset: Side) const
Vector2 | get_parent_area_size() const
Control | get_parent_control() const
Rect2 | get_rect() const
Vector2 | get_screen_position() const
Color | get_theme_color(name: StringName, theme_type: StringName = &"") const
int | get_theme_constant(name: StringName, theme_type: StringName = &"") const
float | get_theme_default_base_scale() const
Font | get_theme_default_font() const
int | get_theme_default_font_size() const
Font | get_theme_font(name: StringName, theme_type: StringName = &"") const
int | get_theme_font_size(name: StringName, theme_type: StringName = &"") const
Texture2D | get_theme_icon(name: StringName, theme_type: StringName = &"") const
StyleBox | get_theme_stylebox(name: StringName, theme_type: StringName = &"") const
String | get_tooltip(at_position: Vector2 = Vector2(0, 0)) const
void | grab_click_focus()
void | grab_focus(hide_focus: bool = false)
bool | has_focus(ignore_hidden_focus: bool = false) const
bool | has_theme_color(name: StringName, theme_type: StringName = &"") const
bool | has_theme_color_override(name: StringName) const
bool | has_theme_constant(name: StringName, theme_type: StringName = &"") const
bool | has_theme_constant_override(name: StringName) const
bool | has_theme_font(name: StringName, theme_type: StringName = &"") const
bool | has_theme_font_override(name: StringName) const
bool | has_theme_font_size(name: StringName, theme_type: StringName = &"") const
bool | has_theme_font_size_override(name: StringName) const
bool | has_theme_icon(name: StringName, theme_type: StringName = &"") const
bool | has_theme_icon_override(name: StringName) const
bool | has_theme_stylebox(name: StringName, theme_type: StringName = &"") const
bool | has_theme_stylebox_override(name: StringName) const
bool | is_drag_successful() const
bool | is_layout_rtl() const
void | release_focus()
void | remove_theme_color_override(name: StringName)
void | remove_theme_constant_override(name: StringName)
void | remove_theme_font_override(name: StringName)
void | remove_theme_font_size_override(name: StringName)
void | remove_theme_icon_override(name: StringName)
void | remove_theme_stylebox_override(name: StringName)
void | reset_size()
void | set_anchor(side: Side, anchor: float, keep_offset: bool = false, push_opposite_anchor: bool = true)
void | set_anchor_and_offset(side: Side, anchor: float, offset: float, push_opposite_anchor: bool = false)
void | set_anchors_and_offsets_preset(preset: LayoutPreset, resize_mode: LayoutPresetMode = 0, margin: int = 0)
void | set_anchors_preset(preset: LayoutPreset, keep_offsets: bool = false)
void | set_begin(position: Vector2)
void | set_drag_forwarding(drag_func: Callable, can_drop_func: Callable, drop_func: Callable)
void | set_drag_preview(control: Control)
void | set_end(position: Vector2)
void | set_focus_neighbor(side: Side, neighbor: NodePath)
void | set_global_position(position: Vector2, keep_offsets: bool = false)
void | set_offset(side: Side, offset: float)
void | set_offsets_preset(preset: LayoutPreset, resize_mode: LayoutPresetMode = 0, margin: int = 0)
void | set_position(position: Vector2, keep_offsets: bool = false)
void | set_size(size: Vector2, keep_offsets: bool = false)
void | update_maximum_size()
void | update_minimum_size()
void | warp_mouse(position: Vector2)

---

## Signals

focus_entered() 

Emitted when the node gains focus.

---

focus_exited() 

Emitted when the node loses focus.

---

gui_input(event: InputEvent) 

Emitted when the node receives an InputEvent.

---

maximum_size_changed() 

Emitted when the node's maximum size changes.

---

minimum_size_changed() 

Emitted when the node's minimum size changes.

---

mouse_entered() 

Emitted when the mouse cursor enters the control's (or any child control's) visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect, which Control receives the signal.

---

mouse_exited() 

Emitted when the mouse cursor leaves the control's (and all child control's) visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect, which Control receives the signal.

Note: If you want to check whether the mouse truly left the area, ignoring any top nodes, you can use code like this:

```gdscript
func _on_mouse_exited():
    if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
        # Not hovering over area.
```

---

resized() 

Emitted when the control changes size.

---

size_flags_changed() 

Emitted when one of the size flags changes. See size_flags_horizontal and size_flags_vertical.

---

theme_changed() 

Emitted when the NOTIFICATION_THEME_CHANGED notification is sent.

---

## Enumerations

enum FocusMode
FocusMode FOCUS_NONE = 0

The node cannot grab focus. Use with focus_mode.

FocusMode FOCUS_CLICK = 1

The node can only grab focus on mouse clicks. Use with focus_mode.

FocusMode FOCUS_ALL = 2

The node can grab focus on mouse click, using the arrows and the Tab keys on the keyboard, or using the D-pad buttons on a gamepad. Use with focus_mode.

FocusMode FOCUS_ACCESSIBILITY = 3

The node can grab focus only when screen reader is active. Use with focus_mode.

---

enum FocusBehaviorRecursive
FocusBehaviorRecursive FOCUS_BEHAVIOR_INHERITED = 0

Inherits the focus_behavior_recursive from the parent control. If there is no parent control, this is the same as FOCUS_BEHAVIOR_ENABLED.

FocusBehaviorRecursive FOCUS_BEHAVIOR_DISABLED = 1

Prevents the control from getting focused. get_focus_mode_with_override() will return FOCUS_NONE.

FocusBehaviorRecursive FOCUS_BEHAVIOR_ENABLED = 2

Allows the control to be focused, depending on the focus_mode. This can be used to ignore the parent's focus_behavior_recursive. get_focus_mode_with_override() will return the focus_mode.

---

enum MouseBehaviorRecursive
MouseBehaviorRecursive MOUSE_BEHAVIOR_INHERITED = 0

Inherits the mouse_behavior_recursive from the parent control. If there is no parent control, this is the same as MOUSE_BEHAVIOR_ENABLED.

MouseBehaviorRecursive MOUSE_BEHAVIOR_DISABLED = 1

Prevents the control from receiving mouse input. get_mouse_filter_with_override() will return MOUSE_FILTER_IGNORE.

MouseBehaviorRecursive MOUSE_BEHAVIOR_ENABLED = 2

Allows the control to receive mouse input, depending on the mouse_filter. This can be used to ignore the parent's mouse_behavior_recursive. get_mouse_filter_with_override() will return the mouse_filter.

---

enum CursorShape
CursorShape CURSOR_ARROW = 0

Show the system's arrow mouse cursor when the user hovers the node. Use with mouse_default_cursor_shape.

CursorShape CURSOR_IBEAM = 1

Show the system's I-beam mouse cursor when the user hovers the node. The I-beam pointer has a shape similar to "I". It tells the user they can highlight or insert text.

CursorShape CURSOR_POINTING_HAND = 2

Show the system's pointing hand mouse cursor when the user hovers the node.

CursorShape CURSOR_CROSS = 3

Show the system's cross mouse cursor when the user hovers the node.

CursorShape CURSOR_WAIT = 4

Show the system's wait mouse cursor when the user hovers the node. Often an hourglass.

CursorShape CURSOR_BUSY = 5

Show the system's busy mouse cursor when the user hovers the node. Often an arrow with a small hourglass.

CursorShape CURSOR_DRAG = 6

Show the system's drag mouse cursor, often a closed fist or a cross symbol, when the user hovers the node. It tells the user they're currently dragging an item, like a node in the Scene dock.

CursorShape CURSOR_CAN_DROP = 7

Show the system's drop mouse cursor when the user hovers the node. It can be an open hand. It tells the user they can drop an item they're currently grabbing, like a node in the Scene dock.

CursorShape CURSOR_FORBIDDEN = 8

Show the system's forbidden mouse cursor when the user hovers the node. Often a crossed circle.

CursorShape CURSOR_VSIZE = 9

Show the system's vertical resize mouse cursor when the user hovers the node. A double-headed vertical arrow. It tells the user they can resize the window or the panel vertically.

CursorShape CURSOR_HSIZE = 10

Show the system's horizontal resize mouse cursor when the user hovers the node. A double-headed horizontal arrow. It tells the user they can resize the window or the panel horizontally.

CursorShape CURSOR_BDIAGSIZE = 11

Show the system's window resize mouse cursor when the user hovers the node. The cursor is a double-headed arrow that goes from the bottom left to the top right. It tells the user they can resize the window or the panel both horizontally and vertically.

CursorShape CURSOR_FDIAGSIZE = 12

Show the system's window resize mouse cursor when the user hovers the node. The cursor is a double-headed arrow that goes from the top left to the bottom right, the opposite of CURSOR_BDIAGSIZE. It tells the user they can resize the window or the panel both horizontally and vertically.

CursorShape CURSOR_MOVE = 13

Show the system's move mouse cursor when the user hovers the node. It shows 2 double-headed arrows at a 90 degree angle. It tells the user they can move a UI element freely.

CursorShape CURSOR_VSPLIT = 14

Show the system's vertical split mouse cursor when the user hovers the node. On Windows, it's the same as CURSOR_VSIZE.

CursorShape CURSOR_HSPLIT = 15

Show the system's horizontal split mouse cursor when the user hovers the node. On Windows, it's the same as CURSOR_HSIZE.

CursorShape CURSOR_HELP = 16

Show the system's help mouse cursor when the user hovers the node, a question mark.

---

enum LayoutPreset
LayoutPreset PRESET_TOP_LEFT = 0

Snap all 4 anchors to the top-left of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_TOP_RIGHT = 1

Snap all 4 anchors to the top-right of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_BOTTOM_LEFT = 2

Snap all 4 anchors to the bottom-left of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_BOTTOM_RIGHT = 3

Snap all 4 anchors to the bottom-right of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_CENTER_LEFT = 4

Snap all 4 anchors to the center of the left edge of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_CENTER_TOP = 5

Snap all 4 anchors to the center of the top edge of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_CENTER_RIGHT = 6

Snap all 4 anchors to the center of the right edge of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_CENTER_BOTTOM = 7

Snap all 4 anchors to the center of the bottom edge of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_CENTER = 8

Snap all 4 anchors to the center of the parent control's bounds. Use with set_anchors_preset().

LayoutPreset PRESET_LEFT_WIDE = 9

Snap all 4 anchors to the left edge of the parent control. The left offset becomes relative to the left edge and the top offset relative to the top left corner of the node's parent. Use with set_anchors_preset().

LayoutPreset PRESET_TOP_WIDE = 10

Snap all 4 anchors to the top edge of the parent control. The left offset becomes relative to the top left corner, the top offset relative to the top edge, and the right offset relative to the top right corner of the node's parent. Use with set_anchors_preset().

LayoutPreset PRESET_RIGHT_WIDE = 11

Snap all 4 anchors to the right edge of the parent control. The right offset becomes relative to the right edge and the top offset relative to the top right corner of the node's parent. Use with set_anchors_preset().

LayoutPreset PRESET_BOTTOM_WIDE = 12

Snap all 4 anchors to the bottom edge of the parent control. The left offset becomes relative to the bottom left corner, the bottom offset relative to the bottom edge, and the right offset relative to the bottom right corner of the node's parent. Use with set_anchors_preset().

LayoutPreset PRESET_VCENTER_WIDE = 13

Snap all 4 anchors to a vertical line that cuts the parent control in half. Use with set_anchors_preset().

LayoutPreset PRESET_HCENTER_WIDE = 14

Snap all 4 anchors to a horizontal line that cuts the parent control in half. Use with set_anchors_preset().

LayoutPreset PRESET_FULL_RECT = 15

Snap all 4 anchors to the respective corners of the parent control. Set all 4 offsets to 0 after you applied this preset and the Control will fit its parent control. Use with set_anchors_preset().

---

enum LayoutPresetMode
LayoutPresetMode PRESET_MODE_MINSIZE = 0

The control will be resized to its minimum size.

LayoutPresetMode PRESET_MODE_KEEP_WIDTH = 1

The control's width will not change.

LayoutPresetMode PRESET_MODE_KEEP_HEIGHT = 2

The control's height will not change.

LayoutPresetMode PRESET_MODE_KEEP_SIZE = 3

The control's size will not change.

---

flags SizeFlags: 

SizeFlags SIZE_SHRINK_BEGIN = 0

Tells the parent Container to align the node with its start, either the top or the left edge. It is mutually exclusive with SIZE_FILL and other shrink size flags, but can be used with SIZE_EXPAND in some containers. Use with size_flags_horizontal and size_flags_vertical.

Note: Setting this flag is equal to not having any size flags.

SizeFlags SIZE_FILL = 1

Tells the parent Container to expand the bounds of this node to fill all the available space without pushing any other node. It is mutually exclusive with shrink size flags. Use with size_flags_horizontal and size_flags_vertical.

SizeFlags SIZE_EXPAND = 2

Tells the parent Container to let this node take all the available space on the axis you flag. If multiple neighboring nodes are set to expand, they'll share the space based on their stretch ratio. See size_flags_stretch_ratio. Use with size_flags_horizontal and size_flags_vertical.

SizeFlags SIZE_EXPAND_FILL = 3

Sets the node's size flags to both fill and expand. See SIZE_FILL and SIZE_EXPAND for more information.

SizeFlags SIZE_SHRINK_CENTER = 4

Tells the parent Container to center the node in the available space. It is mutually exclusive with SIZE_FILL and other shrink size flags, but can be used with SIZE_EXPAND in some containers. Use with size_flags_horizontal and size_flags_vertical.

SizeFlags SIZE_SHRINK_END = 8

Tells the parent Container to align the node with its end, either the bottom or the right edge. It is mutually exclusive with SIZE_FILL and other shrink size flags, but can be used with SIZE_EXPAND in some containers. Use with size_flags_horizontal and size_flags_vertical.

---

enum MouseFilter
MouseFilter MOUSE_FILTER_STOP = 0

The control will receive mouse movement input events and mouse button input events if clicked on through _gui_input(). The control will also receive the mouse_entered and mouse_exited signals. These events are automatically marked as handled, and they will not propagate further to other controls. This also results in blocking signals in other controls.

MouseFilter MOUSE_FILTER_PASS = 1

The control will receive mouse movement input events and mouse button input events if clicked on through _gui_input(). The control will also receive the mouse_entered and mouse_exited signals.

If this control does not handle the event, the event will propagate up to its parent control if it has one. The event is bubbled up the node hierarchy until it reaches a non-CanvasItem, a control with MOUSE_FILTER_STOP, or a CanvasItem with CanvasItem.top_level enabled. This will allow signals to fire in all controls it reaches. If no control handled it, the event will be passed to Node._shortcut_input() for further processing.

MouseFilter MOUSE_FILTER_IGNORE = 2

The control will not receive any mouse movement input events nor mouse button input events through _gui_input(). The control will also not receive the mouse_entered nor mouse_exited signals. This will not block other controls from receiving these events or firing the signals. Ignored events will not be handled automatically. If a child has MOUSE_FILTER_PASS and an event was passed to this control, the event will further propagate up to the control's parent.

Note: If the control has received mouse_entered but not mouse_exited, changing the mouse_filter to MOUSE_FILTER_IGNORE will cause mouse_exited to be emitted.

---

enum GrowDirection
GrowDirection GROW_DIRECTION_BEGIN = 0

The control will grow to the left or top to make up if its minimum size is changed to be greater than its current size on the respective axis.

GrowDirection GROW_DIRECTION_END = 1

The control will grow to the right or bottom to make up if its minimum size is changed to be greater than its current size on the respective axis.

GrowDirection GROW_DIRECTION_BOTH = 2

The control will grow in both directions equally to make up if its minimum size is changed to be greater than its current size.

---

enum Anchor
Anchor ANCHOR_BEGIN = 0

Snaps one of the 4 anchor's sides to the origin of the node's Rect, in the top left. Use it with one of the anchor_* member variables, like anchor_left. To change all 4 anchors at once, use set_anchors_preset().

Anchor ANCHOR_END = 1

Snaps one of the 4 anchor's sides to the end of the node's Rect, in the bottom right. Use it with one of the anchor_* member variables, like anchor_left. To change all 4 anchors at once, use set_anchors_preset().

---

enum LayoutDirection
LayoutDirection LAYOUT_DIRECTION_INHERITED = 0

Automatic layout direction, determined from the parent control layout direction.

LayoutDirection LAYOUT_DIRECTION_APPLICATION_LOCALE = 1

Automatic layout direction, determined from the current locale. Right-to-left layout direction is automatically used for languages that require it such as Arabic and Hebrew, but only if a valid translation file is loaded for the given language (unless said language is configured as a fallback in ProjectSettings.internationalization/locale/fallback). For all other languages (or if no valid translation file is found by Godot), left-to-right layout direction is used. If using TextServerFallback (ProjectSettings.internationalization/rendering/text_driver), left-to-right layout direction is always used regardless of the language. Right-to-left layout direction can also be forced using ProjectSettings.internationalization/rendering/force_right_to_left_layout_direction.

LayoutDirection LAYOUT_DIRECTION_LTR = 2

Left-to-right layout direction.

LayoutDirection LAYOUT_DIRECTION_RTL = 3

Right-to-left layout direction.

LayoutDirection LAYOUT_DIRECTION_SYSTEM_LOCALE = 4

Automatic layout direction, determined from the system locale. Right-to-left layout direction is automatically used for languages that require it such as Arabic and Hebrew, but only if a valid translation file is loaded for the given language. For all other languages (or if no valid translation file is found by Godot), left-to-right layout direction is used. If using TextServerFallback (ProjectSettings.internationalization/rendering/text_driver), left-to-right layout direction is always used regardless of the language.

LayoutDirection LAYOUT_DIRECTION_MAX = 5

Represents the size of the LayoutDirection enum.

LayoutDirection LAYOUT_DIRECTION_LOCALE = 1

Deprecated: Use LAYOUT_DIRECTION_APPLICATION_LOCALE instead.

---

enum TextDirection
TextDirection TEXT_DIRECTION_INHERITED = 3

Text writing direction is the same as layout direction.

TextDirection TEXT_DIRECTION_AUTO = 0

Automatic text writing direction, determined from the current locale and text content.

TextDirection TEXT_DIRECTION_LTR = 1

Left-to-right text writing direction.

TextDirection TEXT_DIRECTION_RTL = 2

Right-to-left text writing direction.

---

## Constants

NOTIFICATION_RESIZED = 40 

Sent when the node changes size. Use size to get the new size.

NOTIFICATION_MOUSE_ENTER = 41 

Sent when the mouse cursor enters the control's (or any child control's) visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect which Control receives the notification.

See also NOTIFICATION_MOUSE_ENTER_SELF.

NOTIFICATION_MOUSE_EXIT = 42 

Sent when the mouse cursor leaves the control's (and all child control's) visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect which Control receives the notification.

See also NOTIFICATION_MOUSE_EXIT_SELF.

NOTIFICATION_MOUSE_ENTER_SELF = 60 

Experimental: The reason this notification is sent may change in the future.

Sent when the mouse cursor enters the control's visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect which Control receives the notification.

See also NOTIFICATION_MOUSE_ENTER.

NOTIFICATION_MOUSE_EXIT_SELF = 61 

Experimental: The reason this notification is sent may change in the future.

Sent when the mouse cursor leaves the control's visible area, that is not occluded behind other Controls or Windows, provided its mouse_filter lets the event reach it and regardless if it's currently focused or not.

Note: CanvasItem.z_index doesn't affect which Control receives the notification.

See also NOTIFICATION_MOUSE_EXIT.

NOTIFICATION_FOCUS_ENTER = 43 

Sent when the node grabs focus.

NOTIFICATION_FOCUS_EXIT = 44 

Sent when the node loses focus.

This notification is sent in reversed order.

NOTIFICATION_THEME_CHANGED = 45 

Sent when the node needs to refresh its theme items. This happens in one of the following cases:

- The theme property is changed on this node or any of its ancestors.
- The theme_type_variation property is changed on this node.
- One of the node's theme property overrides is changed.
- The node enters the scene tree.

Note: As an optimization, this notification won't be sent from changes that occur while this node is outside of the scene tree. Instead, all of the theme item updates can be applied at once when the node enters the scene tree.

Note: This notification is received alongside Node.NOTIFICATION_ENTER_TREE, so if you are instantiating a scene, the child nodes will not be initialized yet. You can use it to setup theming for this node, child nodes created from script, or if you want to access child nodes added in the editor, make sure the node is ready using Node.is_node_ready().

```gdscript
func _notification(what):
    if what == NOTIFICATION_THEME_CHANGED:
        if not is_node_ready():
            await ready # Wait until ready signal.
        $Label.add_theme_color_override("font_color", Color.YELLOW)
```

NOTIFICATION_SCROLL_BEGIN = 47 

Sent when this node is inside a ScrollContainer which has begun being scrolled when dragging the scrollable area with a touch event. This notification is not sent when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.

Note: This signal is only emitted on Android or iOS, or on desktop/web platforms when ProjectSettings.input_devices/pointing/emulate_touch_from_mouse is enabled.

NOTIFICATION_SCROLL_END = 48 

Sent when this node is inside a ScrollContainer which has stopped being scrolled when dragging the scrollable area with a touch event. This notification is not sent when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.

Note: This signal is only emitted on Android or iOS, or on desktop/web platforms when ProjectSettings.input_devices/pointing/emulate_touch_from_mouse is enabled.

NOTIFICATION_LAYOUT_DIRECTION_CHANGED = 49 

Sent when the control layout direction is changed from LTR or RTL or vice versa. This notification is propagated to child Control nodes as result of a change to layout_direction.

---

## Property Descriptions

Array[NodePath] accessibility_controls_nodes = [] 

- void set_accessibility_controls_nodes(value: Array[NodePath])
- Array[NodePath] get_accessibility_controls_nodes()

The paths to the nodes which are controlled by this node.

---

Array[NodePath] accessibility_described_by_nodes = [] 

- void set_accessibility_described_by_nodes(value: Array[NodePath])
- Array[NodePath] get_accessibility_described_by_nodes()

The paths to the nodes which are describing this node.

---

String accessibility_description = "" 

- void set_accessibility_description(value: String)
- String get_accessibility_description()

The human-readable node description that is reported to assistive apps.

---

Array[NodePath] accessibility_flow_to_nodes = [] 

- void set_accessibility_flow_to_nodes(value: Array[NodePath])
- Array[NodePath] get_accessibility_flow_to_nodes()

The paths to the nodes which this node flows into.

---

Array[NodePath] accessibility_labeled_by_nodes = [] 

- void set_accessibility_labeled_by_nodes(value: Array[NodePath])
- Array[NodePath] get_accessibility_labeled_by_nodes()

The paths to the nodes which label this node.

---

AccessibilityLiveMode accessibility_live = 0 

- void set_accessibility_live(value: AccessibilityLiveMode)
- AccessibilityLiveMode get_accessibility_live()

The mode with which a live region updates. A live region is a Node that is updated as a result of an external event when the user's focus may be elsewhere.

---

String accessibility_name = "" 

- void set_accessibility_name(value: String)
- String get_accessibility_name()

The human-readable node name that is reported to assistive apps.

---

float anchor_bottom = 0.0 

- float get_anchor(side: Side) const

Anchors the bottom edge of the node to the origin, the center, or the end of its parent control. It changes how the bottom offset updates when the node moves or changes size. You can use one of the Anchor constants for convenience.

---

float anchor_left = 0.0 

- float get_anchor(side: Side) const

Anchors the left edge of the node to the origin, the center or the end of its parent control. It changes how the left offset updates when the node moves or changes size. You can use one of the Anchor constants for convenience.

---

float anchor_right = 0.0 

- float get_anchor(side: Side) const

Anchors the right edge of the node to the origin, the center or the end of its parent control. It changes how the right offset updates when the node moves or changes size. You can use one of the Anchor constants for convenience.

---

float anchor_top = 0.0 

- float get_anchor(side: Side) const

Anchors the top edge of the node to the origin, the center or the end of its parent control. It changes how the top offset updates when the node moves or changes size. You can use one of the Anchor constants for convenience.

---

bool auto_translate 

- void set_auto_translate(value: bool)
- bool is_auto_translating()

Deprecated: Use Node.auto_translate_mode and Node.can_auto_translate() instead.

Toggles if any text should automatically change to its translated version depending on the current locale.

---

bool clip_contents = false 

- void set_clip_contents(value: bool)
- bool is_clipping_contents()

Enables whether rendering of CanvasItem based children should be clipped to this control's rectangle. If true, parts of a child which would be visibly outside of this control's rectangle will not be rendered and won't receive input.

---

Vector2 custom_maximum_size = Vector2(-1, -1) 

- void set_custom_maximum_size(value: Vector2)
- Vector2 get_custom_maximum_size()

The maximum size of this Control's bounding rectangle. If set to a value greater than or equal to (0, 0), the node's bounding rectangle will never exceed this size. A value below (0, 0) means there is no maximum size.

Note: The final effective maximum size may be subject to parent Container sizing and propagated maximum sizes. See also: get_combined_maximum_size().

Note: Not all Control subtypes handle a custom maximum size gracefully, which may lead to unexpected behavior if the control's contents exceed this size.

Note: This value has priority over custom_minimum_size. For example, if you set custom_maximum_size to (100, 100) and custom_minimum_size to (200, 200), the resulting size will be (100, 100).

Note: It is recommended to use get_bound_minimum_size() instead of get_combined_minimum_size() when using this property, as the former respects maximum size limits when calculating the minimum size, while the latter does not.

---

Vector2 custom_minimum_size = Vector2(0, 0) 

- void set_custom_minimum_size(value: Vector2)
- Vector2 get_custom_minimum_size()

The minimum size of the node's bounding rectangle. If you set it to a value greater than (0, 0), the node's bounding rectangle will always have at least this size. Note that Control nodes have their internal minimum size returned by get_minimum_size(). It depends on the control's contents, like text, textures, or style boxes. The actual minimum size is the maximum value of this property and the internal minimum size (see get_combined_minimum_size()).

Note: custom_maximum_size has priority over this property. For example, if you set custom_minimum_size to (200, 200) and custom_maximum_size to (100, 100), the resulting size will be (100, 100).

---

FocusBehaviorRecursive focus_behavior_recursive = 0 

- void set_focus_behavior_recursive(value: FocusBehaviorRecursive)
- FocusBehaviorRecursive get_focus_behavior_recursive()

Determines which controls can be focused together with focus_mode. See get_focus_mode_with_override(). Since the default behavior is FOCUS_BEHAVIOR_INHERITED, this can be used to prevent all children controls from getting focused.

---

FocusMode focus_mode = 0 

- void set_focus_mode(value: FocusMode)
- FocusMode get_focus_mode()

Determines which controls can be focused. Only one control can be focused at a time, and the focused control will receive keyboard, gamepad, and mouse events in _gui_input(). Use get_focus_mode_with_override() to determine if a control can grab focus, since focus_behavior_recursive also affects it. See also grab_focus().

---

NodePath focus_neighbor_bottom = NodePath("") 

- void set_focus_neighbor(side: Side, neighbor: NodePath)
- NodePath get_focus_neighbor(side: Side) const

Tells Godot which node it should give focus to if the user presses the down arrow on the keyboard or down on a gamepad by default. You can change the key by editing the ProjectSettings.input/ui_down input action. The node must be a Control. If this property is not set, Godot will give focus to the closest Control to the bottom of this one.

---

NodePath focus_neighbor_left = NodePath("") 

- void set_focus_neighbor(side: Side, neighbor: NodePath)
- NodePath get_focus_neighbor(side: Side) const

Tells Godot which node it should give focus to if the user presses the left arrow on the keyboard or left on a gamepad by default. You can change the key by editing the ProjectSettings.input/ui_left input action. The node must be a Control. If this property is not set, Godot will give focus to the closest Control to the left of this one.

---

NodePath focus_neighbor_right = NodePath("") 

- void set_focus_neighbor(side: Side, neighbor: NodePath)
- NodePath get_focus_neighbor(side: Side) const

Tells Godot which node it should give focus to if the user presses the right arrow on the keyboard or right on a gamepad by default. You can change the key by editing the ProjectSettings.input/ui_right input action. The node must be a Control. If this property is not set, Godot will give focus to the closest Control to the right of this one.

---

NodePath focus_neighbor_top = NodePath("") 

- void set_focus_neighbor(side: Side, neighbor: NodePath)
- NodePath get_focus_neighbor(side: Side) const

Tells Godot which node it should give focus to if the user presses the top arrow on the keyboard or top on a gamepad by default. You can change the key by editing the ProjectSettings.input/ui_up input action. The node must be a Control. If this property is not set, Godot will give focus to the closest Control to the top of this one.

---

NodePath focus_next = NodePath("") 

- void set_focus_next(value: NodePath)
- NodePath get_focus_next()

Tells Godot which node it should give focus to if the user presses Tab on a keyboard by default. You can change the key by editing the ProjectSettings.input/ui_focus_next input action.

If this property is not set, Godot will select a "best guess" based on surrounding nodes in the scene tree.

---

NodePath focus_previous = NodePath("") 

- void set_focus_previous(value: NodePath)
- NodePath get_focus_previous()

Tells Godot which node it should give focus to if the user presses Shift + Tab on a keyboard by default. You can change the key by editing the ProjectSettings.input/ui_focus_prev input action.

If this property is not set, Godot will select a "best guess" based on surrounding nodes in the scene tree.

---

Vector2 global_position 

- Vector2 get_global_position()

The node's global position, relative to the world (usually to the CanvasLayer).

---

GrowDirection grow_horizontal = 1 

- void set_h_grow_direction(value: GrowDirection)
- GrowDirection get_h_grow_direction()

Controls the direction on the horizontal axis in which the control should grow if its horizontal minimum size is changed to be greater than its current size, as the control always has to be at least the minimum size.

---

GrowDirection grow_vertical = 1 

- void set_v_grow_direction(value: GrowDirection)
- GrowDirection get_v_grow_direction()

Controls the direction on the vertical axis in which the control should grow if its vertical minimum size is changed to be greater than its current size, as the control always has to be at least the minimum size.

---

LayoutDirection layout_direction = 0 

- void set_layout_direction(value: LayoutDirection)
- LayoutDirection get_layout_direction()

Controls layout direction and text writing direction. Right-to-left layouts are necessary for certain languages (e.g. Arabic and Hebrew). See also is_layout_rtl().

---

bool localize_numeral_system = true 

- void set_localize_numeral_system(value: bool)
- bool is_localizing_numeral_system()

If true, automatically converts code line numbers, list indices, SpinBox and ProgressBar values from the Western Arabic (0..9) to the numeral systems used in current locale.

Note: Numbers within the text are not automatically converted, it can be done manually, using TextServer.format_number().

---

MouseBehaviorRecursive mouse_behavior_recursive = 0 

- void set_mouse_behavior_recursive(value: MouseBehaviorRecursive)
- MouseBehaviorRecursive get_mouse_behavior_recursive()

Determines which controls can receive mouse input together with mouse_filter. See get_mouse_filter_with_override(). Since the default behavior is MOUSE_BEHAVIOR_INHERITED, this can be used to prevent all children controls from receiving mouse input.

---

CursorShape mouse_default_cursor_shape = 0 

- void set_default_cursor_shape(value: CursorShape)
- CursorShape get_default_cursor_shape()

The default cursor shape for this control. Useful for Godot plugins and applications or games that use the system's mouse cursors.

Note: On Linux, shapes may vary depending on the cursor theme of the system.

---

MouseFilter mouse_filter = 0 

- void set_mouse_filter(value: MouseFilter)
- MouseFilter get_mouse_filter()

Determines which controls will be able to receive mouse button input events through _gui_input() and the mouse_entered, and mouse_exited signals. Also determines how these events should be propagated. See the constants to learn what each does. Use get_mouse_filter_with_override() to determine if a control can receive mouse input, since mouse_behavior_recursive also affects it.

---

bool mouse_force_pass_scroll_events = true 

- void set_force_pass_scroll_events(value: bool)
- bool is_force_pass_scroll_events()

When enabled, scroll wheel events processed by _gui_input() will be passed to the parent control even if mouse_filter is set to MOUSE_FILTER_STOP.

You should disable it on the root of your UI if you do not want scroll events to go to the Node._unhandled_input() processing.

Note: Because this property defaults to true, this allows nested scrollable containers to work out of the box.

---

float offset_bottom = 0.0 

- void set_offset(side: Side, offset: float)
- float get_offset(offset: Side) const

Distance between the node's bottom edge and its parent control, based on anchor_bottom.

Offsets are often controlled by one or multiple parent Container nodes, so you should not modify them manually if your node is a direct child of a Container. Offsets update automatically when you move or resize the node.

---

float offset_left = 0.0 

- void set_offset(side: Side, offset: float)
- float get_offset(offset: Side) const

Distance between the node's left edge and its parent control, based on anchor_left.

Offsets are often controlled by one or multiple parent Container nodes, so you should not modify them manually if your node is a direct child of a Container. Offsets update automatically when you move or resize the node.

---

float offset_right = 0.0 

- void set_offset(side: Side, offset: float)
- float get_offset(offset: Side) const

Distance between the node's right edge and its parent control, based on anchor_right.

Offsets are often controlled by one or multiple parent Container nodes, so you should not modify them manually if your node is a direct child of a Container. Offsets update automatically when you move or resize the node.

---

float offset_top = 0.0 

- void set_offset(side: Side, offset: float)
- float get_offset(offset: Side) const

Distance between the node's top edge and its parent control, based on anchor_top.

Offsets are often controlled by one or multiple parent Container nodes, so you should not modify them manually if your node is a direct child of a Container. Offsets update automatically when you move or resize the node.

---

bool offset_transform_enabled = false 

- void set_offset_transform_enabled(value: bool)
- bool is_offset_transform_enabled()

If true, applies all offset transform properties. Otherwise, no offset transform is applied and the properties have no effect.

---

Vector2 offset_transform_pivot = Vector2(0, 0) 

- void set_offset_transform_pivot(value: Vector2)
- Vector2 get_offset_transform_pivot()

Pivot used by offset_transform_rotation and offset_transform_scale in absolute units.

The final pivot position is the combined value of this property and offset_transform_pivot_ratio.

Has no effect unless offset_transform_enabled is true.

---

Vector2 offset_transform_pivot_ratio = Vector2(0.5, 0.5) 

- void set_offset_transform_pivot_ratio(value: Vector2)
- Vector2 get_offset_transform_pivot_ratio()

Same as offset_transform_pivot but expressed in units relative to the Control size where Vector2(0, 0) is the top-left corner of this control, and Vector2(1, 1) is its bottom-right corner.

The final pivot position is the combined value of this property and offset_transform_pivot.

Has no effect unless offset_transform_enabled is true.

---

Vector2 offset_transform_position = Vector2(0, 0) 

- void set_offset_transform_position(value: Vector2)
- Vector2 get_offset_transform_position()

Position offset in absolute units. The final offset is the combined value of this property and offset_transform_position_ratio.

Has no effect unless offset_transform_enabled is true.

---

Vector2 offset_transform_position_ratio = Vector2(0, 0) 

- void set_offset_transform_position_ratio(value: Vector2)
- Vector2 get_offset_transform_position_ratio()

Same as offset_transform_position but expressed in units relative to the Control size where Vector2(0, 0) is the top-left corner of this control, and Vector2(1, 1) is its bottom-right corner.

The final offset is the combined value of this property and offset_transform_position.

Has no effect unless offset_transform_enabled is true.

---

float offset_transform_rotation = 0.0 

- void set_offset_transform_rotation(value: float)
- float get_offset_transform_rotation()

Rotation offset. The rotation pivot is defined by offset_transform_pivot and offset_transform_pivot_ratio.

Has no effect unless offset_transform_enabled is true.

---

Vector2 offset_transform_scale = Vector2(1, 1) 

- void set_offset_transform_scale(value: Vector2)
- Vector2 get_offset_transform_scale()

Scale offset. The scale pivot is defined by offset_transform_pivot and offset_transform_pivot_ratio.

Has no effect unless offset_transform_enabled is true.

---

bool offset_transform_visual_only = true 

- void set_offset_transform_visual_only(value: bool)
- bool is_offset_transform_visual_only()

If true, the offset transforms is only applied visually and does not affect input. In other words, this Control will still receive input events at its original location before the offset transform is applied.

If false, the entire transform of this Control is affected and input events will register where the Control is visually.

Has no effect unless offset_transform_enabled is true.

---

Vector2 pivot_offset = Vector2(0, 0) 

- void set_pivot_offset(value: Vector2)
- Vector2 get_pivot_offset()

By default, the node's pivot is its top-left corner. When you change its rotation or scale, it will rotate or scale around this pivot.

The actual offset is the combined value of this property and pivot_offset_ratio.

---

Vector2 pivot_offset_ratio = Vector2(0, 0) 

- void set_pivot_offset_ratio(value: Vector2)
- Vector2 get_pivot_offset_ratio()

Same as pivot_offset, but expressed as uniform vector, where Vector2(0, 0) is the top-left corner of this control, and Vector2(1, 1) is its bottom-right corner. Set this property to Vector2(0.5, 0.5) to pivot around this control's center.

The actual offset is the combined value of this property and pivot_offset.

---

Vector2 position = Vector2(0, 0) 

- Vector2 get_position()

The node's position, relative to its containing node. It corresponds to the rectangle's top-left corner. The property is not affected by pivot_offset.

---

bool propagate_maximum_size = false 

- void set_propagate_maximum_size(value: bool)
- bool is_propagating_maximum_size()

If true, this Control's children will use the value returned by get_combined_maximum_size() in their own size calculations.

---

float rotation = 0.0 

- void set_rotation(value: float)
- float get_rotation()

The node's rotation around its pivot, in radians. See pivot_offset to change the pivot's position.

Note: This property is edited in the inspector in degrees. If you want to use degrees in a script, use rotation_degrees.

---

float rotation_degrees 

- void set_rotation_degrees(value: float)
- float get_rotation_degrees()

Helper property to access rotation in degrees instead of radians.

---

Vector2 scale = Vector2(1, 1) 

- void set_scale(value: Vector2)
- Vector2 get_scale()

The node's scale, relative to its size. Change this property to scale the node around its pivot_offset. The Control's tooltip will also scale according to this value.

Note: This property is mainly intended to be used for animation purposes. To support multiple resolutions in your project, use an appropriate viewport stretch mode as described in the documentation instead of scaling Controls individually.

Note: FontFile.oversampling does not take Control scale into account. This means that scaling up/down will cause bitmap fonts and rasterized (non-MSDF) dynamic fonts to appear blurry or pixelated. To ensure text remains crisp regardless of scale, you can enable MSDF font rendering by enabling ProjectSettings.gui/theme/default_font_multichannel_signed_distance_field (applies to the default project font only), or enabling Multichannel Signed Distance Field in the import options of a DynamicFont for custom fonts. On system fonts, SystemFont.multichannel_signed_distance_field can be enabled in the inspector.

Note: If the Control node is a child of a Container node, the scale will be reset to Vector2(1, 1) when the scene is instantiated. To set the Control's scale when it's instantiated, wait for one frame using await get_tree().process_frame then set its scale property.

---

Node shortcut_context 

- void set_shortcut_context(value: Node)
- Node get_shortcut_context()

The Node which must be a parent of the focused Control for the shortcut to be activated. If null, the shortcut can be activated when any control is focused (a global shortcut). This allows shortcuts to be accepted only when the user has a certain area of the GUI focused.

---

Vector2 size = Vector2(0, 0) 

- Vector2 get_size()

The size of the node's bounding rectangle, in the node's coordinate system. Container nodes update this property automatically.

---

BitField[SizeFlags] size_flags_horizontal = 1 

- void set_h_size_flags(value: BitField[SizeFlags])
- BitField[SizeFlags] get_h_size_flags()

Tells the parent Container nodes how they should resize and place the node on the X axis. Use a combination of the SizeFlags constants to change the flags. See the constants to learn what each does.

---

float size_flags_stretch_ratio = 1.0 

- void set_stretch_ratio(value: float)
- float get_stretch_ratio()

If the node and at least one of its neighbors uses the SIZE_EXPAND size flag, the parent Container will let it take more or less space depending on this property. If this node has a stretch ratio of 2 and its neighbor a ratio of 1, this node will take two thirds of the available space.

---

BitField[SizeFlags] size_flags_vertical = 1 

- void set_v_size_flags(value: BitField[SizeFlags])
- BitField[SizeFlags] get_v_size_flags()

Tells the parent Container nodes how they should resize and place the node on the Y axis. Use a combination of the SizeFlags constants to change the flags. See the constants to learn what each does.

---

Theme theme 

- void set_theme(value: Theme)
- Theme get_theme()

The Theme resource this node and all its Control and Window children use. If a child node has its own Theme resource set, theme items are merged with child's definitions having higher priority.

Note: Window styles will have no effect unless the window is embedded.

---

StringName theme_type_variation = &"" 

- void set_theme_type_variation(value: StringName)
- StringName get_theme_type_variation()

The name of a theme type variation used by this Control to look up its own theme items. When empty, the class name of the node is used (e.g. Button for the Button control), as well as the class names of all parent classes (in order of inheritance).

When set, this property gives the highest priority to the type of the specified name. This type can in turn extend another type, forming a dependency chain. See Theme.set_type_variation(). If the theme item cannot be found using this type or its base types, lookup falls back on the class names.

Note: To look up Control's own items use various get_theme_* methods without specifying theme_type.

Note: Theme items are looked for in the tree order, from branch to root, where each Control node is checked for its theme property. The earliest match against any type/class name is returned. The project-level Theme and the default Theme are checked last.

---

AutoTranslateMode tooltip_auto_translate_mode = 0 

- void set_tooltip_auto_translate_mode(value: AutoTranslateMode)
- AutoTranslateMode get_tooltip_auto_translate_mode()

Defines if tooltip text should automatically change to its translated version depending on the current locale. Uses the same auto translate mode as this control when set to Node.AUTO_TRANSLATE_MODE_INHERIT.

Note: Tooltips customized using _make_custom_tooltip() do not use this auto translate mode automatically.

---

String tooltip_text = "" 

- void set_tooltip_text(value: String)
- String get_tooltip_text()

The default tooltip text. The tooltip appears when the user's mouse cursor stays idle over this control for a few moments, provided that the mouse_filter property is not MOUSE_FILTER_IGNORE. The time required for the tooltip to appear can be changed with the ProjectSettings.gui/timers/tooltip_delay_sec setting.

This string is the default return value of get_tooltip(). Override _get_tooltip() to generate tooltip text dynamically. Override _make_custom_tooltip() to customize the tooltip interface and behavior.

The tooltip popup will use either a default implementation, or a custom one that you can provide by overriding _make_custom_tooltip(). The default tooltip includes a PopupPanel and Label whose theme properties can be customized using Theme methods with the "TooltipPanel" and "TooltipLabel" respectively. For example:

```
var style_box = StyleBoxFlat.new()
style_box.set_bg_color(Color(1, 1, 0))
style_box.set_border_width_all(2)
# We assume here that the `theme` property has been assigned a custom Theme beforehand.
theme.set_stylebox("panel", "TooltipPanel", style_box)
theme.set_color("font_color", "TooltipLabel", Color(0, 1, 1))
```

```
var styleBox = new StyleBoxFlat();
styleBox.SetBgColor(new Color(1, 1, 0));
styleBox.SetBorderWidthAll(2);
// We assume here that the `Theme` property has been assigned a custom Theme beforehand.
Theme.SetStyleBox("panel", "TooltipPanel", styleBox);
Theme.SetColor("font_color", "TooltipLabel", new Color(0, 1, 1));
```

---

StringName translation_context = &"" 

- void set_translation_context(value: StringName)
- StringName get_translation_context()

The translation context used when translating this control's displayed text, if it has any. Also used when generating translation templates.

---

## Method Descriptions

String _accessibility_get_contextual_info() virtual const 

Return the description of the keyboard shortcuts and other contextual help for this control.

---

bool _can_drop_data(at_position: Vector2, data: Variant) virtual const 

Godot calls this method to test if data from a control's _get_drag_data() can be dropped at at_position. at_position is local to this control.

This method should only be used to test the data. Process the data in _drop_data().

Note: If the drag was initiated by a keyboard shortcut or accessibility_drag(), at_position is set to Vector2.INF, and the currently selected item/text position should be used as the drop position.

```
func _can_drop_data(position, data):
    # Check position if it is relevant to you
    # Otherwise, just check data
    return typeof(data) == TYPE_DICTIONARY and data.has("expected")
```

```
public override bool _CanDropData(Vector2 atPosition, Variant data)
{
    // Check position if it is relevant to you
    // Otherwise, just check data
    return data.VariantType == Variant.Type.Dictionary && data.AsGodotDictionary().ContainsKey("expected");
}
```

---

void _drop_data(at_position: Vector2, data: Variant) virtual 

Godot calls this method to pass you the data from a control's _get_drag_data() result. Godot first calls _can_drop_data() to test if data is allowed to drop at at_position where at_position is local to this control.

Note: If the drag was initiated by a keyboard shortcut or accessibility_drag(), at_position is set to Vector2.INF, and the currently selected item/text position should be used as the drop position.

```
func _can_drop_data(position, data):
    return typeof(data) == TYPE_DICTIONARY and data.has("color")
func _drop_data(position, data):
    var color = data["color"]
```

```
public override bool _CanDropData(Vector2 atPosition, Variant data)
{
    return data.VariantType == Variant.Type.Dictionary && data.AsGodotDictionary().ContainsKey("color");
}
public override void _DropData(Vector2 atPosition, Variant data)
{
    Color color = data.AsGodotDictionary()["color"].AsColor();
}
```

---

String _get_accessibility_container_name(node: Node) virtual const 

Override this method to return a human-readable description of the position of the child node in the custom container, added to the accessibility_name.

---

int _get_cursor_shape(at_position: Vector2) virtual const 

Virtual method to be implemented by the user. Returns the cursor shape for the position at_position in the control's local coordinates, which will typically be used while hovering over this control. See get_cursor_shape().

If not overridden, defaults to mouse_default_cursor_shape.

---

Variant _get_drag_data(at_position: Vector2) virtual 

Godot calls this method to get data that can be dragged and dropped onto controls that expect drop data. Returns null if there is no data to drag. Controls that want to receive drop data should implement _can_drop_data() and _drop_data(). at_position is local to this control. Drag may be forced with force_drag().

A preview that will follow the mouse that should represent the data can be set with set_drag_preview(). A good time to set the preview is in this method.

Note: If the drag was initiated by a keyboard shortcut or accessibility_drag(), at_position is set to Vector2.INF, and the currently selected item/text position should be used as the drag position.

```
func _get_drag_data(position):
    var mydata = make_data() # This is your custom method generating the drag data.
    set_drag_preview(make_preview(mydata)) # This is your custom method generating the preview of the drag data.
    return mydata
```

```
public override Variant _GetDragData(Vector2 atPosition)
{
    var myData = MakeData(); // This is your custom method generating the drag data.
    SetDragPreview(MakePreview(myData)); // This is your custom method generating the preview of the drag data.
    return myData;
}
```

---

Vector2 _get_maximum_size() virtual const 

Virtual method to be implemented by the user. Returns the maximum size for this control. Alternative to custom_maximum_size for controlling maximum size via code. The actual maximum size will be the max value of these two (in each axis separately).

If not overridden, defaults to Vector2.ZERO.

Note: This method will not be called when the script is attached to a Control node that already overrides its maximum size (e.g. ScrollContainer).

Note: It is recommended to use get_bound_minimum_size() instead of get_combined_minimum_size() when implementing this method, as the former respects maximum size limits when calculating the minimum size, while the latter does not.

---

Vector2 _get_minimum_size() virtual const 

Virtual method to be implemented by the user. Returns the minimum size for this control. Alternative to custom_minimum_size for controlling minimum size via code. The actual minimum size will be the max value of these two (in each axis separately).

If not overridden, defaults to Vector2.ZERO.

Note: This method will not be called when the script is attached to a Control node that already overrides its minimum size (e.g. Label, Button, PanelContainer etc.). It can only be used with most basic GUI nodes, like Control, Container, Panel etc.

---

String _get_tooltip(at_position: Vector2) virtual const 

Virtual method to be implemented by the user. Returns the tooltip text for the position at_position in the control's local coordinates, which will typically appear when the cursor is resting over this control. See get_tooltip().

Note: If this method returns an empty String and _make_custom_tooltip() is not overridden, no tooltip is displayed.

---

AutoTranslateMode _get_tooltip_auto_translate_mode_at(at_position: Vector2) virtual const 

Return the auto-translation mode at the given at_position. If not implemented, the tooltip_auto_translate_mode property will be used instead.

---

void _gui_input(event: InputEvent) virtual 

Virtual method to be implemented by the user. Override this method to handle and accept inputs on UI elements. See also accept_event().

Example: Click on the control to print a message:

```
func _gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("I've been clicked D:")
```

```
public override void _GuiInput(InputEvent @event)
{
    if (@event is InputEventMouseButton mb)
    {
        if (mb.ButtonIndex == MouseButton.Left && mb.Pressed)
        {
            GD.Print("I've been clicked D:");
        }
    }
}
```

If the event inherits InputEventMouse, this method will not be called when:

- the control's mouse_filter is set to MOUSE_FILTER_IGNORE;
- the control is obstructed by another control on top, that doesn't have mouse_filter set to MOUSE_FILTER_IGNORE;
- the control's parent has mouse_filter set to MOUSE_FILTER_STOP or has accepted the event;
- the control's parent has clip_contents enabled and the event's position is outside the parent's rectangle;
- the event's position is outside the control (see _has_point()).

Note: The event's position is relative to this control's origin.

---

bool _has_point(point: Vector2) virtual const 

Virtual method to be implemented by the user. Returns whether the given point is inside this control.

If not overridden, default behavior is checking if the point is within the control's Rect.

Note: If you want to check if a point is inside the control, you can use Rect2(Vector2.ZERO, size).has_point(point).

---

Object _make_custom_tooltip(for_text: String) virtual const 

Virtual method to be implemented by the user. Returns a Control node that should be used as a tooltip instead of the default one. for_text is the return value of get_tooltip().

The returned node must be of type Control or Control-derived. It can have child nodes of any type. It is freed when the tooltip disappears, so make sure you always provide a new instance (if you want to use a pre-existing node from your scene tree, you can duplicate it and pass the duplicated instance). When null or a non-Control node is returned, the default tooltip will be used instead.

The returned node will be added as child to a PopupPanel, so you should only provide the contents of that panel. That PopupPanel can be themed using Theme.set_stylebox() for the type "TooltipPanel" (see tooltip_text for an example).

Note: The tooltip is shrunk to minimal size. If you want to ensure it's fully visible, you might want to set its custom_minimum_size to some non-zero value.

Note: The node (and any relevant children) should have their CanvasItem.visible set to true when returned, otherwise, the viewport that instantiates it will not be able to calculate its minimum size reliably.

Note: If overridden, this method is called even if get_tooltip() returns an empty string. When this happens with the default tooltip, it is not displayed. To copy this behavior, return null in this method when for_text is empty.

Example: Use a constructed node as a tooltip:

```
func _make_custom_tooltip(for_text):
    var label = Label.new()
    label.text = for_text
    return label
```

```
public override Control _MakeCustomTooltip(string forText)
{
    var label = new Label();
    label.Text = forText;
    return label;
}
```

Example: Use a scene instance as a tooltip:

```
func _make_custom_tooltip(for_text):
    var tooltip = preload("res://some_tooltip_scene.tscn").instantiate()
    tooltip.get_node("Label").text = for_text
    return tooltip
```

```
public override Control _MakeCustomTooltip(string forText)
{
    Node tooltip = ResourceLoader.Load("res://some_tooltip_scene.tscn").Instantiate();
    tooltip.GetNode("Label").Text = forText;
    return tooltip;
}
```

---

Array[Vector3i] _structured_text_parser(args: Array, text: String) virtual const 

User defined BiDi algorithm override function.

Returns an Array of Vector3i text ranges and text base directions, in the left-to-right order. Ranges should cover full source text without overlaps. BiDi algorithm will be used on each range separately.

---

void accept_event() 

Marks an input event as handled. Once you accept an input event, it stops propagating, even to nodes listening to Node._unhandled_input() or Node._unhandled_key_input().

Note: This does not affect the methods in Input, only the way events are propagated.

---

void accessibility_drag() 

Starts drag-and-drop operation without using a mouse.

---

void accessibility_drop() 

Ends drag-and-drop operation without using a mouse.

---

void add_theme_color_override(name: StringName, color: Color) 

Creates a local override for a theme Color with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_color_override().

See also get_theme_color().

Example: Override a Label's color and reset it later:

```
# Given the child Label node "MyLabel", override its font color with a custom value.
$MyLabel.add_theme_color_override("font_color", Color(1, 0.5, 0))
# Reset the font color of the child label.
$MyLabel.remove_theme_color_override("font_color")
# Alternatively it can be overridden with the default value from the Label type.
$MyLabel.add_theme_color_override("font_color", get_theme_color("font_color", "Label"))
```

```
// Given the child Label node "MyLabel", override its font color with a custom value.
GetNode("MyLabel").AddThemeColorOverride("font_color", new Color(1, 0.5f, 0));
// Reset the font color of the child label.
GetNode("MyLabel").RemoveThemeColorOverride("font_color");
// Alternatively it can be overridden with the default value from the Label type.
GetNode("MyLabel").AddThemeColorOverride("font_color", GetThemeColor("font_color", "Label"));
```

---

void add_theme_constant_override(name: StringName, constant: int) 

Creates a local override for a theme constant with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_constant_override().

See also get_theme_constant().

---

void add_theme_font_override(name: StringName, font: Font) 

Creates a local override for a theme Font with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_font_override().

See also get_theme_font().

---

void add_theme_font_size_override(name: StringName, font_size: int) 

Creates a local override for a theme font size with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_font_size_override().

See also get_theme_font_size().

---

void add_theme_icon_override(name: StringName, texture: Texture2D) 

Creates a local override for a theme icon with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_icon_override().

See also get_theme_icon().

---

void add_theme_stylebox_override(name: StringName, stylebox: StyleBox) 

Creates a local override for a theme StyleBox with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_stylebox_override().

See also get_theme_stylebox().

Example: Modify a property in a StyleBox by duplicating it:

```
# The snippet below assumes the child node "MyButton" has a StyleBoxFlat assigned.
# Resources are shared across instances, so we need to duplicate it
# to avoid modifying the appearance of all other buttons.
var new_stylebox_normal = $MyButton.get_theme_stylebox("normal").duplicate()
new_stylebox_normal.border_width_top = 3
new_stylebox_normal.border_color = Color(0, 1, 0.5)
$MyButton.add_theme_stylebox_override("normal", new_stylebox_normal)
# Remove the stylebox override.
$MyButton.remove_theme_stylebox_override("normal")
```

```
// The snippet below assumes the child node "MyButton" has a StyleBoxFlat assigned.
// Resources are shared across instances, so we need to duplicate it
// to avoid modifying the appearance of all other buttons.
StyleBoxFlat newStyleboxNormal = GetNode("MyButton").GetThemeStylebox("normal").Duplicate() as StyleBoxFlat;
newStyleboxNormal.BorderWidthTop = 3;
newStyleboxNormal.BorderColor = new Color(0, 1, 0.5f);
GetNode("MyButton").AddThemeStyleboxOverride("normal", newStyleboxNormal);
// Remove the stylebox override.
GetNode("MyButton").RemoveThemeStyleboxOverride("normal");
```

---

void begin_bulk_theme_override() 

Prevents *_theme_*_override methods from emitting NOTIFICATION_THEME_CHANGED until end_bulk_theme_override() is called.

---

void end_bulk_theme_override() 

Ends a bulk theme override update. See begin_bulk_theme_override().

---

Control find_next_valid_focus() const 

Finds the next (below in the tree) Control that can receive the focus.

---

Control find_prev_valid_focus() const 

Finds the previous (above in the tree) Control that can receive the focus.

---

Control find_valid_focus_neighbor(side: Side) const 

Finds the next Control that can receive the focus on the specified Side.

Note: This is different from get_focus_neighbor(), which returns the path of a specified focus neighbor.

---

void force_drag(data: Variant, preview: Control) 

Forces drag and bypasses _get_drag_data() and set_drag_preview() by passing data and preview. Drag will start even if the mouse is neither over nor pressed on this control.

The methods _can_drop_data() and _drop_data() must be implemented on controls that want to receive drop data.

---

float get_anchor(side: Side) const 

Returns the anchor for the specified Side. A getter method for anchor_bottom, anchor_left, anchor_right and anchor_top.

---

Vector2 get_begin() const 

Returns offset_left and offset_top. See also position.

---

Vector2 get_bound_minimum_size() const 

Returns the bound value of get_combined_minimum_size() by get_combined_maximum_size().

This value is the true minimum size of the container, as the maximum size has priority over the minimum size.

For example, if the combined minimum size is (100, 100) and the combined maximum size is (50, 150), the bound minimum size will be (50, 100).

---

Vector2 get_combined_maximum_size() const 

Returns the combined maximum size from custom_maximum_size and get_maximum_size(), as well as the custom_maximum_size of this node's parent if it is a Control node with propagate_maximum_size set to true.

---

Vector2 get_combined_minimum_size() const 

Returns the combined minimum size from custom_minimum_size and get_minimum_size().

---

Vector2 get_combined_pivot_offset() const 

Returns the combined value of pivot_offset and pivot_offset_ratio, in pixels. The ratio is multiplied by the control's size.

---

CursorShape get_cursor_shape(at_position: Vector2 = Vector2(0, 0)) const 

Returns the mouse cursor shape for this control when hovered over at_position in local coordinates. For most controls, this is the same as mouse_default_cursor_shape, but some built-in controls implement more complex logic.

You can override _get_cursor_shape() to implement custom behavior for this method.

---

Vector2 get_end() const 

Returns offset_right and offset_bottom.

---

FocusMode get_focus_mode_with_override() const 

Returns the focus_mode, but takes the focus_behavior_recursive into account. If focus_behavior_recursive is set to FOCUS_BEHAVIOR_DISABLED, or it is set to FOCUS_BEHAVIOR_INHERITED and its ancestor is set to FOCUS_BEHAVIOR_DISABLED, then this returns FOCUS_NONE.

---

NodePath get_focus_neighbor(side: Side) const 

Returns the focus neighbor for the specified Side. A getter method for focus_neighbor_bottom, focus_neighbor_left, focus_neighbor_right and focus_neighbor_top.

Note: To find the next Control on the specific Side, even if a neighbor is not assigned, use find_valid_focus_neighbor().

---

Rect2 get_global_rect() const 

Returns the position and size of the control relative to the containing canvas. See global_position and size.

Note: If the node itself or any parent CanvasItem between the node and the canvas have a non default rotation or skew, the resulting size is likely not meaningful.

Note: Setting Viewport.gui_snap_controls_to_pixels to true can lead to rounding inaccuracies between the displayed control and the returned Rect2.

---

Vector2 get_maximum_size() const 

Returns the maximum size for this control. See custom_maximum_size.

---

Vector2 get_minimum_size() const 

Returns the minimum size for this control. See custom_minimum_size.

---

MouseFilter get_mouse_filter_with_override() const 

Returns the mouse_filter, but takes the mouse_behavior_recursive into account. If mouse_behavior_recursive is set to MOUSE_BEHAVIOR_DISABLED, or it is set to MOUSE_BEHAVIOR_INHERITED and its ancestor is set to MOUSE_BEHAVIOR_DISABLED, then this returns MOUSE_FILTER_IGNORE.

---

float get_offset(offset: Side) const 

Returns the offset for the specified Side. A getter method for offset_bottom, offset_left, offset_right and offset_top.

---

Vector2 get_parent_area_size() const 

Returns the width/height occupied in the parent control.

---

Control get_parent_control() const 

Returns the parent control node.

---

Rect2 get_rect() const 

Returns the position and size of the control in the coordinate system of the containing node. See position, scale and size.

Note: If rotation is not the default rotation, the resulting size is not meaningful.

Note: Setting Viewport.gui_snap_controls_to_pixels to true can lead to rounding inaccuracies between the displayed control and the returned Rect2.

---

Vector2 get_screen_position() const 

Returns the position of this Control in global screen coordinates (i.e. taking window position into account). Mostly useful for editor plugins.

Equivalent to get_screen_transform().origin (see CanvasItem.get_screen_transform()).

Example: Show a popup at the mouse position:

```gdscript
popup_menu.position = get_screen_position() + get_screen_transform().basis_xform(get_local_mouse_position())
# The above code is equivalent to:
popup_menu.position = get_screen_transform() * get_local_mouse_position()
popup_menu.reset_size()
popup_menu.popup()
```

---

Color get_theme_color(name: StringName, theme_type: StringName = &"") const 

Returns a Color from the first matching Theme in the tree if that Theme has a color item with the specified name and theme_type. If theme_type is omitted the class name of the current control is used as the type, or theme_type_variation if it is defined. If the type is a class name its parent classes are also checked, in order of inheritance. If the type is a variation its base types are checked, in order of dependency, then the control's class name and its parent classes are checked.

For the current control its local overrides are considered first (see add_theme_color_override()), then its assigned theme. After the current control, each parent control and its assigned theme are considered; controls without a theme assigned are skipped. If no matching Theme is found in the tree, the custom project Theme (see ProjectSettings.gui/theme/custom) and the default Theme are used (see ThemeDB).

```
func _ready():
    # Get the font color defined for the current Control's class, if it exists.
    modulate = get_theme_color("font_color")
    # Get the font color defined for the Button class.
    modulate = get_theme_color("font_color", "Button")
```

```
public override void _Ready()
{
    // Get the font color defined for the current Control's class, if it exists.
    Modulate = GetThemeColor("font_color");
    // Get the font color defined for the Button class.
    Modulate = GetThemeColor("font_color", "Button");
}
```

---

int get_theme_constant(name: StringName, theme_type: StringName = &"") const 

Returns a constant from the first matching Theme in the tree if that Theme has a constant item with the specified name and theme_type.

See get_theme_color() for details.

---

float get_theme_default_base_scale() const 

Returns the default base scale value from the first matching Theme in the tree if that Theme has a valid Theme.default_base_scale value.

See get_theme_color() for details.

---

Font get_theme_default_font() const 

Returns the default font from the first matching Theme in the tree if that Theme has a valid Theme.default_font value.

See get_theme_color() for details.

---

int get_theme_default_font_size() const 

Returns the default font size value from the first matching Theme in the tree if that Theme has a valid Theme.default_font_size value.

See get_theme_color() for details.

---

Font get_theme_font(name: StringName, theme_type: StringName = &"") const 

Returns a Font from the first matching Theme in the tree if that Theme has a font item with the specified name and theme_type.

See get_theme_color() for details.

---

int get_theme_font_size(name: StringName, theme_type: StringName = &"") const 

Returns a font size from the first matching Theme in the tree if that Theme has a font size item with the specified name and theme_type.

See get_theme_color() for details.

---

Texture2D get_theme_icon(name: StringName, theme_type: StringName = &"") const 

Returns an icon from the first matching Theme in the tree if that Theme has an icon item with the specified name and theme_type.

See get_theme_color() for details.

---

StyleBox get_theme_stylebox(name: StringName, theme_type: StringName = &"") const 

Returns a StyleBox from the first matching Theme in the tree if that Theme has a stylebox item with the specified name and theme_type.

See get_theme_color() for details.

---

String get_tooltip(at_position: Vector2 = Vector2(0, 0)) const 

Returns the tooltip text for the position at_position in the control's local coordinates, which will typically appear when the cursor is resting over this control. By default, it returns tooltip_text.

You can override _get_tooltip() to implement custom behavior for this method.

Note: If this method returns an empty String and _make_custom_tooltip() is not overridden, no tooltip is displayed.

---

void grab_click_focus() 

Creates an InputEventMouseButton that attempts to click the control. If the event is received, the control gains focus.

```
func _process(delta):
    grab_click_focus() # When clicking another Control node, this node will be clicked instead.
```

```
public override void _Process(double delta)
{
    GrabClickFocus(); // When clicking another Control node, this node will be clicked instead.
}
```

---

void grab_focus(hide_focus: bool = false) 

Steal the focus from another control and become the focused control (see focus_mode).

If hide_focus is true, the control will not visually show its focused state. Has no effect for LineEdit and TextEdit when ProjectSettings.gui/common/show_focus_state_on_pointer_event is set to Text Input Controls, or for any control when it is set to Always.

Note: Using this method together with Callable.call_deferred() makes it more reliable, especially when called inside Node._ready().

---

bool has_focus(ignore_hidden_focus: bool = false) const 

Returns true if this is the current focused control. See focus_mode.

If ignore_hidden_focus is true, controls that have their focus hidden will always return false. Hidden focus happens automatically when controls gain focus via mouse input, or manually using grab_focus() with hide_focus set to true.

---

bool has_theme_color(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a color item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_color_override(name: StringName) const 

Returns true if there is a local override for a theme Color with the specified name in this Control node.

See add_theme_color_override().

---

bool has_theme_constant(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a constant item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_constant_override(name: StringName) const 

Returns true if there is a local override for a theme constant with the specified name in this Control node.

See add_theme_constant_override().

---

bool has_theme_font(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a font item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_font_override(name: StringName) const 

Returns true if there is a local override for a theme Font with the specified name in this Control node.

See add_theme_font_override().

---

bool has_theme_font_size(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a font size item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_font_size_override(name: StringName) const 

Returns true if there is a local override for a theme font size with the specified name in this Control node.

See add_theme_font_size_override().

---

bool has_theme_icon(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has an icon item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_icon_override(name: StringName) const 

Returns true if there is a local override for a theme icon with the specified name in this Control node.

See add_theme_icon_override().

---

bool has_theme_stylebox(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a stylebox item with the specified name and theme_type.

See get_theme_color() for details.

---

bool has_theme_stylebox_override(name: StringName) const 

Returns true if there is a local override for a theme StyleBox with the specified name in this Control node.

See add_theme_stylebox_override().

---

bool is_drag_successful() const 

Returns true if a drag operation is successful. Alternative to Viewport.gui_is_drag_successful().

Best used with Node.NOTIFICATION_DRAG_END.

---

bool is_layout_rtl() const 

Returns true if the layout is right-to-left. See also layout_direction.

---

void release_focus() 

Give up the focus. No other control will be able to receive input.

---

void remove_theme_color_override(name: StringName) 

Removes a local override for a theme Color with the specified name previously added by add_theme_color_override() or via the Inspector dock.

---

void remove_theme_constant_override(name: StringName) 

Removes a local override for a theme constant with the specified name previously added by add_theme_constant_override() or via the Inspector dock.

---

void remove_theme_font_override(name: StringName) 

Removes a local override for a theme Font with the specified name previously added by add_theme_font_override() or via the Inspector dock.

---

void remove_theme_font_size_override(name: StringName) 

Removes a local override for a theme font size with the specified name previously added by add_theme_font_size_override() or via the Inspector dock.

---

void remove_theme_icon_override(name: StringName) 

Removes a local override for a theme icon with the specified name previously added by add_theme_icon_override() or via the Inspector dock.

---

void remove_theme_stylebox_override(name: StringName) 

Removes a local override for a theme StyleBox with the specified name previously added by add_theme_stylebox_override() or via the Inspector dock.

---

void reset_size() 

Resets the size to get_combined_minimum_size(). This is equivalent to calling set_size(Vector2()) (or any size below the minimum).

---

void set_anchor(side: Side, anchor: float, keep_offset: bool = false, push_opposite_anchor: bool = true) 

Sets the anchor for the specified Side to anchor. A setter method for anchor_bottom, anchor_left, anchor_right and anchor_top.

If keep_offset is true, offsets aren't updated after this operation.

If push_opposite_anchor is true and the opposite anchor overlaps this anchor, the opposite one will have its value overridden. For example, when setting left anchor to 1 and the right anchor has value of 0.5, the right anchor will also get value of 1. If push_opposite_anchor was false, the left anchor would get value 0.5.

---

void set_anchor_and_offset(side: Side, anchor: float, offset: float, push_opposite_anchor: bool = false) 

Works the same as set_anchor(), but instead of keep_offset argument and automatic update of offset, it allows to set the offset yourself (see set_offset()).

---

void set_anchors_and_offsets_preset(preset: LayoutPreset, resize_mode: LayoutPresetMode = 0, margin: int = 0) 

Sets both anchor preset and offset preset. See set_anchors_preset() and set_offsets_preset().

---

void set_anchors_preset(preset: LayoutPreset, keep_offsets: bool = false) 

Sets the anchors to a preset from LayoutPreset enum. This is the code equivalent to using the Layout menu in the 2D editor.

If keep_offsets is true, control's position will also be updated.

---

void set_begin(position: Vector2) 

Sets offset_left and offset_top at the same time. Equivalent of changing position.

---

void set_drag_forwarding(drag_func: Callable, can_drop_func: Callable, drop_func: Callable) 

Sets the given callables to be used instead of the control's own drag-and-drop virtual methods. If a callable is empty, its respective virtual method is used as normal.

The arguments for each callable should be exactly the same as their respective virtual methods, which would be:

- drag_func corresponds to _get_drag_data() and requires a Vector2;
- can_drop_func corresponds to _can_drop_data() and requires both a Vector2 and a Variant;
- drop_func corresponds to _drop_data() and requires both a Vector2 and a Variant.

---

void set_drag_preview(control: Control) 

Shows the given control at the mouse pointer. A good time to call this method is in _get_drag_data(). The control must not be in the scene tree. You should not free the control, and you should not keep a reference to the control beyond the duration of the drag. It will be deleted automatically after the drag has ended.

```
@export var color = Color(1, 0, 0, 1)
func _get_drag_data(position):
    # Use a control that is not in the tree
    var cpb = ColorPickerButton.new()
    cpb.color = color
    cpb.size = Vector2(50, 50)
    set_drag_preview(cpb)
    return color
```

```
[Export]
private Color _color = new Color(1, 0, 0, 1);
public override Variant _GetDragData(Vector2 atPosition)
{
    // Use a control that is not in the tree
    var cpb = new ColorPickerButton();
    cpb.Color = _color;
    cpb.Size = new Vector2(50, 50);
    SetDragPreview(cpb);
    return _color;
}
```

---

void set_end(position: Vector2) 

Sets offset_right and offset_bottom at the same time.

---

void set_focus_neighbor(side: Side, neighbor: NodePath) 

Sets the focus neighbor for the specified Side to the Control at neighbor node path. A setter method for focus_neighbor_bottom, focus_neighbor_left, focus_neighbor_right and focus_neighbor_top.

---

void set_global_position(position: Vector2, keep_offsets: bool = false) 

Sets the global_position to given position.

If keep_offsets is true, control's anchors will be updated instead of offsets.

---

void set_offset(side: Side, offset: float) 

Sets the offset for the specified Side to offset. A setter method for offset_bottom, offset_left, offset_right and offset_top.

---

void set_offsets_preset(preset: LayoutPreset, resize_mode: LayoutPresetMode = 0, margin: int = 0) 

Sets the offsets to a preset from LayoutPreset enum. This is the code equivalent to using the Layout menu in the 2D editor.

Use parameter resize_mode with constants from LayoutPresetMode to better determine the resulting size of the Control. Constant size will be ignored if used with presets that change size, e.g. PRESET_LEFT_WIDE.

Use parameter margin to determine the gap between the Control and the edges.

---

void set_position(position: Vector2, keep_offsets: bool = false) 

Sets the position to given position.

If keep_offsets is true, control's anchors will be updated instead of offsets.

---

void set_size(size: Vector2, keep_offsets: bool = false) 

Sets the size (see size).

If keep_offsets is true, control's anchors will be updated instead of offsets.

---

void update_maximum_size() 

Invalidates the maximum size cache in this node and in parent nodes up to top level. Intended to be used with get_maximum_size() when the return value is changed. Setting custom_maximum_size directly calls this method automatically.

Note: Calling this method also calls update_minimum_size() since the combined minimum size may be affected by the maximum size change.

---

void update_minimum_size() 

Invalidates the minimum size cache in this node and in parent nodes up to top level. Intended to be used with get_minimum_size() when the return value is changed. Setting custom_minimum_size directly calls this method automatically.

---

void warp_mouse(position: Vector2) 

Moves the mouse cursor to position, relative to position of this Control.

Note: warp_mouse() is only supported on Windows, macOS and Linux. It has no effect on Android, iOS and Web.
