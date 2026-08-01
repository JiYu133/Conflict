# HeightMapShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D heightmap shape used for physics collision.

## Description

A 3D heightmap shape, intended for use in physics to provide a shape for a CollisionShape3D. This type is most commonly used for terrain with vertices placed in a fixed-width grid.

The heightmap is represented as a 2D grid of height values, which represent the position of grid points on the Y axis. Grid points are spaced 1 unit apart on the X and Z axes, and the grid is centered on the origin of the CollisionShape3D node. Internally, each grid square is divided into two triangles.

Due to the nature of the heightmap, it cannot be used to model overhangs or caves, which would require multiple vertices at the same vertical location. Holes can be punched through the collision by assigning @GDScript.NAN to the height of the desired vertices (this is supported in both GodotPhysics3D and Jolt Physics). You could then insert meshes with their own separate collision to provide overhangs, caves, and so on.

Performance: HeightMapShape3D is faster to check collisions against than ConcavePolygonShape3D, but it is significantly slower than primitive shapes like BoxShape3D.

A heightmap collision shape can also be built by using an Image reference:

```
var heightmap_texture = ResourceLoader.load("res://heightmap_image.exr")
var heightmap_image = heightmap_texture.get_image()
heightmap_image.convert(Image.FORMAT_RF)
var height_min = 0.0
var height_max = 10.0
update_map_data_from_image(heightmap_image, height_min, height_max)
```

Note: If you need to use a spacing different than 1 unit, you can adjust the Node3D.scale of the shape. However, keep in mind that GodotPhysics3D does not support non-uniform scaling: you'll need to scale the Y axis by the same amount as the X and Z axes, which means the values in map_data will need to be pre-scaled by the inverse of that scale. Also note that GodotPhysics3D does not support scaling at all for dynamic bodies (that is, non-frozen RigidBody3D nodes); to use a scaled HeightMapShape3D with those, you will need to use Jolt Physics.

## Properties

PackedFloat32Array | map_data | PackedFloat32Array(0, 0, 0, 0)
int | map_depth | 2
int | map_width | 2

## Methods

float | get_max_height() const
float | get_min_height() const
void | update_map_data_from_image(image: Image, height_min: float, height_max: float)

---

## Property Descriptions

PackedFloat32Array map_data = PackedFloat32Array(0, 0, 0, 0) 

- void set_map_data(value: PackedFloat32Array)
- PackedFloat32Array get_map_data()

Heightmap data. The array's size must be equal to map_width multiplied by map_depth.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

int map_depth = 2 

- void set_map_depth(value: int)
- int get_map_depth()

Number of vertices in the depth of the heightmap. Changing this will resize the map_data.

---

int map_width = 2 

- void set_map_width(value: int)
- int get_map_width()

Number of vertices in the width of the heightmap. Changing this will resize the map_data.

---

## Method Descriptions

float get_max_height() const 

Returns the largest height value found in map_data. Recalculates only when map_data changes.

---

float get_min_height() const 

Returns the smallest height value found in map_data. Recalculates only when map_data changes.

---

void update_map_data_from_image(image: Image, height_min: float, height_max: float) 

Updates map_data with data read from an Image reference. Automatically resizes heightmap map_width and map_depth to fit the full image width and height.

The image needs to be in either Image.FORMAT_RF (32 bit), Image.FORMAT_RH (16 bit), or Image.FORMAT_R8 (8 bit).

Each image pixel is read in as a float on the range from 0.0 (black pixel) to 1.0 (white pixel). This range value gets remapped to height_min and height_max to form the final height value.

Note: Using a heightmap with 16-bit or 32-bit data, stored in EXR or HDR format is recommended. Using 8-bit height data, or a format like PNG that Godot imports as 8-bit, will result in a terraced terrain.
