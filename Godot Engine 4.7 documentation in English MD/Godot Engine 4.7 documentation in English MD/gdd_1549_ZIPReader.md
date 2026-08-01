# ZIPReader

Inherits: RefCounted < Object

Allows reading the content of a ZIP file.

## Description

This class implements a reader that can extract the content of individual files inside a ZIP archive. See also ZIPPacker.

```gdscript
# Read a single file from a ZIP archive.
func read_zip_file():
    var reader = ZIPReader.new()
    var err = reader.open("user://archive.zip")
    if err != OK:
        return PackedByteArray()
    var res = reader.read_file("hello.txt")
    reader.close()
    return res
# Extract all files from a ZIP archive, preserving the directories within.
# This acts like the "Extract all" functionality from most archive managers.
func extract_all_from_zip():
    var reader = ZIPReader.new()
    reader.open("res://archive.zip")
    # Destination directory for the extracted files (this folder must exist before extraction).
    # Not all ZIP archives put everything in a single root folder,
    # which means several files/folders may be created in `root_dir` after extraction.
    var root_dir = DirAccess.open("user://")
    var files = reader.get_files()
    for file_path in files:
        # If the current entry is a directory.
        if file_path.ends_with("/"):
            root_dir.make_dir_recursive(file_path)
            continue
        # Write file contents, creating folders automatically when needed.
        # Not all ZIP archives are strictly ordered, so we need to do this in case
        # the file entry comes before the folder entry.
        root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
        var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
        var buffer = reader.read_file(file_path)
        file.store_buffer(buffer)
```

## Methods

Error | close()
bool | file_exists(path: String, case_sensitive: bool = true)
int | get_compression_level(path: String, case_sensitive: bool = true)
PackedStringArray | get_files()
Error | open(path: String)
PackedByteArray | read_file(path: String, case_sensitive: bool = true)

---

## Method Descriptions

Error close() 

Closes the underlying resources used by this instance.

---

bool file_exists(path: String, case_sensitive: bool = true) 

Returns true if the file exists in the loaded zip archive.

Must be called after open().

---

int get_compression_level(path: String, case_sensitive: bool = true) 

Returns the compression level of the file in the loaded zip archive. Returns -1 if the file doesn't exist or any other error occurs. Must be called after open().

---

PackedStringArray get_files() 

Returns the list of names of all files in the loaded archive.

Must be called after open().

---

Error open(path: String) 

Opens the zip archive at the given path and reads its file index.

---

PackedByteArray read_file(path: String, case_sensitive: bool = true) 

Loads the whole content of a file in the loaded zip archive into memory and returns it.

Must be called after open().
