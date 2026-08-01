# Main build system: Working with SCons

See also

This page documents how to compile godot-cpp. If you're looking to compile Godot instead, see
Introduction to the buildsystem.

godot-cpp [https://github.com/godotengine/godot-cpp] uses SCons [https://scons.org] as its main build system.
It is modeled after Godot's build system, and some commands available there are also
available in godot-cpp projects.

## Getting started

To build a godot-cpp project, it is generally sufficient to install SCons [https://scons.org], and simply run it
in the project directory:

> scons

You may want to learn about available options:

> scons --help

To cleanly re-build your project, add --clean to your build command:

> scons --clean

You can find more information about common SCons arguments and build patterns in the
SCons User Guide [https://scons.org/doc/latest/HTML/scons-user/index.html]. Additional commands may be added by
individual godot-cpp projects, so consult their specific documentation for more information on those.

## Configuring an IDE

Most IDEs can use a compile_commands.json file to understand a C++ project. You can generate it with godot-cpp using
the following command:

```
# Generate compile_commands.json while compiling.
scons compiledb=yes
# Generate compile_commands.json without compiling.
scons compiledb=yes compile_commands.json
```

For more information, please check out the IDE configuration guides.
Although written for Godot engine contributors, they are largely applicable to godot-cpp projects as well.

## Loading your GDExtension in Godot

Godot loads GDExtensions by finding .gdextension files in the project directory.
.gdextension files are used to select and load a binary compatible with the current computer / operating system.

The godot-cpp-template [https://github.com/godotengine/godot-cpp-template], as well as the
Getting Started section, provide example .gdextension files for GDExtensions
that are widely compatible to many different systems.

## Building for multiple platforms

GDExtensions are expected to run on many different systems, each with separate binaries and build configurations.
If you are planning to publish your GDExtension, we recommend you provide binaries for all configurations that are
mentioned in the godot-cpp-template [https://github.com/godotengine/godot-cpp-template]
.gdextension file [https://github.com/godotengine/godot-cpp-template/blob/main/demo/bin/example.gdextension].

There are two popular ways by which cross platform builds can be achieved:

- Cross-platform build tools
- Continuous Integration (CI)

godot-cpp-template [https://github.com/godotengine/godot-cpp-template] contains an
example setup [https://github.com/godotengine/godot-cpp-template/tree/main/.github/workflows]
for a GitHub based CI workflow.

## Using a custom API file

Every branch of godot-cpp comes with an API file (extension_api.json) appropriate for
the respective Godot version (e.g. the 4.3 branch comes with the API file compatible
with Godot version 4.3 and later).

However, you may want to use a custom extension_api.json, for example:

- If you want to use the latest APIs from Godot master.
- If you build Godot yourself with different options than the official builds (e.g. disable_3d=yes or precision=double).
- If you want to use APIs exposed by custom modules.

To use a custom API file, you first have to generate it from the appropriate Godot
executable:

```
godot --dump-extension-api
```

The resulting extension_api.json file will be created in the executable's
directory. To use it, you can add custom_api_file to your build command:

```
scons platform= custom_api_file=
```

Alternatively, you can add it as the default API file to your project by adding
the following line to your SConstruct file:

```python
localEnv["custom_api_file"] = "extension_api.json"
```
