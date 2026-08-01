# EditorFileSystemImportFormatSupportQuery

Inherits: RefCounted < Object

Used to query and configure import format support.

## Description

This class is used to query and configure a certain import format. It is used in conjunction with asset format import plugins.

## Methods

PackedStringArray | _get_file_extensions() virtual required const
bool | _is_active() virtual required const
bool | _query() virtual required const

---

## Method Descriptions

PackedStringArray _get_file_extensions() virtual required const 

Return the file extensions supported.

---

bool _is_active() virtual required const 

Return whether this importer is active.

---

bool _query() virtual required const 

Query support. Return false if import must not continue.
