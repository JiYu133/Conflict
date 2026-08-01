# CodeEdit

Inherits: TextEdit < Control < CanvasItem < Node < Object

A multiline text editor designed for editing code.

## Description

CodeEdit is a specialized TextEdit designed for editing plain text code files. It has many features commonly found in code editors such as line numbers, line folding, code completion, indent management, and string/comment management.

Note: Regardless of locale, CodeEdit will by default always use left-to-right text direction to correctly display source code.

## Properties

bool | auto_brace_completion_enabled | false
bool | auto_brace_completion_highlight_matching | false
Dictionary | auto_brace_completion_pairs | { "\"": "\"", "'": "'", "(": ")", "[": "]", "{": "}" }
bool | code_completion_enabled | false
Array[String] | code_completion_prefixes | []
Array[String] | delimiter_comments | []
Array[String] | delimiter_strings | ["' '", "\" \""]
bool | gutters_draw_bookmarks | false
bool | gutters_draw_breakpoints_gutter | false
bool | gutters_draw_executing_lines | false
bool | gutters_draw_fold_gutter | false
bool | gutters_draw_line_numbers | false
int | gutters_line_numbers_min_digits | 3
bool | gutters_zero_pad_line_numbers | false
bool | indent_automatic | false
Array[String] | indent_automatic_prefixes | [":", "{", "[", "("]
int | indent_size | 4
bool | indent_use_spaces | false
LayoutDirection | layout_direction | 2 (overrides Control)
bool | line_folding | false
Array[int] | line_length_guidelines | []
bool | symbol_lookup_on_click | false
bool | symbol_tooltip_on_hover | false
TextDirection | text_direction | 1 (overrides TextEdit)

## Methods

void | _confirm_code_completion(replace: bool) virtual
Array[Dictionary] | _filter_code_completion_candidates(candidates: Array[Dictionary]) virtual const
void | _request_code_completion(force: bool) virtual
void | add_auto_brace_completion_pair(start_key: String, end_key: String)
void | add_code_completion_option(type: CodeCompletionKind, display_text: String, insert_text: String, text_color: Color = Color(1, 1, 1, 1), icon: Resource = null, value: Variant = null, location: int = 1024)
void | add_comment_delimiter(start_key: String, end_key: String, line_only: bool = false)
void | add_string_delimiter(start_key: String, end_key: String, line_only: bool = false)
bool | can_fold_line(line: int) const
void | cancel_code_completion()
void | clear_bookmarked_lines()
void | clear_breakpointed_lines()
void | clear_comment_delimiters()
void | clear_executing_lines()
void | clear_string_delimiters()
void | confirm_code_completion(replace: bool = false)
void | convert_indent(from_line: int = -1, to_line: int = -1)
void | create_code_region()
void | delete_lines()
void | do_indent()
void | duplicate_lines()
void | duplicate_selection()
void | fold_all_lines()
void | fold_line(line: int)
String | get_auto_brace_completion_close_key(open_key: String) const
PackedInt32Array | get_bookmarked_lines() const
PackedInt32Array | get_breakpointed_lines() const
Dictionary | get_code_completion_option(index: int) const
Array[Dictionary] | get_code_completion_options() const
int | get_code_completion_selected_index() const
String | get_code_region_end_tag() const
String | get_code_region_start_tag() const
String | get_delimiter_end_key(delimiter_index: int) const
Vector2 | get_delimiter_end_position(line: int, column: int) const
String | get_delimiter_start_key(delimiter_index: int) const
Vector2 | get_delimiter_start_position(line: int, column: int) const
PackedInt32Array | get_executing_lines() const
Array[int] | get_folded_lines() const
String | get_text_for_code_completion() const
String | get_text_for_symbol_lookup() const
String | get_text_with_cursor_char(line: int, column: int) const
bool | has_auto_brace_completion_close_key(close_key: String) const
bool | has_auto_brace_completion_open_key(open_key: String) const
bool | has_comment_delimiter(start_key: String) const
bool | has_string_delimiter(start_key: String) const
void | indent_lines()
int | is_in_comment(line: int, column: int = -1) const
int | is_in_string(line: int, column: int = -1) const
bool | is_line_bookmarked(line: int) const
bool | is_line_breakpointed(line: int) const
bool | is_line_code_region_end(line: int) const
bool | is_line_code_region_start(line: int) const
bool | is_line_executing(line: int) const
bool | is_line_folded(line: int) const
void | join_lines(line_ending: String = " ")
void | move_lines_down()
void | move_lines_up()
void | remove_comment_delimiter(start_key: String)
void | remove_string_delimiter(start_key: String)
void | request_code_completion(force: bool = false)
void | set_code_completion_selected_index(index: int)
void | set_code_hint(code_hint: String)
void | set_code_hint_draw_below(draw_below: bool)
void | set_code_region_tags(start: String = "region", end: String = "endregion")
void | set_line_as_bookmarked(line: int, bookmarked: bool)
void | set_line_as_breakpoint(line: int, breakpointed: bool)
void | set_line_as_executing(line: int, executing: bool)
void | set_symbol_lookup_word_as_valid(valid: bool)
void | toggle_foldable_line(line: int)
void | toggle_foldable_lines_at_carets()
void | unfold_all_lines()
void | unfold_line(line: int)
void | unindent_lines()
void | update_code_completion_options(force: bool)

