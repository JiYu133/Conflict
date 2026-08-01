# VisualShaderNodeVaryingSetter

Inherits: VisualShaderNodeVarying < VisualShaderNode < Resource < RefCounted < Object

A visual shader node that sets a value of a varying.

## Description

Inputs a value to a varying defined in the shader. You need to first create a varying that can be used in the given function, e.g. varying setter in Fragment shader requires a varying with mode set to VisualShader.VARYING_MODE_FRAG_TO_LIGHT.
