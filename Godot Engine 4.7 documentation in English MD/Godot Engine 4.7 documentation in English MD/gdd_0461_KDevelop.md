# KDevelop

KDevelop [https://www.kdevelop.org] is a free, open source IDE for all desktop platforms.

## Importing the project

- From the KDevelop's main screen select Open Project.

![../../../_images/kdevelop_newproject.png](../../../_images/kdevelop_newproject.png)

KDevelop's main screen.

- Navigate to the Godot root folder and select it.
- On the next screen, choose Custom Build System for the Project Manager.

![../../../_images/kdevelop_custombuild.png](../../../_images/kdevelop_custombuild.png)

- After the project has been imported, open the project configuration by right-clicking
on it in the Projects panel and selecting Open Configuration.. option.

![../../../_images/kdevelop_openconfig.png](../../../_images/kdevelop_openconfig.png)

- Under Language Support open the Includes/Imports tab and add the following paths:
.  // A dot, to indicate the root of the Godot project
core/
core/os/
core/math/
drivers/
platform//  // Replace  with a folder
                              corresponding to your current platform

![../../../_images/kdevelop_addincludes.png](../../../_images/kdevelop_addincludes.png)

- Apply the changes.
- Under Custom Build System add a new build configuration with the following settings:

Build Directory
blank

Enable
True

Executable
scons

Arguments
See Introduction to the buildsystem for a full list of arguments.

![../../../_images/kdevelop_buildconfig.png](../../../_images/kdevelop_buildconfig.png)

- Apply the changes and close the configuration window.

## Debugging the project

- Select Run > Configure Launches... from the top menu.

![../../../_images/kdevelop_configlaunches.png](../../../_images/kdevelop_configlaunches.png)

- Click Add to create a new launch configuration.
- Select Executable option and specify the path to your executable located in
the /bin folder. The name depends on your build configuration,
e.g. godot.linuxbsd.editor.dev.x86_64 for 64-bit LinuxBSD platform with
platform=linuxbsd, target=editor, and dev_build=yes.

![../../../_images/kdevelop_configlaunches2.png](../../../_images/kdevelop_configlaunches2.png)

If you run into any issues, ask for help in one of
Godot's community channels [https://godotengine.org/community].
