# EditorFileSystem

Inherits: Node < Object

Resource filesystem, as the editor sees it.

## Description

This object holds information of all resources in the filesystem, their types, etc.

Note: This class shouldn't be instantiated directly. Instead, access the singleton using EditorInterface.get_resource_filesystem().

## Methods

String | get_file_type(path: String) const
EditorFileSystemDirectory | get_filesystem()
EditorFileSystemDirectory | get_filesystem_path(path: String)
float | get_scanning_progress() const
bool | is_importing() const
bool | is_scanning() const
void | reimport_files(files: PackedStringArray)
void | scan()
void | scan_sources()
void | update_file(path: String)

---

## Signals

filesystem_changed() 

Emitted if the filesystem changed.

---

resources_reimported(resources: PackedStringArray) 

Emitted if a resource is reimported.

---

resources_reimporting(resources: PackedStringArray) 

Emitted before a resource is reimported.

---

resources_reload(resources: PackedStringArray) 

Emitted if at least one resource is reloaded when the filesystem is scanned.

---

script_classes_updated() 

Emitted when the list of global script classes gets updated.

---

sources_changed(exist: bool) 

Emitted if the source of any imported file changed.

---

## Method Descriptions

String get_file_type(path: String) const 

Returns the resource type of the file, given the full path. This returns a string such as "Resource" or "GDScript", not a file extension such as ".gd".

---

EditorFileSystemDirectory get_filesystem() 

Gets the root directory object.

---

EditorFileSystemDirectory get_filesystem_path(path: String) 

Returns a view into the filesystem at path.

---

float get_scanning_progress() const 

Returns the scan progress for 0 to 1 if the FS is being scanned.

---

bool is_importing() const 

Returns true if resources are currently being imported.

---

bool is_scanning() const 

Returns true if the filesystem is being scanned.

---

void reimport_files(files: PackedStringArray) 

Reimports a set of files. Call this if these files or their .import files were directly edited by script or an external program.

If the file type changed or the file was newly created, use update_file() or scan().

Note: This function blocks until the import is finished. However, the main loop iteration, including timers and Node._process(), will occur during the import process due to progress bar updates. Avoid calls to reimport_files() or scan() while an import is in progress.

---

void scan() 

Scan the filesystem for changes.

---

void scan_sources() 

Check if the source of any imported resource changed.

---

void update_file(path: String) 

Add a file in an existing directory, or schedule file information to be updated on editor restart. Can be used to update text files saved by an external program.

This will not import the file. To reimport, call reimport_files() or scan() methods.