## Theme Properties

Color | bookmark_color | Color(0.5, 0.64, 1, 0.8)
Color | brace_mismatch_color | Color(1, 0.2, 0.2, 1)
Color | breakpoint_color | Color(0.9, 0.29, 0.3, 1)
Color | code_folding_color | Color(0.8, 0.8, 0.8, 0.8)
Color | completion_background_color | Color(0.17, 0.16, 0.2, 1)
Color | completion_existing_color | Color(0.87, 0.87, 0.87, 0.13)
Color | completion_scroll_color | Color(1, 1, 1, 0.29)
Color | completion_scroll_hovered_color | Color(1, 1, 1, 0.4)
Color | completion_selected_color | Color(0.26, 0.26, 0.27, 1)
Color | executing_line_color | Color(0.98, 0.89, 0.27, 1)
Color | folded_code_region_color | Color(0.68, 0.46, 0.77, 0.2)
Color | line_length_guideline_color | Color(0.3, 0.5, 0.8, 0.1)
Color | line_number_color | Color(0.67, 0.67, 0.67, 0.4)
int | completion_lines | 7
int | completion_max_width | 50
int | completion_scroll_width | 6
Texture2D | bookmark |
Texture2D | breakpoint |
Texture2D | can_fold |
Texture2D | can_fold_code_region |
Texture2D | completion_color_bg |
Texture2D | executing_line |
Texture2D | folded |
Texture2D | folded_code_region |
Texture2D | folded_eol_icon |
StyleBox | completion |

---

## Signals

breakpoint_toggled(line: int) 

Emitted when a breakpoint is added or removed from a line. If the line is removed via backspace, a signal is emitted at the old line.

---

code_completion_requested() 

Emitted when the user requests code completion. This signal will not be sent if _request_code_completion() is overridden or code_completion_enabled is false.

---

symbol_hovered(symbol: String, line: int, column: int) 

Emitted when the user hovers over a symbol. Unlike Control.mouse_entered, this signal is not emitted immediately, but when the cursor is over the symbol for ProjectSettings.gui/timers/tooltip_delay_sec seconds.

Note: symbol_tooltip_on_hover must be true for this signal to be emitted.

---

symbol_lookup(symbol: String, line: int, column: int) 

Emitted when the user has clicked on a valid symbol.

---

symbol_validate(symbol: String) 

Emitted when the user hovers over a symbol. The symbol should be validated and responded to, by calling set_symbol_lookup_word_as_valid().

Note: symbol_lookup_on_click must be true for this signal to be emitted.

---

## Enumerations

enum CodeCompletionKind
CodeCompletionKind KIND_CLASS = 0

Marks the option as a class.

CodeCompletionKind KIND_FUNCTION = 1

Marks the option as a function.

CodeCompletionKind KIND_SIGNAL = 2

Marks the option as a Godot signal.

CodeCompletionKind KIND_VARIABLE = 3

Marks the option as a variable.

CodeCompletionKind KIND_MEMBER = 4

Marks the option as a member.

CodeCompletionKind KIND_ENUM = 5

Marks the option as an enum entry.

CodeCompletionKind KIND_CONSTANT = 6

