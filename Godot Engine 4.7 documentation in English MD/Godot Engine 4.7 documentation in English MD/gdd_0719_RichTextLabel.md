# RichTextLabel

Inherits: Control < CanvasItem < Node < Object

A control for displaying text that can contain different font styles, images, and basic formatting.

## Description

A control for displaying text that can contain custom fonts, images, and basic formatting. RichTextLabel manages these as an internal tag stack. It also adapts itself to given width/heights.

Note: newline(), push_paragraph(), "\n", "\r\n", p tag, and alignment tags start a new paragraph. Each paragraph is processed independently, in its own BiDi context. If you want to force line wrapping within paragraph, any other line breaking character can be used, for example, Form Feed (U+000C), Next Line (U+0085), Line Separator (U+2028).

Note: Assignments to text clear the tag stack and reconstruct it from the property's contents. Any edits made to text will erase previous edits made from other manual sources such as append_text() and the push_* / pop() methods.

Note: RichTextLabel doesn't support entangled BBCode tags. For example, instead of using [b]bold[i]bold italic[/b]italic[/i], use [b]bold[i]bold italic[/i][/b][i]italic[/i].

Note: push_*/pop_* functions won't affect BBCode.

Note: While bbcode_enabled is enabled, alignment tags such as [center] will take priority over the horizontal_alignment setting which determines the default text alignment.

## Tutorials

