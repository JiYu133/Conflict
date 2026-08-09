# CanvasItem

Inherits: Node < Object

Inherited By: Control, Node2D

Abstract base class for everything in 2D space.

## Description

Abstract base class for everything in 2D space. Canvas items are laid out in a tree; children inherit and extend their parent's transform. CanvasItem is extended by Control for GUI-related nodes, and by Node2D for 2D game objects.

Any CanvasItem can draw. For this, queue_redraw() is called by the engine, then NOTIFICATION_DRAW will be received on idle time to request a redraw. Because of this, canvas items don't need to be redrawn on every frame, improving the performance significantly. Several functions for drawing on the CanvasItem are provided (see draw_* functions). However, they can only be used inside _draw(), its corresponding Object._notification() or methods connected to the draw signal.

Canvas items are drawn in tree order on their canvas layer. By default, children are on top of their parents, so a root CanvasItem will be drawn behind everything. This behavior can be changed on a per-item basis.

A CanvasItem can be hidden, which will also hide its children. By adjusting various other properties of a CanvasItem, you can also modulate its color (via modulate or self_modulate), change its Z-index, blend mode, and more.

Note that properties like transform, modulation, and visibility are only propagated to direct CanvasItem child nodes. If there is a non-CanvasItem node in between, like Node or AnimationPlayer, the CanvasItem nodes below will have an independent position and modulate chain. See also top_level.

## Tutorials

- Viewport and canvas transforms
- Custom drawing in 2D
- Audio Spectrum Visualizer Demo [https://godotengine.org/asset-library/asset/2762]

## Properties

ClipChildrenMode | clip_children | 0
int | light_mask | 1
Material | material |
Color | modulate | Color(1, 1, 1, 1)
OversamplingWithScale | oversampling_with_scale | 0
Color | self_modulate | Color(1, 1, 1, 1)
bool | show_behind_parent | false
TextureFilter | texture_filter | 0
TextureRepeat | texture_repeat | 0
bool | top_level | false
bool | use_parent_material | false
int | visibility_layer | 1
bool | visible | true
bool | y_sort_enabled | false
bool | z_as_relative | true
int | z_index | 0

## Methods

void | _draw() virtual
void | draw_animation_slice(animation_length: float, slice_begin: float, slice_end: float, offset: float = 0.0)
void | draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false)
void | draw_char(font: Font, pos: Vector2, char: String, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
void | draw_char_outline(font: Font, pos: Vector2, char: String, font_size: int = 16, size: int = -1, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
void | draw_circle(position: Vector2, radius: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false)
void | draw_colored_polygon(points: PackedVector2Array, color: Color, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null)
void | draw_dashed_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, dash: float = 2.0, aligned: bool = true, antialiased: bool = false)
void | draw_ellipse(position: Vector2, major: float, minor: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false)
void | draw_ellipse_arc(center: Vector2, major: float, minor: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false)
void | draw_end_animation()
void | draw_lcd_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1))
void | draw_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, antialiased: bool = false)
void | draw_mesh(mesh: Mesh, texture: Texture2D, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), modulate: Color = Color(1, 1, 1, 1))
void | draw_msdf_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), outline: float = 0.0, pixel_range: float = 4.0, scale: float = 1.0)
void | draw_multiline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false)
void | draw_multiline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false)
void | draw_multiline_string(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_multiline_string_outline(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, size: int = 1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_multimesh(multimesh: MultiMesh, texture: Texture2D)
void | draw_polygon(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null)
void | draw_polyline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false)
void | draw_polyline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false)
void | draw_primitive(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array, texture: Texture2D = null)
void | draw_rect(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false)
void | draw_set_transform(position: Vector2, rotation: float = 0.0, scale: Vector2 = Vector2(1, 1))
void | draw_set_transform_matrix(xform: Transform2D)
void | draw_string(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_string_outline(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, size: int = 1, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_style_box(style_box: StyleBox, rect: Rect2)
void | draw_texture(texture: Texture2D, position: Vector2, modulate: Color = Color(1, 1, 1, 1))
void | draw_texture_rect(texture: Texture2D, rect: Rect2, tile: bool, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false)
void | draw_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false, clip_uv: bool = true)
void | force_update_transform()
RID | get_canvas() const
RID | get_canvas_item() const
CanvasLayer | get_canvas_layer_node() const
Transform2D | get_canvas_transform() const
Vector2 | get_global_mouse_position() const
Transform2D | get_global_transform() const
Transform2D | get_global_transform_with_canvas() const
Variant | get_instance_shader_parameter(name: StringName) const
Vector2 | get_local_mouse_position() const
Transform2D | get_screen_transform() const
Transform2D | get_transform() const
Rect2 | get_viewport_rect() const
Transform2D | get_viewport_transform() const
bool | get_visibility_layer_bit(layer: int) const
World2D | get_world_2d() const
void | hide()
bool | is_local_transform_notification_enabled() const
bool | is_transform_notification_enabled() const
bool | is_visible_in_tree() const
Vector2 | make_canvas_position_local(viewport_point: Vector2) const
InputEvent | make_input_local(event: InputEvent) const
void | move_to_front()
void | queue_redraw()
void | set_instance_shader_parameter(name: StringName, value: Variant)
void | set_notify_local_transform(enable: bool)
void | set_notify_transform(enable: bool)
void | set_visibility_layer_bit(layer: int, enabled: bool)
void | show()

---

## Signals

draw() 

Emitted when the CanvasItem must redraw, after the related NOTIFICATION_DRAW notification, and before _draw() is called.

Note: Deferred connections do not allow drawing through the draw_* methods.

---

hidden() 

Emitted when this node becomes hidden, i.e. it's no longer visible in the tree (see is_visible_in_tree()).

---

item_rect_changed() 

Emitted when the CanvasItem's boundaries (position or size) change, or when an action took place that may have affected these boundaries (e.g. changing Sprite2D.texture).

---

visibility_changed() 

Emitted when the CanvasItem's visibility changes, either because its own visible property changed or because its visibility in the tree changed (see is_visible_in_tree()).

This signal is emitted after the related NOTIFICATION_VISIBILITY_CHANGED notification.

---

## Enumerations

enum TextureFilter
TextureFilter TEXTURE_FILTER_PARENT_NODE = 0

The CanvasItem will inherit the filter from its parent.

TextureFilter TEXTURE_FILTER_NEAREST = 1

The texture filter reads from the nearest pixel only. This makes the texture look pixelated from up close, and grainy from a distance (due to mipmaps not being sampled).

TextureFilter TEXTURE_FILTER_LINEAR = 2

The texture filter blends between the nearest 4 pixels. This makes the texture look smooth from up close, and grainy from a distance (due to mipmaps not being sampled).

TextureFilter TEXTURE_FILTER_NEAREST_WITH_MIPMAPS = 3

The texture filter reads from the nearest pixel and blends between the nearest 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true). This makes the texture look pixelated from up close, and smooth from a distance.

