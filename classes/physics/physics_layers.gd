class_name PhysicsLayers
extends RefCounted

## Shared 3D physics-layer bits used by systems that must explicitly ignore
## each other. Keep these values aligned with project.godot layer names.

const NONE := 0
const WORLD := 1 << 0
const CHARACTER := 1 << 1
const DROPPED_WEAPON := 1 << 2
const SHELL_CASING := 1 << 3

const BALLISTIC_TARGETS := WORLD | CHARACTER
const WEAPON_OBSTRUCTION := WORLD | CHARACTER
const DROPPED_WEAPON_MASK := WORLD | CHARACTER | DROPPED_WEAPON
const RAGDOLL_DEFAULT_MASK := WORLD | CHARACTER | DROPPED_WEAPON
