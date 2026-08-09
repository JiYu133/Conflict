# ResourceImporterBitMap

Inherits: ResourceImporter < RefCounted < Object

Imports a BitMap resource (2D array of boolean values).

## Description

BitMap resources are typically used as click masks in TextureButton and TouchScreenButton.

## Tutorials

- Importing images

## Properties

int | create_from | 0
float | threshold | 0.5

---

## Property Descriptions

int create_from = 0 

The data source to use for generating the bitmap.

Black & White: Pixels whose HSV value is greater than the threshold will be considered as "enabled" (bit is true). If the pixel is lower than or equal to the threshold, it will be considered as "disabled" (bit is false).

Alpha: Pixels whose alpha value is greater than the threshold will be considered as "enabled" (bit is true). If the pixel is lower than or equal to the threshold, it will be considered as "disabled" (bit is false).

---

float threshold = 0.5 

The threshold to use to determine which bits should be considered enabled or disabled. See also create_from.
