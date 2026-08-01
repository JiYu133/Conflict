# Building from source

Godot prides itself on being very easy to build, by C++ project standards.
Godot uses the SCons build system, and after the initial
setup compiling the engine for your current platform should be as easy as running:

```
scons
```

But you will probably need to use at least some of the available options to configure
the build to match your specific needs, be it a custom engine fork, a lightweight build
stripped of extra modules, or an executable targeting engine development.

The articles below should help you navigate configuration options available, as well as
prerequisites required to compile Godot exactly the way you need.

## Basics of building Godot

Let's start with basics, and learn how to get Godot's source code, and then which options
to use to compile it regardless of your target platform.

- Getting the source
- Introduction to the buildsystem

## Building for target platforms

Below you can find instructions for compiling the engine for your specific target platform.
Note that Godot supports cross-compilation, which means you can compile it for a target platform
that doesn't match your current platform (say, target Linux while being on Windows). The guides
will try their best to cover all possible situations.

- Compiling for Windows
- Compiling for Linux, *BSD
- Compiling for macOS
- Compiling for Android
- Compiling for iOS
- Compiling for visionOS
- Compiling for the Web
- Cross-compiling for iOS on Linux

## Other compilation targets and options

Some additional universal compilation options require further setup. Namely, while Godot
does have C#/.NET support as a part of its main codebase, it does not get compiled by
default to reduce the executable size for users who don't need C# for their projects.

Articles below explain how to configure the buildsystem for cases like this, and also
cover some optimization techniques.

- Compiling with .NET
- Compiling with PCK encryption key
- Optimizing a build for size
