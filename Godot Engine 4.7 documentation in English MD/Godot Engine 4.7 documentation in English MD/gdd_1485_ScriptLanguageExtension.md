# ScriptLanguageExtension

Inherits: ScriptLanguage < Object

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Methods

void | _add_global_constant(name: StringName, value: Variant) virtual required
void | _add_named_global_constant(name: StringName, value: Variant) virtual required
String | _auto_indent_code(code: String, from_line: int, to_line: int) virtual required const
bool | _can_inherit_from_file() virtual required const
bool | _can_make_function() virtual required const
Dictionary | _complete_code(code: String, path: String, owner: Object) virtual required const
Object | _create_script() virtual const
Array[Dictionary] | _debug_get_current_stack_info() virtual required
String | _debug_get_error() virtual required const
Dictionary | _debug_get_globals(max_subitems: int, max_depth: int) virtual required
int | _debug_get_stack_level_count() virtual required const
String | _debug_get_stack_level_function(level: int) virtual required const
void* | _debug_get_stack_level_instance(level: int) virtual required
int | _debug_get_stack_level_line(level: int) virtual required const
Dictionary | _debug_get_stack_level_locals(level: int, max_subitems: int, max_depth: int) virtual required
Dictionary | _debug_get_stack_level_members(level: int, max_subitems: int, max_depth: int) virtual required
String | _debug_get_stack_level_source(level: int) virtual required const
String | _debug_parse_stack_level_expression(level: int, expression: String, max_subitems: int, max_depth: int) virtual required
int | _find_function(function: String, code: String) virtual required const
void | _finish() virtual required
void | _frame() virtual required
Array[Dictionary] | _get_built_in_templates(object: StringName) virtual required const
PackedStringArray | _get_comment_delimiters() virtual required const
PackedStringArray | _get_doc_comment_delimiters() virtual const
String | _get_extension() virtual required const
Dictionary | _get_global_class_name(path: String) virtual required const
String | _get_name() virtual required const
Array[Dictionary] | _get_public_annotations() virtual required const
Dictionary | _get_public_constants() virtual required const
Array[Dictionary] | _get_public_functions() virtual required const
PackedStringArray | _get_recognized_extensions() virtual required const
PackedStringArray | _get_reserved_words() virtual required const
PackedStringArray | _get_string_delimiters() virtual required const
String | _get_type() virtual required const
bool | _handles_global_class_type(type: String) virtual required const
bool | _has_named_classes() virtual const
void | _init() virtual required
bool | _is_control_flow_keyword(keyword: String) virtual required const
bool | _is_using_templates() virtual required
Dictionary | _lookup_code(code: String, symbol: String, path: String, owner: Object) virtual required const
String | _make_function(class_name: String, function_name: String, function_args: PackedStringArray) virtual required const
Script | _make_template(template: String, class_name: String, base_class_name: String) virtual required const
Error | _open_in_external_editor(script: Script, line: int, column: int) virtual required
bool | _overrides_external_editor() virtual required
ScriptNameCasing | _preferred_file_name_casing() virtual const
int | _profiling_get_accumulated_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) virtual required
int | _profiling_get_frame_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) virtual required
void | _profiling_set_save_native_calls(enable: bool) virtual required
void | _profiling_start() virtual required
void | _profiling_stop() virtual required
void | _reload_all_scripts() virtual required
void | _reload_scripts(scripts: Array, soft_reload: bool) virtual required
void | _reload_tool_script(script: Script, soft_reload: bool) virtual required
void | _remove_named_global_constant(name: StringName) virtual required
bool | _supports_builtin_mode() virtual required const
bool | _supports_documentation() virtual required const
void | _thread_enter() virtual required
void | _thread_exit() virtual required
Dictionary | _validate(script: String, path: String, validate_functions: bool, validate_errors: bool, validate_warnings: bool, validate_safe_lines: bool) virtual required const
String | _validate_path(path: String) virtual required const

---

## Enumerations

