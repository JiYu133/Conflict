# FileDialog

Inherits: ConfirmationDialog < AcceptDialog < Window < Viewport < Node < Object

Inherited By: EditorFileDialog

A dialog for selecting files or directories in the filesystem.

## Description

FileDialog is a preset dialog used to choose files and directories in the filesystem. It supports filter masks. FileDialog automatically sets its window title according to the file_mode. If you want to use a custom title, disable this by setting mode_overrides_title to false.

Note: FileDialog is invisible by default. To make it visible, call one of the popup_* methods from Window on the node, such as Window.popup_centered_clamped().

## Properties

Access | access | 0
String | current_dir |
String | current_file |
String | current_path |
bool | deleting_enabled | true
bool | dialog_hide_on_ok | false (overrides AcceptDialog)
DisplayMode | display_mode | 0
bool | favorites_enabled | true
bool | file_filter_toggle_enabled | true
FileMode | file_mode | 4
bool | file_sort_options_enabled | true
String | filename_filter | ""
PackedStringArray | filters | PackedStringArray()
bool | folder_creation_enabled | true
bool | hidden_files_toggle_enabled | true
bool | layout_toggle_enabled | true
bool | mode_overrides_title | true
int | option_count | 0
int | option_{index}/default | 0
String | option_{index}/name | ""
PackedStringArray | option_{index}/values | PackedStringArray()
bool | overwrite_warning_enabled | true
bool | recent_list_enabled | true
String | root_subfolder | ""
bool | show_hidden_files | false
Vector2i | size | Vector2i(640, 360) (overrides Window)
String | title | "Save a File" (overrides Window)
bool | use_native_dialog | false

## Methods

void | add_filter(filter: String, description: String = "", mime_type: String = "")
void | add_option(name: String, values: PackedStringArray, default_value_index: int)
void | clear_filename_filter()
void | clear_filters()
void | deselect_all()
PackedStringArray | get_favorite_list() static
LineEdit | get_line_edit()
int | get_option_default(option: int) const
String | get_option_name(option: int) const
PackedStringArray | get_option_values(option: int) const
PackedStringArray | get_recent_list() static
Dictionary | get_selected_options() const
VBoxContainer | get_vbox()
void | invalidate()
bool | is_customization_flag_enabled(flag: Customization) const
void | popup_file_dialog()
void | set_customization_flag_enabled(flag: Customization, enabled: bool)
void | set_favorite_list(favorites: PackedStringArray) static
void | set_get_icon_callback(callback: Callable) static
void | set_get_thumbnail_callback(callback: Callable) static
void | set_option_default(option: int, default_value_index: int)
void | set_option_name(option: int, name: String)
void | set_option_values(option: int, values: PackedStringArray)
void | set_recent_list(recents: PackedStringArray) static

## Theme Properties

Color | file_disabled_color | Color(1, 1, 1, 0.25)
Color | file_icon_color | Color(1, 1, 1, 1)
Color | folder_icon_color | Color(1, 1, 1, 1)
int | thumbnail_size | 64
Texture2D | back_folder |
Texture2D | create_folder |
Texture2D | favorite |
Texture2D | favorite_down |
Texture2D | favorite_up |
Texture2D | file |
Texture2D | file_thumbnail |
Texture2D | folder |
Texture2D | folder_thumbnail |
Texture2D | forward_folder |
Texture2D | list_mode |
Texture2D | menu_copy_path |
Texture2D | menu_delete |
Texture2D | menu_new_folder |
Texture2D | menu_open_bundle |
Texture2D | menu_refresh |
Texture2D | menu_show_in_file_manager |
Texture2D | parent_folder |
Texture2D | reload |
Texture2D | sort |
Texture2D | thumbnail_mode |
Texture2D | toggle_filename_filter |
Texture2D | toggle_hidden |

---

## Signals

dir_selected(dir: String) 

Emitted when the user selects a directory.

