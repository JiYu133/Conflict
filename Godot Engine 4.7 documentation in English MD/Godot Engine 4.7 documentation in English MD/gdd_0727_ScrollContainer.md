# ScrollContainer

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: EditorInspector

A container used to provide scrollbars to a child control when needed.

## Description

A container used to provide a child control with scrollbars when needed. Scrollbars will automatically be drawn at the right (for vertical) or bottom (for horizontal) and will enable dragging to move the viewable Control (and its children) within the ScrollContainer. Scrollbars will also automatically resize the grabber based on the Control.custom_minimum_size of the Control relative to the ScrollContainer.

## Tutorials

- Using Containers

## Properties

bool | clip_contents | true (overrides Control)
bool | draw_focus_border | false
bool | follow_focus | false
ScrollMode | horizontal_scroll_mode | 1
bool | propagate_maximum_size | false (overrides Control)
int | scroll_deadzone | 0
ScrollHintMode | scroll_hint_mode | 0
int | scroll_horizontal | 0
bool | scroll_horizontal_by_default | false
float | scroll_horizontal_custom_step | -1.0
int | scroll_vertical | 0
float | scroll_vertical_custom_step | -1.0
bool | tile_scroll_hint | false
ScrollMode | vertical_scroll_mode | 1

## Methods

void | ensure_control_visible(control: Control)
HScrollBar | get_h_scroll_bar()
VScrollBar | get_v_scroll_bar()

## Theme Properties

Color | scroll_hint_horizontal_color | Color(0, 0, 0, 1)
Color | scroll_hint_vertical_color | Color(0, 0, 0, 1)
int | scrollbar_h_separation | 0
int | scrollbar_v_separation | 0
Texture2D | scroll_hint_horizontal |
Texture2D | scroll_hint_vertical |
StyleBox | focus |
StyleBox | panel |

---

## Signals

scroll_ended() 

Emitted when scrolling stops when dragging the scrollable area with a touch event. This signal is not emitted when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.

Note: This signal is only emitted on Android or iOS, or on desktop/web platforms when ProjectSettings.input_devices/pointing/emulate_touch_from_mouse is enabled.

---

scroll_started() 

Emitted when scrolling starts when dragging the scrollable area with a touch event. This signal is not emitted when scrolling by dragging the scrollbar, scrolling with the mouse wheel or scrolling with keyboard/gamepad events.

Note: This signal is only emitted on Android or iOS, or on desktop/web platforms when ProjectSettings.input_devices/pointing/emulate_touch_from_mouse is enabled.

---

## Enumerations

enum ScrollMode
ScrollMode SCROLL_MODE_DISABLED = 0

Scrolling disabled, scrollbar will be invisible.

ScrollMode SCROLL_MODE_AUTO = 1

Scrolling enabled, scrollbar will be visible only if necessary, i.e. container's content is bigger than the container.

ScrollMode SCROLL_MODE_SHOW_ALWAYS = 2

Scrolling enabled, scrollbar will be always visible.

ScrollMode SCROLL_MODE_SHOW_NEVER = 3

Scrolling enabled, scrollbar will be hidden.

ScrollMode SCROLL_MODE_RESERVE = 4

Combines SCROLL_MODE_AUTO and SCROLL_MODE_SHOW_ALWAYS. The scrollbar is only visible if necessary, but the content size is adjusted as if it was always visible. It's useful for ensuring that content size stays the same regardless if the scrollbar is visible.

ScrollMode SCROLL_MODE_MAXIMIZE_FIRST = 5

Behaves like SCROLL_MODE_AUTO, but makes the ScrollContainer report a minimum size based on its content (limited by Control.custom_maximum_size when set on the corresponding axis). This allows it to grow first and only start scrolling once constrained.

---

enum ScrollHintMode
ScrollHintMode SCROLL_HINT_MODE_DISABLED = 0

Scroll hints will never be shown.

ScrollHintMode SCROLL_HINT_MODE_ALL = 1

Scroll hints will be shown at the top and bottom (if vertical), or left and right (if horizontal).

ScrollHintMode SCROLL_HINT_MODE_TOP_AND_LEFT = 2

Scroll hints will be shown at the top (if vertical), or the left (if horizontal).

ScrollHintMode SCROLL_HINT_MODE_BOTTOM_AND_RIGHT = 3

Scroll hints will be shown at the bottom (if horizontal), or the right (if horizontal).

---

## Property Descriptions

bool draw_focus_border = false 

- void set_draw_focus_border(value: bool)
- bool get_draw_focus_border()

If true, focus is drawn when the ScrollContainer or one of its descendant nodes is focused.

---

bool follow_focus = false 

- void set_follow_focus(value: bool)
- bool is_following_focus()

If true, the ScrollContainer will automatically scroll to focused children (including indirect children) to make sure they are fully visible.

---

