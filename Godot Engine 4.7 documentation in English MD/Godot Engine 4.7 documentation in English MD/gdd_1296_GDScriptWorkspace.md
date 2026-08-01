# GDScriptWorkspace

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Workspace related language server functionality.

## Description

Provides language server functionality related to the workspace.

## Methods

void | apply_new_signal(obj: Object, function: String, args: PackedStringArray)
void | didDeleteFiles(params: Dictionary)
Dictionary | generate_script_api(path: String)
String | get_file_path(uri: String)
String | get_file_uri(path: String) const
Error | parse_local_script(path: String)
Error | parse_script(path: String, content: String)
void | publish_diagnostics(path: String)

---

## Method Descriptions

void apply_new_signal(obj: Object, function: String, args: PackedStringArray) 

Deprecated: Might result in unwanted side effects for connected clients.

---

void didDeleteFiles(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Dictionary generate_script_api(path: String) 

Returns the interface of the script in a machine-readable format.

---

String get_file_path(uri: String) 

Converts a URI to a file path.

---

String get_file_uri(path: String) const 

Converts a file path to a URI.

---

Error parse_local_script(path: String) 

Deprecated: Might result in unwanted side effects for connected clients.

---

Error parse_script(path: String, content: String) 

Deprecated: Might result in unwanted side effects for connected clients.

---

void publish_diagnostics(path: String) 

Deprecated: Might result in unwanted side effects for connected clients.