---

file_selected(path: String) 

Emitted when the user selects a file by double-clicking it or pressing the OK button.

---

filename_filter_changed(filter: String) 

Emitted when the filter for file names changes.

---

files_selected(paths: PackedStringArray) 

Emitted when the user selects multiple files.

---

## Enumerations

enum FileMode
FileMode FILE_MODE_OPEN_FILE = 0

The dialog allows selecting one, and only one file.

FileMode FILE_MODE_OPEN_FILES = 1

The dialog allows selecting multiple files.

FileMode FILE_MODE_OPEN_DIR = 2

The dialog only allows selecting a directory, disallowing the selection of any file.

FileMode FILE_MODE_OPEN_ANY = 3

The dialog allows selecting one file or directory.

FileMode FILE_MODE_SAVE_FILE = 4

The dialog will warn when a file exists.

---

enum Access
Access ACCESS_RESOURCES = 0

The dialog only allows accessing files under the Resource path (res://).

Access ACCESS_USERDATA = 1

The dialog only allows accessing files under user data path (user://).

Access ACCESS_FILESYSTEM = 2

The dialog allows accessing files on the whole file system.

---

enum DisplayMode
DisplayMode DISPLAY_THUMBNAILS = 0

The dialog displays files as a grid of thumbnails. Use thumbnail_size to adjust their size.

DisplayMode DISPLAY_LIST = 1

The dialog displays files as a list of filenames.

---

enum Customization
Customization CUSTOMIZATION_HIDDEN_FILES = 0

Toggles visibility of the favorite button, and the favorite list on the left side of the dialog.

Equivalent to hidden_files_toggle_enabled.

Customization CUSTOMIZATION_CREATE_FOLDER = 1

If enabled, shows the button for creating new directories (when using FILE_MODE_OPEN_DIR, FILE_MODE_OPEN_ANY, or FILE_MODE_SAVE_FILE).

Equivalent to folder_creation_enabled.

Customization CUSTOMIZATION_FILE_FILTER = 2

If enabled, shows the toggle file filter button.

Equivalent to file_filter_toggle_enabled.

Customization CUSTOMIZATION_FILE_SORT = 3

If enabled, shows the file sorting options button.

Equivalent to file_sort_options_enabled.

Customization CUSTOMIZATION_FAVORITES = 4

If enabled, shows the toggle favorite button and favorite list on the left side of the dialog.

Equivalent to favorites_enabled.

Customization CUSTOMIZATION_RECENT = 5

If enabled, shows the recent directories list on the left side of the dialog.

Equivalent to recent_list_enabled.

Customization CUSTOMIZATION_LAYOUT = 6

If enabled, shows the layout switch buttons (list/thumbnails).

Equivalent to layout_toggle_enabled.

Customization CUSTOMIZATION_OVERWRITE_WARNING = 7

If enabled, the FileDialog will warn the user before overwriting files in save mode.

Equivalent to overwrite_warning_enabled.

Customization CUSTOMIZATION_DELETE = 8

If enabled, the context menu will show the "Delete" option, which allows moving files and folders to trash.

Equivalent to deleting_enabled.

---

## Property Descriptions

Access access = 0 

- void set_access(value: Access)
- Access get_access()

The file system access scope.

Warning: In Web builds, FileDialog cannot access the host file system. In sandboxed Linux and macOS environments, use_native_dialog is automatically used to allow limited access to host file system.

---

String current_dir 

- void set_current_dir(value: String)
- String get_current_dir()

The current working directory of the file dialog.

Note: For native file dialogs, this property is only treated as a hint and may not be respected by specific OS implementations.

---

String current_file 

- void set_current_file(value: String)
- String get_current_file()

The currently selected file of the file dialog.

---

String current_path 

- void set_current_path(value: String)
- String get_current_path()

The currently selected file path of the file dialog.

---

bool deleting_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, the context menu will show the "Delete" option, which allows moving files and folders to trash.

---

DisplayMode display_mode = 0 

- void set_display_mode(value: DisplayMode)
- DisplayMode get_display_mode()

Display mode of the dialog's file list.

---

bool favorites_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the toggle favorite button and favorite list on the left side of the dialog.

---

bool file_filter_toggle_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the toggle file filter button.

---

FileMode file_mode = 4 

- void set_file_mode(value: FileMode)
- FileMode get_file_mode()

The dialog's open or save mode, which affects the selection behavior.

---

bool file_sort_options_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the file sorting options button.

---

String filename_filter = "" 

- void set_filename_filter(value: String)
- String get_filename_filter()

The filter for file names (case-insensitive). When set to a non-empty string, only files that contains the substring will be shown. filename_filter can be edited by the user with the filter button at the top of the file dialog.

See also filters, which should be used to restrict the file types that can be selected instead of filename_filter which is meant to be set by the user.

---

PackedStringArray filters = PackedStringArray() 

- void set_filters(value: PackedStringArray)
- PackedStringArray get_filters()

The available file type filters. Each filter string in the array should be formatted like this: *.png,*.jpg,*.jpeg;Image Files;image/png,image/jpeg. The description text of the filter is optional and can be omitted. Both file extensions and MIME type should be always set.

Note: Embedded file dialogs and Windows file dialogs support only file extensions, while Android, Linux, and macOS file dialogs also support MIME types.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

bool folder_creation_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the button for creating new directories (when using FILE_MODE_OPEN_DIR, FILE_MODE_OPEN_ANY, or FILE_MODE_SAVE_FILE), and the context menu will have the "New Folder..." option.

---

bool hidden_files_toggle_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the toggle hidden files button.

---

bool layout_toggle_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the layout switch buttons (list/thumbnails).

---

bool mode_overrides_title = true 

- void set_mode_overrides_title(value: bool)
- bool is_mode_overriding_title()

If true, changing the file_mode property will set the window title accordingly (e.g. setting file_mode to FILE_MODE_OPEN_FILE will change the window title to "Open a File").

---

int option_count = 0 

- void set_option_count(value: int)
- int get_option_count()

The number of additional OptionButtons and CheckBoxes in the dialog.

---

int option_{index}/default = 0 

The default value for the option at index.

Note: index is a value in the 0 .. option_count - 1 range.

---

String option_{index}/name = "" 

The name of the option at index.

Note: index is a value in the 0 .. option_count - 1 range.

---

PackedStringArray option_{index}/values = PackedStringArray() 

The list of values for the option at index.

Note: index is a value in the 0 .. option_count - 1 range.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

bool overwrite_warning_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, the FileDialog will warn the user before overwriting files in save mode.

---

bool recent_list_enabled = true 

- void set_customization_flag_enabled(flag: Customization, enabled: bool)
- bool is_customization_flag_enabled(flag: Customization) const

If true, shows the recent directories list on the left side of the dialog.

---

String root_subfolder = "" 

- void set_root_subfolder(value: String)
- String get_root_subfolder()

If non-empty, the given sub-folder will be "root" of this FileDialog, i.e. user won't be able to go to its parent directory.

Note: This property is ignored by native file dialogs.

---

bool show_hidden_files = false 

- void set_show_hidden_files(value: bool)
- bool is_showing_hidden_files()

If true, the dialog will show hidden files.

Note: This property is ignored by native file dialogs on Android and Linux.

---

bool use_native_dialog = false 

- void set_use_native_dialog(value: bool)
- bool get_use_native_dialog()

If true, and if supported by the current DisplayServer, OS native dialog will be used instead of custom one.

Note: On Android, it is only supported when using ACCESS_FILESYSTEM. For access mode ACCESS_RESOURCES and ACCESS_USERDATA, the system will fall back to custom FileDialog.

Note: On Linux and macOS, sandboxed apps always use native dialogs to access the host file system.

Note: On macOS, sandboxed apps will save security-scoped bookmarks to retain access to the opened folders across multiple sessions. Use OS.get_granted_permissions() to get a list of saved bookmarks.

Note: Native dialogs are isolated from the base process, file dialog properties can't be modified once the dialog is shown.

Note: This property is ignored in EditorFileDialog.

---

## Method Descriptions

void add_filter(filter: String, description: String = "", mime_type: String = "") 

Adds a comma-separated file extension filter and comma-separated MIME type mime_type option to the FileDialog with an optional description, which restricts what files can be picked.

A filter should be of the form "filename.extension", where filename and extension can be * to match any string. Filters starting with . (i.e. empty filenames) are not allowed.

For example, a filter of "*.png, *.jpg", a mime_type of image/png, image/jpeg, and a description of "Images" results in filter text "Images (*.png, *.jpg)".

Note: Embedded file dialogs and Windows file dialogs support only file extensions, while Android, Linux, and macOS file dialogs also support MIME types.

---

void add_option(name: String, values: PackedStringArray, default_value_index: int) 

Adds an additional OptionButton to the file dialog. If values is empty, a CheckBox is added instead.

default_value_index should be an index of the value in the values. If values is empty it should be either 1 (checked), or 0 (unchecked).

---

void clear_filename_filter() 

Clear the filter for file names.

---

void clear_filters() 

Clear all the added filters in the dialog.

---

void deselect_all() 

Clear all currently selected items in the dialog.

---

PackedStringArray get_favorite_list() static 

Returns the list of favorite directories, which is shared by all FileDialog nodes. Useful to store the list of favorites between project sessions. This method can be called only from the main thread.

---

LineEdit get_line_edit() 

Returns the LineEdit for the selected file.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

int get_option_default(option: int) const 

Returns the default value index of the OptionButton or CheckBox with index option.

---

String get_option_name(option: int) const 

Returns the name of the OptionButton or CheckBox with index option.

---

PackedStringArray get_option_values(option: int) const 

Returns an array of values of the OptionButton with index option.

---

PackedStringArray get_recent_list() static 

Returns the list of recent directories, which is shared by all FileDialog nodes. Useful to store the list of recents between project sessions. This method can be called only from the main thread.

---

Dictionary get_selected_options() const 

Returns a Dictionary with the selected values of the additional OptionButtons and/or CheckBoxes. Dictionary keys are names and values are selected value indices.

---

VBoxContainer get_vbox() 

Returns the vertical box container of the dialog, custom controls can be added to it.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

Note: Changes to this node are ignored by native file dialogs, use add_option() to add custom elements to the dialog instead.

---

void invalidate() 

Invalidates and updates this dialog's content list.

Note: This method does nothing on native file dialogs.

---

bool is_customization_flag_enabled(flag: Customization) const 

Returns true if the provided flag is enabled.

---

void popup_file_dialog() 

Shows the FileDialog using the default size and position for file dialogs, and selects the file name if there is a current file.

---

void set_customization_flag_enabled(flag: Customization, enabled: bool) 

Sets the specified customization flag, allowing to customize the features available in this FileDialog.

---

void set_favorite_list(favorites: PackedStringArray) static 

Sets the list of favorite directories, which is shared by all FileDialog nodes. Useful to restore the list of favorites saved with get_favorite_list(). This method can be called only from the main thread.

Note: FileDialog will update its internal ItemList of favorites when its visibility changes. Be sure to call this method earlier if you want your changes to have effect.

---

void set_get_icon_callback(callback: Callable) static 

Sets the callback used by the FileDialog nodes to get a file icon, when DISPLAY_LIST mode is used. The callback should take a single String argument (file path), and return a Texture2D. If an invalid texture is returned, the file icon will be used instead.

---

void set_get_thumbnail_callback(callback: Callable) static 

Sets the callback used by the FileDialog nodes to get a file icon, when DISPLAY_THUMBNAILS mode is used. The callback should take a single String argument (file path), and return a Texture2D. If an invalid texture is returned, the file_thumbnail icon will be used instead.

Thumbnails are usually more complex and may take a while to load. To avoid stalling the application, you can use ImageTexture to asynchronously create the thumbnail.

```gdscript
func _ready():
    FileDialog.set_get_thumbnail_callback(thumbnail_method)
func thumbnail_method(path):
    var image_texture = ImageTexture.new()
    make_thumbnail_async(path, image_texture)
    return image_texture
func make_thumbnail_async(path, image_texture):
    var thumbnail_texture = await generate_thumbnail(path) # Some method that generates a thumbnail.
    image_texture.set_image(thumbnail_texture.get_image())
```

---

void set_option_default(option: int, default_value_index: int) 

Sets the default value index of the OptionButton or CheckBox with index option.

---

void set_option_name(option: int, name: String) 

Sets the name of the OptionButton or CheckBox with index option.

---

void set_option_values(option: int, values: PackedStringArray) 

Sets the option values of the OptionButton with index option.

---

void set_recent_list(recents: PackedStringArray) static 

Sets the list of recent directories, which is shared by all FileDialog nodes. Useful to restore the list of recents saved with set_recent_list(). This method can be called only from the main thread.

Note: FileDialog will update its internal ItemList of recent directories when its visibility changes. Be sure to call this method earlier if you want your changes to have effect.

---

## Theme Property Descriptions

Color file_disabled_color = Color(1, 1, 1, 0.25) 

The color tint for disabled files (when the FileDialog is used in open folder mode).

---

Color file_icon_color = Color(1, 1, 1, 1) 

The color modulation applied to the file icon.

---

Color folder_icon_color = Color(1, 1, 1, 1) 

The color modulation applied to the folder icon.

---

int thumbnail_size = 64 

The size of thumbnail icons when DISPLAY_THUMBNAILS is enabled.

---

Texture2D back_folder 

Custom icon for the back arrow.

---

Texture2D create_folder 

Custom icon for the create folder button.

---

Texture2D favorite 

Custom icon for favorite folder button.

---

Texture2D favorite_down 

Custom icon for button to move down a favorite entry.

---

Texture2D favorite_up 

Custom icon for button to move up a favorite entry.

---

Texture2D file 

Custom icon for files.

---

Texture2D file_thumbnail 

Icon for files when in thumbnail mode.

---

Texture2D folder 

Custom icon for folders.

---

Texture2D folder_thumbnail 

Icon for folders when in thumbnail mode.

---

Texture2D forward_folder 

Custom icon for the forward arrow.

---

Texture2D list_mode 

Icon for the button that enables list mode.

---

Texture2D menu_copy_path 

Icon for the "Copy Path" context menu option.

---

Texture2D menu_delete 

Icon for the "Delete" context menu option.

---

Texture2D menu_new_folder 

Icon for the "New Folder..." context menu option. Usually it should be the same as create_folder; leave it empty if you want the context menu to show no icons.

---

Texture2D menu_open_bundle 

Icon for the "Show Package Contents" context menu option. The option only appears for macOS bundles.

---

Texture2D menu_refresh 

Icon for the "Refresh" context menu option. Usually it should be the same as reload; leave it empty if you want the context menu to show no icons.

---

Texture2D menu_show_in_file_manager 

Icon for the "Show in File Manager" context menu option.

---

Texture2D parent_folder 

Custom icon for the parent folder arrow.

---

Texture2D reload 

Custom icon for the reload button.

---

Texture2D sort 

Custom icon for the sorting options menu.

---

Texture2D thumbnail_mode 

Icon for the button that enables thumbnail mode.

---

Texture2D toggle_filename_filter 

Custom icon for the toggle button for the filter for file names.

---

Texture2D toggle_hidden 

Custom icon for the toggle hidden button.
