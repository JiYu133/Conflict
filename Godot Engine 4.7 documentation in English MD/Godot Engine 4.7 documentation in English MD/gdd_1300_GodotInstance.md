# GodotInstance

Inherits: Object

Provides access to an embedded Godot instance.

## Description

GodotInstance represents a running Godot instance that is controlled from an outside codebase, without a perpetual main loop. It is created by the C API libgodot_create_godot_instance. Only one may be created per process.

## Methods

void | focus_in()
void | focus_out()
bool | is_started()
bool | iteration()
void | pause()
void | resume()
bool | start()

---

## Method Descriptions

void focus_in() 

Notifies the instance that it is now in focus.

---

void focus_out() 

Notifies the instance that it is now not in focus.

---

bool is_started() 

Returns true if this instance has been fully started.

---

bool iteration() 

Runs a single iteration of the main loop. Returns true if the engine is attempting to quit.

---

void pause() 

Notifies the instance that it is going to be paused.

---

void resume() 

Notifies the instance that it is being resumed.

---

bool start() 

Finishes this instance's startup sequence. Returns true on success.
