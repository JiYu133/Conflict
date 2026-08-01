# EditorExportPlatformWindows

Inherits: EditorExportPlatformPC < EditorExportPlatform < RefCounted < Object

Exporter for Windows.

## Description

The Windows exporter customizes how a Windows build is handled. In the editor's "Export" window, it is created when adding a new "Windows" preset.

## Tutorials

- Exporting for Windows

## Properties

String | application/company_name
String | application/console_wrapper_icon
String | application/copyright
bool | application/d3d12_agility_sdk_multiarch
int | application/export_angle
int | application/export_d3d12
String | application/file_description
String | application/file_version
String | application/icon
int | application/icon_interpolation
bool | application/modify_resources
String | application/product_name
String | application/product_version
String | application/trademarks
String | binary_format/architecture
bool | binary_format/embed_pck
PackedStringArray | codesign/custom_options
String | codesign/description
int | codesign/digest_algorithm
bool | codesign/enable
String | codesign/identity
int | codesign/identity_type
String | codesign/password
bool | codesign/timestamp
String | codesign/timestamp_server_url
String | custom_template/debug
String | custom_template/release
int | debug/export_console_wrapper
bool | shader_baker/enabled
String | ssh_remote_deploy/cleanup_script
bool | ssh_remote_deploy/enabled
String | ssh_remote_deploy/extra_args_scp
String | ssh_remote_deploy/extra_args_ssh
String | ssh_remote_deploy/host
String | ssh_remote_deploy/port
String | ssh_remote_deploy/run_script
bool | texture_format/etc2_astc
bool | texture_format/s3tc_bptc

---

## Property Descriptions

String application/company_name 

Company that produced the application. Required. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String application/console_wrapper_icon 

Console wrapper icon file. If left empty, it will fallback to application/icon, then to ProjectSettings.application/config/windows_native_icon, and lastly, ProjectSettings.application/config/icon.

---

String application/copyright 

Copyright notice for the bundle visible to the user. Optional. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

bool application/d3d12_agility_sdk_multiarch 

If true, and application/export_d3d12 is set, the Agility SDK DLLs will be stored in arch-specific subdirectories.

---

int application/export_angle 

If set to 1, ANGLE libraries are exported with the exported application. If set to 0, ANGLE libraries are exported only if ProjectSettings.rendering/gl_compatibility/driver is set to "opengl3_angle".

---

int application/export_d3d12 

If set to 1, the Direct3D 12 runtime libraries (Agility SDK, PIX) are exported with the exported application. If set to 0, Direct3D 12 libraries are exported only if ProjectSettings.rendering/rendering_device/driver is set to "d3d12".

---

String application/file_description 

File description to be presented to users. Required. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String application/file_version 

Version number of the file. Falls back to ProjectSettings.application/config/version if left empty. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String application/icon 

Application icon file. If left empty, it will fallback to ProjectSettings.application/config/windows_native_icon, and then to ProjectSettings.application/config/icon.

---

int application/icon_interpolation 

Interpolation method used to resize application icon.

---

bool application/modify_resources 

If enabled, icon and metadata of the exported executable is set according to the other application/* values.

---

String application/product_name 

Name of the application. Required. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String application/product_version 

Application version visible to the user. Falls back to ProjectSettings.application/config/version if left empty. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String application/trademarks 

Trademarks and registered trademarks that apply to the file. Optional. See StringFileInfo [https://learn.microsoft.com/en-us/windows/win32/menurc/stringfileinfo-block].

---

String binary_format/architecture 

Application executable architecture.

Supported architectures: x86_32, x86_64, and arm64.

---

bool binary_format/embed_pck 

If true, project resources are embedded into the executable.

---

PackedStringArray codesign/custom_options 

Array of the additional command line arguments passed to the code signing tool. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

String codesign/description 

Description of the signed content. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

---

int codesign/digest_algorithm 

Digest algorithm to use for creating signature. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

---

bool codesign/enable 

If true, executable signing is enabled.

---

String codesign/identity 

PKCS #12 certificate file used to sign executable or certificate SHA-1 hash (if codesign/identity_type is set to "Use certificate store"). See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

Can be overridden with the environment variable GODOT_WINDOWS_CODESIGN_IDENTITY.

---

int codesign/identity_type 

Type of identity to use. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

Can be overridden with the environment variable GODOT_WINDOWS_CODESIGN_IDENTITY_TYPE.

---

String codesign/password 

Password for the certificate file used to sign executable. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

Can be overridden with the environment variable GODOT_WINDOWS_CODESIGN_PASSWORD.

---

bool codesign/timestamp 

If true, time-stamp is added to the signature. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

---

String codesign/timestamp_server_url 

URL of the time stamp server. If left empty, the default server is used. See Sign Tool [https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe].

---

String custom_template/debug 

Path to the custom export template. If left empty, default template is used.

---

String custom_template/release 

Path to the custom export template. If left empty, default template is used.

---

int debug/export_console_wrapper 

If true, a console wrapper executable is exported alongside the main executable, which allows running the project with enabled console output.

---

bool shader_baker/enabled 

If true, shaders will be compiled and embedded in the application. This option is only supported when using the Forward+ and Mobile renderers.

Note: When exporting as a dedicated server, the shader baker is always disabled since no rendering is performed.

---

String ssh_remote_deploy/cleanup_script 

Script code to execute on the remote host when app is finished.

The following variables can be used in the script:

- {temp_dir} - Path of temporary folder on the remote, used to upload app and scripts to.
- {archive_name} - Name of the ZIP containing uploaded application.
- {exe_name} - Name of application executable.
- {cmd_args} - Array of the command line argument for the application.

---

bool ssh_remote_deploy/enabled 

Enables remote deploy using SSH/SCP.

---

String ssh_remote_deploy/extra_args_scp 

Array of the additional command line arguments passed to the SCP.

---

String ssh_remote_deploy/extra_args_ssh 

Array of the additional command line arguments passed to the SSH.

---

String ssh_remote_deploy/host 

Remote host SSH user name and address, in user@address format.

---

String ssh_remote_deploy/port 

Remote host SSH port number.

---

String ssh_remote_deploy/run_script 

Script code to execute on the remote host when running the app.

The following variables can be used in the script:

- {temp_dir} - Path of temporary folder on the remote, used to upload app and scripts to.
- {archive_name} - Name of the ZIP containing uploaded application.
- {exe_name} - Name of application executable.
- {cmd_args} - Array of the command line argument for the application.

---

bool texture_format/etc2_astc 

If true, project textures are exported in the ETC2/ASTC format.

---

bool texture_format/s3tc_bptc 

If true, project textures are exported in the S3TC/BPTC format.
