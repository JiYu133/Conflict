# RDShaderSPIRV

Inherits: Resource < RefCounted < Object

SPIR-V intermediate representation as part of an RDShaderFile (used by RenderingDevice).

## Description

RDShaderSPIRV represents an RDShaderFile's SPIR-V [https://www.khronos.org/spir/] code for various shader stages, as well as possible compilation error messages. SPIR-V is a low-level intermediate shader representation. This intermediate representation is not used directly by GPUs for rendering, but it can be compiled into binary shaders that GPUs can understand. Unlike compiled shaders, SPIR-V is portable across GPU models and driver versions.

This object is used by RenderingDevice.

## Properties

PackedByteArray | bytecode_any_hit | PackedByteArray()
PackedByteArray | bytecode_closest_hit | PackedByteArray()
PackedByteArray | bytecode_compute | PackedByteArray()
PackedByteArray | bytecode_fragment | PackedByteArray()
PackedByteArray | bytecode_intersection | PackedByteArray()
PackedByteArray | bytecode_miss | PackedByteArray()
PackedByteArray | bytecode_raygen | PackedByteArray()
PackedByteArray | bytecode_tesselation_control | PackedByteArray()
PackedByteArray | bytecode_tesselation_evaluation | PackedByteArray()
PackedByteArray | bytecode_vertex | PackedByteArray()
String | compile_error_any_hit | ""
String | compile_error_closest_hit | ""
String | compile_error_compute | ""
String | compile_error_fragment | ""
String | compile_error_intersection | ""
String | compile_error_miss | ""
String | compile_error_raygen | ""
String | compile_error_tesselation_control | ""
String | compile_error_tesselation_evaluation | ""
String | compile_error_vertex | ""

## Methods

PackedByteArray | get_stage_bytecode(stage: ShaderStage) const
String | get_stage_compile_error(stage: ShaderStage) const
void | set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
void | set_stage_compile_error(stage: ShaderStage, compile_error: String)

---

## Property Descriptions

PackedByteArray bytecode_any_hit = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the any hit shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_closest_hit = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the closest hit shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_compute = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the compute shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_fragment = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the fragment shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_intersection = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the intersection shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_miss = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the miss shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_raygen = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the ray generation shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_tesselation_control = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the tessellation control shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_tesselation_evaluation = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the tessellation evaluation shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

PackedByteArray bytecode_vertex = PackedByteArray() 

- void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray)
- PackedByteArray get_stage_bytecode(stage: ShaderStage) const

The SPIR-V bytecode for the vertex shader stage.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

String compile_error_any_hit = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the any hit shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_closest_hit = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the closest hit shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_compute = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the compute shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_fragment = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the fragment shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_intersection = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the intersection shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_miss = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the miss shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_raygen = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the ray generation shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_tesselation_control = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the tessellation control shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_tesselation_evaluation = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the tessellation evaluation shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

String compile_error_vertex = "" 

- void set_stage_compile_error(stage: ShaderStage, compile_error: String)
- String get_stage_compile_error(stage: ShaderStage) const

The compilation error message for the vertex shader stage (set by the SPIR-V compiler and Godot). If empty, shader compilation was successful.

---

## Method Descriptions

PackedByteArray get_stage_bytecode(stage: ShaderStage) const 

Equivalent to getting one of bytecode_compute, bytecode_fragment, bytecode_tesselation_control, bytecode_tesselation_evaluation, bytecode_vertex.

---

String get_stage_compile_error(stage: ShaderStage) const 

Returns the compilation error message for the given shader stage. Equivalent to getting one of compile_error_compute, compile_error_fragment, compile_error_tesselation_control, compile_error_tesselation_evaluation, compile_error_vertex.

---

void set_stage_bytecode(stage: ShaderStage, bytecode: PackedByteArray) 

Sets the SPIR-V bytecode for the given shader stage. Equivalent to setting one of bytecode_compute, bytecode_fragment, bytecode_tesselation_control, bytecode_tesselation_evaluation, bytecode_vertex.

---

void set_stage_compile_error(stage: ShaderStage, compile_error: String) 

Sets the compilation error message for the given shader stage to compile_error. Equivalent to setting one of compile_error_compute, compile_error_fragment, compile_error_tesselation_control, compile_error_tesselation_evaluation, compile_error_vertex.
