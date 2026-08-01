# RDPipelineRasterizationState

Inherits: RefCounted < Object

Pipeline rasterization state (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

PolygonCullMode | cull_mode | 0
float | depth_bias_clamp | 0.0
float | depth_bias_constant_factor | 0.0
bool | depth_bias_enabled | false
float | depth_bias_slope_factor | 0.0
bool | discard_primitives | false
bool | enable_depth_clamp | false
PolygonFrontFace | front_face | 0
float | line_width | 1.0
int | patch_control_points | 1
bool | wireframe | false

---

## Property Descriptions

PolygonCullMode cull_mode = 0 

- void set_cull_mode(value: PolygonCullMode)
- PolygonCullMode get_cull_mode()

The cull mode to use when drawing polygons, which determines whether front faces or backfaces are hidden.

---

float depth_bias_clamp = 0.0 

- void set_depth_bias_clamp(value: float)
- float get_depth_bias_clamp()

A limit for how much each depth value can be offset. If negative, it serves as a minimum value, but if positive, it serves as a maximum value.

---

float depth_bias_constant_factor = 0.0 

- void set_depth_bias_constant_factor(value: float)
- float get_depth_bias_constant_factor()

A constant offset added to each depth value. Applied after depth_bias_slope_factor.

---

bool depth_bias_enabled = false 

- void set_depth_bias_enabled(value: bool)
- bool get_depth_bias_enabled()

If true, each generated depth value will by offset by some amount. The specific amount is generated per polygon based on the values of depth_bias_slope_factor and depth_bias_constant_factor.

---

float depth_bias_slope_factor = 0.0 

- void set_depth_bias_slope_factor(value: float)
- float get_depth_bias_slope_factor()

A constant scale applied to the slope of each polygons' depth. Applied before depth_bias_constant_factor.

---

bool discard_primitives = false 

- void set_discard_primitives(value: bool)
- bool get_discard_primitives()

If true, primitives are discarded immediately before the rasterization stage.

---

bool enable_depth_clamp = false 

- void set_enable_depth_clamp(value: bool)
- bool get_enable_depth_clamp()

If true, clamps depth values according to the minimum and maximum depth of the associated viewport.

---

PolygonFrontFace front_face = 0 

- void set_front_face(value: PolygonFrontFace)
- PolygonFrontFace get_front_face()

The winding order to use to determine which face of a triangle is considered its front face.

---

float line_width = 1.0 

- void set_line_width(value: float)
- float get_line_width()

The line width to use when drawing lines (in pixels). Thick lines may not be supported on all hardware.

---

int patch_control_points = 1 

- void set_patch_control_points(value: int)
- int get_patch_control_points()

The number of control points to use when drawing a patch with tessellation enabled. Higher values result in higher quality at the cost of performance.

---

bool wireframe = false 

- void set_wireframe(value: bool)
- bool get_wireframe()

If true, performs wireframe rendering for triangles instead of flat or textured rendering.
