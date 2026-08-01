# GDScriptLanguageProtocol

Experimental: This class may be changed or removed in future versions.

Inherits: JSONRPC < Object

GDScript language server.

## Description

Provides access to certain features that are implemented in the language server.

Note: This class is not a language server client that can be used to access LSP functionality. It only provides access to a limited set of features that is implemented using the same technical foundation as the language server.

## Methods

GDScriptTextDocument | get_text_document()
GDScriptWorkspace | get_workspace()
Variant | initialize(params: Dictionary)
void | initialized(params: Variant)
bool | is_initialized() const
bool | is_smart_resolve_enabled() const
void | notify_client(method: String, params: Variant = null, client_id: int = -1)
Error | on_client_connected()
void | on_client_disconnected(client_id: int)

---

## Method Descriptions

GDScriptTextDocument get_text_document() 

Deprecated: GDScriptTextDocument is deprecated.

Returns the language server's GDScriptTextDocument instance.

---

GDScriptWorkspace get_workspace() 

Returns the language server's GDScriptWorkspace instance.

---

Variant initialize(params: Dictionary) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

void initialized(params: Variant) 

Deprecated: Accessing LSP endpoints directly might lead to unwanted side effects. Connect to the server via TCP, like a regular language server client.

---

bool is_initialized() const 

Returns true if the language server was initialized by a language server client, false otherwise.

---

bool is_smart_resolve_enabled() const 

Returns true if the language server is providing the smart resolve feature, false otherwise. The feature can be configured through the editor settings.

---

void notify_client(method: String, params: Variant = null, client_id: int = -1) 

Deprecated: Might result in unwanted side effects for connected clients.

---

Error on_client_connected() 

Deprecated: Might result in unwanted side effects for connected clients.

---

void on_client_disconnected(client_id: int) 

Deprecated: Might result in unwanted side effects for connected clients.
