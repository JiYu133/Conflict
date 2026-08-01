# ResourceLoader

Inherits: Object

A singleton for loading resource files.

## Description

A singleton used to load resource files from the filesystem.

It uses the many ResourceFormatLoader classes registered in the engine (either built-in or from a plugin) to load files into memory and convert them to a format that can be used by the engine.

Note: You have to import the files into the engine first to load them using load(). If you want to load Images at run-time, you may use Image.load(). If you want to import audio files, you can use the snippet described in AudioStreamMP3.data.

Note: Non-resource files such as plain text files cannot be read using ResourceLoader. Use FileAccess for those files instead, and be aware that non-resource files are not exported by default (see notes in the FileAccess class description for instructions on exporting them).

## Tutorials

- Threaded Loading Demo [https://godotengine.org/asset-library/asset/2778]
- Operating System Testing Demo [https://godotengine.org/asset-library/asset/2789]

## Methods

void | add_resource_format_loader(format_loader: ResourceFormatLoader, at_front: bool = false)
bool | exists(path: String, type_hint: String = "")
Resource | get_cached_ref(path: String)
PackedStringArray | get_dependencies(path: String)
PackedStringArray | get_recognized_extensions_for_type(type: String)
int | get_resource_uid(path: String)
bool | has_cached(path: String)
PackedStringArray | list_directory(directory_path: String)
Resource | load(path: String, type_hint: String = "", cache_mode: CacheMode = 1)
Resource | load_threaded_get(path: String)
ThreadLoadStatus | load_threaded_get_status(path: String, progress: Array = [])
Error | load_threaded_request(path: String, type_hint: String = "", use_sub_threads: bool = false, cache_mode: CacheMode = 1)
void | remove_resource_format_loader(format_loader: ResourceFormatLoader)
void | set_abort_on_missing_resources(abort: bool)

---

## Enumerations

enum ThreadLoadStatus
ThreadLoadStatus THREAD_LOAD_INVALID_RESOURCE = 0

The resource is invalid, or has not been loaded with load_threaded_request().

ThreadLoadStatus THREAD_LOAD_IN_PROGRESS = 1

The resource is still being loaded.

ThreadLoadStatus THREAD_LOAD_FAILED = 2

Some error occurred during loading and it failed.

ThreadLoadStatus THREAD_LOAD_LOADED = 3

The resource was loaded successfully and can be accessed via load_threaded_get().

---

enum CacheMode
CacheMode CACHE_MODE_IGNORE = 0

Neither the main resource (the one requested to be loaded) nor any of its subresources are retrieved from cache nor stored into it. Dependencies (external resources) are loaded with CACHE_MODE_REUSE.

CacheMode CACHE_MODE_REUSE = 1

The main resource (the one requested to be loaded), its subresources, and its dependencies (external resources) are retrieved from cache if present, instead of loaded. Those not cached are loaded and then stored into the cache. The same rules are propagated recursively down the tree of dependencies (external resources).

CacheMode CACHE_MODE_REPLACE = 2

Like CACHE_MODE_REUSE, but the cache is checked for the main resource (the one requested to be loaded) as well as for each of its subresources. Those already in the cache, as long as the loaded and cached types match, have their data refreshed from storage into the already existing instances. Otherwise, they are recreated as completely new objects.

CacheMode CACHE_MODE_IGNORE_DEEP = 3

Like CACHE_MODE_IGNORE, but propagated recursively down the tree of dependencies (external resources).

CacheMode CACHE_MODE_REPLACE_DEEP = 4

Like CACHE_MODE_REPLACE, but propagated recursively down the tree of dependencies (external resources).

---

## Method Descriptions

void add_resource_format_loader(format_loader: ResourceFormatLoader, at_front: bool = false) 

Registers a new ResourceFormatLoader. The ResourceLoader will use the ResourceFormatLoader as described in load().

This method is performed implicitly for ResourceFormatLoaders written in GDScript (see ResourceFormatLoader for more information).

---

bool exists(path: String, type_hint: String = "") 

Returns whether a recognized resource exists for the given path.

An optional type_hint can be used to further specify the Resource type that should be handled by the ResourceFormatLoader. Anything that inherits from Resource can be used as a type hint, for example Image.

Note: If you use Resource.take_over_path(), this method will return true for the taken path even if the resource wasn't saved (i.e. exists only in resource cache).

---

Resource get_cached_ref(path: String) 

Returns the cached resource reference for the given path.

Note: If the resource is not cached, the returned Resource will be invalid.

---

PackedStringArray get_dependencies(path: String) 

Returns the dependencies for the resource at the given path.

Each dependency is a string that can be divided into sections by ::. There can be either one section or three sections, with the second section always being empty. When there is one section, it contains the file path. When there are three sections, the first section contains the UID and the third section contains the fallback path.

```gdscript
for dependency in ResourceLoader.get_dependencies(path):
    if dependency.contains("::"):
        print(dependency.get_slice("::", 0)) # Prints the UID.
        print(dependency.get_slice("::", 2)) # Prints the fallback path.
    else:
        print(dependency) # Prints the path.
```

---

PackedStringArray get_recognized_extensions_for_type(type: String) 

Returns the list of recognized extensions for a resource type.

---

int get_resource_uid(path: String) 

Returns the ID associated with a given resource path, or -1 when no such ID exists.

---

bool has_cached(path: String) 

Returns whether a cached resource is available for the given path.

Once a resource has been loaded by the engine, it is cached in memory for faster access, and future calls to the load() method will use the cached version. The cached resource can be overridden by using Resource.take_over_path() on a new resource for that same path.

---

PackedStringArray list_directory(directory_path: String) 

Lists a directory, returning all resources and subdirectories contained within. The resource files have the original file names as visible in the editor before exporting. The directories have "/" appended.

```gdscript
# Prints ["extra_data/", "model.gltf", "model.tscn", "model_slime.png"]
print(ResourceLoader.list_directory("res://assets/enemies/slime"))
```

Note: The order of files and directories returned by this method is not deterministic, and can vary between operating systems.

Note: To normally traverse the filesystem, see DirAccess.

---

Resource load(path: String, type_hint: String = "", cache_mode: CacheMode = 1) 

Loads a resource at the given path, caching the result for further access.

The registered ResourceFormatLoaders are queried sequentially to find the first one which can handle the file's extension, and then attempt loading. If loading fails, the remaining ResourceFormatLoaders are also attempted.

An optional type_hint can be used to further specify the Resource type that should be handled by the ResourceFormatLoader. Anything that inherits from Resource can be used as a type hint, for example Image.

The cache_mode property defines whether and how the cache should be used or updated when loading the resource.

Returns an empty resource if no ResourceFormatLoader could handle the file, and prints an error if no file is found at the specified path.

GDScript has a simplified @GDScript.load() built-in method which can be used in most situations, leaving the use of ResourceLoader for more advanced scenarios.

Note: If ProjectSettings.editor/export/convert_text_resources_to_binary is true, @GDScript.load() will not be able to read converted files in an exported project. If you rely on run-time loading of files present within the PCK, set ProjectSettings.editor/export/convert_text_resources_to_binary to false.

Note: Relative paths will be prefixed with "res://" before loading, to avoid unexpected results make sure your paths are absolute.

---

Resource load_threaded_get(path: String) 

Returns the resource loaded by load_threaded_request().

If this is called before the loading thread is done (i.e. load_threaded_get_status() is not THREAD_LOAD_LOADED), the calling thread will be blocked until the resource has finished loading. However, it's recommended to use load_threaded_get_status() to known when the load has actually completed.

---

ThreadLoadStatus load_threaded_get_status(path: String, progress: Array = []) 

Returns the status of a threaded loading operation started with load_threaded_request() for the resource at path.

An array variable can optionally be passed via progress, and will return a one-element array containing the ratio of completion of the threaded loading (between 0.0 and 1.0).

Note: The recommended way of using this method is to call it during different frames (e.g., in Node._process(), instead of a loop).

---

Error load_threaded_request(path: String, type_hint: String = "", use_sub_threads: bool = false, cache_mode: CacheMode = 1) 

Loads the resource using threads. If use_sub_threads is true, multiple threads will be used to load the resource, which makes loading faster, but may affect the main thread (and thus cause game slowdowns).

The cache_mode parameter defines whether and how the cache should be used or updated when loading the resource.

---

void remove_resource_format_loader(format_loader: ResourceFormatLoader) 

Unregisters the given ResourceFormatLoader.

---

void set_abort_on_missing_resources(abort: bool) 

Changes the behavior on missing sub-resources. The default behavior is to abort loading.
