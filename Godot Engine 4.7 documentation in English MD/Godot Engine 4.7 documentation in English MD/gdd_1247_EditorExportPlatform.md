# EditorExportPlatform

Inherits: RefCounted < Object

Inherited By: EditorExportPlatformAndroid, EditorExportPlatformAppleEmbedded, EditorExportPlatformExtension, EditorExportPlatformMacOS, EditorExportPlatformPC, EditorExportPlatformWeb

Identifies a supported export platform, and internally provides the functionality of exporting to that platform.

## Description

Base resource that provides the functionality of exporting a release build of a project to a platform, from the editor. Stores platform-specific metadata such as the name and supported features of the platform, and performs the exporting of projects, PCK files, and ZIP files. Uses an export template for the platform provided at the time of project exporting.

Used in scripting by EditorExportPlugin to configure platform-specific customization of scenes and resources. See EditorExportPlugin._begin_customize_scenes() and EditorExportPlugin._begin_customize_resources() for more details.

## Methods

void | add_message(type: ExportMessageType, category: String, message: String)
void | clear_messages()
EditorExportPreset | create_preset()
Error | export_pack(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0)
Error | export_pack_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: BitField[DebugFlags] = 0)
Error | export_project(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0, notify: bool = true)
Error | export_project_files(preset: EditorExportPreset, debug: bool, save_cb: Callable, shared_cb: Callable = Callable())
Error | export_zip(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0)
Error | export_zip_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: BitField[DebugFlags] = 0)
Dictionary | find_export_template(template_file_name: String) const
PackedStringArray | gen_export_flags(flags: BitField[DebugFlags])
Array | get_current_presets() const
PackedStringArray | get_forced_export_files(preset: EditorExportPreset = null) static
Dictionary | get_internal_export_files(preset: EditorExportPreset, debug: bool)
String | get_message_category(index: int) const
int | get_message_count() const
String | get_message_text(index: int) const
ExportMessageType | get_message_type(index: int) const
String | get_os_name() const
ExportMessageType | get_worst_message_type() const
Dictionary | save_pack(preset: EditorExportPreset, debug: bool, path: String, embed: bool = false)
Dictionary | save_pack_patch(preset: EditorExportPreset, debug: bool, path: String)
Dictionary | save_zip(preset: EditorExportPreset, debug: bool, path: String)
Dictionary | save_zip_patch(preset: EditorExportPreset, debug: bool, path: String)
Error | ssh_push_to_remote(host: String, port: String, scp_args: PackedStringArray, src_file: String, dst_file: String) const
Error | ssh_run_on_remote(host: String, port: String, ssh_arg: PackedStringArray, cmd_args: String, output: Array = [], port_fwd: int = -1) const
int | ssh_run_on_remote_no_wait(host: String, port: String, ssh_args: PackedStringArray, cmd_args: String, port_fwd: int = -1) const

---

## Enumerations

enum ExportMessageType
ExportMessageType EXPORT_MESSAGE_NONE = 0

Invalid message type used as the default value when no type is specified.

ExportMessageType EXPORT_MESSAGE_INFO = 1

Message type for informational messages that have no effect on the export.

ExportMessageType EXPORT_MESSAGE_WARNING = 2

Message type for warning messages that should be addressed but still allow to complete the export.

ExportMessageType EXPORT_MESSAGE_ERROR = 3

Message type for error messages that must be addressed and fail the export.

---

flags DebugFlags: 

DebugFlags DEBUG_FLAG_DUMB_CLIENT = 1

Flag is set if the remotely debugged project is expected to use the remote file system. If set, gen_export_flags() will append --remote-fs and --remote-fs-password (if EditorSettings.filesystem/file_server/password is defined) command line arguments to the returned list.

DebugFlags DEBUG_FLAG_REMOTE_DEBUG = 2

Flag is set if remote debug is enabled. If set, gen_export_flags() will append --remote-debug and --breakpoints (if breakpoints are selected in the script editor or added by the plugin) command line arguments to the returned list.

DebugFlags DEBUG_FLAG_REMOTE_DEBUG_LOCALHOST = 4

Flag is set if remotely debugged project is running on the localhost. If set, gen_export_flags() will use localhost instead of EditorSettings.network/debug/remote_host as remote debugger host.

DebugFlags DEBUG_FLAG_VIEW_COLLISIONS = 8

Flag is set if the "Visible Collision Shapes" remote debug option is enabled. If set, gen_export_flags() will append the --debug-collisions command line argument to the returned list.

DebugFlags DEBUG_FLAG_VIEW_NAVIGATION = 16

Flag is set if the "Visible Navigation" remote debug option is enabled. If set, gen_export_flags() will append the --debug-navigation command line argument to the returned list.

---

## Method Descriptions

void add_message(type: ExportMessageType, category: String, message: String) 

Adds a message to the export log that will be displayed when exporting ends.

---

void clear_messages() 

Clears the export log.

---

EditorExportPreset create_preset() 

Create a new preset for this platform.

---

Error export_pack(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0) 

Creates a PCK archive at path for the specified preset.

---

