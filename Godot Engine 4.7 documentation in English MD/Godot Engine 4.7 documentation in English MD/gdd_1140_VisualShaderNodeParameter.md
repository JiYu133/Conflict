# VisualShaderNodeParameter

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeBooleanParameter, VisualShaderNodeColorParameter, VisualShaderNodeFloatParameter, VisualShaderNodeIntParameter, VisualShaderNodeTextureParameter, VisualShaderNodeTransformParameter, VisualShaderNodeUIntParameter, VisualShaderNodeVec2Parameter, VisualShaderNodeVec3Parameter, VisualShaderNodeVec4Parameter

A base type for the parameters within the visual shader graph.

## Description

A parameter represents a variable in the shader which is set externally, i.e. from the ShaderMaterial. Parameters are exposed as properties in the ShaderMaterial and can be assigned from the Inspector or from a script.

## Properties

int | instance_index | 0
String | parameter_name | ""
Qualifier | qualifier | 0

---

## Enumerations

enum Qualifier
Qualifier QUAL_NONE = 0

The parameter will be tied to the ShaderMaterial using this shader.

Qualifier QUAL_GLOBAL = 1

The parameter will use a global value, defined in Project Settings.

Qualifier QUAL_INSTANCE = 2

The parameter will be tied to the node with attached ShaderMaterial using this shader.

Qualifier QUAL_INSTANCE_INDEX = 3

The parameter will be tied to the node with attached ShaderMaterial using this shader. Enables setting a instance_index property.

Qualifier QUAL_MAX = 4

Represents the size of the Qualifier enum.

---

## Property Descriptions

int instance_index = 0 

- void set_instance_index(value: int)
- int get_instance_index()

The index within 0-15 range, which is used to avoid clashes when shader used on multiple materials.

---

String parameter_name = "" 

- void set_parameter_name(value: String)
- String get_parameter_name()

Name of the parameter, by which it can be accessed through the ShaderMaterial properties.

---

Qualifier qualifier = 0 

- void set_qualifier(value: Qualifier)
- Qualifier get_qualifier()

Defines the scope of the parameter.
