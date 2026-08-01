# EngineDebugger

Inherits: Object

Exposes the internal debugger.

## Description

EngineDebugger handles the communication between the editor and the running game. It is active in the running game. Messages can be sent/received through it. It also manages the profilers.

## Methods

void | clear_breakpoints()
void | debug(can_continue: bool = true, is_error_breakpoint: bool = false)
int | get_depth() const
int | get_lines_left() const
bool | has_capture(name: StringName)
bool | has_profiler(name: StringName)
void | insert_breakpoint(line: int, source: StringName)
bool | is_active()
bool | is_breakpoint(line: int, source: StringName) const
bool | is_profiling(name: StringName)
bool | is_skipping_breakpoints() const
void | line_poll()
void | profiler_add_frame_data(name: StringName, data: Array)
void | profiler_enable(name: StringName, enable: bool, arguments: Array = [])
void | register_message_capture(name: StringName, callable: Callable)
void | register_profiler(name: StringName, profiler: EngineProfiler)
void | remove_breakpoint(line: int, source: StringName)
void | script_debug(language: ScriptLanguage, can_continue: bool = true, is_error_breakpoint: bool = false)
void | send_message(message: String, data: Array)
void | set_depth(depth: int)
void | set_lines_left(lines: int)
void | unregister_message_capture(name: StringName)
void | unregister_profiler(name: StringName)

---

## Method Descriptions

void clear_breakpoints() 

Clears all breakpoints.

---

void debug(can_continue: bool = true, is_error_breakpoint: bool = false) 

Starts a debug break in script execution, optionally specifying whether the program can continue based on can_continue and whether the break was due to a breakpoint.

---

int get_depth() const 

Experimental: This method may be changed or removed in future versions.

Returns the current debug depth.

---

int get_lines_left() const 

Experimental: This method may be changed or removed in future versions.

Returns the number of lines that remain.

---

bool has_capture(name: StringName) 

Returns true if a capture with the given name is present otherwise false.

---

bool has_profiler(name: StringName) 

Returns true if a profiler with the given name is present otherwise false.

---

void insert_breakpoint(line: int, source: StringName) 

Inserts a new breakpoint with the given source and line.

---

bool is_active() 

Returns true if the debugger is active otherwise false.

---

bool is_breakpoint(line: int, source: StringName) const 

Returns true if the given source and line represent an existing breakpoint.

---

bool is_profiling(name: StringName) 

Returns true if a profiler with the given name is present and active otherwise false.

---

bool is_skipping_breakpoints() const 

Returns true if the debugger is skipping breakpoints otherwise false.

---

void line_poll() 

Forces a processing loop of debugger events. The purpose of this method is just processing events every now and then when the script might get too busy, so that bugs like infinite loops can be caught.

---

void profiler_add_frame_data(name: StringName, data: Array) 

Calls the add callable of the profiler with given name and data.

---

void profiler_enable(name: StringName, enable: bool, arguments: Array = []) 

Calls the toggle callable of the profiler with given name and arguments. Enables/Disables the same profiler depending on enable argument.

---

void register_message_capture(name: StringName, callable: Callable) 

Registers a message capture with given name. If name is "my_message" then messages starting with "my_message:" will be called with the given callable.

The callable must accept a message string and a data array as argument. The callable should return true if the message is recognized.

Note: The callable will receive the message with the prefix stripped, unlike EditorDebuggerPlugin._capture(). See the EditorDebuggerPlugin description for an example.

---

void register_profiler(name: StringName, profiler: EngineProfiler) 

Registers a profiler with the given name. See EngineProfiler for more information.

---

void remove_breakpoint(line: int, source: StringName) 

Removes a breakpoint with the given source and line.

---

void script_debug(language: ScriptLanguage, can_continue: bool = true, is_error_breakpoint: bool = false) 

Starts a debug break in script execution, optionally specifying whether the program can continue based on can_continue and whether the break was due to a breakpoint.

---

void send_message(message: String, data: Array) 

Sends a message with given message and data array.

---

void set_depth(depth: int) 

Experimental: This method may be changed or removed in future versions.

Sets the current debugging depth.

---

void set_lines_left(lines: int) 

Experimental: This method may be changed or removed in future versions.

Sets the current debugging lines that remain.

---

void unregister_message_capture(name: StringName) 

Unregisters the message capture with given name.

---

void unregister_profiler(name: StringName) 

Unregisters a profiler with given name.
