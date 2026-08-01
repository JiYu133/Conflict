# EditorExportPlatformMacOS

Inherits: EditorExportPlatform < RefCounted < Object

Exporter for macOS.

## Tutorials

- Exporting for macOS
- Running Godot apps on macOS

## Properties

String | application/additional_plist_content
String | application/app_category
String | application/bundle_identifier
String | application/copyright
Dictionary | application/copyright_localized
int | application/export_angle
String | application/icon
int | application/icon_interpolation
String | application/liquid_glass_icon
String | application/min_macos_version_arm64
String | application/min_macos_version_x86_64
String | application/short_version
String | application/signature
String | application/version
String | binary_format/architecture
String | codesign/apple_team_id
String | codesign/certificate_file
String | codesign/certificate_password
int | codesign/codesign
PackedStringArray | codesign/custom_options
String | codesign/entitlements/additional
bool | codesign/entitlements/address_book
bool | codesign/entitlements/allow_dyld_environment_variables
bool | codesign/entitlements/allow_jit_code_execution
bool | codesign/entitlements/allow_unsigned_executable_memory
bool | codesign/entitlements/app_sandbox/device_bluetooth
bool | codesign/entitlements/app_sandbox/device_usb
bool | codesign/entitlements/app_sandbox/enabled
int | codesign/entitlements/app_sandbox/files_downloads
int | codesign/entitlements/app_sandbox/files_movies
int | codesign/entitlements/app_sandbox/files_music
int | codesign/entitlements/app_sandbox/files_pictures
int | codesign/entitlements/app_sandbox/files_user_selected
Array | codesign/entitlements/app_sandbox/helper_executables
bool | codesign/entitlements/app_sandbox/network_client
bool | codesign/entitlements/app_sandbox/network_server
bool | codesign/entitlements/apple_events
bool | codesign/entitlements/audio_input
bool | codesign/entitlements/calendars
bool | codesign/entitlements/camera
String | codesign/entitlements/custom_file
bool | codesign/entitlements/debugging
bool | codesign/entitlements/disable_library_validation
bool | codesign/entitlements/location
bool | codesign/entitlements/photos_library
String | codesign/identity
String | codesign/installer_identity
String | codesign/provisioning_profile
String | custom_template/debug
String | custom_template/release
int | debug/export_console_wrapper
bool | display/high_res
int | export/distribution_type
String | notarization/api_key
String | notarization/api_key_id
String | notarization/api_uuid
String | notarization/apple_id_name
String | notarization/apple_id_password
int | notarization/notarization
String | privacy/address_book_usage_description
Dictionary | privacy/address_book_usage_description_localized
String | privacy/calendar_usage_description
Dictionary | privacy/calendar_usage_description_localized
String | privacy/camera_usage_description
Dictionary | privacy/camera_usage_description_localized
bool | privacy/collected_data/advertising_data/collected
int | privacy/collected_data/advertising_data/collection_purposes
bool | privacy/collected_data/advertising_data/linked_to_user
bool | privacy/collected_data/advertising_data/used_for_tracking
bool | privacy/collected_data/audio_data/collected
int | privacy/collected_data/audio_data/collection_purposes
bool | privacy/collected_data/audio_data/linked_to_user
bool | privacy/collected_data/audio_data/used_for_tracking
bool | privacy/collected_data/browsing_history/collected
int | privacy/collected_data/browsing_history/collection_purposes
bool | privacy/collected_data/browsing_history/linked_to_user
bool | privacy/collected_data/browsing_history/used_for_tracking
bool | privacy/collected_data/coarse_location/collected
int | privacy/collected_data/coarse_location/collection_purposes
bool | privacy/collected_data/coarse_location/linked_to_user
bool | privacy/collected_data/coarse_location/used_for_tracking
bool | privacy/collected_data/contacts/collected
int | privacy/collected_data/contacts/collection_purposes
bool | privacy/collected_data/contacts/linked_to_user
bool | privacy/collected_data/contacts/used_for_tracking
bool | privacy/collected_data/crash_data/collected
int | privacy/collected_data/crash_data/collection_purposes
bool | privacy/collected_data/crash_data/linked_to_user
bool | privacy/collected_data/crash_data/used_for_tracking
bool | privacy/collected_data/credit_info/collected
int | privacy/collected_data/credit_info/collection_purposes
bool | privacy/collected_data/credit_info/linked_to_user
bool | privacy/collected_data/credit_info/used_for_tracking
bool | privacy/collected_data/customer_support/collected
int | privacy/collected_data/customer_support/collection_purposes
bool | privacy/collected_data/customer_support/linked_to_user
bool | privacy/collected_data/customer_support/used_for_tracking
bool | privacy/collected_data/device_id/collected
int | privacy/collected_data/device_id/collection_purposes
bool | privacy/collected_data/device_id/linked_to_user
bool | privacy/collected_data/device_id/used_for_tracking
bool | privacy/collected_data/email_address/collected
int | privacy/collected_data/email_address/collection_purposes
bool | privacy/collected_data/email_address/linked_to_user
bool | privacy/collected_data/email_address/used_for_tracking
bool | privacy/collected_data/emails_or_text_messages/collected
int | privacy/collected_data/emails_or_text_messages/collection_purposes
bool | privacy/collected_data/emails_or_text_messages/linked_to_user
bool | privacy/collected_data/emails_or_text_messages/used_for_tracking
bool | privacy/collected_data/environment_scanning/collected
int | privacy/collected_data/environment_scanning/collection_purposes
bool | privacy/collected_data/environment_scanning/linked_to_user
bool | privacy/collected_data/environment_scanning/used_for_tracking
bool | privacy/collected_data/fitness/collected
int | privacy/collected_data/fitness/collection_purposes
bool | privacy/collected_data/fitness/linked_to_user
bool | privacy/collected_data/fitness/used_for_tracking
bool | privacy/collected_data/gameplay_content/collected
int | privacy/collected_data/gameplay_content/collection_purposes
bool | privacy/collected_data/gameplay_content/linked_to_user
bool | privacy/collected_data/gameplay_content/used_for_tracking
bool | privacy/collected_data/hands/collected
int | privacy/collected_data/hands/collection_purposes
bool | privacy/collected_data/hands/linked_to_user
bool | privacy/collected_data/hands/used_for_tracking
bool | privacy/collected_data/head/collected
int | privacy/collected_data/head/collection_purposes
bool | privacy/collected_data/head/linked_to_user
bool | privacy/collected_data/head/used_for_tracking
bool | privacy/collected_data/health/collected
int | privacy/collected_data/health/collection_purposes
bool | privacy/collected_data/health/linked_to_user
bool | privacy/collected_data/health/used_for_tracking
bool | privacy/collected_data/name/collected
int | privacy/collected_data/name/collection_purposes
bool | privacy/collected_data/name/linked_to_user
bool | privacy/collected_data/name/used_for_tracking
bool | privacy/collected_data/other_contact_info/collected
int | privacy/collected_data/other_contact_info/collection_purposes
bool | privacy/collected_data/other_contact_info/linked_to_user
bool | privacy/collected_data/other_contact_info/used_for_tracking
bool | privacy/collected_data/other_data_types/collected
int | privacy/collected_data/other_data_types/collection_purposes
bool | privacy/collected_data/other_data_types/linked_to_user
bool | privacy/collected_data/other_data_types/used_for_tracking
bool | privacy/collected_data/other_diagnostic_data/collected
int | privacy/collected_data/other_diagnostic_data/collection_purposes
bool | privacy/collected_data/other_diagnostic_data/linked_to_user
bool | privacy/collected_data/other_diagnostic_data/used_for_tracking
bool | privacy/collected_data/other_financial_info/collected
int | privacy/collected_data/other_financial_info/collection_purposes
bool | privacy/collected_data/other_financial_info/linked_to_user
bool | privacy/collected_data/other_financial_info/used_for_tracking
bool | privacy/collected_data/other_usage_data/collected
int | privacy/collected_data/other_usage_data/collection_purposes
bool | privacy/collected_data/other_usage_data/linked_to_user
bool | privacy/collected_data/other_usage_data/used_for_tracking
bool | privacy/collected_data/other_user_content/collected
int | privacy/collected_data/other_user_content/collection_purposes
bool | privacy/collected_data/other_user_content/linked_to_user
bool | privacy/collected_data/other_user_content/used_for_tracking
bool | privacy/collected_data/payment_info/collected
int | privacy/collected_data/payment_info/collection_purposes
bool | privacy/collected_data/payment_info/linked_to_user
bool | privacy/collected_data/payment_info/used_for_tracking
bool | privacy/collected_data/performance_data/collected
int | privacy/collected_data/performance_data/collection_purposes
bool | privacy/collected_data/performance_data/linked_to_user
bool | privacy/collected_data/performance_data/used_for_tracking
bool | privacy/collected_data/phone_number/collected
int | privacy/collected_data/phone_number/collection_purposes
bool | privacy/collected_data/phone_number/linked_to_user
bool | privacy/collected_data/phone_number/used_for_tracking
bool | privacy/collected_data/photos_or_videos/collected
int | privacy/collected_data/photos_or_videos/collection_purposes
bool | privacy/collected_data/photos_or_videos/linked_to_user
bool | privacy/collected_data/photos_or_videos/used_for_tracking
bool | privacy/collected_data/physical_address/collected
int | privacy/collected_data/physical_address/collection_purposes
bool | privacy/collected_data/physical_address/linked_to_user
bool | privacy/collected_data/physical_address/used_for_tracking
bool | privacy/collected_data/precise_location/collected
int | privacy/collected_data/precise_location/collection_purposes
bool | privacy/collected_data/precise_location/linked_to_user
bool | privacy/collected_data/precise_location/used_for_tracking
bool | privacy/collected_data/product_interaction/collected
int | privacy/collected_data/product_interaction/collection_purposes
bool | privacy/collected_data/product_interaction/linked_to_user
bool | privacy/collected_data/product_interaction/used_for_tracking
bool | privacy/collected_data/purchase_history/collected
int | privacy/collected_data/purchase_history/collection_purposes
bool | privacy/collected_data/purchase_history/linked_to_user
bool | privacy/collected_data/purchase_history/used_for_tracking
bool | privacy/collected_data/search_history/collected
int | privacy/collected_data/search_history/collection_purposes
bool | privacy/collected_data/search_history/linked_to_user
bool | privacy/collected_data/search_history/used_for_tracking
bool | privacy/collected_data/sensitive_info/collected
int | privacy/collected_data/sensitive_info/collection_purposes
bool | privacy/collected_data/sensitive_info/linked_to_user
bool | privacy/collected_data/sensitive_info/used_for_tracking
bool | privacy/collected_data/user_id/collected
int | privacy/collected_data/user_id/collection_purposes
bool | privacy/collected_data/user_id/linked_to_user
bool | privacy/collected_data/user_id/used_for_tracking
String | privacy/desktop_folder_usage_description
Dictionary | privacy/desktop_folder_usage_description_localized
String | privacy/documents_folder_usage_description
Dictionary | privacy/documents_folder_usage_description_localized
String | privacy/downloads_folder_usage_description
Dictionary | privacy/downloads_folder_usage_description_localized
String | privacy/location_usage_description
Dictionary | privacy/location_usage_description_localized
String | privacy/microphone_usage_description
Dictionary | privacy/microphone_usage_description_localized
String | privacy/network_volumes_usage_description
Dictionary | privacy/network_volumes_usage_description_localized
String | privacy/photos_library_usage_description
Dictionary | privacy/photos_library_usage_description_localized
String | privacy/removable_volumes_usage_description
Dictionary | privacy/removable_volumes_usage_description_localized
PackedStringArray | privacy/tracking_domains
bool | privacy/tracking_enabled
bool | shader_baker/enabled
String | ssh_remote_deploy/cleanup_script
bool | ssh_remote_deploy/enabled
String | ssh_remote_deploy/extra_args_scp
String | ssh_remote_deploy/extra_args_ssh
String | ssh_remote_deploy/host
String | ssh_remote_deploy/port
String | ssh_remote_deploy/run_script
String | xcode/platform_build
String | xcode/sdk_build
String | xcode/sdk_name
String | xcode/sdk_version
String | xcode/xcode_build
String | xcode/xcode_version