Marks the option as a constant.

CodeCompletionKind KIND_NODE_PATH = 7

Marks the option as a Godot node path.

CodeCompletionKind KIND_FILE_PATH = 8

Marks the option as a file path.

CodeCompletionKind KIND_PLAIN_TEXT = 9

Marks the option as unclassified or plain text.

CodeCompletionKind KIND_KEYWORD = 10

Marks the option as a keyword.

---

enum CodeCompletionLocation
CodeCompletionLocation LOCATION_LOCAL = 0

The option is local to the location of the code completion query - e.g. a local variable. Subsequent value of location represent options from the outer class, the exact value represent how far they are (in terms of inner classes).

CodeCompletionLocation LOCATION_PARENT_MASK = 256

The option is from the containing class or a parent class, relative to the location of the code completion query. Perform a bitwise OR with the class depth (e.g. 0 for the local class, 1 for the parent, 2 for the grandparent, etc.) to store the depth of an option in the class or a parent class.

CodeCompletionLocation LOCATION_OTHER_USER_CODE = 512

The option is from user code which is not local and not in a derived class (e.g. Autoload Singletons).

CodeCompletionLocation LOCATION_OTHER = 1024

The option is from other engine code, not covered by the other enum constants - e.g. built-in classes.

---

## Property Descriptions

bool auto_brace_completion_enabled = false 

- void set_auto_brace_completion_enabled(value: bool)
- bool is_auto_brace_completion_enabled()

If true, uses auto_brace_completion_pairs to automatically insert the closing brace when the opening brace is inserted by typing or autocompletion. Also automatically removes the closing brace when using backspace on the opening brace.

---

bool auto_brace_completion_highlight_matching = false 

- void set_highlight_matching_braces_enabled(value: bool)
- bool is_highlight_matching_braces_enabled()

If true, highlights brace pairs when the caret is on either one, using auto_brace_completion_pairs. If matching, the pairs will be underlined. If a brace is unmatched, it is colored with brace_mismatch_color.

---

Dictionary auto_brace_completion_pairs = { "\"": "\"", "'": "'", "(": ")", "[": "]", "{": "}" } 

- void set_auto_brace_completion_pairs(value: Dictionary)
- Dictionary get_auto_brace_completion_pairs()

Sets the brace pairs to be autocompleted. For each entry in the dictionary, the key is the opening brace and the value is the closing brace that matches it. A brace is a String made of symbols. See auto_brace_completion_enabled and auto_brace_completion_highlight_matching.

---

bool code_completion_enabled = false 

- void set_code_completion_enabled(value: bool)
- bool is_code_completion_enabled()

If true, the ProjectSettings.input/ui_text_completion_query action requests code completion. To handle it, see _request_code_completion() or code_completion_requested.

---

Array[String] code_completion_prefixes = [] 

- void set_code_completion_prefixes(value: Array[String])
- Array[String] get_code_completion_prefixes()

Sets prefixes that will trigger code completion.

---

Array[String] delimiter_comments = [] 

- void set_comment_delimiters(value: Array[String])
- Array[String] get_comment_delimiters()

Sets the comment delimiters. All existing comment delimiters will be removed.

---

Array[String] delimiter_strings = ["' '", "\" \""] 

- void set_string_delimiters(value: Array[String])
- Array[String] get_string_delimiters()

Sets the string delimiters. All existing string delimiters will be removed.

---

bool gutters_draw_bookmarks = false 

- void set_draw_bookmarks_gutter(value: bool)
- bool is_drawing_bookmarks_gutter()

If true, bookmarks are drawn in the gutter. This gutter is shared with breakpoints and executing lines. See set_line_as_bookmarked().

---

bool gutters_draw_breakpoints_gutter = false 

- void set_draw_breakpoints_gutter(value: bool)
- bool is_drawing_breakpoints_gutter()

If true, breakpoints are drawn in the gutter. This gutter is shared with bookmarks and executing lines. Clicking the gutter will toggle the breakpoint for the line, see set_line_as_breakpoint().

---

bool gutters_draw_executing_lines = false 

- void set_draw_executing_lines_gutter(value: bool)
- bool is_drawing_executing_lines_gutter()

If true, executing lines are marked in the gutter. This gutter is shared with breakpoints and bookmarks. See set_line_as_executing().