Use this for non-pixel art textures that may be viewed at a low scale (e.g. due to Camera2D zoom or sprite scaling), as mipmaps are important to smooth out pixels that are smaller than on-screen pixels.

TextureFilter TEXTURE_FILTER_LINEAR_WITH_MIPMAPS = 4

The texture filter blends between the nearest 4 pixels and between the nearest 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true). This makes the texture look smooth from up close, and smooth from a distance.

Use this for non-pixel art textures that may be viewed at a low scale (e.g. due to Camera2D zoom or sprite scaling), as mipmaps are important to smooth out pixels that are smaller than on-screen pixels.

TextureFilter TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC = 5

The texture filter reads from the nearest pixel and blends between 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true) based on the angle between the surface and the camera view. This makes the texture look pixelated from up close, and smooth from a distance. Anisotropic filtering improves texture quality on surfaces that are almost in line with the camera, but is slightly slower. The anisotropic filtering level can be changed by adjusting ProjectSettings.rendering/textures/default_filters/anisotropic_filtering_level.

Note: This texture filter is rarely useful in 2D projects. TEXTURE_FILTER_NEAREST_WITH_MIPMAPS is usually more appropriate in this case.

TextureFilter TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC = 6

The texture filter blends between the nearest 4 pixels and blends between 2 mipmaps (or uses the nearest mipmap if ProjectSettings.rendering/textures/default_filters/use_nearest_mipmap_filter is true) based on the angle between the surface and the camera view. This makes the texture look smooth from up close, and smooth from a distance. Anisotropic filtering improves texture quality on surfaces that are almost in line with the camera, but is slightly slower. The anisotropic filtering level can be changed by adjusting ProjectSettings.rendering/textures/default_filters/anisotropic_filtering_level.

Note: This texture filter is rarely useful in 2D projects. TEXTURE_FILTER_LINEAR_WITH_MIPMAPS is usually more appropriate in this case.

TextureFilter TEXTURE_FILTER_MAX = 7

Represents the size of the TextureFilter enum.

---

enum TextureRepeat
TextureRepeat TEXTURE_REPEAT_PARENT_NODE = 0

The CanvasItem will inherit the repeat mode from its parent.

TextureRepeat TEXTURE_REPEAT_DISABLED = 1

The texture does not repeat. Sampling the texture outside its extents will result in "stretching" of the edge pixels. You can avoid this by ensuring a 1-pixel fully transparent border on each side of the texture.

TextureRepeat TEXTURE_REPEAT_ENABLED = 2

The texture repeats when exceeding the texture's size.

TextureRepeat TEXTURE_REPEAT_MIRROR = 3

