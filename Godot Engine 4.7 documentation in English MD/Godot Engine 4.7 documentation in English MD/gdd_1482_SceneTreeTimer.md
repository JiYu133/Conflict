# SceneTreeTimer

Inherits: RefCounted < Object

One-shot timer.

## Description

A one-shot timer managed by the scene tree, which emits timeout on completion. See also SceneTree.create_timer().

As opposed to Timer, it does not require the instantiation of a node. Commonly used to create a one-shot delay timer as in the following example:

```
func some_function():
    print("Timer started.")
    await get_tree().create_timer(1.0).timeout
    print("Timer ended.")
```

```
public async Task SomeFunction()
{
    GD.Print("Timer started.");
    await ToSignal(GetTree().CreateTimer(1.0f), SceneTreeTimer.SignalName.Timeout);
    GD.Print("Timer ended.");
}
```

The timer will be dereferenced after its time elapses. To preserve the timer, you can keep a reference to it. See RefCounted.

Note: The timer is processed after all of the nodes in the current frame, i.e. node's Node._process() method would be called before the timer (or Node._physics_process() if process_in_physics in SceneTree.create_timer() has been set to true).

## Properties

float | time_left

---

## Signals

timeout() 

Emitted when the timer reaches 0.

---

## Property Descriptions

float time_left 

- void set_time_left(value: float)
- float get_time_left()

The time remaining (in seconds).
