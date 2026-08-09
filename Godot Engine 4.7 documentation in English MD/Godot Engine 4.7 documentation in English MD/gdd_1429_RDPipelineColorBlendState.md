# RDPipelineColorBlendState

Inherits: RefCounted < Object

Pipeline color blend state (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

Array[RDPipelineColorBlendStateAttachment] | attachments | []
Color | blend_constant | Color(0, 0, 0, 1)
bool | enable_logic_op | false
LogicOperation | logic_op | 0

---

## Property Descriptions

Array[RDPipelineColorBlendStateAttachment] attachments = [] 

- void set_attachments(value: Array[RDPipelineColorBlendStateAttachment])
- Array[RDPipelineColorBlendStateAttachment] get_attachments()

The attachments that are blended together.

---

Color blend_constant = Color(0, 0, 0, 1) 

- void set_blend_constant(value: Color)
- Color get_blend_constant()

The constant color to blend with. See also RenderingDevice.draw_list_set_blend_constants().

---

bool enable_logic_op = false 

- void set_enable_logic_op(value: bool)
- bool get_enable_logic_op()

If true, performs the logic operation defined in logic_op.

---

LogicOperation logic_op = 0 

- void set_logic_op(value: LogicOperation)
- LogicOperation get_logic_op()

The logic operation to perform for blending. Only effective if enable_logic_op is true.
