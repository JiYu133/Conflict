# GLTFNode

Inherits: Resource < RefCounted < Object

glTF node class.

## Description

Represents a glTF node. glTF nodes may have names, transforms, children (other glTF nodes), and more specialized properties (represented by their own classes).

glTF nodes generally exist inside of GLTFState which represents all data of a glTF file. Most of GLTFNode's properties are indices of other data in the glTF file. You can extend a glTF node with additional properties by using get_additional_data() and set_additional_data().

## Tutorials

- Runtime file loading and saving
- glTF scene and node spec [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_004_ScenesNodes.md"]

## Properties

int | camera | -1
PackedInt32Array | children | PackedInt32Array()
int | height | -1
int | light | -1
int | mesh | -1
String | original_name | ""
int | parent | -1
Vector3 | position | Vector3(0, 0, 0)
Quaternion | rotation | Quaternion(0, 0, 0, 1)
Vector3 | scale | Vector3(1, 1, 1)
int | skeleton | -1
int | skin | -1
bool | visible | true
Transform3D | xform | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

## Methods

void | append_child_index(child_index: int)
Variant | get_additional_data(extension_name: StringName)
NodePath | get_scene_node_path(gltf_state: GLTFState, handle_skeletons: bool = true)
void | set_additional_data(extension_name: StringName, additional_data: Variant)

---

## Property Descriptions

int camera = -1 

- void set_camera(value: int)
- int get_camera()

If this glTF node is a camera, the index of the GLTFCamera in the GLTFState that describes the camera's properties. If -1, this node is not a camera.

---

PackedInt32Array children = PackedInt32Array() 

- void set_children(value: PackedInt32Array)
- PackedInt32Array get_children()

The indices of the child nodes in the GLTFState. If this glTF node has no children, this will be an empty array.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

int height = -1 

- void set_height(value: int)
- int get_height()

How deep into the node hierarchy this node is. A root node will have a height of 0, its children will have a height of 1, and so on. If -1, the height has not been calculated.

---

int light = -1 

- void set_light(value: int)
- int get_light()

If this glTF node is a light, the index of the GLTFLight in the GLTFState that describes the light's properties. If -1, this node is not a light.

---

int mesh = -1 

- void set_mesh(value: int)
- int get_mesh()

If this glTF node is a mesh, the index of the GLTFMesh in the GLTFState that describes the mesh's properties. If -1, this node is not a mesh.

---

String original_name = "" 

- void set_original_name(value: String)
- String get_original_name()

The original name of the node.

---

int parent = -1 

- void set_parent(value: int)
- int get_parent()

The index of the parent node in the GLTFState. If -1, this node is a root node.

---

Vector3 position = Vector3(0, 0, 0) 

- void set_position(value: Vector3)
- Vector3 get_position()

The position of the glTF node relative to its parent.

---

Quaternion rotation = Quaternion(0, 0, 0, 1) 

- void set_rotation(value: Quaternion)
- Quaternion get_rotation()

The rotation of the glTF node relative to its parent.

---

Vector3 scale = Vector3(1, 1, 1) 

- void set_scale(value: Vector3)
- Vector3 get_scale()

The scale of the glTF node relative to its parent.

---

int skeleton = -1 

- void set_skeleton(value: int)
- int get_skeleton()

If this glTF node has a skeleton, the index of the GLTFSkeleton in the GLTFState that describes the skeleton's properties. If -1, this node does not have a skeleton.

---

int skin = -1 

- void set_skin(value: int)
- int get_skin()

If this glTF node has a skin, the index of the GLTFSkin in the GLTFState that describes the skin's properties. If -1, this node does not have a skin.

---

bool visible = true 

- void set_visible(value: bool)
- bool get_visible()

If true, the GLTF node is visible. If false, the GLTF node is not visible. This is converted to the Node3D.visible property in the Godot scene, and is exported to KHR_node_visibility when false.

---

Transform3D xform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_xform(value: Transform3D)
- Transform3D get_xform()

The transform of the glTF node relative to its parent. This property is usually unused since the position, rotation, and scale properties are preferred.

---

## Method Descriptions

void append_child_index(child_index: int) 

Appends the given child node index to the children array.

---

Variant get_additional_data(extension_name: StringName) 

Gets additional arbitrary data in this GLTFNode instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is null.

---

NodePath get_scene_node_path(gltf_state: GLTFState, handle_skeletons: bool = true) 

Returns the NodePath that this GLTF node will have in the Godot scene tree after being imported. This is useful when importing glTF object model pointers with GLTFObjectModelProperty, for handling extensions such as KHR_animation_pointer or KHR_interactivity.

If handle_skeletons is true, paths to skeleton bone glTF nodes will be resolved properly. For example, a path that would be ^"A/B/C/Bone1/Bone2/Bone3" if false will become ^"A/B/C/Skeleton3D:Bone3".

---

void set_additional_data(extension_name: StringName, additional_data: Variant) 

Sets additional arbitrary data in this GLTFNode instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The first argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.
