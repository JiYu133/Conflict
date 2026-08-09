# File paths in Godot projects

This page explains how file paths work inside Godot projects. You will learn how
to access paths in your projects using the res:// and user:// notations,
and where Godot stores project and editor files on your and your users' systems.

## Path separators

To make supporting multiple platforms easier, Godot uses UNIX-style path
separators (forward slash /). These work on all platforms, including
Windows.

Instead of writing paths like C:\Projects\Game, in Godot, you should write
C:/Projects/Game.

Windows-style path separators (backward slash \) are also supported in some
path-related methods, but they need to be doubled (\\), as \ is normally
used as an escape for characters with a special meaning.

This makes it possible to work with paths returned by other Windows
applications. We still recommend using only forward slashes in your own code to
guarantee that everything will work as intended.

Tip

The String class offers over a dozen methods to work with strings that represent file paths:

- String.filecasecmp_to()
- String.filenocasecmp_to()
- String.get_base_dir()
- String.get_basename()
- String.get_extension()
- String.get_file()
- String.is_absolute_path()
- String.is_relative_path()
- String.is_valid_filename()
- String.path_join()
- String.simplify_path()
- String.validate_filename()

## Accessing files in the project folder (res://)

Godot considers that a project exists in any folder that contains a
project.godot text file, even if the file is empty. The folder that contains
this file is your project's root folder.

You can access any file relative to it by writing paths starting with
res://, which stands for resources. For example, you can access an image
file character.png located in the project's root folder in code with the
following path: res://character.png.

## Accessing persistent user data (user://)

To store persistent data files, like the player's save or settings, you want to
use user:// instead of res:// as your path's prefix. This is because
when the game is running, the project's file system will likely be read-only.

The user:// prefix points to a different directory on the user's device.
Unlike res://, the directory pointed at by user:// is created
automatically and guaranteed to be writable to, even in an exported project.

The location of the user:// folder depends on what is configured in the
Project Settings:

- By default, the user:// folder is created within Godot's
editor data path in the
app_userdata/[project_name] folder. This is the default so that prototypes
and test projects stay self-contained within Godot's data folder.
- If application/config/use_custom_user_dir
is enabled in the Project Settings, the user:// folder is created next
to Godot's editor data path, i.e. in the standard location for applications
data.

By default, the folder name will be inferred from the project name, but it
can be further customized with
application/config/custom_user_dir_name.
This path can contain path separators, so you can use it e.g. to group
projects of a given studio with a Studio Name/Game Name structure.
  - By default, the folder name will be inferred from the project name, but it
can be further customized with
application/config/custom_user_dir_name.
This path can contain path separators, so you can use it e.g. to group
projects of a given studio with a Studio Name/Game Name structure.

On desktop platforms, the actual directory paths for user:// are:

Type | Location
Default | Windows: %APPDATA%\Godot\app_userdata\[project_name]
macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
Linux: ~/.local/share/godot/app_userdata/[project_name]
Custom dir | Windows: %APPDATA%\[project_name]
macOS: ~/Library/Application Support/[project_name]
Linux: ~/.local/share/[project_name]
Custom dir and name | Windows: %APPDATA%\[custom_user_dir_name]
macOS: ~/Library/Application Support/[custom_user_dir_name]
Linux: ~/.local/share/[custom_user_dir_name]

[project_name] is based on the application name defined in the Project Settings, but
you can override it on a per-platform basis using feature tags.

On mobile platforms, this path is unique to the project and is not accessible
by other applications for security reasons.

On HTML5 exports, user:// will refer to a virtual filesystem stored on the
device via IndexedDB. (Interaction with the main filesystem can still be performed
through the JavaScriptBridge singleton.)

## File logging

See also

Documentation on file logging has been moved to Logging.

## Converting paths to absolute paths or "local" paths

You can use ProjectSettings.globalize_path()
to convert a "local" path like res://path/to/file.txt to an absolute OS path.
For example, ProjectSettings.globalize_path()
can be used to open "local" paths in the OS file manager
using OS.shell_open() since it only accepts
native OS paths.

To convert an absolute OS path to a "local" path starting with res://
or user://, use ProjectSettings.localize_path().
This only works for absolute paths that point to files or folders in your
project's root or user:// folders.

## Editor data paths

The editor uses different paths for editor data, editor settings, and cache,
depending on the platform. By default, these paths are:

Type | Location
Editor data | Windows: %APPDATA%\Godot\
macOS: ~/Library/Application Support/Godot/
Linux: ~/.local/share/godot/
Editor settings | Windows: %APPDATA%\Godot\
macOS: ~/Library/Application Support/Godot/
Linux: ~/.config/godot/
Cache | Windows: %TEMP%\Godot\
macOS: ~/Library/Caches/Godot/
Linux: ~/.cache/godot/

- Editor data contains export templates and project-specific data.
- Editor settings contains the main editor settings configuration file as
well as various other user-specific customizations (editor layouts, feature
profiles, script templates, etc.).
- Cache contains data generated by the editor, or stored temporarily.
It can safely be removed when Godot is closed.

Godot complies with the XDG Base Directory Specification [https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html]
on Linux/*BSD. You can override the XDG_DATA_HOME, XDG_CONFIG_HOME and
XDG_CACHE_HOME environment variables to change the editor and project data
paths.

Note

If you use Godot packaged as a Flatpak [https://flathub.org/apps/details/org.godotengine.Godot], the
editor data paths will be located in subfolders in
~/.var/app/org.godotengine.Godot/.

### Self-contained mode

If you create a file called ._sc_ or _sc_ in the same directory as the
editor binary (or in MacOS/Contents/ for a macOS editor .app bundle), Godot
will enable self-contained mode.
This mode makes Godot write all editor data, settings, and cache to a directory
named editor_data/ in the same directory as the editor binary.
You can use it to create a portable installation of the editor.

The Steam release of Godot [https://store.steampowered.com/app/404790/] uses
self-contained mode by default.

Note

Self-contained mode is not supported in exported projects yet.
To read and write files relative to the executable path, use
OS.get_executable_path().
Note that writing files in the executable path only works if the executable
is placed in a writable location (i.e. not Program Files or another
directory that is read-only for regular users).
