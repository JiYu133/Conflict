# FastNoiseLite

Inherits: Noise < Resource < RefCounted < Object

Generates noise using the FastNoiseLite library.

## Description

This class generates noise using the FastNoiseLite library, which is a collection of several noise algorithms including Cellular, Perlin, Value, and more.

Most generated noise values are in the range of [-1, 1], but not always. Some of the cellular noise algorithms return results above 1.

## Properties

CellularDistanceFunction | cellular_distance_function | 0
float | cellular_jitter | 1.0
CellularReturnType | cellular_return_type | 1
float | domain_warp_amplitude | 30.0
bool | domain_warp_enabled | false
float | domain_warp_fractal_gain | 0.5
float | domain_warp_fractal_lacunarity | 6.0
int | domain_warp_fractal_octaves | 5
DomainWarpFractalType | domain_warp_fractal_type | 1
float | domain_warp_frequency | 0.05
DomainWarpType | domain_warp_type | 0
float | fractal_gain | 0.5
float | fractal_lacunarity | 2.0
int | fractal_octaves | 5
float | fractal_ping_pong_strength | 2.0
FractalType | fractal_type | 1
float | fractal_weighted_strength | 0.0
float | frequency | 0.01
NoiseType | noise_type | 1
Vector3 | offset | Vector3(0, 0, 0)
int | seed | 0

---

## Enumerations

enum NoiseType
NoiseType TYPE_VALUE = 5

A lattice of points are assigned random values then interpolated based on neighboring values.

NoiseType TYPE_VALUE_CUBIC = 4

Similar to value noise (TYPE_VALUE), but slower. Has more variance in peaks and valleys.

Cubic noise can be used to avoid certain artifacts when using value noise to create a bumpmap. In general, you should always use this mode if the value noise is being used for a heightmap or bumpmap.

NoiseType TYPE_PERLIN = 3

A lattice of random gradients. Their dot products are interpolated to obtain values in between the lattices.

NoiseType TYPE_CELLULAR = 2

Cellular includes both Worley noise and Voronoi diagrams which creates various regions of the same value.

NoiseType TYPE_SIMPLEX = 0

As opposed to TYPE_PERLIN, gradients exist in a simplex lattice rather than a grid lattice, avoiding directional artifacts. Internally uses FastNoiseLite's OpenSimplex2 noise type.

NoiseType TYPE_SIMPLEX_SMOOTH = 1

Modified, higher quality version of TYPE_SIMPLEX, but slower. Internally uses FastNoiseLite's OpenSimplex2S noise type.

---

enum FractalType
FractalType FRACTAL_NONE = 0

No fractal noise.

FractalType FRACTAL_FBM = 1

Method using Fractional Brownian Motion to combine octaves into a fractal.

FractalType FRACTAL_RIDGED = 2

Method of combining octaves into a fractal resulting in a "ridged" look.

FractalType FRACTAL_PING_PONG = 3

Method of combining octaves into a fractal with a ping pong effect.

---

enum CellularDistanceFunction
CellularDistanceFunction DISTANCE_EUCLIDEAN = 0

Euclidean distance to the nearest point.

CellularDistanceFunction DISTANCE_EUCLIDEAN_SQUARED = 1

Squared Euclidean distance to the nearest point.

CellularDistanceFunction DISTANCE_MANHATTAN = 2

Manhattan distance (taxicab metric) to the nearest point.

CellularDistanceFunction DISTANCE_HYBRID = 3

Blend of DISTANCE_EUCLIDEAN and DISTANCE_MANHATTAN to give curved cell boundaries.

---

enum CellularReturnType
CellularReturnType RETURN_CELL_VALUE = 0

The cellular distance function will return the same value for all points within a cell.

CellularReturnType RETURN_DISTANCE = 1

The cellular distance function will return a value determined by the distance to the nearest point.

CellularReturnType RETURN_DISTANCE2 = 2

The cellular distance function returns the distance to the second-nearest point.

CellularReturnType RETURN_DISTANCE2_ADD = 3

The distance to the nearest point is added to the distance to the second-nearest point.

CellularReturnType RETURN_DISTANCE2_SUB = 4

The distance to the nearest point is subtracted from the distance to the second-nearest point.

CellularReturnType RETURN_DISTANCE2_MUL = 5

The distance to the nearest point is multiplied with the distance to the second-nearest point.

CellularReturnType RETURN_DISTANCE2_DIV = 6

The distance to the nearest point is divided by the distance to the second-nearest point.

---

enum DomainWarpType
DomainWarpType DOMAIN_WARP_SIMPLEX = 0

The domain is warped using the simplex noise algorithm.

DomainWarpType DOMAIN_WARP_SIMPLEX_REDUCED = 1

The domain is warped using a simplified version of the simplex noise algorithm.

DomainWarpType DOMAIN_WARP_BASIC_GRID = 2

The domain is warped using a simple noise grid (not as smooth as the other methods, but more performant).

---

enum DomainWarpFractalType
DomainWarpFractalType DOMAIN_WARP_FRACTAL_NONE = 0

