# EditorScript

Inherits: RefCounted < Object

Base script that can be used to add extension functions to the editor.

## Description

Scripts extending this class and implementing its _run() method can be executed from the Script Editor's File > Run menu option (or by pressing Ctrl + Shift + X) while the editor is running. This is useful for adding custom in-editor functionality to Godot. For more complex additions, consider using EditorPlugins instead.

If a script extending this class also has a global class name, it will be included in the editor's command palette.

Note: Extending scripts need to have tool mode enabled.

Example: Running the following script prints "Hello from the Godot Editor!":

```
@tool
extends EditorScript
func _run():
    print("Hello from the Godot Editor!")
```

```
using Godot;
[Tool]
public partial class HelloEditor : EditorScript
{
    public override void _Run()
    {
        GD.Print("Hello from the Godot Editor!");
    }
}
```

Note: EditorScript is RefCounted, meaning it is destroyed when nothing references it. This can cause errors during asynchronous operations if there are no references to the script.

## Methods

void | _run() virtual required
void | add_root_node(node: Node)
EditorInterface | get_editor_interface() const
Node | get_scene() const

---

## Method Descriptions

void _run() virtual required 

This method is executed by the Editor when File > Run is used.

---

void add_root_node(node: Node) 

Deprecated: Use EditorInterface.add_root_node() instead.

Makes node root of the currently opened scene. Only works if the scene is empty. If the node is a scene instance, an inheriting scene will be created.

---

EditorInterface get_editor_interface() const 

Deprecated: EditorInterface is a global singleton and can be accessed directly by its name.

Returns the EditorInterface singleton instance.

---

Node get_scene() const 

Deprecated: Use EditorInterface.get_edited_scene_root() instead.

Returns the edited (current) scene's root Node. Equivalent of EditorInterface.get_edited_scene_root().