---

bool gutters_draw_fold_gutter = false 

- void set_draw_fold_gutter(value: bool)
- bool is_drawing_fold_gutter()

If true, the fold gutter is drawn. In this gutter, the can_fold_code_region icon is drawn for each foldable line (see can_fold_line()) and the folded_code_region icon is drawn for each folded line (see is_line_folded()). These icons can be clicked to toggle the fold state, see toggle_foldable_line(). line_folding must be true to show icons.

---

bool gutters_draw_line_numbers = false 

- void set_draw_line_numbers(value: bool)
- bool is_draw_line_numbers_enabled()

If true, the line number gutter is drawn. Line numbers start at 1 and are incremented for each line of text. Clicking and dragging in the line number gutter will select entire lines of text.

---

int gutters_line_numbers_min_digits = 3 

- void set_line_numbers_min_digits(value: int)
- int get_line_numbers_min_digits()

The minimum width in digits reserved for the line number gutter.

---

bool gutters_zero_pad_line_numbers = false 

- void set_line_numbers_zero_padded(value: bool)
- bool is_line_numbers_zero_padded()

If true, line numbers drawn in the gutter are zero padded based on the total line count. Requires gutters_draw_line_numbers to be set to true.

---

bool indent_automatic = false 

- void set_auto_indent_enabled(value: bool)
- bool is_auto_indent_enabled()

If true, an extra indent is automatically inserted when a new line is added and a prefix in indent_automatic_prefixes is found. If a brace pair opening key is found, the matching closing brace will be moved to another new line (see auto_brace_completion_pairs).

---

Array[String] indent_automatic_prefixes = [":", "{", "[", "("] 

- void set_auto_indent_prefixes(value: Array[String])
- Array[String] get_auto_indent_prefixes()

Prefixes to trigger an automatic indent. Used when indent_automatic is set to true.

---

int indent_size = 4 

- void set_indent_size(value: int)
- int get_indent_size()

Size of the tabulation indent (one Tab press) in characters. If indent_use_spaces is enabled the number of spaces to use.

---

bool indent_use_spaces = false 

- void set_indent_using_spaces(value: bool)
- bool is_indent_using_spaces()

Use spaces instead of tabs for indentation.

---

bool line_folding = false 

- void set_line_folding_enabled(value: bool)
- bool is_line_folding_enabled()

If true, lines can be folded. Otherwise, line folding methods like fold_line() will not work and can_fold_line() will always return false. See gutters_draw_fold_gutter.

---

Array[int] line_length_guidelines = [] 

- void set_line_length_guidelines(value: Array[int])
- Array[int] get_line_length_guidelines()

Draws vertical lines at the provided columns. The first entry is considered a main hard guideline and is drawn more prominently.

---

bool symbol_lookup_on_click = false 

- void set_symbol_lookup_on_click_enabled(value: bool)
- bool is_symbol_lookup_on_click_enabled()

Set when a validated word from symbol_validate is clicked, the symbol_lookup should be emitted.

---

bool symbol_tooltip_on_hover = false 

- void set_symbol_tooltip_on_hover_enabled(value: bool)
- bool is_symbol_tooltip_on_hover_enabled()

If true, the symbol_hovered signal is emitted when hovering over a word.

---

## Method Descriptions

void _confirm_code_completion(replace: bool) virtual 

Override this method to define how the selected entry should be inserted. If replace is true, any existing text should be replaced.

---

Array[Dictionary] _filter_code_completion_candidates(candidates: Array[Dictionary]) virtual const 

Override this method to define what items in candidates should be displayed.

Both candidates and the return is an Array of Dictionary, see get_code_completion_option() for Dictionary content.

---

void _request_code_completion(force: bool) virtual 

Override this method to define what happens when the user requests code completion. If force is true, any checks should be bypassed.

---

void add_auto_brace_completion_pair(start_key: String, end_key: String) 

Adds a brace pair.

Both the start and end keys must be symbols. Only the start key has to be unique.

---

void add_code_completion_option(type: CodeCompletionKind, display_text: String, insert_text: String, text_color: Color = Color(1, 1, 1, 1), icon: Resource = null, value: Variant = null, location: int = 1024) 