No fractal noise for warping the space.

DomainWarpFractalType DOMAIN_WARP_FRACTAL_PROGRESSIVE = 1

Warping the space progressively, octave for octave, resulting in a more "liquified" distortion.

DomainWarpFractalType DOMAIN_WARP_FRACTAL_INDEPENDENT = 2

Warping the space independently for each octave, resulting in a more chaotic distortion.

---

## Property Descriptions

CellularDistanceFunction cellular_distance_function = 0 

- void set_cellular_distance_function(value: CellularDistanceFunction)
- CellularDistanceFunction get_cellular_distance_function()

Determines how the distance to the nearest/second-nearest point is computed.

---

float cellular_jitter = 1.0 

- void set_cellular_jitter(value: float)
- float get_cellular_jitter()

Maximum distance a point can move off of its grid position. Set to 0 for an even grid.

---

CellularReturnType cellular_return_type = 1 

- void set_cellular_return_type(value: CellularReturnType)
- CellularReturnType get_cellular_return_type()

Return type from cellular noise calculations.

---

float domain_warp_amplitude = 30.0 

- void set_domain_warp_amplitude(value: float)
- float get_domain_warp_amplitude()

Sets the maximum warp distance from the origin.

---

bool domain_warp_enabled = false 

- void set_domain_warp_enabled(value: bool)
- bool is_domain_warp_enabled()

If enabled, another FastNoiseLite instance is used to warp the space, resulting in a distortion of the noise.

---

float domain_warp_fractal_gain = 0.5 

- void set_domain_warp_fractal_gain(value: float)
- float get_domain_warp_fractal_gain()

Determines the strength of each subsequent layer of the noise which is used to warp the space.

A low value places more emphasis on the lower frequency base layers, while a high value puts more emphasis on the higher frequency layers.

---

float domain_warp_fractal_lacunarity = 6.0 

- void set_domain_warp_fractal_lacunarity(value: float)
- float get_domain_warp_fractal_lacunarity()

The change in frequency between octaves, also known as "lacunarity", of the fractal noise which warps the space. Increasing this value results in higher octaves, producing noise with finer details and a rougher appearance.

---

int domain_warp_fractal_octaves = 5 

- void set_domain_warp_fractal_octaves(value: int)
- int get_domain_warp_fractal_octaves()

The number of noise layers that are sampled to get the final value for the fractal noise which warps the space.

---

DomainWarpFractalType domain_warp_fractal_type = 1 

- void set_domain_warp_fractal_type(value: DomainWarpFractalType)
- DomainWarpFractalType get_domain_warp_fractal_type()

The method for combining octaves into a fractal which is used to warp the space.

---

float domain_warp_frequency = 0.05 

- void set_domain_warp_frequency(value: float)
- float get_domain_warp_frequency()

Frequency of the noise which warps the space. Low frequency results in smooth noise while high frequency results in rougher, more granular noise.

---

DomainWarpType domain_warp_type = 0 

- void set_domain_warp_type(value: DomainWarpType)
- DomainWarpType get_domain_warp_type()

The warp algorithm.

---

float fractal_gain = 0.5 

- void set_fractal_gain(value: float)
- float get_fractal_gain()

Determines the strength of each subsequent layer of noise in fractal noise.

A low value places more emphasis on the lower frequency base layers, while a high value puts more emphasis on the higher frequency layers.

---

float fractal_lacunarity = 2.0 

- void set_fractal_lacunarity(value: float)
- float get_fractal_lacunarity()

Frequency multiplier between subsequent octaves. Increasing this value results in higher octaves producing noise with finer details and a rougher appearance.

---

int fractal_octaves = 5 

- void set_fractal_octaves(value: int)
- int get_fractal_octaves()

The number of noise layers that are sampled to get the final value for fractal noise types.

---

float fractal_ping_pong_strength = 2.0 

- void set_fractal_ping_pong_strength(value: float)
- float get_fractal_ping_pong_strength()

Sets the strength of the fractal ping pong type.

---

FractalType fractal_type = 1 

- void set_fractal_type(value: FractalType)
- FractalType get_fractal_type()

The method for combining octaves into a fractal.

---

float fractal_weighted_strength = 0.0 

- void set_fractal_weighted_strength(value: float)
- float get_fractal_weighted_strength()

Higher weighting means higher octaves have less impact if lower octaves have a large impact.

---

float frequency = 0.01 

- void set_frequency(value: float)
- float get_frequency()

The frequency for all noise types. Low frequency results in smooth noise while high frequency results in rougher, more granular noise.

---

NoiseType noise_type = 1 

- void set_noise_type(value: NoiseType)
- NoiseType get_noise_type()

The noise algorithm used.

---

Vector3 offset = Vector3(0, 0, 0) 

- void set_offset(value: Vector3)
- Vector3 get_offset()

Translate the noise input coordinates by the given Vector3.

---

int seed = 0 

- void set_seed(value: int)
- int get_seed()

The random number seed for all noise types.
