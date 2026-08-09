# InputEventAction

Inherits: InputEvent < Resource < RefCounted < Object

An input event type for actions.

## Description

Contains a generic action which can be targeted from several types of inputs. Actions and their events can be set in the Input Map tab in Project > Project Settings, or with the InputMap class.

Note: Unlike the other InputEvent subclasses which map to unique physical events, this virtual one is not emitted by the engine. This class is useful to emit actions manually with Input.parse_input_event(), which are then received in Node._input(). To check if a physical event matches an action from the Input Map, use InputEvent.is_action() and InputEvent.is_action_pressed().

## Tutorials

- Using InputEvent: Actions
- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]
- 3D Voxel Demo [https://godotengine.org/asset-library/asset/2755]

## Properties

StringName | action | &""
int | event_index | -1
bool | pressed | false
float | strength | 1.0

---

## Property Descriptions

StringName action = &"" 

- void set_action(value: StringName)
- StringName get_action()

The action's name. This is usually the name of an existing action in the InputMap which you want this custom event to match.

---

int event_index = -1 

- void set_event_index(value: int)
- int get_event_index()

The real event index in action this event corresponds to (from events defined for this action in the InputMap). If -1, a unique ID will be used and actions pressed with this ID will need to be released with another InputEventAction.

---

bool pressed = false 

- void set_pressed(value: bool)
- bool is_pressed()

If true, the action's state is pressed. If false, the action's state is released.

---

float strength = 1.0 

- void set_strength(value: float)
- float get_strength()

The action's strength between 0 and 1. This value is considered as equal to 0 if pressed is false. The event strength allows faking analog joypad motion events, by specifying how strongly the joypad axis is bent or pressed.
