# CodeHighlighter

Inherits: SyntaxHighlighter < Resource < RefCounted < Object

A syntax highlighter intended for code.

## Description

By adjusting various properties of this resource, you can change the colors of strings, comments, numbers, and other text patterns inside a TextEdit control.

## Properties

Dictionary | color_regions | {}
Color | function_color | Color(0, 0, 0, 1)
Dictionary | keyword_colors | {}
Dictionary | member_keyword_colors | {}
Color | member_variable_color | Color(0, 0, 0, 1)
Color | number_color | Color(0, 0, 0, 1)
Color | symbol_color | Color(0, 0, 0, 1)

## Methods

void | add_color_region(start_key: String, end_key: String, color: Color, line_only: bool = false)
void | add_keyword_color(keyword: String, color: Color)
void | add_member_keyword_color(member_keyword: String, color: Color)
void | clear_color_regions()
void | clear_keyword_colors()
void | clear_member_keyword_colors()
Color | get_keyword_color(keyword: String) const
Color | get_member_keyword_color(member_keyword: String) const
bool | has_color_region(start_key: String) const
bool | has_keyword_color(keyword: String) const
bool | has_member_keyword_color(member_keyword: String) const
void | remove_color_region(start_key: String)
void | remove_keyword_color(keyword: String)
void | remove_member_keyword_color(member_keyword: String)

---

## Property Descriptions

Dictionary color_regions = {} 

- void set_color_regions(value: Dictionary)
- Dictionary get_color_regions()

Sets the color regions. All existing regions will be removed. The Dictionary key is the region start and end key, separated by a space. The value is the region color.

---

Color function_color = Color(0, 0, 0, 1) 

- void set_function_color(value: Color)
- Color get_function_color()

Sets color for functions. A function is a non-keyword string followed by a '('.

---

Dictionary keyword_colors = {} 

- void set_keyword_colors(value: Dictionary)
- Dictionary get_keyword_colors()

Sets the keyword colors. All existing keywords will be removed. The Dictionary key is the keyword. The value is the keyword color.

---

Dictionary member_keyword_colors = {} 

- void set_member_keyword_colors(value: Dictionary)
- Dictionary get_member_keyword_colors()

Sets the member keyword colors. All existing member keyword will be removed. The Dictionary key is the member keyword. The value is the member keyword color.

---

Color member_variable_color = Color(0, 0, 0, 1) 

- void set_member_variable_color(value: Color)
- Color get_member_variable_color()

Sets color for member variables. A member variable is non-keyword, non-function string proceeded with a '.'.

---

Color number_color = Color(0, 0, 0, 1) 

- void set_number_color(value: Color)
- Color get_number_color()

Sets the color for numbers.

---

Color symbol_color = Color(0, 0, 0, 1) 

- void set_symbol_color(value: Color)
- Color get_symbol_color()

Sets the color for symbols.

---

## Method Descriptions

void add_color_region(start_key: String, end_key: String, color: Color, line_only: bool = false) 

Adds a color region (such as for comments or strings) from start_key to end_key. Both keys should be symbols, and start_key must not be shared with other delimiters.

If line_only is true or end_key is an empty String, the region does not carry over to the next line.

---

void add_keyword_color(keyword: String, color: Color) 

Sets the color for a keyword.

The keyword cannot contain any symbols except '_'.

---

void add_member_keyword_color(member_keyword: String, color: Color) 

Sets the color for a member keyword.

The member keyword cannot contain any symbols except '_'.

It will not be highlighted if preceded by a '.'.

---

void clear_color_regions() 

Removes all color regions.

---

void clear_keyword_colors() 

Removes all keywords.

---

void clear_member_keyword_colors() 

Removes all member keywords.

---

Color get_keyword_color(keyword: String) const 

Returns the color for a keyword.

---

Color get_member_keyword_color(member_keyword: String) const 

Returns the color for a member keyword.

---

bool has_color_region(start_key: String) const 

Returns true if the start key exists, else false.

---

bool has_keyword_color(keyword: String) const 

Returns true if the keyword exists, else false.

---

bool has_member_keyword_color(member_keyword: String) const 

Returns true if the member keyword exists, else false.

---

void remove_color_region(start_key: String) 

Removes the color region that uses that start key.

---

void remove_keyword_color(keyword: String) 

Removes the keyword.

---

void remove_member_keyword_color(member_keyword: String) 

Removes the member keyword.
