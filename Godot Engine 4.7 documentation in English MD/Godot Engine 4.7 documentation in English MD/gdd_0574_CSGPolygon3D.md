# CSGPolygon3D

Inherits: CSGPrimitive3D < CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Extrudes a 2D polygon shape to create a 3D mesh.

## Description

An array of 2D points is extruded to quickly and easily create a variety of 3D meshes. See also CSGMesh3D for using 3D meshes as CSG nodes.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

float | depth | 1.0
Material | material |
Mode | mode | 0
bool | path_continuous_u |
float | path_interval |
PathIntervalType | path_interval_type |
bool | path_joined |
bool | path_local |
NodePath | path_node |
PathRotation | path_rotation |
bool | path_rotation_accurate |
float | path_simplify_angle |
float | path_u_distance |
PackedVector2Array | polygon | PackedVector2Array(0, 0, 0, 1, 1, 1, 1, 0)
bool | smooth_faces | false
float | spin_degrees |
int | spin_sides |

---

## Enumerations

enum Mode
Mode MODE_DEPTH = 0

The polygon shape is extruded along the negative Z axis.

Mode MODE_SPIN = 1

The polygon shape is extruded by rotating it around the Y axis.

Mode MODE_PATH = 2

The polygon shape is extruded along the Path3D specified in path_node.

---

enum PathRotation
PathRotation PATH_ROTATION_POLYGON = 0

The polygon shape is not rotated.

Note: Requires the path Z coordinates to continually decrease to ensure viable shapes.

PathRotation PATH_ROTATION_PATH = 1

The polygon shape is rotated along the path, but it is not rotated around the path axis.

Note: Requires the path Z coordinates to continually decrease to ensure viable shapes.

PathRotation PATH_ROTATION_PATH_FOLLOW = 2

The polygon shape follows the path and its rotations around the path axis.

---

enum PathIntervalType
PathIntervalType PATH_INTERVAL_DISTANCE = 0

When mode is set to MODE_PATH, path_interval will determine the distance, in meters, each interval of the path will extrude.

PathIntervalType PATH_INTERVAL_SUBDIVIDE = 1

When mode is set to MODE_PATH, path_interval will subdivide the polygons along the path.

---

## Property Descriptions

float depth = 1.0 

- void set_depth(value: float)
- float get_depth()

When mode is MODE_DEPTH, the depth of the extrusion.

---

Material material 

- void set_material(value: Material)
- Material get_material()

Material to use for the resulting mesh. The UV maps the top half of the material to the extruded shape (U along the length of the extrusions and V around the outline of the polygon), the bottom-left quarter to the front end face, and the bottom-right quarter to the back end face.

---

Mode mode = 0 

- void set_mode(value: Mode)
- Mode get_mode()

The mode used to extrude the polygon.

---

bool path_continuous_u 

- void set_path_continuous_u(value: bool)
- bool is_path_continuous_u()

When mode is MODE_PATH, by default, the top half of the material is stretched along the entire length of the extruded shape. If false the top half of the material is repeated every step of the extrusion.

---

float path_interval 

- void set_path_interval(value: float)
- float get_path_interval()

When mode is MODE_PATH, the path interval or ratio of path points to extrusions.

---

PathIntervalType path_interval_type 

- void set_path_interval_type(value: PathIntervalType)
- PathIntervalType get_path_interval_type()

When mode is MODE_PATH, this will determine if the interval should be by distance (PATH_INTERVAL_DISTANCE) or subdivision fractions (PATH_INTERVAL_SUBDIVIDE).

---

bool path_joined 

- void set_path_joined(value: bool)
- bool is_path_joined()

When mode is MODE_PATH, if true the ends of the path are joined, by adding an extrusion between the last and first points of the path.

---

bool path_local 

- void set_path_local(value: bool)
- bool is_path_local()

When mode is MODE_PATH, if true the Transform3D of the CSGPolygon3D is used as the starting point for the extrusions, not the Transform3D of the path_node.

---

NodePath path_node 

- void set_path_node(value: NodePath)
- NodePath get_path_node()

When mode is MODE_PATH, the location of the Path3D object used to extrude the polygon.

---

PathRotation path_rotation 

- void set_path_rotation(value: PathRotation)
- PathRotation get_path_rotation()

When mode is MODE_PATH, the path rotation method used to rotate the polygon as it is extruded.

---

bool path_rotation_accurate 

- void set_path_rotation_accurate(value: bool)
- bool get_path_rotation_accurate()

When mode is MODE_PATH, if true the polygon will be rotated according to the proper tangent of the path at the sampled points. If false an approximation is used, which decreases in accuracy as the number of subdivisions decreases.

---

float path_simplify_angle 

- void set_path_simplify_angle(value: float)
- float get_path_simplify_angle()

When mode is MODE_PATH, extrusions that are less than this angle, will be merged together to reduce polygon count.

---

float path_u_distance 

- void set_path_u_distance(value: float)
- float get_path_u_distance()

When mode is MODE_PATH, this is the distance along the path, in meters, the texture coordinates will tile. When set to 0, texture coordinates will match geometry exactly with no tiling.

---

PackedVector2Array polygon = PackedVector2Array(0, 0, 0, 1, 1, 1, 1, 0) 

- void set_polygon(value: PackedVector2Array)
- PackedVector2Array get_polygon()

The point array that defines the 2D polygon that is extruded. This can be a convex or concave polygon with 3 or more points. The polygon must not have any intersecting edges. Otherwise, triangulation will fail and no mesh will be generated.

Note: If only 1 or 2 points are defined in polygon, no mesh will be generated.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.

---

bool smooth_faces = false 

- void set_smooth_faces(value: bool)
- bool get_smooth_faces()

If true, applies smooth shading to the extrusions.

---

float spin_degrees 

- void set_spin_degrees(value: float)
- float get_spin_degrees()

When mode is MODE_SPIN, the total number of degrees the polygon is rotated when extruding.

---

int spin_sides 

- void set_spin_sides(value: int)
- int get_spin_sides()

When mode is MODE_SPIN, the number of extrusions made.
