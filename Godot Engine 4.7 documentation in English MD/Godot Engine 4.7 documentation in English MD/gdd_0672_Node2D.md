# Node2D

Inherits: CanvasItem < Node < Object

Inherited By: AnimatedSprite2D, AudioListener2D, AudioStreamPlayer2D, BackBufferCopy, Bone2D, Camera2D, CanvasGroup, CanvasModulate, CollisionObject2D, CollisionPolygon2D, CollisionShape2D, CPUParticles2D, GPUParticles2D, Joint2D, Light2D, LightOccluder2D, Line2D, Marker2D, MeshInstance2D, MultiMeshInstance2D, NavigationLink2D, NavigationObstacle2D, NavigationRegion2D, Parallax2D, ParallaxLayer, Path2D, PathFollow2D, Polygon2D, RayCast2D, RemoteTransform2D, ShapeCast2D, Skeleton2D, Sprite2D, TileMap, TileMapLayer, TouchScreenButton, VisibleOnScreenNotifier2D

A 2D game object, inherited by all 2D-related nodes. Has a position, rotation, scale, and skew.

## Description

A 2D game object, with a transform (position, rotation, and scale). All 2D nodes, including physics objects and sprites, inherit from Node2D. Use Node2D as a parent node to move, scale and rotate children in a 2D project. Also gives control of the node's render order.

Note: Since both Node2D and Control inherit from CanvasItem, they share several concepts from the class such as the CanvasItem.z_index and CanvasItem.visible properties.

## Tutorials

- Custom drawing in 2D
- All 2D Demos [https://github.com/godotengine/godot-demo-projects/tree/master/2d]

## Properties

Vector2 | global_position |
float | global_rotation |
float | global_rotation_degrees |
Vector2 | global_scale |
float | global_skew |
Transform2D | global_transform |
Vector2 | position | Vector2(0, 0)
float | rotation | 0.0
float | rotation_degrees |
Vector2 | scale | Vector2(1, 1)
float | skew | 0.0
Transform2D | transform |

## Methods

void | apply_scale(ratio: Vector2)
float | get_angle_to(point: Vector2) const
Transform2D | get_relative_transform_to_parent(parent: Node) const
void | global_translate(offset: Vector2)
void | look_at(point: Vector2)
void | move_local_x(delta: float, scaled: bool = false)
void | move_local_y(delta: float, scaled: bool = false)
void | rotate(radians: float)
Vector2 | to_global(local_point: Vector2) const
Vector2 | to_local(global_point: Vector2) const
void | translate(offset: Vector2)

---

## Property Descriptions

Vector2 global_position 

- void set_global_position(value: Vector2)
- Vector2 get_global_position()

Global position. See also position.

---

float global_rotation 

- void set_global_rotation(value: float)
- float get_global_rotation()

Global rotation in radians. See also rotation.

---

float global_rotation_degrees 

- void set_global_rotation_degrees(value: float)
- float get_global_rotation_degrees()

Helper property to access global_rotation in degrees instead of radians. See also rotation_degrees.

---

Vector2 global_scale 

- void set_global_scale(value: Vector2)
- Vector2 get_global_scale()

Global scale. See also scale.

---

float global_skew 

- void set_global_skew(value: float)
- float get_global_skew()

Global skew in radians. See also skew.

---

Transform2D global_transform 

- void set_global_transform(value: Transform2D)
- Transform2D get_global_transform()

Global Transform2D. See also transform.

---

Vector2 position = Vector2(0, 0) 

- void set_position(value: Vector2)
- Vector2 get_position()

Position, relative to the node's parent. See also global_position.

---

float rotation = 0.0 

- void set_rotation(value: float)
- float get_rotation()

Rotation in radians, relative to the node's parent. See also global_rotation.

Note: This property is edited in the inspector in degrees. If you want to use degrees in a script, use rotation_degrees.

---

float rotation_degrees 

- void set_rotation_degrees(value: float)
- float get_rotation_degrees()

Helper property to access rotation in degrees instead of radians. See also global_rotation_degrees.

---

Vector2 scale = Vector2(1, 1) 

- void set_scale(value: Vector2)
- Vector2 get_scale()

The node's scale, relative to the node's parent. Unscaled value: (1, 1). See also global_scale.

Note: Negative X scales in 2D are not decomposable from the transformation matrix. Due to the way scale is represented with transformation matrices in Godot, negative scales on the X axis will be changed to negative scales on the Y axis and a rotation of 180 degrees when decomposed.

---

float skew = 0.0 

- void set_skew(value: float)
- float get_skew()

If set to a non-zero value, slants the node in one direction or another. This can be used for pseudo-3D effects. See also global_skew.

Note: Skew is performed on the X axis only, and between rotation and scaling.

Note: This property is edited in the inspector in degrees. If you want to use degrees in a script, use skew = deg_to_rad(value_in_degrees).

---

Transform2D transform 

- void set_transform(value: Transform2D)
- Transform2D get_transform()

The node's Transform2D, relative to the node's parent. See also global_transform.

---

## Method Descriptions

void apply_scale(ratio: Vector2) 

Multiplies the current scale by the ratio vector.

---

float get_angle_to(point: Vector2) const 

Returns the angle between the node and the point in radians. See also look_at().

Illustration of the returned angle. [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/node2d_get_angle_to.png]

---

Transform2D get_relative_transform_to_parent(parent: Node) const 

Returns the Transform2D relative to this node's parent.

---

void global_translate(offset: Vector2) 

Adds the offset vector to the node's global position.

---

void look_at(point: Vector2) 

Rotates the node so that its local +X axis points towards the point, which is expected to use global coordinates. This method is a combination of both rotate() and get_angle_to().

point should not be the same as the node's position, otherwise the node always looks to the right.

---

void move_local_x(delta: float, scaled: bool = false) 

Applies a local translation on the node's X axis with the amount specified in delta. If scaled is false, normalizes the movement to occur independently of the node's scale.

---

void move_local_y(delta: float, scaled: bool = false) 

Applies a local translation on the node's Y axis with the amount specified in delta. If scaled is false, normalizes the movement to occur independently of the node's scale.

---

void rotate(radians: float) 

Applies a rotation to the node, in radians, starting from its current rotation. This is equivalent to rotation += radians.

---

Vector2 to_global(local_point: Vector2) const 

Transforms the provided local position into a position in global coordinate space. The input is expected to be local relative to the Node2D it is called on. e.g. Applying this method to the positions of child nodes will correctly transform their positions into the global coordinate space, but applying it to a node's own position will give an incorrect result, as it will incorporate the node's own transformation into its global position.

---

Vector2 to_local(global_point: Vector2) const 

Transforms the provided global position into a position in local coordinate space. The output will be local relative to the Node2D it is called on. e.g. It is appropriate for determining the positions of child nodes, but it is not appropriate for determining its own position relative to its parent.

---

void translate(offset: Vector2) 

Translates the node by the given offset in local coordinates. This is equivalent to position += offset.
