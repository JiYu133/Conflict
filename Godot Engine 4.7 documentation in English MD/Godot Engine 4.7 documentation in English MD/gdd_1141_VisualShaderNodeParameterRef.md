# VisualShaderNodeParameterRef

Inherits: VisualShaderNode < Resource < RefCounted < Object

A reference to an existing VisualShaderNodeParameter.

## Description

Creating a reference to a VisualShaderNodeParameter allows you to reuse this parameter in different shaders or shader stages easily.

## Properties

String | parameter_name | "[None]"

---

## Property Descriptions

String parameter_name = "[None]" 

- void set_parameter_name(value: String)
- String get_parameter_name()

The name of the parameter which this reference points to.
