# Runtime file loading and saving

See also

See Saving games for information on saving and loading game progression.

Sometimes, exporting packs, patches, and mods is not
ideal when you want players to be able to load user-generated content in your
project. It requires users to generate a PCK or ZIP file through the Godot
editor, which contains resources imported by Godot.

Example use cases for runtime file loading and saving include:

- Loading texture packs designed for the game.
- Loading user-provided audio tracks and playing them back in an in-game radio station.
- Loading custom levels or 3D models that can be designed with any 3D DCC that
can export to glTF or FBX (including glTF scenes saved by Godot at runtime).
- Using user-provided fonts for menus and HUD.
- Saving/loading a file format that can contain multiple files but can still
easily be read by other applications (ZIP).
- Loading files created by another game or program, or even game data files from
another game not made with Godot.

Runtime file loading can be combined with HTTP requests
to load resources from the Internet directly.

Warning

Do not use this runtime loading approach to load resources that are part
of the project, as it's less efficient and doesn't allow benefiting from
Godot's resource handling functionality (such as translation remaps). See
Import process for details.

See also

You can see how saving and loading works in action using the
Run-time File Saving and Loading (Serialization) demo project [https://github.com/godotengine/godot-demo-projects/blob/master/loading/runtime_save_load].

## Plain text and binary files

Godot's FileAccess class provides methods to access files on the
filesystem for reading and writing:

```
func save_file(content):
    var file = FileAccess.open("/path/to/file.txt", FileAccess.WRITE)
    file.store_string(content)
func load_file():
    var file = FileAccess.open("/path/to/file.txt", FileAccess.READ)
    var content = file.get_as_text()
    return content
```

```
private void SaveFile(string content)
{
    using var file = FileAccess.Open("/Path/To/File.txt", FileAccess.ModeFlags.Write);
    file.StoreString(content);
}
private string LoadFile()
{
    using var file = FileAccess.Open("/Path/To/File.txt", FileAccess.ModeFlags.Read);
    string content = file.GetAsText();
    return content;
}
```

To handle custom binary formats (such as loading file formats not supported by
Godot), FileAccess provides several methods to read/write integers,
floats, strings and more. These FileAccess methods have names that start with
get_ and store_.

If you need more control over reading binary files or need to read binary
streams that are not part of a file, PackedByteArray provides
several helper methods to decode/encode series of bytes to integers, floats,
strings and more. These PackedByteArray methods have names that start with
decode_ and encode_. See also Binary serialization API.

## Images

Image's Image.load_from_file static method
handles everything, from format detection based on file extension to reading the
file from disk.

If you need error handling or more control (such as changing the scale an SVG is
loaded at), use one of the following methods depending on the file format:

- Image.load_jpg_from_buffer
- Image.load_ktx_from_buffer
- Image.load_png_from_buffer
- Image.load_svg_from_buffer
or Image.load_svg_from_string
- Image.load_tga_from_buffer
- Image.load_webp_from_buffer
- Image.load_exr_from_buffer

Several image formats can also be saved by Godot at runtime using the following
methods:

- Image.save_png
or Image.save_png_to_buffer
- Image.save_webp
or Image.save_webp_to_buffer
- Image.save_jpg
or Image.save_jpg_to_buffer
- Image.save_exr
or Image.save_exr_to_buffer

The methods with the to_buffer suffix save the image to a PackedByteArray
instead of the filesystem. This is useful to send the image over the network or
into a ZIP archive without having to write it on the filesystem. This can
increase performance by reducing I/O utilization.

Note

If displaying the loaded image on a 3D surface, make sure to call
Image.generate_mipmaps
so that the texture doesn't look grainy when viewed at a distance.
This is also useful in 2D when following instructions on
reducing aliasing when downsampling.

Example of loading an image and displaying it in a TextureRect node
(which requires conversion to ImageTexture):

```
# Load an image of any format supported by Godot from the filesystem.
var image = Image.load_from_file(path)
# Optionally, generate mipmaps if displaying the texture on a 3D surface
# so that the texture doesn't look grainy when viewed at a distance.
#image.generate_mipmaps()
$TextureRect.texture = ImageTexture.create_from_image(image)
# Save the loaded Image to a PNG image.
image.save_png("/path/to/file.png")
# Save the converted ImageTexture to a PNG image.
$TextureRect.texture.get_image().save_png("/path/to/file.png")
```

```
// Load an image of any format supported by Godot from the filesystem.
var image = Image.LoadFromFile(path);
// Optionally, generate mipmaps if displaying the texture on a 3D surface
// so that the texture doesn't look grainy when viewed at a distance.
// image.GenerateMipmaps();
GetNode("TextureRect").Texture = ImageTexture.CreateFromImage(image);
// Save the loaded Image to a PNG image.
image.SavePng("/Path/To/File.png");
// Save the converted ImageTexture to a PNG image.
GetNode("TextureRect").Texture.GetImage().SavePng("/Path/To/File.png");
```

## Audio/video files

Godot supports loading Ogg Vorbis, MP3, and WAV audio at runtime. Note that not all
files with a .ogg extension are Ogg Vorbis files. Some may be Ogg Theora
videos, or contain Opus audio within an Ogg container. These files will not
load correctly as audio files in Godot.

Example of loading an Ogg Vorbis audio file in an AudioStreamPlayer node:

```
$AudioStreamPlayer.stream = AudioStreamOggVorbis.load_from_file(path)
```

```
GetNode("AudioStreamPlayer").Stream = AudioStreamOggVorbis.LoadFromFile(path);
```

Example of loading an Ogg Theora video file in a VideoStreamPlayer node:

```
var video_stream_theora = VideoStreamTheora.new()
# File extension is ignored, so it is possible to load Ogg Theora videos
# that have a `.ogg` extension this way.
video_stream_theora.file = "/path/to/file.ogv"
$VideoStreamPlayer.stream = video_stream_theora
# VideoStreamPlayer's Autoplay property won't work if the stream is empty
# before this property is set, so call `play()` after setting `stream`.
$VideoStreamPlayer.play()
```

```
var videoStreamTheora = new VideoStreamTheora();
// File extension is ignored, so it is possible to load Ogg Theora videos
// that have a `.ogg` extension this way.
videoStreamTheora.File = "/Path/To/File.ogv";
GetNode("VideoStreamPlayer").Stream = videoStreamTheora;
// VideoStreamPlayer's Autoplay property won't work if the stream is empty
// before this property is set, so call `Play()` after setting `Stream`.
GetNode("VideoStreamPlayer").Play();
```

## 3D scenes

Godot has first-class support for glTF 2.0, both in the editor and exported
projects. Using GLTFDocument and GLTFState together,
Godot can load and save glTF files in exported projects, in both text
(.gltf) and binary (.glb) formats. The binary format should be preferred
as it's faster to write and smaller, but the text format is easier to debug.

Since Godot 4.3, FBX scenes can also be loaded (but not saved) at runtime using the
FBXDocument and FBXState classes. The code to do so
is the same as glTF, but you will need to replace all instances of
GLTFDocument and GLTFState with FBXDocument and FBXState in the
code samples below.

Example of loading a glTF scene and appending its root node to the scene:

```
# Load an existing glTF scene.
# GLTFState is used by GLTFDocument to store the loaded scene's state.
# GLTFDocument is the class that handles actually loading glTF data into a Godot node tree,
# which means it supports glTF features such as lights and cameras.
var gltf_document_load = GLTFDocument.new()
var gltf_state_load = GLTFState.new()
var error = gltf_document_load.append_from_file("/path/to/file.gltf", gltf_state_load)
if error == OK:
    var gltf_scene_root_node = gltf_document_load.generate_scene(gltf_state_load)
    add_child(gltf_scene_root_node)
else:
    show_error("Couldn't load glTF scene (error code: %s)." % error_string(error))
# Save a new glTF scene.
var gltf_document_save := GLTFDocument.new()
var gltf_state_save := GLTFState.new()
gltf_document_save.append_from_scene(gltf_scene_root_node, gltf_state_save)
# The file extension in the output `path` (`.gltf` or `.glb`) determines
# whether the output uses text or binary format.
# `GLTFDocument.generate_buffer()` is also available for saving to memory.
gltf_document_save.write_to_filesystem(gltf_state_save, path)
```

```
// Load an existing glTF scene.
// GLTFState is used by GLTFDocument to store the loaded scene's state.
// GLTFDocument is the class that handles actually loading glTF data into a Godot node tree,
// which means it supports glTF features such as lights and cameras.
var gltfDocumentLoad = new GltfDocument();
var gltfStateLoad = new GltfState();
var error = gltfDocumentLoad.AppendFromFile("/Path/To/File.gltf", gltfStateLoad);
if (error == Error.Ok)
{
    var gltfSceneRootNode = gltfDocumentLoad.GenerateScene(gltfStateLoad);
    AddChild(gltfSceneRootNode);
}
else
{
    GD.PrintErr($"Couldn't load glTF scene (error code: {error}).");
}
// Save a new glTF scene.
var gltfDocumentSave = new GltfDocument();
var gltfStateSave = new GltfState();
gltfDocumentSave.AppendFromScene(gltfSceneRootNode, gltfStateSave);
// The file extension in the output `path` (`.gltf` or `.glb`) determines
// whether the output uses text or binary format.
// `GltfDocument.GenerateBuffer()` is also available for saving to memory.
gltfDocumentSave.WriteToFilesystem(gltfStateSave, path);
```

Note

When loading a glTF scene, a base path must be set so that external
resources like textures can be loaded correctly. When loading from a file,
the base path is automatically set to the folder containing the file. When
loading from a buffer, this base path must be manually set as there is no
way for Godot to infer this path.

To set the base path, set
GLTFState.base_path on your
GLTFState instance before calling
GLTFDocument.append_from_buffer
or GLTFDocument.append_from_file.

## Fonts

FontFile.load_dynamic_font supports the following
font file formats: TTF, OTF, WOFF, WOFF2, PFB, PFM

On the other hand, FontFile.load_bitmap_font supports
the BMFont [https://www.angelcode.com/products/bmfont/] format (.fnt or .font).

Additionally, it is possible to load any font that is installed on the system using
Godot's support for System fonts.

Example of loading a font file automatically according to its file extension,
then adding it as a theme override to a Label node:

```
var path = "/path/to/font.ttf"
var path_lower = path.to_lower()
var font_file = FontFile.new()
if (
        path_lower.ends_with(".ttf")
        or path_lower.ends_with(".otf")
        or path_lower.ends_with(".woff")
        or path_lower.ends_with(".woff2")
        or path_lower.ends_with(".pfb")
        or path_lower.ends_with(".pfm")
):
    font_file.load_dynamic_font(path)
elif path_lower.ends_with(".fnt") or path_lower.ends_with(".font"):
    font_file.load_bitmap_font(path)
else:
    push_error("Invalid font file format.")
if not font_file.data.is_empty():
    # If font was loaded successfully, add it as a theme override.
    $Label.add_theme_font_override("font", font_file)
```

```
string path = "/Path/To/Font.ttf";
var fontFile = new FontFile();
if (
    path.EndsWith(".ttf", StringComparison.OrdinalIgnoreCase)
    || path.EndsWith(".otf", StringComparison.OrdinalIgnoreCase)
    || path.EndsWith(".woff", StringComparison.OrdinalIgnoreCase)
    || path.EndsWith(".woff2", StringComparison.OrdinalIgnoreCase)
    || path.EndsWith(".pfb", StringComparison.OrdinalIgnoreCase)
    || path.EndsWith(".pfm", StringComparison.OrdinalIgnoreCase)
)
{
    fontFile.LoadDynamicFont(path);
}
else if (path.EndsWith(".fnt", StringComparison.OrdinalIgnoreCase) || path.EndsWith(".font", StringComparison.OrdinalIgnoreCase))
{
    fontFile.LoadBitmapFont(path);
}
else
{
    GD.PrintErr("Invalid font file format.");
}
if (!fontFile.Data.IsEmpty())
{
    // If font was loaded successfully, add it as a theme override.
    GetNode("Label").AddThemeFontOverride("font", fontFile);
}
```

## ZIP archives

Godot supports reading and writing ZIP archives using the ZIPReader
and ZIPPacker classes. This supports any ZIP file, including files
generated by Godot's "Export PCK/ZIP" functionality (although these will contain
imported Godot resources rather than the original project files).

Note

Use ProjectSettings.load_resource_pack
to load PCK or ZIP files exported by Godot as
additional data packs. That approach is preferred
for DLCs, as it makes interacting with additional data packs seamless (virtual filesystem).

This ZIP archive support can be combined with runtime image, 3D scene and audio
loading to provide a seamless modding experience without requiring users to go
through the Godot editor to generate PCK/ZIP files.

Example that lists files in a ZIP archive in an ItemList node,
then writes contents read from it to a new ZIP archive (essentially duplicating the archive):

```
# Load an existing ZIP archive.
var zip_reader = ZIPReader.new()
zip_reader.open(path)
var files = zip_reader.get_files()
# The list of files isn't sorted by default. Sort it for more consistent processing.
files.sort()
for file in files:
    $ItemList.add_item(file, null)
    # Make folders disabled in the list.
    $ItemList.set_item_disabled(-1, file.ends_with("/"))
# Save a new ZIP archive.
var zip_packer = ZIPPacker.new()
var error = zip_packer.open(path)
if error != OK:
    push_error("Couldn't open path for saving ZIP archive (error code: %s)." % error_string(error))
    return
# Reuse the above ZIPReader instance to read files from an existing ZIP archive.
for file in zip_reader.get_files():
    zip_packer.start_file(file)
    zip_packer.write_file(zip_reader.read_file(file))
    zip_packer.close_file()
zip_packer.close()
```

```
// Load an existing ZIP archive.
var zipReader = new ZipReader();
zipReader.Open(path);
string[] files = zipReader.GetFiles();
// The list of files isn't sorted by default. Sort it for more consistent processing.
Array.Sort(files);
foreach (string file in files)
{
    GetNode("ItemList").AddItem(file);
    // Make folders disabled in the list.
    GetNode("ItemList").SetItemDisabled(-1, file.EndsWith('/'));
}
// Save a new ZIP archive.
var zipPacker = new ZipPacker();
var error = zipPacker.Open(path);
if (error != Error.Ok)
{
    GD.PrintErr($"Couldn't open path for saving ZIP archive (error code: {error}).");
    return;
}
// Reuse the above ZIPReader instance to read files from an existing ZIP archive.
foreach (string file in zipReader.GetFiles())
{
    zipPacker.StartFile(file);
    zipPacker.WriteFile(zipReader.ReadFile(file));
    zipPacker.CloseFile();
}
zipPacker.Close();
```
