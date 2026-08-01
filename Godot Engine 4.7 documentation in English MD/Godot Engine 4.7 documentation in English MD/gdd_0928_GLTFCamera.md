# GLTFCamera

Inherits: Resource < RefCounted < Object

Represents a glTF camera.

## Description

Represents a camera as defined by the base glTF spec.

## Tutorials

- Runtime file loading and saving
- glTF camera detailed specification [https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#reference-camera]
- glTF camera spec and example file [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_015_SimpleCameras.md]

## Properties

float | depth_far | 4000.0
float | depth_near | 0.05
float | fov | 1.3089969
bool | perspective | true
float | size_mag | 0.5

## Methods

GLTFCamera | from_dictionary(dictionary: Dictionary) static
GLTFCamera | from_node(camera_node: Camera3D) static
Dictionary | to_dictionary() const
Camera3D | to_node() const

---

## Property Descriptions

float depth_far = 4000.0 

- void set_depth_far(value: float)
- float get_depth_far()

The distance to the far culling boundary for this camera relative to its local Z axis, in meters. This maps to glTF's zfar property.

---

float depth_near = 0.05 

- void set_depth_near(value: float)
- float get_depth_near()

The distance to the near culling boundary for this camera relative to its local Z axis, in meters. This maps to glTF's znear property.

---

float fov = 1.3089969 

- void set_fov(value: float)
- float get_fov()

The FOV of the camera. This class and glTF define the camera FOV in radians, while Godot uses degrees. This maps to glTF's yfov property. This value is only used for perspective cameras, when perspective is true.

---

bool perspective = true 

- void set_perspective(value: bool)
- bool get_perspective()

If true, the camera is in perspective mode. Otherwise, the camera is in orthographic/orthogonal mode. This maps to glTF's camera type property. See Camera3D.projection and the glTF spec for more information.

---

float size_mag = 0.5 

- void set_size_mag(value: float)
- float get_size_mag()

The size of the camera. This class and glTF define the camera size magnitude as a radius in meters, while Godot defines it as a diameter in meters. This maps to glTF's ymag property. This value is only used for orthographic/orthogonal cameras, when perspective is false.

---

## Method Descriptions

GLTFCamera from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFCamera instance by parsing the given Dictionary.

---

GLTFCamera from_node(camera_node: Camera3D) static 

Create a new GLTFCamera instance from the given Godot Camera3D node.

---

Dictionary to_dictionary() const 

Serializes this GLTFCamera instance into a Dictionary.

---

Camera3D to_node() const 

Converts this GLTFCamera instance into a Godot Camera3D node.
