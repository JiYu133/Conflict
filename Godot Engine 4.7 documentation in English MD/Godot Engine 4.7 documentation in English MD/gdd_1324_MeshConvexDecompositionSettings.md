# MeshConvexDecompositionSettings

Inherits: RefCounted < Object

Parameters to be used with a Mesh convex decomposition operation.

## Description

Parameters to be used with a Mesh convex decomposition operation.

## Properties

bool | convex_hull_approximation | true
int | convex_hull_downsampling | 4
float | max_concavity | 1.0
int | max_convex_hulls | 1
int | max_num_vertices_per_convex_hull | 32
float | min_volume_per_convex_hull | 0.0001
Mode | mode | 0
bool | normalize_mesh | false
int | plane_downsampling | 4
bool | project_hull_vertices | true
int | resolution | 10000
float | revolution_axes_clipping_bias | 0.05
float | symmetry_planes_clipping_bias | 0.05

---

## Enumerations

enum Mode
Mode CONVEX_DECOMPOSITION_MODE_VOXEL = 0

Constant for voxel-based approximate convex decomposition.

Mode CONVEX_DECOMPOSITION_MODE_TETRAHEDRON = 1

Constant for tetrahedron-based approximate convex decomposition.

---

## Property Descriptions

bool convex_hull_approximation = true 

- void set_convex_hull_approximation(value: bool)
- bool get_convex_hull_approximation()

If true, uses approximation for computing convex hulls.

---

int convex_hull_downsampling = 4 

- void set_convex_hull_downsampling(value: int)
- int get_convex_hull_downsampling()

Controls the precision of the convex-hull generation process during the clipping plane selection stage. Ranges from 1 to 16.

---

float max_concavity = 1.0 

- void set_max_concavity(value: float)
- float get_max_concavity()

Maximum concavity. Ranges from 0.0 to 1.0.

---

int max_convex_hulls = 1 

- void set_max_convex_hulls(value: int)
- int get_max_convex_hulls()

The maximum number of convex hulls to produce from the merge operation.

---

int max_num_vertices_per_convex_hull = 32 

- void set_max_num_vertices_per_convex_hull(value: int)
- int get_max_num_vertices_per_convex_hull()

Controls the maximum number of triangles per convex-hull. Ranges from 4 to 1024.

---

float min_volume_per_convex_hull = 0.0001 

- void set_min_volume_per_convex_hull(value: float)
- float get_min_volume_per_convex_hull()

Controls the adaptive sampling of the generated convex-hulls. Ranges from 0.0 to 0.01.

---

Mode mode = 0 

- void set_mode(value: Mode)
- Mode get_mode()

Mode for the approximate convex decomposition.

---

bool normalize_mesh = false 

- void set_normalize_mesh(value: bool)
- bool get_normalize_mesh()

If true, normalizes the mesh before applying the convex decomposition.

---

int plane_downsampling = 4 

- void set_plane_downsampling(value: int)
- int get_plane_downsampling()

Controls the granularity of the search for the "best" clipping plane. Ranges from 1 to 16.

---

bool project_hull_vertices = true 

- void set_project_hull_vertices(value: bool)
- bool get_project_hull_vertices()

If true, projects output convex hull vertices onto the original source mesh to increase floating-point accuracy of the results.

---

int resolution = 10000 

- void set_resolution(value: int)
- int get_resolution()

Maximum number of voxels generated during the voxelization stage.

---

float revolution_axes_clipping_bias = 0.05 

- void set_revolution_axes_clipping_bias(value: float)
- float get_revolution_axes_clipping_bias()

Controls the bias toward clipping along revolution axes. Ranges from 0.0 to 1.0.

---

float symmetry_planes_clipping_bias = 0.05 

- void set_symmetry_planes_clipping_bias(value: float)
- float get_symmetry_planes_clipping_bias()

Controls the bias toward clipping along symmetry planes. Ranges from 0.0 to 1.0.
