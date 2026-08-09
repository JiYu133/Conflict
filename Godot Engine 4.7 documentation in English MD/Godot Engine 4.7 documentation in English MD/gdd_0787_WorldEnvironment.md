# WorldEnvironment

Inherits: Node < Object

Default environment properties for the entire scene (post-processing effects, lighting and background settings).

## Description

The WorldEnvironment node is used to configure the default Environment for the scene.

The parameters defined in the WorldEnvironment can be overridden by an Environment node set on the current Camera3D. Additionally, only one WorldEnvironment may be instantiated in a given scene at a time.

The WorldEnvironment allows the user to specify default lighting parameters (e.g. ambient lighting), various post-processing effects (e.g. SSAO, DOF, Tonemapping), and how to draw the background (e.g. solid color, skybox). Usually, these are added in order to improve the realism/color balance of the scene.

## Tutorials

- Environment and post-processing
- 3D Material Testers Demo [https://godotengine.org/asset-library/asset/2742]
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

CameraAttributes | camera_attributes
Compositor | compositor
Environment | environment

---

## Property Descriptions

CameraAttributes camera_attributes 

- void set_camera_attributes(value: CameraAttributes)
- CameraAttributes get_camera_attributes()

The default CameraAttributes resource to use if none set on the Camera3D.

---

Compositor compositor 

- void set_compositor(value: Compositor)
- Compositor get_compositor()

The default Compositor resource to use if none set on the Camera3D.

---

Environment environment 

- void set_environment(value: Environment)
- Environment get_environment()

The Environment resource used by this WorldEnvironment, defining the default properties.
