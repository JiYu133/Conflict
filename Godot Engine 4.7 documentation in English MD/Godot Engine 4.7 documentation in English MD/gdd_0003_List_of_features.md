# List of features

This page aims to list all features currently supported by Godot.

Note

This page lists features supported by the current stable version of
Godot. Some of these features are not available in the
3.x release series [https://docs.godotengine.org/en/3.6/about/list_of_features.html].

## Platforms

See also

See System requirements for hardware and software version requirements.

Note

For information about console support, see the Godot website [https://godotengine.org/consoles/].

Can run both the editor and exported projects:

- Windows (x86 and ARM, 64-bit and 32-bit).
- macOS (x86 and ARM, 64-bit only).
- Linux (x86 and ARM, 64-bit and 32-bit).

Binaries are statically linked and can run on any distribution if compiled
on an old enough base distribution.
Official binaries are compiled using the
Godot Engine buildroot [https://github.com/godotengine/buildroot],
allowing for binaries that work across common Linux distributions.
- Android (editor support is experimental).
- Web browsers. Experimental in 4.0,
using Godot 3.x is recommended instead when targeting HTML5.

Note

Linux supports rv64 (RISC-V), ppc64 & ppc32 (PowerPC), and loongarch64. However
you must compile the editor for that platform (as well as export templates)
yourself, no official downloads are currently provided. RISC-V compiling
instructions can be found on the Compiling for Linux, *BSD page.

Runs exported projects:

- iOS.

Godot aims to be as platform-independent as possible and can be
ported to new platforms with relative ease.

Note

Projects written in C# using Godot 4 currently cannot be exported to the
web platform. To use C# on that platform, consider Godot 3 instead.
Android and iOS platform support is available as of Godot 4.2, but is
experimental and some limitations apply.

## Editor

Features:

- Scene tree editor.
- Built-in script editor. Also supports editing text files and using custom
syntax highlighters.
- Support for external script editors such as
Visual Studio Code or Vim.
- GDScript debugger.

Supports debugging in threads.
- Visual profiler with CPU and GPU time indications for each step of the
rendering pipeline.
- Performance monitoring tools, including
custom performance monitors.
- Supports tracing profilers like
Tracy and Perfetto for deeper optimization tasks.
- Any script can be run in the editor
and provide custom functionality such as clickable buttons in the inspector,
without needing to create an editor plugin.
- Live script reloading.
- Live scene editing.

Changes will reflect in the editor and will be kept after closing the running project.
- Live camera replication (disabled by default).

Move the in-editor camera and see the result in the running project.
- Remote inspector.

Changes won't reflect in the editor and won't be kept after closing the running project.
- Run multiple simultaneous project instances from a single editor instance
(useful for client/server testing).
- Optional game embedding to run the project in a panel within the editor.

Select 2D and 3D nodes in the project's viewport to inspect them in the editor.
Move the camera within the project using the 2D and 3D camera overrides.
Supports time scale adjustments, pausing, and frame advance.
Supports muting the project.
  - Select 2D and 3D nodes in the project's viewport to inspect them in the editor.
  - Move the camera within the project using the 2D and 3D camera overrides.
  - Supports time scale adjustments, pausing, and frame advance.
  - Supports muting the project.

- Ruler tool to measure distances in 2D and 3D.
- Vertex snapping support in 3D.
- Support for following the selection as it moves in 3D by using Focus Selection twice.
- Built-in offline class reference documentation.
- Use the editor in dozens of languages contributed by the community.

Plugins:

- Editor plugins can be downloaded from the
asset library to extend editor functionality.
- Create your own plugins using GDScript to add new
features or speed up your workflow.
- Download projects from the asset library
in the Project Manager and import them directly.

## Rendering

Godot 4 includes three renderers:

- Forward+. The most advanced renderer, suited for desktop platforms only.
Used by default on desktop platforms. This renderer uses Vulkan, Direct3D 12,
or Metal as the rendering driver, and it uses the RenderingDevice backend.
- Mobile. Fewer features, but renders simple scenes faster. Suited for mobile
and desktop platforms. Used by default on mobile platforms. This renderer uses
Vulkan, Direct3D 12, or Metal as the rendering driver, and it uses
the RenderingDevice backend.
- Compatibility, sometimes called GL Compatibility. The least advanced
renderer, suited for low-end desktop and mobile platforms. Used by default on
the web platform. This renderer uses OpenGL as the rendering driver.

See also

See Overview of renderers for a detailed comparison of the rendering methods.

## 2D graphics

- Sprite, polygon and line rendering.

High-level tools to draw lines and polygons such as
Polygon2D and Line2D, with support for texturing.
- AnimatedSprite2D as a helper for creating animated sprites.
- Parallax layers.

Pseudo-3D support including preview in the editor.
- 2D lighting with normal maps and specular maps.

Point (omni/spot) and directional 2D lights.
Hard or soft shadows (adjustable on a per-light basis).
Custom shaders can access a real-time SDF
representation of the 2D scene based on LightOccluder2D nodes,
which can be used for improved 2D lighting effects including 2D global illumination.
- Font rendering using bitmaps, rasterization using FreeType
or multi-channel signed distance fields (MSDF).

Bitmap fonts can be exported using tools like BMFont, or imported from images
(for fixed-width fonts only).
Dynamic fonts support monochrome fonts as well as colored fonts (e.g. for emoji).
Supported formats are TTF, OTF, WOFF1 and WOFF2.
Dynamic fonts support optional font outlines with adjustable width and color.
Dynamic fonts support variable fonts and OpenType features including ligatures.
Dynamic fonts support simulated bold and italic when the font file lacks
those styles.
Dynamic fonts support oversampling to keep fonts sharp at higher resolutions.
Dynamic fonts support subpixel positioning to make fonts crisper at low sizes.
Dynamic fonts support LCD subpixel optimizations to make fonts even crisper at low sizes.
Signed distance field fonts can be scaled at any resolution without
requiring re-rasterization. Multi-channel usage makes SDF fonts scale down
to lower sizes better compared to monochrome SDF fonts.
- Oversampling for SVG images
using the DPITexture import type. This allows for sharper results when scaling
up the texture by re-rasterizing the SVG source image to a new resolution at run-time.

Oversampling can optionally take individual CanvasItem scales into
account for crisper rendering when scaling nodes.
  - Oversampling can optionally take individual CanvasItem scales into
account for crisper rendering when scaling nodes.

- GPU-based particles with support for
custom particle shaders.
- CPU-based particles.
- Optional 2D HDR rendering
for better glow capabilities.
- Optional debanding to reduce banding artifacts in gradients.
- HDR output on supported platforms and renderers.

## 2D tools

- TileMaps for 2D tile-based level design.
- 2D camera with built-in smoothing and drag margins.
- Path2D node to represent a path in 2D space.

Can be drawn in the editor or generated procedurally.
PathFollow2D node to make nodes follow a Path2D.
- 2D geometry helper class.

## 2D physics

Physics bodies:

- Static bodies.
- Animatable bodies (for objects moving only by script or animation, such as doors and platforms).
- Rigid bodies.
- Character bodies.
- Joints.
- Areas to detect bodies entering or leaving it.
- Physics interpolation.

Collision detection:

- Built-in shapes: line, box, circle, capsule, world boundary (infinite plane).
- Collision polygons (can be drawn manually or generated from a sprite in the editor).

## 3D graphics

- Linear HDR internal lighting calculations.
- Optional debanding to reduce banding artifacts in gradients.
- HDR output on supported platforms and renderers.
- Perspective, orthographic and frustum-offset cameras.
- When using the Forward+ renderer, a depth prepass is used to improve
performance in complex scenes by reducing the cost of overdraw.
- Variable rate shading on supported GPUs in Forward+ and Mobile.

Physically-based rendering (built-in material features):

- Follows the Disney PBR model.
- Supports Burley, Lambert, Lambert Wrap (half-Lambert) and Toon diffuse shading modes.
- Supports Schlick-GGX, Toon and Disabled specular shading modes.
- Uses a roughness-metallic workflow with support for ORM textures.
- Uses horizon specular occlusion (Filament model) to improve material appearance.
- Normal mapping.
- Parallax/relief mapping with automatic level of detail based on distance.
- Detail mapping for the albedo and normal maps.
- Sub-surface scattering and transmittance.
- Screen-space refraction with support for material roughness (resulting in blurry refraction).
- Proximity fade (soft particles) and distance fade.
- Distance fade can use alpha blending or dithering to avoid going through
the transparent pipeline.
- Dithering can be determined on a per-pixel or per-object basis.

Real-time lighting:

- Directional lights (sun/moon).
- Omnidirectional lights.
- Spot lights with adjustable cone angle and attenuation.
- Rectangular area lights with an optional texture
to determine the shape and color.
- Specular, indirect light, and volumetric fog energy can be adjusted on a per-light basis.
- Adjustable light "size" for spherical omni and disc spot lights (will also make shadows
blurrier with variable penumbra).
- Optional distance fade system to fade distant lights and their shadows, improving performance.
- When using the Forward+ renderer (default on desktop), lights are
rendered with clustered forward optimizations to decrease their individual cost.
Clustered rendering also lifts any limits on the number of lights that can be used on a mesh.
- When using the Mobile renderer, up to 8 omni lights, 8 spot lights, and 8 area lights can
be displayed per mesh resource. Baked lighting can be used to overcome this limit
if needed.

Shadow mapping:

- DirectionalLight3D: Orthogonal (fastest), PSSM 2-split and 4-split.
Supports blending between splits.
- OmniLight3D: Dual paraboloid (fast) or cubemap (slower but more accurate).
Supports colored projector textures in the form of panoramas.
- SpotLight3D: Single texture. Supports colored projector textures.
- AreaLight3D: Single texture with dual paraboloid distortion to approximate
the light's shape.
- Shadow normal offset bias and shadow pancaking to decrease the amount of
visible shadow acne and peter-panning.
- PCSS-like shadow blur based on the
light size and distance from the surface the shadow is cast on. Supported for
all light types.
- Adjustable shadow blur on a per-light basis.

Global illumination with indirect lighting:

- Baked lightmaps (fast, but can't be updated at runtime).

Supports baking indirect light only or baking both direct and indirect lighting.
The bake mode can be adjusted on a per-light basis to allow for hybrid light
baking setups.
Supports lighting dynamic objects using automatic and manually placed probes.
Optionally supports directional lighting based on spherical harmonics.
Optionally supports baking a shadowmask for distant static directional shadows.
Optional supersampling at bake-time to improve quality and reduce light leaking
at the cost of increased bake times and memory usage during baking.
Lightmaps are baked on the GPU using compute shaders (much faster than
CPU lightmapping). Baking can only be performed from the editor, not in
exported projects.
Supports GPU-based denoising
with JNLM out of the box, or higher-quality CPU/GPU-based denoising with
OIDN (requires downloading OIDN separately).
Lightmaps are rendered with bicubic filtering to reduce scaling artifacts.
- Voxel-based GI probes. Supports
dynamic lights and dynamic occluders, while also supporting reflections.
Requires a fast baking step which can be performed in the editor or at
runtime (including from an exported project).
- Signed-distance field GI designed for large open worlds.
Supports dynamic lights, but not dynamic occluders. Supports reflections.
No baking required.
- Screen-space indirect lighting (SSIL)
at half or full resolution. Fully real-time and supports any kind of emissive
light source (including decals).
- VoxelGI and SDFGI use a deferred pass to allow for rendering GI at half
resolution to improve performance (while still having functional MSAA support).

Reflections:

- Voxel-based reflections (when using GI probes) and SDF-based reflections
(when using signed distance field GI). Voxel-based reflections are visible
on transparent surfaces, while rough SDF-based reflections are visible
on transparent surfaces.
- Fast baked reflections or slow real-time reflections using ReflectionProbe.
Parallax box correction can optionally be enabled.
- Screen-space reflections with support for material roughness.
- Reflection techniques can be mixed together for greater accuracy or scalability.
- When using the Forward+ renderer (default on desktop), reflection probes are
rendered with clustered forward optimizations to decrease their individual cost.
Clustered rendering also lifts any limits on the number of reflection probes
that can be used on a mesh.
- When using the Mobile renderer, up to 8 reflection probes can be displayed per mesh
resource. When using the Compatibility renderer, up to 2 reflection probes can
be displayed per mesh resource.

Decals:

- Supports albedo, emissive, ORM,
and normal mapping.
- Texture channels are smoothly overlaid on top of the underlying material,
with support for normal/ORM-only decals.
- Support for normal fade to fade the decal depending on its incidence angle.
- Does not rely on runtime mesh generation. This means decals can be used on
complex skinned meshes with no performance penalty, even if the decal moves every frame.
- Support for nearest, bilinear, trilinear or anisotropic texture filtering (configured globally).
- Optional distance fade system to fade distant decals, improving performance.
- When using the Forward+ renderer (default on desktop), decals are
rendered with clustered forward optimizations to decrease their individual cost.
Clustered rendering also lifts any limits on the number of decals that can be used on a mesh.
- When using the Mobile renderer, up to 8 decals can be displayed per mesh
resource.

Sky:

- Panorama sky (using an HDRI).
- Procedural sky and Physically-based sky that respond to the DirectionalLights in the scene.
- Support for custom sky shaders, which can be animated.
- The radiance map used for ambient and specular light can be updated in
real-time depending on the quality settings chosen.

Fog:

- Exponential depth fog.
- Exponential height fog.
- Support for automatic fog color depending on the sky color (aerial perspective).
- Support for sun scattering in the fog.
- Support for controlling how much fog rendering should affect the sky, with
separate controls for traditional and volumetric fog.
- Support for making specific materials ignore fog.

Volumetric fog:

- Global volumetric fog that reacts to lights and shadows.
- Volumetric fog can take indirect light into account when using VoxelGI or SDFGI.
- Fog volume nodes that can be placed to add fog to specific areas (or remove fog from specific areas).
Supported shapes include box, ellipse, cone, cylinder, and 3D texture-based density maps.
- Each fog volume can have its own custom shader.
- Can be used together with traditional fog.

Particles:

- GPU-based particles with support for subemitters (2D + 3D), trails (2D + 3D),
attractors (3D only) and collision (2D + 3D).

3D particle attractor shapes supported: box, sphere and 3D vector fields.
3D particle collision shapes supported: box, sphere, baked signed distance field
and real-time heightmap (suited for open world weather effects).
2D particle collision is handled using a signed distance field generated in real-time
based on LightOccluder2D nodes in the scene.
Trails can use the built-in ribbon trail and tube trail meshes, or custom
meshes with skeletons.
Support for custom particle shaders with manual emission.
  - 3D particle attractor shapes supported: box, sphere and 3D vector fields.
  - 3D particle collision shapes supported: box, sphere, baked signed distance field
and real-time heightmap (suited for open world weather effects).
  - 2D particle collision is handled using a signed distance field generated in real-time
based on LightOccluder2D nodes in the scene.
  - Trails can use the built-in ribbon trail and tube trail meshes, or custom
meshes with skeletons.
  - Support for custom particle shaders with manual emission.

- CPU-based particles.

Post-processing:

- Tonemapping (Linear, Reinhard, Filmic, ACES, AgX).
- Automatic exposure adjustments based on viewport brightness (and manual exposure override).
- Near and far depth of field with adjustable bokeh simulation (box, hexagon, circle).
- Screen-space ambient occlusion (SSAO) at half or full resolution.
- Glow/bloom with optional bicubic upscaling and several blend modes available:
Screen, Soft Light, Add, Replace, Mix.
- Glow can have a colored dirt map texture, acting as a lens dirt effect.
- Glow can be used as a screen-space blur effect.
- Color correction using a one-dimensional ramp or a 3D LUT texture.
- Roughness limiter to reduce the impact of specular aliasing.
- Brightness, contrast and saturation adjustments.

Texture filtering:

- Nearest, bilinear, trilinear or anisotropic filtering.
- Filtering options are defined on a per-use basis, not a per-texture basis.

Texture VRAM compression:

- BPTC (for high-quality compression targeting desktop platforms).
- ASTC (for high-quality compression targeting mobile platforms).
- ETC2 (for fast compression targeting mobile platforms).
- S3TC (for fast compression targeting desktop platforms).
- Basis Universal (slow, but only requires one encoding for all platforms).

Antialiasing:

- Temporal antialiasing (TAA).
- AMD FidelityFX Super Resolution 2.2 antialiasing (FSR2),
which can be used at native resolution as a form of high-quality temporal antialiasing.
- Multi-sample antialiasing (MSAA), for both 2D antialiasing and 3D antialiasing.
- Fast approximate antialiasing (FXAA).
- Super-sample antialiasing (SSAA) using bilinear 3D scaling and a 3D resolution scale above 1.0.
- Alpha antialiasing, MSAA alpha to coverage and alpha hashing on a per-material basis.

Resolution scaling:

- Support for rendering 3D at a lower resolution
while keeping 2D rendering at the original scale. This can be used to improve
performance on low-end systems or improve visuals on high-end systems.
- Resolution scaling uses nearest-neighbor filtering, bilinear filtering,
AMD FidelityFX Super Resolution 1.0 (FSR1), or AMD FidelityFX Super Resolution 2.2.1
(FSR2).
- Texture mipmap LOD bias is adjusted automatically to improve quality at lower
resolution scales. It can also be modified with a manual offset.

Most effects listed above can be adjusted for better performance or to further
improve quality. This can be helpful when
using Godot for offline rendering.

## 3D tools

- Built-in meshes: cube, cylinder/cone, (hemi)sphere, prism, plane, quad, torus, ribbon, tube.
- GridMaps for 3D tile-based level design.
- Constructive solid geometry (intended for prototyping).
- Tools for procedural geometry generation.
- Path3D node to represent a path in 3D space.

Can be drawn in the editor or generated procedurally.
PathFollow3D node to make nodes follow a Path3D.
- 3D geometry helper class.
- Support for exporting the current scene as a glTF 2.0 file, both from the editor
and at runtime from an exported project.

## 3D physics

Physics bodies:

- Static bodies.
- Animatable bodies (for objects moving only by script or animation, such as doors and platforms).
- Rigid bodies.
- Character bodies.
- Vehicle bodies (intended for arcade physics, not simulation).
- Joints.
- Soft bodies.
- Ragdolls.
- Areas to detect bodies entering or leaving it.
- Physics interpolation.

Collision detection:

- Built-in shapes: cuboid, sphere, capsule, cylinder, world boundary (infinite plane).
- Generate triangle collision shapes for any mesh from the editor.
- Generate one or several convex collision shapes for any mesh from the editor.

## Shaders

- 2D: Custom vertex, fragment, and light shaders.
- 3D: Custom vertex, fragment, light, sky, and fog shaders.
- Custom shaders can procedurally generate and modify textures in real-time using
DrawableTexture2D.
- Text-based shaders using a shader language inspired by GLSL.
- Syntax highlighting is provided on GitHub by using gdshader
as the language name in a Markdown code block.
- Visual shader editor.

Support for visual shader plugins.

## Scripting

General:

- Object-oriented design pattern with scripts extending nodes.
- Signals and groups for communicating between scripts.
- Support for cross-language scripting.
- Many 2D, 3D and 4D linear algebra data types such as vectors and transforms.

GDScript:

- High-level interpreted language with
optional static typing.
- Syntax inspired by Python. However, GDScript is not based on Python.
- Syntax highlighting is provided on GitHub by using gdscript
as the language name in a Markdown code block.
- Use threads to perform asynchronous actions
or make use of multiple processor cores.

C#:

- Packaged in a separate binary to keep file sizes and dependencies down.
- Supports .NET 8 and higher.

Full support for the C# 12.0 syntax and features.
- Supports Windows, Linux, and macOS. Since Godot 4.2, experimental support for
Android and iOS is also available.

On the iOS platform only some architectures are supported: arm64.
The web platform is currently unsupported. To use C# on that platform,
consider Godot 3 instead.
- Using an external editor is recommended to benefit from IDE functionality.

GDExtension (C, C++, Rust, D, ...):

- When you need it, link to native libraries for higher performance and third-party
integrations.

For scripting game logic, GDScript or C# are recommended if their
performance is suitable.
- Official GDExtension bindings for C [https://github.com/godotengine/godot-headers]
and C++ [https://github.com/godotengine/godot-cpp].

Use any build system and language features you wish.
- Actively developed GDExtension bindings for D [https://github.com/godot-dlang/godot-dlang],
Swift [https://github.com/migueldeicaza/SwiftGodot], and Rust [https://github.com/godot-rust/gdextension]
bindings provided by the community. (Some of these bindings may be experimental and not production-ready).

## Audio

Features:

- Mono, stereo, 5.1 and 7.1 output.
- Non-positional and positional playback in 2D and 3D.

Optional Doppler effect in 2D and 3D.
- Support for re-routable audio buses and effects
with dozens of effects included.
- Support for polyphony (playing several sounds from a single AudioStreamPlayer
node).
- Support for random volume and pitch.
- Support for real-time pitch scaling.
- Support for sequential/random sample selection, including repetition prevention
when using random sample selection.
- AudioListener2D and AudioListener3D nodes to listen from a position
different from the camera.
- Support for procedural audio generation.
- Audio input to record microphones.
- Text to speech using platform-provided TTS engines.
- MIDI input.

No support for MIDI output yet.

APIs used:

- Windows: WASAPI.
- macOS: CoreAudio.
- Linux: PulseAudio or ALSA.

## Import

- Support for custom import plugins.

Formats:

- Images: See Importing images.
- Audio:

WAV with optional QOA or IMA-ADPCM compression.
Ogg Vorbis.
MP3.
- 3D scenes: See Importing 3D scenes.

glTF 2.0 (recommended).
.blend (by calling Blender's glTF export functionality transparently).
FBX (by calling FBX2glTF [https://github.com/godotengine/FBX2glTF] transparently).
Collada (.dae).
Wavefront OBJ (static scenes only, can be loaded directly as a mesh or imported as a 3D scene).
- Support for loading glTF 2.0 scenes at runtime, including from an exported project.
- 3D meshes use Mikktspace [http://www.mikktspace.com/] to generate tangents
on import, which ensures consistency with other 3D applications such as Blender.

## Input

- Input mapping system using hardcoded input events
or remappable input actions.

Axis values can be mapped to two different actions with a configurable deadzone.
Use the same code to support both keyboards and gamepads.
- Keyboard input.

Keys can be mapped in "physical" mode to be independent of the keyboard layout.
- Mouse input.

The mouse cursor can be visible, hidden, captured or confined within the window.
The mouse cursor's appearance can be changed to a custom image or one of the
system cursors.
When captured, raw input is used on Windows and Linux to sidestep the OS'
mouse acceleration settings.
- Gamepad input
(up to 8 simultaneous controllers).

Support for changing the LED color
on supported controllers.
Support for reading motion sensors
on supported controllers (used to implement gyro aiming).
  - Support for changing the LED color
on supported controllers.
  - Support for reading motion sensors
on supported controllers (used to implement gyro aiming).

- Pen/tablet input with pressure and tilt support.

## Navigation

- A* algorithm in 2D and 3D.
- Navigation meshes with dynamic obstacle avoidance in
2D and 3D.
- Generate navigation meshes from the editor or at runtime (including from an exported project).

## Networking

- Low-level TCP networking using StreamPeer and TCPServer.
- Low-level UDP networking using PacketPeer and UDPServer.
- Low-level HTTP requests using HTTPClient.
- High-level HTTP requests using HTTPRequest.

Supports HTTPS out of the box using bundled certificates.
- High-level multiplayer API using UDP and ENet.

Automatic replication using remote procedure calls (RPCs).
Supports unreliable, reliable and ordered transfers.
- WebSocket client and server, available on all platforms.
- WebRTC client and server, available on all platforms.
- Support for UPnP to sidestep the requirement to forward ports
when hosting a server behind a NAT.

## Internationalization

- Full support for Unicode including emoji.
- Support for loading system fonts on Windows, macOS, and Linux.

By default, system fonts are used as a fallback to display unsupported
characters. This allows proper display of multilingual text without
having to bundle large font files with a project.
  - By default, system fonts are used as a fallback to display unsupported
characters. This allows proper display of multilingual text without
having to bundle large font files with a project.

- Store localization strings using CSV
or gettext.

Support for generating gettext POT and PO files from the editor.
  - Support for generating gettext POT and PO files from the editor.

- Use localized strings in your project automatically in GUI elements or by
using the tr() function.
- Support for pluralization and translation contexts.
- Support for bidirectional typesetting,
text shaping and OpenType localized forms.
- Automatic UI mirroring for right-to-left locales.
- Support for pseudolocalization to test your project
for i18n-friendliness.

## Windowing and OS integration

- Spawn multiple independent windows within a single process.
- Move, resize, minimize, and maximize windows spawned by the project.
- Change the window title and icon.
- Create transparent windows to use as overlays, with polygon-based
mouse passthrough support.
- Request attention (will cause the title bar to blink on most platforms).
- Fullscreen mode.

Uses borderless fullscreen by default on Windows for fast alt-tabbing,
but can optionally use exclusive fullscreen to reduce input lag.
- Borderless windows (fullscreen or non-fullscreen).
- Keep a window always on top.
- Make a window ignore focus (useful for overlays).
- Declare a window as a popup (hidden from task switcher)
or exclusive (prevents interacting with other windows from the same process).
- Native file dialog support on Windows, macOS, Linux, and Android.
- Tray icon support on Windows and macOS.
- Global menu integration on macOS.
- Client-side decorations on macOS.
- Execute commands in a blocking or non-blocking manner (including running
multiple instances of the same project).
- Open file paths and URLs using default or custom protocol handlers (if registered on the system).
- Parse custom command line arguments.
- Support for screen readers on Windows, macOS, and Linux.
- Any Godot binary (editor or exported project) can be
used as a headless server
by starting it with the --headless command line argument.
This allows running the engine without a GPU or display server.

See also

See Creating applications for details on using these features.

## Mobile

- Virtual joystick and buttons
for touch input.
- In-app purchases on Android
and iOS [https://github.com/godot-sdk-integrations/godot-storekit2].
- Support for advertisements using third-party modules.
- Support for picture-in-picture mode on Android.

## XR support (AR and VR)

- Out of the box support for OpenXR.

Including support for popular desktop headsets like the Valve Index, WMR headsets, and Quest over Link.
- Support for Android-based headsets using OpenXR through a plugin.

Including support for popular standalone headsets like the Meta Quest 1/2/3 and Pro, Pico 4, Magic Leap 2, and Lynx R1.
  - Including support for popular standalone headsets like the Meta Quest 1/2/3 and Pro, Pico 4, Magic Leap 2, and Lynx R1.

- Out of the box limited support for visionOS Apple headsets.

Currently only exporting an application for use on a flat plane within the
headset is supported. Immersive experiences are not supported.
  - Currently only exporting an application for use on a flat plane within the
headset is supported. Immersive experiences are not supported.

- Other devices supported through an XR plugin structure.
- Various advanced toolkits are available that implement common features required by XR applications.

## GUI system

Godot's GUI is built using the same Control nodes used to make games in Godot.
The editor UI can easily be extended in many ways using add-ons.

Nodes:

- Buttons.
- Checkboxes, check buttons, radio buttons.
- Text entry using LineEdit (single line), TextEdit
(multiple lines), and CodeEdit (supports syntax highlighting,
line numbers, and more).
- Dropdown menus using PopupMenu and OptionButton
with support for an optional search bar.
- Scrollbars.
- Labels.
- RichTextLabel for text formatted using BBCode,
with support for animated custom effects.
- Trees (can also be used to represent tables).
- Color picker with RGB, HSV, and OKHSL modes, as well as custom color palettes.
- Controls can be rotated and scaled.
- Drag-and-drop support.

Sizing:

- Anchors to keep GUI elements in a specific corner, edge or centered.
- Containers to place GUI elements automatically following certain rules.

Stack layouts.
Grid layouts.
Flow layouts (similar to autowrapping text).
Margin, centered
and aspect ratio layouts.
Draggable splitter layouts.
Foldable section layouts.
- Scale to multiple resolutions using the
canvas_items or viewport stretch modes.
- Support any aspect ratio using anchors and the expand stretch aspect.

Theming:

- Built-in theme editor.

Generate a theme based on the current editor theme settings.
- Procedural vector-based theming using StyleBoxFlat.

Supports rounded/beveled corners, drop shadows, per-border widths and antialiasing.
- Texture-based theming using StyleBoxTexture.

Godot's small distribution size can make it a suitable alternative to frameworks
like Electron or Qt.

## Animation

- Direct kinematics and inverse kinematics.
- Support for animating any property with customizable interpolation.
- Support for calling methods in animation tracks.
- Support for playing sounds in animation tracks.
- Support for Bézier curves in animation.

## File formats

- Scenes and resources can be saved in text-based or binary formats.

Text-based formats are human-readable and more friendly to version control.
Binary formats are faster to save/load for large scenes/resources.
- Read and write text or binary files using FileAccess.

Can optionally be compressed or encrypted.
- Read and write JSON files.
- Read and write INI-style configuration files using ConfigFile.

Can (de)serialize any Godot datatype, including Vector2/3, Color, ...
- Read XML files using XMLParser.
- Load and save images, audio/video, fonts and ZIP archives
in an exported project without having to go through Godot's import system.
- Pack game data into a PCK file (custom format optimized for fast seeking),
into a ZIP archive, or directly into the executable for single-file distribution.
- Export additional PCK files that can be read
by the engine to support mods and DLCs.

## Miscellaneous

- Video playback with built-in support for Ogg Theora.
- Movie Maker mode to record videos from a running
project with synchronized audio and perfect frame pacing.
- Low-level access to servers which allows bypassing
the scene tree's overhead when needed.
- Command line interface for automation.

Export and deploy projects using continuous integration platforms.
Shell completion scripts [https://github.com/godotengine/godot/tree/master/misc/dist/shell]
are available for Bash, zsh and fish.
Print colored text to standard output on all platforms using
print_rich.
- The editor can
detect features used in a project and create a compilation profile,
which can be used to create smaller export template binaries
with unneeded features disabled.
- Support for C++ modules statically linked
into the engine binary.

Most built-in modules can be disabled at compile-time to reduce binary size
in custom builds. See Optimizing a build for size for details.
  - Most built-in modules can be disabled at compile-time to reduce binary size
in custom builds. See Optimizing a build for size for details.

- Engine and editor written in C++17.

Can be compiled using GCC,
Clang and MSVC. MinGW is also supported.
Friendly towards packagers. In most cases, system libraries can be used
instead of the ones provided by Godot. The build system doesn't download anything.
Builds can be fully reproducible.
- Licensed under the permissive MIT license.

Open development process with contributions welcome [https://contributing.godotengine.org/en/latest/organization/how_to_contribute.html].

See also

The Godot proposals repository [https://github.com/godotengine/godot-proposals]
lists features that have been requested by the community and may be implemented
in future Godot releases.
