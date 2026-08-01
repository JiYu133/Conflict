# ScriptBacktrace

Inherits: RefCounted < Object

A captured backtrace of a specific script language.

## Description

ScriptBacktrace holds an already captured backtrace of a specific script language, such as GDScript or C#, which are captured using Engine.capture_script_backtraces().

See ProjectSettings.debug/settings/gdscript/always_track_call_stacks and ProjectSettings.debug/settings/gdscript/always_track_local_variables for ways of controlling the contents of this class.

## Methods

String | format(indent_all: int = 0, indent_frames: int = 4) const
int | get_frame_count() const
String | get_frame_file(index: int) const
String | get_frame_function(index: int) const
int | get_frame_line(index: int) const
int | get_global_variable_count() const
String | get_global_variable_name(variable_index: int) const
Variant | get_global_variable_value(variable_index: int) const
String | get_language_name() const
int | get_local_variable_count(frame_index: int) const
String | get_local_variable_name(frame_index: int, variable_index: int) const
Variant | get_local_variable_value(frame_index: int, variable_index: int) const
int | get_member_variable_count(frame_index: int) const
String | get_member_variable_name(frame_index: int, variable_index: int) const
Variant | get_member_variable_value(frame_index: int, variable_index: int) const
bool | is_empty() const

---

## Method Descriptions

String format(indent_all: int = 0, indent_frames: int = 4) const 

Converts the backtrace to a String, where the entire string will be indented by indent_all number of spaces, and the individual stack frames will be additionally indented by indent_frames number of spaces.

Note: Calling Object.to_string() on a ScriptBacktrace will produce the same output as calling format() with all parameters left at their default values.

---

int get_frame_count() const 

Returns the number of stack frames in the backtrace.

---

String get_frame_file(index: int) const 

Returns the file name of the call site represented by the stack frame at the specified index.

---

String get_frame_function(index: int) const 

Returns the name of the function called at the stack frame at the specified index.

---

int get_frame_line(index: int) const 

Returns the line number of the call site represented by the stack frame at the specified index.

---

int get_global_variable_count() const 

Returns the number of global variables (e.g. autoload singletons) in the backtrace.

Note: This will be non-zero only if the include_variables parameter was true when capturing the backtrace with Engine.capture_script_backtraces().

---

String get_global_variable_name(variable_index: int) const 

Returns the name of the global variable at the specified index.

---

Variant get_global_variable_value(variable_index: int) const 

Returns the value of the global variable at the specified index.

Warning: With GDScript backtraces, the returned Variant will be the variable's actual value, including any object references. This means that storing the returned Variant will prevent any such object from being deallocated, so it's generally recommended not to do so.

---

String get_language_name() const 

Returns the name of the script language that this backtrace was captured from.

---

int get_local_variable_count(frame_index: int) const 

Returns the number of local variables in the stack frame at the specified index.

Note: This will be non-zero only if the include_variables parameter was true when capturing the backtrace with Engine.capture_script_backtraces().

---

String get_local_variable_name(frame_index: int, variable_index: int) const 

Returns the name of the local variable at the specified variable_index in the stack frame at the specified frame_index.

---

Variant get_local_variable_value(frame_index: int, variable_index: int) const 

Returns the value of the local variable at the specified variable_index in the stack frame at the specified frame_index.

Warning: With GDScript backtraces, the returned Variant will be the variable's actual value, including any object references. This means that storing the returned Variant will prevent any such object from being deallocated, so it's generally recommended not to do so.

---

int get_member_variable_count(frame_index: int) const 

Returns the number of member variables in the stack frame at the specified index.

Note: This will be non-zero only if the include_variables parameter was true when capturing the backtrace with Engine.capture_script_backtraces().

---

String get_member_variable_name(frame_index: int, variable_index: int) const 

Returns the name of the member variable at the specified variable_index in the stack frame at the specified frame_index.

---

Variant get_member_variable_value(frame_index: int, variable_index: int) const 

Returns the value of the member variable at the specified variable_index in the stack frame at the specified frame_index.

Warning: With GDScript backtraces, the returned Variant will be the variable's actual value, including any object references. This means that storing the returned Variant will prevent any such object from being deallocated, so it's generally recommended not to do so.

---

bool is_empty() const 

Returns true if the backtrace has no stack frames.
