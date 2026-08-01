# RegEx

Inherits: RefCounted < Object

Class for searching text for patterns using regular expressions.

## Description

A regular expression (or regex) is a compact language that can be used to recognize strings that follow a specific pattern, such as URLs, email addresses, complete sentences, etc. For example, a regex of ab[0-9] would find any string that is ab followed by any number from 0 to 9. For a more in-depth look, you can easily find various tutorials and detailed explanations on the Internet.

To begin, the RegEx object needs to be compiled with the search pattern using compile() before it can be used. Alternatively, the static method create_from_string() can be used to create and compile a RegEx object in a single method call.

```gdscript
var regex = RegEx.new()
regex.compile("\\w-(\\d+)")
# Shorthand to create and compile a regex (used in the examples below):
var regex2 = RegEx.create_from_string("\\w-(\\d+)")
```

The search pattern must be escaped first for GDScript before it is escaped for the expression. For example, compile("\\d+") would be read by RegEx as \d+. Similarly, compile("\"(?:\\\\.|[^\"])*\"") would be read as "(?:\\.|[^"])*". In GDScript, you can also use raw string literals (r-strings). For example, compile(r'"(?:\\.|[^"])*"') would be read the same.

Using search(), you can find the pattern within the given text. If a pattern is found, RegExMatch is returned and you can retrieve details of the results using methods such as RegExMatch.get_string() and RegExMatch.get_start().

```gdscript
var regex = RegEx.create_from_string("\\w-(\\d+)")
var result = regex.search("abc n-0123")
if result:
    print(result.get_string()) # Prints "n-0123"
```

The results of capturing groups () can be retrieved by passing the group number to the various methods in RegExMatch. Group 0 is the default and will always refer to the entire pattern. In the above example, calling result.get_string(1) would give you 0123.

This version of RegEx also supports named capturing groups, and the names can be used to retrieve the results. If two or more groups have the same name, the name would only refer to the first one with a match.

```gdscript
var regex = RegEx.create_from_string("d(?[0-9]+)|x(?[0-9a-f]+)")
var result = regex.search("the number is x2f")
if result:
    print(result.get_string("digit")) # Prints "2f"
```

If you need to process multiple results, search_all() generates a list of all non-overlapping results. This can be combined with a for loop for convenience.

```gdscript
# Prints "01 03 0 3f 42"
for result in regex.search_all("d01, d03, d0c, x3f and x42"):
    print(result.get_string("digit"))
```

Example: Split a string using a RegEx:

```gdscript
var regex = RegEx.create_from_string("\\S+") # Negated whitespace character class.
var results = []
for result in regex.search_all("One  Two \n\tThree"):
    results.push_back(result.get_string())
print(results) # Prints ["One", "Two", "Three"]
```

Note: Godot's regex implementation is based on the PCRE2 [https://www.pcre.org/] library. You can view the full pattern reference here [https://www.pcre.org/current/doc/html/pcre2pattern.html].

Tip: You can use Regexr [https://regexr.com/] to test regular expressions online.

## Methods

void | clear()
Error | compile(pattern: String, show_error: bool = true)
RegEx | create_from_string(pattern: String, show_error: bool = true) static
int | get_group_count() const
PackedStringArray | get_names() const
String | get_pattern() const
bool | is_valid() const
RegExMatch | search(subject: String, offset: int = 0, end: int = -1) const
Array[RegExMatch] | search_all(subject: String, offset: int = 0, end: int = -1) const
String | sub(subject: String, replacement: String, all: bool = false, offset: int = 0, end: int = -1) const

---

## Method Descriptions

void clear() 

This method resets the state of the object, as if it was freshly created. Namely, it unassigns the regular expression of this object.

---

Error compile(pattern: String, show_error: bool = true) 

Compiles and assign the search pattern to use. Returns @GlobalScope.OK if the compilation is successful. If compilation fails, returns @GlobalScope.FAILED and when show_error is true, details are printed to standard output.

---

RegEx create_from_string(pattern: String, show_error: bool = true) static 

Creates and compiles a new RegEx object. See also compile().

---

int get_group_count() const 

Returns the number of capturing groups in compiled pattern.

---

PackedStringArray get_names() const 

Returns an array of names of named capturing groups in the compiled pattern. They are ordered by appearance.

---

String get_pattern() const 

Returns the original search pattern that was compiled.

---

bool is_valid() const 

Returns whether this object has a valid search pattern assigned.

---

RegExMatch search(subject: String, offset: int = 0, end: int = -1) const 

Searches the text for the compiled pattern. Returns a RegExMatch container of the first matching result if found, otherwise null.

The region to search within can be specified with offset and end. This is useful when searching for another match in the same subject by calling this method again after a previous success. Note that setting these parameters differs from passing over a shortened string. For example, the start anchor ^ is not affected by offset, and the character before offset will be checked for the word boundary \b.

---

Array[RegExMatch] search_all(subject: String, offset: int = 0, end: int = -1) const 

Searches the text for the compiled pattern. Returns an array of RegExMatch containers for each non-overlapping result. If no results were found, an empty array is returned instead.

The region to search within can be specified with offset and end. This is useful when searching for another match in the same subject by calling this method again after a previous success. Note that setting these parameters differs from passing over a shortened string. For example, the start anchor ^ is not affected by offset, and the character before offset will be checked for the word boundary \b.

---

String sub(subject: String, replacement: String, all: bool = false, offset: int = 0, end: int = -1) const 

Searches the text for the compiled pattern and replaces it with the specified string. Escapes and backreferences such as $1 and $name are expanded and resolved. By default, only the first instance is replaced, but it can be changed for all instances (global replacement).

The region to search within can be specified with offset and end. This is useful when searching for another match in the same subject by calling this method again after a previous success. Note that setting these parameters differs from passing over a shortened string. For example, the start anchor ^ is not affected by offset, and the character before offset will be checked for the word boundary \b.
