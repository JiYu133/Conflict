# Upgrading from Godot 4.6 to Godot 4.7

For most games and apps made with 4.6 it should be relatively safe to migrate to 4.7.
This page intends to cover everything you need to pay attention to when migrating
your project.

## Breaking changes

If you are migrating from 4.6 to 4.7, the breaking changes listed here might
affect you. Changes are grouped by areas/systems.

This article indicates whether each breaking change affects GDScript and whether
the C# breaking change is binary compatible or source compatible:

- Binary compatible - Existing binaries will load and execute successfully without
recompilation, and the runtime behavior won't change.
- Source compatible - Source code will compile successfully without changes when
upgrading Godot.

### Core

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Object |  |  |  |
Method is_class changes class parameter type from String to StringName | ✔️ | ✔️ | ✔️ | GH-118582 [https://github.com/godotengine/godot/pull/118582]
ZIPPacker |  |  |  |
Method start_file adds new permissions and modified_time optional parameters | ✔️ | ✔️ | ✔️ | GH-115946 [https://github.com/godotengine/godot/pull/115946]
OptimizedTranslation |  |  |  |
Method generate changes return type from void to bool | ✔️ | ❌ | ✔️ | GH-119563 [https://github.com/godotengine/godot/pull/119563]

### 2D

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
CPUParticles2D |  |  |  |
Method request_particles_process adds new process_time_residual optional parameter | ✔️ | ✔️ | ✔️ | GH-109142 [https://github.com/godotengine/godot/pull/109142]
GPUParticles2D |  |  |  |
Method request_particles_process adds new process_time_residual optional parameter | ✔️ | ✔️ | ✔️ | GH-109142 [https://github.com/godotengine/godot/pull/109142]

### 3D

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
CPUParticles3D |  |  |  |
Method request_particles_process adds new process_time_residual optional parameter | ✔️ | ✔️ | ✔️ | GH-109142 [https://github.com/godotengine/godot/pull/109142]
GPUParticles3D |  |  |  |
Method request_particles_process adds new process_time_residual optional parameter | ✔️ | ✔️ | ✔️ | GH-109142 [https://github.com/godotengine/godot/pull/109142]

### GUI nodes

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Control |  |  |  |
Property accessibility_live changes type from DisplayServer.AccessibilityLiveMode to AccessibilityServer.AccessibilityLiveMode | ✔️ | ❌ | ❌ | GH-116839 [https://github.com/godotengine/godot/pull/116839]
RichTextLabel |  |  |  |
Enum field ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT renamed to ImageUpdateMask.UPDATE_WIDTH_UNIT | ❌ | ✔️ | ❌ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method add_image changes width parameter type from int to float | ✔️ | ✔️ | ✔️ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method add_image changes height parameter type from int to float | ✔️ | ✔️ | ✔️ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method add_image renames width_in_percent parameter to width_unit and changes type from bool to RichTextLabel.ImageUnit | ✔️ | ✔️ | ❌ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method add_image renames height_in_percent parameter to height_unit and changes type from bool to RichTextLabel.ImageUnit | ✔️ | ✔️ | ❌ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method update_image changes width parameter type from int to float | ✔️ | ✔️ | ✔️ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method update_image changes height parameter type from int to float | ✔️ | ✔️ | ✔️ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method update_image renames width_in_percent parameter to width_unit and changes type from bool to RichTextLabel.ImageUnit | ✔️ | ✔️ | ❌ | GH-112617 [https://github.com/godotengine/godot/pull/112617]
Method update_image renames height_in_percent parameter to height_unit and changes type from bool to RichTextLabel.ImageUnit | ✔️ | ✔️ | ❌ | GH-112617 [https://github.com/godotengine/godot/pull/112617]

### Text

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Font |  |  |  |
Method find_variation adds new palette_index and custom_colors optional parameters | ✔️ | ✔️ | ✔️ | GH-117149 [https://github.com/godotengine/godot/pull/117149]
TreeItem |  |  |  |
Method select adds new set_as_cursor optional parameter | ✔️ | ✔️ | ✔️ | GH-119367 [https://github.com/godotengine/godot/pull/119367]

### Rendering

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Image |  |  |  |
Method save_exr adds new color_image and max_linear_value optional parameters | ✔️ | ✔️ | ✔️ | GH-117800 [https://github.com/godotengine/godot/pull/117800]
Method save_exr_to_buffer adds new color_image and max_linear_value optional parameters | ✔️ | ✔️ | ✔️ | GH-117800 [https://github.com/godotengine/godot/pull/117800]
ImageTexture |  |  |  |
Method get_format moved to base class Texture2D | ✔️ | ✔️ | ✔️ | GH-109004 [https://github.com/godotengine/godot/pull/109004]
PortableCompressedTexture2D |  |  |  |
Method get_format moved to base class Texture2D | ✔️ | ✔️ | ✔️ | GH-109004 [https://github.com/godotengine/godot/pull/109004]
RenderingServer |  |  |  |
Method particles_request_process_time renames time parameter to process_time and adds new process_time_residual optional parameter | ✔️ | ✔️ | ❌ | GH-109142 [https://github.com/godotengine/godot/pull/109142]
Method viewport_set_size adds new view_count optional parameter | ✔️ | ✔️ | ✔️ | GH-115799 [https://github.com/godotengine/godot/pull/115799]

### Animation

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Animation |  |  |  |
Property length changes type metadata from float to double | ✔️ | ❌ | ❌ | GH-116394 [https://github.com/godotengine/godot/pull/116394]
AnimationNodeBlendSpace1D |  |  |  |
Method add_blend_point adds new name optional parameter | ✔️ | ✔️ | ✔️ | GH-110369 [https://github.com/godotengine/godot/pull/110369]
AnimationNodeBlendSpace2D |  |  |  |
Method add_blend_point adds new name optional parameter | ✔️ | ✔️ | ✔️ | GH-110369 [https://github.com/godotengine/godot/pull/110369]

### Physics

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
PhysicsServer2D |  |  |  |
Method body_set_shape_as_one_way_collision adds new direction optional parameter | ✔️ | ✔️ | ✔️ | GH-104736 [https://github.com/godotengine/godot/pull/104736]
PhysicsServer2DExtension |  |  |  |
Method _body_set_shape_as_one_way_collision adds new direction parameter | ❌ | ❌ | ❌ | GH-104736 [https://github.com/godotengine/godot/pull/104736]

### Audio

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
AudioEffectSpectrumAnalyzer |  |  |  |
Property tap_back_pos removed | ❌ | ❌ | ❌ | GH-114355 [https://github.com/godotengine/godot/pull/114355]

### XR

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
OpenXRExtensionWrapper |  |  |  |
Method _on_register_metadata adds new interaction_profile_metadata parameter | ❌ | ❌ | ❌ | GH-117399 [https://github.com/godotengine/godot/pull/117399]
OpenXRSpatialAnchorCapability |  |  |  |
Method create_new_anchor adds new next optional parameter | ✔️ | ✔️ | ✔️ | GH-118128 [https://github.com/godotengine/godot/pull/118128]

### Editor

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
EditorSceneFormatImporter |  |  |  |
Constant IMPORT_ANIMATION moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_DISCARD_MESHES_AND_MATERIALS moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_FAIL_ON_MISSING_DEPENDENCIES moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_FORCE_DISABLE_MESH_COMPRESSION moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_GENERATE_TANGENT_ARRAYS moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_SCENE moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
Constant IMPORT_USE_NAMED_SKIN_BINDS moved to enum ImportFlags | ✔️ | ✔️ | ❌ | GH-115788 [https://github.com/godotengine/godot/pull/115788]
EditorVCSInterface |  |  |  |
Method _commit adds new amend parameter | ❌ | ❌ | ❌ | GH-117968 [https://github.com/godotengine/godot/pull/117968]

## Behavior changes

### Rendering

Note

The LinearToSRGB visual shader no longer clamps to the range [0.0, 1.0]
when using the Mobile or Forward+ renderer (GH-113956 [https://github.com/godotengine/godot/pull/113956]).

Note

CanvasItem now avoids adding the antialiasing feather when drawing lines (GH-105122 [https://github.com/godotengine/godot/pull/105122]).
The feather made lines appear thicker than intended, projects that relied on this behavior
will have to be updated to draw a thicker line width.

### Physics

Note

The default area_mask for AudioStreamPlayer was changed from 1 to 0 (disabled) (GH-107679 [https://github.com/godotengine/godot/pull/107679]).
If you use the audio_bus_override feature on Area2D or Area3D, and you
use the AudioStreamPlayer default area_mask (just layer 1 ticked), you will need
to reset the mask to layer 1 — otherwise, the bus overrides will stop working.
If the mask was set to anything except layer 1, it will continue to work as expected.

Note

When using Jolt Physics as the 3D physics engine, WorldBoundaryShape3D will now use the same
convention as Godot when applying WorldBoundaryShape3D.plane.d, resulting in the sign of the plane
distance being interpreted in the opposite way compared to Godot 4.6 (GH-118948 [https://github.com/godotengine/godot/pull/118948]). You will need to flip
the sign yourself to get the same behavior as in Godot 4.6.

Note

When using Jolt Physics as the 3D physics engine, SoftBody3D will no longer default its mass to 0,
which resulted in an automatically calculated weight of 1 kg per point, resulting in a very high total
mass for the body. Now instead it will default to 1 kg for the entire SoftBody3D, same as Godot
Physics (GH-116041 [https://github.com/godotengine/godot/pull/116041]).

Note

When using Jolt Physics as the 3D physics engine, SoftBody3D will now apply
SoftBody3D.linear_stiffness in a way that better matches Godot Physics, and in a way that's more
appropriate in general (GH-116041 [https://github.com/godotengine/godot/pull/116041]). This will affect every SoftBody3D instance in one way or
another, meaning you will need to re-tweak properties like SoftBody3D.linear_stiffness and
SoftBody3D.damping_coefficient to achieve your desired behavior.

Note

When using Jolt Physics as the 3D physics engine, Area3D will now report overlaps with SoftBody3D
from its various signals and methods (GH-114198 [https://github.com/godotengine/godot/pull/114198]). To work around this breaking change, configure your
collision layers/masks such that any undesirable interactions between Area3D and SoftBody3D are
ignored.

### Input

Note

The device IDs for mouse and keyboard were changed from 0 to InputEvent.DEVICE_ID_MOUSE and
InputEvent.DEVICE_ID_KEYBOARD because some joypads may use 0 as their ID (GH-116274 [https://github.com/godotengine/godot/pull/116274]).
Check the input event by type or compare the device ID InputEvent.device to the constants
InputEvent.DEVICE_ID_MOUSE and InputEvent.DEVICE_ID_KEYBOARD instead.

### GDScript

Note

Setting the element of packed arrays no longer calls the setter for the entire packed array property
(GH-113228 [https://github.com/godotengine/godot/pull/113228]).

Note

Methods that inherit from a method with a typed return now inherit the return type as well,
requiring an explicit return statement in the override (GH-115763 [https://github.com/godotengine/godot/pull/115763]).
Add return null to the end of the method to fix the error.

## Changed defaults

The following default values have been changed. If your project uses any of these properties
with their default value, you can achieve a similar behavior to the previous version by manually
setting the values to match the old defaults.

### Animation

Property/Parameter | Old Default | New Default
LookAtModifier3D |  |
Property relative | true | false

### Core

Property/Parameter | Old Default | New Default
ProjectSettings |  |
Property rendering/reflections/sky_reflections/roughness_layers | 7 | 8

### GUI nodes

Property/Parameter | Old Default | New Default
RichTextLabel |  |
Method add_image parameter width_in_percent | false | 0
Method add_image parameter height_in_percent | false | 0
Method update_image parameter width_in_percent | false | 0
Method update_image parameter height_in_percent | false | 0

### Import

Property/Parameter | Old Default | New Default
ResourceImporterDynamicFont |  |
Property hinting | 1 | 3
