# RefCounted

Inherits: Object

Inherited By: AESContext, AStar2D, AStar3D, AStarGrid2D, AudioEffectInstance, AudioSample, AudioSamplePlayback, AudioStreamPlayback, CameraFeed, CharFXTransform, ConfigFile, Crypto, DirAccess, DTLSServer, EditorContextMenuPlugin, EditorDebuggerPlugin, EditorDebuggerSession, EditorExportPlatform, EditorExportPlugin, EditorExportPreset, EditorFeatureProfile, EditorFileSystemImportFormatSupportQuery, EditorInspectorPlugin, EditorResourceConversionPlugin, EditorResourcePreviewGenerator, EditorResourceTooltipPlugin, EditorSceneFormatImporter, EditorScenePostImport, EditorScenePostImportPlugin, EditorScript, EditorTranslationParserPlugin, EncodedObjectAsID, ENetConnection, EngineProfiler, Expression, FileAccess, GDScriptTextDocument, GDScriptWorkspace, GLTFObjectModelProperty, HashingContext, HMACContext, HTTPClient, ImageFormatLoader, JavaClass, JavaObject, JavaScriptObject, KinematicCollision2D, KinematicCollision3D, Lightmapper, Logger, MeshConvexDecompositionSettings, MeshDataTool, MultiplayerAPI, Mutex, NavigationPathQueryParameters2D, NavigationPathQueryParameters3D, NavigationPathQueryResult2D, NavigationPathQueryResult3D, Node3DGizmo, OggPacketSequencePlayback, OpenXRAPIExtension, OpenXRFutureResult, OpenXRSpatialCapabilityConfigurationBaseHeader, OpenXRSpatialComponentData, OpenXRStructureBase, PackedDataContainerRef, PacketPeer, PCKPacker, PhysicsPointQueryParameters2D, PhysicsPointQueryParameters3D, PhysicsRayQueryParameters2D, PhysicsRayQueryParameters3D, PhysicsShapeQueryParameters2D, PhysicsShapeQueryParameters3D, PhysicsTestMotionParameters2D, PhysicsTestMotionParameters3D, PhysicsTestMotionResult2D, PhysicsTestMotionResult3D, RandomNumberGenerator, RDAccelerationStructureGeometry, RDAccelerationStructureInstance, RDAttachmentFormat, RDFramebufferPass, RDHitGroup, RDPipelineColorBlendState, RDPipelineColorBlendStateAttachment, RDPipelineDepthStencilState, RDPipelineMultisampleState, RDPipelineRasterizationState, RDPipelineShader, RDPipelineSpecializationConstant, RDSamplerState, RDShaderSource, RDTextureFormat, RDTextureView, RDUniform, RDVertexAttribute, RegEx, RegExMatch, RenderSceneBuffers, RenderSceneBuffersConfiguration, Resource, ResourceFormatLoader, ResourceFormatSaver, ResourceImporter, SceneState, SceneTreeTimer, ScriptBacktrace, Semaphore, SkinReference, SocketServer, StreamPeer, SurfaceTool, TextLine, TextParagraph, TextServer, Thread, TLSOptions, TranslationDomain, TriangleMesh, Tween, Tweener, UDPServer, UPNP, UPNPDevice, WeakRef, WebRTCPeerConnection, XMLParser, XRInterface, XRPose, XRTracker, ZIPPacker, ZIPReader

Base class for reference-counted objects.

## Description

Base class for any object that keeps a reference count. Resource and many other helper objects inherit this class.

Unlike other Object types, RefCounteds keep an internal reference counter so that they are automatically released when no longer in use, and only then. RefCounteds therefore do not need to be freed manually with Object.free().

RefCounted instances caught in a cyclic reference will not be freed automatically. For example, if a node holds a reference to instance A, which directly or indirectly holds a reference back to A, A's reference count will be 2. Destruction of the node will leave A dangling with a reference count of 1, and there will be a memory leak. To prevent this, one of the references in the cycle can be made weak with @GlobalScope.weakref().

In the vast majority of use cases, instantiating and using RefCounted-derived types is all you need to do. The methods provided in this class are only for advanced users, and can cause issues if misused.

Note: In C#, reference-counted objects will not be freed instantly after they are no longer in use. Instead, garbage collection will run periodically and will free reference-counted objects that are no longer in use. This means that unused ones will remain in memory for a while before being removed.

## Tutorials

- When and how to avoid using nodes for everything

## Methods

int | get_reference_count() const
bool | init_ref()
bool | reference()
bool | unreference()

---

## Method Descriptions

int get_reference_count() const 

Returns the current reference count.

---

bool init_ref() 

Initializes the internal reference counter. Use this only if you really know what you are doing.

Returns whether the initialization was successful.

---

bool reference() 

Increments the internal reference counter. Use this only if you really know what you are doing.

Returns true if the increment was successful, false otherwise.

---

bool unreference() 

Decrements the internal reference counter. Use this only if you really know what you are doing.

Returns true if the object should be freed after the decrement, false otherwise.
