# VisualShaderNode

Inherits: Resource < RefCounted < Object

Inherited By: VisualShaderNodeBillboard, VisualShaderNodeClamp, VisualShaderNodeColorFunc, VisualShaderNodeColorOp, VisualShaderNodeCompare, VisualShaderNodeConstant, VisualShaderNodeCubemap, VisualShaderNodeCustom, VisualShaderNodeDerivativeFunc, VisualShaderNodeDeterminant, VisualShaderNodeDistanceFade, VisualShaderNodeDotProduct, VisualShaderNodeFloatFunc, VisualShaderNodeFloatOp, VisualShaderNodeFresnel, VisualShaderNodeIf, VisualShaderNodeInput, VisualShaderNodeIntFunc, VisualShaderNodeIntOp, VisualShaderNodeIs, VisualShaderNodeLinearSceneDepth, VisualShaderNodeMix, VisualShaderNodeMultiplyAdd, VisualShaderNodeOuterProduct, VisualShaderNodeOutput, VisualShaderNodeParameter, VisualShaderNodeParameterRef, VisualShaderNodeParticleAccelerator, VisualShaderNodeParticleConeVelocity, VisualShaderNodeParticleEmit, VisualShaderNodeParticleEmitter, VisualShaderNodeParticleMultiplyByAxisAngle, VisualShaderNodeParticleRandomness, VisualShaderNodeProximityFade, VisualShaderNodeRandomRange, VisualShaderNodeRemap, VisualShaderNodeReroute, VisualShaderNodeResizableBase, VisualShaderNodeRotationByAxis, VisualShaderNodeSample3D, VisualShaderNodeScreenNormalWorldSpace, VisualShaderNodeScreenUVToSDF, VisualShaderNodeSDFRaymarch, VisualShaderNodeSDFToScreenUV, VisualShaderNodeSmoothStep, VisualShaderNodeStep, VisualShaderNodeSwitch, VisualShaderNodeTexture, VisualShaderNodeTextureSDF, VisualShaderNodeTextureSDFNormal, VisualShaderNodeTransformCompose, VisualShaderNodeTransformDecompose, VisualShaderNodeTransformFunc, VisualShaderNodeTransformOp, VisualShaderNodeTransformVecMult, VisualShaderNodeUIntFunc, VisualShaderNodeUIntOp, VisualShaderNodeUVFunc, VisualShaderNodeUVPolarCoord, VisualShaderNodeVarying, VisualShaderNodeVectorBase, VisualShaderNodeWorldPositionFromDepth

Base class for VisualShader nodes. Not related to scene nodes.

## Description

Visual shader graphs consist of various nodes. Each node in the graph is a separate object and they are represented as a rectangular boxes with title and a set of properties. Each node also has connection ports that allow to connect it to another nodes and control the flow of the shader.

## Tutorials

- Using VisualShaders

## Properties

int | linked_parent_graph_frame | -1
int | output_port_for_preview | -1

## Methods

void | clear_default_input_values()
int | get_default_input_port(type: PortType) const
Array | get_default_input_values() const
Variant | get_input_port_default_value(port: int) const
void | remove_input_port_default_value(port: int)
void | set_default_input_values(values: Array)
void | set_input_port_default_value(port: int, value: Variant, prev_value: Variant = null)

---

## Enumerations

enum PortType
PortType PORT_TYPE_SCALAR = 0

Floating-point scalar. Translated to float type in shader code.

PortType PORT_TYPE_SCALAR_INT = 1

Integer scalar. Translated to int type in shader code.

PortType PORT_TYPE_SCALAR_UINT = 2

Unsigned integer scalar. Translated to uint type in shader code.

PortType PORT_TYPE_VECTOR_2D = 3

2D vector of floating-point values. Translated to vec2 type in shader code.

PortType PORT_TYPE_VECTOR_3D = 4

3D vector of floating-point values. Translated to vec3 type in shader code.

PortType PORT_TYPE_VECTOR_4D = 5

4D vector of floating-point values. Translated to vec4 type in shader code.

PortType PORT_TYPE_BOOLEAN = 6

Boolean type. Translated to bool type in shader code.

PortType PORT_TYPE_TRANSFORM = 7

Transform type. Translated to mat4 type in shader code.

PortType PORT_TYPE_SAMPLER = 8

Sampler type. Translated to reference of sampler uniform in shader code. Can only be used for input ports in non-uniform nodes.

PortType PORT_TYPE_MAX = 9

Represents the size of the PortType enum.

---

## Property Descriptions

int linked_parent_graph_frame = -1 

- void set_frame(value: int)
- int get_frame()

Represents the index of the frame this node is linked to. If set to -1 the node is not linked to any frame.

---

int output_port_for_preview = -1 

- void set_output_port_for_preview(value: int)
- int get_output_port_for_preview()

Sets the output port index which will be showed for preview. If set to -1 no port will be open for preview.

---

## Method Descriptions

void clear_default_input_values() 

Clears the default input ports value.

---

int get_default_input_port(type: PortType) const 

Returns the input port which should be connected by default when this node is created as a result of dragging a connection from an existing node to the empty space on the graph.

---

Array get_default_input_values() const 

Returns an Array containing default values for all of the input ports of the node in the form [index0, value0, index1, value1, ...].

---

Variant get_input_port_default_value(port: int) const 

Returns the default value of the input port.

---

void remove_input_port_default_value(port: int) 

Removes the default value of the input port.

---

void set_default_input_values(values: Array) 

Sets the default input ports values using an Array of the form [index0, value0, index1, value1, ...]. For example: [0, Vector3(0, 0, 0), 1, Vector3(0, 0, 0)].

---

void set_input_port_default_value(port: int, value: Variant, prev_value: Variant = null) 

Sets the default value for the selected input port.
