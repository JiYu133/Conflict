# GDScriptTextDocument

Deprecated: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Document related language server functionality.

## Description

Provides language server functionality related to documents.

## Methods

Array | codeLens(params: Dictionary)
Array | colorPresentation(params: Dictionary)
Array | completion(params: Dictionary)
Variant | declaration(params: Dictionary)
Array | definition(params: Dictionary)
void | didChange(params: Variant)
void | didClose(params: Variant)
void | didOpen(params: Variant)
void | didSave(params: Variant)
Array | documentLink(params: Dictionary)
Array | documentSymbol(params: Dictionary)
Array | foldingRange(params: Dictionary)
Variant | hover(params: Dictionary)
Variant | nativeSymbol(params: Dictionary)
Variant | prepareRename(params: Dictionary)
Array | references(params: Dictionary)
Dictionary | rename(params: Dictionary)
Dictionary | resolve(params: Dictionary)
void | show_native_symbol_in_editor(symbol_id: String)
Variant | signatureHelp(params: Dictionary)
void | willSaveWaitUntil(params: Variant)

---

## Method Descriptions

Array codeLens(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array colorPresentation(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array completion(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Variant declaration(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array definition(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void didChange(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void didClose(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void didOpen(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void didSave(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array documentLink(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array documentSymbol(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array foldingRange(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Variant hover(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Variant nativeSymbol(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Variant prepareRename(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Array references(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Dictionary rename(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

Dictionary resolve(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void show_native_symbol_in_editor(symbol_id: String) 

Deprecated: Use ScriptEditor.goto_help() instead.

---

Variant signatureHelp(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void willSaveWaitUntil(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.
