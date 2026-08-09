# Using the XR editor

In 2024, we introduced the Godot XR editor [https://godotengine.org/article/godot-editor-horizon-store-early-access-release/],
a version of the Godot editor designed to run natively on XR devices, enabling the creation,
development and export of 2D, 3D, and XR apps and games directly on device.

The app can be downloaded from the Google Play Store [https://play.google.com/store/apps/details?id=org.godotengine.editor.v4],
Meta Horizon Store [https://www.meta.com/experiences/godot-game-engine/7713660705416473/],
or from the Godot download page [https://godotengine.org/download/preview/].

Note

The XR editor is in early access, while we continue to refine the experience. See Limitations & known issues below.

## XR devices support

For now, the Godot XR editor is only available for Android XR devices, and the
following Meta Quest [https://www.meta.com/quest/] devices running Meta Horizon OS v69 or higher:

> Meta Quest 2
> Meta Quest 3
> Meta Quest 3s
> Meta Quest Pro

Note

We are working to add support for more XR devices, including PCVR devices.

## Runtime Permissions

- All files access permission [https://developer.android.com/training/data-storage/manage-all-files#all-files-access]:
Enables the editor to create, import, and read project files from any file locations on the device.
Without this permission, the editor is still functional, but has limited access to the device's files and directories.
- REQUEST_INSTALL_PACKAGES [https://developer.android.com/reference/android/Manifest.permission#REQUEST_INSTALL_PACKAGES]: Enables the editor to install exported project APKs.
- RECORD_AUDIO [https://developer.android.com/reference/android/Manifest.permission#RECORD_AUDIO]: Requested when the audio/driver/enable_input [https://docs.godotengine.org/en/stable/classes/class_projectsettings.html#class-projectsettings-property-audio-driver-enable-input] project setting is enabled.
- USE_SCENE (META ONLY) [https://developers.meta.com/horizon/documentation/native/native-spatial-data-perm/]: Required to enable and access the scene APIs when running an XR project.

## Tips & Tricks

Input

- For the best experience and high level of productivity, connecting a bluetooth keyboard & mouse is recommended to interact with the XR editor.
The XR editor supports all of the usual shortcuts and key mappings [https://docs.godotengine.org/en/stable/tutorials/editor/default_key_mapping.html].
- When interacting with tracked controllers or tracked hands, you can toggle on the
interface/touchscreen/enable_long_press_as_right_click [https://docs.godotengine.org/en/stable/classes/class_editorsettings.html#class-editorsettings-property-interface-touchscreen-enable-long-press-as-right-click] editor setting to enable right-click by long press.
- When interacting with tracked controllers or tracked hands, you can increase the size of the scrollbar using the
interface/touchscreen/increase_scrollbar_touch_area [https://docs.godotengine.org/en/stable/classes/class_editorsettings.html#class-editorsettings-property-interface-touchscreen-increase-scrollbar-touch-area] editor setting.

Multi-tasking on Quest

- Theater View [https://www.meta.com/blog/quest/meta-quest-v67-update-new-window-layout-creator-content-horizon-feed/] can be used to fullscreen the Editor window.
- Enable Seamless Multitasking [https://www.uploadvr.com/seamless-multitasking-experimental-quest/], available in the Quest Experimental Settings,
to enable the ability to quickly transition between a running XR project and the Editor window.
- When developing a non-XR project, the Godot editor app icon will provide the ability to switch between the Editor window and the Play window when the latter is active, using Quest's App menu feature.
- When developing and running an XR project, you can bring back the Editor window by:

Pressing on the Meta button to invoke the menu bar
Clicking on the Godot editor app icon to summon the App menu, and select the Editor window tile.
  - Pressing on the Meta button to invoke the menu bar
  - Clicking on the Godot editor app icon to summon the App menu, and select the Editor window tile.

Projects sync

- Syncing projects via Git can be done by downloading an Android Git client. We recommend the Termux terminal [https://termux.dev/en/],
an Android terminal emulator which provides access to common terminal utilities such Git and SSH.

Note: To use Git with the Termux terminal, you'll need to grant WRITE permission to the terminal.
This can be done by running the following command [https://wiki.termux.com/wiki/Termux-setup-storage] from within the terminal: termux-setup-storage
  - Note: To use Git with the Termux terminal, you'll need to grant WRITE permission to the terminal.
This can be done by running the following command [https://wiki.termux.com/wiki/Termux-setup-storage] from within the terminal: termux-setup-storage

Plugins

- GDExtension plugins work as expected, but require the plugin developer to provide native Android binaries.

## Limitations & known issues

Here are the known limitations and issues of the XR editor:

- No C#/Mono support.
- No support for external script editors.
- While available, the Vulkan Forward+ renderer is not recommended due to severe performance issues.
