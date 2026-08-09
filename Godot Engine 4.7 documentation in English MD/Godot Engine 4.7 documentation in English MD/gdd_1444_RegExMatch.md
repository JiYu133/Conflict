# RegExMatch

Inherits: RefCounted < Object

Contains the results of a RegEx search.

## Description

Contains the results of a single RegEx match returned by RegEx.search() and RegEx.search_all(). It can be used to find the position and range of the match and its capturing groups, and it can extract its substring for you.

## Properties

Dictionary | names | {}
PackedStringArray | strings | PackedStringArray()
String | subject | ""

## Methods

int | get_end(name: Variant = 0) const
int | get_group_count() const
int | get_start(name: Variant = 0) const
String | get_string(name: Variant = 0) const

---

## Property Descriptions

Dictionary names = {} 

- Dictionary get_names()

A dictionary of named groups and its corresponding group number. Only groups that were matched are included. If multiple groups have the same name, that name would refer to the first matching one.

---

PackedStringArray strings = PackedStringArray() 

- PackedStringArray get_strings()

An Array of the match and its capturing groups.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

String subject = "" 

- String get_subject()

The source string used with the search pattern to find this matching result.

---

## Method Descriptions

int get_end(name: Variant = 0) const 

Returns the end position of the match within the source string. The end position of capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.

Returns -1 if the group did not match or doesn't exist.

---

int get_group_count() const 

Returns the number of capturing groups.

---

int get_start(name: Variant = 0) const 

Returns the starting position of the match within the source string. The starting position of capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.

Returns -1 if the group did not match or doesn't exist.

---

String get_string(name: Variant = 0) const 

Returns the substring of the match from the source string. Capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.

Returns an empty string if the group did not match or doesn't exist.
