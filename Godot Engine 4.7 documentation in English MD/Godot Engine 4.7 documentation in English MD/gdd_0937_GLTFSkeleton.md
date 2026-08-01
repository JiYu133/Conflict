# GLTFSkeleton

Inherits: Resource < RefCounted < Object

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Tutorials

- Runtime file loading and saving

## Properties

PackedInt32Array | joints | PackedInt32Array()
PackedInt32Array | roots | PackedInt32Array()

## Methods

BoneAttachment3D | get_bone_attachment(idx: int)
int | get_bone_attachment_count()
Dictionary | get_godot_bone_node()
Skeleton3D | get_godot_skeleton()
Array[String] | get_unique_names()
void | set_godot_bone_node(godot_bone_node: Dictionary)
void | set_unique_names(unique_names: Array[String])

---

## Property Descriptions

PackedInt32Array joints = PackedInt32Array() 

- void set_joints(value: PackedInt32Array)
- PackedInt32Array get_joints()

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

PackedInt32Array roots = PackedInt32Array() 

- void set_roots(value: PackedInt32Array)
- PackedInt32Array get_roots()

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

## Method Descriptions

BoneAttachment3D get_bone_attachment(idx: int) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int get_bone_attachment_count() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary get_godot_bone_node() 

Returns a Dictionary that maps skeleton bone indices to the indices of glTF nodes. This property is unused during import, and only set during export. In a glTF file, a bone is a node, so Godot converts skeleton bones to glTF nodes.

---

Skeleton3D get_godot_skeleton() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[String] get_unique_names() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_godot_bone_node(godot_bone_node: Dictionary) 

Sets a Dictionary that maps skeleton bone indices to the indices of glTF nodes. This property is unused during import, and only set during export. In a glTF file, a bone is a node, so Godot converts skeleton bones to glTF nodes.

---

void set_unique_names(unique_names: Array[String]) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