- BBCode in RichTextLabel
- Rich Text Label with BBCode Demo [https://godotengine.org/asset-library/asset/2774]
- Operating System Testing Demo [https://godotengine.org/asset-library/asset/2789]

## Properties

AutowrapMode | autowrap_mode | 3
BitField[LineBreakFlag] | autowrap_trim_flags | 192
bool | bbcode_enabled | false
bool | clip_contents | true (overrides Control)
bool | context_menu_enabled | false
Array | custom_effects | []
bool | deselect_on_focus_loss_enabled | true
bool | drag_and_drop_selection_enabled | true
bool | fit_content | false
FocusMode | focus_mode | 3 (overrides Control)
bool | hint_underlined | true
HorizontalAlignment | horizontal_alignment | 0
BitField[JustificationFlag] | justification_flags | 163
String | language | ""
bool | meta_underlined | true
int | progress_bar_delay | 1000
bool | scroll_active | true
bool | scroll_following | false
bool | scroll_following_visible_characters | false
bool | selection_enabled | false
bool | shortcut_keys_enabled | true
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
int | tab_size | 4
PackedFloat32Array | tab_stops | PackedFloat32Array()
String | text | ""
TextDirection | text_direction | 0
bool | threaded | false
VerticalAlignment | vertical_alignment | 0
int | visible_characters | -1
VisibleCharactersBehavior | visible_characters_behavior | 0
float | visible_ratio | 1.0

## Methods

void | add_hr(width: int = 90, height: int = 2, color: Color = Color(1, 1, 1, 1), alignment: HorizontalAlignment = 1, width_in_percent: bool = true, height_in_percent: bool = false)
void | add_image(image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: InlineAlignment = 5, region: Rect2 = Rect2(0, 0, 0, 0), key: Variant = null, pad: bool = false, tooltip: String = "", width_unit: ImageUnit = 0, height_unit: ImageUnit = 0, alt_text: String = "")
void | add_text(text: String)
void | append_text(bbcode: String)
void | clear()
void | deselect()
int | get_character_line(character: int)
int | get_character_paragraph(character: int)
int | get_content_height() const
int | get_content_width() const
int | get_line_count() const
int | get_line_height(line: int) const
float | get_line_offset(line: int)
Vector2i | get_line_range(line: int)
int | get_line_width(line: int) const
PopupMenu | get_menu() const
int | get_paragraph_count() const
float | get_paragraph_offset(paragraph: int)
String | get_parsed_text() const
String | get_selected_text() const
int | get_selection_from() const
float | get_selection_line_offset() const
int | get_selection_to() const
int | get_total_character_count() const
VScrollBar | get_v_scroll_bar()
Rect2i | get_visible_content_rect() const
int | get_visible_line_count() const
int | get_visible_paragraph_count() const
void | install_effect(effect: Variant)
bool | invalidate_paragraph(paragraph: int)
bool | is_finished() const
bool | is_menu_visible() const
bool | is_ready() const
void | menu_option(option: int)
void | newline()
void | parse_bbcode(bbcode: String)
Dictionary | parse_expressions_for_values(expressions: PackedStringArray)
void | pop()
void | pop_all()
void | pop_context()
void | push_bgcolor(bgcolor: Color)
void | push_bold()
void | push_bold_italics()
void | push_cell()
void | push_color(color: Color)
void | push_context()
void | push_customfx(effect: RichTextEffect, env: Dictionary)
void | push_dropcap(string: String, font: Font, size: int, dropcap_margins: Rect2 = Rect2(0, 0, 0, 0), color: Color = Color(1, 1, 1, 1), outline_size: int = 0, outline_color: Color = Color(0, 0, 0, 0))
void | push_fgcolor(fgcolor: Color)
void | push_font(font: Font, font_size: int = 0)
void | push_font_size(font_size: int)
void | push_hint(description: String)
void | push_indent(level: int)
void | push_italics()
void | push_language(language: String)
void | push_list(level: int, type: ListType, capitalize: bool, bullet: String = "•")
void | push_meta(data: Variant, underline_mode: MetaUnderline = 1, tooltip: String = "")
void | push_mono()
void | push_normal()
void | push_outline_color(color: Color)
void | push_outline_size(outline_size: int)
void | push_paragraph(alignment: HorizontalAlignment, base_direction: TextDirection = 0, language: String = "", st_parser: StructuredTextParser = 0, justification_flags: BitField[JustificationFlag] = 163, tab_stops: PackedFloat32Array = PackedFloat32Array())
void | push_strikethrough(color: Color = Color(0, 0, 0, 0))
void | push_table(columns: int, inline_align: InlineAlignment = 0, align_to_row: int = -1, name: String = "")
void | push_underline(color: Color = Color(0, 0, 0, 0))
void | reload_effects()
bool | remove_paragraph(paragraph: int, no_invalidate: bool = false)
void | scroll_to_line(line: int)
void | scroll_to_paragraph(paragraph: int)
void | scroll_to_selection()
void | select_all()
void | set_cell_border_color(color: Color)
void | set_cell_padding(padding: Rect2)
void | set_cell_row_background_color(odd_row_bg: Color, even_row_bg: Color)
void | set_cell_size_override(min_size: Vector2, max_size: Vector2)
void | set_table_column_expand(column: int, expand: bool, ratio: int = 1, shrink: bool = true)
void | set_table_column_name(column: int, name: String)
void | update_image(key: Variant, mask: BitField[ImageUpdateMask], image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: InlineAlignment = 5, region: Rect2 = Rect2(0, 0, 0, 0), pad: bool = false, tooltip: String = "", width_unit: ImageUnit = 0, height_unit: ImageUnit = 0)

## Theme Properties

Color | default_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_selected_color | Color(0, 0, 0, 0)
Color | font_shadow_color | Color(0, 0, 0, 0)
Color | selection_color | Color(0.1, 0.1, 1, 0.8)
Color | table_border | Color(0, 0, 0, 0)
Color | table_even_row_bg | Color(0, 0, 0, 0)
Color | table_odd_row_bg | Color(0, 0, 0, 0)
int | line_separation | 0
int | outline_size | 0
int | paragraph_separation | 0
int | shadow_offset_x | 1
int | shadow_offset_y | 1
int | shadow_outline_size | 1
int | strikethrough_alpha | 50
int | table_h_separation | 3
int | table_v_separation | 3
int | text_highlight_h_padding | 3
int | text_highlight_v_padding | 3
int | underline_alpha | 50
Font | bold_font |
Font | bold_italics_font |
Font | italics_font |
Font | mono_font |
Font | normal_font |
int | bold_font_size |
int | bold_italics_font_size |
int | italics_font_size |
int | mono_font_size |
int | normal_font_size |
Texture2D | horizontal_rule |
StyleBox | focus |
StyleBox | normal |

---

## Signals

finished() 

Triggered when the document is fully loaded.

Note: This can happen before the text is processed for drawing. Scrolling values may not be valid until the document is drawn for the first time after this signal.

---

meta_clicked(meta: Variant) 

Triggered when the user clicks on content between meta (URL) tags. If the meta is defined in BBCode, e.g. Text, then the parameter for this signal will always be a String type. If a particular type or an object is desired, the push_meta() method must be used to manually insert the data into the tag stack. Alternatively, you can convert the String input to the desired type based on its contents (such as calling JSON.parse() on it).

For example, the following method can be connected to meta_clicked to open clicked URLs using the user's default web browser:

```
# This assumes RichTextLabel's `meta_clicked` signal was connected to
# the function below using the signal connection dialog.
func _richtextlabel_on_meta_clicked(meta):
    # `meta` is of Variant type, so convert it to a String to avoid script errors at run-time.
    OS.shell_open(str(meta))
```

---

meta_hover_ended(meta: Variant) 

Triggers when the mouse exits a meta tag.

---

meta_hover_started(meta: Variant) 

Triggers when the mouse enters a meta tag.

---

## Enumerations

enum ListType
ListType LIST_NUMBERS = 0

Each list item has a number marker.

ListType LIST_LETTERS = 1

Each list item has a letter marker.

ListType LIST_ROMAN = 2

Each list item has a roman number marker.

ListType LIST_DOTS = 3

Each list item has a filled circle marker.

---

enum MenuItems
MenuItems MENU_COPY = 0

Copies the selected text.

MenuItems MENU_SELECT_ALL = 1

Selects the whole RichTextLabel text.

MenuItems MENU_MAX = 2

Represents the size of the MenuItems enum.

---

enum MetaUnderline
MetaUnderline META_UNDERLINE_NEVER = 0

Meta tag does not display an underline, even if meta_underlined is true.

MetaUnderline META_UNDERLINE_ALWAYS = 1

If meta_underlined is true, meta tag always display an underline.

MetaUnderline META_UNDERLINE_ON_HOVER = 2

If meta_underlined is true, meta tag display an underline when the mouse cursor is over it.

---

flags ImageUpdateMask: 

ImageUpdateMask UPDATE_TEXTURE = 1

If this bit is set, update_image() changes image texture.

ImageUpdateMask UPDATE_SIZE = 2

If this bit is set, update_image() changes image size.

ImageUpdateMask UPDATE_COLOR = 4

If this bit is set, update_image() changes image color.

ImageUpdateMask UPDATE_ALIGNMENT = 8

If this bit is set, update_image() changes image inline alignment.

ImageUpdateMask UPDATE_REGION = 16

If this bit is set, update_image() changes image texture region.

ImageUpdateMask UPDATE_PAD = 32

If this bit is set, update_image() changes image padding.

ImageUpdateMask UPDATE_TOOLTIP = 64

If this bit is set, update_image() changes image tooltip.

ImageUpdateMask UPDATE_WIDTH_UNIT = 128

If this bit is set, update_image() changes the units used to calculate image size.

---

enum ImageUnit
ImageUnit IMAGE_UNIT_PIXEL = 0

Images drawn with this unit will be in pixels.

ImageUnit IMAGE_UNIT_PERCENT = 1

Images drawn with this unit will be in percentages of the control width.

ImageUnit IMAGE_UNIT_EM = 2

Images drawn with this unit will be in percentages of the surrounding font size.

---

## Property Descriptions

AutowrapMode autowrap_mode = 3 

- void set_autowrap_mode(value: AutowrapMode)
- AutowrapMode get_autowrap_mode()

If set to something other than TextServer.AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle.

Note: RichTextLabels with autowrapping and fit_content enabled must have a custom maximum width configured to work correctly, either through the RichTextLabel's own Control.custom_maximum_size or as a result of a propagated maximum size from a parent Control with Control.propagate_maximum_size enabled.

---

BitField[LineBreakFlag] autowrap_trim_flags = 192 

- void set_autowrap_trim_flags(value: BitField[LineBreakFlag])
- BitField[LineBreakFlag] get_autowrap_trim_flags()

Autowrap space trimming flags. See TextServer.BREAK_TRIM_START_EDGE_SPACES and TextServer.BREAK_TRIM_END_EDGE_SPACES for more info.

---

bool bbcode_enabled = false 

- void set_use_bbcode(value: bool)
- bool is_using_bbcode()

If true, the label uses BBCode formatting.

Note: This only affects the contents of text, not the tag stack.

---

bool context_menu_enabled = false 

- void set_context_menu_enabled(value: bool)
- bool is_context_menu_enabled()

If true, a right-click displays the context menu.

---

Array custom_effects = [] 

- void set_effects(value: Array)
- Array get_effects()

The currently installed custom effects. This is an array of RichTextEffects.

To add a custom effect, it's more convenient to use install_effect().

---

bool deselect_on_focus_loss_enabled = true 

- void set_deselect_on_focus_loss_enabled(value: bool)
- bool is_deselect_on_focus_loss_enabled()

If true, the selected text will be deselected when focus is lost.

---

bool drag_and_drop_selection_enabled = true 

- void set_drag_and_drop_selection_enabled(value: bool)
- bool is_drag_and_drop_selection_enabled()

If true, allow drag and drop of selected text.

---

bool fit_content = false 

- void set_fit_content(value: bool)
- bool is_fit_content_enabled()

If true, the label's minimum size will be automatically updated to fit its content, matching the behavior of Label.

Note: RichTextLabels with autowrapping and fit_content enabled must have a custom maximum width configured to work correctly, either through the RichTextLabel's own Control.custom_maximum_size or as a result of a propagated maximum size from a parent Control with Control.propagate_maximum_size enabled.

---

bool hint_underlined = true 

- void set_hint_underline(value: bool)
- bool is_hint_underlined()

If true, the label underlines hint tags such as [hint=description]{text}[/hint].

---

HorizontalAlignment horizontal_alignment = 0 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

Controls the text's horizontal alignment. Supports left, center, right, and fill (also known as justify).

---

BitField[JustificationFlag] justification_flags = 163 

- void set_justification_flags(value: BitField[JustificationFlag])
- BitField[JustificationFlag] get_justification_flags()

Line fill alignment rules.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

bool meta_underlined = true 

- void set_meta_underline(value: bool)
- bool is_meta_underlined()

If true, the label underlines meta tags such as {text}. These tags can call a function when clicked if meta_clicked is connected to a function.

---

int progress_bar_delay = 1000 

- void set_progress_bar_delay(value: int)
- int get_progress_bar_delay()

The delay after which the loading progress bar is displayed, in milliseconds. Set to -1 to disable progress bar entirely.

Note: Progress bar is displayed only if threaded is enabled.

---

bool scroll_active = true 

- void set_scroll_active(value: bool)
- bool is_scroll_active()

If true, the scrollbar is visible. Setting this to false does not block scrolling completely. See scroll_to_line().

---

bool scroll_following = false 

- void set_scroll_follow(value: bool)
- bool is_scroll_following()

If true, the window scrolls down to display new content automatically.

---

bool scroll_following_visible_characters = false 

- void set_scroll_follow_visible_characters(value: bool)
- bool is_scroll_following_visible_characters()

If true, the window scrolls to display the last visible line when visible_characters or visible_ratio is changed.

---

bool selection_enabled = false 

- void set_selection_enabled(value: bool)
- bool is_selection_enabled()

If true, the label allows text selection.

---

bool shortcut_keys_enabled = true 

- void set_shortcut_keys_enabled(value: bool)
- bool is_shortcut_keys_enabled()

If true, shortcut keys for context menu items are enabled, even if the context menu is disabled.

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

int tab_size = 4 

- void set_tab_size(value: int)
- int get_tab_size()

The number of spaces associated with a single tab length. Does not affect \t in text tags, only indent tags.

---

PackedFloat32Array tab_stops = PackedFloat32Array() 

- void set_tab_stops(value: PackedFloat32Array)
- PackedFloat32Array get_tab_stops()

Aligns text to the given tab-stops.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

String text = "" 

- void set_text(value: String)
- String get_text()

The label's text in BBCode format. Is not representative of manual modifications to the internal tag stack. Erases changes made by other methods when edited.

Note: If bbcode_enabled is true, it is unadvised to use the += operator with text (e.g. text += "some string") as it replaces the whole text and can cause slowdowns. It will also erase all BBCode that was added to stack using push_* methods. Use append_text() for adding text instead, unless you absolutely need to close a tag that was opened in an earlier method call.

---

TextDirection text_direction = 0 

- void set_text_direction(value: TextDirection)
- TextDirection get_text_direction()

Base text writing direction.

---

bool threaded = false 

- void set_threaded(value: bool)
- bool is_threaded()

If true, text processing is done in a background thread.

---

VerticalAlignment vertical_alignment = 0 

- void set_vertical_alignment(value: VerticalAlignment)
- VerticalAlignment get_vertical_alignment()

Controls the text's vertical alignment. Supports top, center, bottom, and fill.

---

int visible_characters = -1 

- void set_visible_characters(value: int)
- int get_visible_characters()

The number of characters to display. If set to -1, all characters are displayed. This can be useful when animating the text appearing in a dialog box.

Note: Setting this property updates visible_ratio accordingly.

Note: Characters are counted as Unicode codepoints. A single visible grapheme may contain multiple codepoints (e.g. certain emoji use three codepoints). A single codepoint may contain two UTF-16 characters, which are used in C# strings.

---

VisibleCharactersBehavior visible_characters_behavior = 0 

- void set_visible_characters_behavior(value: VisibleCharactersBehavior)
- VisibleCharactersBehavior get_visible_characters_behavior()

The clipping behavior when visible_characters or visible_ratio is set.

---

float visible_ratio = 1.0 

- void set_visible_ratio(value: float)
- float get_visible_ratio()

The fraction of characters to display, relative to the total number of characters (see get_total_character_count()). If set to 1.0, all characters are displayed. If set to 0.5, only half of the characters will be displayed. This can be useful when animating the text appearing in a dialog box.

Note: Setting this property updates visible_characters accordingly.

---

## Method Descriptions

void add_hr(width: int = 90, height: int = 2, color: Color = Color(1, 1, 1, 1), alignment: HorizontalAlignment = 1, width_in_percent: bool = true, height_in_percent: bool = false) 

Adds a horizontal rule that can be used to separate content.

If width_in_percent is set, width values are percentages of the control width instead of pixels.

If height_in_percent is set, height values are percentages of the control width instead of pixels.

---

void add_image(image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: InlineAlignment = 5, region: Rect2 = Rect2(0, 0, 0, 0), key: Variant = null, pad: bool = false, tooltip: String = "", width_unit: ImageUnit = 0, height_unit: ImageUnit = 0, alt_text: String = "") 

Adds an image's opening and closing tags to the tag stack, optionally providing a width and height to resize the image, a color to tint the image and a region to only use parts of the image.

If width or height is set to 0, the image size will be adjusted in order to keep the original aspect ratio.

If width and height are not set, but region is, the region's rect will be used.

key is an optional identifier, that can be used to modify the image via update_image().

If pad is set, and the image is smaller than the size specified by width and height, the image padding is added to match the size instead of upscaling.

Parameters width_unit and height_unit determine the units used to calculate the image width and height, respectively.

alt_text is used as the image description for assistive apps.

---

void add_text(text: String) 

Adds raw non-BBCode-parsed text to the tag stack.

---

void append_text(bbcode: String) 

Parses bbcode and adds tags to the tag stack as needed.

Note: Using this method, you can't close a tag that was opened in a previous append_text() call. This is done to improve performance, especially when updating large RichTextLabels since rebuilding the whole BBCode every time would be slower. If you absolutely need to close a tag in a future method call, append the text instead of using append_text().

---

void clear() 

Clears the tag stack, causing the label to display nothing.

Note: This method does not affect text, and its contents will show again if the label is redrawn. However, setting text to an empty String also clears the stack.

---

void deselect() 

Clears the current selection.

---

int get_character_line(character: int) 

Returns the line number of the character position provided. Line and character numbers are both zero-indexed.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_character_paragraph(character: int) 

Returns the paragraph number of the character position provided. Paragraph and character numbers are both zero-indexed.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_content_height() const 

Returns the height of the content.

Note: This method always returns the full content size, and is not affected by visible_ratio and visible_characters. To get the visible content size, use get_visible_content_rect().

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_content_width() const 

Returns the width of the content.

Note: This method always returns the full content size, and is not affected by visible_ratio and visible_characters. To get the visible content size, use get_visible_content_rect().

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_line_count() const 

Returns the total number of lines in the text. Wrapped text is counted as multiple lines.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_line_height(line: int) const 

Returns the height of the line found at the provided index.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether the document is fully loaded.

---

float get_line_offset(line: int) 

Returns the vertical offset of the line found at the provided index.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

Vector2i get_line_range(line: int) 

Returns the indexes of the first and last visible characters for the given line, as a Vector2i.

Note: If visible_characters_behavior is set to TextServer.VC_CHARS_BEFORE_SHAPING only visible wrapped lines are counted.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_line_width(line: int) const 

Returns the width of the line found at the provided index.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether the document is fully loaded.

---

PopupMenu get_menu() const 

Returns the PopupMenu of this RichTextLabel. By default, this menu is displayed when right-clicking on the RichTextLabel.

You can add custom menu items or remove standard ones. Make sure your IDs don't conflict with the standard ones (see MenuItems). For example:

```
func _ready():
    var menu = get_menu()
    # Remove "Select All" item.
    menu.remove_item(MENU_SELECT_ALL)
    # Add custom items.
    menu.add_separator()
    menu.add_item("Duplicate Text", MENU_MAX + 1)
    # Connect callback.
    menu.id_pressed.connect(_on_item_pressed)
func _on_item_pressed(id):
    if id == MENU_MAX + 1:
        add_text("\n" + get_parsed_text())
```

```
public override void _Ready()
{
    var menu = GetMenu();
    // Remove "Select All" item.
    menu.RemoveItem(RichTextLabel.MenuItems.SelectAll);
    // Add custom items.
    menu.AddSeparator();
    menu.AddItem("Duplicate Text", RichTextLabel.MenuItems.Max + 1);
    // Add event handler.
    menu.IdPressed += OnItemPressed;
}
public void OnItemPressed(int id)
{
    if (id == TextEdit.MenuItems.Max + 1)
    {
        AddText("\n" + GetParsedText());
    }
}
```

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their Window.visible property.

---

int get_paragraph_count() const 

Returns the total number of paragraphs (newlines or p tags in the tag stack's text tags). Considers wrapped text as one paragraph.

---

float get_paragraph_offset(paragraph: int) 

Returns the vertical offset of the paragraph found at the provided index.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

String get_parsed_text() const 

Returns the text without BBCode mark-up.

---

String get_selected_text() const 

Returns the current selection text. Does not include BBCodes.

---

int get_selection_from() const 

Returns the current selection first character index if a selection is active, -1 otherwise. Does not include BBCodes.

---

float get_selection_line_offset() const 

Returns the current selection vertical line offset if a selection is active, -1.0 otherwise.

---

int get_selection_to() const 

Returns the current selection last character index if a selection is active, -1 otherwise. Does not include BBCodes.

---

int get_total_character_count() const 

Returns the total number of characters from text tags. Does not include BBCodes.

---

VScrollBar get_v_scroll_bar() 

Returns the vertical scrollbar.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

Rect2i get_visible_content_rect() const 

Returns the bounding rectangle of the visible content.

Note: This method returns a correct value only after the label has been drawn.

```
extends RichTextLabel
@export var background_panel: Panel
func _ready():
    await draw
    background_panel.position = get_visible_content_rect().position
    background_panel.size = get_visible_content_rect().size
```

```
public partial class TestLabel : RichTextLabel
{
    [Export]
    public Panel BackgroundPanel { get; set; }
    public override async void _Ready()
    {
        await ToSignal(this, Control.SignalName.Draw);
        BackgroundGPanel.Position = GetVisibleContentRect().Position;
        BackgroundPanel.Size = GetVisibleContentRect().Size;
    }
}
```

---

int get_visible_line_count() const 

Returns the number of visible lines.

Note: This method returns a correct value only after the label has been drawn.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

int get_visible_paragraph_count() const 

Returns the number of visible paragraphs. A paragraph is considered visible if at least one of its lines is visible.

Note: This method returns a correct value only after the label has been drawn.

Note: If threaded is enabled, this method returns a value for the loaded part of the document. Use is_finished() or finished to determine whether document is fully loaded.

---

void install_effect(effect: Variant) 

Installs a custom effect. This can also be done in the Inspector through the custom_effects property. effect should be a valid RichTextEffect.

Example: With the following script extending from RichTextEffect:

```gdscript
# effect.gd
class_name MyCustomEffect
extends RichTextEffect
var bbcode = "my_custom_effect"
# ...
```

The above effect can be installed in RichTextLabel from a script:

```gdscript
# rich_text_label.gd
extends RichTextLabel
func _ready():
    install_effect(MyCustomEffect.new())
    # Alternatively, if not using `class_name` in the script that extends RichTextEffect:
    install_effect(preload("res://effect.gd").new())
```

---

bool invalidate_paragraph(paragraph: int) 

Invalidates paragraph and all subsequent paragraphs cache.

---

bool is_finished() const 

If threaded is enabled, returns true if the background thread has finished text processing, otherwise always return true.

---

bool is_menu_visible() const 

Returns whether the menu is visible. Use this instead of get_menu().visible to improve performance (so the creation of the menu is avoided).

---

bool is_ready() const 

Deprecated: Use is_finished() instead.

If threaded is enabled, returns true if the background thread has finished text processing, otherwise always return true.

---

void menu_option(option: int) 

Executes a given action as defined in the MenuItems enum.

---

void newline() 

Adds a newline tag to the tag stack.

---

void parse_bbcode(bbcode: String) 

The assignment version of append_text(). Clears the tag stack and inserts the new content.

---

Dictionary parse_expressions_for_values(expressions: PackedStringArray) 

Parses BBCode parameter expressions into a dictionary.

---

void pop() 

Terminates the current tag. Use after push_* methods to close BBCodes manually. Does not need to follow add_* methods.

---

void pop_all() 

Terminates all tags opened by push_* methods.

---

void pop_context() 

Terminates tags opened after the last push_context() call (including context marker), or all tags if there's no context marker on the stack.

---

void push_bgcolor(bgcolor: Color) 

Adds a [bgcolor] tag to the tag stack.

Note: The background color has padding applied by default, which is controlled using text_highlight_h_padding and text_highlight_v_padding. This can lead to overlapping highlights if background colors are placed on neighboring lines/columns, so consider setting those theme items to 0 if you want to avoid this.

---

void push_bold() 

Adds a [font] tag with a bold font to the tag stack. This is the same as adding a [b] tag if not currently in a [i] tag.

---

void push_bold_italics() 

Adds a [font] tag with a bold italics font to the tag stack.

---

void push_cell() 

Adds a [cell] tag to the tag stack. Must be inside a [table] tag. See push_table() for details. Use set_table_column_expand() to set column expansion ratio, set_cell_border_color() to set cell border, set_cell_row_background_color() to set cell background, set_cell_size_override() to override cell size, and set_cell_padding() to set padding.

---

void push_color(color: Color) 

Adds a [color] tag to the tag stack.

---

void push_context() 

Adds a context marker to the tag stack. See pop_context().

---

void push_customfx(effect: RichTextEffect, env: Dictionary) 

Adds a custom effect tag to the tag stack. The effect does not need to be in custom_effects. The environment is directly passed to the effect.

---

void push_dropcap(string: String, font: Font, size: int, dropcap_margins: Rect2 = Rect2(0, 0, 0, 0), color: Color = Color(1, 1, 1, 1), outline_size: int = 0, outline_color: Color = Color(0, 0, 0, 0)) 

Adds a [dropcap] tag to the tag stack. Drop cap (dropped capital) is a decorative element at the beginning of a paragraph that is larger than the rest of the text.

---

void push_fgcolor(fgcolor: Color) 

Adds a [fgcolor] tag to the tag stack.

Note: The foreground color has padding applied by default, which is controlled using text_highlight_h_padding and text_highlight_v_padding. This can lead to overlapping highlights if foreground colors are placed on neighboring lines/columns, so consider setting those theme items to 0 if you want to avoid this.

---

void push_font(font: Font, font_size: int = 0) 

Adds a [font] tag to the tag stack. Overrides default fonts for its duration.

Passing 0 to font_size will use the existing default font size.

---

void push_font_size(font_size: int) 

Adds a [font_size] tag to the tag stack. Overrides default font size for its duration.

---

void push_hint(description: String) 

Adds a [hint] tag to the tag stack. Same as BBCode [hint=something]{text}[/hint].

---

void push_indent(level: int) 

Adds an [indent] tag to the tag stack. Multiplies level by current tab_size to determine new margin length.

---

void push_italics() 

Adds a [font] tag with an italics font to the tag stack. This is the same as adding an [i] tag if not currently in a [b] tag.

---

void push_language(language: String) 

Adds language code used for text shaping algorithm and Open-Type font features.

---

void push_list(level: int, type: ListType, capitalize: bool, bullet: String = "•") 

Adds [ol] or [ul] tag to the tag stack. Multiplies level by current tab_size to determine new margin length.

---

void push_meta(data: Variant, underline_mode: MetaUnderline = 1, tooltip: String = "") 

Adds a meta tag to the tag stack. Similar to the BBCode {text}, but supports non-String metadata types.

If meta_underlined is true, meta tags display an underline. This behavior can be customized with underline_mode.

Note: Meta tags do nothing by default when clicked. To assign behavior when clicked, connect meta_clicked to a function that is called when the meta tag is clicked.

---

void push_mono() 

Adds a [font] tag with a monospace font to the tag stack.

---

void push_normal() 

Adds a [font] tag with a normal font to the tag stack.

---

void push_outline_color(color: Color) 

Adds a [outline_color] tag to the tag stack. Adds text outline for its duration.

---

void push_outline_size(outline_size: int) 

Adds a [outline_size] tag to the tag stack. Overrides default text outline size for its duration.

---

void push_paragraph(alignment: HorizontalAlignment, base_direction: TextDirection = 0, language: String = "", st_parser: StructuredTextParser = 0, justification_flags: BitField[JustificationFlag] = 163, tab_stops: PackedFloat32Array = PackedFloat32Array()) 

Adds a [p] tag to the tag stack.

---

void push_strikethrough(color: Color = Color(0, 0, 0, 0)) 

Adds a [s] tag to the tag stack. If color's alpha value is 0.0, the current font's color with its alpha multiplied by strikethrough_alpha is used.

---

void push_table(columns: int, inline_align: InlineAlignment = 0, align_to_row: int = -1, name: String = "") 

Adds a [table=columns,inline_align] tag to the tag stack. Use set_table_column_expand() to set column expansion ratio. Use push_cell() to add cells. name is used as the table name for assistive apps.

---

void push_underline(color: Color = Color(0, 0, 0, 0)) 

Adds a [u] tag to the tag stack. If color's alpha value is 0.0, the current font's color with its alpha multiplied by underline_alpha is used.

---

void reload_effects() 

Reloads custom effects. Useful when custom_effects is modified manually.

---

bool remove_paragraph(paragraph: int, no_invalidate: bool = false) 

Removes a paragraph of content from the label. Returns true if the paragraph exists.

The paragraph argument is the index of the paragraph to remove, it can take values in the interval [0, get_paragraph_count() - 1].

If no_invalidate is set to true, cache for the subsequent paragraphs is not invalidated. Use it for faster updates if deleted paragraph is fully self-contained (have no unclosed tags), or this call is part of the complex edit operation and invalidate_paragraph() will be called at the end of operation.

---

void scroll_to_line(line: int) 

Scrolls the window's top line to match line.

---

void scroll_to_paragraph(paragraph: int) 

Scrolls the window's top line to match first line of the paragraph.

---

void scroll_to_selection() 

Scrolls to the beginning of the current selection.

---

void select_all() 

Select all the text.

If selection_enabled is false, no selection will occur.

---

void set_cell_border_color(color: Color) 

Sets color of a table cell border.

---

void set_cell_padding(padding: Rect2) 

Sets inner padding of a table cell.

---

void set_cell_row_background_color(odd_row_bg: Color, even_row_bg: Color) 

Sets color of a table cell. Separate colors for alternating rows can be specified.

---

void set_cell_size_override(min_size: Vector2, max_size: Vector2) 

Sets minimum and maximum size overrides for a table cell.

---

void set_table_column_expand(column: int, expand: bool, ratio: int = 1, shrink: bool = true) 

Edits the selected column's expansion options. If expand is true, the column expands in proportion to its expansion ratio versus the other columns' ratios.

For example, 2 columns with ratios 3 and 4 plus 70 pixels in available width would expand 30 and 40 pixels, respectively.

If expand is false, the column will not contribute to the total ratio.

---

void set_table_column_name(column: int, name: String) 

Sets table column name for assistive apps.

---

void update_image(key: Variant, mask: BitField[ImageUpdateMask], image: Texture2D, width: float = 0, height: float = 0, color: Color = Color(1, 1, 1, 1), inline_align: InlineAlignment = 5, region: Rect2 = Rect2(0, 0, 0, 0), pad: bool = false, tooltip: String = "", width_unit: ImageUnit = 0, height_unit: ImageUnit = 0) 

Updates the existing images with the key key. Only properties specified by mask bits are updated. See add_image().

---

## Theme Property Descriptions

Color default_color = Color(1, 1, 1, 1) 

The default text color.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The default tint of text outline.

---

Color font_selected_color = Color(0, 0, 0, 0) 

The color of selected text, used when selection_enabled is true. If equal to Color(0, 0, 0, 0), it will be ignored.

---

Color font_shadow_color = Color(0, 0, 0, 0) 

The color of the font's shadow.

---

Color selection_color = Color(0.1, 0.1, 1, 0.8) 

The color of the selection box.

---

Color table_border = Color(0, 0, 0, 0) 

The default cell border color.

---

Color table_even_row_bg = Color(0, 0, 0, 0) 

The default background color for even rows.

---

Color table_odd_row_bg = Color(0, 0, 0, 0) 

The default background color for odd rows.

---

int line_separation = 0 

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

int paragraph_separation = 0 

Additional vertical spacing between paragraphs (in pixels). Spacing is added after the last line. This value can be negative.

---

int shadow_offset_x = 1 

The horizontal offset of the font's shadow.

---

int shadow_offset_y = 1 

The vertical offset of the font's shadow.

---

int shadow_outline_size = 1 

The size of the shadow outline.

---

int strikethrough_alpha = 50 

The default strikethrough color transparency (percent). For strikethroughs with a custom color, this theme item is only used if the custom color's alpha is 0.0 (fully transparent).

---

int table_h_separation = 3 

The horizontal separation of elements in a table.

---

int table_v_separation = 3 

The vertical separation of elements in a table.

---

int text_highlight_h_padding = 3 

The horizontal padding around boxes drawn by the [fgcolor] and [bgcolor] tags. This does not affect the appearance of text selection. To avoid any risk of neighboring highlights overlapping each other, set this to 0 to disable padding.

---

int text_highlight_v_padding = 3 

The vertical padding around boxes drawn by the [fgcolor] and [bgcolor] tags. This does not affect the appearance of text selection. To avoid any risk of neighboring highlights overlapping each other, set this to 0 to disable padding.

---

int underline_alpha = 50 

The default underline color transparency (percent). For underlines with a custom color, this theme item is only used if the custom color's alpha is 0.0 (fully transparent).

---

Font bold_font 

The font used for bold text.

---

Font bold_italics_font 

The font used for bold italics text.

---

Font italics_font 

The font used for italics text.

---

Font mono_font 

The font used for monospace text.

---

Font normal_font 

The default text font.

---

int bold_font_size 

The font size used for bold text.

---

int bold_italics_font_size 

The font size used for bold italics text.

---

int italics_font_size 

The font size used for italics text.

---

int mono_font_size 

The font size used for monospace text.

---

int normal_font_size 

The default text font size.

---

Texture2D horizontal_rule 

The horizontal rule texture.

---

StyleBox focus 

The background used when the RichTextLabel is focused. The focus StyleBox is displayed over the base StyleBox, so a partially transparent StyleBox should be used to ensure the base StyleBox remains visible. A StyleBox that represents an outline or an underline works well for this purpose. To disable the focus visual effect, assign a StyleBoxEmpty resource. Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.

---

StyleBox normal 

The normal background for the RichTextLabel.
