# Expression

Inherits: RefCounted < Object

A class that stores an expression you can execute.

## Description

An expression can be made of any arithmetic operation, built-in math function call, method call of a passed instance, or built-in type construction call.

An example expression text using the built-in math functions could be sqrt(pow(3, 2) + pow(4, 2)).

In the following example we use a LineEdit node to write our expression and show the result.

```
var expression = Expression.new()
func _ready():
    $LineEdit.text_submitted.connect(self._on_text_submitted)
func _on_text_submitted(command):
    var error = expression.parse(command)
    if error != OK:
        print(expression.get_error_text())
        return
    var result = expression.execute()
    if not expression.has_execute_failed():
        $LineEdit.text = str(result)
```

```
private Expression _expression = new Expression();
public override void _Ready()
{
    GetNode("LineEdit").TextSubmitted += OnTextEntered;
}
private void OnTextEntered(string command)
{
    Error error = _expression.Parse(command);
    if (error != Error.Ok)
    {
        GD.Print(_expression.GetErrorText());
        return;
    }
    Variant result = _expression.Execute();
    if (!_expression.HasExecuteFailed())
    {
        GetNode("LineEdit").Text = result.ToString();
    }
}
```

## Tutorials

- Evaluating Expressions

## Methods

Variant | execute(inputs: Array = [], base_instance: Object = null, show_error: bool = true, const_calls_only: bool = false)
String | get_error_text() const
bool | has_execute_failed() const
Error | parse(expression: String, input_names: PackedStringArray = PackedStringArray())

---

## Method Descriptions

Variant execute(inputs: Array = [], base_instance: Object = null, show_error: bool = true, const_calls_only: bool = false) 

Executes the expression that was previously parsed by parse() and returns the result. Before you use the returned object, you should check if the method failed by calling has_execute_failed().

If you defined input variables in parse(), you can specify their values in the inputs array, in the same order.

---

String get_error_text() const 

Returns the error text if parse() or execute() has failed.

---

bool has_execute_failed() const 

Returns true if execute() has failed.

---

Error parse(expression: String, input_names: PackedStringArray = PackedStringArray()) 

Parses the expression and returns an Error code.

You can optionally specify names of variables that may appear in the expression with input_names, so that you can bind them when it gets executed.
