# AnimationTree

Inherits: AnimationMixer < Node < Object

A node used for advanced animation transitions in an AnimationPlayer.

## Description

A node used for advanced animation transitions in an AnimationPlayer.

Note: When linked with an AnimationPlayer, several properties and methods of the corresponding AnimationPlayer will not function as expected. Playback and transitions should be handled using only the AnimationTree and its constituent AnimationNode(s). The AnimationPlayer node should be used solely for adding, deleting, and editing animations.

## Tutorials

- Using AnimationTree
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

NodePath | advance_expression_base_node | NodePath(".")
NodePath | anim_player | NodePath("")
AnimationCallbackModeDiscrete | callback_mode_discrete | 2 (overrides AnimationMixer)
bool | deterministic | true (overrides AnimationMixer)
AnimationRootNode | tree_root |

## Methods

AnimationProcessCallback | get_process_callback() const
void | set_process_callback(mode: AnimationProcessCallback)

---

## Signals

animation_player_changed() 

Emitted when the anim_player is changed.

---

## Enumerations

enum AnimationProcessCallback
AnimationProcessCallback ANIMATION_PROCESS_PHYSICS = 0

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS.

AnimationProcessCallback ANIMATION_PROCESS_IDLE = 1

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_IDLE.

AnimationProcessCallback ANIMATION_PROCESS_MANUAL = 2

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL.

---

## Property Descriptions

NodePath advance_expression_base_node = NodePath(".") 

- void set_advance_expression_base_node(value: NodePath)
- NodePath get_advance_expression_base_node()

The path to the Node used to evaluate the AnimationNode Expression if one is not explicitly specified internally.

---

NodePath anim_player = NodePath("") 

- void set_animation_player(value: NodePath)
- NodePath get_animation_player()

The path to the AnimationPlayer used for animating.

---

AnimationRootNode tree_root 

- void set_tree_root(value: AnimationRootNode)
- AnimationRootNode get_tree_root()

The root animation node of this AnimationTree. See AnimationRootNode.

---

## Method Descriptions

AnimationProcessCallback get_process_callback() const 

Deprecated: Use AnimationMixer.callback_mode_process instead.

Returns the process notification in which to update animations.

---

void set_process_callback(mode: AnimationProcessCallback) 

Deprecated: Use AnimationMixer.callback_mode_process instead.

Sets the process notification in which to update animations.
