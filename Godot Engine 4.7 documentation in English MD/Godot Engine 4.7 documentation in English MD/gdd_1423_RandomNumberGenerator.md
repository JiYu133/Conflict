# RandomNumberGenerator

Inherits: RefCounted < Object

Provides methods for generating pseudo-random numbers.

## Description

RandomNumberGenerator is a class for generating pseudo-random numbers. It currently uses PCG32 [https://www.pcg-random.org/].

Note: The underlying algorithm is an implementation detail and should not be depended upon.

To generate a random float number (within a given range) based on a time-dependent seed:

```gdscript
var rng = RandomNumberGenerator.new()
func _ready():
    var my_random_number = rng.randf_range(-10.0, 10.0)
```

## Tutorials

- Random number generation

## Properties

int | seed | 0
int | state | 0

## Methods

int | rand_weighted(weights: PackedFloat32Array)
float | randf()
float | randf_range(from: float, to: float)
float | randfn(mean: float = 0.0, deviation: float = 1.0)
int | randi()
int | randi_range(from: int, to: int)
void | randomize()

---

## Property Descriptions

int seed = 0 

- void set_seed(value: int)
- int get_seed()

Initializes the random number generator state based on the given seed value. A given seed will give a reproducible sequence of pseudo-random numbers.

Note: The RNG does not have an avalanche effect, and can output similar random streams given similar seeds. Consider using a hash function to improve your seed quality if they're sourced externally.

Note: The default value of this property is pseudo-random, and changes when calling randomize(). The 0 value documented here is a placeholder, and not the actual default seed.

Note: Setting this property produces a side effect of changing the internal state, so make sure to initialize the seed before modifying the state:

```gdscript
var rng = RandomNumberGenerator.new()
rng.seed = hash("Godot")
rng.state = 100 # Restore to some previously saved state.
```

---

int state = 0 

- void set_state(value: int)
- int get_state()

The current state of the random number generator. Save and restore this property to restore the generator to a previous state:

```gdscript
var rng = RandomNumberGenerator.new()
print(rng.randf())
var saved_state = rng.state # Store current state.
print(rng.randf()) # Advance internal state.
rng.state = saved_state # Restore the state.
print(rng.randf()) # Prints the same value as previously.
```

Note: Do not set state to arbitrary values, since the random number generator requires the state to have certain qualities to behave properly. It should only be set to values that came from the state property itself. To initialize the random number generator with arbitrary input, use seed instead.

Note: The default value of this property is pseudo-random, and changes when calling randomize(). The 0 value documented here is a placeholder, and not the actual default state.

---

## Method Descriptions

int rand_weighted(weights: PackedFloat32Array) 

Returns a random integer between 0 and the size of the array that is passed as a parameter. Each value in the array should be a floating-point number that represents the relative likelihood that it will be returned as an index. A higher value means the value is more likely to be returned as an index, while a value of 0 means it will never be returned as an index.

For example, if [0.5, 1, 1, 2] is passed as a parameter, then the method is twice as likely to return 3 (the index of the value 2) and twice as unlikely to return 0 (the index of the value 0.5) compared to the indices 1 and 2.

Prints an error and returns -1 if the array is empty.

```
var rng = RandomNumberGenerator.new()
var my_array = ["one", "two", "three", "four"]
var weights = PackedFloat32Array([0.5, 1, 1, 2])
# Prints one of the four elements in `my_array`.
# It is more likely to print "four", and less likely to print "one".
print(my_array[rng.rand_weighted(weights)])
```

---

float randf() 

Returns a pseudo-random float between 0.0 and 1.0 (inclusive).

---

float randf_range(from: float, to: float) 

Returns a pseudo-random float between from and to (inclusive).

---

float randfn(mean: float = 0.0, deviation: float = 1.0) 

Returns a normally-distributed [https://en.wikipedia.org/wiki/Normal_distribution], pseudo-random floating-point number from the specified mean and a standard deviation. This is also known as a Gaussian distribution.

Note: This method uses the Box-Muller transform [https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform] algorithm.

---

int randi() 

Returns a pseudo-random 32-bit unsigned integer between 0 and 4294967295 (inclusive).

---

int randi_range(from: int, to: int) 

Returns a pseudo-random 32-bit signed integer between from and to (inclusive).

---

void randomize() 

Sets up a time-based seed for this RandomNumberGenerator instance. Unlike the @GlobalScope random number generation functions, different RandomNumberGenerator instances can use different seeds.
