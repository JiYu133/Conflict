# JNISingleton

Inherits: Object

Singleton that connects the engine with Android plugins to interface with native Android code.

## Description

The JNISingleton is implemented only in the Android export. It's used to call methods and connect signals from an Android plugin written in Java or Kotlin. Methods and signals can be called and connected to the JNISingleton as if it is a Node. See Java Native Interface - Wikipedia [https://en.wikipedia.org/wiki/Java_Native_Interface] for more information.

## Tutorials

- Creating Android plugins

## Methods

bool | has_java_method(method: StringName) const

---

## Method Descriptions

bool has_java_method(method: StringName) const 

Returns true if the given method name exists in the JNISingleton's Java methods.
