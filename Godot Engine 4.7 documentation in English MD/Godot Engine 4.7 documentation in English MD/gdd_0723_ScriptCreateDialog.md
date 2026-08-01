# ScriptCreateDialog

Inherits: ConfirmationDialog < AcceptDialog < Window < Viewport < Node < Object

Godot editor's popup dialog for creating new Script files.

## Description

The ScriptCreateDialog creates script files according to a given template for a given scripting language. The standard use is to configure its fields prior to calling one of the Window.popup() methods.

```
func _ready():
    var dialog = ScriptCreateDialog.new();
    dialog.config("Node", "res://new_node.gd") # For in-engine types.
    dialog.config("\"res://base_node.gd\"", "res://derived_node.gd") # For script types.
    dialog.popup_centered()
```

```
public override void _Ready()
{
    var dialog = new ScriptCreateDialog();
    dialog.Config("Node", "res://NewNode.cs"); // For in-engine types.
    dialog.Config("\"res://BaseNode.cs\"", "res://DerivedNode.cs"); // For script types.
    dialog.PopupCentered();
}
```

## Properties

bool | dialog_hide_on_ok | false (overrides AcceptDialog)
String | ok_button_text | "Create" (overrides AcceptDialog)
String | title | "Attach Node Script" (overrides Window)

## Methods

void | config(inherits: String, path: String, built_in_enabled: bool = true, load_enabled: bool = true)

---

## Signals

script_created(script: Script) 

Emitted when the user clicks the OK button.

---

## Method Descriptions

void config(inherits: String, path: String, built_in_enabled: bool = true, load_enabled: bool = true) 

Prefills required fields to configure the ScriptCreateDialog for use.
