# Upgrading from Godot 4.0 to Godot 4.1

For most games and apps made with 4.0, it should be relatively safe to migrate to 4.1.
This page intends to cover everything you need to pay attention to when migrating
your project.

## Breaking changes

If you are migrating from 4.0 to 4.1, the breaking changes listed here might
affect you. Changes are grouped by areas/systems.

Warning

The GDExtension API completely breaks compatibility in 4.1, so it's not included
in the table below. See the Updating your GDExtension for 4.1 section
for more information.

This article indicates whether each breaking change affects GDScript and whether
the C# breaking change is binary compatible or source compatible:

- Binary compatible - Existing binaries will load and execute successfully without
recompilation, and the runtime behavior won't change.
- Source compatible - Source code will compile successfully without changes when
upgrading Godot.

### Core

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Basis |  |  |  |
Method looking_at adds a new use_model_front optional parameter | ✔️ | ✔️ | ✔️ | GH-76082 [https://github.com/godotengine/godot/pull/76082]
Object |  |  |  |
Method get_meta_list changes return type from PackedStringArray to Array[StringName] | ✔️ | ❌ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]
Transform3D |  |  |  |
Method looking_at adds a new use_model_front optional parameter | ✔️ | ✔️ | ✔️ | GH-76082 [https://github.com/godotengine/godot/pull/76082]
UndoRedo |  |  |  |
Method create_action adds a new backward_undo_ops optional parameter | ✔️ | ✔️ | ✔️ | GH-76688 [https://github.com/godotengine/godot/pull/76688]
WorkerThreadPool |  |  |  |
Method wait_for_task_completion changes return type from void to Error | ✔️ | ❌ | ✔️ | GH-77143 [https://github.com/godotengine/godot/pull/77143]

### Animation

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
AnimationNode |  |  |  |
Method _process adds a new test_only parameter | ❌ | ❌ | ❌ | GH-75759 [https://github.com/godotengine/godot/pull/75759]
Method blend_input adds a new test_only optional parameter | ✔️ | ✔️ | ✔️ | GH-75759 [https://github.com/godotengine/godot/pull/75759]
Method blend_node adds a new test_only optional parameter | ✔️ | ✔️ | ✔️ | GH-75759 [https://github.com/godotengine/godot/pull/75759]
AnimationNodeStateMachinePlayback |  |  |  |
Method get_travel_path changes return type from PackedStringArray to Array[StringName] | ✔️ | ❌ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]

### 2D nodes

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
PathFollow2D |  |  |  |
Property lookahead removed | ❌ | ❌ | ❌ | GH-72842 [https://github.com/godotengine/godot/pull/72842]

### 3D nodes

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Geometry3D |  |  |  |
Method segment_intersects_convex changes planes parameter type from untyped Array to Array[Plane] | ✔️ | ✔️ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]
MeshInstance3D |  |  |  |
Method create_multiple_convex_collisions adds a new settings optional parameter | ✔️ | ✔️ | ✔️ | GH-72152 [https://github.com/godotengine/godot/pull/72152]
Node3D |  |  |  |
Method look_at adds a new use_model_front optional parameter | ✔️ | ✔️ | ✔️ | GH-76082 [https://github.com/godotengine/godot/pull/76082]
Method look_at_from_position adds a new use_model_front optional parameter | ✔️ | ✔️ | ✔️ | GH-76082 [https://github.com/godotengine/godot/pull/76082]

### GUI nodes

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
CodeEdit |  |  |  |
Method add_code_completion_option adds a new location optional parameter | ✔️ | ✔️ | ✔️ | GH-75746 [https://github.com/godotengine/godot/pull/75746]
RichTextLabel |  |  |  |
Method push_list adds a new bullet optional parameter | ✔️ | ✔️ | ✔️ | GH-75017 [https://github.com/godotengine/godot/pull/75017]
Method push_paragraph adds a new justification_flags optional parameter | ✔️ | ✔️ | ✔️ | GH-75250 [https://github.com/godotengine/godot/pull/75250]
Method push_paragraph adds a new tab_stops optional parameter | ✔️ | ✔️ | ✔️ | GH-76401 [https://github.com/godotengine/godot/pull/76401]
Tree |  |  |  |
Method edit_selected adds a new force_edit optional parameter | ✔️ | ✔️ | ✔️ | GH-76794 [https://github.com/godotengine/godot/pull/76794]

### Physics

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
Area2D |  |  |  |
Property priority changes type from float to int | ❌ | ❌ | ❌ | GH-72749 [https://github.com/godotengine/godot/pull/72749]
Area3D |  |  |  |
Property priority changes type from float to int | ❌ | ❌ | ❌ | GH-72749 [https://github.com/godotengine/godot/pull/72749]
PhysicsDirectSpaceState2D |  |  |  |
Method collide_shape changes return type from Array[PackedVector2Array] to Array[Vector2] | ❌ | ❌ | ❌ | GH-75260 [https://github.com/godotengine/godot/pull/75260]
PhysicsDirectSpaceState3D |  |  |  |
Method collide_shape changes return type from Array[PackedVector3Array] to Array[Vector3] | ❌ | ❌ | ❌ | GH-75260 [https://github.com/godotengine/godot/pull/75260]

### Rendering

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
RDShaderFile |  |  |  |
Method get_version_list changes return type from PackedStringArray to Array[StringName] | ✔️ | ❌ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]
RenderingDevice |  |  |  |
Method draw_list_begin changes storage_textures parameter type from untyped Array to Array[RID] | ✔️ | ✔️ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]
RenderingServer |  |  |  |
Method global_shader_parameter_get_list changes return type from PackedStringArray to Array[StringName] | ✔️ | ❌ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]
SurfaceTool |  |  |  |
Method add_triangle_fan changes tangents parameter type from untyped Array to Array[Plane] | ✔️ | ✔️ | ❌ | GH-76418 [https://github.com/godotengine/godot/pull/76418]

### Navigation

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
NavigationAgent2D |  |  |  |
Method set_velocity replaced with velocity property | ✔️ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Property time_horizon split into time_horizon_agents and time_horizon_obstacles | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
NavigationAgent3D |  |  |  |
Property agent_height_offset renamed to path_height_offset | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Property ignore_y removed | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method set_velocity replaced with velocity property | ✔️ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Property time_horizon split into time_horizon_agents and time_horizon_obstacles | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
NavigationObstacle2D |  |  |  |
Property estimate_radius removed | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method get_rid renamed to get_agent_rid | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
NavigationObstacle3D |  |  |  |
Property estimate_radius removed | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method get_rid renamed to get_agent_rid | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
NavigationServer2D |  |  |  |
Method agent_set_callback renamed to agent_set_avoidance_callback | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method agent_set_target_velocity removed | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method agent_set_time_horizon split into agent_set_time_horizon_agents and agent_set_time_horizon_obstacles | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
NavigationServer3D |  |  |  |
Method agent_set_callback renamed to agent_set_avoidance_callback | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method agent_set_target_velocity removed | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]
Method agent_set_time_horizon split into agent_set_time_horizon_agents and agent_set_time_horizon_obstacles | ❌ | ❌ | ❌ | GH-69988 [https://github.com/godotengine/godot/pull/69988]

### Networking

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
WebRTCPeerConnectionExtension |  |  |  |
Method _create_data_channel changes return type from Object to WebRTCDataChannel | ✔️ | ❌ | ✔️ | GH-78237 [https://github.com/godotengine/godot/pull/78237]

### Editor plugins

Change | GDScript Compatible | C# Binary Compatible | C# Source Compatible | Introduced
AnimationTrackEditPlugin |  |  |  |
Type AnimationTrackEditPlugin removed | ❌ | ❌ | ❌ | GH-76413 [https://github.com/godotengine/godot/pull/76413]
EditorInterface |  |  |  |
Type EditorInterface changes inheritance from Node to Object | ✔️ | ❌ | ❌ | GH-76176 [https://github.com/godotengine/godot/pull/76176]
Method set_movie_maker_enabled replaced with movie_maker_enabled property | ✔️ | ❌ | ❌ | GH-76176 [https://github.com/godotengine/godot/pull/76176]
Method is_movie_maker_enabled replaced with movie_maker_enabled property | ✔️ | ❌ | ❌ | GH-76176 [https://github.com/godotengine/godot/pull/76176]
EditorResourcePreviewGenerator |  |  |  |
Method _generate adds a new metadata parameter | ❌ | ❌ | ❌ | GH-64628 [https://github.com/godotengine/godot/pull/64628]
Method _generate_from_path adds a new metadata parameter | ❌ | ❌ | ❌ | GH-64628 [https://github.com/godotengine/godot/pull/64628]
EditorUndoRedoManager |  |  |  |
Method create_action adds a new backward_undo_ops optional parameter | ✔️ | ✔️ | ✔️ | GH-76688 [https://github.com/godotengine/godot/pull/76688]

## Behavior changes

In 4.1, some behavior changes have been introduced, which might require you to adjust your project.

Change | Introduced
SubViewportContainer |
When input events should reach SubViewports and their children, SubViewportContainer.mouse_filter now needs to be MOUSE_FILTER_STOP or MOUSE_FILTER_PASS. See GH-79271 [https://github.com/godotengine/godot/issues/79271] for details. | GH-57894 [https://github.com/godotengine/godot/pull/57894]
Multiple layered SubViewportContainer nodes, that should all receive mouse input events, now need to be replaced by Area2D nodes. See GH-79128 [https://github.com/godotengine/godot/issues/79128] for details. | GH-57894 [https://github.com/godotengine/godot/pull/57894]
Viewport |
Viewport nodes, that have Physics Picking enabled, now automatically set InputEvents as handled. See GH-79897 [https://github.com/godotengine/godot/issues/79897] for workarounds. | GH-77595 [https://github.com/godotengine/godot/pull/77595]

## Updating your GDExtension for 4.1

In order to fix a serious bug, in Godot 4.1 we had to break binary compatibility in a big
way and source compatibility in a small way.

This means that GDExtensions made for Godot 4.0 will need to be recompiled for Godot 4.1
(using the  4.1 branch of godot-cpp), with a small change to their source code.

In Godot 4.0, your "entry_symbol" function looks something like this:

```cpp
GDExtensionBool GDE_EXPORT example_library_init(const GDExtensionInterface *p_interface, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);
    init_obj.register_initializer(initialize_example_module);
    init_obj.register_terminator(uninitialize_example_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return init_obj.init();
}
```

However, for Godot 4.1, it should look like:

```cpp
GDExtensionBool GDE_EXPORT example_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);
    init_obj.register_initializer(initialize_example_module);
    init_obj.register_terminator(uninitialize_example_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return init_obj.init();
}
```

There are two small changes:

1. The first argument changes from const GDExtensionInterface *p_interface to GDExtensionInterfaceGetProcAddress p_get_proc_address
2. The constructor for the init_obj variable now receives p_get_proc_address as its first parameter

You also need to add an extra compatibility_minimum line to your .gdextension file, so that it looks something like:

```gdscript
[configuration]
entry_symbol = "example_library_init"
compatibility_minimum = 4.1
```

This lets Godot know that your GDExtension has been updated and is safe to load in Godot 4.1.
