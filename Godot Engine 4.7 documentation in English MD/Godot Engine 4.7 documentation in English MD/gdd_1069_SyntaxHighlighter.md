# SyntaxHighlighter

Inherits: Resource < RefCounted < Object

Inherited By: CodeHighlighter, EditorSyntaxHighlighter

Base class for syntax highlighters. Provides syntax highlighting data to a TextEdit.

## Description

Base class for syntax highlighters. Provides syntax highlighting data to a TextEdit. The associated TextEdit will call into the SyntaxHighlighter on an as-needed basis.

Note: A SyntaxHighlighter instance should not be used across multiple TextEdit nodes.

## Methods

void | _clear_highlighting_cache() virtual
Dictionary | _get_line_syntax_highlighting(line: int) virtual const
void | _update_cache() virtual
void | clear_highlighting_cache()
Dictionary | get_line_syntax_highlighting(line: int)
TextEdit | get_text_edit() const
void | update_cache()

---

## Method Descriptions

void _clear_highlighting_cache() virtual 

Virtual method which can be overridden to clear any local caches.

---

Dictionary _get_line_syntax_highlighting(line: int) virtual const 

Virtual method which can be overridden to return syntax highlighting data.

See get_line_syntax_highlighting() for more details.

---

void _update_cache() virtual 

Virtual method which can be overridden to update any local caches.

---

void clear_highlighting_cache() 

Clears all cached syntax highlighting data.

Then calls overridable method _clear_highlighting_cache().

---

Dictionary get_line_syntax_highlighting(line: int) 

Returns the syntax highlighting data for the line at index line. If the line is not cached, calls _get_line_syntax_highlighting() first to calculate the data.

Each entry is a column number containing a nested Dictionary. The column number denotes the start of a region, the region will end if another region is found, or at the end of the line. The nested Dictionary contains the data for that region. Currently only the key "color" is supported.

Example: Possible return value. This means columns 0 to 4 should be red, and columns 5 to the end of the line should be green:

```gdscript
{
    0: {
        "color": Color(1, 0, 0)
    },
    5: {
        "color": Color(0, 1, 0)
    }
}
```

---

TextEdit get_text_edit() const 

Returns the associated TextEdit node.

---

void update_cache() 

Clears then updates the SyntaxHighlighter caches. Override _update_cache() for a callback.

Note: This is called automatically when the associated TextEdit node, updates its own cache.