The texture repeats when the exceeding the texture's size in a "2×2 tiled mode". Repeated textures at even positions are mirrored.

TextureRepeat TEXTURE_REPEAT_MAX = 4

Represents the size of the TextureRepeat enum.

---

enum ClipChildrenMode
ClipChildrenMode CLIP_CHILDREN_DISABLED = 0

Children are drawn over this node and are not clipped.

ClipChildrenMode CLIP_CHILDREN_ONLY = 1

This node is used as a mask and is not drawn. The mask is based on this node's alpha channel: Opaque pixels are kept, transparent pixels are discarded, and semi-transparent pixels are blended in according to their opacity. Children are clipped to this node's drawn area.

ClipChildrenMode CLIP_CHILDREN_AND_DRAW = 2

This node is used as a mask and is also drawn. The mask is based on this node's alpha channel: Opaque pixels are kept, transparent pixels are discarded, and semi-transparent pixels are blended in according to their opacity. Children are clipped to the parent's drawn area.

ClipChildrenMode CLIP_CHILDREN_MAX = 3

Represents the size of the ClipChildrenMode enum.

---

enum OversamplingWithScale
OversamplingWithScale OVERSAMPLING_WITH_SCALE_PARENT_NODE = 0

The CanvasItem will inherit the oversampling mode from its parent.

OversamplingWithScale OVERSAMPLING_WITH_SCALE_DISABLED = 1

The oversampling is not affected by CanvasItem scale, and is equal to the Viewport oversampling.

OversamplingWithScale OVERSAMPLING_WITH_SCALE_ENABLED = 2

The oversampling is a product of CanvasItem scale and Viewport oversampling.

OversamplingWithScale OVERSAMPLING_WITH_SCALE_MAX = 3

Represents the size of the OversamplingWithScale enum.

---

## Constants

NOTIFICATION_TRANSFORM_CHANGED = 2000 

Notification received when this node's global transform changes, if is_transform_notification_enabled() is true. See also set_notify_transform() and get_transform().

Note: Many canvas items such as Camera2D or CollisionObject2D automatically enable this in order to function correctly.

NOTIFICATION_LOCAL_TRANSFORM_CHANGED = 35 

Notification received when this node's transform changes, if is_local_transform_notification_enabled() is true. This is not received when a parent Node2D's transform changes. See also set_notify_local_transform().

Note: Many canvas items such as Camera2D or CollisionShape2D automatically enable this in order to function correctly.

NOTIFICATION_DRAW = 30 

The CanvasItem is requested to draw (see _draw()).

NOTIFICATION_VISIBILITY_CHANGED = 31 

Notification received when this node's visibility changes (see visible and is_visible_in_tree()).

This notification is received before the related visibility_changed signal.

NOTIFICATION_ENTER_CANVAS = 32 

The CanvasItem has entered the canvas.

NOTIFICATION_EXIT_CANVAS = 33 

The CanvasItem has exited the canvas.

This notification is sent in reversed order.

NOTIFICATION_WORLD_2D_CHANGED = 36 

Notification received when this CanvasItem is registered to a new World2D (see get_world_2d()).

---

## Property Descriptions

ClipChildrenMode clip_children = 0 

- void set_clip_children_mode(value: ClipChildrenMode)
- ClipChildrenMode get_clip_children_mode()

The mode in which this node clips its children, acting as a mask.

Note: Clipping nodes cannot be nested or placed within a CanvasGroup. If an ancestor of this node clips its children or is a CanvasGroup, then this node's clip mode should be set to CLIP_CHILDREN_DISABLED to avoid unexpected behavior.

---

int light_mask = 1 

- void set_light_mask(value: int)
- int get_light_mask()

The rendering layers in which this CanvasItem responds to Light2D nodes.

---

Material material 

- void set_material(value: Material)
- Material get_material()

The material applied to this CanvasItem.

---

Color modulate = Color(1, 1, 1, 1) 

- void set_modulate(value: Color)
- Color get_modulate()

The color applied to this CanvasItem. This property does affect child CanvasItems, unlike self_modulate which only affects the node itself.

---

OversamplingWithScale oversampling_with_scale = 0 

- void set_oversampling_with_scale(value: OversamplingWithScale)
- OversamplingWithScale get_oversampling_with_scale()

If enabled, oversampling for this CanvasItem is automatically adjusted with scale.

---

Color self_modulate = Color(1, 1, 1, 1) 

- void set_self_modulate(value: Color)
- Color get_self_modulate()

The color applied to this CanvasItem. This property does not affect child CanvasItems, unlike modulate which affects both the node itself and its children.

Note: Internal children are also not affected by this property (see the include_internal parameter in Node.add_child()). For built-in nodes this includes sliders in ColorPicker, and the tab bar in TabContainer.

---

bool show_behind_parent = false 

- void set_draw_behind_parent(value: bool)
- bool is_draw_behind_parent_enabled()

