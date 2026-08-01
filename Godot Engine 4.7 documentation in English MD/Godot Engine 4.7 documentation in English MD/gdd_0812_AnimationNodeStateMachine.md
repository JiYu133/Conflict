# AnimationNodeStateMachine

Inherits: AnimationRootNode < AnimationNode < Resource < RefCounted < Object

A state machine with multiple AnimationRootNodes, used by AnimationTree.

## Description

Contains multiple AnimationRootNodes representing animation states, connected in a graph. State transitions can be configured to happen automatically or via code, using a shortest-path algorithm. Retrieve the AnimationNodeStateMachinePlayback object from the AnimationTree node to control it programmatically.

```
var state_machine = $AnimationTree.get("parameters/playback")
state_machine.travel("some_state")
```

```
var stateMachine = GetNode("AnimationTree").Get("parameters/playback") as AnimationNodeStateMachinePlayback;
stateMachine.Travel("some_state");
```

## Tutorials

- Using AnimationTree

## Properties

bool | allow_transition_to_self | false
bool | reset_ends | false
StateMachineType | state_machine_type | 0

## Methods

void | add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0))
void | add_transition(from: StringName, to: StringName, transition: AnimationNodeStateMachineTransition)
Vector2 | get_graph_offset() const
AnimationNode | get_node(name: StringName) const
Array[StringName] | get_node_list() const
StringName | get_node_name(node: AnimationNode) const
Vector2 | get_node_position(name: StringName) const
AnimationNodeStateMachineTransition | get_transition(idx: int) const
int | get_transition_count() const
StringName | get_transition_from(idx: int) const
StringName | get_transition_to(idx: int) const
bool | has_node(name: StringName) const
bool | has_transition(from: StringName, to: StringName) const
void | remove_node(name: StringName)
void | remove_transition(from: StringName, to: StringName)
void | remove_transition_by_index(idx: int)
void | rename_node(name: StringName, new_name: StringName)
void | replace_node(name: StringName, node: AnimationNode)
void | set_graph_offset(offset: Vector2)
void | set_node_position(name: StringName, position: Vector2)

---

## Enumerations

enum StateMachineType
StateMachineType STATE_MACHINE_TYPE_ROOT = 0

Seeking to the beginning is treated as playing from the start state. Transition to the end state is treated as exiting the state machine.

StateMachineType STATE_MACHINE_TYPE_NESTED = 1

Seeking to the beginning is treated as seeking to the beginning of the animation in the current state. Transition to the end state, or the absence of transitions in each state, is treated as exiting the state machine.

StateMachineType STATE_MACHINE_TYPE_GROUPED = 2

This is a grouped state machine that can be controlled from a parent state machine. It does not work independently. There must be a state machine with state_machine_type of STATE_MACHINE_TYPE_ROOT or STATE_MACHINE_TYPE_NESTED in the parent or ancestor.

---

## Property Descriptions

bool allow_transition_to_self = false 

- void set_allow_transition_to_self(value: bool)
- bool is_allow_transition_to_self()

If true, allows teleport to the self state with AnimationNodeStateMachinePlayback.travel(). When the reset option is enabled in AnimationNodeStateMachinePlayback.travel(), the animation is restarted. If false, nothing happens on the teleportation to the self state.

---

bool reset_ends = false 

- void set_reset_ends(value: bool)
- bool are_ends_reset()

If true, treat the cross-fade to the start and end nodes as a blend with the RESET animation.

In most cases, when additional cross-fades are performed in the parent AnimationNode of the state machine, setting this property to false and matching the cross-fade time of the parent AnimationNode and the state machine's start node and end node gives good results.

---

StateMachineType state_machine_type = 0 

- void set_state_machine_type(value: StateMachineType)
- StateMachineType get_state_machine_type()

This property can define the process of transitions for different use cases. See also StateMachineType.

---

## Method Descriptions

void add_node(name: StringName, node: AnimationNode, position: Vector2 = Vector2(0, 0)) 

Adds a new animation node to the graph. The position is used for display in the editor.

---

void add_transition(from: StringName, to: StringName, transition: AnimationNodeStateMachineTransition) 

Adds a transition between the given animation nodes.

---

Vector2 get_graph_offset() const 

Returns the draw offset of the graph. Used for display in the editor.

---

AnimationNode get_node(name: StringName) const 

Returns the animation node with the given name.

---

Array[StringName] get_node_list() const 

Returns a list containing the names of all animation nodes in this state machine.

---

StringName get_node_name(node: AnimationNode) const 

Returns the given animation node's name.

---

Vector2 get_node_position(name: StringName) const 

Returns the given animation node's coordinates. Used for display in the editor.

---

AnimationNodeStateMachineTransition get_transition(idx: int) const 

Returns the given transition.

---

int get_transition_count() const 

Returns the number of connections in the graph.

---

StringName get_transition_from(idx: int) const 

Returns the given transition's start node.

---

StringName get_transition_to(idx: int) const 

Returns the given transition's end node.

---

bool has_node(name: StringName) const 

Returns true if the graph contains the given animation node.

---

bool has_transition(from: StringName, to: StringName) const 

Returns true if there is a transition between the given animation nodes.

---

void remove_node(name: StringName) 

Deletes the given animation node from the graph.

---

void remove_transition(from: StringName, to: StringName) 

Deletes the transition between the two specified animation nodes.

---

void remove_transition_by_index(idx: int) 

Deletes the given transition by index.

---

void rename_node(name: StringName, new_name: StringName) 

Renames the given animation node.

---

void replace_node(name: StringName, node: AnimationNode) 

Replaces the given animation node with a new animation node.

---

void set_graph_offset(offset: Vector2) 

Sets the draw offset of the graph. Used for display in the editor.

---

void set_node_position(name: StringName, position: Vector2) 

Sets the animation node's coordinates. Used for display in the editor.
