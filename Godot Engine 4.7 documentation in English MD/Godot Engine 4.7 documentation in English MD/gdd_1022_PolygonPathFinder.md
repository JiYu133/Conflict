# PolygonPathFinder

Inherits: Resource < RefCounted < Object

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Methods

PackedVector2Array | find_path(from: Vector2, to: Vector2)
Rect2 | get_bounds() const
Vector2 | get_closest_point(point: Vector2) const
PackedVector2Array | get_intersections(from: Vector2, to: Vector2) const
float | get_point_penalty(idx: int) const
bool | is_point_inside(point: Vector2) const
void | set_point_penalty(idx: int, penalty: float)
void | setup(points: PackedVector2Array, connections: PackedInt32Array)

---

## Method Descriptions

PackedVector2Array find_path(from: Vector2, to: Vector2) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Rect2 get_bounds() const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector2 get_closest_point(point: Vector2) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedVector2Array get_intersections(from: Vector2, to: Vector2) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float get_point_penalty(idx: int) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool is_point_inside(point: Vector2) const 

Returns true if point falls inside the polygon area.

```
var polygon_path_finder = PolygonPathFinder.new()
var points = [Vector2(0.0, 0.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0)]
var connections = [0, 1, 1, 2, 2, 0]
polygon_path_finder.setup(points, connections)
print(polygon_path_finder.is_point_inside(Vector2(0.2, 0.2))) # Prints true
print(polygon_path_finder.is_point_inside(Vector2(1.0, 1.0))) # Prints false
```

```
var polygonPathFinder = new PolygonPathFinder();
Vector2[] points =
[
    new Vector2(0.0f, 0.0f),
    new Vector2(1.0f, 0.0f),
    new Vector2(0.0f, 1.0f)
];
int[] connections = [0, 1, 1, 2, 2, 0];
polygonPathFinder.Setup(points, connections);
GD.Print(polygonPathFinder.IsPointInside(new Vector2(0.2f, 0.2f))); // Prints True
GD.Print(polygonPathFinder.IsPointInside(new Vector2(1.0f, 1.0f))); // Prints False
```

---

void set_point_penalty(idx: int, penalty: float) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void setup(points: PackedVector2Array, connections: PackedInt32Array) 

Sets up PolygonPathFinder with an array of points that define the vertices of the polygon, and an array of indices that determine the edges of the polygon.

The length of connections must be even, returns an error if odd.

```
var polygon_path_finder = PolygonPathFinder.new()
var points = [Vector2(0.0, 0.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0)]
var connections = [0, 1, 1, 2, 2, 0]
polygon_path_finder.setup(points, connections)
```

```
var polygonPathFinder = new PolygonPathFinder();
Vector2[] points =
[
    new Vector2(0.0f, 0.0f),
    new Vector2(1.0f, 0.0f),
    new Vector2(0.0f, 1.0f)
];
int[] connections = [0, 1, 1, 2, 2, 0];
polygonPathFinder.Setup(points, connections);
```
