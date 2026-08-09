# EngineProfiler

Inherits: RefCounted < Object

Base class for creating custom profilers.

## Description

This class can be used to implement custom profilers that are able to interact with the engine and editor debugger.

See EngineDebugger and EditorDebuggerPlugin for more information.

## Methods

void | _add_frame(data: Array) virtual
void | _tick(frame_time: float, process_time: float, physics_time: float, physics_frame_time: float) virtual
void | _toggle(enable: bool, options: Array) virtual

---

## Method Descriptions

void _add_frame(data: Array) virtual 

Called when data is added to profiler using EngineDebugger.profiler_add_frame_data().

---

void _tick(frame_time: float, process_time: float, physics_time: float, physics_frame_time: float) virtual 

Called once every engine iteration when the profiler is active with information about the current frame. All time values are in seconds. Lower values represent faster processing times and are therefore considered better.

---

void _toggle(enable: bool, options: Array) virtual 

Called when the profiler is enabled/disabled, along with a set of options.
