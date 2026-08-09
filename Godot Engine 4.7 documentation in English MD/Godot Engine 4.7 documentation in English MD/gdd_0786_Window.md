# Window

Inherits: Viewport < Node < Object

Inherited By: AcceptDialog, Popup

Base class for all windows, dialogs, and popups.

## Description

A node that creates a window. The window can either be a native system window or embedded inside another Window (see Viewport.gui_embed_subwindows).

At runtime, Windows will not close automatically when requested. You need to handle it manually using the close_requested signal (this applies both to pressing the close button and clicking outside of a popup).

## Tutorials

- HDR output
- Multiple Windows demo [https://github.com/godotengine/godot-demo-projects/tree/master/misc/multiple_windows]

## Properties

String | accessibility_description | ""
String | accessibility_name | ""
bool | always_on_top | false
bool | auto_translate |
bool | borderless | false
ContentScaleAspect | content_scale_aspect | 0
float | content_scale_factor | 1.0
ContentScaleMode | content_scale_mode | 0
Vector2i | content_scale_size | Vector2i(0, 0)
ContentScaleStretch | content_scale_stretch | 0
int | current_screen |
bool | exclude_from_capture | false
bool | exclusive | false
bool | extend_to_title | false
bool | force_native | false
bool | hdr_output_requested | false
WindowInitialPosition | initial_position | 0
bool | keep_title_visible | false
Vector2i | max_size | Vector2i(0, 0)
bool | maximize_disabled | false
Vector2i | min_size | Vector2i(0, 0)
bool | minimize_disabled | false
Mode | mode | 0
bool | mouse_passthrough | false
PackedVector2Array | mouse_passthrough_polygon | PackedVector2Array()
Rect2i | nonclient_area | Rect2i(0, 0, 0, 0)
bool | popup_window | false
bool | popup_wm_hint | false
Vector2i | position | Vector2i(0, 0)
bool | sharp_corners | false
Vector2i | size | Vector2i(100, 100)
Theme | theme |
StringName | theme_type_variation | &""
String | title | ""
bool | transient | false
bool | transient_to_focused | false
bool | transparent | false
bool | unfocusable | false
bool | unresizable | false
bool | visible | true
bool | wrap_controls | false

## Methods

Vector2 | _get_contents_minimum_size() virtual const
void | add_theme_color_override(name: StringName, color: Color)
void | add_theme_constant_override(name: StringName, constant: int)
void | add_theme_font_override(name: StringName, font: Font)
void | add_theme_font_size_override(name: StringName, font_size: int)
void | add_theme_icon_override(name: StringName, texture: Texture2D)
void | add_theme_stylebox_override(name: StringName, stylebox: StyleBox)
void | begin_bulk_theme_override()
bool | can_draw() const
void | child_controls_changed()
void | end_bulk_theme_override()
Vector2 | get_contents_minimum_size() const
bool | get_flag(flag: Flags) const
Window | get_focused_window() static
LayoutDirection | get_layout_direction() const
float | get_output_max_linear_value() const
Vector2i | get_position_with_decorations() const
Vector2i | get_size_with_decorations() const
Color | get_theme_color(name: StringName, theme_type: StringName = &"") const
int | get_theme_constant(name: StringName, theme_type: StringName = &"") const
float | get_theme_default_base_scale() const
Font | get_theme_default_font() const
int | get_theme_default_font_size() const
Font | get_theme_font(name: StringName, theme_type: StringName = &"") const
int | get_theme_font_size(name: StringName, theme_type: StringName = &"") const
Texture2D | get_theme_icon(name: StringName, theme_type: StringName = &"") const
StyleBox | get_theme_stylebox(name: StringName, theme_type: StringName = &"") const
int | get_window_id() const
void | grab_focus()
bool | has_focus() const
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
void | hide()
bool | is_embedded() const
bool | is_layout_rtl() const
bool | is_maximize_allowed() const
bool | is_using_font_oversampling() const
void | move_to_center()
void | move_to_foreground()
void | popup(rect: Rect2i = Rect2i(0, 0, 0, 0))
void | popup_centered(minsize: Vector2i = Vector2i(0, 0))
void | popup_centered_clamped(minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75)
void | popup_centered_ratio(ratio: float = 0.8)
void | popup_exclusive(from_node: Node, rect: Rect2i = Rect2i(0, 0, 0, 0))
void | popup_exclusive_centered(from_node: Node, minsize: Vector2i = Vector2i(0, 0))
void | popup_exclusive_centered_clamped(from_node: Node, minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75)
void | popup_exclusive_centered_ratio(from_node: Node, ratio: float = 0.8)
void | popup_exclusive_on_parent(from_node: Node, parent_rect: Rect2i)
void | popup_on_parent(parent_rect: Rect2i)
void | remove_theme_color_override(name: StringName)
void | remove_theme_constant_override(name: StringName)
void | remove_theme_font_override(name: StringName)
void | remove_theme_font_size_override(name: StringName)
void | remove_theme_icon_override(name: StringName)
void | remove_theme_stylebox_override(name: StringName)
void | request_attention()
void | reset_size()
void | set_flag(flag: Flags, enabled: bool)
void | set_ime_active(active: bool)
void | set_ime_position(position: Vector2i)
void | set_layout_direction(direction: LayoutDirection)
void | set_taskbar_progress_state(state: ProgressState)
void | set_taskbar_progress_value(value: float)
void | set_unparent_when_invisible(unparent: bool)
void | set_use_font_oversampling(enable: bool)
void | show()
void | start_drag()
void | start_resize(edge: WindowResizeEdge)

## Theme Properties

Color | title_color | Color(0.875, 0.875, 0.875, 1)
Color | title_outline_modulate | Color(0, 0, 0, 1)
int | close_h_offset | 18
int | close_v_offset | 24
int | resize_margin | 4
int | title_height | 36
int | title_outline_size | 0
Font | title_font |
int | title_font_size |
Texture2D | close |
Texture2D | close_pressed |
StyleBox | embedded_border |
StyleBox | embedded_unfocused_border |

---

## Signals

about_to_popup() 

Emitted right after popup() call, before the Window appears or does anything.

---

close_requested() 

Emitted when the Window's close button is pressed or when popup_window is enabled and user clicks outside the window.

This signal can be used to handle window closing, e.g. by connecting it to hide().

---

dpi_changed() 

Emitted when the Window's DPI changes as a result of OS-level changes (e.g. moving the window from a Retina display to a lower resolution one).

Note: Only implemented on macOS and Linux (Wayland).

---

files_dropped(files: PackedStringArray) 

Emitted when files are dragged from the OS file manager and dropped in the game window. The argument is a list of file paths.

```gdscript
func _ready():
    get_window().files_dropped.connect(on_files_dropped)
func on_files_dropped(files):
    print(files)
```

Note: This signal only works with native windows, i.e. the main window and Window-derived nodes when Viewport.gui_embed_subwindows is disabled in the main viewport.

---

focus_entered() 

Emitted when the Window gains focus.

---

focus_exited() 

Emitted when the Window loses its focus.

---

go_back_requested() 

Emitted when a go back request is sent (e.g. pressing the "Back" button on Android), right after Node.NOTIFICATION_WM_GO_BACK_REQUEST.

---

mouse_entered() 

Emitted when the mouse cursor enters the Window's visible area, that is not occluded behind other Controls or windows, provided its Viewport.gui_disable_input is false and regardless if it's currently focused or not.

---

mouse_exited() 

Emitted when the mouse cursor leaves the Window's visible area, that is not occluded behind other Controls or windows, provided its Viewport.gui_disable_input is false and regardless if it's currently focused or not.

---

nonclient_window_input(event: InputEvent) 

Emitted when the mouse event is received by the custom decoration area defined by nonclient_area, and normal input to the window is blocked (such as when it has an exclusive child opened). event's position is in the embedder's coordinate system.

---

output_max_linear_value_changed(output_max_linear_value: float) 

Emitted when the output max linear value returned by get_output_max_linear_value() has changed. This occurs when HDR output is enabled or disabled and when any HDR output luminance values of the window have changed, such as when the player adjusts their screen brightness setting or moves the window to a different screen. output_max_linear_value is the new value.

---

theme_changed() 

Emitted when the NOTIFICATION_THEME_CHANGED notification is sent.

---

title_changed() 

Emitted when window title bar text is changed.

---

titlebar_changed() 

Emitted when window title bar decorations are changed, e.g. macOS window enter/exit full screen mode, or extend-to-title flag is changed.

---

visibility_changed() 

Emitted when Window is made visible or disappears.

---

window_input(event: InputEvent) 

Emitted when the Window is currently focused and receives any input, passing the received event as an argument. The event's position, if present, is in the embedder's coordinate system.

---

## Enumerations

enum Mode
Mode MODE_WINDOWED = 0

Windowed mode, i.e. Window doesn't occupy the whole screen (unless set to the size of the screen).

Mode MODE_MINIMIZED = 1

Minimized window mode, i.e. Window is not visible and available on window manager's window list. Normally happens when the minimize button is pressed.

Mode MODE_MAXIMIZED = 2

Maximized window mode, i.e. Window will occupy whole screen area except task bar and still display its borders. Normally happens when the maximize button is pressed.

Mode MODE_FULLSCREEN = 3

Full screen mode with full multi-window support.

Full screen window covers the entire display area of a screen and has no decorations. The display's video mode is not changed.

On Android: This enables immersive mode.

On macOS: A new desktop is used to display the running project.

Note: Regardless of the platform, enabling full screen will change the window size to match the monitor's size. Therefore, make sure your project supports multiple resolutions when enabling full screen mode.

Mode MODE_EXCLUSIVE_FULLSCREEN = 4

A single window full screen mode. This mode has less overhead, but only one window can be open on a given screen at a time (opening a child window or application switching will trigger a full screen transition).

Full screen window covers the entire display area of a screen and has no border or decorations. The display's video mode is not changed.

Note: This mode might not work with screen recording software.

On Android: This enables immersive mode.

On Windows: Depending on video driver, full screen transition might cause screens to go black for a moment.

On macOS: A new desktop is used to display the running project. Exclusive full screen mode prevents Dock and Menu from showing up when the mouse pointer is hovering the edge of the screen.

On Linux (X11): Exclusive full screen mode bypasses compositor.

On Linux (Wayland): Equivalent to MODE_FULLSCREEN.

Note: Regardless of the platform, enabling full screen will change the window size to match the monitor's size. Therefore, make sure your project supports multiple resolutions when enabling full screen mode.

---

enum Flags
Flags FLAG_RESIZE_DISABLED = 0

The window can't be resized by dragging its resize grip. It's still possible to resize the window using size. This flag is ignored for full screen windows. Set with unresizable.

Note: This flag is implemented on Linux (X11), macOS, Windows, and embedded windows.

Flags FLAG_BORDERLESS = 1

The window do not have native title bar and other decorations. This flag is ignored for full-screen windows. Set with borderless.

Note: This flag is implemented on Linux (X11/Wayland), macOS, Windows, and embedded windows.

Flags FLAG_ALWAYS_ON_TOP = 2

The window is floating on top of all other windows. This flag is ignored for full-screen windows. Set with always_on_top.

Note: This flag is implemented on Linux (X11), macOS, Windows, and embedded windows.

Flags FLAG_TRANSPARENT = 3

The window background can be transparent. Set with transparent.

Note: This flag has no effect if either ProjectSettings.display/window/per_pixel_transparency/allowed, or the window's Viewport.transparent_bg is set to false.

Note: Transparency support is implemented on Linux (X11/Wayland), macOS, Windows, and embedded windows.

Flags FLAG_NO_FOCUS = 4

The window can't be focused. No-focus window will ignore all input, except mouse clicks. Set with unfocusable.

Note: This flag is implemented on Linux (X11), macOS, Windows, and embedded windows.

Flags FLAG_POPUP = 5

Window is part of menu or OptionButton dropdown. This flag can't be changed when the window is visible. An active popup window will exclusively receive all input, without stealing focus from its parent. Popup windows are automatically closed when uses click outside it, or when an application is switched. Popup window must have transient parent set (see transient).

Note: This flag is implemented on Linux (X11/Wayland), macOS, Windows, and embedded Popup windows.

Flags FLAG_EXTEND_TO_TITLE = 6

Window content is expanded to the full size of the window. Unlike borderless window, the frame is left intact and can be used to resize the window, title bar is transparent, but have minimize/maximize/close buttons. Set with extend_to_title.

Note: This flag has no effect in embedded windows.

Note: This flag is implemented only on macOS.

Flags FLAG_MOUSE_PASSTHROUGH = 7

All mouse events are passed to the underlying window of the same application.

Note: This flag has no effect in embedded windows.

Note: This flag is implemented on Linux (X11), macOS, Windows.

Flags FLAG_SHARP_CORNERS = 8

Window style is overridden, forcing sharp corners.

Note: This flag has no effect in embedded windows.

Note: This flag is implemented only on Windows (11).

Flags FLAG_EXCLUDE_FROM_CAPTURE = 9

Windows is excluded from screenshots taken by DisplayServer.screen_get_image(), DisplayServer.screen_get_image_rect(), and DisplayServer.screen_get_pixel().

Note: This flag has no effect in embedded windows.

Note: This flag is implemented on macOS and Windows (10, 20H1).

Note: Setting this flag will prevent standard screenshot methods from capturing a window image, but does NOT guarantee that other apps won't be able to capture an image. It should not be used as a DRM or security measure.

Flags FLAG_POPUP_WM_HINT = 10

Signals the window manager that this window is supposed to be an implementation-defined "popup" (usually a floating, borderless, untileable and immovable child window).

Note: This flag has no effect in embedded windows.

Note: This flag is implemented on Linux (Wayland).

Flags FLAG_MINIMIZE_DISABLED = 11

Window minimize button is disabled.

Note: This flag has no effect in embedded windows.

Note: This flag is implemented on Linux (X11), macOS, and Windows.

Flags FLAG_MAXIMIZE_DISABLED = 12

Window maximize button is disabled.

Note: This flag has no effect in embedded windows.

Note: This flag is implemented on Linux (X11), macOS, and Windows.

Flags FLAG_MAX = 13

Max value of the Flags.

---

enum ContentScaleMode
ContentScaleMode CONTENT_SCALE_MODE_DISABLED = 0

The content will not be scaled to match the Window's size (content_scale_size is ignored).

ContentScaleMode CONTENT_SCALE_MODE_CANVAS_ITEMS = 1

The content will be rendered at the target size. This is more performance-expensive than CONTENT_SCALE_MODE_VIEWPORT, but provides better results.

ContentScaleMode CONTENT_SCALE_MODE_VIEWPORT = 2

The content will be rendered at the base size and then scaled to the target size. More performant than CONTENT_SCALE_MODE_CANVAS_ITEMS, but results in pixelated image.

---

enum ContentScaleAspect
ContentScaleAspect CONTENT_SCALE_ASPECT_IGNORE = 0

The aspect will be ignored. Scaling will simply stretch the content to fit the target size.

ContentScaleAspect CONTENT_SCALE_ASPECT_KEEP = 1

The content's aspect will be preserved. If the target size has different aspect from the base one, the image will be centered and black bars will appear on left and right sides.

ContentScaleAspect CONTENT_SCALE_ASPECT_KEEP_WIDTH = 2

The content can be expanded vertically. Scaling horizontally will result in keeping the width ratio and then black bars on left and right sides.

ContentScaleAspect CONTENT_SCALE_ASPECT_KEEP_HEIGHT = 3

The content can be expanded horizontally. Scaling vertically will result in keeping the height ratio and then black bars on top and bottom sides.

ContentScaleAspect CONTENT_SCALE_ASPECT_EXPAND = 4

The content's aspect will be preserved. If the target size has different aspect from the base one, the content will stay in the top-left corner and add an extra visible area in the stretched space.

---

enum ContentScaleStretch
ContentScaleStretch CONTENT_SCALE_STRETCH_FRACTIONAL = 0

The content will be stretched according to a fractional factor. This fills all the space available in the window, but allows "pixel wobble" to occur due to uneven pixel scaling.

ContentScaleStretch CONTENT_SCALE_STRETCH_INTEGER = 1

The content will be stretched only according to an integer factor, preserving sharp pixels. This may leave a black background visible on the window's edges depending on the window size.

---

enum LayoutDirection
LayoutDirection LAYOUT_DIRECTION_INHERITED = 0

Automatic layout direction, determined from the parent window layout direction.

LayoutDirection LAYOUT_DIRECTION_APPLICATION_LOCALE = 1

Automatic layout direction, determined from the current locale.

LayoutDirection LAYOUT_DIRECTION_LTR = 2

Left-to-right layout direction.

LayoutDirection LAYOUT_DIRECTION_RTL = 3

Right-to-left layout direction.

LayoutDirection LAYOUT_DIRECTION_SYSTEM_LOCALE = 4

Automatic layout direction, determined from the system locale.

LayoutDirection LAYOUT_DIRECTION_MAX = 5

Represents the size of the LayoutDirection enum.

LayoutDirection LAYOUT_DIRECTION_LOCALE = 1

Deprecated: Use LAYOUT_DIRECTION_APPLICATION_LOCALE instead.

---

enum WindowInitialPosition
WindowInitialPosition WINDOW_INITIAL_POSITION_ABSOLUTE = 0

Initial window position is determined by position.

WindowInitialPosition WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN = 1

Initial window position is the center of the primary screen.

WindowInitialPosition WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN = 2

Initial window position is the center of the main window screen.

WindowInitialPosition WINDOW_INITIAL_POSITION_CENTER_OTHER_SCREEN = 3

Initial window position is the center of current_screen screen.

WindowInitialPosition WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS = 4

Initial window position is the center of the screen containing the mouse pointer.

WindowInitialPosition WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_KEYBOARD_FOCUS = 5

Initial window position is the center of the screen containing the window with the keyboard focus.

---

## Constants

NOTIFICATION_VISIBILITY_CHANGED = 30 

Emitted when Window's visibility changes, right before visibility_changed.

NOTIFICATION_THEME_CHANGED = 32 

Sent when the node needs to refresh its theme items. This happens in one of the following cases:

- The theme property is changed on this node or any of its ancestors.
- The theme_type_variation property is changed on this node.
- The node enters the scene tree.

Note: As an optimization, this notification won't be sent from changes that occur while this node is outside of the scene tree. Instead, all of the theme item updates can be applied at once when the node enters the scene tree.

---

## Property Descriptions

String accessibility_description = "" 

- void set_accessibility_description(value: String)
- String get_accessibility_description()

The human-readable node description that is reported to assistive apps.

---

String accessibility_name = "" 

- void set_accessibility_name(value: String)
- String get_accessibility_name()

The human-readable node name that is reported to assistive apps.

---

bool always_on_top = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the window will be on top of all other windows. Does not work if transient is enabled.

---

bool auto_translate 

- void set_auto_translate(value: bool)
- bool is_auto_translating()

Deprecated: Use Node.auto_translate_mode and Node.can_auto_translate() instead.

Toggles if any text should automatically change to its translated version depending on the current locale.

---

bool borderless = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the window will have no borders.

---

ContentScaleAspect content_scale_aspect = 0 

- void set_content_scale_aspect(value: ContentScaleAspect)
- ContentScaleAspect get_content_scale_aspect()

Specifies how the content's aspect behaves when the Window is resized. The base aspect is determined by content_scale_size.

---

float content_scale_factor = 1.0 

- void set_content_scale_factor(value: float)
- float get_content_scale_factor()

Specifies the base scale of Window's content when its size is equal to content_scale_size. See also Viewport.get_stretch_transform().

---

ContentScaleMode content_scale_mode = 0 

- void set_content_scale_mode(value: ContentScaleMode)
- ContentScaleMode get_content_scale_mode()

Specifies how the content is scaled when the Window is resized.

---

Vector2i content_scale_size = Vector2i(0, 0) 

- void set_content_scale_size(value: Vector2i)
- Vector2i get_content_scale_size()

The content's base size in "virtual" pixels. Not to be confused with size, which sets the actual window's physical size in pixels. If set to a value greater than 0 and content_scale_mode is set to a value other than CONTENT_SCALE_MODE_DISABLED, the Window's content will be scaled when the window is resized to a different size. Higher values will make the content appear smaller, as it will be able to fit more of the project in view. On the root Window, this is set to match ProjectSettings.display/window/size/viewport_width and ProjectSettings.display/window/size/viewport_height by default.

For example, when using CONTENT_SCALE_MODE_CANVAS_ITEMS and content_scale_size set to Vector2i(1280, 720), using a window size of 2560×1440 will make 2D elements appear at double their original size, as the content is scaled by a factor of 2.0 (2560.0 / 1280.0 = 2.0, 1440.0 / 720.0 = 2.0).

See the Base size section of the Multiple resolutions documentation for details.

---

ContentScaleStretch content_scale_stretch = 0 

- void set_content_scale_stretch(value: ContentScaleStretch)
- ContentScaleStretch get_content_scale_stretch()

The policy to use to determine the final scale factor for 2D elements. This affects how content_scale_factor is applied, in addition to the automatic scale factor determined by content_scale_size.

---

int current_screen 

- void set_current_screen(value: int)
- int get_current_screen()

The screen the window is currently on.

---

bool exclude_from_capture = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window is excluded from screenshots taken by DisplayServer.screen_get_image(), DisplayServer.screen_get_image_rect(), and DisplayServer.screen_get_pixel().

Note: This property is implemented on macOS and Windows.

Note: Enabling this setting will prevent standard screenshot methods from capturing a window image, but does NOT guarantee that other apps won't be able to capture an image. It should not be used as a DRM or security measure.

---

bool exclusive = false 

- void set_exclusive(value: bool)
- bool is_exclusive()

If true, the Window will be in exclusive mode. Exclusive windows are always on top of their parent and will block all input going to the parent Window.

Needs transient enabled to work.

---

bool extend_to_title = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window contents is expanded to the full size of the window, window title bar is transparent.

Note: This property is implemented only on macOS.

Note: This property only works with native windows.

---

bool force_native = false 

- void set_force_native(value: bool)
- bool get_force_native()

If true, native window will be used regardless of parent viewport and project settings.

---

bool hdr_output_requested = false 

- void set_hdr_output_requested(value: bool)
- bool is_hdr_output_requested()

If true, requests HDR output for the Window, falling back to SDR if not supported, and automatically switching between HDR and SDR as the window moves between screens, screen capabilities change, or system settings are modified. This will internally force Viewport.use_hdr_2d to be enabled on the main Viewport. All other SubViewport of this Window must have their Viewport.use_hdr_2d property enabled to produce HDR output.

---

WindowInitialPosition initial_position = 0 

- void set_initial_position(value: WindowInitialPosition)
- WindowInitialPosition get_initial_position()

Specifies the initial type of position for the Window.

---

bool keep_title_visible = false 

- void set_keep_title_visible(value: bool)
- bool get_keep_title_visible()

If true, the Window width is expanded to keep the title bar text fully visible.

---

Vector2i max_size = Vector2i(0, 0) 

- void set_max_size(value: Vector2i)
- Vector2i get_max_size()

If non-zero, the Window can't be resized to be bigger than this size.

Note: This property will be ignored if the value is lower than min_size.

---

bool maximize_disabled = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window's maximize button is disabled.

Note: If both minimize and maximize buttons are disabled, buttons are fully hidden, and only close button is visible.

Note: This property is implemented only on macOS and Windows.

---

Vector2i min_size = Vector2i(0, 0) 

- void set_min_size(value: Vector2i)
- Vector2i get_min_size()

If non-zero, the Window can't be resized to be smaller than this size.

Note: This property will be ignored in favor of get_contents_minimum_size() if wrap_controls is enabled and if its size is bigger.

---

bool minimize_disabled = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window's minimize button is disabled.

Note: If both minimize and maximize buttons are disabled, buttons are fully hidden, and only close button is visible.

Note: This property is implemented only on macOS and Windows.

---

Mode mode = 0 

- void set_mode(value: Mode)
- Mode get_mode()

Set's the window's current mode.

Note: Fullscreen mode is not exclusive full screen on Windows and Linux.

Note: This method only works with native windows, i.e. the main window and Window-derived nodes when Viewport.gui_embed_subwindows is disabled in the main viewport.

---

bool mouse_passthrough = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, all mouse events will be passed to the underlying window of the same application. See also mouse_passthrough_polygon.

Note: This property is implemented on Linux (X11), macOS and Windows.

Note: This property only works with native windows.

---

PackedVector2Array mouse_passthrough_polygon = PackedVector2Array() 

- void set_mouse_passthrough_polygon(value: PackedVector2Array)
- PackedVector2Array get_mouse_passthrough_polygon()

Sets a polygonal region of the window which accepts mouse events. Mouse events outside the region will be passed through.

Passing an empty array will disable passthrough support (all mouse events will be intercepted by the window, which is the default behavior).

```
# Set region, using Path2D node.
$Window.mouse_passthrough_polygon = $Path2D.curve.get_baked_points()
# Set region, using Polygon2D node.
$Window.mouse_passthrough_polygon = $Polygon2D.polygon
# Reset region to default.
$Window.mouse_passthrough_polygon = []
```

```
// Set region, using Path2D node.
GetNode("Window").MousePassthroughPolygon = GetNode("Path2D").Curve.GetBakedPoints();
// Set region, using Polygon2D node.
GetNode("Window").MousePassthroughPolygon = GetNode("Polygon2D").Polygon;
// Reset region to default.
GetNode("Window").MousePassthroughPolygon = [];
```

Note: This property is ignored if mouse_passthrough is set to true.

Note: On Windows, the portion of a window that lies outside the region is not drawn, while on Linux (X11) and macOS it is.

Note: This property is implemented on Linux (X11), macOS and Windows.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

Rect2i nonclient_area = Rect2i(0, 0, 0, 0) 

- void set_nonclient_area(value: Rect2i)
- Rect2i get_nonclient_area()

If set, defines the window's custom decoration area which will receive mouse input, even if normal input to the window is blocked (such as when it has an exclusive child opened). See also nonclient_window_input.

---

bool popup_window = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window will be considered a popup. Popups are sub-windows that don't show as separate windows in system's window manager's window list and will send close request when anything is clicked outside of them (unless exclusive is enabled).

---

bool popup_wm_hint = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window will signal to the window manager that it is supposed to be an implementation-defined "popup" (usually a floating, borderless, untileable and immovable child window).

---

Vector2i position = Vector2i(0, 0) 

- void set_position(value: Vector2i)
- Vector2i get_position()

The window's position in pixels.

If ProjectSettings.display/window/subwindows/embed_subwindows is false, the position is in absolute screen coordinates. This typically applies to editor plugins. If the setting is true, the window's position is in the coordinates of its parent Viewport.

Note: This property only works if initial_position is set to WINDOW_INITIAL_POSITION_ABSOLUTE.

---

bool sharp_corners = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window will override the OS window style to display sharp corners.

Note: This property is implemented only on Windows (11).

Note: This property only works with native windows.

---

Vector2i size = Vector2i(100, 100) 

- void set_size(value: Vector2i)
- Vector2i get_size()

The window's size in pixels. See also content_scale_size, which doesn't set the window's physical size but affects how scaling works relative to the current content_scale_mode.

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

The name of a theme type variation used by this Window to look up its own theme items. See Control.theme_type_variation for more details.

---

String title = "" 

- void set_title(value: String)
- String get_title()

The window's title. If the Window is native, title styles set in Theme will have no effect.

---

bool transient = false 

- void set_transient(value: bool)
- bool is_transient()

If true, the Window is transient, i.e. it's considered a child of another Window. The transient window will be destroyed with its transient parent and will return focus to their parent when closed. The transient window is displayed on top of a non-exclusive full-screen parent window. Transient windows can't enter full-screen mode.

Note that behavior might be different depending on the platform.

---

bool transient_to_focused = false 

- void set_transient_to_focused(value: bool)
- bool is_transient_to_focused()

If true, and the Window is transient, this window will (at the time of becoming visible) become transient to the currently focused window instead of the immediate parent window in the hierarchy. Note that the transient parent is assigned at the time this window becomes visible, so changing it afterwards has no effect until re-shown.

---

bool transparent = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window's background can be transparent. This is best used with embedded windows.

Note: Transparency support is implemented on Linux, macOS and Windows, but availability might vary depending on GPU driver, display manager, and compositor capabilities.

Note: This property has no effect if ProjectSettings.display/window/per_pixel_transparency/allowed is set to false.

---

bool unfocusable = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the Window can't be focused nor interacted with. It can still be visible.

---

bool unresizable = false 

- void set_flag(flag: Flags, enabled: bool)
- bool get_flag(flag: Flags) const

If true, the window can't be resized.

---

bool visible = true 

- void set_visible(value: bool)
- bool is_visible()

If true, the window is visible.

---

bool wrap_controls = false 

- void set_wrap_controls(value: bool)
- bool is_wrapping_controls()

If true, the window's size will automatically update when a child node is added or removed, ignoring min_size if the new size is bigger.

If false, you need to call child_controls_changed() manually.

---

## Method Descriptions

Vector2 _get_contents_minimum_size() virtual const 

Virtual method to be implemented by the user. Overrides the value returned by get_contents_minimum_size().

---

void add_theme_color_override(name: StringName, color: Color) 

Creates a local override for a theme Color with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_color_override().

See also get_theme_color() and Control.add_theme_color_override() for more details.

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

See also get_theme_stylebox() and Control.add_theme_stylebox_override() for more details.

---

void begin_bulk_theme_override() 

Prevents *_theme_*_override methods from emitting NOTIFICATION_THEME_CHANGED until end_bulk_theme_override() is called.

---

bool can_draw() const 

Returns whether the window is being drawn to the screen.

---

void child_controls_changed() 

Requests an update of the Window size to fit underlying Control nodes.

---

void end_bulk_theme_override() 

Ends a bulk theme override update. See begin_bulk_theme_override().

---

Vector2 get_contents_minimum_size() const 

Returns the combined minimum size from the child Control nodes of the window. Use child_controls_changed() to update it when child nodes have changed.

The value returned by this method can be overridden with _get_contents_minimum_size().

---

bool get_flag(flag: Flags) const 

Returns true if the flag is set.

---

Window get_focused_window() static 

Returns the focused window.

---

LayoutDirection get_layout_direction() const 

Returns layout direction and text writing direction.

---

float get_output_max_linear_value() const 

Returns the maximum value for linear color components that can be displayed in this window, regardless of SDR or HDR output. Returns 1.0 if HDR is not enabled or not supported. The output_max_linear_value_changed signal will be emitted whenever this value changes.

This value is used by tonemapping and other Environment effects to ensure that bright colors are presented in the range that can be displayed by this window. When using this maximum linear value in your project, it should only be used to present colors directly to the screen without tonemapping and without influencing lighting, post-processing effects, or surrounding color. The following is an example that produces the brightest purple color that the screen can produce:

```
func _process(_delta):
    # output_max_linear_value may change often, so do this every frame.
    var max_linear_value = get_window().get_output_max_linear_value()
    # Replace this with your color:
    var original_color = Color.PURPLE
    # Normalize to max_linear_value to produce the brightest color possible,
    # regardless of SDR or HDR output:
    var bright_color = normalize_color(original_color, max_linear_value)
func normalize_color(srgb_color, max_linear_value = 1.0):
    # Color must be linear-encoded to use math operations.
    var linear_color = srgb_color.srgb_to_linear()
    var max_rgb_value = maxf(linear_color.r, maxf(linear_color.g, linear_color.b))
    var brightness_scale = max_linear_value / max_rgb_value
    linear_color *= brightness_scale
    # Undo changes to the alpha channel, which should not be modified.
    linear_color.a = srgb_color.a
    # Convert back to nonlinear sRGB encoding, which is required for Color in
    # Godot unless stated otherwise.
    return linear_color.linear_to_srgb()
```

Note: You will need to convert sRGB colors to linear before multiplying by this value to get correct results.

---

Vector2i get_position_with_decorations() const 

Returns the window's position including its border.

Note: If visible is false, this method returns the same value as position.

---

Vector2i get_size_with_decorations() const 

Returns the window's size including its border.

Note: If visible is false, this method returns the same value as size.

---

Color get_theme_color(name: StringName, theme_type: StringName = &"") const 

Returns a Color from the first matching Theme in the tree if that Theme has a color item with the specified name and theme_type.

See Control.get_theme_color() for more details.

---

int get_theme_constant(name: StringName, theme_type: StringName = &"") const 

Returns a constant from the first matching Theme in the tree if that Theme has a constant item with the specified name and theme_type.

See Control.get_theme_color() for more details.

---

float get_theme_default_base_scale() const 

Returns the default base scale value from the first matching Theme in the tree if that Theme has a valid Theme.default_base_scale value.

See Control.get_theme_color() for details.

---

Font get_theme_default_font() const 

Returns the default font from the first matching Theme in the tree if that Theme has a valid Theme.default_font value.

See Control.get_theme_color() for details.

---

int get_theme_default_font_size() const 

Returns the default font size value from the first matching Theme in the tree if that Theme has a valid Theme.default_font_size value.

See Control.get_theme_color() for details.

---

Font get_theme_font(name: StringName, theme_type: StringName = &"") const 

Returns a Font from the first matching Theme in the tree if that Theme has a font item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

int get_theme_font_size(name: StringName, theme_type: StringName = &"") const 

Returns a font size from the first matching Theme in the tree if that Theme has a font size item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

Texture2D get_theme_icon(name: StringName, theme_type: StringName = &"") const 

Returns an icon from the first matching Theme in the tree if that Theme has an icon item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

StyleBox get_theme_stylebox(name: StringName, theme_type: StringName = &"") const 

Returns a StyleBox from the first matching Theme in the tree if that Theme has a stylebox item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

int get_window_id() const 

Returns the ID of the window.

---

void grab_focus() 

Causes the window to grab focus, allowing it to receive user input.

---

bool has_focus() const 

Returns true if the window is focused.

---

bool has_theme_color(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a color item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_color_override(name: StringName) const 

Returns true if there is a local override for a theme Color with the specified name in this Control node.

See add_theme_color_override().

---

bool has_theme_constant(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a constant item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_constant_override(name: StringName) const 

Returns true if there is a local override for a theme constant with the specified name in this Control node.

See add_theme_constant_override().

---

bool has_theme_font(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a font item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_font_override(name: StringName) const 

Returns true if there is a local override for a theme Font with the specified name in this Control node.

See add_theme_font_override().

---

bool has_theme_font_size(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a font size item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_font_size_override(name: StringName) const 

Returns true if there is a local override for a theme font size with the specified name in this Control node.

See add_theme_font_size_override().

---

bool has_theme_icon(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has an icon item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_icon_override(name: StringName) const 

Returns true if there is a local override for a theme icon with the specified name in this Control node.

See add_theme_icon_override().

---

bool has_theme_stylebox(name: StringName, theme_type: StringName = &"") const 

Returns true if there is a matching Theme in the tree that has a stylebox item with the specified name and theme_type.

See Control.get_theme_color() for details.

---

bool has_theme_stylebox_override(name: StringName) const 

Returns true if there is a local override for a theme StyleBox with the specified name in this Control node.

See add_theme_stylebox_override().

---

void hide() 

Hides the window. This is not the same as minimized state. Hidden window can't be interacted with and needs to be made visible with show().

---

bool is_embedded() const 

Returns true if the window is currently embedded in another window.

---

bool is_layout_rtl() const 

Returns true if the layout is right-to-left.

---

bool is_maximize_allowed() const 

Returns true if the window can be maximized (the maximize button is enabled).

---

bool is_using_font_oversampling() const 

Returns true if font oversampling is enabled. See set_use_font_oversampling().

---

void move_to_center() 

Centers the window in the current screen. If the window is embedded, it is centered in the embedder Viewport instead.

---

void move_to_foreground() 

Deprecated: Use grab_focus() instead.

Causes the window to grab focus, allowing it to receive user input.

---

void popup(rect: Rect2i = Rect2i(0, 0, 0, 0)) 

Shows the Window and makes it transient (see transient). If rect is provided, it will be set as the Window's size. Fails if called on the main window.

If ProjectSettings.display/window/subwindows/embed_subwindows is true (single-window mode), rect's coordinates are global and relative to the main window's top-left corner (excluding window decorations). If rect's position coordinates are negative, the window will be located outside the main window and may not be visible as a result.

If ProjectSettings.display/window/subwindows/embed_subwindows is false (multi-window mode), rect's coordinates are global and relative to the top-left corner of the leftmost screen. If rect's position coordinates are negative, the window will be placed at the top-left corner of the screen.

Note: rect must be in global coordinates if specified.

---

void popup_centered(minsize: Vector2i = Vector2i(0, 0)) 

Popups the Window at the center of the current screen, with optionally given minimum size. If the Window is embedded, it will be centered in the parent Viewport instead.

Note: Calling it with the default value of minsize is equivalent to calling it with size.

---

void popup_centered_clamped(minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75) 

Popups the Window centered inside its parent Window. fallback_ratio determines the maximum size of the Window, in relation to its parent.

Note: Calling it with the default value of minsize is equivalent to calling it with size.

---

void popup_centered_ratio(ratio: float = 0.8) 

If Window is embedded, popups the Window centered inside its embedder and sets its size as a ratio of embedder's size.

If Window is a native window, popups the Window centered inside the screen of its parent Window and sets its size as a ratio of the screen size.

---

void popup_exclusive(from_node: Node, rect: Rect2i = Rect2i(0, 0, 0, 0)) 

Attempts to parent this dialog to the last exclusive window relative to from_node, and then calls popup() on it. The dialog must have no current parent, otherwise the method fails.

See also set_unparent_when_invisible() and Node.get_last_exclusive_window().

---

void popup_exclusive_centered(from_node: Node, minsize: Vector2i = Vector2i(0, 0)) 

Attempts to parent this dialog to the last exclusive window relative to from_node, and then calls popup_centered() on it. The dialog must have no current parent, otherwise the method fails.

See also set_unparent_when_invisible() and Node.get_last_exclusive_window().

---

void popup_exclusive_centered_clamped(from_node: Node, minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75) 

Attempts to parent this dialog to the last exclusive window relative to from_node, and then calls popup_centered_clamped() on it. The dialog must have no current parent, otherwise the method fails.

See also set_unparent_when_invisible() and Node.get_last_exclusive_window().

---

void popup_exclusive_centered_ratio(from_node: Node, ratio: float = 0.8) 

Attempts to parent this dialog to the last exclusive window relative to from_node, and then calls popup_centered_ratio() on it. The dialog must have no current parent, otherwise the method fails.

See also set_unparent_when_invisible() and Node.get_last_exclusive_window().

---

void popup_exclusive_on_parent(from_node: Node, parent_rect: Rect2i) 

Attempts to parent this dialog to the last exclusive window relative to from_node, and then calls popup_on_parent() on it. The dialog must have no current parent, otherwise the method fails.

See also set_unparent_when_invisible() and Node.get_last_exclusive_window().

---

void popup_on_parent(parent_rect: Rect2i) 

Popups the Window with a position shifted by parent Window's position. If the Window is embedded, has the same effect as popup().

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

void request_attention() 

Tells the OS that the Window needs an attention. This makes the window stand out in some way depending on the system, e.g. it might blink on the task bar.

---

void reset_size() 

Resets the size to the minimum size, which is the max of min_size and (if wrap_controls is enabled) get_contents_minimum_size(). This is equivalent to calling set_size(Vector2i()) (or any size below the minimum).

---

void set_flag(flag: Flags, enabled: bool) 

Sets a specified window flag.

---

void set_ime_active(active: bool) 

If active is true, enables system's native IME (Input Method Editor).

---

void set_ime_position(position: Vector2i) 

Moves IME to the given position.

---

void set_layout_direction(direction: LayoutDirection) 

Sets layout direction and text writing direction. Right-to-left layouts are necessary for certain languages (e.g. Arabic and Hebrew).

---

void set_taskbar_progress_state(state: ProgressState) 

Sets the type and state of the progress bar on the taskbar/dock icon of the Window. See ProgressState for possible values and how each mode behaves.

Note: This method is implemented only on Windows and macOS.

---

void set_taskbar_progress_value(value: float) 

Creates a progress bar on the taskbar/dock icon of the Window if it does not exist, sets the progress of the icon.

value acts as a relative percentage value, ranges from 0.0 (lowest) to 1.0 (highest).

Note: This method is implemented only on Windows and macOS.

---

void set_unparent_when_invisible(unparent: bool) 

If unparent is true, the window is automatically unparented when going invisible.

Note: Make sure to keep a reference to the node, otherwise it will be orphaned. You also need to manually call Node.queue_free() to free the window if it's not parented.

---

void set_use_font_oversampling(enable: bool) 

Enables font oversampling. This makes fonts look better when they are scaled up.

---

void show() 

Makes the Window appear. This enables interactions with the Window and doesn't change any of its property other than visibility (unlike e.g. popup()).

---

void start_drag() 

Starts an interactive drag operation on the window, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's title bar. Using this method allows the window to participate in space switching, tiling, and other system features.

---

void start_resize(edge: WindowResizeEdge) 

Starts an interactive resize operation on the window, using the current mouse position. Call this method when handling a mouse button being pressed to simulate a pressed event on the window's edge.

---

## Theme Property Descriptions

Color title_color = Color(0.875, 0.875, 0.875, 1) 

The color of the title's text.

---

Color title_outline_modulate = Color(0, 0, 0, 1) 

The color of the title's text outline.

---

int close_h_offset = 18 

Horizontal position offset of the close button, relative to the end of the title bar, towards the beginning of the title bar.

---

int close_v_offset = 24 

Vertical position offset of the close button, relative to the bottom of the title bar, towards the top of the title bar.

---

int resize_margin = 4 

Defines the outside margin at which the window border can be grabbed with mouse and resized.

---

int title_height = 36 

Height of the title bar.

---

int title_outline_size = 0 

The size of the title outline.

---

Font title_font 

The font used to draw the title.

---

int title_font_size 

The size of the title font.

---

Texture2D close 

The icon for the close button.

---

Texture2D close_pressed 

The icon for the close button when it's being pressed.

---

StyleBox embedded_border 

The background style used when the Window is embedded. Note that this is drawn only under the window's content, excluding the title. For proper borders and title bar style, you can use expand_margin_* properties of StyleBoxFlat.

Note: The content background will not be visible unless transparent is enabled.

---

StyleBox embedded_unfocused_border 

The background style used when the Window is embedded and unfocused.
