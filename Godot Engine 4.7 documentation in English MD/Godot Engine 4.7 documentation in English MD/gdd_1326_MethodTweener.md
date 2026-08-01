# MethodTweener

Inherits: Tweener < RefCounted < Object

Interpolates an abstract value and supplies it to a method called over time.

## Description

MethodTweener is similar to a combination of CallbackTweener and PropertyTweener. It calls a method providing an interpolated value as a parameter. See Tween.tween_method() for more usage information.

The tweener will finish automatically if the callback's target object is freed.

Note: Tween.tween_method() is the only correct way to create MethodTweener. Any MethodTweener created manually will not function correctly.

## Methods

MethodTweener | set_delay(delay: float)
MethodTweener | set_ease(ease: EaseType)
MethodTweener | set_trans(trans: TransitionType)

---

## Method Descriptions

MethodTweener set_delay(delay: float) 

Sets the time in seconds after which the MethodTweener will start interpolating. By default there's no delay.

---

MethodTweener set_ease(ease: EaseType) 

Sets the type of used easing from EaseType. If not set, the default easing is used from the Tween that contains this Tweener.

---

MethodTweener set_trans(trans: TransitionType) 

Sets the type of used transition from TransitionType. If not set, the default transition is used from the Tween that contains this Tweener.
