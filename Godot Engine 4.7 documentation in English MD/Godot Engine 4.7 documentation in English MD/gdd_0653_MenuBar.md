# MenuBar

Inherits: Control < CanvasItem < Node < Object

A horizontal menu bar that creates a menu for each PopupMenu child.

## Description

A horizontal menu bar that creates a menu for each PopupMenu child. New items are created by adding PopupMenus to this node. Item title is determined by Window.title, or node name if Window.title is empty. Item title can be overridden using set_menu_title().

## Properties

bool | flat | false
FocusMode | focus_mode | 3 (overrides Control)
String | language | ""
bool | prefer_global_menu | true
int | start_index | -1
bool | switch_on_hover | true
TextDirection | text_direction | 0

## Methods

int | get_menu_count() const
PopupMenu | get_menu_popup(menu: int) const
String | get_menu_title(menu: int) const
String | get_menu_tooltip(menu: int) const
bool | is_menu_disabled(menu: int) const
bool | is_menu_hidden(menu: int) const
bool | is_native_menu() const
void | set_disable_shortcuts(disabled: bool)
void | set_menu_disabled(menu: int, disabled: bool)
void | set_menu_hidden(menu: int, hidden: bool)
void | set_menu_title(menu: int, title: String)
void | set_menu_tooltip(menu: int, tooltip: String)

## Theme Properties

Color | font_color | Color(0.875, 0.875, 0.875, 1)
Color | font_disabled_color | Color(0.875, 0.875, 0.875, 0.5)
Color | font_focus_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_color | Color(0.95, 0.95, 0.95, 1)
Color | font_hover_pressed_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_pressed_color | Color(1, 1, 1, 1)
int | h_separation | 4
int | outline_size | 0
Font | font |
int | font_size |
StyleBox | disabled |
StyleBox | disabled_mirrored |
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

bool flat = false 

- void set_flat(value: bool)
- bool is_flat()

Flat MenuBar don't display item decoration.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

bool prefer_global_menu = true 

- void set_prefer_global_menu(value: bool)
- bool is_prefer_global_menu()

If true, MenuBar will use system global menu when supported.

Note: If true and global menu is supported, this node is not displayed, has zero size, and all its child nodes except PopupMenus are inaccessible.

Note: This property overrides the value of the PopupMenu.prefer_native_menu property of the child nodes.

---

int start_index = -1 

- void set_start_index(value: int)
- int get_start_index()

Position order in the global menu to insert MenuBar items at. All menu items in the MenuBar are always inserted as a continuous range. Menus with lower start_index are inserted first. Menus with start_index equal to -1 are inserted last.

---

bool switch_on_hover = true 

- void set_switch_on_hover(value: bool)
- bool is_switch_on_hover()

If true, when the cursor hovers above menu item, it will close the current PopupMenu and open the other one.

---

TextDirection text_direction = 0 

- void set_text_direction(value: TextDirection)
- TextDirection get_text_direction()

Base text writing direction.

---

## Method Descriptions

int get_menu_count() const 

Returns number of menu items.

---

PopupMenu get_menu_popup(menu: int) const 

Returns PopupMenu associated with menu item.

---

String get_menu_title(menu: int) const 

Returns menu item title.

---

String get_menu_tooltip(menu: int) const 

Returns menu item tooltip.

---

bool is_menu_disabled(menu: int) const 

Returns true if the menu item is disabled.

---

bool is_menu_hidden(menu: int) const 

Returns true if the menu item is hidden.

---

bool is_native_menu() const 

Returns true if the current system's global menu is supported and used by this MenuBar.

---

void set_disable_shortcuts(disabled: bool) 

If true, shortcuts are disabled and cannot be used to trigger the button.

---

void set_menu_disabled(menu: int, disabled: bool) 

If true, menu item is disabled.

---

void set_menu_hidden(menu: int, hidden: bool) 

If true, menu item is hidden.

---

void set_menu_title(menu: int, title: String) 

Sets menu item title.

---

void set_menu_tooltip(menu: int, tooltip: String) 

Sets menu item tooltip.

---

## Theme Property Descriptions

Color font_color = Color(0.875, 0.875, 0.875, 1) 

Default text Color of the menu item.

---

Color font_disabled_color = Color(0.875, 0.875, 0.875, 0.5) 

Text Color used when the menu item is disabled.

---

Color font_focus_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the menu item is focused. Only replaces the normal text color of the menu item. Disabled, hovered, and pressed states take precedence over this color.

---

Color font_hover_color = Color(0.95, 0.95, 0.95, 1) 

Text Color used when the menu item is being hovered.

---

Color font_hover_pressed_color = Color(1, 1, 1, 1) 

Text Color used when the menu item is being hovered and pressed.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The tint of text outline of the menu item.

---

Color font_pressed_color = Color(1, 1, 1, 1) 

Text Color used when the menu item is being pressed.

---

int h_separation = 4 

The horizontal space between menu items.

---

int outline_size = 0 

The size of the text outline.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

---

Font font 

Font of the menu item's text.

---

int font_size 

Font size of the menu item's text.

---

StyleBox disabled 

StyleBox used when the menu item is disabled.

---

StyleBox disabled_mirrored 

StyleBox used when the menu item is disabled (for right-to-left layouts).

---

StyleBox hover 

StyleBox used when the menu item is being hovered.

---

StyleBox hover_mirrored 

StyleBox used when the menu item is being hovered (for right-to-left layouts).

---

StyleBox hover_pressed 

StyleBox used when the menu item is being pressed and hovered at the same time.

---

StyleBox hover_pressed_mirrored 

StyleBox used when the menu item is being pressed and hovered at the same time (for right-to-left layouts).

---

StyleBox normal 

Default StyleBox for the menu item.

---

StyleBox normal_mirrored 

Default StyleBox for the menu item (for right-to-left layouts).

---

StyleBox pressed 

StyleBox used when the menu item is being pressed.

---

StyleBox pressed_mirrored 

StyleBox used when the menu item is being pressed (for right-to-left layouts).
