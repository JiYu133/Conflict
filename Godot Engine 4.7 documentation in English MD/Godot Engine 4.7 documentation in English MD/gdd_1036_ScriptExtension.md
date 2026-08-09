# ScriptExtension

Inherits: Script < Resource < RefCounted < Object

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Methods

bool | _can_instantiate() virtual required const
bool | _editor_can_reload_from_file() virtual required
Script | _get_base_script() virtual required const
String | _get_class_icon_path() virtual const
Dictionary | _get_constants() virtual required const
StringName | _get_doc_class_name() virtual required const
Array[Dictionary] | _get_documentation() virtual required const
StringName | _get_global_name() virtual required const
StringName | _get_instance_base_type() virtual required const
ScriptLanguage | _get_language() virtual required const
int | _get_member_line(member: StringName) virtual required const
Array[StringName] | _get_members() virtual required const
Dictionary | _get_method_info(method: StringName) virtual required const
Variant | _get_property_default_value(property: StringName) virtual required const
Variant | _get_rpc_config() virtual required const
Variant | _get_script_method_argument_count(method: StringName) virtual const
Array[Dictionary] | _get_script_method_list() virtual required const
Array[Dictionary] | _get_script_property_list() virtual required const
Array[Dictionary] | _get_script_signal_list() virtual required const
String | _get_source_code() virtual required const
bool | _has_method(method: StringName) virtual required const
bool | _has_property_default_value(property: StringName) virtual required const
bool | _has_script_signal(signal: StringName) virtual required const
bool | _has_source_code() virtual required const
bool | _has_static_method(method: StringName) virtual required const
bool | _inherits_script(script: Script) virtual required const
void* | _instance_create(for_object: Object) virtual required const
bool | _instance_has(object: Object) virtual const
bool | _is_abstract() virtual const
bool | _is_placeholder_fallback_enabled() virtual required const
bool | _is_tool() virtual required const
bool | _is_valid() virtual required const
void | _placeholder_erased(placeholder: void*) virtual
void* | _placeholder_instance_create(for_object: Object) virtual required const
Error | _reload(keep_state: bool) virtual required
void | _set_source_code(code: String) virtual required
void | _update_exports() virtual required

---

## Method Descriptions

bool _can_instantiate() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _editor_can_reload_from_file() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Script _get_base_script() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _get_class_icon_path() virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _get_constants() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

StringName _get_doc_class_name() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_documentation() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

StringName _get_global_name() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

StringName _get_instance_base_type() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

ScriptLanguage _get_language() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_member_line(member: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[StringName] _get_members() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary _get_method_info(method: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _get_property_default_value(property: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _get_rpc_config() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _get_script_method_argument_count(method: StringName) virtual const 

Return the expected argument count for the given method, or null if it can't be determined (which will then fall back to the default behavior).

---

Array[Dictionary] _get_script_method_list() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_script_property_list() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[Dictionary] _get_script_signal_list() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String _get_source_code() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_method(method: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_property_default_value(property: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_script_signal(signal: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_source_code() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _has_static_method(method: StringName) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _inherits_script(script: Script) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void* _instance_create(for_object: Object) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _instance_has(object: Object) virtual const 

Deprecated: This method is not called by the engine.

---

bool _is_abstract() virtual const 

Returns true if the script is an abstract script. Abstract scripts cannot be instantiated directly, instead other scripts should inherit them. Abstract scripts will be either unselectable or hidden in the Create New Node dialog (unselectable if there are non-abstract classes inheriting it, otherwise hidden).

---

bool _is_placeholder_fallback_enabled() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_tool() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_valid() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _placeholder_erased(placeholder: void*) virtual 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void* _placeholder_instance_create(for_object: Object) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Error _reload(keep_state: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_source_code(code: String) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _update_exports() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
