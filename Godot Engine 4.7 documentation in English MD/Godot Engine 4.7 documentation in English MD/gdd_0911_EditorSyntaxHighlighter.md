# EditorSyntaxHighlighter

Inherits: SyntaxHighlighter < Resource < RefCounted < Object

Inherited By: GDScriptSyntaxHighlighter

Base class for SyntaxHighlighter used by the ScriptEditor.

## Description

Base class that all SyntaxHighlighters used by the ScriptEditor extend from.

Add a syntax highlighter to an individual script by calling ScriptEditorBase.add_syntax_highlighter(). To apply to all scripts on open, call ScriptEditor.register_syntax_highlighter().

## Methods

EditorSyntaxHighlighter | _create() virtual const
String | _get_name() virtual const
PackedStringArray | _get_supported_languages() virtual const

---

## Method Descriptions

EditorSyntaxHighlighter _create() virtual const 

Virtual method which creates a new instance of the syntax highlighter.

---

String _get_name() virtual const 

Virtual method which can be overridden to return the syntax highlighter name.

---

PackedStringArray _get_supported_languages() virtual const 

Virtual method which can be overridden to return the supported language names.
