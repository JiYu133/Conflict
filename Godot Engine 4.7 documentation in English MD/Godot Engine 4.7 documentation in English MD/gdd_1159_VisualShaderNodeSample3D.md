# VisualShaderNodeSample3D

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeTexture2DArray, VisualShaderNodeTexture3D

A base node for nodes which samples 3D textures in the visual shader graph.

## Description

A virtual class, use the descendants instead.

## Properties

Source | source | 0

---

## Enumerations

enum Source
Source SOURCE_TEXTURE = 0

Creates internal uniform and provides a way to assign it within node.

Source SOURCE_PORT = 1

Use the uniform texture from sampler port.

Source SOURCE_MAX = 2

Represents the size of the Source enum.

---

## Property Descriptions

Source source = 0 

- void set_source(value: Source)
- Source get_source()

An input source type.
