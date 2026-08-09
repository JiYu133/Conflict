# OpenXRAndroidThreadSettingsExtension

Inherits: OpenXRExtensionWrapper < Object

Wraps the XR_KHR_android_thread_settings [https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_KHR_android_thread_settings] extension.

## Description

For XR to be comfortable, it is important for applications to deliver frames quickly and consistently. In order to make sure the important application threads get their full share of time, these threads must be identified to the system, which will adjust their scheduling priority accordingly.

## Methods

bool | set_application_thread_type(thread_type: ThreadType, thread_id: int = 0)

---

## Enumerations

enum ThreadType
ThreadType THREAD_TYPE_APPLICATION_MAIN = 0

Hints to the XR runtime that the thread is doing time critical CPU tasks.

ThreadType THREAD_TYPE_APPLICATION_WORKER = 1

Hints to the XR runtime that the thread is doing background CPU tasks.

ThreadType THREAD_TYPE_RENDERER_MAIN = 2

Hints to the XR runtime that the thread is doing time critical graphics device tasks.

ThreadType THREAD_TYPE_RENDERER_WORKER = 3

Hints to the XR runtime that the thread is doing background graphics device tasks.

---

## Method Descriptions

bool set_application_thread_type(thread_type: ThreadType, thread_id: int = 0) 

Sets the thread type of the given thread, so that the XR runtime can adjust its scheduling priority accordingly.

thread_id refers to the OS thread id (ie from gettid()). When thread_id is 0, it will set the thread type of the current thread.

NOTE: The id returned by Thread.get_id() is incompatible with thread_id.
