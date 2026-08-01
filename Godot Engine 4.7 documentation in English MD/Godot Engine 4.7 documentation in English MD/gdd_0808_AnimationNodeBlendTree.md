# AnimationNodeBlendTree

Inherits: AnimationRootNode < AnimationNode < Resource < RefCounted < Object

A sub-tree of many type AnimationNodes used for complex animations. Used by AnimationTree.

## Description

This animation node may contain a sub-tree of any other type animation nodes, such as AnimationNodeTransition, AnimationNodeBlend2, AnimationNodeBlend3, AnimationNodeOneShot, etc. This is one of the most commonly used animation node roots.

An AnimationNodeOutput node named output is created by default.

## Tutorials

- Using AnimationTree

## Properties

Vector2 | graph_offset | Vector2(0, 0)

## Methods

void | add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0))
void | connect_node(input_node: StringName, input_index: int, output_node: StringName)
void | disconnect_node(input_node: StringName, input_index: int)
AnimationNode | get_node(name: StringName) const
Array[StringName] | get_node_list() const
Vector2 | get_node_position(name: StringName) const
bool | has_node(name: StringName) const
void | remove_node(name: StringName)
void | rename_node(name: StringName, new_name: StringName)
void | set_node_position(name: StringName, position: Vector2)

---

## Signals

node_changed(node_name: StringName) 

Emitted when the input port information is changed.

---

## Constants

CONNECTION_OK = 0 

The connection was successful.

CONNECTION_ERROR_NO_INPUT = 1 

The input node is null.

CONNECTION_ERROR_NO_INPUT_INDEX = 2 

The specified input port is out of range.

CONNECTION_ERROR_NO_OUTPUT = 3 

The output node is null.

CONNECTION_ERROR_SAME_NODE = 4 

Input and output nodes are the same.

CONNECTION_ERROR_CONNECTION_EXISTS = 5 

The specified connection already exists.

---

## Property Descriptions

Vector2 graph_offset = Vector2(0, 0) 

- void set_graph_offset(value: Vector2)
- Vector2 get_graph_offset()

The global offset of all sub animation nodes.

---

## Method Descriptions

void add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0)) 

Adds an AnimationNode at the given position. The name is used to identify the created sub animation node later.

---

void connect_node(input_node: StringName, input_index: int, output_node: StringName) 

Connects the output of an AnimationNode as input for another AnimationNode, at the input port specified by input_index.

---

void disconnect_node(input_node: StringName, input_index: int) 

Disconnects the animation node connected to the specified input.

---

AnimationNode get_node(name: StringName) const 

Returns the sub animation node with the specified name.

---

Array[StringName] get_node_list() const 

Returns a list containing the names of all sub animation nodes in this blend tree.

---

Vector2 get_node_position(name: StringName) const 

Returns the position of the sub animation node with the specified name.

---

bool has_node(name: StringName) const 

Returns true if a sub animation node with specified name exists.

---

void remove_node(name: StringName) 

Removes a sub animation node.

---

void rename_node(name: StringName, new_name: StringName) 

Changes the name of a sub animation node.

---

void set_node_position(name: StringName, position: Vector2) 

Modifies the position of a sub animation node.
