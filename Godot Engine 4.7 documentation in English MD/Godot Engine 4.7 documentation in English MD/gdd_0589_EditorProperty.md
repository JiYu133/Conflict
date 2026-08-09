# EditorProperty

Inherits: Container < Control < CanvasItem < Node < Object

Custom control for editing properties that can be added to the EditorInspector.

## Description

A custom control for editing properties that can be added to the EditorInspector. It is added via EditorInspectorPlugin.

## Properties

bool | checkable | false
bool | checked | false
bool | deletable | false
bool | draw_background | true
bool | draw_label | true
bool | draw_warning | false
FocusMode | focus_mode | 3 (overrides Control)
bool | keying | false
String | label | ""
float | name_split_ratio | 0.5
bool | read_only | false
bool | selectable | true
bool | use_folding | false

## Methods

void | _set_read_only(read_only: bool) virtual
void | _update_property() virtual
void | add_focusable(control: Control)
void | deselect()
void | emit_changed(property: StringName, value: Variant, field: StringName = &"", changing: bool = false)
Object | get_edited_object()
StringName | get_edited_property() const
bool | is_selected() const
void | select(focusable: int = -1)
void | set_bottom_editor(editor: Control)
void | set_label_reference(control: Control)
void | set_object_and_property(object: Object, property: StringName)
void | update_property()

---

## Signals

multiple_properties_changed(properties: PackedStringArray, value: Array) 

Emit it if you want multiple properties modified at the same time. Do not use if added via EditorInspectorPlugin._parse_property().

---

object_id_selected(property: StringName, id: int) 

Used by sub-inspectors. Emit it if what was selected was an Object ID.

---

property_can_revert_changed(property: StringName, can_revert: bool) 

Emitted when the revertability (i.e., whether it has a non-default value and thus is displayed with a revert icon) of a property has changed.

---

property_changed(property: StringName, value: Variant, field: StringName, changing: bool) 

Do not emit this manually, use the emit_changed() method instead.

---

property_checked(property: StringName, checked: bool) 

Emitted when a property was checked. Used internally.

---

property_deleted(property: StringName) 

Emitted when a property was deleted. Used internally.

---

property_favorited(property: StringName, favorited: bool) 

Emit it if you want to mark a property as favorited, making it appear at the top of the inspector.

---

property_keyed(property: StringName) 

Emit it if you want to add this value as an animation key (check for keying being enabled first).

---

property_keyed_with_value(property: StringName, value: Variant) 

Emit it if you want to key a property with a single value.

---

property_overridden() 

Emitted when a setting override for the current project is requested.

---

property_pinned(property: StringName, pinned: bool) 

Emit it if you want to mark (or unmark) the value of a property for being saved regardless of being equal to the default value.

The default value is the one the property will get when the node is just instantiated and can come from an ancestor scene in the inheritance/instantiation chain, a script or a builtin class.

---

resource_selected(path: String, resource: Resource) 

If you want a sub-resource to be edited, emit this signal with the resource.

---

selected(path: String, focusable_idx: int) 

Emitted when selected. Used internally.

---

## Property Descriptions

bool checkable = false 

- void set_checkable(value: bool)
- bool is_checkable()

Used by the inspector, set to true when the property is checkable.

---

bool checked = false 

- void set_checked(value: bool)
- bool is_checked()

Used by the inspector, set to true when the property is checked.

---

bool deletable = false 

- void set_deletable(value: bool)
- bool is_deletable()

Used by the inspector, set to true when the property can be deleted by the user.

---

bool draw_background = true 

- void set_draw_background(value: bool)
- bool is_draw_background()

Used by the inspector, set to true when the property background is drawn.

---

bool draw_label = true 

- void set_draw_label(value: bool)
- bool is_draw_label()

Used by the inspector, set to true when the property label is drawn.

---

bool draw_warning = false 

- void set_draw_warning(value: bool)
- bool is_draw_warning()

Used by the inspector, set to true when the property is drawn with the editor theme's warning color. This is used for editable children's properties.

---

bool keying = false 

- void set_keying(value: bool)
- bool is_keying()

Used by the inspector, set to true when the property can add keys for animation.

---

String label = "" 

- void set_label(value: String)
- String get_label()

Set this property to change the label (if you want to show one).

---

float name_split_ratio = 0.5 

- void set_name_split_ratio(value: float)
- float get_name_split_ratio()

Space distribution ratio between the label and the editing field.

---

bool read_only = false 

- void set_read_only(value: bool)
- bool is_read_only()

Used by the inspector, set to true when the property is read-only.

---

bool selectable = true 

- void set_selectable(value: bool)
- bool is_selectable()

Used by the inspector, set to true when the property is selectable.

---

bool use_folding = false 

- void set_use_folding(value: bool)
- bool is_using_folding()

Used by the inspector, set to true when the property is using folding.

---

## Method Descriptions

void _set_read_only(read_only: bool) virtual 

Called when the read-only status of the property is changed. It may be used to change custom controls into a read-only or modifiable state.

---

void _update_property() virtual 

When this virtual function is called, you must update your editor.

---

void add_focusable(control: Control) 

If any of the controls added can gain keyboard focus, add it here. This ensures that focus will be restored if the inspector is refreshed.

---

void deselect() 

Draw property as not selected. Used by the inspector.

---

void emit_changed(property: StringName, value: Variant, field: StringName = &"", changing: bool = false) 

If one or several properties have changed, this must be called. field is used in case your editor can modify fields separately (as an example, Vector3.x). The changing argument avoids the editor requesting this property to be refreshed (leave as false if unsure).

---

Object get_edited_object() 

Returns the edited object.

Note: This method could return null if the editor has not yet been associated with a property. However, in _update_property() and _set_read_only(), this value is guaranteed to be non-null.

---

StringName get_edited_property() const 

Returns the edited property. If your editor is for a single property (added via EditorInspectorPlugin._parse_property()), then this will return the property.

Note: This method could return null if the editor has not yet been associated with a property. However, in _update_property() and _set_read_only(), this value is guaranteed to be non-null.

---

bool is_selected() const 

Returns true if property is drawn as selected. Used by the inspector.

---

void select(focusable: int = -1) 

Draw property as selected. Used by the inspector.

---

void set_bottom_editor(editor: Control) 

Puts the editor control below the property label. The control must be previously added using Node.add_child().

---

void set_label_reference(control: Control) 

Used by the inspector, set to a control that will be used as a reference to calculate the size of the label.

---

void set_object_and_property(object: Object, property: StringName) 

Assigns object and property to edit.

---

void update_property() 

Forces a refresh of the property display.
