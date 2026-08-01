# XRFaceTracker

Experimental: This class may be changed or removed in future versions.

Inherits: XRTracker < RefCounted < Object

A tracked face.

## Description

An instance of this object represents a tracked face and its corresponding blend shapes. The blend shapes come from the Unified Expressions [https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/unified-blendshapes] standard, and contain extended details and visuals for each blend shape. Additionally the Tracking Standard Comparison [https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/compatibility/overview] page documents the relationship between Unified Expressions and other standards.

As face trackers are turned on they are registered with the XRServer.

## Tutorials

- XR documentation index

## Properties

PackedFloat32Array | blend_shapes | PackedFloat32Array()
TrackerType | type | 64 (overrides XRTracker)

## Methods

float | get_blend_shape(blend_shape: BlendShapeEntry) const
void | set_blend_shape(blend_shape: BlendShapeEntry, weight: float)

---

## Enumerations

enum BlendShapeEntry
BlendShapeEntry FT_EYE_LOOK_OUT_RIGHT = 0

Right eye looks outwards.

BlendShapeEntry FT_EYE_LOOK_IN_RIGHT = 1

Right eye looks inwards.

BlendShapeEntry FT_EYE_LOOK_UP_RIGHT = 2

Right eye looks upwards.

BlendShapeEntry FT_EYE_LOOK_DOWN_RIGHT = 3

Right eye looks downwards.

BlendShapeEntry FT_EYE_LOOK_OUT_LEFT = 4

Left eye looks outwards.

BlendShapeEntry FT_EYE_LOOK_IN_LEFT = 5

Left eye looks inwards.

BlendShapeEntry FT_EYE_LOOK_UP_LEFT = 6

Left eye looks upwards.

BlendShapeEntry FT_EYE_LOOK_DOWN_LEFT = 7

Left eye looks downwards.

BlendShapeEntry FT_EYE_CLOSED_RIGHT = 8

Closes the right eyelid.

BlendShapeEntry FT_EYE_CLOSED_LEFT = 9

Closes the left eyelid.

BlendShapeEntry FT_EYE_SQUINT_RIGHT = 10

Squeezes the right eye socket muscles.

BlendShapeEntry FT_EYE_SQUINT_LEFT = 11

Squeezes the left eye socket muscles.

BlendShapeEntry FT_EYE_WIDE_RIGHT = 12

Right eyelid widens beyond relaxed.

BlendShapeEntry FT_EYE_WIDE_LEFT = 13

Left eyelid widens beyond relaxed.

BlendShapeEntry FT_EYE_DILATION_RIGHT = 14

Dilates the right eye pupil.

BlendShapeEntry FT_EYE_DILATION_LEFT = 15

Dilates the left eye pupil.

BlendShapeEntry FT_EYE_CONSTRICT_RIGHT = 16

Constricts the right eye pupil.

BlendShapeEntry FT_EYE_CONSTRICT_LEFT = 17

Constricts the left eye pupil.

BlendShapeEntry FT_BROW_PINCH_RIGHT = 18

Right eyebrow pinches in.

BlendShapeEntry FT_BROW_PINCH_LEFT = 19

Left eyebrow pinches in.

BlendShapeEntry FT_BROW_LOWERER_RIGHT = 20

Outer right eyebrow pulls down.

BlendShapeEntry FT_BROW_LOWERER_LEFT = 21

Outer left eyebrow pulls down.

BlendShapeEntry FT_BROW_INNER_UP_RIGHT = 22

Inner right eyebrow pulls up.

BlendShapeEntry FT_BROW_INNER_UP_LEFT = 23

Inner left eyebrow pulls up.

BlendShapeEntry FT_BROW_OUTER_UP_RIGHT = 24

Outer right eyebrow pulls up.

BlendShapeEntry FT_BROW_OUTER_UP_LEFT = 25

Outer left eyebrow pulls up.

BlendShapeEntry FT_NOSE_SNEER_RIGHT = 26

Right side face sneers.

BlendShapeEntry FT_NOSE_SNEER_LEFT = 27

Left side face sneers.

BlendShapeEntry FT_NASAL_DILATION_RIGHT = 28

Right side nose canal dilates.

BlendShapeEntry FT_NASAL_DILATION_LEFT = 29

Left side nose canal dilates.

