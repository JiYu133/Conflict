# Godot notifications

Every Object in Godot implements a
_notification method. Its purpose is to
allow the Object to respond to a variety of engine-level callbacks that may
relate to it. For example, if the engine tells a
CanvasItem to "draw", it will call
_notification(NOTIFICATION_DRAW).

Some of these notifications, like draw, are useful to override in scripts. So
much so that Godot exposes many of them with dedicated functions:

- _ready(): NOTIFICATION_READY
- _enter_tree(): NOTIFICATION_ENTER_TREE
- _exit_tree(): NOTIFICATION_EXIT_TREE
- _process(delta): NOTIFICATION_PROCESS
- _physics_process(delta): NOTIFICATION_PHYSICS_PROCESS
- _draw(): NOTIFICATION_DRAW

What users might not realize is that notifications exist for types other
than Node alone, for example:

- Object::NOTIFICATION_POSTINITIALIZE:
a callback that triggers during object initialization. Not accessible to scripts.
- Object::NOTIFICATION_PREDELETE:
a callback that triggers before the engine deletes an Object, i.e. a
"destructor".

And many of the callbacks that do exist in Nodes don't have any dedicated
methods, but are still quite useful.

- Node::NOTIFICATION_PARENTED:
a callback that triggers anytime you add a child node to another node.
- Node::NOTIFICATION_UNPARENTED:
a callback that triggers anytime you remove a child node from another
node.

The universal _notification() method provides access to all these custom
notifications.

Note

Methods in the documentation labeled as "virtual" are also intended to be
overridden by scripts.

