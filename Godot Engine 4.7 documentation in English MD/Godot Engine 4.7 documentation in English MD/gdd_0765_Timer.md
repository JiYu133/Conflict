# Timer

Inherits: Node < Object

A countdown timer.

## Description

The Timer node is a countdown timer and is the simplest way to handle time-based logic in the engine. When a timer reaches the end of its wait_time, it will emit the timeout signal.

After a timer enters the scene tree, it can be manually started with start(). A timer node is also started automatically if autostart is true.

Without requiring much code, a timer node can be added and configured in the editor. The timeout signal it emits can also be connected through the Signals dock in the editor:

```gdscript
func _on_timer_timeout():
    print("Time to attack!")
```

Note: To create a one-shot timer without instantiating a node, use SceneTree.create_timer().

Note: Timers are affected by Engine.time_scale unless ignore_time_scale is true. The higher the time scale, the sooner timers will end. How often a timer processes may depend on the framerate or Engine.physics_ticks_per_second.

## Tutorials

- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]

## Properties

bool | autostart | false
bool | ignore_time_scale | false
bool | one_shot | false
bool | paused |
TimerProcessCallback | process_callback | 1
float | time_left |
float | wait_time | 1.0

## Methods

bool | is_stopped() const
void | start(time_sec: float = -1)
void | stop()

---

## Signals

timeout() 

Emitted when the timer reaches the end.

---

## Enumerations

enum TimerProcessCallback
TimerProcessCallback TIMER_PROCESS_PHYSICS = 0

Update the timer every physics process frame (see Node.NOTIFICATION_INTERNAL_PHYSICS_PROCESS).

TimerProcessCallback TIMER_PROCESS_IDLE = 1

Update the timer every process (rendered) frame (see Node.NOTIFICATION_INTERNAL_PROCESS).

---

## Property Descriptions

bool autostart = false 

- void set_autostart(value: bool)
- bool has_autostart()

If true, the timer will start immediately when it enters the scene tree.

Note: After the timer enters the tree, this property is automatically set to false.

Note: This property does nothing when the timer is running in the editor.

---

bool ignore_time_scale = false 

- void set_ignore_time_scale(value: bool)
- bool is_ignoring_time_scale()

If true, the timer will ignore Engine.time_scale and update with the real, elapsed time.

---

bool one_shot = false 

- void set_one_shot(value: bool)
- bool is_one_shot()

If true, the timer will stop after reaching the end. Otherwise, as by default, the timer will automatically restart.

---

bool paused 

- void set_paused(value: bool)
- bool is_paused()

If true, the timer is paused. A paused timer does not process until this property is set back to false, even when start() is called. See also stop().

---

TimerProcessCallback process_callback = 1 

- void set_timer_process_callback(value: TimerProcessCallback)
- TimerProcessCallback get_timer_process_callback()

Specifies when the timer is updated during the main loop.

---

float time_left 

- float get_time_left()

The timer's remaining time in seconds. This is always 0 if the timer is stopped.

Note: This property is read-only and cannot be modified. It is based on wait_time.

---

float wait_time = 1.0 

- void set_wait_time(value: float)
- float get_wait_time()

The time required for the timer to end, in seconds. This property can also be set every time start() is called.

Note: Timers can only process once per physics or process frame (depending on the process_callback). An unstable framerate may cause the timer to end inconsistently, which is especially noticeable if the wait time is lower than roughly 0.05 seconds. For very short timers, it is recommended to write your own code instead of using a Timer node. Timers are also affected by Engine.time_scale.

---

## Method Descriptions

bool is_stopped() const 

Returns true if the timer is stopped or has not started.

---

void start(time_sec: float = -1) 

Starts the timer, or resets the timer if it was started already. Fails if the timer is not inside the scene tree. If time_sec is greater than 0, this value is used for the wait_time.

Note: This method does not resume a paused timer. See paused.

---

void stop() 

Stops the timer. See also paused. Unlike start(), this can safely be called if the timer is not inside the scene tree.

Note: Calling stop() does not emit the timeout signal, as the timer is not considered to have timed out. If this is desired, use $Timer.timeout.emit() after calling stop() to manually emit the signal.