enum LookupResultType
LookupResultType LOOKUP_RESULT_SCRIPT_LOCATION = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_CONSTANT = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_PROPERTY = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_METHOD = 4

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_SIGNAL = 5

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_ENUM = 6

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_CLASS_TBD_GLOBALSCOPE = 7

Deprecated: This constant may be changed or removed in future versions.

LookupResultType LOOKUP_RESULT_CLASS_ANNOTATION = 8

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_LOCAL_CONSTANT = 9

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_LOCAL_VARIABLE = 10

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

LookupResultType LOOKUP_RESULT_MAX = 11

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

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

enum CodeCompletionKind
CodeCompletionKind CODE_COMPLETION_KIND_CLASS = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_FUNCTION = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_SIGNAL = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_VARIABLE = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_MEMBER = 4

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_ENUM = 5

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_CONSTANT = 6

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_NODE_PATH = 7

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_FILE_PATH = 8

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_PLAIN_TEXT = 9

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_KEYWORD = 10

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

CodeCompletionKind CODE_COMPLETION_KIND_MAX = 11

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Method Descriptions

void _add_global_constant(name: StringName, value: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _add_named_global_constant(name: StringName, value: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _auto_indent_code(code: String, from_line: int, to_line: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _can_inherit_from_file() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _can_make_function() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _complete_code(code: String, path: String, owner: Object) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Object _create_script() virtual const 

Deprecated: This method is not called by the engine.

---

Array[Dictionary] _debug_get_current_stack_info() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _debug_get_error() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _debug_get_globals(max_subitems: int, max_depth: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _debug_get_stack_level_count() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _debug_get_stack_level_function(level: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void* _debug_get_stack_level_instance(level: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _debug_get_stack_level_line(level: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _debug_get_stack_level_locals(level: int, max_subitems: int, max_depth: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _debug_get_stack_level_members(level: int, max_subitems: int, max_depth: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _debug_get_stack_level_source(level: int) virtual required const 

Returns the source associated with a given debug stack position.

---

String _debug_parse_stack_level_expression(level: int, expression: String, max_subitems: int, max_depth: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _find_function(function: String, code: String) virtual required const 

Returns the line where the function is defined in the code, or -1 if the function is not present.

---

void _finish() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _frame() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_built_in_templates(object: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedStringArray _get_comment_delimiters() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedStringArray _get_doc_comment_delimiters() virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _get_extension() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _get_global_class_name(path: String) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _get_name() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_public_annotations() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _get_public_constants() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_public_functions() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedStringArray _get_recognized_extensions() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedStringArray _get_reserved_words() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedStringArray _get_string_delimiters() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _get_type() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _handles_global_class_type(type: String) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_named_classes() virtual const 

Deprecated: This method is not called by the engine.

---

void _init() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_control_flow_keyword(keyword: String) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_using_templates() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _lookup_code(code: String, symbol: String, path: String, owner: Object) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _make_function(class_name: String, function_name: String, function_args: PackedStringArray) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Script _make_template(template: String, class_name: String, base_class_name: String) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Error _open_in_external_editor(script: Script, line: int, column: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _overrides_external_editor() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

ScriptNameCasing _preferred_file_name_casing() virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _profiling_get_accumulated_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _profiling_get_frame_data(info_array: ScriptLanguageExtensionProfilingInfo*, info_max: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _profiling_set_save_native_calls(enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _profiling_start() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _profiling_stop() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _reload_all_scripts() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _reload_scripts(scripts: Array, soft_reload: bool) virtual required 

Reloads all scripts from disk and the specifics of how that happens is ScriptLanguageExtension specific.

---

void _reload_tool_script(script: Script, soft_reload: bool) virtual required 

Reloads the given script from disk and the specifics of how that happens is ScriptLanguageExtension specific.

---

void _remove_named_global_constant(name: StringName) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _supports_builtin_mode() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _supports_documentation() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _thread_enter() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _thread_exit() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _validate(script: String, path: String, validate_functions: bool, validate_errors: bool, validate_warnings: bool, validate_safe_lines: bool) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _validate_path(path: String) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
