# XRFaceModifier3D

Experimental: This class may be changed or removed in future versions.

Inherits: Node3D < Node < Object

A node for driving standard face meshes from XRFaceTracker weights.

## Description

This node applies weights from an XRFaceTracker to a mesh with supporting face blend shapes.

The Unified Expressions [https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/unified-blendshapes] blend shapes are supported, as well as ARKit and SRanipal blend shapes.

The node attempts to identify blend shapes based on name matching. Blend shapes should match the names listed in the Unified Expressions Compatibility [https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/compatibility/overview] chart.

## Tutorials

- XR documentation index

## Properties

StringName | face_tracker | &"/user/face_tracker"
NodePath | target | NodePath("")

---

## Property Descriptions

StringName face_tracker = &"/user/face_tracker" 

- void set_face_tracker(value: StringName)
- StringName get_face_tracker()

The XRFaceTracker path.

---

NodePath target = NodePath("") 

- void set_target(value: NodePath)
- NodePath get_target()

The NodePath of the face MeshInstance3D.
