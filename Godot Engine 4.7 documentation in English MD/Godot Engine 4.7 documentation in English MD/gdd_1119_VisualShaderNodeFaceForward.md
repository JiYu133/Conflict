# VisualShaderNodeFaceForward

Inherits: VisualShaderNodeVectorBase < VisualShaderNode < Resource < RefCounted < Object

Returns the vector that points in the same direction as a reference vector within the visual shader graph.

## Description

Translates to faceforward(N, I, Nref) in the shader language. The function has three vector parameters: N, the vector to orient, I, the incident vector, and Nref, the reference vector. If the dot product of I and Nref is smaller than zero the return value is N. Otherwise, -N is returned.
