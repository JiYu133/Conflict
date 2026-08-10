# DeathBloodEffect

`DeathBloodEffect` is a presentation-only component for the post-death external bleeding effect.

## Flow

```text
HealthSystem.medically_died / BasePlayer.died
            ↓
      DeathBloodEffect
            ↓
  ground RayCast3D → Decal pool Tween
                    → GPUParticles3D drips
BasePlayer.revived → clear pool and stop drips
```

The component does not read or mutate wounds, blood volume, or medical state. It is created by
`BasePlayer` and reads `PlayerConfig.blood_effect_config`.

## Art resources

Assign two authored alpha textures in `BloodEffectConfig`:

- `blood_pool_texture`: irregular top-down pool/decal texture.
- `blood_drop_texture`: single drop/splash texture for particles.

The repository intentionally does not provide procedural fallback art. If either texture is
missing, only that visual layer is disabled and the gameplay/medical flow continues normally.

The default configuration is `assets/config/medic/blood_effect_config_default.tres`.