Submits an item to the queue of potential candidates for the autocomplete menu. Call update_code_completion_options() to update the list.

location indicates location of the option relative to the location of the code completion query. See CodeCompletionLocation for how to set this value.

Note: This list will replace all current candidates.

---

void add_comment_delimiter(start_key: String, end_key: String, line_only: bool = false) 

Adds a comment delimiter from start_key to end_key. Both keys should be symbols, and start_key must not be shared with other delimiters.

If line_only is true or end_key is an empty String, the region does not carry over to the next line.

---

void add_string_delimiter(start_key: String, end_key: String, line_only: bool = false) 

Defines a string delimiter from start_key to end_key. Both keys should be symbols, and start_key must not be shared with other delimiters.

If line_only is true or end_key is an empty String, the region does not carry over to the next line.

---

bool can_fold_line(line: int) const 

Returns true if the given line is foldable. A line is foldable if it is the start of a valid code region (see get_code_region_start_tag()), if it is the start of a comment or string block, or if the next non-empty line is more indented (see TextEdit.get_indent_level()).

---

void cancel_code_completion() 

Cancels the autocomplete menu.

---

void clear_bookmarked_lines() 

Clears all bookmarked lines.

---

void clear_breakpointed_lines() 

Clears all breakpointed lines.

---

void clear_comment_delimiters() 

Removes all comment delimiters.

---

void clear_executing_lines() 

Clears all executed lines.

---

void clear_string_delimiters() 

Removes all string delimiters.

---

void confirm_code_completion(replace: bool = false) 

Inserts the selected entry into the text. If replace is true, any existing text is replaced rather than merged.

---

void convert_indent(from_line: int = -1, to_line: int = -1) 

Converts the indents of lines between from_line and to_line to tabs or spaces as set by indent_use_spaces.

Values of -1 convert the entire text.

---

void create_code_region() 

Creates a new code region with the selection. At least one single line comment delimiter have to be defined (see add_comment_delimiter()).

A code region is a part of code that is highlighted when folded and can help organize your script.

Code region start and end tags can be customized (see set_code_region_tags()).

