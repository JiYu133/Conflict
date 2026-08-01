# Range

Inherits: Control < CanvasItem < Node < Object

Inherited By: EditorSpinSlider, ProgressBar, ScrollBar, Slider, SpinBox, TextureProgressBar

Abstract base class for controls that represent a number within a range.

## Description

Range is an abstract base class for controls that represent a number within a range, using a configured step and page size. See e.g. ScrollBar and Slider for examples of higher-level nodes using Range.

## Properties

bool | allow_greater | false
bool | allow_lesser | false
bool | exp_edit | false
float | max_value | 100.0
float | min_value | 0.0
float | page | 0.0
float | ratio |
bool | rounded | false
BitField[SizeFlags] | size_flags_vertical | 0 (overrides Control)
float | step | 0.01
float | value | 0.0

## Methods

void | _value_changed(new_value: float) virtual
void | set_value_no_signal(value: float)
void | share(with: Node)
void | unshare()

---

## Signals

changed() 

Emitted when min_value, max_value, page, or step change.

---

value_changed(value: float) 

Emitted when value changes. When used on a Slider, this is called continuously while dragging (potentially every frame). If you are performing an expensive operation in a function connected to value_changed, consider using a debouncing Timer to call the function less often.

Note: Unlike signals such as LineEdit.text_changed, value_changed is also emitted when value is set directly via code.

---

## Property Descriptions

bool allow_greater = false 

- void set_allow_greater(value: bool)
- bool is_greater_allowed()

If true, value may be greater than max_value.

---

bool allow_lesser = false 

- void set_allow_lesser(value: bool)
- bool is_lesser_allowed()

If true, value may be less than min_value.

---

bool exp_edit = false 

- void set_exp_ratio(value: bool)
- bool is_ratio_exp()

If true, and min_value is greater or equal to 0, value will be represented exponentially rather than linearly.

---

float max_value = 100.0 

- void set_max(value: float)
- float get_max()

Maximum value. Range is clamped if value is greater than max_value.

---

float min_value = 0.0 

- void set_min(value: float)
- float get_min()

Minimum value. Range is clamped if value is less than min_value.

---

float page = 0.0 

- void set_page(value: float)
- float get_page()

Page size. Used mainly for ScrollBar. A ScrollBar's grabber length is the ScrollBar's size multiplied by page over the difference between min_value and max_value.

---

float ratio 

- void set_as_ratio(value: float)
- float get_as_ratio()

The value mapped between 0 and 1.

---

bool rounded = false 

- void set_use_rounded_values(value: bool)
- bool is_using_rounded_values()

If true, value will always be rounded to the nearest integer.

---

float step = 0.01 

- void set_step(value: float)
- float get_step()

If greater than 0.0, value will always be rounded to a multiple of this property's value above min_value. For example, if min_value is 0.1 and step is 0.2, then value is limited to 0.1, 0.3, 0.5, and so on. If rounded is also true, value will first be rounded to a multiple of this property's value, then rounded to the nearest integer.

---

float value = 0.0 

- void set_value(value: float)
- float get_value()

Range's current value. Changing this property (even via code) will trigger value_changed signal. Use set_value_no_signal() if you want to avoid it.

---

## Method Descriptions

void _value_changed(new_value: float) virtual 

Called when the Range's value is changed (following the same conditions as value_changed).

---

void set_value_no_signal(value: float) 

Sets the Range's current value to the specified value, without emitting the value_changed signal.

---

void share(with: Node) 

Binds two Ranges together along with any ranges previously grouped with either of them. When any of range's member variables change, it will share the new value with all other ranges in its group.

---

void unshare() 

Stops the Range from sharing its member variables with any other.
