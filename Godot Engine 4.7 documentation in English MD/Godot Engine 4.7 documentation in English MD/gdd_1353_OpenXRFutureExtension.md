# OpenXRFutureExtension

Inherits: OpenXRExtensionWrapper < Object

The OpenXR Future extension allows for asynchronous APIs to be used.

## Description

This is a support extension in OpenXR that allows other OpenXR extensions to start asynchronous functions and get a callback after this function finishes. It is not intended for consumption within GDScript but can be accessed from GDExtension.

## Methods

void | cancel_future(future: int)
bool | is_active() const
OpenXRFutureResult | register_future(future: int, on_success: Callable = Callable())

---

## Method Descriptions

void cancel_future(future: int) 

Cancels an in-progress future. future must be an XrFutureEXT value previously returned by an API that started an asynchronous function.

---

bool is_active() const 

Returns true if futures are available in the OpenXR runtime used. This function will only return a usable result after OpenXR has been initialized.

---

OpenXRFutureResult register_future(future: int, on_success: Callable = Callable()) 

Register an OpenXR Future object so we monitor for completion. future must be an XrFutureEXT value previously returned by an API that started an asynchronous function.

You can optionally specify on_success, it will be invoked on successful completion of the future.

Or you can use the returned OpenXRFutureResult object to await its OpenXRFutureResult.completed signal.

```gdscript
var future_result = OpenXRFutureExtension.register_future(future)
await future_result.completed
if future_result.get_status() == OpenXRFutureResult.RESULT_FINISHED:
    # Handle your success
    pass
```
