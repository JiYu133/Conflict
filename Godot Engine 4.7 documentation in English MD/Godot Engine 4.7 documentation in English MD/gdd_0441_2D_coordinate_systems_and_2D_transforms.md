# 2D coordinate systems and 2D transforms

## Introduction

This is a detailed overview of the available 2D coordinate systems and 2D transforms that are
built in. The basic concepts are covered in Viewport and canvas transforms.

Transform2D are matrices that convert coordinates from one coordinate
system to another. In order to use them, it is beneficial to know which coordinate systems are
available in Godot. For a deeper understanding, the Matrices and transforms tutorial
offers insights to the underlying functionality.

## Godot 2D coordinate systems

The following graphic gives an overview of Godot 2D coordinate systems and the available
node-transforms, transform-functions and coordinate-system related functions. At the left
is the OS Window Manager screen, at the right are the CanvasItems. For
simplicity reasons this graphic doesn't include SubViewport,
SubViewportContainer, ParallaxLayer
and ParallaxBackground all of which also influence transforms.

The graphic is based on a node tree of the following form: Root Window (embed Windows) ⇒
Window (don't embed Windows) ⇒ CanvasLayer ⇒ CanvasItem ⇒ CanvasItem ⇒
CanvasItem. There are more complex combinations possible, like deeply nested Window and
SubViewports, however this example intends to provide an overview of the methodology in general.

../../_images/transforms_overview.png

Click graphic to enlarge.

- Item CoordinatesThis is the local coordinate system of a CanvasItem.
- Parent Item CoordinatesThis is the local coordinate system of the parent's CanvasItem. When positioning
CanvasItems in the Canvas, they usually inherit the transformations of their parent
CanvasItems. An exceptions is
CanvasItems.top_level.
- Canvas CoordinatesAs mentioned in the previous tutorial Canvas layers, there are two types of canvases
(Viewport canvas and CanvasLayer canvas) and both have a canvas coordinate system. These
are also called world coordinates. A Viewport can contain multiple Canvases with different
coordinate systems.
- Viewport CoordinatesThis is the coordinate system of the Viewport.
- Camera CoordinatesThis is only used internally for functionality like 3D-camera ray projections.
- Embedder Coordinates / Screen CoordinatesEvery Viewport (Window or SubViewport) in the scene tree is embedded either in a
different node or in the OS Window Manager. This coordinate system's origin is identical to the
top-left corner of the Window or SubViewport and its scale is the one of the embedder or
the OS Window Manager.
If the embedder is the OS Window Manager, then they are also called Screen Coordinates.
- Absolute Embedder Coordinates / Absolute Screen CoordinatesThe origin of this coordinate system is the top-left corner of the embedding node or the OS
Window Manager screen. Its scale is the one of the embedder or the OS Window Manager.
If the embedder is the OS Window Manager, then they are also called Absolute Screen
Coordinates.

## Node transforms

Each of the mentioned nodes have one or more transforms associated with them and the combination of
these nodes infer the transforms between the different coordinate systems. With a few exceptions,
the transforms are Transform2D and the following list shows details and
effects of each of them.

- CanvasItem transformCanvasItems are either Control-nodes or Node2D-nodes.
For Control nodes this transform consists of a position
relative to the parent's origin and a scale and
rotation around a
pivot point.
For Node2D nodes transform consists of
position, rotation,
scale and skew.
The transform affects the item itself and usually also child-CanvasItems and in the case of a
SubViewportContainer it affects the contained SubViewport.
- CanvasLayer transformThe CanvasLayer's transform affects all
CanvasItems within the CanvasLayer. It doesn't affect other CanvasLayers or Windows in
its Viewport.
- CanvasLayer follow viewport transformThe follow viewport transform is an automatically calculated transform, that is based on the
Viewport's canvas transform and the
CanvasLayer's follow viewport scale
and can be used, if enabled, to
achieve a pseudo-3D effect. It affects the same child nodes as the CanvasLayer transform.
- Viewport canvas transformThe canvas transform affects all
CanvasItems in the Viewport's default canvas. It also affects CanvasLayers, that have
follow viewport transform enabled. The Viewport's active Camera2D
works by changing this transform. It doesn't affect this Viewport's embedded Windows.
- Viewport global canvas transformViewports also have a global canvas transform.
This is the master transform and affects all individual Canvas Layer and embedded Window
transforms. This is primarily used in Godot's CanvasItem Editor.
- Viewport stretch transformFinally, Viewports have a stretch transform, which is used when resizing or stretching the
viewport. This transform is used for Windows as described in
Multiple resolutions, but can also be manually set on SubViewports by means of
size and
size_2d_override. Its
translation,
rotation and
skew are the default values and it can only have
non-default scale.
- Window transformIn order to scale and position the Window's content as described in
Multiple resolutions, each Window contains a
window transform. It is for example responsible for the black bars at the Window's sides so
that the Viewport is displayed with a fixed aspect ratio.
- Window positionEvery Window also has a position to describe its
position within its embedder. The embedder can be another Viewport or the OS Window Manager.
- SubViewportContainer shrink transformstretch together with
stretch_shrink declare for a
SubViewportContainer if and by what integer factor the contained SubViewport should be
scaled in comparison to the container's size.
