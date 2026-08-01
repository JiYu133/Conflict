# DirAccess

Inherits: RefCounted < Object

Provides methods for managing directories and their content.

## Description

This class is used to manage directories and their content, even outside of the project folder.

DirAccess can't be instantiated directly. Instead it is created with a static method that takes a path for which it will be opened.

Most of the methods have a static alternative that can be used without creating a DirAccess. Static methods only support absolute paths (including res:// and user://).

```gdscript
# Standard
var dir = DirAccess.open("user://levels")
dir.make_dir("world1")
# Static
DirAccess.make_dir_absolute("user://levels/world1")
```

Note: Accessing project ("res://") directories once exported may behave unexpectedly as some files are converted to engine-specific formats and their original source files may not be present in the expected PCK package. Because of this, to access resources in an exported project, it is recommended to use ResourceLoader instead of FileAccess.

Here is an example on how to iterate through the files of a directory:

```
func dir_contents(path):
    var dir = DirAccess.open(path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                print("Found directory: " + file_name)
            else:
                print("Found file: " + file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")
```

```
public void DirContents(string path)
{
    using var dir = DirAccess.Open(path);
    if (dir != null)
    {
        dir.ListDirBegin();
        string fileName = dir.GetNext();
        while (fileName != "")
        {
            if (dir.CurrentIsDir())
            {
                GD.Print($"Found directory: {fileName}");
            }
            else
            {
                GD.Print($"Found file: {fileName}");
            }
            fileName = dir.GetNext();
        }
    }
    else
    {
        GD.Print("An error occurred when trying to access the path.");
    }
}
```

Keep in mind that file names may change or be remapped after export. If you want to see the actual resource file list as it appears in the editor, use ResourceLoader.list_directory() instead.

## Tutorials

- File system

## Properties

bool | include_hidden
bool | include_navigational

## Methods

Error | change_dir(to_dir: String)
Error | copy(from: String, to: String, chmod_flags: int = -1)
Error | copy_absolute(from: String, to: String, chmod_flags: int = -1) static
Error | create_link(source: String, target: String)
DirAccess | create_temp(prefix: String = "", keep: bool = false) static
bool | current_is_dir() const
bool | dir_exists(path: String)
bool | dir_exists_absolute(path: String) static
bool | file_exists(path: String)
String | get_current_dir(include_drive: bool = true) const
int | get_current_drive()
PackedStringArray | get_directories()
PackedStringArray | get_directories_at(path: String) static
int | get_drive_count() static
String | get_drive_label(idx: int) static
String | get_drive_name(idx: int) static
PackedStringArray | get_files()
PackedStringArray | get_files_at(path: String) static
String | get_filesystem_type() const
String | get_next()
Error | get_open_error() static
int | get_space_left()
bool | is_bundle(path: String) const
bool | is_case_sensitive(path: String) const
bool | is_equivalent(path_a: String, path_b: String) const
bool | is_link(path: String)
Error | list_dir_begin()
void | list_dir_end()
Error | make_dir(path: String)
Error | make_dir_absolute(path: String) static
Error | make_dir_recursive(path: String)
Error | make_dir_recursive_absolute(path: String) static
DirAccess | open(path: String) static
String | read_link(path: String)
Error | remove(path: String)
Error | remove_absolute(path: String) static
Error | rename(from: String, to: String)
Error | rename_absolute(from: String, to: String) static

---

## Property Descriptions

bool include_hidden 

- void set_include_hidden(value: bool)
- bool get_include_hidden()

If true, hidden files are included when navigating the directory.

Affects list_dir_begin(), get_directories() and get_files().

---

bool include_navigational 

- void set_include_navigational(value: bool)
- bool get_include_navigational()

If true, . and .. are included when navigating the directory.

Affects list_dir_begin() and get_directories().

---

## Method Descriptions

Error change_dir(to_dir: String) 

Changes the currently opened directory to the one passed as an argument. The argument can be relative to the current directory (e.g. newdir or ../newdir), or an absolute path (e.g. /tmp/newdir or res://somedir/newdir).

Returns one of the Error code constants (@GlobalScope.OK on success).

Note: The new directory must be within the same scope, e.g. when you had opened a directory inside res://, you can't change it to user:// directory. If you need to open a directory in another access scope, use open() to create a new instance instead.

---

Error copy(from: String, to: String, chmod_flags: int = -1) 

Copies the from file to the to destination. Both arguments should be paths to files, either relative or absolute. If the destination file exists and is not access-protected, it will be overwritten.

If chmod_flags is different than -1, the Unix permissions for the destination path will be set to the provided value, if available on the current operating system.

Returns one of the Error code constants (@GlobalScope.OK on success).

---

Error copy_absolute(from: String, to: String, chmod_flags: int = -1) static 

Static version of copy(). Supports only absolute paths.

---

Error create_link(source: String, target: String) 

Creates symbolic link between files or folders.

Note: On Windows, this method works only if the application is running with elevated privileges or Developer Mode is enabled.

Note: This method is implemented on macOS, Linux, and Windows.

---

DirAccess create_temp(prefix: String = "", keep: bool = false) static 

Creates a temporary directory. This directory will be freed when the returned DirAccess is freed.

If prefix is not empty, it will be prefixed to the directory name, separated by a -.

If keep is true, the directory is not deleted when the returned DirAccess is freed.

Returns null if opening the directory failed. You can use get_open_error() to check the error that occurred.

---

bool current_is_dir() const 

Returns whether the current item processed with the last get_next() call is a directory (. and .. are considered directories).

---

bool dir_exists(path: String) 

Returns whether the target directory exists. The argument can be relative to the current directory, or an absolute path.

Note: The returned bool in the editor and after exporting when used on a path in the res:// directory may be different. Some files are converted to engine-specific formats when exported, potentially changing the directory structure.

---

bool dir_exists_absolute(path: String) static 

Static version of dir_exists(). Supports only absolute paths.

Note: The returned bool in the editor and after exporting when used on a path in the res:// directory may be different. Some files are converted to engine-specific formats when exported, potentially changing the directory structure.

---

bool file_exists(path: String) 

Returns whether the target file exists. The argument can be relative to the current directory, or an absolute path.

For a static equivalent, use FileAccess.file_exists().

Note: Many resources types are imported (e.g. textures or sound files), and their source asset will not be included in the exported game, as only the imported version is used. See ResourceLoader.exists() for an alternative approach that takes resource remapping into account.

---

String get_current_dir(include_drive: bool = true) const 

Returns the absolute path to the currently opened directory (e.g. res://folder or C:\tmp\folder).

---

int get_current_drive() 

Returns the currently opened directory's drive index. See get_drive_name() to convert returned index to the name of the drive.

---

PackedStringArray get_directories() 

Returns a PackedStringArray containing filenames of the directory contents, excluding files. The array is sorted alphabetically.

Affected by include_hidden and include_navigational.

Note: The returned directories in the editor and after exporting in the res:// directory may differ as some files are converted to engine-specific formats when exported.

---

PackedStringArray get_directories_at(path: String) static 

Returns a PackedStringArray containing filenames of the directory contents, excluding files, at the given path. The array is sorted alphabetically.

Use get_directories() if you want more control of what gets included.

Note: The returned directories in the editor and after exporting in the res:// directory may differ as some files are converted to engine-specific formats when exported.

---

int get_drive_count() static 

On Windows, returns the number of drives (partitions) mounted on the current filesystem.

On macOS and Android, returns the number of mounted volumes.

On Linux, returns the number of mounted volumes and GTK 3 bookmarks.

On other platforms, the method returns 0.

---

String get_drive_label(idx: int) static 

On Windows, returns the label of the drive (partition) passed as an argument.

On other platforms, or if the requested drive does not exist, returns an empty String.

---

String get_drive_name(idx: int) static 

On Windows, returns the name of the drive (partition) passed as an argument (e.g. C:).

On macOS, returns the path to the mounted volume passed as an argument.

On Linux, returns the path to the mounted volume or GTK 3 bookmark passed as an argument.

On Android (API level 30+), returns the path to the mounted volume as an argument.

On other platforms, or if the requested drive does not exist, returns an empty String.

---

PackedStringArray get_files() 

Returns a PackedStringArray containing filenames of the directory contents, excluding directories. The array is sorted alphabetically.

Affected by include_hidden.

Note: When used on a res:// path in an exported project, only the files actually included in the PCK at the given folder level are returned. In practice, this means that since imported resources are stored in a top-level .godot/ folder, only paths to *.gd and *.import files are returned (plus a few files such as project.godot or project.binary and the project icon). In an exported project, the list of returned files will also vary depending on whether ProjectSettings.editor/export/convert_text_resources_to_binary is true.

---

PackedStringArray get_files_at(path: String) static 

Returns a PackedStringArray containing filenames of the directory contents, excluding directories, at the given path. The array is sorted alphabetically.

Use get_files() if you want more control of what gets included.

Note: When used on a res:// path in an exported project, only the files included in the PCK at the given folder level are returned. In practice, this means that since imported resources are stored in a top-level .godot/ folder, only paths to .gd and .import files are returned (plus a few other files, such as project.godot or project.binary and the project icon). In an exported project, the list of returned files will also vary depending on ProjectSettings.editor/export/convert_text_resources_to_binary.

---

String get_filesystem_type() const 

Returns file system type name of the current directory's disk. Returned values are uppercase strings like NTFS, FAT32, EXFAT, APFS, EXT4, BTRFS, and so on.

Note: This method is implemented on macOS, Linux, Windows and for PCK virtual file system.

---

String get_next() 

Returns the next element (file or directory) in the current directory.

The name of the file or directory is returned (and not its full path). Once the stream has been fully processed, the method returns an empty String and closes the stream automatically (i.e. list_dir_end() would not be mandatory in such a case).

---

Error get_open_error() static 

Returns the result of the last open() call in the current thread.

---

int get_space_left() 

Returns the available space on the current directory's disk, in bytes. Returns 0 if the platform-specific method to query the available space fails.

---

bool is_bundle(path: String) const 

Returns true if the directory is a macOS bundle.

Note: This method is implemented on macOS.

---

bool is_case_sensitive(path: String) const 

Returns true if the file system or directory use case sensitive file names.

Note: This method is implemented on macOS, Linux (for EXT4 and F2FS filesystems only) and Windows. On other platforms, it always returns true.

---

bool is_equivalent(path_a: String, path_b: String) const 

Returns true if paths path_a and path_b resolve to the same file system object. Returns false otherwise, even if the files are bit-for-bit identical (e.g., identical copies of the file that are not symbolic links).

---

bool is_link(path: String) 

Returns true if the file or directory is a symbolic link, directory junction, or other reparse point.

Note: This method is implemented on macOS, Linux, and Windows.

---

Error list_dir_begin() 

Initializes the stream used to list all files and directories using the get_next() function, closing the currently opened stream if needed. Once the stream has been processed, it should typically be closed with list_dir_end().

Affected by include_hidden and include_navigational.

Note: The order of files and directories returned by this method is not deterministic, and can vary between operating systems. If you want a list of all files or folders sorted alphabetically, use get_files() or get_directories().

---

void list_dir_end() 

Closes the current stream opened with list_dir_begin() (whether it has been fully processed with get_next() does not matter).

---

Error make_dir(path: String) 

Creates a directory. The argument can be relative to the current directory, or an absolute path. The target directory should be placed in an already existing directory (to create the full path recursively, see make_dir_recursive()).

Returns one of the Error code constants (@GlobalScope.OK on success).

---

Error make_dir_absolute(path: String) static 

Static version of make_dir(). Supports only absolute paths.

---

Error make_dir_recursive(path: String) 

Creates a target directory and all necessary intermediate directories in its path, by calling make_dir() recursively. The argument can be relative to the current directory, or an absolute path.

Returns one of the Error code constants (@GlobalScope.OK on success).

---

Error make_dir_recursive_absolute(path: String) static 

Static version of make_dir_recursive(). Supports only absolute paths.

---

DirAccess open(path: String) static 

Creates a new DirAccess object and opens an existing directory of the filesystem. The path argument can be within the project tree (res://folder), the user directory (user://folder) or an absolute path of the user filesystem (e.g. /tmp/folder or C:\tmp\folder).

Returns null if opening the directory failed. You can use get_open_error() to check the error that occurred.

---

String read_link(path: String) 

Returns target of the symbolic link.

Note: This method is implemented on macOS, Linux, and Windows.

---

Error remove(path: String) 

Permanently deletes the target file or an empty directory. The argument can be relative to the current directory, or an absolute path. If the target directory is not empty, the operation will fail.

If you don't want to delete the file/directory permanently, use OS.move_to_trash() instead.

Returns one of the Error code constants (@GlobalScope.OK on success).

---

Error remove_absolute(path: String) static 

Static version of remove(). Supports only absolute paths.

---

Error rename(from: String, to: String) 

Renames (move) the from file or directory to the to destination. Both arguments should be paths to files or directories, either relative or absolute. If the destination file or directory exists and is not access-protected, it will be overwritten.

Returns one of the Error code constants (@GlobalScope.OK on success).

---

Error rename_absolute(from: String, to: String) static 

Static version of rename(). Supports only absolute paths.
