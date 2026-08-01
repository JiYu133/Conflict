# CanvasLayer

Inherits: Node < Object

Inherited By: ParallaxBackground

A node used for independent rendering of objects within a 2D scene.

## Description

CanvasItem-derived nodes that are direct or indirect children of a CanvasLayer will be drawn in that layer. The layer is a numeric index that defines the draw order. The default 2D scene renders with index 0, so a CanvasLayer with index -1 will be drawn below, and a CanvasLayer with index 1 will be drawn above. This order will hold regardless of the CanvasItem.z_index of the nodes within each layer.

CanvasLayers can be hidden and they can also optionally follow the viewport. This makes them useful for HUDs like health bar overlays (on layers 1 and higher) or backgrounds (on layers -1 and lower).

Note: Embedded Windows are placed on layer 1024. CanvasItems on layers 1025 and higher appear in front of embedded windows.

Note: Each CanvasLayer is drawn on one specific Viewport and cannot be shared between multiple Viewports, see custom_viewport. When using multiple Viewports, for example in a split-screen game, you need to create an individual CanvasLayer for each Viewport you want it to be drawn on.

## Tutorials

- Viewport and canvas transforms
- Canvas layers
- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]

## Properties

Node | custom_viewport |
bool | follow_viewport_enabled | false
float | follow_viewport_scale | 1.0
int | layer | 1
Vector2 | offset | Vector2(0, 0)
float | rotation | 0.0
Vector2 | scale | Vector2(1, 1)
Transform2D | transform | Transform2D(1, 0, 0, 1, 0, 0)
bool | visible | true

## Methods

RID | get_canvas() const
Transform2D | get_final_transform() const
void | hide()
void | show()

---

## Signals

visibility_changed() 

Emitted when visibility of the layer is changed. See visible.

---

## Property Descriptions

Node custom_viewport 

- void set_custom_viewport(value: Node)
- Node get_custom_viewport()

The custom Viewport node assigned to the CanvasLayer. If null, uses the default viewport instead.

---

bool follow_viewport_enabled = false 

- void set_follow_viewport(value: bool)
- bool is_following_viewport()

If enabled, the CanvasLayer maintains its position in world space. If disabled, the CanvasLayer stays in a fixed position on the screen.

Together with follow_viewport_scale, this can be used for a pseudo-3D effect.

---

float follow_viewport_scale = 1.0 

- void set_follow_viewport_scale(value: float)
- float get_follow_viewport_scale()

Scales the layer when using follow_viewport_enabled. Layers moving into the foreground should have increasing scales, while layers moving into the background should have decreasing scales.

---

int layer = 1 

- void set_layer(value: int)
- int get_layer()

Layer index for draw order. Lower values are drawn behind higher values.

Note: If multiple CanvasLayers have the same layer index, CanvasItem children of one CanvasLayer are drawn behind the CanvasItem children of the other CanvasLayer. Which CanvasLayer is drawn in front is non-deterministic.

Note: The layer index should be between RenderingServer.CANVAS_LAYER_MIN and RenderingServer.CANVAS_LAYER_MAX (inclusive). Any other value will wrap around.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The layer's base offset.

---

float rotation = 0.0 

- void set_rotation(value: float)
- float get_rotation()

The layer's rotation in radians.

---

Vector2 scale = Vector2(1, 1) 

- void set_scale(value: Vector2)
- Vector2 get_scale()

The layer's scale.

---

Transform2D transform = Transform2D(1, 0, 0, 1, 0, 0) 

- void set_transform(value: Transform2D)
- Transform2D get_transform()

The layer's transform.

---

bool visible = true 

- void set_visible(value: bool)
- bool is_visible()

If false, any CanvasItem under this CanvasLayer will be hidden.

Unlike CanvasItem.visible, visibility of a CanvasLayer isn't propagated to underlying layers.

---

## Method Descriptions

RID get_canvas() const 

Returns the RID of the canvas used by this layer.

---

Transform2D get_final_transform() const 

Returns the transform from the CanvasLayers coordinate system to the Viewports coordinate system.

---

void hide() 

Hides any CanvasItem under this CanvasLayer. This is equivalent to setting visible to false.

---

void show() 

Shows any CanvasItem under this CanvasLayer. This is equivalent to setting visible to true.
