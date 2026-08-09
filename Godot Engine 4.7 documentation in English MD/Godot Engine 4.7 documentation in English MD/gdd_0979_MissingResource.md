# MissingResource

Inherits: Resource < RefCounted < Object

An internal editor class intended for keeping the data of unrecognized resources.

## Description

This is an internal editor class intended for keeping data of resources of unknown type (most likely this type was supplied by an extension that is no longer loaded). It can't be manually instantiated or placed in a scene.

Warning: Ignore missing resources unless you know what you are doing. Existing properties on a missing resource can be freely modified in code, regardless of the type they are intended to be.

## Properties

String | original_class
bool | recording_properties

---

## Property Descriptions

String original_class 

- void set_original_class(value: String)
- String get_original_class()

The name of the class this resource was supposed to be (see Object.get_class()).

---

bool recording_properties 

- void set_recording_properties(value: bool)
- bool is_recording_properties()

If set to true, allows new properties to be added on top of the existing ones with Object.set().