If true, this node draws behind its parent.

---

TextureFilter texture_filter = 0 

- void set_texture_filter(value: TextureFilter)
- TextureFilter get_texture_filter()

The filtering mode used to render this CanvasItem's texture(s).

---

TextureRepeat texture_repeat = 0 

- void set_texture_repeat(value: TextureRepeat)
- TextureRepeat get_texture_repeat()

The repeating mode used to render this CanvasItem's texture(s). It affects what happens when the texture is sampled outside its extents, for example by setting a Sprite2D.region_rect that is larger than the texture or assigning Polygon2D UV points outside the texture.

Note: TextureRect is not affected by texture_repeat, as it uses its own texture repeating implementation.

---

bool top_level = false 

- void set_as_top_level(value: bool)
- bool is_set_as_top_level()

If true, this CanvasItem will not inherit its transform from parent CanvasItems. Its draw order will also be changed to make it draw on top of other CanvasItems that do not have top_level set to true. The CanvasItem will effectively act as if it was placed as a child of a bare Node.

---

bool use_parent_material = false 

- void set_use_parent_material(value: bool)
- bool get_use_parent_material()

If true, the parent CanvasItem's material is used as this node's material.

---

int visibility_layer = 1 

- void set_visibility_layer(value: int)
- int get_visibility_layer()

The rendering layer in which this CanvasItem is rendered by Viewport nodes. A Viewport will render a CanvasItem if it and all its parents share a layer with the Viewport's canvas cull mask.

Note: A CanvasItem does not inherit its parents' visibility layers. This means that if a parent CanvasItem does not have all the same layers as its child, the child may not be visible even if both the parent and child have visible set to true. For example, if a parent has layer 1 and a child has layer 2, the child will not be visible in a Viewport with the canvas cull mask set to layer 1 or 2 (see Viewport.canvas_cull_mask). To ensure that both the parent and child are visible, the parent must have both layers 1 and 2, or the child must have top_level set to true.

---

bool visible = true 

- void set_visible(value: bool)
- bool is_visible()

If true, this CanvasItem may be drawn. Whether this CanvasItem is actually drawn depends on the visibility of all of its CanvasItem ancestors. In other words: this CanvasItem will be drawn when is_visible_in_tree() returns true and all CanvasItem ancestors share at least one visibility_layer with this CanvasItem.

Note: For controls that inherit Popup, the correct way to make them visible is to call one of the multiple popup*() functions instead.

---

bool y_sort_enabled = false 

- void set_y_sort_enabled(value: bool)
- bool is_y_sort_enabled()

If true, this and child CanvasItem nodes with a higher Y position are rendered in front of nodes with a lower Y position. If false, this and child CanvasItem nodes are rendered normally in scene tree order.

With Y-sorting enabled on a parent node ('A') but disabled on a child node ('B'), the child node ('B') is sorted but its children ('C1', 'C2', etc.) render together on the same Y position as the child node ('B'). This allows you to organize the render order of a scene without changing the scene tree.

Nodes sort relative to each other only if they are on the same z_index.

---

bool z_as_relative = true 

- void set_z_as_relative(value: bool)
- bool is_z_relative()

If true, this node's final Z index is relative to its parent's Z index.

For example, if z_index is 2 and its parent's final Z index is 3, then this node's final Z index will be 5 (2 + 3).

---

int z_index = 0 

- void set_z_index(value: int)
- int get_z_index()

The order in which this node is drawn. A node with a higher Z index will display in front of others. Must be between RenderingServer.CANVAS_ITEM_Z_MIN and RenderingServer.CANVAS_ITEM_Z_MAX (inclusive).

Note: The Z index does not affect the order in which CanvasItem nodes are processed or the way input events are handled. This is especially important to keep in mind for Control nodes.

---

## Method Descriptions

void _draw() virtual 

Called when CanvasItem has been requested to redraw (after queue_redraw() is called, either manually or by the engine).

Corresponds to the NOTIFICATION_DRAW notification in Object._notification().

---

void draw_animation_slice(animation_length: float, slice_begin: float, slice_end: float, offset: float = 0.0) 

Subsequent drawing commands will be ignored unless they fall within the specified animation slice. This is a faster way to implement animations that loop on background rather than redrawing constantly.

---

void draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false) 

Draws an unfilled arc between the given angles with a uniform color and width and optional antialiasing (supported only for positive width). The larger the value of point_count, the smoother the curve. center is defined in local space. For elliptical arcs, see draw_ellipse_arc(). See also draw_circle().

If width is negative, it will be ignored and the arc will be drawn using RenderingServer.PRIMITIVE_LINE_STRIP. This means that when the CanvasItem is scaled, the arc will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

