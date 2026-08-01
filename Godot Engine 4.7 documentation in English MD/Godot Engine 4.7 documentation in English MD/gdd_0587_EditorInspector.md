# EditorInspector

Inherits: ScrollContainer < Container < Control < CanvasItem < Node < Object

A control used to edit properties of an object.

## Description

This is the control that implements property editing in the editor's Settings dialogs, the Inspector dock, etc. To get the EditorInspector used in the editor's Inspector dock, use EditorInterface.get_inspector().

EditorInspector will show properties in the same order as the array returned by Object.get_property_list().

If a property's name is path-like (i.e. if it contains forward slashes), EditorInspector will create nested sections for "directories" along the path. For example, if a property is named highlighting/gdscript/node_path_color, it will be shown as "Node Path Color" inside the "GDScript" section nested inside the "Highlighting" section.

If a property has @GlobalScope.PROPERTY_USAGE_GROUP usage, it will group subsequent properties whose name starts with the property's hint string. The group ends when a property does not start with that hint string or when a new group starts. An empty group name effectively ends the current group. EditorInspector will create a top-level section for each group. For example, if a property with group usage is named Collide With and its hint string is collide_with_, a subsequent collide_with_area property will be shown as "Area" inside the "Collide With" section. There is also a special case: when the hint string contains the name of a property, that property is grouped too. This is mainly to help grouping properties like font, font_color and font_size (using the hint string font_).

If a property has @GlobalScope.PROPERTY_USAGE_SUBGROUP usage, a subgroup will be created in the same way as a group, and a second-level section will be created for each subgroup.

Note: Unlike sections created from path-like property names, EditorInspector won't capitalize the name for sections created from groups. So properties with group usage usually use capitalized names instead of snake_cased names.

## Properties

bool | draw_focus_border | true (overrides ScrollContainer)
FocusMode | focus_mode | 2 (overrides Control)
bool | follow_focus | true (overrides ScrollContainer)
ScrollMode | horizontal_scroll_mode | 0 (overrides ScrollContainer)

## Methods

void | collapse_all_folding()
EditorInspector | create_default_inspector(filter_line_edit: LineEdit = null) static
void | edit(object: Object)
void | expand_all_folding()
void | expand_revertable()
Object | get_edited_object()
String | get_selected_path() const
EditorProperty | instantiate_property_editor(object: Object, type: Variant.Type, path: String, hint: PropertyHint, hint_text: String, usage: int, wide: bool = false) static

---

## Signals

edited_object_changed() 

Emitted when the object being edited by the inspector has changed.

---

object_id_selected(id: int) 

Emitted when the Edit button of an Object has been pressed in the inspector. This is mainly used in the remote scene tree Inspector.

---

property_deleted(property: String) 

Emitted when a property is removed from the inspector.

---

property_edited(property: String) 

Emitted when a property is edited in the inspector.

---

property_keyed(property: String, value: Variant, advance: bool) 

Emitted when a property is keyed in the inspector. Properties can be keyed by clicking the "key" icon next to a property when the Animation panel is toggled.

---

property_selected(property: String) 

Emitted when a property is selected in the inspector.

---

property_toggled(property: String, checked: bool) 

Emitted when a boolean property is toggled in the inspector.

Note: This signal is never emitted if the internal autoclear property enabled. Since this property is always enabled in the editor inspector, this signal is never emitted by the editor itself.

---

resource_selected(resource: Resource, path: String) 

Emitted when a resource is selected in the inspector.

---

restart_requested() 

Emitted when a property that requires a restart to be applied is edited in the inspector. This is only used in the Project Settings and Editor Settings.

---

## Method Descriptions

void collapse_all_folding() 

Collapses all foldable sections.

---

EditorInspector create_default_inspector(filter_line_edit: LineEdit = null) static 

Creates an inspector with the same configuration as the one used in the editor's Inspector dock. When passing a LineEdit into filter_line_edit, the inspector will filter its properties based on LineEdit.text whenever LineEdit.text_changed is emitted.

---

void edit(object: Object) 

Shows the properties of the given object in this inspector for editing. To clear the inspector, call this method with null.

Note: If you want to edit an object in the editor's main inspector, use the edit_* methods in EditorInterface instead.

---

void expand_all_folding() 

Expands all foldable sections.

---

void expand_revertable() 

Expands only the foldable sections that contain a revertable (i.e. non-default) property.

---

Object get_edited_object() 

Returns the object currently selected in this inspector.

---

String get_selected_path() const 

Gets the path of the currently selected property.

---

EditorProperty instantiate_property_editor(object: Object, type: Variant.Type, path: String, hint: PropertyHint, hint_text: String, usage: int, wide: bool = false) static 

Creates a property editor that can be used by plugin UI to edit the specified property of an object.
