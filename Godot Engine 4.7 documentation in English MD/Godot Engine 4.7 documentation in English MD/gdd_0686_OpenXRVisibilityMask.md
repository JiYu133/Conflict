# OpenXRVisibilityMask

Inherits: VisualInstance3D < Node3D < Node < Object

Draws a stereo correct visibility mask.

## Description

The visibility mask allows us to black out the part of the render result that is invisible due to lens distortion.

As this is rendered first, it prevents fragments with expensive lighting calculations to be processed as they are discarded through z-checking.
