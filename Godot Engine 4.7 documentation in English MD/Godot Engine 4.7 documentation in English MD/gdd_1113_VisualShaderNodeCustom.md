# VisualShaderNodeCustom

Inherits: VisualShaderNode < Resource < RefCounted < Object

Virtual class to define custom VisualShaderNodes for use in the Visual Shader Editor.

## Description

By inheriting this class you can create a custom VisualShader script addon which will be automatically added to the Visual Shader Editor. The VisualShaderNode's behavior is defined by overriding the provided virtual methods.

In order for the node to be registered as an editor addon, you must use the @tool annotation and provide a class_name for your custom script. For example:

```gdscript
@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeNoise
```

## Tutorials

- Visual Shader plugins

## Methods

String | _get_category() virtual const
String | _get_code(input_vars: Array[String], output_vars: Array[String], mode: Mode, type: Type) virtual const
int | _get_default_input_port(type: PortType) virtual const
String | _get_description() virtual const
String | _get_func_code(mode: Mode, type: Type) virtual const
String | _get_global_code(mode: Mode) virtual const
int | _get_input_port_count() virtual const
Variant | _get_input_port_default_value(port: int) virtual const
String | _get_input_port_name(port: int) virtual const
PortType | _get_input_port_type(port: int) virtual const
String | _get_name() virtual const
int | _get_output_port_count() virtual const
String | _get_output_port_name(port: int) virtual const
PortType | _get_output_port_type(port: int) virtual const
int | _get_property_count() virtual const
int | _get_property_default_index(index: int) virtual const
String | _get_property_name(index: int) virtual const
PackedStringArray | _get_property_options(index: int) virtual const
PortType | _get_return_icon_type() virtual const
bool | _is_available(mode: Mode, type: Type) virtual const
bool | _is_highend() virtual const
int | get_option_index(option: int) const

---

## Method Descriptions

String _get_category() virtual const 

Override this method to define the path to the associated custom node in the Visual Shader Editor's members dialog. The path may look like "MyGame/MyFunctions/Noise".

Defining this method is optional. If not overridden, the node will be filed under the "Addons" category.

---

String _get_code(input_vars: Array[String], output_vars: Array[String], mode: Mode, type: Type) virtual const 

Override this method to define the actual shader code of the associated custom node. The shader code should be returned as a string, which can have multiple lines (the """ multiline string construct can be used for convenience).

The input_vars and output_vars arrays contain the string names of the various input and output variables, as defined by _get_input_* and _get_output_* virtual methods in this class.

The output ports can be assigned values in the shader code. For example, return output_vars[0] + " = " + input_vars[0] + ";".

You can customize the generated code based on the shader mode and/or type.

Defining this method is required.

---

int _get_default_input_port(type: PortType) virtual const 

Override this method to define the input port which should be connected by default when this node is created as a result of dragging a connection from an existing node to the empty space on the graph.

Defining this method is optional. If not overridden, the connection will be created to the first valid port.

---

String _get_description() virtual const 

Override this method to define the description of the associated custom node in the Visual Shader Editor's members dialog.

Defining this method is optional.

---

String _get_func_code(mode: Mode, type: Type) virtual const 

Override this method to add a shader code to the beginning of each shader function (once). The shader code should be returned as a string, which can have multiple lines (the """ multiline string construct can be used for convenience).

If there are multiple custom nodes of different types which use this feature the order of each insertion is undefined.

You can customize the generated code based on the shader mode and/or type.

Defining this method is optional.

---

String _get_global_code(mode: Mode) virtual const 

Override this method to add shader code on top of the global shader, to define your own standard library of reusable methods, varyings, constants, uniforms, etc. The shader code should be returned as a string, which can have multiple lines (the """ multiline string construct can be used for convenience).

Be careful with this functionality as it can cause name conflicts with other custom nodes, so be sure to give the defined entities unique names.

You can customize the generated code based on the shader mode.

Defining this method is optional.

---

int _get_input_port_count() virtual const 

Override this method to define the number of input ports of the associated custom node.

Defining this method is required. If not overridden, the node has no input ports.

---

Variant _get_input_port_default_value(port: int) virtual const 

Override this method to define the default value for the specified input port. Prefer use this over VisualShaderNode.set_input_port_default_value().

Defining this method is required. If not overridden, the node has no default values for their input ports.

---

String _get_input_port_name(port: int) virtual const 

Override this method to define the names of input ports of the associated custom node. The names are used both for the input slots in the editor and as identifiers in the shader code, and are passed in the input_vars array in _get_code().

Defining this method is optional, but recommended. If not overridden, input ports are named as "in" + str(port).

---

PortType _get_input_port_type(port: int) virtual const 

Override this method to define the returned type of each input port of the associated custom node.

Defining this method is optional, but recommended. If not overridden, input ports will return the VisualShaderNode.PORT_TYPE_SCALAR type.

---

String _get_name() virtual const 

Override this method to define the name of the associated custom node in the Visual Shader Editor's members dialog and graph.

Defining this method is optional, but recommended. If not overridden, the node will be named as "Unnamed".

---

int _get_output_port_count() virtual const 

Override this method to define the number of output ports of the associated custom node.

Defining this method is required. If not overridden, the node has no output ports.

---

String _get_output_port_name(port: int) virtual const 

Override this method to define the names of output ports of the associated custom node. The names are used both for the output slots in the editor and as identifiers in the shader code, and are passed in the output_vars array in _get_code().

Defining this method is optional, but recommended. If not overridden, output ports are named as "out" + str(port).

---

PortType _get_output_port_type(port: int) virtual const 

Override this method to define the returned type of each output port of the associated custom node.

Defining this method is optional, but recommended. If not overridden, output ports will return the VisualShaderNode.PORT_TYPE_SCALAR type.

---

int _get_property_count() virtual const 

Override this method to define the number of the properties.

Defining this method is optional.

---

int _get_property_default_index(index: int) virtual const 

Override this method to define the default index of the property of the associated custom node.

Defining this method is optional.

---

String _get_property_name(index: int) virtual const 

Override this method to define the names of the property of the associated custom node.

Defining this method is optional.

---

PackedStringArray _get_property_options(index: int) virtual const 

Override this method to define the options inside the drop-down list property of the associated custom node.

Defining this method is optional.

---

PortType _get_return_icon_type() virtual const 

Override this method to define the return icon of the associated custom node in the Visual Shader Editor's members dialog.

Defining this method is optional. If not overridden, no return icon is shown.

---

bool _is_available(mode: Mode, type: Type) virtual const 

Override this method to prevent the node to be visible in the member dialog for the certain mode and/or type.

Defining this method is optional. If not overridden, it's true.

---

bool _is_highend() virtual const 

Override this method to enable the high-end mark in the Visual Shader Editor's members dialog. This should return true for nodes that only work when using the Forward+ and Mobile renderers.

Defining this method is optional. If not overridden, it's false, which indicates this node works with all renderers (including Compatibility).

---

int get_option_index(option: int) const 

Returns the selected index of the drop-down list option within a graph. You may use this function to define the specific behavior in the _get_code() or _get_global_code().
