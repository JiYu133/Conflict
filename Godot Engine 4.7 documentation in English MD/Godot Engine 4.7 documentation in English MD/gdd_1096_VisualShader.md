# VisualShader

Inherits: Shader < Resource < RefCounted < Object

A custom shader program with a visual editor.

## Description

This class provides a graph-like visual editor for creating a Shader. Although VisualShaders do not require coding, they share the same logic with script shaders. They use VisualShaderNodes that can be connected to each other to control the flow of the shader. The visual shader graph is converted to a script shader behind the scenes.

## Tutorials

- Using VisualShaders

## Properties

Vector2 | graph_offset

## Methods

void | add_node(type: Type, node: VisualShaderNode, position: Vector2, id: int)
void | add_varying(name: String, mode: VaryingMode, type: VaryingType)
void | attach_node_to_frame(type: Type, id: int, frame: int)
bool | can_connect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) const
Error | connect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int)
void | connect_nodes_forced(type: Type, from_node: int, from_port: int, to_node: int, to_port: int)
void | detach_node_from_frame(type: Type, id: int)
void | disconnect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int)
VisualShaderNode | get_node(type: Type, id: int) const
Array[Dictionary] | get_node_connections(type: Type) const
PackedInt32Array | get_node_list(type: Type) const
Vector2 | get_node_position(type: Type, id: int) const
int | get_valid_node_id(type: Type) const
bool | has_varying(name: String) const
bool | is_node_connection(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) const
void | remove_node(type: Type, id: int)
void | remove_varying(name: String)
void | replace_node(type: Type, id: int, new_class: StringName)
void | set_mode(mode: Mode)
void | set_node_position(type: Type, id: int, position: Vector2)

---

## Enumerations

enum Type
Type TYPE_VERTEX = 0

A vertex shader, operating on vertices.

Type TYPE_FRAGMENT = 1

A fragment shader, operating on fragments (pixels).

Type TYPE_LIGHT = 2

A shader for light calculations.

Type TYPE_START = 3

A function for the "start" stage of particle shader.

Type TYPE_PROCESS = 4

A function for the "process" stage of particle shader.

Type TYPE_COLLIDE = 5

A function for the "collide" stage (particle collision handler) of particle shader.

Type TYPE_START_CUSTOM = 6

A function for the "start" stage of particle shader, with customized output.

Type TYPE_PROCESS_CUSTOM = 7

A function for the "process" stage of particle shader, with customized output.

Type TYPE_SKY = 8

A shader for 3D environment's sky.

Type TYPE_FOG = 9

A compute shader that runs for each froxel of the volumetric fog map.

Type TYPE_TEXTURE_BLIT = 10

A shader used to process blit calls to a DrawableTexture.

Type TYPE_MAX = 11

Represents the size of the Type enum.

---

enum VaryingMode
VaryingMode VARYING_MODE_VERTEX_TO_FRAG_LIGHT = 0

Varying is passed from Vertex function to Fragment and Light functions.

VaryingMode VARYING_MODE_FRAG_TO_LIGHT = 1

Varying is passed from Fragment function to Light function.

VaryingMode VARYING_MODE_MAX = 2

Represents the size of the VaryingMode enum.

---

enum VaryingType
VaryingType VARYING_TYPE_FLOAT = 0

Varying is of type float.

VaryingType VARYING_TYPE_INT = 1

Varying is of type int.

VaryingType VARYING_TYPE_UINT = 2

Varying is of type unsigned int.

VaryingType VARYING_TYPE_VECTOR_2D = 3

Varying is of type Vector2.

VaryingType VARYING_TYPE_VECTOR_3D = 4

Varying is of type Vector3.

VaryingType VARYING_TYPE_VECTOR_4D = 5

Varying is of type Vector4.

VaryingType VARYING_TYPE_BOOLEAN = 6

Varying is of type bool.

VaryingType VARYING_TYPE_TRANSFORM = 7

Varying is of type Transform3D.

VaryingType VARYING_TYPE_MAX = 8

Represents the size of the VaryingType enum.

---

## Constants

NODE_ID_INVALID = -1 

Indicates an invalid VisualShader node.

NODE_ID_OUTPUT = 0 

Indicates an output node of VisualShader.

---

## Property Descriptions

Vector2 graph_offset 

- void set_graph_offset(value: Vector2)
- Vector2 get_graph_offset()

Deprecated: This property does nothing and always equals to zero.

Deprecated.

---

## Method Descriptions

void add_node(type: Type, node: VisualShaderNode, position: Vector2, id: int) 

Adds the specified node to the shader.

---

void add_varying(name: String, mode: VaryingMode, type: VaryingType) 

Adds a new varying value node to the shader.

---

void attach_node_to_frame(type: Type, id: int, frame: int) 

Attaches the given node to the given frame.

---

bool can_connect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) const 

Returns true if the specified nodes and ports can be connected together.

---

Error connect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) 

Connects the specified nodes and ports.

---

void connect_nodes_forced(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) 

Connects the specified nodes and ports, even if they can't be connected. Such connection is invalid and will not function properly.

---

void detach_node_from_frame(type: Type, id: int) 

Detaches the given node from the frame it is attached to.

---

void disconnect_nodes(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) 

Connects the specified nodes and ports.

---

VisualShaderNode get_node(type: Type, id: int) const 

Returns the shader node instance with specified type and id.

---

Array[Dictionary] get_node_connections(type: Type) const 

Returns the list of connected nodes with the specified type.

---

PackedInt32Array get_node_list(type: Type) const 

Returns the list of all nodes in the shader with the specified type.

---

Vector2 get_node_position(type: Type, id: int) const 

Returns the position of the specified node within the shader graph.

---

int get_valid_node_id(type: Type) const 

Returns next valid node ID that can be added to the shader graph.

---

bool has_varying(name: String) const 

Returns true if the shader has a varying with the given name.

---

bool is_node_connection(type: Type, from_node: int, from_port: int, to_node: int, to_port: int) const 

Returns true if the specified node and port connection exist.

---

void remove_node(type: Type, id: int) 

Removes the specified node from the shader.

---

void remove_varying(name: String) 

Removes a varying value node with the given name. Prints an error if a node with this name is not found.

---

void replace_node(type: Type, id: int, new_class: StringName) 

Replaces the specified node with a node of new class type.

---

void set_mode(mode: Mode) 

Sets the mode of this shader.

---

void set_node_position(type: Type, id: int, position: Vector2) 

Sets the position of the specified node.
