# OpenXRBindingModifierEditor

Inherits: PanelContainer < Container < Control < CanvasItem < Node < Object

Binding modifier editor.

## Description

This is the default binding modifier editor used in the OpenXR action map.

## Methods

OpenXRBindingModifier | get_binding_modifier() const
void | setup(action_map: OpenXRActionMap, binding_modifier: OpenXRBindingModifier)

---

## Signals

binding_modifier_removed(binding_modifier_editor: Object) 

Signal emitted when the user presses the delete binding modifier button for this modifier.

---

## Method Descriptions

OpenXRBindingModifier get_binding_modifier() const 

Returns the OpenXRBindingModifier currently being edited.

---

void setup(action_map: OpenXRActionMap, binding_modifier: OpenXRBindingModifier) 

Setup this editor for the provided action_map and binding_modifier.
