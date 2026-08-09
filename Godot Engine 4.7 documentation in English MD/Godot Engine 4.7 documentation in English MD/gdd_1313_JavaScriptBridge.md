# JavaScriptBridge

Inherits: Object

Singleton that connects the engine with the browser's JavaScript context in Web export.

## Description

The JavaScriptBridge singleton is implemented only in the Web export. It's used to access the browser's JavaScript context. This allows interaction with embedding pages or calling third-party JavaScript APIs.

Note: This singleton can be disabled at build-time to improve security. By default, the JavaScriptBridge singleton is enabled. Official export templates also have the JavaScriptBridge singleton enabled. See Compiling for the Web in the documentation for more information.

## Tutorials

- The JavaScriptBridge singleton

## Methods

JavaScriptObject | create_callback(callable: Callable)
Variant | create_object(object: String, ...) vararg
void | download_buffer(buffer: PackedByteArray, name: String, mime: String = "application/octet-stream")
Variant | eval(code: String, use_global_execution_context: bool = false)
void | force_fs_sync()
JavaScriptObject | get_interface(interface: String)
bool | is_js_buffer(javascript_object: JavaScriptObject)
PackedByteArray | js_buffer_to_packed_byte_array(javascript_buffer: JavaScriptObject)
bool | pwa_needs_update() const
Error | pwa_update()

---

## Signals

pwa_update_available() 

Emitted when an update for this progressive web app has been detected but is waiting to be activated because a previous version is active. See pwa_update() to force the update to take place immediately.

---

## Method Descriptions

JavaScriptObject create_callback(callable: Callable) 

Creates a reference to a Callable that can be used as a callback by JavaScript. The reference must be kept until the callback happens, or it won't be called at all. See JavaScriptObject for usage.

Note: The callback function must take exactly one Array argument, which is going to be the JavaScript arguments object [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments] converted to an array.

---

Variant create_object(object: String, ...) vararg 

Creates a new JavaScript object using the new constructor. The object must a valid property of the JavaScript window. See JavaScriptObject for usage.

---

void download_buffer(buffer: PackedByteArray, name: String, mime: String = "application/octet-stream") 

Prompts the user to download a file containing the specified buffer. The file will have the given name and mime type.

Note: The browser may override the MIME type [https://en.wikipedia.org/wiki/Media_type] provided based on the file name's extension.

Note: Browsers might block the download if download_buffer() is not being called from a user interaction (e.g. button click).

Note: Browsers might ask the user for permission or block the download if multiple download requests are made in a quick succession.

---

Variant eval(code: String, use_global_execution_context: bool = false) 

Execute the string code as JavaScript code within the browser window. This is a call to the actual global JavaScript function eval().

If use_global_execution_context is true, the code will be evaluated in the global execution context. Otherwise, it is evaluated in the execution context of a function within the engine's runtime environment.

---

void force_fs_sync() 

Force synchronization of the persistent file system (when enabled).

Note: This is only useful for modules or extensions that can't use FileAccess to write files.

---

JavaScriptObject get_interface(interface: String) 

Returns an interface to a JavaScript object that can be used by scripts. The interface must be a valid property of the JavaScript window. The callback must accept a single Array argument, which will contain the JavaScript arguments. See JavaScriptObject for usage.

---

bool is_js_buffer(javascript_object: JavaScriptObject) 

Returns true if the given javascript_object is of type ArrayBuffer [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer], DataView [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView], or one of the many typed array objects [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray].

---

PackedByteArray js_buffer_to_packed_byte_array(javascript_buffer: JavaScriptObject) 

Returns a copy of javascript_buffer's contents as a PackedByteArray. See also is_js_buffer().

---

bool pwa_needs_update() const 

Returns true if a new version of the progressive web app is waiting to be activated.

Note: Only relevant when exported as a Progressive Web App.

---

Error pwa_update() 

Performs the live update of the progressive web app. Forcing the new version to be installed and the page to be reloaded.

Note: Your application will be reloaded in all browser tabs.

Note: Only relevant when exported as a Progressive Web App and pwa_needs_update() returns true.
