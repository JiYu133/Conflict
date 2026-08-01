# EditorSceneFormatImporterFBX2GLTF

Inherits: EditorSceneFormatImporter < RefCounted < Object

Importer for the .fbx scene file format.

## Description

Imports Autodesk FBX 3D scenes by way of converting them to glTF 2.0 using the FBX2glTF command line tool.

The location of the FBX2glTF binary is set via the EditorSettings.filesystem/import/fbx/fbx2gltf_path editor setting.

This importer is only used if ProjectSettings.filesystem/import/fbx2gltf/enabled is set to true.
