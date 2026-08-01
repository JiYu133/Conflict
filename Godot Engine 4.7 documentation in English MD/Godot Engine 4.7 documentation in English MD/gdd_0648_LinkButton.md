# LinkButton

Inherits: BaseButton < Control < CanvasItem < Node < Object

A button that represents a link.

## Description

A button that represents a link. This type of button is primarily used for interactions that cause a context change (like linking to a web page).

See also BaseButton which contains common properties and methods associated with this node.

## Properties

String | ellipsis_char | "…"
FocusMode | focus_mode | 3 (overrides Control)
String | language | ""
CursorShape | mouse_default_cursor_shape | 2 (overrides Control)
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
String | text | ""
TextDirection | text_direction | 0
OverrunBehavior | text_overrun_behavior | 0
UnderlineMode | underline | 0
String | uri | ""

## Theme Properties

Color | font_color | Color(0.875, 0.875, 0.875, 1)
Color | font_disabled_color | Color(0, 0, 0, 1)
Color | font_focus_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_pressed_color | Color(0, 0, 0, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_pressed_color | Color(1, 1, 1, 1)
int | outline_size | 0
int | underline_spacing | 2
Font | font |
int | font_size |
StyleBox | focus |

---

## Enumerations

enum UnderlineMode
UnderlineMode UNDERLINE_MODE_ALWAYS = 0

The LinkButton will always show an underline at the bottom of its text.

UnderlineMode UNDERLINE_MODE_ON_HOVER = 1

The LinkButton will show an underline at the bottom of its text when the mouse cursor is over it.

UnderlineMode UNDERLINE_MODE_NEVER = 2

The LinkButton will never show an underline at the bottom of its text.

---

## Property Descriptions

String ellipsis_char = "…" 

- void set_ellipsis_char(value: String)
- String get_ellipsis_char()

Ellipsis character used for text clipping.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

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

The button's text that will be displayed inside the button's area.

---

TextDirection text_direction = 0 

- void set_text_direction(value: TextDirection)
- TextDirection get_text_direction()

Base text writing direction.

---

OverrunBehavior text_overrun_behavior = 0 

- void set_text_overrun_behavior(value: OverrunBehavior)
- OverrunBehavior get_text_overrun_behavior()

Sets the clipping behavior when the text exceeds the node's bounding rectangle.

---

UnderlineMode underline = 0 

- void set_underline_mode(value: UnderlineMode)
- UnderlineMode get_underline_mode()

The underline mode to use for the text.

---

String uri = "" 

- void set_uri(value: String)
- String get_uri()

The URI [https://en.wikipedia.org/wiki/Uniform_Resource_Identifier] for this LinkButton. If set to a valid URI, pressing the button opens the URI using the operating system's default program for the protocol (via OS.shell_open()). HTTP and HTTPS URLs open the default web browser.

```
uri = "https://godotengine.org"  # Opens the URL in the default web browser.
uri = "C:\SomeFolder"  # Opens the file explorer at the given path.
uri = "C:\SomeImage.png"  # Opens the given image in the default viewing app.
```

```
Uri = "https://godotengine.org"; // Opens the URL in the default web browser.
Uri = "C:\SomeFolder"; // Opens the file explorer at the given path.
Uri = "C:\SomeImage.png"; // Opens the given image in the default viewing app.
```

---

## Theme Property Descriptions

Color font_color = Color(0.875, 0.875, 0.875, 1) 

Default text Color of the LinkButton.

---

Color font_disabled_color = Color(0, 0, 0, 1) 

Text Color used when the LinkButton is disabled.

---

Color font_focus_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the LinkButton is focused. Only replaces the normal text color of the button. Disabled, hovered, and pressed states take precedence over this color.

---

Color font_hover_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the LinkButton is being hovered.

---

Color font_hover_pressed_color = Color(0, 0, 0, 1) 

Text Color used when the LinkButton is being hovered and pressed.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the LinkButton.

---

Color font_pressed_color = Color(1, 1, 1, 1) 

Text Color used when the LinkButton is being pressed.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int underline_spacing = 2 

The vertical space between the baseline of text and the underline.

---

Font font 

Font of the LinkButton's text.

---

int font_size 

Font size of the LinkButton's text.

---

StyleBox focus 

StyleBox used when the LinkButton is focused. The focus StyleBox is displayed over the base StyleBox, so a partially transparent StyleBox should be used to ensure the base StyleBox remains visible. A StyleBox that represents an outline or an underline works well for this purpose. To disable the focus visual effect, assign a StyleBoxEmpty resource. Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.