Error export_pack_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: BitField[DebugFlags] = 0) 

Creates a patch PCK archive at path for the specified preset, containing only the files that have changed since the last patch.

Note: patches is an optional override of the set of patches defined in the export preset. When empty the patches defined in the export preset will be used instead.

---

Error export_project(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0, notify: bool = true) 

Creates a full project at path for the specified preset. If notify is true, plugins using EditorExportPlugin._export_begin() will be called during the process.

---

Error export_project_files(preset: EditorExportPreset, debug: bool, save_cb: Callable, shared_cb: Callable = Callable()) 

Exports project files for the specified preset. This method can be used to implement custom export format, other than PCK and ZIP. One of the callbacks is called for each exported file.

save_cb is called for all exported files and have the following arguments: file_path: String, file_data: PackedByteArray, file_index: int, file_count: int, encryption_include_filters: PackedStringArray, encryption_exclude_filters: PackedStringArray, encryption_key: PackedByteArray.

shared_cb is called for exported native shared/static libraries and have the following arguments: file_path: String, tags: PackedStringArray, target_folder: String.

Note: file_index and file_count are intended for progress tracking only and aren't necessarily unique and precise.

---

Error export_zip(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags] = 0) 

Create a ZIP archive at path for the specified preset.

---

Error export_zip_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: BitField[DebugFlags] = 0) 

Create a patch ZIP archive at path for the specified preset, containing only the files that have changed since the last patch.

Note: patches is an optional override of the set of patches defined in the export preset. When empty the patches defined in the export preset will be used instead.

---

Dictionary find_export_template(template_file_name: String) const 

Locates export template for the platform, and returns Dictionary with the following keys: path: String and error: String. This method is provided for convenience and custom export platforms aren't required to use it or keep export templates stored in the same way official templates are.

---

PackedStringArray gen_export_flags(flags: BitField[DebugFlags]) 

Generates array of command line arguments for the default export templates for the debug flags and editor settings.

---

Array get_current_presets() const 

Returns array of EditorExportPresets for this platform.

---

PackedStringArray get_forced_export_files(preset: EditorExportPreset = null) static 

Returns array of core file names that always should be exported regardless of preset config.

---

Dictionary get_internal_export_files(preset: EditorExportPreset, debug: bool) 

Returns additional files that should always be exported regardless of preset configuration, and are not part of the project source. The returned Dictionary contains filename keys (String) and their corresponding raw data (PackedByteArray).

---

String get_message_category(index: int) const 

Returns the message category for the message with the given index.

---

int get_message_count() const 

Returns the number of messages in the export log.

---

String get_message_text(index: int) const 

Returns the text for the message with the given index.

---

ExportMessageType get_message_type(index: int) const 

Returns the type for the message with the given index.

---

String get_os_name() const 

Returns the name of the export operating system handled by this EditorExportPlatform class, as a friendly string. Possible return values are Windows, Linux, macOS, Android, iOS, and Web.

---

ExportMessageType get_worst_message_type() const 

Returns most severe message type currently present in the export log.

---

Dictionary save_pack(preset: EditorExportPreset, debug: bool, path: String, embed: bool = false) 

Saves PCK archive and returns Dictionary with the following keys: result: Error, so_files: Array (array of the shared/static objects which contains dictionaries with the following keys: path: String, tags: PackedStringArray, and target_folder: String).

If embed is true, PCK content is appended to the end of path file and return Dictionary additionally include following keys: embedded_start: int (embedded PCK offset) and embedded_size: int (embedded PCK size).

---

Dictionary save_pack_patch(preset: EditorExportPreset, debug: bool, path: String) 

Saves patch PCK archive and returns Dictionary with the following keys: result: Error, so_files: Array (array of the shared/static objects which contains dictionaries with the following keys: path: String, tags: PackedStringArray, and target_folder: String).

---

Dictionary save_zip(preset: EditorExportPreset, debug: bool, path: String) 

Saves ZIP archive and returns Dictionary with the following keys: result: Error, so_files: Array (array of the shared/static objects which contains dictionaries with the following keys: path: String, tags: PackedStringArray, and target_folder: String).

---

Dictionary save_zip_patch(preset: EditorExportPreset, debug: bool, path: String) 

Saves patch ZIP archive and returns Dictionary with the following keys: result: Error, so_files: Array (array of the shared/static objects which contains dictionaries with the following keys: path: String, tags: PackedStringArray, and target_folder: String).

---

Error ssh_push_to_remote(host: String, port: String, scp_args: PackedStringArray, src_file: String, dst_file: String) const 

Uploads specified file over SCP protocol to the remote host.

---

Error ssh_run_on_remote(host: String, port: String, ssh_arg: PackedStringArray, cmd_args: String, output: Array = [], port_fwd: int = -1) const 

Executes specified command on the remote host via SSH protocol and returns command output in the output.

---

int ssh_run_on_remote_no_wait(host: String, port: String, ssh_args: PackedStringArray, cmd_args: String, port_fwd: int = -1) const 

Executes specified command on the remote host via SSH protocol and returns process ID (on the remote host) without waiting for command to finish.
