# Compiling for the Web

See also

This page describes how to compile HTML5 editor and export template binaries from source.
If you're looking to export your project to HTML5 instead, read Exporting for the Web.

## Requirements

To compile export templates for the Web, the following is required:

- Emscripten 4.0.0+ [https://emscripten.org].
- Python 3.9+ [https://www.python.org/].
- SCons 4.4+ [https://scons.org/pages/download.html] build system.

See also

To get the Godot source code for compiling, see
Getting the source.

For a general overview of SCons usage for Godot, see
Introduction to the buildsystem.

## Building export templates

Before starting, confirm that emcc is available in your PATH. This is
usually configured by the Emscripten SDK, e.g. when invoking emsdk activate
and source ./emsdk_env.sh/emsdk_env.bat.

Open a terminal and navigate to the root directory of the engine source code.
Then instruct SCons to build the Web platform. Specify target as
either template_release for a release build or template_debug for a debug build:

```
scons platform=web target=template_release
scons platform=web target=template_debug
```

By default, the JavaScriptBridge singleton will be built
into the engine. Official export templates also have the JavaScript singleton
enabled. Since eval() calls can be a security concern, the
javascript_eval option can be used to build without the singleton:

```
scons platform=web target=template_release javascript_eval=no
scons platform=web target=template_debug javascript_eval=no
```

By default, WebWorker threads support is enabled. To disable it and only use a single thread,
the threads option can be used to build the web template without threads support:

```
scons platform=web target=template_release threads=no
scons platform=web target=template_debug threads=no
```

The engine will now be compiled to WebAssembly by Emscripten. Once finished,
the resulting file will be placed in the bin subdirectory. Its name is
godot.web.template_release.wasm32.zip for release or godot.web.template_debug.wasm32.zip
for debug.

Finally, rename the zip archive to web_release.zip for the
release template:

```
mv bin/godot.web.template_release.wasm32.zip bin/web_release.zip
```

And web_debug.zip for the debug template:

```
mv bin/godot.web.template_debug.wasm32.zip bin/web_debug.zip
```

## GDExtension

The default export templates do not include GDExtension support for
performance and compatibility reasons. See the
export page for more info.

You can build the export templates using the option dlink_enabled=yes
to enable GDExtension support:

```
scons platform=web dlink_enabled=yes target=template_release
scons platform=web dlink_enabled=yes target=template_debug
```

Once finished, the resulting file will be placed in the bin subdirectory.
Its name will have _dlink added.

Finally, rename the zip archives to web_dlink_release.zip and
web_dlink_release.zip for the release template:

```
mv bin/godot.web.template_release.wasm32.dlink.zip bin/web_dlink_release.zip
mv bin/godot.web.template_debug.wasm32.dlink.zip bin/web_dlink_debug.zip
```

## Building the editor

It is also possible to build a version of the Godot editor that can run in the
browser. The editor version is not recommended
over the native build. You can build the editor with:

```
scons platform=web target=editor
```

Once finished, the resulting file will be placed in the bin subdirectory.
Its name will be godot.web.editor.wasm32.zip. You can upload the
zip content to your web server and visit it with your browser to use the editor.

Refer to the export page for the web
server requirements.

Tip

The Godot repository includes a
Python script to host a local web server [https://raw.githubusercontent.com/godotengine/godot/master/platform/web/serve.py].
This can be used to test the web editor locally.

After compiling the editor, extract the ZIP archive that was created in the
bin/ folder, then run the following command in the Godot repository
root:

```
# You may need to replace `python` with `python3` on some platforms.
python platform/web/serve.py
```

This will serve the contents of the bin/ folder and open the default web
browser automatically. In the page that opens, access godot.editor.html
and you should be able to test the web editor this way.

Note that for production use cases, this Python-based web server should not
be used. Instead, you should use an established web server such as Apache or
nginx.
