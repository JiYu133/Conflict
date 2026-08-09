# Texture Organization

Textures are grouped by usage first and by texture role where the role is known:

- `models/` contains model-specific texture sets.
- `materials/normal_maps/` contains reusable normal maps.
- `materials/pbr/` contains reusable PBR texture sets.
- `effects/noise/` contains noise textures used by shaders and visual effects.
- `ui/` contains interface textures such as key icons.
- `effects/blood/` is reserved for authored blood-pool and blood-drop textures used by
  `DeathBloodEffect`. These must be imported art assets with alpha; the effect code does
  not synthesize replacement textures.
- `effects/blood/` is reserved for authored blood-pool and blood-drop textures used by
  `DeathBloodEffect`. These must be imported art assets with alpha; the effect code does
  not synthesize replacement textures.

Textures that are external sidecars of an FBX or GLB remain beside their source model. Moving those files independently can break the model importer. New standalone textures should use the categorized folders above.
