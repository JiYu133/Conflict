# Signal

A built-in type representing a signal of an Object.

## Description

Signal is a built-in Variant type that represents a signal of an Object instance. Like all Variant types, it can be stored in variables and passed to functions. Signals allow all connected Callables (and by extension their respective objects) to listen and react to events, without directly referencing one another. This keeps the code flexible and easier to manage. You can check whether an Object has a given signal name using Object.has_signal().

In GDScript, signals can be declared with the signal keyword. In C#, you may use the [Signal] attribute on a delegate.

```
signal attacked
# Additional arguments may be declared.
# These arguments must be passed when the signal is emitted.
signal item_dropped(item_name, amount)
```

```
[Signal]
delegate void AttackedEventHandler();
// Additional arguments may be declared.
// These arguments must be passed when the signal is emitted.
[Signal]
delegate void ItemDroppedEventHandler(string itemName, int amount);
```

Connecting signals is one of the most common operations in Godot and the API gives many options to do so, which are described further down. The code block below shows the recommended approach.

```
func _ready():
    var button = Button.new()
    # `button_down` here is a Signal Variant type. We therefore call the Signal.connect() method, not Object.connect().
    # See discussion below for a more in-depth overview of the API.
    button.button_down.connect(_on_button_down)
    # This assumes that a `Player` class exists, which defines a `hit` signal.
    var player = Player.new()
    # We use Signal.connect() again, and we also use the Callable.bind() method,
    # which returns a new Callable with the parameter binds.
    player.hit.connect(_on_player_hit.bind("sword", 100))
func _on_button_down():
    print("Button down!")
func _on_player_hit(weapon_type, damage):
    print("Hit with weapon %s for %d damage." % [weapon_type, damage])
```

```
public override void _Ready()
{
    var button = new Button();
    // C# supports passing signals as events, so we can use this idiomatic construct:
    button.ButtonDown += OnButtonDown;
    // This assumes that a `Player` class exists, which defines a `Hit` signal.
    var player = new Player();
    // We can use lambdas when we need to bind additional parameters.
    player.Hit += () => OnPlayerHit("sword", 100);
}
private void OnButtonDown()
{
    GD.Print("Button down!");
}
private void OnPlayerHit(string weaponType, int damage)
{
    GD.Print($"Hit with weapon {weaponType} for {damage} damage.");
}
```

Object.connect() or Signal.connect()?

As seen above, the recommended method to connect signals is not Object.connect(). The code block below shows the four options for connecting signals, using either this legacy method or the recommended connect(), and using either an implicit Callable or a manually defined one.

```
func _ready():
    var button = Button.new()
    # Option 1: Object.connect() with an implicit Callable for the defined function.
    button.connect("button_down", _on_button_down)
    # Option 2: Object.connect() with a constructed Callable using a target object and method name.
    button.connect("button_down", Callable(self, "_on_button_down"))
    # Option 3: Signal.connect() with an implicit Callable for the defined function.
    button.button_down.connect(_on_button_down)
    # Option 4: Signal.connect() with a constructed Callable using a target object and method name.
    button.button_down.connect(Callable(self, "_on_button_down"))
func _on_button_down():
    print("Button down!")
```

```
public override void _Ready()
{
    var button = new Button();
    // Option 1: In C#, we can use signals as events and connect with this idiomatic syntax:
    button.ButtonDown += OnButtonDown;
    // Option 2: GodotObject.Connect() with a constructed Callable from a method group.
    button.Connect(Button.SignalName.ButtonDown, Callable.From(OnButtonDown));
    // Option 3: GodotObject.Connect() with a constructed Callable using a target object and method name.
    button.Connect(Button.SignalName.ButtonDown, new Callable(this, MethodName.OnButtonDown));
}
private void OnButtonDown()
{
    GD.Print("Button down!");
}
```