The arc is drawn from start_angle towards the value of end_angle so in clockwise direction if start_angle < end_angle and counter-clockwise otherwise. Passing the same angles but in reversed order will produce the same arc. If absolute difference of start_angle and end_angle is greater than @GDScript.TAU radians, then a full circle arc is drawn (i.e. arc will not overlap itself).

---

void draw_char(font: Font, pos: Vector2, char: String, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draws a string first character using a custom font. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used. pos is defined in local space.

---

void draw_char_outline(font: Font, pos: Vector2, char: String, font_size: int = 16, size: int = -1, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draws a string first character outline using a custom font. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used. pos is defined in local space.

---

void draw_circle(position: Vector2, radius: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) 

Draws a circle, with position defined in local space. See also draw_ellipse(), draw_arc(), draw_polyline(), and draw_polygon().

If filled is true, the circle will be filled with the color specified. If filled is false, the circle will be drawn as a stroke with the color and width specified.

If width is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

If antialiased is true, half transparent "feathers" will be attached to the boundary, making outlines smooth.

Note: width is only effective if filled is false.

---

void draw_colored_polygon(points: PackedVector2Array, color: Color, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null) 

Draws a colored polygon of any number of points, convex or concave. The points in the points array are defined in local space. Unlike draw_polygon(), a single color must be specified for the whole polygon.

Note: If you frequently redraw the same polygon with a large number of vertices, consider pre-calculating the triangulation with Geometry2D.triangulate_polygon() and using draw_mesh(), draw_multimesh(), or RenderingServer.canvas_item_add_triangle_array().

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_dashed_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, dash: float = 2.0, aligned: bool = true, antialiased: bool = false) 

Draws a dashed line from a 2D point to another, with a given color and width. The from and to positions are defined in local space. See also draw_line(), draw_multiline(), and draw_polyline().

If width is negative, then a two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the line parts will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

dash is the length of each dash in pixels, with the gap between each dash being the same length. If aligned is true, the length of the first and last dashes may be shortened or lengthened to allow the line to begin and end at the precise points defined by from and to. Both ends are always symmetrical when aligned is true. If aligned is false, all dashes will have the same length, but the line may appear incomplete at the end due to the dash length not dividing evenly into the line length. Only full dashes are drawn when aligned is false.

If antialiased is true, half transparent "feathers" will be attached to the boundary, making outlines smooth.

Note: antialiased is only effective if width is greater than 0.0.

---

void draw_ellipse(position: Vector2, major: float, minor: float, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) 

Draws an ellipse with semi-major axis major and semi-minor axis minor. See also draw_circle(), draw_ellipse_arc(), draw_polyline(), and draw_polygon().

If filled is true, the ellipse will be filled with the color specified. If filled is false, the ellipse will be drawn as a stroke with the color and width specified.

If width is negative, then two-point primitives will be drawn instead of four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

If antialiased is true, half transparent "feathers" will be attached to the boundary, making outlines smooth.

Note: width is only effective if filled is false.

---

void draw_ellipse_arc(center: Vector2, major: float, minor: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false) 

Draws an unfilled elliptical arc between the given angles with a uniform color and width and optional antialiasing (supported only for positive width). The larger the value of point_count, the smoother the curve. For circular arcs, see draw_arc(). See also draw_ellipse().

If width is negative, it will be ignored and the arc will be drawn using RenderingServer.PRIMITIVE_LINE_STRIP. This means that when the CanvasItem is scaled, the arc will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

The arc is drawn from start_angle towards the value of end_angle so in clockwise direction if start_angle < end_angle and counter-clockwise otherwise. Passing the same angles but in reversed order will produce the same arc. If absolute difference of start_angle and end_angle is greater than @GDScript.TAU radians, then a full ellipse is drawn (i.e. arc will not overlap itself).

---

void draw_end_animation() 

After submitting all animations slices via draw_animation_slice(), this function can be used to revert drawing to its default state (all subsequent drawing commands will be visible). If you don't care about this particular use case, usage of this function after submitting the slices is not required.

---

void draw_lcd_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1)) 

Draws a textured rectangle region of the font texture with LCD subpixel anti-aliasing at a given position, optionally modulated by a color. The rect is defined in local space.

Texture is drawn using the following blend operation, blend mode of the CanvasItemMaterial is ignored:

```gdscript
dst.r = texture.r * modulate.r * modulate.a + dst.r * (1.0 - texture.r * modulate.a);
dst.g = texture.g * modulate.g * modulate.a + dst.g * (1.0 - texture.g * modulate.a);
dst.b = texture.b * modulate.b * modulate.a + dst.b * (1.0 - texture.b * modulate.a);
dst.a = modulate.a + dst.a * (1.0 - modulate.a);
```

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_line(from: Vector2, to: Vector2, color: Color, width: float = -1.0, antialiased: bool = false) 

