# EditorDebuggerSession

Inherits: RefCounted < Object

A class to interact with the editor debugger.

## Description

This class cannot be directly instantiated and must be retrieved via an EditorDebuggerPlugin.

You can add tabs to the session UI via add_session_tab(), send messages via send_message(), and toggle EngineProfilers via toggle_profiler().

## Methods

void | add_session_tab(control: Control)
bool | is_active()
bool | is_breaked()
bool | is_debuggable()
void | remove_session_tab(control: Control)
void | send_message(message: String, data: Array = [])
void | set_breakpoint(path: String, line: int, enabled: bool)
void | toggle_profiler(profiler: String, enable: bool, data: Array = [])

---

## Signals

breaked(can_debug: bool) 

Emitted when the attached remote instance enters a break state. If can_debug is true, the remote instance will enter the debug loop.

---

continued() 

Emitted when the attached remote instance exits a break state.

---

started() 

Emitted when a remote instance is attached to this session (i.e. the session becomes active).

---

stopped() 

Emitted when a remote instance is detached from this session (i.e. the session becomes inactive).

---

## Method Descriptions

void add_session_tab(control: Control) 

Adds the given control to the debug session UI in the debugger bottom panel. The control's node name will be used as the tab title.

---

bool is_active() 

Returns true if the debug session is currently attached to a remote instance.

---

bool is_breaked() 

Returns true if the attached remote instance is currently in the debug loop.

---

bool is_debuggable() 

Returns true if the attached remote instance can be debugged.

---

void remove_session_tab(control: Control) 

Removes the given control from the debug session UI in the debugger bottom panel.

---

void send_message(message: String, data: Array = []) 

Sends the given message to the attached remote instance, optionally passing additionally data. See EngineDebugger for how to retrieve those messages.

---

void set_breakpoint(path: String, line: int, enabled: bool) 

Enables or disables a specific breakpoint based on enabled, updating the Editor Breakpoint Panel accordingly.

---

void toggle_profiler(profiler: String, enable: bool, data: Array = []) 

Toggle the given profiler on the attached remote instance, optionally passing additionally data. See EngineProfiler for more details.
