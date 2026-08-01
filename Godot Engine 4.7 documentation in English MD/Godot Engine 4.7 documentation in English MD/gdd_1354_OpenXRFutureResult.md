# OpenXRFutureResult

Inherits: RefCounted < Object

Result object tracking the asynchronous result of an OpenXR Future object.

## Description

Result object tracking the asynchronous result of an OpenXR Future object, you can use this object to track the result status.

## Methods

void | cancel_future()
int | get_future() const
Variant | get_result_value() const
ResultStatus | get_status() const
void | set_result_value(result_value: Variant)

---

## Signals

completed(result: OpenXRFutureResult) 

Emitted when the asynchronous function is finished or has been cancelled.

---

## Enumerations

enum ResultStatus
ResultStatus RESULT_RUNNING = 0

The asynchronous function is running.

ResultStatus RESULT_FINISHED = 1

The asynchronous function has finished.

ResultStatus RESULT_CANCELLED = 2

The asynchronous function has been cancelled.

---

## Method Descriptions

void cancel_future() 

Cancel this future, this will interrupt and stop the asynchronous function.

---

int get_future() const 

Return the XrFutureEXT value this result relates to.

---

Variant get_result_value() const 

Returns the result value of our asynchronous function (if set by the extension). The type of this result value depends on the function being called. Consult the documentation of the relevant function.

---

ResultStatus get_status() const 

Returns the status of this result.

---

void set_result_value(result_value: Variant) 

Stores the result value we expose to the user.

Note: This method should only be called by an OpenXR extension that implements an asynchronous function.