BlendShapeEntry FT_NASAL_CONSTRICT_RIGHT = 30

Right side nose canal constricts.

BlendShapeEntry FT_NASAL_CONSTRICT_LEFT = 31

Left side nose canal constricts.

BlendShapeEntry FT_CHEEK_SQUINT_RIGHT = 32

Raises the right side cheek.

BlendShapeEntry FT_CHEEK_SQUINT_LEFT = 33

Raises the left side cheek.

BlendShapeEntry FT_CHEEK_PUFF_RIGHT = 34

Puffs the right side cheek.

BlendShapeEntry FT_CHEEK_PUFF_LEFT = 35

Puffs the left side cheek.

BlendShapeEntry FT_CHEEK_SUCK_RIGHT = 36

Sucks in the right side cheek.

BlendShapeEntry FT_CHEEK_SUCK_LEFT = 37

Sucks in the left side cheek.

BlendShapeEntry FT_JAW_OPEN = 38

Opens jawbone.

BlendShapeEntry FT_MOUTH_CLOSED = 39

Closes the mouth.

BlendShapeEntry FT_JAW_RIGHT = 40

Pushes jawbone right.

BlendShapeEntry FT_JAW_LEFT = 41

Pushes jawbone left.

BlendShapeEntry FT_JAW_FORWARD = 42

Pushes jawbone forward.

BlendShapeEntry FT_JAW_BACKWARD = 43

Pushes jawbone backward.

BlendShapeEntry FT_JAW_CLENCH = 44

Flexes jaw muscles.

BlendShapeEntry FT_JAW_MANDIBLE_RAISE = 45

Raises the jawbone.

BlendShapeEntry FT_LIP_SUCK_UPPER_RIGHT = 46

Upper right lip part tucks in the mouth.

BlendShapeEntry FT_LIP_SUCK_UPPER_LEFT = 47

Upper left lip part tucks in the mouth.

BlendShapeEntry FT_LIP_SUCK_LOWER_RIGHT = 48

Lower right lip part tucks in the mouth.

BlendShapeEntry FT_LIP_SUCK_LOWER_LEFT = 49

Lower left lip part tucks in the mouth.

BlendShapeEntry FT_LIP_SUCK_CORNER_RIGHT = 50

Right lip corner folds into the mouth.

BlendShapeEntry FT_LIP_SUCK_CORNER_LEFT = 51

Left lip corner folds into the mouth.

BlendShapeEntry FT_LIP_FUNNEL_UPPER_RIGHT = 52

Upper right lip part pushes into a funnel.

BlendShapeEntry FT_LIP_FUNNEL_UPPER_LEFT = 53

Upper left lip part pushes into a funnel.

BlendShapeEntry FT_LIP_FUNNEL_LOWER_RIGHT = 54

Lower right lip part pushes into a funnel.

BlendShapeEntry FT_LIP_FUNNEL_LOWER_LEFT = 55

Lower left lip part pushes into a funnel.

BlendShapeEntry FT_LIP_PUCKER_UPPER_RIGHT = 56

Upper right lip part pushes outwards.

BlendShapeEntry FT_LIP_PUCKER_UPPER_LEFT = 57

Upper left lip part pushes outwards.

BlendShapeEntry FT_LIP_PUCKER_LOWER_RIGHT = 58

Lower right lip part pushes outwards.

BlendShapeEntry FT_LIP_PUCKER_LOWER_LEFT = 59

Lower left lip part pushes outwards.

BlendShapeEntry FT_MOUTH_UPPER_UP_RIGHT = 60

Upper right part of the lip pulls up.

BlendShapeEntry FT_MOUTH_UPPER_UP_LEFT = 61

Upper left part of the lip pulls up.

BlendShapeEntry FT_MOUTH_LOWER_DOWN_RIGHT = 62

Lower right part of the lip pulls up.

BlendShapeEntry FT_MOUTH_LOWER_DOWN_LEFT = 63

Lower left part of the lip pulls up.

BlendShapeEntry FT_MOUTH_UPPER_DEEPEN_RIGHT = 64

Upper right lip part pushes in the cheek.

BlendShapeEntry FT_MOUTH_UPPER_DEEPEN_LEFT = 65

Upper left lip part pushes in the cheek.

BlendShapeEntry FT_MOUTH_UPPER_RIGHT = 66

Moves upper lip right.