Code regions are delimited using start and end tags (respectively region and endregion by default) preceded by one line comment delimiter. (eg. #region and #endregion)

---

void delete_lines() 

Deletes all lines that are selected or have a caret on them.

---

void do_indent() 

If there is no selection, indentation is inserted at the caret. Otherwise, the selected lines are indented like indent_lines(). Equivalent to the ProjectSettings.input/ui_text_indent action. The indentation characters used depend on indent_use_spaces and indent_size.

---

void duplicate_lines() 

Duplicates all lines currently selected with any caret. Duplicates the entire line beneath the current one no matter where the caret is within the line.

---

void duplicate_selection() 

Duplicates all selected text and duplicates all lines with a caret on them.

---

void fold_all_lines() 

Folds all lines that are possible to be folded (see can_fold_line()).

---

void fold_line(line: int) 

Folds the given line, if possible (see can_fold_line()).

---

String get_auto_brace_completion_close_key(open_key: String) const 

Gets the matching auto brace close key for open_key.

---

PackedInt32Array get_bookmarked_lines() const 

Gets all bookmarked lines.

---

PackedInt32Array get_breakpointed_lines() const 

Gets all breakpointed lines.

---

Dictionary get_code_completion_option(index: int) const 

Gets the completion option at index. The return Dictionary has the following key-values:

kind: CodeCompletionKind

display_text: Text that is shown on the autocomplete menu.

insert_text: Text that is to be inserted when this item is selected.

font_color: Color of the text on the autocomplete menu.

icon: Icon to draw on the autocomplete menu.

default_value: Value of the symbol.

---

Array[Dictionary] get_code_completion_options() const 

Gets all completion options, see get_code_completion_option() for return content.

---

int get_code_completion_selected_index() const 

Gets the index of the current selected completion option.

---

String get_code_region_end_tag() const 

Returns the code region end tag (without comment delimiter).

---

String get_code_region_start_tag() const 

Returns the code region start tag (without comment delimiter).

---

String get_delimiter_end_key(delimiter_index: int) const 

Gets the end key for a string or comment region index.

---

Vector2 get_delimiter_end_position(line: int, column: int) const 

If line column is in a string or comment, returns the end position of the region. If not or no end could be found, both Vector2 values will be -1.

---

String get_delimiter_start_key(delimiter_index: int) const 

Gets the start key for a string or comment region index.

---

Vector2 get_delimiter_start_position(line: int, column: int) const 

If line column is in a string or comment, returns the start position of the region. If not or no start could be found, both Vector2 values will be -1.

---

PackedInt32Array get_executing_lines() const 

Gets all executing lines.

---

Array[int] get_folded_lines() const 

Returns all lines that are currently folded.

---

String get_text_for_code_completion() const 

Returns the full text with char 0xFFFF at the caret location.

---

String get_text_for_symbol_lookup() const 

Returns the full text with char 0xFFFF at the cursor location.

---

String get_text_with_cursor_char(line: int, column: int) const 

Returns the full text with char 0xFFFF at the specified location.

---

bool has_auto_brace_completion_close_key(close_key: String) const 

Returns true if close key close_key exists.

---

bool has_auto_brace_completion_open_key(open_key: String) const 

Returns true if open key open_key exists.

---

bool has_comment_delimiter(start_key: String) const 

Returns true if comment start_key exists.

---

bool has_string_delimiter(start_key: String) const 

Returns true if string start_key exists.

---

void indent_lines() 

Indents all lines that are selected or have a caret on them. Uses spaces or a tab depending on indent_use_spaces. See unindent_lines().

---

int is_in_comment(line: int, column: int = -1) const 

Returns delimiter index if line column is in a comment. If column is not provided, will return delimiter index if the entire line is a comment. Otherwise -1.

---

int is_in_string(line: int, column: int = -1) const 

Returns the delimiter index if line column is in a string. If column is not provided, will return the delimiter index if the entire line is a string. Otherwise -1.

---

bool is_line_bookmarked(line: int) const 

Returns true if the given line is bookmarked. See set_line_as_bookmarked().

---

bool is_line_breakpointed(line: int) const 

Returns true if the given line is breakpointed. See set_line_as_breakpoint().

---

bool is_line_code_region_end(line: int) const 

Returns true if the given line is a code region end. See set_code_region_tags().

---

bool is_line_code_region_start(line: int) const 

Returns true if the given line is a code region start. See set_code_region_tags().

---

bool is_line_executing(line: int) const 

Returns true if the given line is marked as executing. See set_line_as_executing().

---

bool is_line_folded(line: int) const 

Returns true if the given line is folded. See fold_line().

---

void join_lines(line_ending: String = " ") 

Joins all selected lines or lines containing a caret with their next line. Whitespace in between will be removed. If the next line has content, the line_ending will be inserted in between.

---

void move_lines_down() 

Moves all lines down that are selected or have a caret on them.

---

void move_lines_up() 

Moves all lines up that are selected or have a caret on them.

---

void remove_comment_delimiter(start_key: String) 

Removes the comment delimiter with start_key.

---

void remove_string_delimiter(start_key: String) 

Removes the string delimiter with start_key.

---

void request_code_completion(force: bool = false) 

Emits code_completion_requested, if force is true will bypass all checks. Otherwise will check that the caret is in a word or in front of a prefix. Will ignore the request if all current options are of type file path, node path, or signal.

---

void set_code_completion_selected_index(index: int) 

Sets the current selected completion option.

---

void set_code_hint(code_hint: String) 

Sets the code hint text. Pass an empty string to clear.

---

void set_code_hint_draw_below(draw_below: bool) 

If true, the code hint will draw below the main caret. If false, the code hint will draw above the main caret. See set_code_hint().

---

void set_code_region_tags(start: String = "region", end: String = "endregion") 

Sets the code region start and end tags (without comment delimiter).

---

void set_line_as_bookmarked(line: int, bookmarked: bool) 

Sets the given line as bookmarked. If true and gutters_draw_bookmarks is true, draws the bookmark icon in the gutter for this line. See get_bookmarked_lines() and is_line_bookmarked().

---

void set_line_as_breakpoint(line: int, breakpointed: bool) 

Sets the given line as a breakpoint. If true and gutters_draw_breakpoints_gutter is true, draws the breakpoint icon in the gutter for this line. See get_breakpointed_lines() and is_line_breakpointed().

---

void set_line_as_executing(line: int, executing: bool) 

Sets the given line as executing. If true and gutters_draw_executing_lines is true, draws the executing_line icon in the gutter for this line. See get_executing_lines() and is_line_executing().

---

void set_symbol_lookup_word_as_valid(valid: bool) 

Sets the symbol emitted by symbol_validate as a valid lookup.

---

void toggle_foldable_line(line: int) 

Toggle the folding of the code block at the given line.

---

void toggle_foldable_lines_at_carets() 

Toggle the folding of the code block on all lines with a caret on them.

---

void unfold_all_lines() 

Unfolds all lines that are folded.

---

void unfold_line(line: int) 

Unfolds the given line if it is folded or if it is hidden under a folded line.

---

void unindent_lines() 

Unindents all lines that are selected or have a caret on them. Uses spaces or a tab depending on indent_use_spaces. Equivalent to the ProjectSettings.input/ui_text_dedent action. See indent_lines().

---

void update_code_completion_options(force: bool) 

Submits all completion options added with add_code_completion_option(). Will try to force the autocomplete menu to popup, if force is true.

Note: This will replace all current candidates.

---

## Theme Property Descriptions

Color bookmark_color = Color(0.5, 0.64, 1, 0.8) 

Color of the bookmark icon for bookmarked lines.

---

Color brace_mismatch_color = Color(1, 0.2, 0.2, 1) 

Color of the text to highlight mismatched braces.

---

Color breakpoint_color = Color(0.9, 0.29, 0.3, 1) 

Color of the breakpoint icon for bookmarked lines.

---

Color code_folding_color = Color(0.8, 0.8, 0.8, 0.8) 

Color for all icons related to line folding.

---

Color completion_background_color = Color(0.17, 0.16, 0.2, 1) 

Sets the background Color for the code completion popup.

---

Color completion_existing_color = Color(0.87, 0.87, 0.87, 0.13) 

Background highlight Color for matching text in code completion options.

---

Color completion_scroll_color = Color(1, 1, 1, 0.29) 

Color of the scrollbar in the code completion popup.

---

Color completion_scroll_hovered_color = Color(1, 1, 1, 0.4) 

Color of the scrollbar in the code completion popup when hovered.

---

Color completion_selected_color = Color(0.26, 0.26, 0.27, 1) 

Background highlight Color for the current selected option item in the code completion popup.

---

Color executing_line_color = Color(0.98, 0.89, 0.27, 1) 

Color of the executing icon for executing lines.

---

Color folded_code_region_color = Color(0.68, 0.46, 0.77, 0.2) 

Color of background line highlight for folded code region.

---

Color line_length_guideline_color = Color(0.3, 0.5, 0.8, 0.1) 

Color of the main line length guideline, secondary guidelines will have 50% alpha applied.

---

Color line_number_color = Color(0.67, 0.67, 0.67, 0.4) 

Sets the Color of line numbers.

---

int completion_lines = 7 

Max number of options to display in the code completion popup at any one time.

---

int completion_max_width = 50 

Max width of options in the code completion popup. Options longer than this will be cut off.

---

int completion_scroll_width = 6 

Width of the scrollbar in the code completion popup.

---

Texture2D bookmark 

Sets a custom Texture2D to draw in the bookmark gutter for bookmarked lines.

---

Texture2D breakpoint 

Sets a custom Texture2D to draw in the breakpoint gutter for breakpointed lines.

---

Texture2D can_fold 

Sets a custom Texture2D to draw in the line folding gutter when a line can be folded.

---

Texture2D can_fold_code_region 

Sets a custom Texture2D to draw in the line folding gutter when a code region can be folded.

---

Texture2D completion_color_bg 

Background panel for the color preview box in autocompletion (visible when the color is translucent).

---

Texture2D executing_line 

Icon to draw in the executing gutter for executing lines.

---

Texture2D folded 

Sets a custom Texture2D to draw in the line folding gutter when a line is folded and can be unfolded.

---

Texture2D folded_code_region 

Sets a custom Texture2D to draw in the line folding gutter when a code region is folded and can be unfolded.

---

Texture2D folded_eol_icon 

Sets a custom Texture2D to draw at the end of a folded line.

---

StyleBox completion 

StyleBox for the code completion popup.
