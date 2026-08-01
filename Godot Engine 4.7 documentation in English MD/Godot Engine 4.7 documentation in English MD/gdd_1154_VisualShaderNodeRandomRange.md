# VisualShaderNodeRandomRange

Inherits: VisualShaderNode < Resource < RefCounted < Object

A visual shader node that generates a pseudo-random scalar.

## Description

Random range node will output a pseudo-random scalar value in the specified range, based on the seed. The value is always the same for the given seed and range, so you should provide a changing input, e.g. by using time.
