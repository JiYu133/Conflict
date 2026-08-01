# VisualShaderNodeIntParameter

Inherits: VisualShaderNodeParameter < VisualShaderNode < Resource < RefCounted < Object

A visual shader node for shader parameter (uniform) of type int.

## Description

A VisualShaderNodeParameter of type int. Offers additional customization for range of accepted values.

## Properties

int | default_value | 0
bool | default_value_enabled | false
PackedStringArray | enum_names | PackedStringArray()
Hint | hint | 0
int | max | 100
int | min | 0
int | step | 1

---

## Enumerations

enum Hint
Hint HINT_NONE = 0

The parameter will not constrain its value.

Hint HINT_RANGE = 1

The parameter's value must be within the specified min/max range.

Hint HINT_RANGE_STEP = 2

The parameter's value must be within the specified range, with the given step between values.

Hint HINT_ENUM = 3

The parameter uses an enum to associate preset values to names in the editor.

Hint HINT_MAX = 4

Represents the size of the Hint enum.

---

## Property Descriptions

int default_value = 0 

- void set_default_value(value: int)
- int get_default_value()

Default value of this parameter, which will be used if not set externally. default_value_enabled must be enabled; defaults to 0 otherwise.

---

bool default_value_enabled = false 

- void set_default_value_enabled(value: bool)
- bool is_default_value_enabled()

If true, the node will have a custom default value.

---

PackedStringArray enum_names = PackedStringArray() 

- void set_enum_names(value: PackedStringArray)
- PackedStringArray get_enum_names()

The names used for the enum select in the editor. hint must be HINT_ENUM for this to take effect.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

Hint hint = 0 

- void set_hint(value: Hint)
- Hint get_hint()

Range hint of this node. Use it to customize valid parameter range.

---

int max = 100 

- void set_max(value: int)
- int get_max()

The maximum value this parameter can take. hint must be either HINT_RANGE or HINT_RANGE_STEP for this to take effect.

---

int min = 0 

- void set_min(value: int)
- int get_min()

The minimum value this parameter can take. hint must be either HINT_RANGE or HINT_RANGE_STEP for this to take effect.

---

int step = 1 

- void set_step(value: int)
- int get_step()

The step between parameter's values. Forces the parameter to be a multiple of the given value. hint must be HINT_RANGE_STEP for this to take effect.
