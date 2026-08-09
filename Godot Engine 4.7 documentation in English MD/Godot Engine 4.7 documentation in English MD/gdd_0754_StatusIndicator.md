# StatusIndicator

Inherits: Node < Object

Application status indicator (aka notification area icon).

Note: Status indicator is implemented on macOS and Windows.

## Properties

Texture2D | icon |
NodePath | menu | NodePath("")
String | tooltip | ""
bool | visible | true

## Methods

Rect2 | get_rect() const

---

## Signals

pressed(mouse_button: int, mouse_position: Vector2i) 

Emitted when the status indicator is pressed.

---

## Property Descriptions

Texture2D icon 

- void set_icon(value: Texture2D)
- Texture2D get_icon()

Status indicator icon.

---

NodePath menu = NodePath("") 

- void set_menu(value: NodePath)
- NodePath get_menu()

Status indicator native popup menu. If this is set, the pressed signal is not emitted.

Note: Native popup is only supported if NativeMenu supports NativeMenu.FEATURE_POPUP_MENU feature.

---

String tooltip = "" 

- void set_tooltip(value: String)
- String get_tooltip()

Status indicator tooltip.

---

bool visible = true 

- void set_visible(value: bool)
- bool is_visible()

If true, the status indicator is visible.

---

## Method Descriptions

Rect2 get_rect() const 

Returns the status indicator rectangle in screen coordinates. If this status indicator is not visible, returns an empty Rect2.
