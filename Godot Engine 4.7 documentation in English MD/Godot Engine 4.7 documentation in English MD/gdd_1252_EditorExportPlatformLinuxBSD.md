# EditorExportPlatformLinuxBSD

Inherits: EditorExportPlatformPC < EditorExportPlatform < RefCounted < Object

Exporter for Linux/BSD.

## Tutorials

- Exporting for Linux

## Properties

String | binary_format/architecture
bool | binary_format/embed_pck
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

String binary_format/architecture 

Application executable architecture.

Supported architectures: x86_32, x86_64, arm64, arm32, rv64, ppc64, and loongarch64.

Official export templates include x86_32, x86_64, arm32, and arm64 binaries only.

---

bool binary_format/embed_pck 

If true, project resources are embedded into the executable.

---

String custom_template/debug 

Path to the custom export template. If left empty, default template is used.

---

String custom_template/release 

Path to the custom export template. If left empty, default template is used.

---

int debug/export_console_wrapper 

If true, a console wrapper is exported alongside the main executable, which allows running the project with enabled console output.

---

bool shader_baker/enabled 

If true, shaders will be compiled and embedded in the application. This option is only supported when using the Forward+ or Mobile renderers.

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