While all options have the same outcome (button's BaseButton.button_down signal will be connected to _on_button_down), option 3 offers the best validation: it will print a compile-time error if either the button_down Signal or the _on_button_down Callable are not defined. On the other hand, option 2 only relies on string names and will only be able to validate either names at runtime: it will generate an error at runtime if "button_down" is not a signal, or if "_on_button_down" is not a method in the object self. The main reason for using options 1, 2, or 4 would be if you actually need to use strings (e.g. to connect signals programmatically based on strings read from a configuration file). Otherwise, option 3 is the recommended (and fastest) method.

Binding and passing parameters:

The syntax to bind parameters is through Callable.bind(), which returns a copy of the Callable with its parameters bound.

When calling emit() or Object.emit_signal(), the signal parameters can be also passed. The examples below show the relationship between these signal parameters and bound parameters.

```
func _ready():
    # This assumes that a `Player` class exists, which defines a `hit` signal.
    var player = Player.new()
    # Using Callable.bind().
    player.hit.connect(_on_player_hit.bind("sword", 100))
    # Parameters added when emitting the signal are passed first.
    player.hit.emit("Dark lord", 5)
# We pass two arguments when emitting (`hit_by`, `level`),
# and bind two more arguments when connecting (`weapon_type`, `damage`).
func _on_player_hit(hit_by, level, weapon_type, damage):
    print("Hit by %s (level %d) with weapon %s for %d damage." % [hit_by, level, weapon_type, damage])
```

```
public override void _Ready()
{
    // This assumes that a `Player` class exists, which defines a `Hit` signal.
    var player = new Player();
    // Using lambda expressions that create a closure that captures the additional parameters.
    // The lambda only receives the parameters defined by the signal's delegate.
    player.Hit += (hitBy, level) => OnPlayerHit(hitBy, level, "sword", 100);
    // Parameters added when emitting the signal are passed first.
    player.EmitSignal(SignalName.Hit, "Dark lord", 5);
}
// We pass two arguments when emitting (`hit_by`, `level`),
// and bind two more arguments when connecting (`weapon_type`, `damage`).
private void OnPlayerHit(string hitBy, int level, string weaponType, int damage)
{
    GD.Print($"Hit by {hitBy} (level {level}) with weapon {weaponType} for {damage} damage.");
}
```

Note: In a boolean context, a signal will evaluate to false if it's null (see is_null()). Otherwise, a signal will always evaluate to true.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Tutorials

- Using Signals
- GDScript Basics

## Constructors

Signal | Signal()
Signal | Signal(from: Signal)
Signal | Signal(object: Object, signal: StringName)

## Methods

int | connect(callable: Callable, flags: int = 0)
void | disconnect(callable: Callable)
void | emit(...) vararg const
Array | get_connections() const
StringName | get_name() const
Object | get_object() const
int | get_object_id() const
bool | has_connections() const
bool | is_connected(callable: Callable) const
bool | is_null() const

## Operators

bool | operator !=(right: Signal)
bool | operator ==(right: Signal)

---

## Constructor Descriptions

Signal Signal() 

Constructs an empty Signal with no object nor signal name bound.

---

Signal Signal(from: Signal)

Constructs a Signal as a copy of the given Signal.

---

Signal Signal(object: Object, signal: StringName)

Creates a Signal object referencing a signal named signal in the specified object.

---

## Method Descriptions

int connect(callable: Callable, flags: int = 0) 

Connects this signal to the specified callable. Optional flags can be also added to configure the connection's behavior (see ConnectFlags constants). You can provide additional arguments to the connected callable by using Callable.bind().

A signal can only be connected once to the same Callable. If the signal is already connected, this method returns @GlobalScope.ERR_INVALID_PARAMETER and generates an error, unless the signal is connected with Object.CONNECT_REFERENCE_COUNTED. To prevent this, use is_connected() first to check for existing connections.

```gdscript
for button in $Buttons.get_children():
    button.pressed.connect(_on_pressed.bind(button))
func _on_pressed(button):
    print(button.name, " was pressed")
```

Note: If the callable's object is freed, the connection will be lost.

---

void disconnect(callable: Callable) 

Disconnects this signal from the specified Callable. If the connection does not exist, generates an error. Use is_connected() to make sure that the connection exists.

---

void emit(...) vararg const 

Emits this signal. All Callables connected to this signal will be triggered. This method supports a variable number of arguments, so parameters can be passed as a comma separated list.

---

Array get_connections() const 

Returns an Array of connections for this signal. Each connection is represented as a Dictionary that contains three entries:

- signal is a reference to this signal;
- callable is a reference to the connected Callable;
- flags is a combination of ConnectFlags.

---

StringName get_name() const 

Returns the name of this signal.

---

Object get_object() const 

Returns the object emitting this signal.

---

int get_object_id() const 

Returns the ID of the object emitting this signal (see Object.get_instance_id()).

---

bool has_connections() const 

Returns true if any Callable is connected to this signal.

---

bool is_connected(callable: Callable) const 

Returns true if the specified Callable is connected to this signal.

---

bool is_null() const 

Returns true if this Signal has no object and the signal name is empty. Equivalent to signal == Signal().

---

## Operator Descriptions

bool operator !=(right: Signal) 

Returns true if the signals do not share the same object and name.

---

bool operator ==(right: Signal) 

Returns true if both signals share the same object and name.
