# RDPipelineDepthStencilState

Inherits: RefCounted < Object

Pipeline depth/stencil state (used by RenderingDevice).

## Description

RDPipelineDepthStencilState controls the way depth and stencil comparisons are performed when sampling those values using RenderingDevice.

## Properties

CompareOperator | back_op_compare | 7
int | back_op_compare_mask | 0
StencilOperation | back_op_depth_fail | 1
StencilOperation | back_op_fail | 1
StencilOperation | back_op_pass | 1
int | back_op_reference | 0
int | back_op_write_mask | 0
CompareOperator | depth_compare_operator | 7
float | depth_range_max | 0.0
float | depth_range_min | 0.0
bool | enable_depth_range | false
bool | enable_depth_test | false
bool | enable_depth_write | false
bool | enable_stencil | false
CompareOperator | front_op_compare | 7
int | front_op_compare_mask | 0
StencilOperation | front_op_depth_fail | 1
StencilOperation | front_op_fail | 1
StencilOperation | front_op_pass | 1
int | front_op_reference | 0
int | front_op_write_mask | 0

---

## Property Descriptions

CompareOperator back_op_compare = 7 

- void set_back_op_compare(value: CompareOperator)
- CompareOperator get_back_op_compare()

The method used for comparing the previous back stencil value and back_op_reference.

---

int back_op_compare_mask = 0 

- void set_back_op_compare_mask(value: int)
- int get_back_op_compare_mask()

Selects which bits from the back stencil value will be compared.

---

StencilOperation back_op_depth_fail = 1 

- void set_back_op_depth_fail(value: StencilOperation)
- StencilOperation get_back_op_depth_fail()

The operation to perform on the stencil buffer for back pixels that pass the stencil test but fail the depth test.

---

StencilOperation back_op_fail = 1 

- void set_back_op_fail(value: StencilOperation)
- StencilOperation get_back_op_fail()

The operation to perform on the stencil buffer for back pixels that fail the stencil test.

---

StencilOperation back_op_pass = 1 

- void set_back_op_pass(value: StencilOperation)
- StencilOperation get_back_op_pass()

The operation to perform on the stencil buffer for back pixels that pass the stencil test.

---

int back_op_reference = 0 

- void set_back_op_reference(value: int)
- int get_back_op_reference()

The value the previous back stencil value will be compared to.

---

int back_op_write_mask = 0 

- void set_back_op_write_mask(value: int)
- int get_back_op_write_mask()

Selects which bits from the back stencil value will be changed.

---

CompareOperator depth_compare_operator = 7 

- void set_depth_compare_operator(value: CompareOperator)
- CompareOperator get_depth_compare_operator()

The method used for comparing the previous and current depth values.

---

float depth_range_max = 0.0 

- void set_depth_range_max(value: float)
- float get_depth_range_max()

The maximum depth that returns true for enable_depth_range.

---

float depth_range_min = 0.0 

- void set_depth_range_min(value: float)
- float get_depth_range_min()

The minimum depth that returns true for enable_depth_range.

---

bool enable_depth_range = false 

- void set_enable_depth_range(value: bool)
- bool get_enable_depth_range()

If true, each depth value will be tested to see if it is between depth_range_min and depth_range_max. If it is outside of these values, it is discarded.

---

bool enable_depth_test = false 

- void set_enable_depth_test(value: bool)
- bool get_enable_depth_test()

If true, enables depth testing which allows objects to be automatically occluded by other objects based on their depth. This also allows objects to be partially occluded by other objects. If false, objects will appear in the order they were drawn (like in Godot's 2D renderer).

---

bool enable_depth_write = false 

- void set_enable_depth_write(value: bool)
- bool get_enable_depth_write()

If true, writes to the depth buffer whenever the depth test returns true. Only works when enable_depth_test is also true.

---

bool enable_stencil = false 

- void set_enable_stencil(value: bool)
- bool get_enable_stencil()

If true, enables stencil testing. There are separate stencil buffers for front-facing triangles and back-facing triangles. See properties that begin with "front_op" and properties with "back_op" for each.

---

CompareOperator front_op_compare = 7 

- void set_front_op_compare(value: CompareOperator)
- CompareOperator get_front_op_compare()

The method used for comparing the previous front stencil value and front_op_reference.

---

int front_op_compare_mask = 0 

- void set_front_op_compare_mask(value: int)
- int get_front_op_compare_mask()

Selects which bits from the front stencil value will be compared.

---

StencilOperation front_op_depth_fail = 1 

- void set_front_op_depth_fail(value: StencilOperation)
- StencilOperation get_front_op_depth_fail()

The operation to perform on the stencil buffer for front pixels that pass the stencil test but fail the depth test.

---

StencilOperation front_op_fail = 1 

- void set_front_op_fail(value: StencilOperation)
- StencilOperation get_front_op_fail()

The operation to perform on the stencil buffer for front pixels that fail the stencil test.

---

StencilOperation front_op_pass = 1 

- void set_front_op_pass(value: StencilOperation)
- StencilOperation get_front_op_pass()

The operation to perform on the stencil buffer for front pixels that pass the stencil test.

---

int front_op_reference = 0 

- void set_front_op_reference(value: int)
- int get_front_op_reference()

The value the previous front stencil value will be compared to.

---

int front_op_write_mask = 0 

- void set_front_op_write_mask(value: int)
- int get_front_op_write_mask()

Selects which bits from the front stencil value will be changed.