BlendShapeEntry FT_MOUTH_UPPER_LEFT = 67

Moves upper lip left.

BlendShapeEntry FT_MOUTH_LOWER_RIGHT = 68

Moves lower lip right.

BlendShapeEntry FT_MOUTH_LOWER_LEFT = 69

Moves lower lip left.

BlendShapeEntry FT_MOUTH_CORNER_PULL_RIGHT = 70

Right lip corner pulls diagonally up and out.

BlendShapeEntry FT_MOUTH_CORNER_PULL_LEFT = 71

Left lip corner pulls diagonally up and out.

BlendShapeEntry FT_MOUTH_CORNER_SLANT_RIGHT = 72

Right corner lip slants up.

BlendShapeEntry FT_MOUTH_CORNER_SLANT_LEFT = 73

Left corner lip slants up.

BlendShapeEntry FT_MOUTH_FROWN_RIGHT = 74

Right corner lip pulls down.

BlendShapeEntry FT_MOUTH_FROWN_LEFT = 75

Left corner lip pulls down.

BlendShapeEntry FT_MOUTH_STRETCH_RIGHT = 76

Mouth corner lip pulls out and down.

BlendShapeEntry FT_MOUTH_STRETCH_LEFT = 77

Mouth corner lip pulls out and down.

BlendShapeEntry FT_MOUTH_DIMPLE_RIGHT = 78

Right lip corner is pushed backwards.

BlendShapeEntry FT_MOUTH_DIMPLE_LEFT = 79

Left lip corner is pushed backwards.

BlendShapeEntry FT_MOUTH_RAISER_UPPER = 80

Raises and slightly pushes out the upper mouth.

BlendShapeEntry FT_MOUTH_RAISER_LOWER = 81

Raises and slightly pushes out the lower mouth.

BlendShapeEntry FT_MOUTH_PRESS_RIGHT = 82

Right side lips press and flatten together vertically.

BlendShapeEntry FT_MOUTH_PRESS_LEFT = 83

Left side lips press and flatten together vertically.

BlendShapeEntry FT_MOUTH_TIGHTENER_RIGHT = 84

Right side lips squeeze together horizontally.

BlendShapeEntry FT_MOUTH_TIGHTENER_LEFT = 85

Left side lips squeeze together horizontally.

BlendShapeEntry FT_TONGUE_OUT = 86

Tongue visibly sticks out of the mouth.

BlendShapeEntry FT_TONGUE_UP = 87

Tongue points upwards.

BlendShapeEntry FT_TONGUE_DOWN = 88

Tongue points downwards.

BlendShapeEntry FT_TONGUE_RIGHT = 89

Tongue points right.

BlendShapeEntry FT_TONGUE_LEFT = 90

Tongue points left.

BlendShapeEntry FT_TONGUE_ROLL = 91

Sides of the tongue funnel, creating a roll.

BlendShapeEntry FT_TONGUE_BLEND_DOWN = 92

Tongue arches up then down inside the mouth.

BlendShapeEntry FT_TONGUE_CURL_UP = 93

Tongue arches down then up inside the mouth.

BlendShapeEntry FT_TONGUE_SQUISH = 94

Tongue squishes together and thickens.

BlendShapeEntry FT_TONGUE_FLAT = 95

Tongue flattens and thins out.

BlendShapeEntry FT_TONGUE_TWIST_RIGHT = 96

Tongue tip rotates clockwise, with the rest following gradually.

BlendShapeEntry FT_TONGUE_TWIST_LEFT = 97

Tongue tip rotates counter-clockwise, with the rest following gradually.

BlendShapeEntry FT_SOFT_PALATE_CLOSE = 98

Inner mouth throat closes.

BlendShapeEntry FT_THROAT_SWALLOW = 99

The Adam's apple visibly swallows.

BlendShapeEntry FT_NECK_FLEX_RIGHT = 100

Right side neck visibly flexes.

BlendShapeEntry FT_NECK_FLEX_LEFT = 101

Left side neck visibly flexes.

BlendShapeEntry FT_EYE_CLOSED = 102

Closes both eye lids.

BlendShapeEntry FT_EYE_WIDE = 103

Widens both eye lids.

BlendShapeEntry FT_EYE_SQUINT = 104

Squints both eye lids.

BlendShapeEntry FT_EYE_DILATION = 105

