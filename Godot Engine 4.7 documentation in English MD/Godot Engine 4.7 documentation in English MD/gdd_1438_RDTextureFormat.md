# RDTextureFormat

Inherits: RefCounted < Object

Texture format (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

int | array_layers | 1
int | depth | 1
DataFormat | format | 8
int | height | 1
bool | is_discardable | false
bool | is_resolve_buffer | false
int | mipmaps | 1
TextureSamples | samples | 0
TextureType | texture_type | 1
BitField[TextureUsageBits] | usage_bits | 0
int | width | 1

## Methods

void | add_shareable_format(format: DataFormat)
void | remove_shareable_format(format: DataFormat)

---

## Property Descriptions

int array_layers = 1 

- void set_array_layers(value: int)
- int get_array_layers()

The number of layers in the texture. Only relevant for 2D texture arrays.

---

int depth = 1 

- void set_depth(value: int)
- int get_depth()

The texture's depth (in pixels). This is always 1 for 2D textures.

---

DataFormat format = 8 

- void set_format(value: DataFormat)
- DataFormat get_format()

The texture's pixel data format.

---

int height = 1 

- void set_height(value: int)
- int get_height()

The texture's height (in pixels).

---

bool is_discardable = false 

- void set_is_discardable(value: bool)
- bool get_is_discardable()

If a texture is discardable, its contents do not need to be preserved between frames. This flag is only relevant when the texture is used as target in a draw list.

This information is used by RenderingDevice to figure out if a texture's contents can be discarded, eliminating unnecessary writes to memory and boosting performance.

---

bool is_resolve_buffer = false 

- void set_is_resolve_buffer(value: bool)
- bool get_is_resolve_buffer()

The texture will be used as the destination of a resolve operation.

---

int mipmaps = 1 

- void set_mipmaps(value: int)
- int get_mipmaps()

The number of mipmaps available in the texture.

---

TextureSamples samples = 0 

- void set_samples(value: TextureSamples)
- TextureSamples get_samples()

The number of samples used when sampling the texture.

---

TextureType texture_type = 1 

- void set_texture_type(value: TextureType)
- TextureType get_texture_type()

The texture type.

---

BitField[TextureUsageBits] usage_bits = 0 

- void set_usage_bits(value: BitField[TextureUsageBits])
- BitField[TextureUsageBits] get_usage_bits()

The texture's usage bits, which determine what can be done using the texture.

---

int width = 1 

- void set_width(value: int)
- int get_width()

The texture's width (in pixels).

---

## Method Descriptions

void add_shareable_format(format: DataFormat) 

Adds format as a valid format for the corresponding RDTextureView's RDTextureView.format_override property. If any format is added as shareable, then the main format must also be added.

---

void remove_shareable_format(format: DataFormat) 

Removes format from the list of valid formats that the corresponding RDTextureView's RDTextureView.format_override property can be set to.