A classic example is the
_init method in Object. While it has no
NOTIFICATION_* equivalent, the engine still calls the method. Most languages
(except C#) rely on it as a constructor.

So, when should you use each of these notifications or
virtual functions?

## _process vs. _physics_process vs. *_input

Use _process() when you need a framerate-dependent delta time between
frames. If code that updates object data needs to update as often as
possible, this is the right place. Recurring logic checks and data caching
often execute here, but it comes down to how often
the evaluations need to update. If they don't need to execute every frame, then
implementing a Timer-timeout loop is another option.

```
# Allows for recurring operations that don't trigger script logic
# every frame (or even every fixed frame).
func _ready():
    var timer = Timer.new()
    timer.autostart = true
    timer.wait_time = 0.5
    add_child(timer)
    timer.timeout.connect(func():
        print("This block runs every 0.5 seconds")
    )
```

```
using Godot;
public partial class MyNode : Node
{
    // Allows for recurring operations that don't trigger script logic
    // every frame (or even every fixed frame).
    public override void _Ready()
    {
        var timer = new Timer();
        timer.Autostart = true;
        timer.WaitTime = 0.5;
        AddChild(timer);
        timer.Timeout += () => GD.Print("This block runs every 0.5 seconds");
    }
}
```

```
using namespace godot;
class MyNode : public Node {
    GDCLASS(MyNode, Node)
public:
    // Allows for recurring operations that don't trigger script logic
    // every frame (or even every fixed frame).
    virtual void _ready() override {
        Timer *timer = memnew(Timer);
        timer->set_autostart(true);
        timer->set_wait_time(0.5);
        add_child(timer);
        timer->connect("timeout", callable_mp(this, &MyNode::run));
    }
    void run() {
        UtilityFunctions::print("This block runs every 0.5 seconds.");
    }
};
```

Use _physics_process() when you need a framerate-independent delta time
between frames. If code needs consistent updates over time, regardless
of how fast or slow time advances, this is the right place.
Recurring kinematic and object transform operations should execute here.

While it is possible, to achieve the best performance, you should avoid
making input checks during these callbacks. _process() and
_physics_process() will trigger at every opportunity (they do not "rest" by
default). In contrast, *_input() callbacks will trigger only on frames in
which the engine has actually detected the input.

You can check for input actions within the input callbacks just the same.
If you want to use delta time, you can fetch it from the related
delta time methods as needed.

```
# Called every frame, even when the engine detects no input.
func _process(delta):
    if Input.is_action_just_pressed("ui_select"):
        print(delta)
# Called during every input event.
func _unhandled_input(event):
    match event.get_class():
        "InputEventKey":
            if Input.is_action_just_pressed("ui_accept"):
                print(get_process_delta_time())
```

```
using Godot;
public partial class MyNode : Node
{
    // Called every frame, even when the engine detects no input.
    public void _Process(double delta)
    {
        if (Input.IsActionJustPressed("ui_select"))
        {
            GD.Print(delta);
        }
    }
    // Called during every input event. Equally true for _input().
    public void _UnhandledInput(InputEvent @event)
    {
        switch (@event)
        {
            case InputEventKey:
                if (Input.IsActionJustPressed("ui_accept"))
                {
                    GD.Print(GetProcessDeltaTime());
                }
                break;
        }
    }
}
```

```
using namespace godot;
class MyNode : public Node {
    GDCLASS(MyNode, Node)
public:
    // Called every frame, even when the engine detects no input.
    virtual void _process(double p_delta) override {
        if (Input::get_singleton->is_action_just_pressed("ui_select")) {
            UtilityFunctions::print(p_delta);
        }
    }
    // Called during every input event. Equally true for _input().
    virtual void _unhandled_input(const Ref &p_event) override {
        Ref key_event = event;
        if (key_event.is_valid() && Input::get_singleton->is_action_just_pressed("ui_accept")) {
            UtilityFunctions::print(get_process_delta_time());
        }
    }
};
```

## _init vs. initialization vs. export

If the script initializes its own node subtree, without a scene,
that code should execute in _init(). Other property or SceneTree-independent
initializations should also run here.

Note

The C# equivalent to GDScript's _init() method is the constructor.

_init() triggers before _enter_tree() or _ready(), but after a script
creates and initializes its properties. When instantiating a scene, property
values will set up according to the following sequence:

1. Initial value assignment: the property is assigned its initialization value,
or its default value if one is not specified. If a setter exists, it is not used.
2. _init() assignment: the property's value is replaced by any assignments
made in _init(), triggering the setter.
3. Exported value assignment: an exported property's value is again replaced by
any value set in the Inspector, triggering the setter.

```
# test is initialized to "one", without triggering the setter.
@export var test: String = "one":
    set(value):
        test = value + "!"
func _init():
    # Triggers the setter, changing test's value from "one" to "two!".
    test = "two"
# If you set test to "three" from the Inspector, it would trigger
# the setter, changing test's value from "two!" to "three!".
```

```
using Godot;
public partial class MyNode : Node
{
    private string _test = "one";
    [Export]
    public string Test
    {
        get { return _test; }
        set { _test = $"{value}!"; }
    }
    public MyNode()
    {
        // Triggers the setter, changing _test's value from "one" to "two!".
        Test = "two";
    }
    // If you set Test to "three" in the Inspector, it would trigger
    // the setter, changing _test's value from "two!" to "three!".
}
```

```
using namespace godot;
class MyNode : public Node {
    GDCLASS(MyNode, Node)
    String test = "one";
protected:
    static void _bind_methods() {
        ClassDB::bind_method(D_METHOD("get_test"), &MyNode::get_test);
        ClassDB::bind_method(D_METHOD("set_test", "test"), &MyNode::set_test);
        ADD_PROPERTY(PropertyInfo(Variant::STRING, "test"), "set_test", "get_test");
    }
public:
    String get_test() { return test; }
    void set_test(String p_test) { test = p_test + "!"; }
    MyNode() {
        // Triggers the setter, changing _test's value from "one" to "two!".
        set_test("two");
    }
    // If you set test to "three" in the Inspector, it would trigger
    // the setter, changing test's value from "two!" to "three!".
};
```

As a result, instantiating a script versus a scene may affect both the
initialization and the number of times the engine calls the setter.

## _ready vs. _enter_tree vs. NOTIFICATION_PARENTED

When instantiating a scene connected to the first executed scene, Godot will
instantiate nodes down the tree (making _init() calls) and build the tree
going downwards from the root. This causes _enter_tree() calls to cascade
down the tree. Once the tree is complete, leaf nodes call _ready. A node
will call this method once all child nodes have finished calling theirs. This
then causes a reverse cascade going up back to the tree's root.

When instantiating a script or a standalone scene, nodes are not
added to the SceneTree upon creation, so no _enter_tree() callbacks
trigger. Instead, only the _init() call occurs. When the scene is added
to the SceneTree, the _enter_tree() and _ready() calls occur.

If you need to trigger behavior that occurs as nodes parent to another,
regardless of whether it occurs as part of the main/active scene or not, you
can use the PARENTED notification.
For example, here is a snippet that connects a node's method to
a custom signal on the parent node without failing. Useful on data-centric
nodes potentially created at runtime.

```
extends Node
var parent_cache
func connection_check():
    return parent_cache.has_user_signal("interacted_with")
func _notification(what):
    match what:
        NOTIFICATION_PARENTED:
            parent_cache = get_parent()
            if connection_check():
                parent_cache.interacted_with.connect(_on_parent_interacted_with)
        NOTIFICATION_UNPARENTED:
            if connection_check():
                parent_cache.interacted_with.disconnect(_on_parent_interacted_with)
func _on_parent_interacted_with():
    print("I'm reacting to my parent's interaction!")
```

```
using Godot;
public partial class MyNode : Node
{
    private Node _parentCache;
    public bool ConnectionCheck()
    {
        return _parentCache.HasUserSignal("InteractedWith");
    }
    public override void _Notification(int what)
    {
        switch ((long)what)
        {
            case NotificationParented:
                _parentCache = GetParent();
                if (ConnectionCheck())
                {
                    _parentCache.Connect("InteractedWith", Callable.From(OnParentInteractedWith));
                }
                break;
            case NotificationUnparented:
                if (ConnectionCheck())
                {
                    _parentCache.Disconnect("InteractedWith", Callable.From(OnParentInteractedWith));
                }
                break;
        }
    }
    private void OnParentInteractedWith()
    {
        GD.Print("I'm reacting to my parent's interaction!");
    }
}
```

```
using namespace godot;
class MyNode : public Node {
    GDCLASS(MyNode, Node)
    Node *parent_cache = nullptr;
    void on_parent_interacted_with() {
        UtilityFunctions::print("I'm reacting to my parent's interaction!");
    }
public:
    void connection_check() {
        return parent_cache->has_user_signal("interacted_with");
    }
    void _notification(int p_what) {
        switch (p_what) {
            case NOTIFICATION_PARENTED:
                parent_cache = get_parent();
                if (connection_check()) {
                    parent_cache->connect("interacted_with", callable_mp(this, &MyNode::on_parent_interacted_with));
                }
                break;
            case NOTIFICATION_UNPARENTED:
                if (connection_check()) {
                    parent_cache->disconnect("interacted_with", callable_mp(this, &MyNode::on_parent_interacted_with));
                }
                break;
        }
    }
};
```