ScrollMode horizontal_scroll_mode = 1 

- void set_horizontal_scroll_mode(value: ScrollMode)
- ScrollMode get_horizontal_scroll_mode()

Controls whether horizontal scrollbar can be used and when it should be visible.

---

int scroll_deadzone = 0 

- void set_deadzone(value: int)
- int get_deadzone()

Deadzone for touch scrolling. Lower deadzone makes the scrolling more sensitive.

---

ScrollHintMode scroll_hint_mode = 0 

- void set_scroll_hint_mode(value: ScrollHintMode)
- ScrollHintMode get_scroll_hint_mode()

The way which scroll hints (indicators that show that the content can still be scrolled in a certain direction) will be shown.

Note: Hints won't be shown if the content can be scrolled both vertically and horizontally.

---

int scroll_horizontal = 0 

- void set_h_scroll(value: int)
- int get_h_scroll()

The current horizontal scroll value.

Note: If you are setting this value in the Node._ready() function or earlier, it needs to be wrapped with Object.set_deferred(), since scroll bar's Range.max_value is not initialized yet.

```gdscript
func _ready():
    set_deferred("scroll_horizontal", 600)
```

---

bool scroll_horizontal_by_default = false 

- void set_scroll_horizontal_by_default(value: bool)
- bool is_scroll_horizontal_by_default()

If true, the mouse wheel scrolls the view horizontally, and holding Shift scrolls vertically.

If false (default), the mouse wheel scrolls the view vertically, and holding Shift scrolls horizontally.

---

float scroll_horizontal_custom_step = -1.0 

- void set_horizontal_custom_step(value: float)
- float get_horizontal_custom_step()

Overrides the ScrollBar.custom_step used when clicking the internal scroll bar's horizontal increment and decrement buttons or when using arrow keys when the ScrollBar is focused.

---

int scroll_vertical = 0 

- void set_v_scroll(value: int)
- int get_v_scroll()

The current vertical scroll value.

Note: Setting it early needs to be deferred, just like in scroll_horizontal.

```gdscript
func _ready():
    set_deferred("scroll_vertical", 600)
```

---

float scroll_vertical_custom_step = -1.0 

- void set_vertical_custom_step(value: float)
- float get_vertical_custom_step()

Overrides the ScrollBar.custom_step used when clicking the internal scroll bar's vertical increment and decrement buttons or when using arrow keys when the ScrollBar is focused.

---

bool tile_scroll_hint = false 

- void set_tile_scroll_hint(value: bool)
- bool is_scroll_hint_tiled()

If true, the scroll hint texture will be tiled instead of stretched. See scroll_hint_mode.

---

ScrollMode vertical_scroll_mode = 1 

- void set_vertical_scroll_mode(value: ScrollMode)
- ScrollMode get_vertical_scroll_mode()

Controls whether vertical scrollbar can be used and when it should be visible.

---

## Method Descriptions

void ensure_control_visible(control: Control) 

Ensures the given control is visible (must be a direct or indirect child of the ScrollContainer). Used by follow_focus.

Note: This will not work on a node that was just added during the same frame. If you want to scroll to a newly added child, you must wait until the next frame using SceneTree.process_frame:

```gdscript
add_child(child_node)
await get_tree().process_frame
ensure_control_visible(child_node)
```

---

HScrollBar get_h_scroll_bar() 

Returns the horizontal scrollbar HScrollBar of this ScrollContainer.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to disable or hide a scrollbar, you can use horizontal_scroll_mode.

---

VScrollBar get_v_scroll_bar() 

Returns the vertical scrollbar VScrollBar of this ScrollContainer.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to disable or hide a scrollbar, you can use vertical_scroll_mode.

---

## Theme Property Descriptions

Color scroll_hint_horizontal_color = Color(0, 0, 0, 1) 

Color used to modulate the scroll_hint_horizontal texture.

---

Color scroll_hint_vertical_color = Color(0, 0, 0, 1) 

Color used to modulate the scroll_hint_vertical texture.

---

int scrollbar_h_separation = 0 

The space between the ScrollContainer's vertical scroll bar and its content, in pixels. No space will be added when the content's minimum size is larger than the ScrollContainer's size.

---

int scrollbar_v_separation = 0 

The space between the ScrollContainer's horizontal scroll bar and its content, in pixels. No space will be added when the content's minimum size is larger than the ScrollContainer's size.

---

Texture2D scroll_hint_horizontal 

The indicator that will be shown when the content can still be scrolled horizontally. See scroll_hint_mode.

---

Texture2D scroll_hint_vertical 

The indicator that will be shown when the content can still be scrolled vertically. See scroll_hint_mode.

---

StyleBox focus 

The focus border StyleBox of the ScrollContainer. Only used if draw_focus_border is true.

---

StyleBox panel 

The background StyleBox of the ScrollContainer.
