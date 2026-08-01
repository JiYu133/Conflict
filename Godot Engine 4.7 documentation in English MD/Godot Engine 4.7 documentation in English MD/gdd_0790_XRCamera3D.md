# XRCamera3D

Inherits: Camera3D < Node3D < Node < Object

A camera node which automatically positions itself based on XR tracking data.

## Description

A camera node which automatically positions itself based on XR tracking data.

In contrast to XRController3D, the render thread has access to more up-to-date tracking data, and the location of the XRCamera3D node can lag a few milliseconds behind what is used for rendering.

Note: If Viewport.use_xr is true, most of the camera properties are overridden by the active XRInterface. The only properties that can be trusted are the near and far planes.

## Tutorials

- XR documentation index

## Properties

PhysicsInterpolationMode | physics_interpolation_mode | 2 (overrides Node)
