# GDScriptSyntaxHighlighter

Inherits: EditorSyntaxHighlighter < SyntaxHighlighter < Resource < RefCounted < Object

A GDScript syntax highlighter that can be used with TextEdit and CodeEdit nodes.

## Description

Note: This class can only be used for editor plugins because it relies on editor settings.

```
var code_preview = TextEdit.new()
var highlighter = GDScriptSyntaxHighlighter.new()
code_preview.syntax_highlighter = highlighter
```

```
var codePreview = new TextEdit();
var highlighter = new GDScriptSyntaxHighlighter();
codePreview.SyntaxHighlighter = highlighter;
```