Draws a line from a 2D point to another, with a given color and width. It can be optionally antialiased. The from and to positions are defined in local space. See also draw_dashed_line(), draw_multiline(), and draw_polyline().

If width is negative, then a two-point primitive will be drawn instead of a four-point one. This means that when the CanvasItem is scaled, the line will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

---

void draw_mesh(mesh: Mesh, texture: Texture2D, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), modulate: Color = Color(1, 1, 1, 1)) 

Draws a Mesh in 2D, using the provided texture. See MeshInstance2D for related documentation. The transform is defined in local space.

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_msdf_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), outline: float = 0.0, pixel_range: float = 4.0, scale: float = 1.0) 

Draws a textured rectangle region of the multichannel signed distance field texture at a given position, optionally modulated by a color. The rect is defined in local space. See FontFile.multichannel_signed_distance_field for more information and caveats about MSDF font rendering.

If outline is positive, each alpha channel value of pixel in region is set to maximum value of true distance in the outline radius.

Value of the pixel_range should the same that was used during distance field texture generation.

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_multiline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false) 

Draws multiple disconnected lines with a uniform width and color. Each line is defined by two consecutive points from points array in local space, i.e. i-th segment consists of points[2 * i], points[2 * i + 1] endpoints. When drawing large amounts of lines, this is faster than using individual draw_line() calls. To draw interconnected lines, use draw_polyline() instead.

If width is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

Note: antialiased is only effective if width is greater than 0.0.

---

void draw_multiline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) 

Draws multiple disconnected lines with a uniform width and segment-by-segment coloring. Each segment is defined by two consecutive points from points array in local space and a corresponding color from colors array, i.e. i-th segment consists of points[2 * i], points[2 * i + 1] endpoints and has colors[i] color. When drawing large amounts of lines, this is faster than using individual draw_line() calls. To draw interconnected lines, use draw_polyline_colors() instead.

If width is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

Note: antialiased is only effective if width is greater than 0.0.

---

