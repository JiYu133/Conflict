# BitMap

Inherits: Resource < RefCounted < Object

Boolean matrix.

## Description

A two-dimensional array of boolean values, can be used to efficiently store a binary matrix (every matrix element takes only one bit) and query the values using natural cartesian coordinates.

## Methods

Image | convert_to_image() const
void | create(size: Vector2i)
void | create_from_image_alpha(image: Image, threshold: float = 0.1)
bool | get_bit(x: int, y: int) const
bool | get_bitv(position: Vector2i) const
Vector2i | get_size() const
int | get_true_bit_count() const
void | grow_mask(pixels: int, rect: Rect2i)
Array[PackedVector2Array] | opaque_to_polygons(rect: Rect2i, epsilon: float = 2.0) const
void | resize(new_size: Vector2i)
void | set_bit(x: int, y: int, bit: bool)
void | set_bit_rect(rect: Rect2i, bit: bool)
void | set_bitv(position: Vector2i, bit: bool)

---

## Method Descriptions

Image convert_to_image() const 

Returns an image of the same size as the bitmap and with an Format of type Image.FORMAT_L8. true bits of the bitmap are being converted into white pixels, and false bits into black.

---

void create(size: Vector2i) 

Creates a bitmap with the specified size, filled with false.

---

void create_from_image_alpha(image: Image, threshold: float = 0.1) 

Creates a bitmap that matches the given image dimensions, every element of the bitmap is set to false if the alpha value of the image at that position is equal to threshold or less, and true in other case.

---

bool get_bit(x: int, y: int) const 

Returns bitmap's value at the specified position.

---

bool get_bitv(position: Vector2i) const 

Returns bitmap's value at the specified position.

---

Vector2i get_size() const 

Returns bitmap's dimensions.

---

int get_true_bit_count() const 

Returns the number of bitmap elements that are set to true.

---

void grow_mask(pixels: int, rect: Rect2i) 

Applies morphological dilation or erosion to the bitmap. If pixels is positive, dilation is applied to the bitmap. If pixels is negative, erosion is applied to the bitmap. rect defines the area where the morphological operation is applied. Pixels located outside the rect are unaffected by grow_mask().

---

Array[PackedVector2Array] opaque_to_polygons(rect: Rect2i, epsilon: float = 2.0) const 

Creates an Array of polygons covering a rectangular portion of the bitmap. It uses a marching squares algorithm, followed by Ramer-Douglas-Peucker (RDP) reduction of the number of vertices. Each polygon is described as a PackedVector2Array of its vertices.

To get polygons covering the whole bitmap, pass:

```gdscript
Rect2(Vector2(), get_size())
```

epsilon is passed to RDP to control how accurately the polygons cover the bitmap: a lower epsilon corresponds to more points in the polygons.

---

void resize(new_size: Vector2i) 

Resizes the image to new_size.

---

void set_bit(x: int, y: int, bit: bool) 

Sets the bitmap's element at the specified position, to the specified value.

---

void set_bit_rect(rect: Rect2i, bit: bool) 

Sets a rectangular portion of the bitmap to the specified value.

---

void set_bitv(position: Vector2i, bit: bool) 

Sets the bitmap's element at the specified position, to the specified value.