Dilates both pupils.

BlendShapeEntry FT_EYE_CONSTRICT = 106

Constricts both pupils.

BlendShapeEntry FT_BROW_DOWN_RIGHT = 107

Pulls the right eyebrow down and in.

BlendShapeEntry FT_BROW_DOWN_LEFT = 108

Pulls the left eyebrow down and in.

BlendShapeEntry FT_BROW_DOWN = 109

Pulls both eyebrows down and in.

BlendShapeEntry FT_BROW_UP_RIGHT = 110

Right brow appears worried.

BlendShapeEntry FT_BROW_UP_LEFT = 111

Left brow appears worried.

BlendShapeEntry FT_BROW_UP = 112

Both brows appear worried.

BlendShapeEntry FT_NOSE_SNEER = 113

Entire face sneers.

BlendShapeEntry FT_NASAL_DILATION = 114

Both nose canals dilate.

BlendShapeEntry FT_NASAL_CONSTRICT = 115

Both nose canals constrict.

BlendShapeEntry FT_CHEEK_PUFF = 116

Puffs both cheeks.

BlendShapeEntry FT_CHEEK_SUCK = 117

Sucks in both cheeks.

BlendShapeEntry FT_CHEEK_SQUINT = 118

Raises both cheeks.

BlendShapeEntry FT_LIP_SUCK_UPPER = 119

Tucks in the upper lips.

BlendShapeEntry FT_LIP_SUCK_LOWER = 120

Tucks in the lower lips.

BlendShapeEntry FT_LIP_SUCK = 121

Tucks in both lips.

BlendShapeEntry FT_LIP_FUNNEL_UPPER = 122

Funnels in the upper lips.

BlendShapeEntry FT_LIP_FUNNEL_LOWER = 123

Funnels in the lower lips.

BlendShapeEntry FT_LIP_FUNNEL = 124

Funnels in both lips.

BlendShapeEntry FT_LIP_PUCKER_UPPER = 125

Upper lip part pushes outwards.

BlendShapeEntry FT_LIP_PUCKER_LOWER = 126

Lower lip part pushes outwards.

BlendShapeEntry FT_LIP_PUCKER = 127

Lips push outwards.

BlendShapeEntry FT_MOUTH_UPPER_UP = 128

Raises the upper lips.

BlendShapeEntry FT_MOUTH_LOWER_DOWN = 129

Lowers the lower lips.

BlendShapeEntry FT_MOUTH_OPEN = 130

Mouth opens, revealing teeth.

BlendShapeEntry FT_MOUTH_RIGHT = 131

Moves mouth right.

BlendShapeEntry FT_MOUTH_LEFT = 132

Moves mouth left.

BlendShapeEntry FT_MOUTH_SMILE_RIGHT = 133

Right side of the mouth smiles.

BlendShapeEntry FT_MOUTH_SMILE_LEFT = 134

Left side of the mouth smiles.

BlendShapeEntry FT_MOUTH_SMILE = 135

Mouth expresses a smile.

BlendShapeEntry FT_MOUTH_SAD_RIGHT = 136

Right side of the mouth expresses sadness.

BlendShapeEntry FT_MOUTH_SAD_LEFT = 137

Left side of the mouth expresses sadness.

BlendShapeEntry FT_MOUTH_SAD = 138

Mouth expresses sadness.

BlendShapeEntry FT_MOUTH_STRETCH = 139

Mouth stretches.

BlendShapeEntry FT_MOUTH_DIMPLE = 140

Lip corners dimple.

BlendShapeEntry FT_MOUTH_TIGHTENER = 141

Mouth tightens.

BlendShapeEntry FT_MOUTH_PRESS = 142

Mouth presses together.

BlendShapeEntry FT_MAX = 143

Represents the size of the BlendShapeEntry enum.

---

## Property Descriptions

PackedFloat32Array blend_shapes = PackedFloat32Array() 

- void set_blend_shapes(value: PackedFloat32Array)
- PackedFloat32Array get_blend_shapes()

The array of face blend shape weights with indices corresponding to the BlendShapeEntry enum.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

## Method Descriptions

float get_blend_shape(blend_shape: BlendShapeEntry) const 

Returns the requested face blend shape weight.

---

void set_blend_shape(blend_shape: BlendShapeEntry, weight: float) 

Sets a face blend shape weight.
