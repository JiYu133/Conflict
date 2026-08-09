# Node3DGizmo

Inherits: RefCounted < Object

Inherited By: EditorNode3DGizmo

Abstract class to expose editor gizmos for Node3D.

## Description

This abstract class helps connect the Node3D scene with the editor-specific EditorNode3DGizmo class.

Node3DGizmo by itself has no exposed API, refer to Node3D.add_gizmo() and pass it an EditorNode3DGizmo instance.
