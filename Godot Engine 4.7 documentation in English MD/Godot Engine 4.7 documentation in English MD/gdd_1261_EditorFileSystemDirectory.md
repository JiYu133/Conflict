# EditorFileSystemDirectory

Inherits: Object

A directory for the resource filesystem.

## Description

A more generalized, low-level variation of the directory concept.

## Methods

int | find_dir_index(name: String) const
int | find_file_index(name: String) const
String | get_file(idx: int) const
int | get_file_count() const
bool | get_file_import_is_valid(idx: int) const
String | get_file_path(idx: int) const
String | get_file_script_class_extends(idx: int) const
String | get_file_script_class_name(idx: int) const
StringName | get_file_type(idx: int) const
String | get_name()
EditorFileSystemDirectory | get_parent()
String | get_path() const
EditorFileSystemDirectory | get_subdir(idx: int)
int | get_subdir_count() const

---

## Method Descriptions

int find_dir_index(name: String) const 

Returns the index of the directory with name name or -1 if not found.

---

int find_file_index(name: String) const 

Returns the index of the file with name name or -1 if not found.

---

String get_file(idx: int) const 

Returns the name of the file at index idx.

---

int get_file_count() const 

Returns the number of files in this directory.

---

bool get_file_import_is_valid(idx: int) const 

Returns true if the file at index idx imported properly.

---

String get_file_path(idx: int) const 

Returns the path to the file at index idx.

---

String get_file_script_class_extends(idx: int) const 

Returns the base class of the script class defined in the file at index idx. If the file doesn't define a script class using the class_name syntax, this will return an empty string.

---

String get_file_script_class_name(idx: int) const 

Returns the name of the script class defined in the file at index idx. If the file doesn't define a script class using the class_name syntax, this will return an empty string.

---

StringName get_file_type(idx: int) const 

Returns the resource type of the file at index idx. This returns a string such as "Resource" or "GDScript", not a file extension such as ".gd".

---

String get_name() 

Returns the name of this directory.

---

EditorFileSystemDirectory get_parent() 

Returns the parent directory for this directory or null if called on a directory at res:// or user://.

---

String get_path() const 

Returns the path to this directory.

---

EditorFileSystemDirectory get_subdir(idx: int) 

Returns the subdirectory at index idx.

---

int get_subdir_count() const 

Returns the number of subdirectories in this directory.
