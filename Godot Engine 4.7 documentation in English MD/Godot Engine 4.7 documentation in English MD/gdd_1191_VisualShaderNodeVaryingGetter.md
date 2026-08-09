# VisualShaderNodeVaryingGetter

Inherits: VisualShaderNodeVarying < VisualShaderNode < Resource < RefCounted < Object

A visual shader node that gets a value of a varying.

## Description

Outputs a value of a varying defined in the shader. You need to first create a varying that can be used in the given function, e.g. varying getter in Fragment shader requires a varying with mode set to VisualShader.VARYING_MODE_VERTEX_TO_FRAG_LIGHT.
