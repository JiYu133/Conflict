# EditorTranslationParserPlugin

Inherits: RefCounted < Object

Plugin for adding custom parsers to extract strings that are to be translated from custom files (.csv, .json etc.).

## Description

EditorTranslationParserPlugin is invoked when a file is being parsed to extract strings that require translation. To define the parsing and string extraction logic, override the _parse_file() method in script.

The return value should be an Array of PackedStringArrays, one for each extracted translatable string. Each entry should contain [msgid, msgctxt, msgid_plural, comment, source_line], where all except msgid are optional. Empty strings will be ignored.

The extracted strings will be written into a translation template file selected by user under "Template Generation" in "Localization" tab in "Project Settings" menu.

Below shows an example of a custom parser that extracts strings from a CSV file to write into a template.

```
@tool
extends EditorTranslationParserPlugin
func _parse_file(path):
    var ret: Array[PackedStringArray] = []
    var file = FileAccess.open(path, FileAccess.READ)
    var text = file.get_as_text()
    var split_strs = text.split(",", false)
    for s in split_strs:
        ret.append(PackedStringArray([s]))
        #print("Extracted string: " + s)
    return ret
func _get_recognized_extensions():
    return ["csv"]
```

```
using Godot;
[Tool]
public partial class CustomParser : EditorTranslationParserPlugin
{
    public override Godot.Collections.Array _ParseFile(string path)
    {
        Godot.Collections.Array ret;
        using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
        string text = file.GetAsText();
        string[] splitStrs = text.Split(",", allowEmpty: false);
        foreach (string s in splitStrs)
        {
            ret.Add([s]);
            //GD.Print($"Extracted string: {s}");
        }
        return ret;
    }
    public override string[] _GetRecognizedExtensions()
    {
        return ["csv"];
    }
}
```

To add a translatable string associated with a context, plural, comment, or source line:

```
# This will add a message with msgid "Test 1", msgctxt "context", msgid_plural "test 1 plurals", comment "test 1 comment", and source line "7".
ret.append(PackedStringArray(["Test 1", "context", "test 1 plurals", "test 1 comment", "7"]))
# This will add a message with msgid "A test without context" and msgid_plural "plurals".
ret.append(PackedStringArray(["A test without context", "", "plurals"]))
# This will add a message with msgid "Only with context" and msgctxt "a friendly context".
ret.append(PackedStringArray(["Only with context", "a friendly context"]))
```

```
// This will add a message with msgid "Test 1", msgctxt "context", msgid_plural "test 1 plurals", comment "test 1 comment", and source line "7".
ret.Add(["Test 1", "context", "test 1 plurals", "test 1 comment", "7"]);
// This will add a message with msgid "A test without context" and msgid_plural "plurals".
ret.Add(["A test without context", "", "plurals"]);
// This will add a message with msgid "Only with context" and msgctxt "a friendly context".
ret.Add(["Only with context", "a friendly context"]);
```

Note: If you override parsing logic for standard script types (GDScript, C#, etc.), it would be better to load the path argument using ResourceLoader.load(). This is because built-in scripts are loaded as Resource type, not FileAccess type. For example:

```
func _parse_file(path):
    var res = ResourceLoader.load(path, "Script")
    var text = res.source_code
    # Parsing logic.
func _get_recognized_extensions():
    return ["gd"]
```

```
public override Godot.Collections.Array _ParseFile(string path)
{
    var res = ResourceLoader.Load(path, "Script");
    string text = res.SourceCode;
    // Parsing logic.
}
public override string[] _GetRecognizedExtensions()
{
    return ["gd"];
}
```

Alternatively, the plugin can directly modify the final list of strings, by implementing _customize_strings().

To use EditorTranslationParserPlugin, register it using the EditorPlugin.add_translation_parser_plugin() method first.

## Methods

Array[PackedStringArray] | _customize_strings(strings: Array[PackedStringArray]) virtual const
PackedStringArray | _get_recognized_extensions() virtual const
Array[PackedStringArray] | _parse_file(path: String) virtual

---

## Method Descriptions

Array[PackedStringArray] _customize_strings(strings: Array[PackedStringArray]) virtual const 

Called after parsing all files. You can modify the strings array to add or remove entries from the final list of strings, then return it after modifications. Each entry is a PackedStringArray like explained in the EditorTranslationParserPlugin's description.

```gdscript
@tool
extends EditorTranslationParserPlugin
func _customize_strings(strings):
    # Add new string.
    strings.append(["Test 1", "context", "test 1 plurals", "test 1 comment"])
    # Remove all strings that begin with $.
    strings = strings.filter(func(s): return not s[0].begins_with("$"))
    return strings
```

---

PackedStringArray _get_recognized_extensions() virtual const 

Gets the list of file extensions to associate with this parser, e.g. ["csv"].

---

Array[PackedStringArray] _parse_file(path: String) virtual 

Override this method to define a custom parsing logic to extract the translatable strings.