---

## Property Descriptions

String application/additional_plist_content 

Additional data added to the root  section of the Info.plist [https://developer.apple.com/documentation/bundleresources/information_property_list] file. The value should be an XML section with pairs of key-value elements, e.g.:

```
key_name
value
```

---

String application/app_category 

Application category for the App Store.

---

String application/bundle_identifier 

Unique application identifier in a reverse-DNS format, can only contain alphanumeric characters (A-Z, a-z, and 0-9), hyphens (-), and periods (.).

---

String application/copyright 

Copyright notice for the bundle visible to the user (in English).

---

Dictionary application/copyright_localized 

Copyright notice for the bundle visible to the user (localized).

---

int application/export_angle 

If set to 1, ANGLE libraries are exported with the exported application. If set to 0, ANGLE libraries are exported only if ProjectSettings.rendering/gl_compatibility/driver is set to "opengl3_angle".

---

String application/icon 

Application icon file. If left empty, it will fallback to ProjectSettings.application/config/macos_native_icon, and then to ProjectSettings.application/config/icon.

---

int application/icon_interpolation 

Interpolation method used to resize application icon.

---

String application/liquid_glass_icon 

macOS 26 Liquid Glass icon source file. Use Icon Composer [https://developer.apple.com/icon-composer/] to create Liquid Glass icons.

Note: Supported when exporting from macOS only, Xcode 26+ required.

Note: Liquid Glass icons are supported on macOS 26 only, use application/icon to set the icon for older macOS versions.

---

String application/min_macos_version_arm64 

Minimum version of macOS required for this application to run on Apple Silicon Macs, in the major.minor.patch or major.minor format, can only contain numeric characters (0-9) and periods (.).

---

String application/min_macos_version_x86_64 

Minimum version of macOS required for this application to run on Intel Macs, in the major.minor.patch or major.minor format, can only contain numeric characters (0-9) and periods (.).

---

String application/short_version 

Application version visible to the user. Can only contain numeric characters (0-9) and periods (.). Falls back to ProjectSettings.application/config/version if left empty.

Note: This value is used for the Identity > Version value in the generated Xcode project.

---

String application/signature 

A four-character creator code that is specific to the bundle. Optional.

---

String application/version 

Machine-readable application version in the major.minor.patch format. Can only contain numeric characters (0-9) and periods (.). This must be incremented with every new release pushed to the App Store. Falls back to ProjectSettings.application/config/version if left empty.

Note: This value is used for the Identity > Build value in the generated Xcode project.

---

String binary_format/architecture 

Application executable architecture.

Supported architectures: x86_64, arm64, and universal (x86_64 + arm64).

Official export templates include universal binaries only.

---

String codesign/apple_team_id 

Apple Team ID, unique 10-character string. To locate your Team ID check "Membership details" section in your Apple developer account dashboard, or "Organizational Unit" of your code signing certificate. See Locate your Team ID [https://developer.apple.com/help/account/manage-your-team/locate-your-team-id].

---

String codesign/certificate_file 

PKCS #12 certificate file used to sign .app bundle.

Can be overridden with the environment variable GODOT_MACOS_CODESIGN_CERTIFICATE_FILE.

---

String codesign/certificate_password 

Password for the certificate file used to sign .app bundle.

Can be overridden with the environment variable GODOT_MACOS_CODESIGN_CERTIFICATE_PASSWORD.

---

int codesign/codesign 

Tool to use for code signing.

---

PackedStringArray codesign/custom_options 

Array of the additional command line arguments passed to the code signing tool.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

String codesign/entitlements/additional 

Additional data added to the root  section of the .entitlements [https://developer.apple.com/documentation/bundleresources/entitlements] file. The value should be an XML section with pairs of key-value elements, for example:

```
key_name
value
```

---

bool codesign/entitlements/address_book 

Enable to allow access to contacts in the user's address book, if it's enabled you should also provide usage message in the privacy/address_book_usage_description option. See com.apple.security.personal-information.addressbook [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_personal-information_addressbook].

---

bool codesign/entitlements/allow_dyld_environment_variables 

Allows app to use dynamic linker environment variables to inject code. If you are using add-ons with dynamic or self-modifying native code, enable them according to the add-on documentation. See com.apple.security.cs.allow-dyld-environment-variables [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_cs_allow-dyld-environment-variables].

---

bool codesign/entitlements/allow_jit_code_execution 

Allows creating writable and executable memory for JIT code. If you are using add-ons with dynamic or self-modifying native code, enable them according to the add-on documentation. See com.apple.security.cs.allow-jit [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_cs_allow-jit].

---

bool codesign/entitlements/allow_unsigned_executable_memory 

Allows creating writable and executable memory without JIT restrictions. If you are using add-ons with dynamic or self-modifying native code, enable them according to the add-on documentation. See com.apple.security.cs.allow-unsigned-executable-memory [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_cs_allow-unsigned-executable-memory].

---

bool codesign/entitlements/app_sandbox/device_bluetooth 

Enable to allow app to interact with Bluetooth devices. This entitlement is required to use wireless controllers. See com.apple.security.device.bluetooth [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_device_bluetooth].

---

bool codesign/entitlements/app_sandbox/device_usb 

Enable to allow app to interact with USB devices. This entitlement is required to use wired controllers. See com.apple.security.device.usb [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_device_usb].

---

bool codesign/entitlements/app_sandbox/enabled 

Enables App Sandbox. The App Sandbox restricts access to user data, networking, and devices. Sandboxed apps can't access most of the file system, can't use custom file dialogs and execute binaries outside the .app bundle. See App Sandbox [https://developer.apple.com/documentation/security/app_sandbox].

Note: To distribute an app through the App Store, you must enable the App Sandbox.

---

int codesign/entitlements/app_sandbox/files_downloads 

Allows read or write access to the user's "Downloads" folder. See com.apple.security.files.downloads.read-write [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_files_downloads_read-write].

---

int codesign/entitlements/app_sandbox/files_movies 

Allows read or write access to the user's "Movies" folder. See com.apple.security.files.movies.read-write [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_assets_movies_read-write].

---

int codesign/entitlements/app_sandbox/files_music 

Allows read or write access to the user's "Music" folder. See com.apple.security.files.music.read-write [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_assets_music_read-write].

---

int codesign/entitlements/app_sandbox/files_pictures 

Allows read or write access to the user's "Pictures" folder. See com.apple.security.files.pictures.read-write [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_assets_pictures_read-write].

---

int codesign/entitlements/app_sandbox/files_user_selected 

Allows read or write access to the locations the user has selected using a native file dialog. See com.apple.security.files.user-selected.read-write [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_files_user-selected_read-write].

---

Array codesign/entitlements/app_sandbox/helper_executables 

List of helper executables to embedded to the app bundle. Sandboxed app are limited to execute only these executable. See Embedding a command-line tool in a sandboxed app [https://developer.apple.com/documentation/xcode/embedding-a-helper-tool-in-a-sandboxed-app].

---

bool codesign/entitlements/app_sandbox/network_client 

Enable to allow app to establish outgoing network connections. See com.apple.security.network.client [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_network_client].

---

bool codesign/entitlements/app_sandbox/network_server 

Enable to allow app to listen for incoming network connections. See com.apple.security.network.server [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_network_server].

---

bool codesign/entitlements/apple_events 

Enable to allow app to send Apple events to other apps. See com.apple.security.automation.apple-events [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_automation_apple-events].

---

bool codesign/entitlements/audio_input 

Enable if you need to use the microphone or other audio input sources, if it's enabled you should also provide usage message in the privacy/microphone_usage_description option. See com.apple.security.device.audio-input [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_device_audio-input].

---

bool codesign/entitlements/calendars 

Enable to allow access to the user's calendar, if it's enabled you should also provide usage message in the privacy/calendar_usage_description option. See com.apple.security.personal-information.calendars [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_personal-information_calendars].

---

bool codesign/entitlements/camera 

Enable if you need to use the camera, if it's enabled you should also provide usage message in the privacy/camera_usage_description option. See com.apple.security.device.camera [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_device_camera].

---

String codesign/entitlements/custom_file 

Custom entitlements .plist file, if specified the rest of entitlements in the export config are ignored.

---

bool codesign/entitlements/debugging 

You can temporarily enable this entitlement to use native debugger (GDB, LLDB) with the exported app. This entitlement should be disabled for production export. See Embedding a command-line tool in a sandboxed app [https://developer.apple.com/documentation/xcode/embedding-a-helper-tool-in-a-sandboxed-app].

---

bool codesign/entitlements/disable_library_validation 

Allows app to load arbitrary libraries and frameworks (not signed with the same Team ID as the main executable or by Apple). Enable it if you are using GDExtension add-ons or ad-hoc signing, or want to support user-provided external add-ons. See com.apple.security.cs.disable-library-validation [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_cs_disable-library-validation].

---

bool codesign/entitlements/location 

Enable if you need to use location information from Location Services, if it's enabled you should also provide usage message in the privacy/location_usage_description option. See com.apple.security.personal-information.location [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_personal-information_location].

---

bool codesign/entitlements/photos_library 

Enable to allow access to the user's Photos library, if it's enabled you should also provide usage message in the privacy/photos_library_usage_description option. See com.apple.security.personal-information.photos-library [https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_personal-information_photos-library].

---

String codesign/identity 

The "Full Name", "Common Name" or SHA-1 hash of the signing identity used to sign .app bundle.

---

String codesign/installer_identity 

The "Full Name", "Common Name" or SHA-1 hash of the signing identity used to sign .pkg installer package for App Store distribution, use 3rd Party Mac Developer Installer: Name. identity.

---

String codesign/provisioning_profile 

Provisioning profile file downloaded from Apple developer account dashboard. See Edit, download, or delete provisioning profiles [https://developer.apple.com/help/account/manage-profiles/edit-download-or-delete-profiles].

Can be overridden with the environment variable GODOT_MACOS_CODESIGN_PROVISIONING_PROFILE.

---

String custom_template/debug 

Path to the custom export template. If left empty, default template is used.

---

String custom_template/release 

Path to the custom export template. If left empty, default template is used.

---

int debug/export_console_wrapper 

If enabled, a wrapper that can be used to run the application with console output is created alongside the exported application.

---

bool display/high_res 

If true, the application is rendered at native display resolution, otherwise it is always rendered at loDPI resolution and upscaled by OS when required.

---

int export/distribution_type 

Application distribution target.

---

String notarization/api_key 

Apple App Store Connect API issuer key file.

Can be overridden with the environment variable GODOT_MACOS_NOTARIZATION_API_KEY.

---

String notarization/api_key_id 

Apple App Store Connect API issuer key ID.

Can be overridden with the environment variable GODOT_MACOS_NOTARIZATION_API_KEY_ID.

---

String notarization/api_uuid 

Apple App Store Connect API issuer UUID.

Can be overridden with the environment variable GODOT_MACOS_NOTARIZATION_API_UUID.

---

String notarization/apple_id_name 

Apple ID account name (email address).

Can be overridden with the environment variable GODOT_MACOS_NOTARIZATION_APPLE_ID_NAME.

---

String notarization/apple_id_password 

Apple ID app-specific password.

Can be overridden with the environment variable GODOT_MACOS_NOTARIZATION_APPLE_ID_PASSWORD.

---

int notarization/notarization 

Tool to use for notarization.

---

String privacy/address_book_usage_description 

A message displayed when requesting access to the user's contacts (in English).

---

Dictionary privacy/address_book_usage_description_localized 

A message displayed when requesting access to the user's contacts (localized).

---

String privacy/calendar_usage_description 

A message displayed when requesting access to the user's calendar data (in English).

---

Dictionary privacy/calendar_usage_description_localized 

A message displayed when requesting access to the user's calendar data (localized).

---

String privacy/camera_usage_description 

A message displayed when requesting access to the device's camera (in English).

---

Dictionary privacy/camera_usage_description_localized 

A message displayed when requesting access to the device's camera (localized).

---

bool privacy/collected_data/advertising_data/collected 

Indicates whether your app collects advertising data.

---

int privacy/collected_data/advertising_data/collection_purposes 

The reasons your app collects advertising data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/advertising_data/linked_to_user 

Indicates whether your app links advertising data to the user's identity.

---

bool privacy/collected_data/advertising_data/used_for_tracking 

Indicates whether your app uses advertising data for tracking.

---

bool privacy/collected_data/audio_data/collected 

Indicates whether your app collects audio data.

---

int privacy/collected_data/audio_data/collection_purposes 

The reasons your app collects audio data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/audio_data/linked_to_user 

Indicates whether your app links audio data to the user's identity.

---

bool privacy/collected_data/audio_data/used_for_tracking 

Indicates whether your app uses audio data for tracking.

---

bool privacy/collected_data/browsing_history/collected 

Indicates whether your app collects browsing history.

---

int privacy/collected_data/browsing_history/collection_purposes 

The reasons your app collects browsing history. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/browsing_history/linked_to_user 

Indicates whether your app links browsing history to the user's identity.

---

bool privacy/collected_data/browsing_history/used_for_tracking 

Indicates whether your app uses browsing history for tracking.

---

bool privacy/collected_data/coarse_location/collected 

Indicates whether your app collects coarse location data.

---

int privacy/collected_data/coarse_location/collection_purposes 

The reasons your app collects coarse location data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/coarse_location/linked_to_user 

Indicates whether your app links coarse location data to the user's identity.

---

bool privacy/collected_data/coarse_location/used_for_tracking 

Indicates whether your app uses coarse location data for tracking.

---

bool privacy/collected_data/contacts/collected 

Indicates whether your app collects contacts.

---

int privacy/collected_data/contacts/collection_purposes 

The reasons your app collects contacts. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/contacts/linked_to_user 

Indicates whether your app links contacts to the user's identity.

---

bool privacy/collected_data/contacts/used_for_tracking 

Indicates whether your app uses contacts for tracking.

---

bool privacy/collected_data/crash_data/collected 

Indicates whether your app collects crash data.

---

int privacy/collected_data/crash_data/collection_purposes 

The reasons your app collects crash data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/crash_data/linked_to_user 

Indicates whether your app links crash data to the user's identity.

---

bool privacy/collected_data/crash_data/used_for_tracking 

Indicates whether your app uses crash data for tracking.

---

bool privacy/collected_data/credit_info/collected 

Indicates whether your app collects credit information.

---

int privacy/collected_data/credit_info/collection_purposes 

The reasons your app collects credit information. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/credit_info/linked_to_user 

Indicates whether your app links credit information to the user's identity.

---

bool privacy/collected_data/credit_info/used_for_tracking 

Indicates whether your app uses credit information for tracking.

---

bool privacy/collected_data/customer_support/collected 

Indicates whether your app collects customer support data.

---

int privacy/collected_data/customer_support/collection_purposes 

The reasons your app collects customer support data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/customer_support/linked_to_user 

Indicates whether your app links customer support data to the user's identity.

---

bool privacy/collected_data/customer_support/used_for_tracking 

Indicates whether your app uses customer support data for tracking.

---

bool privacy/collected_data/device_id/collected 

Indicates whether your app collects device IDs.

---

int privacy/collected_data/device_id/collection_purposes 

The reasons your app collects device IDs. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/device_id/linked_to_user 

Indicates whether your app links device IDs to the user's identity.

---

bool privacy/collected_data/device_id/used_for_tracking 

Indicates whether your app uses device IDs for tracking.

---

bool privacy/collected_data/email_address/collected 

Indicates whether your app collects email address.

---

int privacy/collected_data/email_address/collection_purposes 

The reasons your app collects email address. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/email_address/linked_to_user 

Indicates whether your app links email address to the user's identity.

---

bool privacy/collected_data/email_address/used_for_tracking 

Indicates whether your app uses email address for tracking.

---

bool privacy/collected_data/emails_or_text_messages/collected 

Indicates whether your app collects emails or text messages.

---

int privacy/collected_data/emails_or_text_messages/collection_purposes 

The reasons your app collects emails or text messages. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/emails_or_text_messages/linked_to_user 

Indicates whether your app links emails or text messages to the user's identity.

---

bool privacy/collected_data/emails_or_text_messages/used_for_tracking 

Indicates whether your app uses emails or text messages for tracking.

---

bool privacy/collected_data/environment_scanning/collected 

Indicates whether your app collects environment scanning data.

---

int privacy/collected_data/environment_scanning/collection_purposes 

The reasons your app collects environment scanning data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/environment_scanning/linked_to_user 

Indicates whether your app links environment scanning data to the user's identity.

---

bool privacy/collected_data/environment_scanning/used_for_tracking 

Indicates whether your app uses environment scanning data for tracking.

---

bool privacy/collected_data/fitness/collected 

Indicates whether your app collects fitness and exercise data.

---

int privacy/collected_data/fitness/collection_purposes 

The reasons your app collects fitness and exercise data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/fitness/linked_to_user 

Indicates whether your app links fitness and exercise data to the user's identity.

---

bool privacy/collected_data/fitness/used_for_tracking 

Indicates whether your app uses fitness and exercise data for tracking.

---

bool privacy/collected_data/gameplay_content/collected 

Indicates whether your app collects gameplay content.

---

int privacy/collected_data/gameplay_content/collection_purposes 

The reasons your app collects gameplay content. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/gameplay_content/linked_to_user 

Indicates whether your app links gameplay content to the user's identity.

---

bool privacy/collected_data/gameplay_content/used_for_tracking 

Indicates whether your app uses gameplay content for tracking.

---

bool privacy/collected_data/hands/collected 

Indicates whether your app collects user's hand structure and hand movements.

---

int privacy/collected_data/hands/collection_purposes 

The reasons your app collects user's hand structure and hand movements. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/hands/linked_to_user 

Indicates whether your app links user's hand structure and hand movements to the user's identity.

---

bool privacy/collected_data/hands/used_for_tracking 

Indicates whether your app uses user's hand structure and hand movements for tracking.

---

bool privacy/collected_data/head/collected 

Indicates whether your app collects user's head movement.

---

int privacy/collected_data/head/collection_purposes 

The reasons your app collects user's head movement. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/head/linked_to_user 

Indicates whether your app links user's head movement to the user's identity.

---

bool privacy/collected_data/head/used_for_tracking 

Indicates whether your app uses user's head movement for tracking.

---

bool privacy/collected_data/health/collected 

Indicates whether your app collects health and medical data.

---

int privacy/collected_data/health/collection_purposes 

The reasons your app collects health and medical data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/health/linked_to_user 

Indicates whether your app links health and medical data to the user's identity.

---

bool privacy/collected_data/health/used_for_tracking 

Indicates whether your app uses health and medical data for tracking.

---

bool privacy/collected_data/name/collected 

Indicates whether your app collects user's name.

---

int privacy/collected_data/name/collection_purposes 

The reasons your app collects user's name. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/name/linked_to_user 

Indicates whether your app links user's name to the user's identity.

---

bool privacy/collected_data/name/used_for_tracking 

Indicates whether your app uses user's name for tracking.

---

bool privacy/collected_data/other_contact_info/collected 

Indicates whether your app collects any other contact information.

---

int privacy/collected_data/other_contact_info/collection_purposes 

The reasons your app collects any other contact information. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_contact_info/linked_to_user 

Indicates whether your app links any other contact information to the user's identity.

---

bool privacy/collected_data/other_contact_info/used_for_tracking 

Indicates whether your app uses any other contact information for tracking.

---

bool privacy/collected_data/other_data_types/collected 

Indicates whether your app collects any other data.

---

int privacy/collected_data/other_data_types/collection_purposes 

The reasons your app collects any other data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_data_types/linked_to_user 

Indicates whether your app links any other data to the user's identity.

---

bool privacy/collected_data/other_data_types/used_for_tracking 

Indicates whether your app uses any other data for tracking.

---

bool privacy/collected_data/other_diagnostic_data/collected 

Indicates whether your app collects any other diagnostic data.

---

int privacy/collected_data/other_diagnostic_data/collection_purposes 

The reasons your app collects any other diagnostic data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_diagnostic_data/linked_to_user 

Indicates whether your app links any other diagnostic data to the user's identity.

---

bool privacy/collected_data/other_diagnostic_data/used_for_tracking 

Indicates whether your app uses any other diagnostic data for tracking.

---

bool privacy/collected_data/other_financial_info/collected 

Indicates whether your app collects any other financial information.

---

int privacy/collected_data/other_financial_info/collection_purposes 

The reasons your app collects any other financial information. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_financial_info/linked_to_user 

Indicates whether your app links any other financial information to the user's identity.

---

bool privacy/collected_data/other_financial_info/used_for_tracking 

Indicates whether your app uses any other financial information for tracking.

---

bool privacy/collected_data/other_usage_data/collected 

Indicates whether your app collects any other usage data.

---

int privacy/collected_data/other_usage_data/collection_purposes 

The reasons your app collects any other usage data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_usage_data/linked_to_user 

Indicates whether your app links any other usage data to the user's identity.

---

bool privacy/collected_data/other_usage_data/used_for_tracking 

Indicates whether your app uses any other usage data for tracking.

---

bool privacy/collected_data/other_user_content/collected 

Indicates whether your app collects any other user generated content.

---

int privacy/collected_data/other_user_content/collection_purposes 

The reasons your app collects any other user generated content. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/other_user_content/linked_to_user 

Indicates whether your app links any other user generated content to the user's identity.

---

bool privacy/collected_data/other_user_content/used_for_tracking 

Indicates whether your app uses any other user generated content for tracking.

---

bool privacy/collected_data/payment_info/collected 

Indicates whether your app collects payment information.

---

int privacy/collected_data/payment_info/collection_purposes 

The reasons your app collects payment information. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/payment_info/linked_to_user 

Indicates whether your app links payment information to the user's identity.

---

bool privacy/collected_data/payment_info/used_for_tracking 

Indicates whether your app uses payment information for tracking.

---

bool privacy/collected_data/performance_data/collected 

Indicates whether your app collects performance data.

---

int privacy/collected_data/performance_data/collection_purposes 

The reasons your app collects performance data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/performance_data/linked_to_user 

Indicates whether your app links performance data to the user's identity.

---

bool privacy/collected_data/performance_data/used_for_tracking 

Indicates whether your app uses performance data for tracking.

---

bool privacy/collected_data/phone_number/collected 

Indicates whether your app collects phone number.

---

int privacy/collected_data/phone_number/collection_purposes 

The reasons your app collects phone number. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/phone_number/linked_to_user 

Indicates whether your app links phone number to the user's identity.

---

bool privacy/collected_data/phone_number/used_for_tracking 

Indicates whether your app uses phone number for tracking.

---

bool privacy/collected_data/photos_or_videos/collected 

Indicates whether your app collects photos or videos.

---

int privacy/collected_data/photos_or_videos/collection_purposes 

The reasons your app collects photos or videos. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/photos_or_videos/linked_to_user 

Indicates whether your app links photos or videos to the user's identity.

---

bool privacy/collected_data/photos_or_videos/used_for_tracking 

Indicates whether your app uses photos or videos for tracking.

---

bool privacy/collected_data/physical_address/collected 

Indicates whether your app collects physical address.

---

int privacy/collected_data/physical_address/collection_purposes 

The reasons your app collects physical address. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/physical_address/linked_to_user 

Indicates whether your app links physical address to the user's identity.

---

bool privacy/collected_data/physical_address/used_for_tracking 

Indicates whether your app uses physical address for tracking.

---

bool privacy/collected_data/precise_location/collected 

Indicates whether your app collects precise location data.

---

int privacy/collected_data/precise_location/collection_purposes 

The reasons your app collects precise location data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/precise_location/linked_to_user 

Indicates whether your app links precise location data to the user's identity.

---

bool privacy/collected_data/precise_location/used_for_tracking 

Indicates whether your app uses precise location data for tracking.

---

bool privacy/collected_data/product_interaction/collected 

Indicates whether your app collects product interaction data.

---

int privacy/collected_data/product_interaction/collection_purposes 

The reasons your app collects product interaction data. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/product_interaction/linked_to_user 

Indicates whether your app links product interaction data to the user's identity.

---

bool privacy/collected_data/product_interaction/used_for_tracking 

Indicates whether your app uses product interaction data for tracking.

---

bool privacy/collected_data/purchase_history/collected 

Indicates whether your app collects purchase history.

---

int privacy/collected_data/purchase_history/collection_purposes 

The reasons your app collects purchase history. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/purchase_history/linked_to_user 

Indicates whether your app links purchase history to the user's identity.

---

bool privacy/collected_data/purchase_history/used_for_tracking 

Indicates whether your app uses purchase history for tracking.

---

bool privacy/collected_data/search_history/collected 

Indicates whether your app collects search history.

---

int privacy/collected_data/search_history/collection_purposes 

The reasons your app collects search history. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/search_history/linked_to_user 

Indicates whether your app links search history to the user's identity.

---

bool privacy/collected_data/search_history/used_for_tracking 

Indicates whether your app uses search history for tracking.

---

bool privacy/collected_data/sensitive_info/collected 

Indicates whether your app collects sensitive user information.

---

int privacy/collected_data/sensitive_info/collection_purposes 

The reasons your app collects sensitive user information. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/sensitive_info/linked_to_user 

Indicates whether your app links sensitive user information to the user's identity.

---

bool privacy/collected_data/sensitive_info/used_for_tracking 

Indicates whether your app uses sensitive user information for tracking.

---

bool privacy/collected_data/user_id/collected 

Indicates whether your app collects user IDs.

---

int privacy/collected_data/user_id/collection_purposes 

The reasons your app collects user IDs. See Describing data use in privacy manifests [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests].

---

bool privacy/collected_data/user_id/linked_to_user 

Indicates whether your app links user IDs to the user's identity.

---

bool privacy/collected_data/user_id/used_for_tracking 

Indicates whether your app uses user IDs for tracking.

---

String privacy/desktop_folder_usage_description 

A message displayed when requesting access to the user's "Desktop" folder (in English).

---

Dictionary privacy/desktop_folder_usage_description_localized 

A message displayed when requesting access to the user's "Desktop" folder (localized).

---

String privacy/documents_folder_usage_description 

A message displayed when requesting access to the user's "Documents" folder (in English).

---

Dictionary privacy/documents_folder_usage_description_localized 

A message displayed when requesting access to the user's "Documents" folder (localized).

---

String privacy/downloads_folder_usage_description 

A message displayed when requesting access to the user's "Downloads" folder (in English).

---

Dictionary privacy/downloads_folder_usage_description_localized 

A message displayed when requesting access to the user's "Downloads" folder (localized).

---

String privacy/location_usage_description 

A message displayed when requesting access to the user's location information (in English).

---

Dictionary privacy/location_usage_description_localized 

A message displayed when requesting access to the user's location information (localized).

---

String privacy/microphone_usage_description 

A message displayed when requesting access to the device's microphone (in English).

---

Dictionary privacy/microphone_usage_description_localized 

A message displayed when requesting access to the device's microphone (localized).

---

String privacy/network_volumes_usage_description 

A message displayed when requesting access to the user's network drives (in English).

---

Dictionary privacy/network_volumes_usage_description_localized 

A message displayed when requesting access to the user's network drives (localized).

---

String privacy/photos_library_usage_description 

A message displayed when requesting access to the user's photo library (in English).

---

Dictionary privacy/photos_library_usage_description_localized 

A message displayed when requesting access to the user's photo library (localized).

---

String privacy/removable_volumes_usage_description 

A message displayed when requesting access to the user's removable drives (in English).

---

Dictionary privacy/removable_volumes_usage_description_localized 

A message displayed when requesting access to the user's removable drives (localized).

---

PackedStringArray privacy/tracking_domains 

The list of internet domains your app connects to that engage in tracking. See Privacy manifest files [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files].

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

bool privacy/tracking_enabled 

Indicates whether your app uses data for tracking. See Privacy manifest files [https://developer.apple.com/documentation/bundleresources/privacy_manifest_files].

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

String xcode/platform_build 

macOS build number used to build application executable.

---

String xcode/sdk_build 

macOS SDK build number used to build application executable.

---

String xcode/sdk_name 

macOS SDK name used to build application executable.

---

String xcode/sdk_version 

macOS SDK version used to build application executable in the major.minor format.

---

String xcode/xcode_build 

Xcode build number used to build application executable.

---

String xcode/xcode_version 

Xcode version used to build application executable.
