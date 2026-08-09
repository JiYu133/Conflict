# RDPipelineColorBlendStateAttachment

Inherits: RefCounted < Object

Pipeline color blend state attachment (used by RenderingDevice).

## Description

Controls how blending between source and destination fragments is performed when using RenderingDevice.

For reference, this is how common user-facing blend modes are implemented in Godot's 2D renderer:

Mix:

```gdscript
var attachment = RDPipelineColorBlendStateAttachment.new()
attachment.enable_blend = true
attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
```

Add:

```gdscript
var attachment = RDPipelineColorBlendStateAttachment.new()
attachment.enable_blend = true
attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
```

Subtract:

```gdscript
var attachment = RDPipelineColorBlendStateAttachment.new()
attachment.enable_blend = true
attachment.alpha_blend_op = RenderingDevice.BLEND_OP_REVERSE_SUBTRACT
attachment.color_blend_op = RenderingDevice.BLEND_OP_REVERSE_SUBTRACT
attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
```

Multiply:

```gdscript
var attachment = RDPipelineColorBlendStateAttachment.new()
attachment.enable_blend = true
attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_DST_COLOR
attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ZERO
attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_DST_ALPHA
attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ZERO
```

Pre-multiplied alpha:

```gdscript
var attachment = RDPipelineColorBlendStateAttachment.new()
attachment.enable_blend = true
attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
```

## Properties

BlendOperation | alpha_blend_op | 0
BlendOperation | color_blend_op | 0
BlendFactor | dst_alpha_blend_factor | 0
BlendFactor | dst_color_blend_factor | 0
bool | enable_blend | false
BlendFactor | src_alpha_blend_factor | 0
BlendFactor | src_color_blend_factor | 0
bool | write_a | true
bool | write_b | true
bool | write_g | true
bool | write_r | true

## Methods

void | set_as_mix()

---

## Property Descriptions

BlendOperation alpha_blend_op = 0 

- void set_alpha_blend_op(value: BlendOperation)
- BlendOperation get_alpha_blend_op()

The blend mode to use for the alpha channel.

---

BlendOperation color_blend_op = 0 

- void set_color_blend_op(value: BlendOperation)
- BlendOperation get_color_blend_op()

The blend mode to use for the red/green/blue color channels.

---

BlendFactor dst_alpha_blend_factor = 0 

- void set_dst_alpha_blend_factor(value: BlendFactor)
- BlendFactor get_dst_alpha_blend_factor()

Controls how the blend factor for the alpha channel is determined based on the destination's fragments.

---

BlendFactor dst_color_blend_factor = 0 

- void set_dst_color_blend_factor(value: BlendFactor)
- BlendFactor get_dst_color_blend_factor()

Controls how the blend factor for the color channels is determined based on the destination's fragments.

---

bool enable_blend = false 

- void set_enable_blend(value: bool)
- bool get_enable_blend()

If true, performs blending between the source and destination according to the factors defined in src_color_blend_factor, dst_color_blend_factor, src_alpha_blend_factor and dst_alpha_blend_factor. The blend modes color_blend_op and alpha_blend_op are also taken into account, with write_r, write_g, write_b and write_a controlling the output.

---

BlendFactor src_alpha_blend_factor = 0 

- void set_src_alpha_blend_factor(value: BlendFactor)
- BlendFactor get_src_alpha_blend_factor()

Controls how the blend factor for the alpha channel is determined based on the source's fragments.

---

BlendFactor src_color_blend_factor = 0 

- void set_src_color_blend_factor(value: BlendFactor)
- BlendFactor get_src_color_blend_factor()

Controls how the blend factor for the color channels is determined based on the source's fragments.

---

bool write_a = true 

- void set_write_a(value: bool)
- bool get_write_a()

If true, writes the new alpha channel to the final result.

---

bool write_b = true 

- void set_write_b(value: bool)
- bool get_write_b()

If true, writes the new blue color channel to the final result.

---

bool write_g = true 

- void set_write_g(value: bool)
- bool get_write_g()

If true, writes the new green color channel to the final result.

---

bool write_r = true 

- void set_write_r(value: bool)
- bool get_write_r()

If true, writes the new red color channel to the final result.

---

## Method Descriptions

void set_as_mix() 

Convenience method to perform standard mix blending with straight (non-premultiplied) alpha. This sets enable_blend to true, src_color_blend_factor to RenderingDevice.BLEND_FACTOR_SRC_ALPHA, dst_color_blend_factor to RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA, src_alpha_blend_factor to RenderingDevice.BLEND_FACTOR_SRC_ALPHA and dst_alpha_blend_factor to RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA.
