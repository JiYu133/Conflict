# RDShaderFile

Inherits: Resource < RefCounted < Object

Compiled shader file in SPIR-V form (used by RenderingDevice). Not to be confused with Godot's own Shader.

## Description

Compiled shader file in SPIR-V form.

See also RDShaderSource. RDShaderFile is only meant to be used with the RenderingDevice API. It should not be confused with Godot's own Shader resource, which is what Godot's various nodes use for high-level shader programming.

## Properties

String | base_error | ""

## Methods

RDShaderSPIRV | get_spirv(version: StringName = &"") const
Array[StringName] | get_version_list() const
void | set_bytecode(bytecode: RDShaderSPIRV, version: StringName = &"")

---

## Property Descriptions

String base_error = "" 

- void set_base_error(value: String)
- String get_base_error()

The base compilation error message, which indicates errors not related to a specific shader stage if non-empty. If empty, shader compilation is not necessarily successful (check RDShaderSPIRV's error message members).

---

## Method Descriptions

RDShaderSPIRV get_spirv(version: StringName = &"") const 

Returns the SPIR-V intermediate representation for the specified shader version.

---

Array[StringName] get_version_list() const 

Returns the list of compiled versions for this shader.

---

void set_bytecode(bytecode: RDShaderSPIRV, version: StringName = &"") 

Sets the SPIR-V bytecode that will be compiled for the specified version.
