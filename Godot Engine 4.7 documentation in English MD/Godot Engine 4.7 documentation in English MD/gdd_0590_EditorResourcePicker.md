# EditorResourcePicker

Inherits: HBoxContainer < BoxContainer < Container < Control < CanvasItem < Node < Object

Inherited By: EditorScriptPicker

Godot editor's control for selecting Resource type properties.

## Description

This Control node is used in the editor's Inspector dock to allow editing of Resource type properties. It provides options for creating, loading, saving and converting resources. Can be used with EditorInspectorPlugin to recreate the same behavior.

Note: This Control does not include any editor for the resource, as editing is controlled by the Inspector dock itself or sub-Inspectors.

## Properties

String | base_type | ""
bool | editable | true
Resource | edited_resource |
bool | toggle_mode | false

## Methods

bool | _handle_menu_selected(id: int) virtual
void | _set_create_options(menu_node: Object) virtual
PackedStringArray | get_allowed_types() const
void | set_toggle_pressed(pressed: bool)

---

## Signals

resource_changed(resource: Resource) 

Emitted when the value of the edited resource was changed.

---

resource_selected(resource: Resource, inspect: bool) 

Emitted when the resource value was set and user clicked to edit it. When inspect is true, the signal was caused by the context menu "Edit" or "Inspect" option.

---

## Property Descriptions

String base_type = "" 

- void set_base_type(value: String)
- String get_base_type()

The base type of allowed resource types. Can be a comma-separated list of several options.

---

bool editable = true 

- void set_editable(value: bool)
- bool is_editable()

If true, the value can be selected and edited.

---

Resource edited_resource 

- void set_edited_resource(value: Resource)
- Resource get_edited_resource()

The edited resource value.

---

bool toggle_mode = false 

- void set_toggle_mode(value: bool)
- bool is_toggle_mode()

If true, the main button with the resource preview works in the toggle mode. Use set_toggle_pressed() to manually set the state.

---

## Method Descriptions

bool _handle_menu_selected(id: int) virtual 

This virtual method can be implemented to handle context menu items not handled by default. See _set_create_options().

---

void _set_create_options(menu_node: Object) virtual 

This virtual method is called when updating the context menu of an editable EditorResourcePicker. Implement this method to override the "New" items section with your own options. menu_node is a reference to the PopupMenu node.

Note: Implement _handle_menu_selected() to handle these custom items.

Note: Relevant built-in options ("Load", "Copy", "Paste", etc.) are automatically added to the menu_node afterwards, using their hard-coded IDs starting from 0. Custom options need to use non-colliding IDs to be handled properly. Using id = 100 + custom_option_index is safe (this is what the default items in the "New" section use).

---

PackedStringArray get_allowed_types() const 

Returns a list of all allowed types and subtypes corresponding to the base_type. If the base_type is empty, an empty list is returned.

---

void set_toggle_pressed(pressed: bool) 

Sets the toggle mode state for the main button. Works only if toggle_mode is set to true.
