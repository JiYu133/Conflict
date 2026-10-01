# DeathBloodEffect

`DeathBloodEffect` is a presentation-only component for the post-death external bleeding effect.

## Flow

```text
BasePlayer.died + injected bleed-origin Callable
            ↓
      DeathBloodEffect
            ↓
  ground RayCast3D → Decal pool Tween
                    → GPUParticles3D drips
BasePlayer.revived → stop the current drip cycle
```

The component does not traverse or mutate `HealthSystem`, wounds, blood volume, or the skeleton.
`BasePlayer` injects `HealthSystem.get_major_external_bleed_world_position` as a read-only
`Callable`; without it, the effect falls back to the player origin.

Persistent pools are parented to the scene world, not to the movable wound emitter. Moving the
emitter for a later death therefore cannot drag old blood pools to a new position. Pools are
removed only by `clear_blood`, disabling blood effects, or destruction of their player owner.

## Art resources

Assign two authored alpha textures in `BloodEffectConfig`:

- `blood_pool_texture`: irregular top-down pool/decal texture.
- `blood_drop_texture`: single drop/splash texture for particles.

The repository intentionally does not provide procedural fallback art. If either texture is
missing, only that visual layer is disabled and the gameplay/medical flow continues normally.

The default configuration is `assets/config/medic/blood_effect_config_default.tres`.

## Atlas policy

Both `CombatEffects` and `DeathBloodEffect` use `DecalAtlasCache`. The shared preparation clears
mipmaps and transparent RGB; floor-pool cells also remove the source atlas's low-alpha black haze.
Do not add a second atlas crop path inside an effect component, because that previously allowed
the rectangular black background to return through ordinary bleeding while death pools looked correct.
