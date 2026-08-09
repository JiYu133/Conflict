# RDPipelineMultisampleState

Inherits: RefCounted < Object

Pipeline multisample state (used by RenderingDevice).

## Description

RDPipelineMultisampleState is used to control how multisample or supersample antialiasing is being performed when rendering using RenderingDevice.

## Properties

bool | enable_alpha_to_coverage | false
bool | enable_alpha_to_one | false
bool | enable_sample_shading | false
float | min_sample_shading | 0.0
TextureSamples | sample_count | 0
Array[int] | sample_masks | []

---

## Property Descriptions

bool enable_alpha_to_coverage = false 

- void set_enable_alpha_to_coverage(value: bool)
- bool get_enable_alpha_to_coverage()

If true, alpha to coverage is enabled. This generates a temporary coverage value based on the alpha component of the fragment's first color output. This allows alpha transparency to make use of multisample antialiasing.

---

bool enable_alpha_to_one = false 

- void set_enable_alpha_to_one(value: bool)
- bool get_enable_alpha_to_one()

If true, alpha is forced to either 0.0 or 1.0. This allows hardening the edges of antialiased alpha transparencies. Only relevant if enable_alpha_to_coverage is true.

---

bool enable_sample_shading = false 

- void set_enable_sample_shading(value: bool)
- bool get_enable_sample_shading()

If true, enables per-sample shading which replaces MSAA by SSAA. This provides higher quality antialiasing that works with transparent (alpha scissor) edges. This has a very high performance cost. See also min_sample_shading. See the per-sample shading Vulkan documentation [https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#primsrast-sampleshading] for more details.

---

float min_sample_shading = 0.0 

- void set_min_sample_shading(value: float)
- float get_min_sample_shading()

The multiplier of sample_count that determines how many samples are performed for each fragment. Must be between 0.0 and 1.0 (inclusive). Only effective if enable_sample_shading is true. If min_sample_shading is 1.0, fragment invocation must only read from the coverage index sample. Tile image access must not be used if enable_sample_shading is not 1.0.

---

TextureSamples sample_count = 0 

- void set_sample_count(value: TextureSamples)
- TextureSamples get_sample_count()

The number of MSAA samples (or SSAA samples if enable_sample_shading is true) to perform. Higher values result in better antialiasing, at the cost of performance.

---

Array[int] sample_masks = [] 

- void set_sample_masks(value: Array[int])
- Array[int] get_sample_masks()

The sample mask array. See the sample mask Vulkan documentation [https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#fragops-samplemask] for more details.
