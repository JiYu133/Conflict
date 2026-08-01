# Upgrading from Godot 4.1 to Godot 4.2

For most games and apps made with 4.1 it should be relatively safe to migrate to 4.2.
This page intends to cover everything you need to pay attention to when migrating
your project.

## Breaking changes

If you are migrating from 4.1 to 4.2, the breaking changes listed here might
affect you. Changes are grouped by areas/systems.

Warning

The Mesh resource format has changed in 4.2 to allow for
vertex and attribute compression [https://github.com/godotengine/godot/pull/81138].
This allows for improved rendering performance, especially on platforms
constrained by memory bandwidth such as mobile.

It is still possible to load the Godot 4.0-4.1 Mesh formats, but it is
not possible to load the Godot 4.2 Mesh format in prior Godot versions.
When opening a Godot project made with a version prior to 4.2, you may
be presented with an upgrade dialog that offers two options:

- Restart & Upgrade: Upgrades the mesh format for all meshes in the
project and saves the result to disk. Once chosen, this option prevents
downgrading the project to a Godot version prior to 4.2. Set up a
version control system and push your changes before choosing this option!
- Upgrade Only: Upgrades the mesh format in-memory without writing it
to disk. This allows downgrading the project to a Godot version older than 4.2
if you need to do so in the future. The downside is that loading the project
will be slower every time as the mesh format needs to be upgraded every time
the project is loaded. These increased loading times will also affect the
exported project. The number and complexity of Mesh resources determines
how much loading times are affected.

If this dialog doesn't appear, use Project > Tools > Upgrade Mesh Surfaces…
at the top of the editor.

This article indicates whether each breaking change affects GDScript and whether
the C# breaking change is binary compatible or source compatible:

- Binary compatible - Existing binaries will load and execute successfully without
recompilation, and the runtime behavior won't change.
- Source compatible - Source code will compile successfully without changes when
upgrading Godot.

### Core

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Node |  |  |  |
Constant NOTIFICATION_NODE_RECACHE_REQUESTED removed | ❌ | ✔️ | ❌ | GH-84419 [https://github.com/godotengine/godot/pull/84419]

### Animation

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
AnimationPlayer |  |  |  |
Method _post_process_key_value moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method add_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method advance moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_finished moved to base class AnimationMixer | ✔️ | ❌ | ❌ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_started moved to base class AnimationMixer | ✔️ | ❌ | ❌ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_libraries_updated moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_list_changed moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property audio_max_polyphony moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal caches_cleared moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method clear_caches moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method find_animation moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method find_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_animation moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_animation_library_list moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_animation_list moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method has_animation moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method has_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property method_call_mode renamed to callback_mode_method and moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property playback_active renamed to active and moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property playback_process_mode renamed to callback_mode_process and moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method remove_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method rename_animation_library moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property reset_on_save moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property root_node moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method set_reset_on_save_enabled moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method seek adds a new update_only optional parameter | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
AnimationTree |  |  |  |
Method _post_process_key_value moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property active moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method advance moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_finished moved to base class AnimationMixer | ✔️ | ❌ | ❌ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Signal animation_started moved to base class AnimationMixer | ✔️ | ❌ | ❌ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property audio_max_polyphony moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_position moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_position_accumulator moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_rotation moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_rotation_accumulator moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_scale moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Method get_root_motion_scale_accumulator moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property process_callback renamed to callback_mode_process and moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property root_motion_track  moved to base class AnimationMixer | ✔️ | ✔️ | ✔️ | GH-80813 [https://github.com/godotengine/godot/pull/80813]
Property tree_root changes type from AnimationNode to AnimationRootNode | ✔️ | ❌ | ❌ | GH-80813 [https://github.com/godotengine/godot/pull/80813]

### GUI nodes

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
PopupMenu |  |  |  |
Method add_icon_shortcut adds a new allow_echo optional parameter | ✔️ | ✔️ | ✔️ | GH-36493 [https://github.com/godotengine/godot/pull/36493]
Method add_shortcut adds a new allow_echo optional parameter | ✔️ | ✔️ | ✔️ | GH-36493 [https://github.com/godotengine/godot/pull/36493]
Method clear adds a new free_submenus optional parameter | ✔️ | ✔️ | ✔️ | GH-79965 [https://github.com/godotengine/godot/pull/79965]
RichTextLabel |  |  |  |
Method add_image adds new key, pad, tooltip, and size_in_percent optional parameters | ✔️ | ✔️ | ✔️ | GH-80410 [https://github.com/godotengine/godot/pull/80410]

### Rendering

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
ImporterMesh |  |  |  |
Method add_surface changes flags parameter type from uint32 to uint64 | ✔️ | ✔️ | ✔️ | GH-81138 [https://github.com/godotengine/godot/pull/81138]
Method get_surface_format changes return type from uint32 to uint64 | ✔️ | ❌ | ❌ | GH-81138 [https://github.com/godotengine/godot/pull/81138]
MeshDataTool |  |  |  |
Method commit_to_surface adds a new compression_flags optional parameter | ✔️ | ✔️ | ✔️ | GH-81138 [https://github.com/godotengine/godot/pull/81138]
Method get_format changes return type from uint32 to uint64 | ✔️ | ❌ | ❌ | GH-81138 [https://github.com/godotengine/godot/pull/81138]
RenderingDevice |  |  |  |
Enum field BarrierMask.BARRIER_MASK_RASTER changes value from 1 to 9 | ✔️ | ✔️ | ✔️ | GH-79911 [https://github.com/godotengine/godot/pull/79911]
Enum field BarrierMask.BARRIER_MASK_ALL_BARRIERS changes value from 7 to 32767 | ✔️ | ✔️ | ✔️ | GH-79911 [https://github.com/godotengine/godot/pull/79911]
Enum field BarrierMask.BARRIER_MASK_NO_BARRIER changes value from 8 to 32768 | ✔️ | ✔️ | ✔️ | GH-79911 [https://github.com/godotengine/godot/pull/79911]
Method shader_create_from_bytecode adds a new placeholder_rid optional parameter | ✔️ | ✔️ | ✔️ | GH-79606 [https://github.com/godotengine/godot/pull/79606]
Method shader_get_vertex_input_attribute_ask changes return type from uint32 to uint64 | ✔️ | ❌ | ❌ | GH-81138 [https://github.com/godotengine/godot/pull/81138]
SurfaceTool |  |  |  |
Method commit changes flags parameter type from uint32 to uint64 | ✔️ | ✔️ | ✔️ | GH-81138 [https://github.com/godotengine/godot/pull/81138]

### Text

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Font |  |  |  |
Method set_fallbacks replaced with fallbacks property | ✔️ | ❌ | ❌ | GH-78266 [https://github.com/godotengine/godot/pull/78266]
Method get_fallbacks replaced with fallbacks property | ✔️ | ❌ | ❌ | GH-78266 [https://github.com/godotengine/godot/pull/78266]
Method find_variation adds new spacing_top, spacing_bottom, spacing_space, and spacing_glyph optional parameters | ✔️ | ✔️ | ✔️ | GH-80954 [https://github.com/godotengine/godot/pull/80954]

### GraphEdit

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
GraphEdit |  |  |  |
Property arrange_nodes_button_hidden renamed to show_arrange_button | ❌ | ✔️ | ✔️ | GH-81582 [https://github.com/godotengine/godot/pull/81582]
Method get_zoom_hbox renamed to get_menu_hbox | ❌ | ✔️ | ✔️ | GH-79308 [https://github.com/godotengine/godot/pull/79308]
Property snap_distance renamed to snapping_distance | ❌ | ✔️ | ✔️ | GH-79308 [https://github.com/godotengine/godot/pull/79308]
Property use_snap renamed to snapping_enabled | ❌ | ✔️ | ✔️ | GH-79308 [https://github.com/godotengine/godot/pull/79308]
GraphNode |  |  |  |
Property comment removed | ❌ | ❌ | ❌ | GH-79307 [https://github.com/godotengine/godot/pull/79307]
Signal close_request renamed to delete_request and moved to base class GraphElement | ❌ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property draggable moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property draggable moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal dragged moved to base class GraphElement | ✔️ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_color removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_count removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_height removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_position removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_slot removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_input_type removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_color removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_count removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_height removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_position removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_slot removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Method get_connection_output_type removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property language removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal node_deselected moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal node_selected moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property overlay removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property position_offset moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal position_offset_changed moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal raise_request moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property resizable moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Signal resize_request moved to base class GraphElement | ✔️ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property selectable moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property selected moved to base class GraphElement | ✔️ | ✔️ | ✔️ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property show_close removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]
Property text_direction removed | ❌ | ❌ | ❌ | GH-79311 [https://github.com/godotengine/godot/pull/79311]

### TileMap

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
TileMap |  |  |  |
Property cell_quadrant_size renamed to rendering_quadrant_size | ❌ | ✔️ | ✔️ | GH-81070 [https://github.com/godotengine/godot/pull/81070]

### XR

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
XRInterface |  |  |  |
Property environment_blend_mode added | ✔️ | ❌ | ❌ | GH-81561 [https://github.com/godotengine/godot/pull/81561]

Note

This change breaks compatibility in C# because the new property conflicts with the name of an existing enum
and the C# bindings generator gives priority to properties, so the enum type was renamed from
EnvironmentBlendMode to EnvironmentBlendModeEnum.
