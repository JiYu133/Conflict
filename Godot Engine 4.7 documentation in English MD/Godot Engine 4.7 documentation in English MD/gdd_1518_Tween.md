# Tween

Inherits: RefCounted < Object

Lightweight object used for general-purpose animation via script, using Tweeners.

## Description

Tweens are mostly useful for animations requiring a numerical property to be interpolated over a range of values. The name tween comes from in-betweening, an animation technique where you specify keyframes and the computer interpolates the frames that appear between them. Animating something with a Tween is called tweening.

Tween is more suited than AnimationPlayer for animations where you don't know the final values in advance. For example, interpolating a dynamically-chosen camera zoom value is best done with a Tween; it would be difficult to do the same thing with an AnimationPlayer node. Tweens are also more light-weight than AnimationPlayer, so they are very much suited for simple animations or general tasks that don't require visual tweaking provided by the editor. They can be used in a "fire-and-forget" manner for some logic that normally would be done by code. You can e.g. make something shoot periodically by using a looped CallbackTweener with a delay.

A Tween can be created by using either SceneTree.create_tween() or Node.create_tween(). Tweens created manually (i.e. by using Tween.new()) are invalid and can't be used for tweening values.

A tween animation is created by adding Tweeners to the Tween object, using tween_property(), tween_interval(), tween_callback(), tween_method(), tween_subtween(), or tween_await():

```
var tween = get_tree().create_tween()
tween.tween_property($Sprite, "modulate", Color.RED, 1.0)
tween.tween_property($Sprite, "scale", Vector2(), 1.0)
tween.tween_callback($Sprite.queue_free)
```

```
Tween tween = GetTree().CreateTween();
tween.TweenProperty(GetNode("Sprite"), "modulate", Colors.Red, 1.0f);
tween.TweenProperty(GetNode("Sprite"), "scale", Vector2.Zero, 1.0f);
tween.TweenCallback(Callable.From(GetNode("Sprite").QueueFree));
```

This sequence will make the $Sprite node turn red, then shrink, before finally calling Node.queue_free() to free the sprite. Tweeners are executed one after another by default. This behavior can be changed using parallel() and set_parallel().

When a Tweener is created with one of the tween_* methods, a chained method call can be used to tweak the properties of this Tweener. For example, if you want to set a different transition type in the above example, you can use set_trans():

```
var tween = get_tree().create_tween()
tween.tween_property($Sprite, "modulate", Color.RED, 1.0).set_trans(Tween.TRANS_SINE)
tween.tween_property($Sprite, "scale", Vector2(), 1.0).set_trans(Tween.TRANS_BOUNCE)
tween.tween_callback($Sprite.queue_free)
```

```
Tween tween = GetTree().CreateTween();
tween.TweenProperty(GetNode("Sprite"), "modulate", Colors.Red, 1.0f).SetTrans(Tween.TransitionType.Sine);
tween.TweenProperty(GetNode("Sprite"), "scale", Vector2.Zero, 1.0f).SetTrans(Tween.TransitionType.Bounce);
tween.TweenCallback(Callable.From(GetNode("Sprite").QueueFree));
```

Most of the Tween methods can be chained this way too. In the following example the Tween is bound to the running script's node and a default transition is set for its Tweeners:

```
var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
tween.tween_property($Sprite, "modulate", Color.RED, 1.0)
tween.tween_property($Sprite, "scale", Vector2(), 1.0)
tween.tween_callback($Sprite.queue_free)
```

```
var tween = GetTree().CreateTween().BindNode(this).SetTrans(Tween.TransitionType.Elastic);
tween.TweenProperty(GetNode("Sprite"), "modulate", Colors.Red, 1.0f);
tween.TweenProperty(GetNode("Sprite"), "scale", Vector2.Zero, 1.0f);
tween.TweenCallback(Callable.From(GetNode("Sprite").QueueFree));
```

Another interesting use for Tweens is animating arbitrary sets of objects:

```
var tween = create_tween()
for sprite in get_children():
    tween.tween_property(sprite, "position", Vector2(0, 0), 1.0)
```

```
Tween tween = CreateTween();
foreach (Node sprite in GetChildren())
    tween.TweenProperty(sprite, "position", Vector2.Zero, 1.0f);
```

In the example above, all children of a node are moved one after another to position (0, 0).

You should avoid using more than one Tween per object's property. If two or more tweens animate one property at the same time, the last one created will take priority and assign the final value. If you want to interrupt and restart an animation, consider assigning the Tween to a variable:

```
var tween
func animate():
    if tween:
        tween.kill() # Abort the previous animation.
    tween = create_tween()
```

```
private Tween _tween;
public void Animate()
{
    if (_tween != null)
        _tween.Kill(); // Abort the previous animation
    _tween = CreateTween();
}
```

Some Tweeners use transitions and eases. The first accepts a TransitionType constant, and refers to the way the timing of the animation is handled (see easings.net [https://easings.net/] for some examples). The second accepts an EaseType constant, and controls where the trans_type is applied to the interpolation (in the beginning, the end, or both). If you don't know which transition and easing to pick, you can try different TransitionType constants with EASE_IN_OUT, and use the one that looks best.

Tween easing and transition types cheatsheet [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/tween_cheatsheet.webp]

Note: Tweens are not designed to be reused and trying to do so results in an undefined behavior. Create a new Tween for each animation and every time you replay an animation from start. Keep in mind that Tweens start immediately, so only create a Tween when you want to start animating.

Note: The tween is processed after all of the nodes in the current frame, i.e. node's Node._process() method would be called before the tween (or Node._physics_process() depending on the value passed to set_process_mode()).

## Methods

Tween | bind_node(node: Node)
Tween | chain()
bool | custom_step(delta: float)
int | get_loops_left() const
float | get_total_elapsed_time() const
bool | has_tweeners() const
Variant | interpolate_value(initial_value: Variant, delta_value: Variant, elapsed_time: float, duration: float, trans_type: TransitionType, ease_type: EaseType) static
bool | is_running()
bool | is_valid()
void | kill()
Tween | parallel()
void | pause()
void | play()
Tween | set_ease(ease: EaseType)
Tween | set_ignore_time_scale(ignore: bool = true)
Tween | set_loops(loops: int = 0)
Tween | set_parallel(parallel: bool = true)
Tween | set_pause_mode(mode: TweenPauseMode)
Tween | set_process_mode(mode: TweenProcessMode)
Tween | set_speed_scale(speed: float)
Tween | set_trans(trans: TransitionType)
void | stop()
AwaitTweener | tween_await(signal: Signal)
CallbackTweener | tween_callback(callback: Callable)
IntervalTweener | tween_interval(time: float)
MethodTweener | tween_method(method: Callable, from: Variant, to: Variant, duration: float)
PropertyTweener | tween_property(object: Object, property: NodePath, final_val: Variant, duration: float)
SubtweenTweener | tween_subtween(subtween: Tween)

---

## Signals

finished() 

Emitted when the Tween has finished all tweening. Never emitted when the Tween is set to infinite looping (see set_loops()).

---

loop_finished(loop_count: int) 

Emitted when a full loop is complete (see set_loops()), providing the loop index. This signal is not emitted after the final loop, use finished instead for this case.

---

step_finished(idx: int) 

Emitted when one step of the Tween is complete, providing the step index. One step is either a single Tweener or a group of Tweeners running in parallel.

---

## Enumerations

enum TweenProcessMode
TweenProcessMode TWEEN_PROCESS_PHYSICS = 0

The Tween updates after each physics frame (see Node._physics_process()).

TweenProcessMode TWEEN_PROCESS_IDLE = 1

The Tween updates after each process frame (see Node._process()).

---

enum TweenPauseMode
TweenPauseMode TWEEN_PAUSE_BOUND = 0

If the Tween has a bound node, it will process when that node can process (see Node.process_mode). Otherwise it's the same as TWEEN_PAUSE_STOP.

TweenPauseMode TWEEN_PAUSE_STOP = 1

If SceneTree is paused, the Tween will also pause.

TweenPauseMode TWEEN_PAUSE_PROCESS = 2

The Tween will process regardless of whether SceneTree is paused.

---

enum TransitionType
TransitionType TRANS_LINEAR = 0

The animation is interpolated linearly.

TransitionType TRANS_SINE = 1

The animation is interpolated using a sine function.

TransitionType TRANS_QUINT = 2

The animation is interpolated with a quintic (to the power of 5) function.

TransitionType TRANS_QUART = 3

The animation is interpolated with a quartic (to the power of 4) function.

TransitionType TRANS_QUAD = 4

The animation is interpolated with a quadratic (to the power of 2) function.

TransitionType TRANS_EXPO = 5

The animation is interpolated with an exponential (to the power of x) function.

TransitionType TRANS_ELASTIC = 6

The animation is interpolated with elasticity, wiggling around the edges.

TransitionType TRANS_CUBIC = 7

The animation is interpolated with a cubic (to the power of 3) function.

TransitionType TRANS_CIRC = 8

The animation is interpolated with a function using square roots.

TransitionType TRANS_BOUNCE = 9

The animation is interpolated by bouncing at the end.

TransitionType TRANS_BACK = 10

The animation is interpolated backing out at ends.

TransitionType TRANS_SPRING = 11

The animation is interpolated like a spring towards the end.

---

enum EaseType
EaseType EASE_IN = 0

The interpolation starts slowly and speeds up towards the end.

EaseType EASE_OUT = 1

The interpolation starts quickly and slows down towards the end.

EaseType EASE_IN_OUT = 2

A combination of EASE_IN and EASE_OUT. The interpolation is slowest at both ends.

EaseType EASE_OUT_IN = 3

A combination of EASE_IN and EASE_OUT. The interpolation is fastest at both ends.

---

## Method Descriptions

Tween bind_node(node: Node) 

Binds this Tween with the given node. Tweens are processed directly by the SceneTree, so they run independently of the animated nodes. When you bind a Node with the Tween, the Tween will halt the animation when the object is not inside tree and the Tween will be automatically killed when the bound object is freed. Also TWEEN_PAUSE_BOUND will make the pausing behavior dependent on the bound node.

For a shorter way to create and bind a Tween, you can use Node.create_tween().

---

Tween chain() 

Used to chain two Tweeners after set_parallel() is called with true.

```
var tween = create_tween().set_parallel(true)
tween.tween_property(...)
tween.tween_property(...) # Will run parallelly with above.
tween.chain().tween_property(...) # Will run after two above are finished.
```

```
Tween tween = CreateTween().SetParallel(true);
tween.TweenProperty(...);
tween.TweenProperty(...); // Will run parallelly with above.
tween.Chain().TweenProperty(...); // Will run after two above are finished.
```

---

bool custom_step(delta: float) 

Processes the Tween by the given delta value, in seconds. This is mostly useful for manual control when the Tween is paused. It can also be used to end the Tween animation immediately, by setting delta longer than the whole duration of the Tween animation.

Returns true if the Tween still has Tweeners that haven't finished.

---

int get_loops_left() const 

Returns the number of remaining loops for this Tween (see set_loops()). A return value of -1 indicates an infinitely looping Tween, and a return value of 0 indicates that the Tween has already finished.

---

float get_total_elapsed_time() const 

Returns the total time in seconds the Tween has been animating (i.e. the time since it started, not counting pauses etc.). The time is affected by set_speed_scale(), and stop() will reset it to 0.

Note: As it results from accumulating frame deltas, the time returned after the Tween has finished animating will be slightly greater than the actual Tween duration.

---

bool has_tweeners() const 

Returns true if any Tweener has been added to the Tween and the Tween is valid. Useful when tweeners are added dynamically and the tween can end up empty. Killing an empty tween before it starts will prevent errors.

---

Variant interpolate_value(initial_value: Variant, delta_value: Variant, elapsed_time: float, duration: float, trans_type: TransitionType, ease_type: EaseType) static 

This method can be used for manual interpolation of a value, when you don't want Tween to do animating for you. It's similar to @GlobalScope.lerp(), but with support for custom transition and easing.

initial_value is the starting value of the interpolation.

delta_value is the change of the value in the interpolation, i.e. it's equal to final_value - initial_value.

elapsed_time is the time in seconds that passed after the interpolation started and it's used to control the position of the interpolation. E.g. when it's equal to half of the duration, the interpolated value will be halfway between initial and final values. This value can also be greater than duration or lower than 0, which will extrapolate the value.

duration is the total time of the interpolation.

Note: If duration is equal to 0, the method will always return the final value, regardless of elapsed_time provided.

---

bool is_running() 

Returns whether the Tween is currently running, i.e. it wasn't paused and it's not finished.

---

bool is_valid() 

Returns whether the Tween is valid. A valid Tween is a Tween contained by the scene tree (i.e. the array from SceneTree.get_processed_tweens() will contain this Tween). A Tween might become invalid when it has finished tweening, is killed, or when created with Tween.new(). Invalid Tweens can't have Tweeners appended.

---

void kill() 

Aborts all tweening operations and invalidates the Tween.

---

Tween parallel() 

Makes the next Tweener run parallelly to the previous one.

```
var tween = create_tween()
tween.tween_property(...)
tween.parallel().tween_property(...)
tween.parallel().tween_property(...)
```

```
Tween tween = CreateTween();
tween.TweenProperty(...);
tween.Parallel().TweenProperty(...);
tween.Parallel().TweenProperty(...);
```

All Tweeners in the example will run at the same time.

You can make the Tween parallel by default by using set_parallel().

---

void pause() 

Pauses the tweening. The animation can be resumed by using play().

Note: If a Tween is paused and not bound to any node, it will exist indefinitely until manually started or invalidated. If you lose a reference to such Tween, you can retrieve it using SceneTree.get_processed_tweens().

---

void play() 

Resumes a paused or stopped Tween.

---

Tween set_ease(ease: EaseType) 

Sets the default ease type for PropertyTweeners and MethodTweeners appended after this method.

Before this method is called, the default ease type is EASE_IN_OUT.

```
var tween = create_tween()
tween.tween_property(self, "position", Vector2(300, 0), 0.5) # Uses EASE_IN_OUT.
tween.set_ease(Tween.EASE_IN)
tween.tween_property(self, "rotation_degrees", 45.0, 0.5) # Uses EASE_IN.
```

```
Tween tween = CreateTween();
tween.TweenProperty(this, "position", new Vector2(300, 0), 0.5); // Uses EaseType.InOut.
tween.SetEase(Tween.EaseType.In);
tween.TweenProperty(this, "rotation_degrees", 45.0, 0.5); // Uses EaseType.In.
```

---

Tween set_ignore_time_scale(ignore: bool = true) 

If ignore is true, the tween will ignore Engine.time_scale and update with the real, elapsed time. This affects all Tweeners and their delays. Default value is false.

---

Tween set_loops(loops: int = 0) 

Sets the number of times the tweening sequence will be repeated, i.e. set_loops(2) will run the animation twice.

Calling this method without arguments will make the Tween run infinitely, until either it is killed with kill(), the Tween's bound node is freed, or all the animated objects have been freed (which makes further animation impossible).

Warning: Make sure to always add some duration/delay when using infinite loops. To prevent the game freezing, 0-duration looped animations (e.g. a single CallbackTweener with no delay) are stopped after a small number of loops, which may produce unexpected results. If a Tween's lifetime depends on some node, always use bind_node().

---

Tween set_parallel(parallel: bool = true) 

If parallel is true, the Tweeners appended after this method will by default run simultaneously, as opposed to sequentially.

Note: Just like with parallel(), the tweener added right before this method will also be part of the parallel step.

```gdscript
tween.tween_property(self, "position", Vector2(300, 0), 0.5)
tween.set_parallel()
tween.tween_property(self, "modulate", Color.GREEN, 0.5) # Runs together with the position tweener.
```

---

Tween set_pause_mode(mode: TweenPauseMode) 

Determines the behavior of the Tween when the SceneTree is paused.

Default value is TWEEN_PAUSE_BOUND.

---

Tween set_process_mode(mode: TweenProcessMode) 

Determines whether the Tween should run after process frames (see Node._process()) or physics frames (see Node._physics_process()).

Default value is TWEEN_PROCESS_IDLE.

---

Tween set_speed_scale(speed: float) 

Scales the speed of tweening. This affects all Tweeners and their delays.

---

Tween set_trans(trans: TransitionType) 

Sets the default transition type for PropertyTweeners and MethodTweeners appended after this method.

Before this method is called, the default transition type is TRANS_LINEAR.

```gdscript
var tween = create_tween()
tween.tween_property(self, "position", Vector2(300, 0), 0.5) # Uses TRANS_LINEAR.
tween.set_trans(Tween.TRANS_SINE)
tween.tween_property(self, "rotation_degrees", 45.0, 0.5) # Uses TRANS_SINE.
```

---

void stop() 

Stops the tweening and resets the Tween to its initial state. This will not remove any appended Tweeners.

Note: This does not reset targets of PropertyTweeners to their values when the Tween first started.

```gdscript
var tween = create_tween()
# Will move from 0 to 500 over 1 second.
position.x = 0.0
tween.tween_property(self, "position:x", 500, 1.0)
# Will be at (about) 250 when the timer finishes.
await get_tree().create_timer(0.5).timeout
# Will now move from (about) 250 to 500 over 1 second,
# thus at half the speed as before.
tween.stop()
tween.play()
```

Note: If a Tween is stopped and not bound to any node, it will exist indefinitely until manually started or invalidated. If you lose a reference to such Tween, you can retrieve it using SceneTree.get_processed_tweens().

---

AwaitTweener tween_await(signal: Signal) 

Creates and appends an AwaitTweener. This method can be used to await a signal to be emitted and create asynchronous animations or cutscenes.

The animation will not progress to the next step until the awaited signal is emitted or the connection becomes invalid (e.g. as a result of freeing the target object). If you know that the emission may not happen, use AwaitTweener.set_timeout().

Note: The awaited signal should be emitted during the step when AwaitTweener is active.

Example: An object launches itself and explodes upon collision or after 4 seconds.

```gdscript
var tween = create_tween()
tween.tween_callback(launch)
tween.tween_await(collided).set_timeout(4.0)
tween.tween_callback(explode)
```

Example: A character walks to a specific point, says some lines and walks back when the player closes the message box.

```gdscript
var tween = create_tween()
tween.tween_callback(walk_to.bind(600.0))
tween.tween_await(destination_reached)
tween.tween_callback(say_dialogue.bind("Good day, sir!"))
tween.tween_await(dialogue_closed)
tween.tween_callback(walk_to.bind(0.0))
```

Note: If you are awaiting a signal from a callback called in the same Tween, make sure the signal is emitted after the await starts. If it can't be reasonably guaranteed, you can await and emit in the same step:

```gdscript
var tween = create_tween()
tween.tween_await(signal)
tween.parallel().tween_callback(method_that_emits_signal)
```

---

CallbackTweener tween_callback(callback: Callable) 

Creates and appends a CallbackTweener. This method can be used to call an arbitrary method in any object. Use Callable.bind() to bind additional arguments for the call.

Example: Object that keeps shooting every 1 second:

```
var tween = get_tree().create_tween().set_loops()
tween.tween_callback(shoot).set_delay(1.0)
```

```
Tween tween = GetTree().CreateTween().SetLoops();
tween.TweenCallback(Callable.From(Shoot)).SetDelay(1.0f);
```

Example: Turning a sprite red and then blue, with 2 second delay:

```
var tween = get_tree().create_tween()
tween.tween_callback($Sprite.set_modulate.bind(Color.RED)).set_delay(2)
tween.tween_callback($Sprite.set_modulate.bind(Color.BLUE)).set_delay(2)
```

```
Tween tween = GetTree().CreateTween();
Sprite2D sprite = GetNode("Sprite");
tween.TweenCallback(Callable.From(() => sprite.Modulate = Colors.Red)).SetDelay(2.0f);
tween.TweenCallback(Callable.From(() => sprite.Modulate = Colors.Blue)).SetDelay(2.0f);
```

---

IntervalTweener tween_interval(time: float) 

Creates and appends an IntervalTweener. This method can be used to create delays in the tween animation, as an alternative to using the delay in other Tweeners, or when there's no animation (in which case the Tween acts as a timer). time is the length of the interval, in seconds.

Example: Creating an interval in code execution:

```
# ... some code
await create_tween().tween_interval(2).finished
# ... more code
```

```
// ... some code
await ToSignal(CreateTween().TweenInterval(2.0f), Tween.SignalName.Finished);
// ... more code
```

Example: Creating an object that moves back and forth and jumps every few seconds:

```
var tween = create_tween().set_loops()
tween.tween_property($Sprite, "position:x", 200.0, 1.0).as_relative()
tween.tween_callback(jump)
tween.tween_interval(2)
tween.tween_property($Sprite, "position:x", -200.0, 1.0).as_relative()
tween.tween_callback(jump)
tween.tween_interval(2)
```

```
Tween tween = CreateTween().SetLoops();
tween.TweenProperty(GetNode("Sprite"), "position:x", 200.0f, 1.0f).AsRelative();
tween.TweenCallback(Callable.From(Jump));
tween.TweenInterval(2.0f);
tween.TweenProperty(GetNode("Sprite"), "position:x", -200.0f, 1.0f).AsRelative();
tween.TweenCallback(Callable.From(Jump));
tween.TweenInterval(2.0f);
```

---

MethodTweener tween_method(method: Callable, from: Variant, to: Variant, duration: float) 

Creates and appends a MethodTweener. This method is similar to a combination of tween_callback() and tween_property(). It calls a method over time with a tweened value provided as an argument. The value is tweened between from and to over the time specified by duration, in seconds. Use Callable.bind() to bind additional arguments for the call. You can use MethodTweener.set_ease() and MethodTweener.set_trans() to tweak the easing and transition of the value or MethodTweener.set_delay() to delay the tweening.

Example: Making a 3D object look from one point to another point:

```
var tween = create_tween()
tween.tween_method(look_at.bind(Vector3.UP), Vector3(-1, 0, -1), Vector3(1, 0, -1), 1.0) # The look_at() method takes up vector as second argument.
```

```
Tween tween = CreateTween();
tween.TweenMethod(Callable.From((Vector3 target) => LookAt(target, Vector3.Up)), new Vector3(-1.0f, 0.0f, -1.0f), new Vector3(1.0f, 0.0f, -1.0f), 1.0f); // Use lambdas to bind additional arguments for the call.
```

Example: Setting the text of a Label, using an intermediate method and after a delay:

```
func _ready():
    var tween = create_tween()
    tween.tween_method(set_label_text, 0, 10, 1.0).set_delay(1.0)
func set_label_text(value: int):
    $Label.text = "Counting " + str(value)
```

```
public override void _Ready()
{
    base._Ready();
    Tween tween = CreateTween();
    tween.TweenMethod(Callable.From(SetLabelText), 0.0f, 10.0f, 1.0f).SetDelay(1.0f);
}
private void SetLabelText(int value)
{
    GetNode("Label").Text = $"Counting {value}";
}
```

---

PropertyTweener tween_property(object: Object, property: NodePath, final_val: Variant, duration: float) 

Creates and appends a PropertyTweener. This method tweens a property of an object between an initial value and final_val in a span of time equal to duration, in seconds. The initial value by default is the property's value at the time the tweening of the PropertyTweener starts.

```
var tween = create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 200), 1.0)
tween.tween_property($Sprite, "position", Vector2(200, 300), 1.0)
```

```
Tween tween = CreateTween();
tween.TweenProperty(GetNode("Sprite"), "position", new Vector2(100.0f, 200.0f), 1.0f);
tween.TweenProperty(GetNode("Sprite"), "position", new Vector2(200.0f, 300.0f), 1.0f);
```

will move the sprite to position (100, 200) and then to (200, 300). If you use PropertyTweener.from() or PropertyTweener.from_current(), the starting position will be overwritten by the given value instead. See other methods in PropertyTweener to see how the tweening can be tweaked further.

Note: You can find the correct property name by hovering over the property in the Inspector. You can also provide the components of a property directly by using "property:component" (eg. position:x), where it would only apply to that particular component.

Example: Moving an object twice from the same position, with different transition types:

```
var tween = create_tween()
tween.tween_property($Sprite, "position", Vector2.RIGHT * 300, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
tween.tween_property($Sprite, "position", Vector2.RIGHT * 300, 1.0).as_relative().from_current().set_trans(Tween.TRANS_EXPO)
```

```
Tween tween = CreateTween();
tween.TweenProperty(GetNode("Sprite"), "position", Vector2.Right * 300.0f, 1.0f).AsRelative().SetTrans(Tween.TransitionType.Sine);
tween.TweenProperty(GetNode("Sprite"), "position", Vector2.Right * 300.0f, 1.0f).AsRelative().FromCurrent().SetTrans(Tween.TransitionType.Expo);
```

---

SubtweenTweener tween_subtween(subtween: Tween) 

Creates and appends a SubtweenTweener. This method can be used to nest subtween within this Tween, allowing for the creation of more complex and composable sequences.

```gdscript
# Subtween will rotate the object.
var subtween = create_tween()
subtween.tween_property(self, "rotation_degrees", 45.0, 1.0)
subtween.tween_property(self, "rotation_degrees", 0.0, 1.0)
# Parent tween will execute the subtween as one of its steps.
var tween = create_tween()
tween.tween_property(self, "position:x", 500, 3.0)
tween.tween_subtween(subtween)
tween.tween_property(self, "position:x", 300, 2.0)
```

Note: The methods pause(), stop(), and set_loops() can cause the parent Tween to get stuck on the subtween step; see the documentation for those methods for more information.

Note: The pause and process modes set by set_pause_mode() and set_process_mode() on subtween will be overridden by the parent Tween's settings.
