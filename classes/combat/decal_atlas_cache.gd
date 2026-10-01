class_name DecalAtlasCache
extends RefCounted

## Shared CPU-side atlas preparation for every blood Decal path.
##
## Godot Decal requires a concrete Texture2D rather than AtlasTexture. This
## utility crops and uploads each cell once, clears mipmaps, and removes RGB
## from transparent pixels. A positive alpha cutoff additionally removes the
## low-alpha black haze found in the floor-pool source art. Keeping this policy
## here prevents hit effects and death effects from silently diverging again.

static var _variant_cache: Dictionary = {}


static func build_variants(
	atlas: Texture2D,
	columns: int = 2,
	variant_count: int = 4,
	alpha_cutoff: int = 0
) -> Array[Texture2D]:
	var variants: Array[Texture2D] = []
	if not atlas or columns <= 0 or variant_count <= 0:
		return variants
	var cache_key := "%d:%d:%d:%d" % [
		atlas.get_instance_id(), columns, variant_count, alpha_cutoff
	]
	if _variant_cache.has(cache_key):
		for cached_texture in _variant_cache[cache_key] as Array:
			variants.append(cached_texture as Texture2D)
		return variants

	var atlas_image := atlas.get_image()
	if atlas_image.is_compressed():
		var decompress_error := atlas_image.decompress()
		if decompress_error != OK:
			push_error("DecalAtlasCache: failed to decompress atlas (%s)" % error_string(decompress_error))
			return variants
	var cell_size := Vector2i(
		atlas_image.get_width() / columns,
		atlas_image.get_height() / columns
	)
	if cell_size.x <= 0 or cell_size.y <= 0:
		push_error("DecalAtlasCache: atlas is smaller than its declared grid")
		return variants

	for variant_index in range(variant_count):
		var column := variant_index % columns
		var row := int(variant_index / columns)
		var cell := atlas_image.get_region(Rect2i(Vector2i(column, row) * cell_size, cell_size))
		cell = _sanitize_alpha(cell, alpha_cutoff)
		variants.append(ImageTexture.create_from_image(cell))
	_variant_cache[cache_key] = variants
	return variants


static func _sanitize_alpha(image: Image, alpha_cutoff: int) -> Image:
	image.convert(Image.FORMAT_RGBA8)
	image.clear_mipmaps()
	var cutoff := clampi(alpha_cutoff, 0, 255)
	var pixel_data := image.get_data()
	for alpha_index in range(3, pixel_data.size(), 4):
		if pixel_data[alpha_index] <= cutoff:
			pixel_data[alpha_index - 3] = 0
			pixel_data[alpha_index - 2] = 0
			pixel_data[alpha_index - 1] = 0
			pixel_data[alpha_index] = 0
	return Image.create_from_data(
		image.get_width(),
		image.get_height(),
		false,
		Image.FORMAT_RGBA8,
		pixel_data
	)