void draw_multiline_string(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Breaks text into lines and draws it using the specified font at the pos in local space (top-left corner). The text will have its color multiplied by modulate. If width is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

void draw_multiline_string_outline(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, size: int = 1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Breaks text to the lines and draws text outline using the specified font at the pos in local space (top-left corner). The text will have its color multiplied by modulate. If width is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

void draw_multimesh(multimesh: MultiMesh, texture: Texture2D) 

Draws a MultiMesh in 2D with the provided texture. See MultiMeshInstance2D for related documentation.

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_polygon(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array = PackedVector2Array(), texture: Texture2D = null) 

Draws a solid polygon of any number of points, convex or concave. Unlike draw_colored_polygon(), each point's color can be changed individually. The points array is defined in local space. See also draw_polyline() and draw_polyline_colors(). If you need more flexibility (such as being able to use bones), use RenderingServer.canvas_item_add_triangle_array() instead.

Note: If you frequently redraw the same polygon with a large number of vertices, consider pre-calculating the triangulation with Geometry2D.triangulate_polygon() and using draw_mesh(), draw_multimesh(), or RenderingServer.canvas_item_add_triangle_array().

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_polyline(points: PackedVector2Array, color: Color, width: float = -1.0, antialiased: bool = false) 

Draws interconnected line segments with a uniform color and width and optional antialiasing (supported only for positive width). The points array is defined in local space. When drawing large amounts of lines, this is faster than using individual draw_line() calls. To draw disconnected lines, use draw_multiline() instead. See also draw_polygon().

If width is negative, it will be ignored and the polyline will be drawn using RenderingServer.PRIMITIVE_LINE_STRIP. This means that when the CanvasItem is scaled, the polyline will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

---

void draw_polyline_colors(points: PackedVector2Array, colors: PackedColorArray, width: float = -1.0, antialiased: bool = false) 

Draws interconnected line segments with a uniform width, point-by-point coloring, and optional antialiasing (supported only for positive width). Colors assigned to line points match by index between points and colors, i.e. each line segment is filled with a gradient between the colors of the endpoints. The points array is defined in local space. When drawing large amounts of lines, this is faster than using individual draw_line() calls. To draw disconnected lines, use draw_multiline_colors() instead. See also draw_polygon().

If width is negative, it will be ignored and the polyline will be drawn using RenderingServer.PRIMITIVE_LINE_STRIP. This means that when the CanvasItem is scaled, the polyline will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

---

void draw_primitive(points: PackedVector2Array, colors: PackedColorArray, uvs: PackedVector2Array, texture: Texture2D = null) 

Draws a custom primitive. 1 point for a point, 2 points for a line, 3 points for a triangle, and 4 points for a quad. If 0 points or more than 4 points are specified, nothing will be drawn and an error message will be printed. The points array is defined in local space. See also draw_line(), draw_polyline(), draw_polygon(), and draw_rect().

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_rect(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0, antialiased: bool = false) 

Draws a rectangle. If filled is true, the rectangle will be filled with the color specified. If filled is false, the rectangle will be drawn as a stroke with the color and width specified. The rect is specified in local space. See also draw_texture_rect().

If width is negative, then two-point primitives will be drawn instead of a four-point ones. This means that when the CanvasItem is scaled, the lines will remain thin. If this behavior is not desired, then pass a positive width like 1.0.

If antialiased is true, half transparent "feathers" will be attached to the boundary, making outlines smooth.

Note: width is only effective if filled is false.

Note: Unfilled rectangles drawn with a negative width may not display perfectly. For example, corners may be missing or brighter due to overlapping lines (for a translucent color).

---

void draw_set_transform(position: Vector2, rotation: float = 0.0, scale: Vector2 = Vector2(1, 1)) 

Sets a custom local transform for drawing via components. Anything drawn afterwards will be transformed by this.

Note: FontFile.oversampling does not take scale into account. This means that scaling up/down will cause bitmap fonts and rasterized (non-MSDF) dynamic fonts to appear blurry or pixelated. To ensure text remains crisp regardless of scale, you can enable MSDF font rendering by enabling ProjectSettings.gui/theme/default_font_multichannel_signed_distance_field (applies to the default project font only), or enabling Multichannel Signed Distance Field in the import options of a DynamicFont for custom fonts. On system fonts, SystemFont.multichannel_signed_distance_field can be enabled in the inspector.

---

void draw_set_transform_matrix(xform: Transform2D) 

Sets a custom local transform for drawing via matrix. Anything drawn afterwards will be transformed by this.

---

void draw_string(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Draws text using the specified font at the pos in local space (bottom-left corner using the baseline of the font). The text will have its color multiplied by modulate. If width is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

Example: Draw "Hello world", using the project's default font:

```
draw_string(ThemeDB.fallback_font, Vector2(64, 64), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, ThemeDB.fallback_font_size)
```

```
DrawString(ThemeDB.FallbackFont, new Vector2(64, 64), "Hello world", HorizontalAlignment.Left, -1, ThemeDB.FallbackFontSize);
```

See also Font.draw_string().

---

void draw_string_outline(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, size: int = 1, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Draws text outline using the specified font at the pos in local space (bottom-left corner using the baseline of the font). The text will have its color multiplied by modulate. If width is greater than or equal to 0, the text will be clipped if it exceeds the specified width. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

void draw_style_box(style_box: StyleBox, rect: Rect2) 

Draws a styled rectangle. The rect is defined in local space.

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_texture(texture: Texture2D, position: Vector2, modulate: Color = Color(1, 1, 1, 1)) 

Draws a texture at a given position. The position is defined in local space.

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_texture_rect(texture: Texture2D, rect: Rect2, tile: bool, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false) 

Draws a textured rectangle at a given position, optionally modulated by a color. The rect is defined in local space. If transpose is true, the texture will have its X and Y coordinates swapped. See also draw_rect() and draw_texture_rect_region().

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void draw_texture_rect_region(texture: Texture2D, rect: Rect2, src_rect: Rect2, modulate: Color = Color(1, 1, 1, 1), transpose: bool = false, clip_uv: bool = true) 

Draws a textured rectangle from a texture's region (specified by src_rect) at a given position in local space, optionally modulated by a color. If transpose is true, the texture will have its X and Y coordinates swapped. See also draw_texture_rect().

Note: Styleboxes, textures, and meshes stored only inside local variables should not be used with this method in GDScript, because the drawing operation doesn't begin immediately once this method is called. In GDScript, when the function with the local variables ends, the local variables get destroyed before the rendering takes place.

---

void force_update_transform() 

Forces the node's transform to update. Fails if the node is not inside the tree. See also get_transform().

Note: For performance reasons, transform changes are usually accumulated and applied once at the end of the frame. The update propagates through CanvasItem children, as well. Therefore, use this method only when you need an up-to-date transform (such as during physics operations).

---

RID get_canvas() const 

Returns the RID of the World2D canvas where this node is registered to, used by the RenderingServer.

---

RID get_canvas_item() const 

Returns the internal canvas item RID used by the RenderingServer for this node.

---

CanvasLayer get_canvas_layer_node() const 

Returns the CanvasLayer that contains this node, or null if the node is not in any CanvasLayer.

---

Transform2D get_canvas_transform() const 

Returns the transform of this node, converted from its registered canvas's coordinate system to its viewport's coordinate system. See also Node.get_viewport().

---

Vector2 get_global_mouse_position() const 

Returns mouse cursor's global position relative to the CanvasLayer that contains this node.

Note: For screen-space coordinates (e.g. when using a non-embedded Popup), you can use DisplayServer.mouse_get_position().

---

Transform2D get_global_transform() const 

Returns the global transform matrix of this item, i.e. the combined transform up to the topmost CanvasItem node. The topmost item is a CanvasItem that either has no parent, has non-CanvasItem parent or it has top_level enabled.

---

Transform2D get_global_transform_with_canvas() const 

Returns the transform from the local coordinate system of this CanvasItem to the Viewports coordinate system.

---

Variant get_instance_shader_parameter(name: StringName) const 

Get the value of a shader parameter as set on this instance.

---

Vector2 get_local_mouse_position() const 

Returns the mouse's position in this CanvasItem using the local coordinate system of this CanvasItem.

---

Transform2D get_screen_transform() const 

Returns the transform of this CanvasItem in global screen coordinates (i.e. taking window position into account). Mostly useful for editor plugins.

Equivalent to get_global_transform_with_canvas() if the window is embedded (see Viewport.gui_embed_subwindows).

---

Transform2D get_transform() const 

Returns the transform matrix of this CanvasItem.

---

Rect2 get_viewport_rect() const 

Returns this node's viewport boundaries as a Rect2. See also Node.get_viewport().

---

Transform2D get_viewport_transform() const 

Returns the transform of this node, converted from its registered canvas's coordinate system to its viewport embedder's coordinate system. See also Viewport.get_final_transform() and Node.get_viewport().

---

bool get_visibility_layer_bit(layer: int) const 

Returns true if the layer at the given index is set in visibility_layer.

---

World2D get_world_2d() const 

Returns the World2D this node is registered to.

Usually, this is the same as this node's viewport (see Node.get_viewport() and Viewport.find_world_2d()).

---

void hide() 

Hide the CanvasItem if it's currently visible. This is equivalent to setting visible to false.

---

bool is_local_transform_notification_enabled() const 

Returns true if the node receives NOTIFICATION_LOCAL_TRANSFORM_CHANGED whenever its local transform changes. This is enabled with set_notify_local_transform().

---

bool is_transform_notification_enabled() const 

Returns true if the node receives NOTIFICATION_TRANSFORM_CHANGED whenever its global transform changes. This is enabled with set_notify_transform().

---

bool is_visible_in_tree() const 

Returns true if the node is present in the SceneTree, its visible property is true and all its ancestors are also visible. If any ancestor is hidden, this node will not be visible in the scene tree, and is therefore not drawn (see _draw()).

Visibility is checked only in parent nodes that inherit from CanvasItem, CanvasLayer, and Window. If the parent is of any other type (such as Node, AnimationPlayer, or Node3D), it is assumed to be visible.

Note: This method does not take visibility_layer into account, so even if this method returns true, the node might end up not being rendered.

---

Vector2 make_canvas_position_local(viewport_point: Vector2) const 

Transforms viewport_point from the viewport's coordinates to this node's local coordinates.

For the opposite operation, use get_global_transform_with_canvas().

```gdscript
var viewport_point = get_global_transform_with_canvas() * local_point
```

---

InputEvent make_input_local(event: InputEvent) const 

Returns a copy of the given event with its coordinates converted from global space to this CanvasItem's local space. If not possible, returns the same InputEvent unchanged.

---

void move_to_front() 

Moves this node below its siblings, usually causing the node to draw on top of its siblings. Does nothing if this node does not have a parent. See also Node.move_child().

---

void queue_redraw() 

Queues the CanvasItem to redraw. During idle time, if CanvasItem is visible, NOTIFICATION_DRAW is sent and _draw() is called. This only occurs once per frame, even if this method has been called multiple times.

---

void set_instance_shader_parameter(name: StringName, value: Variant) 

Set the value of a shader uniform for this instance only (per-instance uniform). See also ShaderMaterial.set_shader_parameter() to assign a uniform on all instances using the same ShaderMaterial.

Note: For a shader uniform to be assignable on a per-instance basis, it must be defined with instance uniform ... rather than uniform ... in the shader code.

Note: name is case-sensitive and must match the name of the uniform in the code exactly (not the capitalized name in the inspector).

---

void set_notify_local_transform(enable: bool) 

If true, the node will receive NOTIFICATION_LOCAL_TRANSFORM_CHANGED whenever its local transform changes.

Note: Many canvas items such as Bone2D or CollisionShape2D automatically enable this in order to function correctly.

---

void set_notify_transform(enable: bool) 

If true, the node will receive NOTIFICATION_TRANSFORM_CHANGED whenever its global transform changes.

Note: Many canvas items such as Camera2D or Light2D automatically enable this in order to function correctly.

---

void set_visibility_layer_bit(layer: int, enabled: bool) 

Set/clear individual bits on the rendering visibility layer. This simplifies editing this CanvasItem's visibility layer.

---

void show() 

Show the CanvasItem if it's currently hidden. This is equivalent to setting visible to true.

Note: For controls that inherit Popup, the correct way to make them visible is to call one of the multiple popup*() functions instead.
