# Button

Inherits: BaseButton < Control < CanvasItem < Node < Object

Inherited By: CheckBox, CheckButton, ColorPickerButton, MenuButton, OptionButton

A themed button that can contain text and an icon.

## Description

Button is the standard themed button. It can contain text and an icon, and it will display them according to the current Theme.

Example: Create a button and connect a method that will be called when the button is pressed:

```
func _ready():
    var button = Button.new()
    button.text = "Click me"
    button.pressed.connect(_button_pressed)
    add_child(button)
func _button_pressed():
    print("Hello world!")
```

```
public override void _Ready()
{
    var button = new Button();
    button.Text = "Click me";
    button.Pressed += ButtonPressed;
    AddChild(button);
}
private void ButtonPressed()
{
    GD.Print("Hello world!");
}
```

See also BaseButton which contains common properties and methods associated with this node.

Note: Buttons support multitouch via touch input, allowing multiple buttons to be pressed at the same time. Otherwise, mouse input is used, limiting interaction to one button press at a time.

## Tutorials

- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]
- Operating System Testing Demo [https://godotengine.org/asset-library/asset/2789]

## Properties

HorizontalAlignment | alignment | 1
AutowrapMode | autowrap_mode | 0
BitField[LineBreakFlag] | autowrap_trim_flags | 128
bool | clip_text | false
bool | expand_icon | false
bool | flat | false
Texture2D | icon |
HorizontalAlignment | icon_alignment | 0
String | language | ""
String | text | ""
TextDirection | text_direction | 0
OverrunBehavior | text_overrun_behavior | 0
VerticalAlignment | vertical_icon_alignment | 1

## Theme Properties

Color | font_color | Color(0.875, 0.875, 0.875, 1)
Color | font_disabled_color | Color(0.875, 0.875, 0.875, 0.5)
Color | font_focus_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_pressed_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_pressed_color | Color(1, 1, 1, 1)
Color | icon_disabled_color | Color(1, 1, 1, 0.4)
Color | icon_focus_color | Color(1, 1, 1, 1)
Color | icon_hover_color | Color(1, 1, 1, 1)
Color | icon_hover_pressed_color | Color(1, 1, 1, 1)
Color | icon_normal_color | Color(1, 1, 1, 1)
Color | icon_pressed_color | Color(1, 1, 1, 1)
int | align_to_largest_stylebox | 0
int | h_separation | 4
int | icon_max_width | 0
int | line_spacing | 0
int | outline_size | 0
Font | font |
int | font_size |
Texture2D | icon |
StyleBox | disabled |
StyleBox | disabled_mirrored |
StyleBox | focus |
StyleBox | hover |
StyleBox | hover_mirrored |
StyleBox | hover_pressed |
StyleBox | hover_pressed_mirrored |
StyleBox | normal |
StyleBox | normal_mirrored |
StyleBox | pressed |
StyleBox | pressed_mirrored |

---

## Property Descriptions

HorizontalAlignment alignment = 1 

- void set_text_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_text_alignment()

Text alignment policy for the button's text.

---

AutowrapMode autowrap_mode = 0 

- void set_autowrap_mode(value: AutowrapMode)
- AutowrapMode get_autowrap_mode()

If set to something other than TextServer.AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle.

---

BitField[LineBreakFlag] autowrap_trim_flags = 128 

- void set_autowrap_trim_flags(value: BitField[LineBreakFlag])
- BitField[LineBreakFlag] get_autowrap_trim_flags()

Autowrap space trimming flags. See TextServer.BREAK_TRIM_START_EDGE_SPACES and TextServer.BREAK_TRIM_END_EDGE_SPACES for more info.

---

bool clip_text = false 

- void set_clip_text(value: bool)
- bool get_clip_text()

If true, text that is too large to fit the button is clipped horizontally. If false, the button will always be wide enough to hold the text. The text is not vertically clipped, and the button's height is not affected by this property.

---

bool expand_icon = false 

- void set_expand_icon(value: bool)
- bool is_expand_icon()

When enabled, the button's icon will expand/shrink to fit the button's size while keeping its aspect. See also icon_max_width.

---

bool flat = false 

- void set_flat(value: bool)
- bool is_flat()

Flat buttons don't display decoration.

---

Texture2D icon 

- void set_button_icon(value: Texture2D)
- Texture2D get_button_icon()

Button's icon, if text is present the icon will be placed before the text.

To edit margin and spacing of the icon, use h_separation theme property and content_margin_* properties of the used StyleBoxes.

---

HorizontalAlignment icon_alignment = 0 

- void set_icon_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_icon_alignment()

Specifies if the icon should be aligned horizontally to the left, right, or center of a button. Uses the same HorizontalAlignment constants as the text alignment. If centered horizontally and vertically, text will draw on top of the icon.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

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

VerticalAlignment vertical_icon_alignment = 1 

- void set_vertical_icon_alignment(value: VerticalAlignment)
- VerticalAlignment get_vertical_icon_alignment()

Specifies if the icon should be aligned vertically to the top, bottom, or center of a button. Uses the same VerticalAlignment constants as the text alignment. If centered horizontally and vertically, text will draw on top of the icon.

---

## Theme Property Descriptions

Color font_color = Color(0.875, 0.875, 0.875, 1) 

Default text Color of the Button.

---

Color font_disabled_color = Color(0.875, 0.875, 0.875, 0.5) 

Text Color used when the Button is disabled.

---

Color font_focus_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the Button is focused. Only replaces the normal text color of the button. Disabled, hovered, and pressed states take precedence over this color.

---

Color font_hover_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the Button is being hovered.

---

Color font_hover_pressed_color = Color(1, 1, 1, 1) 

Text Color used when the Button is being hovered and pressed.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the Button.

---

Color font_pressed_color = Color(1, 1, 1, 1) 

Text Color used when the Button is being pressed.

---

Color icon_disabled_color = Color(1, 1, 1, 0.4) 

Icon modulate Color used when the Button is disabled.

---

Color icon_focus_color = Color(1, 1, 1, 1) 

Icon modulate Color used when the Button is focused. Only replaces the normal modulate color of the button. Disabled, hovered, and pressed states take precedence over this color.

---

Color icon_hover_color = Color(1, 1, 1, 1) 

Icon modulate Color used when the Button is being hovered.

---

Color icon_hover_pressed_color = Color(1, 1, 1, 1) 

Icon modulate Color used when the Button is being hovered and pressed.

---

Color icon_normal_color = Color(1, 1, 1, 1) 

Default icon modulate Color of the Button.

---

Color icon_pressed_color = Color(1, 1, 1, 1) 

Icon modulate Color used when the Button is being pressed.

---

int align_to_largest_stylebox = 0 

This constant acts as a boolean. If true, the minimum size of the button and text/icon alignment is always based on the largest stylebox margins, otherwise it's based on the current button state stylebox margins.

---

int h_separation = 4 

The horizontal space between Button's icon and text. Negative values will be treated as 0 when used.

---

int icon_max_width = 0 

The maximum allowed width of the Button's icon. This limit is applied on top of the default size of the icon, or its expanded size if expand_icon is true. The height is adjusted according to the icon's ratio. If the button has additional icons (e.g. CheckBox), they will also be limited.

---

int line_spacing = 0 

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

Font font 

Font of the Button's text.

---

int font_size 

Font size of the Button's text.

---

Texture2D icon 

Default icon for the Button. Appears only if icon is not assigned.

---

StyleBox disabled 

StyleBox used when the Button is disabled.

---

StyleBox disabled_mirrored 

StyleBox used when the Button is disabled (for right-to-left layouts).

---

StyleBox focus 

StyleBox used when the Button is focused. The focus StyleBox is displayed over the base StyleBox, so a partially transparent StyleBox should be used to ensure the base StyleBox remains visible. A StyleBox that represents an outline or an underline works well for this purpose. To disable the focus visual effect, assign a StyleBoxEmpty resource. Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.

---

StyleBox hover 

StyleBox used when the Button is being hovered.

---

StyleBox hover_mirrored 

StyleBox used when the Button is being hovered (for right-to-left layouts).

---

StyleBox hover_pressed 

StyleBox used when the Button is being pressed and hovered at the same time.

---

StyleBox hover_pressed_mirrored 

StyleBox used when the Button is being pressed and hovered at the same time (for right-to-left layouts).

---

StyleBox normal 

Default StyleBox for the Button.

---

StyleBox normal_mirrored 

Default StyleBox for the Button (for right-to-left layouts).

---

StyleBox pressed 

StyleBox used when the Button is being pressed.

---

StyleBox pressed_mirrored 

StyleBox used when the Button is being pressed (for right-to-left layouts).
