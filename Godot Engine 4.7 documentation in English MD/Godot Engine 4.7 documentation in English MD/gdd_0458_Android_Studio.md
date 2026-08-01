# Android Studio

Android Studio [https://developer.android.com/studio] is a free
IDE for Android development made by Google [https://about.google/] and JetBrains [https://www.jetbrains.com/].
It's based on IntelliJ IDEA [https://www.jetbrains.com/idea/] and has a
feature-rich editor which supports Java and C/C++. It can be used to
work on Godot's core engine as well as the Android platform codebase.

## Importing the project

- From the Android Studio's welcome window select Open.

![../../../_images/android_studio_setup_project_1.png](../../../_images/android_studio_setup_project_1.png)

Android Studio's welcome window.

- Navigate to /platform/android/java and select the settings.gradle file.
- Android Studio will import and index the project.

## Android Studio project layout

The project is organized using Android Studio's modules [https://developer.android.com/studio/projects#ApplicationModules]:

- lib module:

Located under /platform/android/java/lib, this is a library module that organizes the Godot java and native code and make it available as a reusable Android library [https://developer.android.com/studio/projects/android-library].
The generated Godot Android library is made available for other Android modules / projects via MavenCentral [https://central.sonatype.com/artifact/org.godotengine/godot], along with its documentation [https://javadoc.io/doc/org.godotengine/godot/latest/index.html].
- editor module:

Located under /platform/android/java/editor, this is an application module that holds the source code for the Android and XR ports [https://godotengine.org/download/android/] of the Godot Editor.
This module has a dependency on the lib module.
- app module:

Located under /platform/android/java/app, this is an application module that holds the source code for the Android build templates.
This module has a dependency on the lib module.

## Building & debugging the editor module

- To build the editor module:

Select the Run/Debug Configurations drop down [https://developer.android.com/studio/run/rundebugconfig#running] and select editor.

Select Run > Run 'editor' from the top menu or click the Run icon [https://developer.android.com/studio/run/rundebugconfig#running].
- To debug the editor module:

Open the Build Variants window using View > Tools Windows > Build Variants from the top menu.
In the Build Variants window, make sure that in the Active Build Variant column, the :editor entry is set to one of the Debug variants.

Open the Run/Debug Configurations window by clicking on Run > Edit Configurations... on the top menu.
In the Run/Debug Configurations window, select the editor entry, and under Debugger make sure the Debug Type is set to Dual (Java + Native)
Click the + sign under the Symbol Directories section, and add the platform/android/java/lib/libs/tools/debug directory.

Select Run > Debug 'editor' from the top menu or click the Debug icon [https://developer.android.com/studio/run/rundebugconfig#running].

## Building & debugging the app module

The app module requires the presence of a Godot project in its assets directory (/platform/android/java/app/src/main/assets) to run.
This is usually handled by the Godot Editor during the export process.
While developing in Android Studio, it's necessary to manually add a Godot project under that directory to replicate the export process.
Once that's done, you can follow the instructions below to run/debug the app module:

- To build the app module:

Select the Run/Debug Configurations drop down [https://developer.android.com/studio/run/rundebugconfig#running] and select app.

Select Run > Run 'app' from the top menu or click the Run icon [https://developer.android.com/studio/run/rundebugconfig#running].
- To debug the app module:

Open the Build Variants window using View > Tools Windows > Build Variants from the top menu.
In the Build Variants window, make sure that in the Active Build Variant column, the :app entry is set to one of the Debug variants.

Open the Run/Debug Configurations window by clicking on Run > Edit Configurations... on the top menu.
In the Run/Debug Configurations window, select the app entry, and under Debugger make sure the Debug Type is set to Dual (Java + Native)
Click the + sign under the Symbol Directories section, and add the platform/android/java/lib/libs/debug directory.

Select Run > Debug 'app' from the top menu or click the Debug icon [https://developer.android.com/studio/run/rundebugconfig#running].

If you run into any issues, ask for help in
Godot's Android dev channel [https://chat.godotengine.org/channel/android].
