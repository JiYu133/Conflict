# Class reference primer

This page explains how to write the class reference. You will learn where to
write new descriptions for the classes, methods, and properties for Godot's
built-in node types.

See also

To learn to submit your changes to the Godot project using the Git version
control system, see Class reference contribution documentation [https://contributing.godotengine.org/en/latest/documentation/class_reference.html].

The reference for each class is contained in an XML file like the one below:

```xml

    
        A 2D game object, inherited by all 2D-related nodes. Has a position, rotation, scale, and Z index.
    
    
        A 2D game object, with a transform (position, rotation, and scale). All 2D nodes, including physics objects and sprites, inherit from Node2D. Use Node2D as a parent node to move, scale and rotate children in a 2D project. Also gives control of the node's render order.
    
    
        https://docs.godotengine.org/en/latest/tutorials/2d/custom_drawing_in_2d.html
        https://github.com/godotengine/godot-demo-projects/tree/master/2d
    
    
        
            
            
            
            
            
                Multiplies the current scale by the [code]ratio[/code] vector.
            
        
        [...]
        
            
            
            
            
            
                Translates the node by the given [code]offset[/code] in local coordinates.
            
        
    
    
        
            Global position.
        
        [...]
        
            Z index. Controls the order in which the nodes render. A node with a higher Z index will display in front of others.
        
    
    
    

```

It starts with brief and long descriptions. In the generated docs, the brief
description is always at the top of the page, while the long description lies
below the list of methods, variables, and constants. You can find methods,
member variables, constants, and signals in separate XML nodes.

For each, you want to learn how they work in Godot's source code. Then, fill
their documentation by completing or improving the text in these tags:

- 
- 
- 
-  (in its  tag; return types and arguments don't take separate
documentation strings)
- 
-  (in its  tag; arguments don't take separate documentation strings)
- 

Write in a clear and simple language. Always follow the writing guidelines [https://contributing.godotengine.org/en/latest/documentation/guidelines/docs_writing_guidelines.html]
to keep your descriptions short and easy to read.
Do not leave empty lines in the descriptions: each line in the XML file will
result in a new paragraph, even if it is empty.

## How to edit class XML

Edit the file for your chosen class in doc/classes/ to update the class
reference. The folder contains an XML file for each class. The XML lists the
constants and methods you will find in the class reference. Godot generates and
updates the XML automatically.

Note

For some modules in the engine's source code, you'll find the XML
files in the modules//doc_classes/ directory instead.

Edit it using your favorite text editor. If you use a code editor, make sure
that it doesn't change the indent style: you should use tabs for the XML and
four spaces inside BBCode-style blocks. More on that below.

To check that the modifications you've made are correct in the generated
documentation, navigate to the doc/ folder and run the command make rst.
This will convert the XML files to the online documentation's format and output
errors if anything's wrong.

Alternatively, you can build Godot and open the modified page in the built-in
code reference. To learn how to compile the engine, read the compilation
guide.

We recommend using a code editor that supports XML files like Vim, Atom, Visual Studio Code,
Notepad++, or another to comfortably edit the file. You can also use their
search feature to find classes and properties quickly.

Tip

If you use Visual Studio Code, you can install the
vscode-xml extension [https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml]
to get linting for class reference XML files.

### Improve formatting with BBCode style tags

Godot's XML class reference supports BBCode-like tags for linking as well as formatting text and code.
In the tables below you can find the available tags, usage examples and the results after conversion to reStructuredText.

#### Linking

Whenever you link to a member of another class, you need to specify the class name.
For links to the same class, the class name is optional and can be omitted.

Tag and Description | Example | Result
[Class]
Link to class | Move the [Sprite2D]. | Move the Sprite2D.
[annotation Class.name]
Link to annotation | See [annotation @GDScript.@rpc]. | See @GDScript.@rpc.
[constant Class.name]
Link to constant | See [constant Color.RED]. | See Color.RED.
[enum Class.name]
Link to enum | See [enum Mesh.ArrayType]. | See Mesh.ArrayType.
[member Class.name]
Link to member | Get [member Node2D.scale]. | Get Node2D.scale.
[method Class.name]
Link to method | Call [method Node3D.hide]. | Call Node3D.hide().
[constructor Class.name]
Link to built-in constructor | Use [constructor Color.Color]. | Use  Color.Color.
[operator Class.name]
Link to built-in operator | Use [operator Color.operator *]. | Use  Color.operator *.
[signal Class.name]
Link to signal | Emit [signal Node.renamed]. | Emit Node.renamed.
[theme_item Class.name]
Link to theme item | See [theme_item Label.font]. | See Label.font.
[param name]
Parameter name (as code) | Takes [param size] for the size. | Takes size for the size.

Note

Currently only @GDScript has annotations.

#### Formatting text

Tag and Description | Example | Result
[br]
Line break | Line 1.[br]
Line 2. | Line 1.
Line 2.
[lb] [rb]
[ and ] respectively | [lb]b[rb]text[lb]/b[rb] | [b]text[/b]
[b] [/b]
Bold | Do [b]not[/b] call this method. | Do not call this method.
[i] [/i]
Italic | Returns the [i]global[/i] position. | Returns the global position.
[u] [/u]
Underline | [u]Always[/u] use this method. | Always use this method.
[s] [/s]
Strikethrough | [s]Outdated information.[/s] | Outdated information.
 
Hyperlink | https://example.com
Website | https://example.com
Website [https://example.com]
[center] [/center]
Horizontal centering | [center]2 + 2 = 4[/center] | 2 + 2 = 4
[kbd] [/kbd]
Keyboard/mouse shortcut | Press [kbd]Ctrl + C[/kbd]. | Press Ctrl + C.
[code] [/code]
Inline code fragment | Returns [code]true[/code]. | Returns true.

Note

1. Some supported tags like [color] and [font] are not listed here because they are not recommended in the engine documentation.
2. [kbd] disables BBCode until the parser encounters [/kbd].
3. [code] disables BBCode until the parser encounters [/code].

#### Formatting code blocks

There are two options for formatting code blocks:

1. Use [codeblock] if you want to add an example for a specific language.
2. Use [codeblocks], [gdscript], and [csharp] if you want to add the same example for both languages, GDScript and C#.

By default, [codeblock] highlights GDScript syntax. You can change it using
the lang attribute. Currently supported options are:

- [codeblock lang=text] disables syntax highlighting;
- [codeblock lang=gdscript] highlights GDScript syntax;
- [codeblock lang=csharp] highlights C# syntax (only in .NET version).

Note

[codeblock] disables BBCode until the parser encounters [/codeblock].

Warning

Use [codeblock] for pre-formatted code blocks. Since Godot 4.5,
tabs should be used for indentation.

For example:

```
[codeblock]
func _ready():
    var sprite = get_node("Sprite2D")
    print(sprite.get_pos())
[/codeblock]
```

Will display as:

```gdscript
func _ready():
    var sprite = get_node("Sprite2D")
    print(sprite.get_pos())
```

If you need to have different code version in GDScript and C#, use
[codeblocks] instead. If you use [codeblocks], you also need to have at
least one of the language-specific tags, [gdscript] and [csharp].

Always write GDScript code examples first! You can use this experimental code
translation tool [https://github.com/HaSa1002/codetranslator] to speed up your
workflow.

```
[codeblocks]
[gdscript]
func _ready():
    var sprite = get_node("Sprite2D")
    print(sprite.get_pos())
[/gdscript]
[csharp]
public override void _Ready()
{
    var sprite = GetNode("Sprite2D");
    GD.Print(sprite.GetPos());
}
[/csharp]
[/codeblocks]
```

The above will display as:

```
func _ready():
    var sprite = get_node("Sprite2D")
    print(sprite.get_pos())
```

```
public override void _Ready()
{
    var sprite = GetNode("Sprite2D");
    GD.Print(sprite.GetPos());
}
```

#### Formatting notes and warnings

To denote important information, add a paragraph starting with "[b]Note:[/b]" at
the end of the description:

```
[b]Note:[/b] Only available when using the Forward+ renderer.
```

To denote crucial information that could cause security issues or loss of data
if not followed carefully, add a paragraph starting with "[b]Warning:[/b]" at
the end of the description:

```
[b]Warning:[/b] If this property is set to [code]true[/code], it allows clients to execute arbitrary code on the server.
```

In all the paragraphs described above, make sure the punctuation is part of the
BBCode tags for consistency.

### Marking API as deprecated/experimental

To mark an API as deprecated or experimental, you need to add the corresponding XML attribute. The attribute value must be a message
explaining why the API is not recommended (BBCode markup is supported) or an empty string (the default message will be used).
If an API element is marked as deprecated/experimental, then it is considered documented even if the description is empty.

```xml

    [...]

    HTTP status code [code]305 Use Proxy[/code].

    Toggles if any text should automatically change to its translated version depending on the current locale.

    
    
        Returns the call mode used for "Call Method" tracks.
    

```
