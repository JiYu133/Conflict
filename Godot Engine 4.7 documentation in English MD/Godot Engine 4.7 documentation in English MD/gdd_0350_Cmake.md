# Secondary build system: Working with CMake

See also

This page documents how to compile godot-cpp. If you're looking to compile
Godot instead, see Introduction to the buildsystem.

Beside the SCons [http://cmake.org] based build system, godot-cpp also provides a CMakeLists.txt [https://github.com/godotengine/godot-cpp/blob/master/CMakeLists.txt]
file to support users that prefer using CMake [http://scons.org] over SCons for their build
system.

While actively supported, the CMake system is considered secondary to the
SCons build system. This means it may lack some features that are available to
projects using SCons.

## Introduction

Compiling godot-cpp independently of an extension project is mainly for
godot-cpp developers, package maintainers, and CI/CD.

Examples of how to use CMake to consume the godot-cpp library as part of an
extension project:

- godot-cpp-template [https://github.com/godotengine/godot-cpp-template/]
- godot_roguelite [https://github.com/vorlac/godot-roguelite/]
- godot-orchestrator [https://github.com/CraterCrash/godot-orchestrator/]

Examples for configuring godot-cpp are listed at the bottom of the page, many
of which may help with configuring your project.

## CMake's Debug vs Godot's template_debug

Something that has come up during many discussions is the conflation of a
compilation of C++ source code with debug symbols enabled, and compiling a
Godot extension with debug features enabled. The two concepts are not mutually
exclusive.

### Debug Features

Enables a pre-processor definition to selectively compile code to help users of
a Godot extension with their own project.

Debug features are enabled in editor and template_debug builds, which
can be specified during the configure phase like so:

```
cmake -S godot-cpp -B cmake-build -DGODOTCPP_TARGET=
```

### Debug

Sets compiler flags so that debug symbols are generated to help godot extension
developers debug their extension.

Debug is the default build type for CMake projects, the way to select another
depends on the generator used:

- For single configuration generators, add -DCMAKE_BUILD_TYPE= to the
configure command.
- For multi-config generators, add --config  to the build command.

Where  is one of Debug, Release, RelWithDebInfo, and
MinSizeRel.

## SCons Deviations

Not all code from the SCons system can be perfectly represented in CMake, here
are the notable differences:

- debug_symbols

Is no longer an explicit option, and is enabled when using CMake build
configurations; Debug, RelWithDebInfo.
- dev_build

Does not define NDEBUG when disabled, NDEBUG is set when using
CMake build configurations; Release, MinSizeRel.
- arch

CMake sets the architecture via the toolchain files, macOS universal is
controlled via the CMAKE_OSX_ARCHITECTURES property which is copied to
targets when they are defined.
- debug_crt

CMake controls linking to Windows runtime libraries by copying the value of
CMAKE_MSVC_RUNTIME_LIBRARIES to targets as they are defined. godot-cpp
will set this variable if it isn't already set. So, include it before other
dependencies to have the value propagate across the projects.

## Basic Walk-Through

### Clone the git repository

```
git clone https://github.com/godotengine/godot-cpp.git
Cloning into 'godot-cpp'...
...
```

### Configure the build

```
cmake -S godot-cpp -B cmake-build -G Ninja
```

- -S Specifies the source directory as godot-cpp
- -B Specifies the build directory as cmake-build
- -G Specifies the Generator as Ninja

The source directory in this example is the source root for the freshly cloned
godot-cpp. CMake will also interpret the first path in the command as the
source path, or if an existing build path is specified it will deduce the
source path from the build cache.

The following three commands are equivalent:

```
# Current working directory is the godot-cpp source root.
cmake . -B build-dir
# Current working directory is an empty godot-cpp/build-dir.
cmake ../
# Current working directory is an existing build path.
cmake .
```

The build directory is specified so that generated files do not clutter the
source tree with build artifacts.

CMake doesn't build the code, it generates the files that a build tool uses, in
this case the Ninja generator creates Ninja [https://ninja-build.org/] build files.

To see the list of generators run cmake --help.

### Build Options

To list the available options use the -L[AH] command flags. A is for
advanced, and H is for help strings:

```
cmake -S godot-cpp -LH
```

Options are specified on the command line when configuring, for example:

```
cmake -S godot-cpp -DGODOTCPP_USE_HOT_RELOAD:BOOL=ON \
    -DGODOTCPP_PRECISION:STRING=double \
    -DCMAKE_BUILD_TYPE:STRING=Debug
```

See setting-build-variables [https://cmake.org/cmake/help/latest/guide/user-interaction/index.html#setting-build-variables] and build-configurations [https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#build-configurations] for more information.

#### A non-exhaustive list of options:

```
// Path to a custom GDExtension API JSON file.
// (takes precedence over GODOTCPP_GDEXTENSION_DIR)
// ( /path/to/custom_api_file )
GODOTCPP_CUSTOM_API_FILE:FILEPATH=
// Force disabling exception handling code. (ON|OFF)
GODOTCPP_DISABLE_EXCEPTIONS:BOOL=ON
// Path to a custom directory containing the GDExtension interface
// header and API JSON file. ( /path/to/gdextension_dir )
GODOTCPP_GDEXTENSION_DIR:PATH=gdextension
// Set the floating-point precision level. (single|double)
GODOTCPP_PRECISION:STRING=single
// Enable the extra accounting required to support hot reload. (ON|OFF)
GODOTCPP_USE_HOT_RELOAD:BOOL=
```

### Compiling

Tell CMake to invoke the build system it generated in the specified directory.
The default target is template_debug and the default build configuration is
Debug.

```
cmake --build cmake-build
```

## Examples

These examples, while intended for godot-cpp developers, package maintainers,
and CI/CD may help you configure your own extension project.

Practical examples for how to consume the godot-cpp library as part of an
extension project are listed in the Introduction.

### Enabling Integration Testing

The testing target godot-cpp-test is guarded by GODOTCPP_ENABLE_TESTING
which is off by default.

To configure and build the godot-cpp project to enable the integration
testing targets the command will look something like:

```
cmake -S godot-cpp -B cmake-build -DGODOTCPP_ENABLE_TESTING=YES
cmake --build cmake-build --target godot-cpp-test
```

### Windows and MSVC - Release

So long as CMake is installed from the CMake Downloads [https://cmake.org/download/] page and in the PATH,
and Microsoft Visual Studio is installed with C++ support, CMake will detect
the MSVC compiler.

Note that Visual Studio is a Multi-Config Generator so the build configuration
needs to be specified at build time, for example, --config Release.

```
cmake -S godot-cpp -B cmake-build -DGODOTCPP_ENABLE_TESTING=YES
cmake --build cmake-build -t godot-cpp-test --config Release
```

### MSys2/clang64, "Ninja" - Debug

Assumes the ming-w64-clang-x86_64-toolchain is installed.

Note that Ninja is a Single-Config Generator so the build type needs to be
specified at configuration time.

Using the msys2/clang64 shell:

```
cmake -S godot-cpp -B cmake-build -G"Ninja" \
    -DGODOTCPP_ENABLE_TESTING=YES -DCMAKE_BUILD_TYPE=Release
cmake --build cmake-build -t godot-cpp-test
```

### MSys2/clang64, "Ninja Multi-Config" - dev_build, Debug Symbols

Assumes the ming-w64-clang-x86_64-toolchain is installed.

This time we are choosing the 'Ninja Multi-Config' generator, so the build
type is specified at build time.

Using the msys2/clang64 shell:

```
cmake -S godot-cpp -B cmake-build -G"Ninja Multi-Config" \
    -DGODOTCPP_ENABLE_TESTING=YES -DGODOTCPP_DEV_BUILD:BOOL=ON
cmake --build cmake-build -t godot-cpp-test --config Debug
```

### Emscripten for web platform

This has only been tested on Windows so far. You can use this example workflow:

- Clone and install the latest Emscripten tools to c:\emsdk.
- Use C:\emsdk\emsdk.ps1 activate latest to enable the environment from
powershell in the current shell.
- The emcmake.bat utility adds the emscripten toolchain to the CMake
command. It can also be added manually;
the location is listed inside the emcmake.bat file

```
C:\emsdk\emsdk.ps1 activate latest
emcmake.bat cmake -S godot-cpp -B cmake-build-web -DCMAKE_BUILD_TYPE=Release
cmake --build cmake-build-web
```

### Android Cross Compile from Windows

There are two separate paths you can choose when configuring for android.

Use the CMAKE_ANDROID_* variables specified on the command line or in your
own toolchain file as listed in the cmake-toolchains [https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-android-with-the-ndk] documentation.

Or use the toolchain and scripts provided by the Android SDK and make changes
using the ANDROID_* variables listed there. Where  is whatever
NDK version you have installed (tested with 28.1.13356709) and 
is for the Android sdk platform, (tested with android-29).

Warning

The Android SDK website [https://developer.android.com/ndk/guides/cmake] explicitly states that they do not support using
the CMake built-in method, and recommends you stick with their toolchain
files.

#### Using your own toolchain file

As described in the CMake documentation:

```
cmake -S godot-cpp -B cmake-build --toolchain my_toolchain.cmake
cmake --build cmake-build -t template_release
```

Doing the equivalent just using the command line:

```
cmake -S godot-cpp -B cmake-build \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION= \
    -DCMAKE_ANDROID_ARCH_ABI= \
    -DCMAKE_ANDROID_NDK=/path/to/android-ndk
cmake --build cmake-build
```

#### Using the Android SDK toolchain file

This defaults to the minimum supported version and armv7-a:

```
cmake -S godot-cpp -B cmake-build \
    --toolchain $ANDROID_HOME/ndk//build/cmake/android.toolchain.cmake
cmake --build cmake-build
```

Specifying the Android platform and ABI:

```
cmake -S godot-cpp -B cmake-build \
    --toolchain $ANDROID_HOME/ndk//build/cmake/android.toolchain.cmake \
    -DANDROID_PLATFORM:STRING=android-29 \
    -DANDROID_ABI:STRING=armeabi-v7a
cmake --build cmake-build
```
