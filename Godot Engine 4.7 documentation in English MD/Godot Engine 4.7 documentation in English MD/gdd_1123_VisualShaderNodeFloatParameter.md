# VisualShaderNodeFloatParameter

Inherits: VisualShaderNodeParameter < VisualShaderNode < Resource < RefCounted < Object

A scalar float parameter to be used within the visual shader graph.

## Description

Translated to uniform float in the shader language.

## Properties

float | default_value | 0.0
bool | default_value_enabled | false
Hint | hint | 0
float | max | 1.0
float | min | 0.0
float | step | 0.1

---

## Enumerations

enum Hint
Hint HINT_NONE = 0

No hint used.

Hint HINT_RANGE = 1

A range hint for scalar value, which limits possible input values between min and max. Translated to hint_range(min, max) in shader code.

Hint HINT_RANGE_STEP = 2

A range hint for scalar value with step, which limits possible input values between min and max, with a step (increment) of step). Translated to hint_range(min, max, step) in shader code.

Hint HINT_MAX = 3

Represents the size of the Hint enum.

---

## Property Descriptions

float default_value = 0.0 

- void set_default_value(value: float)
- float get_default_value()

A default value to be assigned within the shader.

---

bool default_value_enabled = false 

- void set_default_value_enabled(value: bool)
- bool is_default_value_enabled()

Enables usage of the default_value.

---

Hint hint = 0 

- void set_hint(value: Hint)
- Hint get_hint()

A hint applied to the uniform, which controls the values it can take when set through the Inspector.

---

float max = 1.0 

- void set_max(value: float)
- float get_max()

Minimum value for range hints. Used if hint is set to HINT_RANGE or HINT_RANGE_STEP.

---

float min = 0.0 

- void set_min(value: float)
- float get_min()

Maximum value for range hints. Used if hint is set to HINT_RANGE or HINT_RANGE_STEP.

---

float step = 0.1 

- void set_step(value: float)
- float get_step()

Step (increment) value for the range hint with step. Used if hint is set to HINT_RANGE_STEP.
