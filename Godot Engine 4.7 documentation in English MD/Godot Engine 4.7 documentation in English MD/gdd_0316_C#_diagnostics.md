# C# diagnostics

Godot includes analyzers that inspect your C# source code to check for invalid
or unsupported code and let you know that something is wrong during build time.

## Rules

- GD0001: Missing partial modifier on declaration of type that derives from GodotObject
- GD0002: Missing partial modifier on declaration of type which contains nested classes that derive from GodotObject
- GD0003: Found multiple classes with the same name in the same script file
- GD0101: The exported member is static
- GD0102: The type of the exported member is not supported
- GD0103: The exported member is read-only
- GD0104: The exported property is write-only
- GD0105: The exported property is an indexer
- GD0106: The exported property is an explicit interface implementation
- GD0107: Types not derived from Node should not export Node members
- GD0108: The exported tool button is not in a tool class
- GD0109: The '[ExportToolButton]' attribute cannot be used with another '[Export]' attribute
- GD0110: The exported tool button is not a Callable
- GD0111: The exported tool button must be an expression-bodied property
- GD0201: The name of the delegate must end with 'EventHandler'
- GD0202: The parameter of the delegate signature of the signal is not supported
- GD0203: The delegate signature of the signal must return void
- GD0301: The generic type argument must be a Variant compatible type
- GD0302: The generic type parameter must be annotated with the '[MustBeVariant]' attribute
- GD0303: The parent symbol of a type argument that must be Variant compatible was not handled
- GD0401: The class must derive from Godot.GodotObject or a derived class
- GD0402: The class must not be generic
