# VisualShaderNodeColorOp

Inherits: VisualShaderNode < Resource < RefCounted < Object

A Color operator to be used within the visual shader graph.

## Description

Applies operator to two color inputs.

## Properties

Operator | operator | 0

---

## Enumerations

enum Operator
Operator OP_SCREEN = 0

Produce a screen effect with the following formula:

```gdscript
result = vec3(1.0) - (vec3(1.0) - a) * (vec3(1.0) - b);
```

Operator OP_DIFFERENCE = 1

Produce a difference effect with the following formula:

```gdscript
result = abs(a - b);
```

Operator OP_DARKEN = 2

Produce a darken effect with the following formula:

```gdscript
result = min(a, b);
```

Operator OP_LIGHTEN = 3

Produce a lighten effect with the following formula:

```gdscript
result = max(a, b);
```

Operator OP_OVERLAY = 4

Produce an overlay effect with the following formula:

```gdscript
for (int i = 0; i < 3; i++) {
    float base = a[i];
    float blend = b[i];
    if (base < 0.5) {
        result[i] = 2.0 * base * blend;
    } else {
        result[i] = 1.0 - 2.0 * (1.0 - blend) * (1.0 - base);
    }
}
```

Operator OP_DODGE = 5

Produce a dodge effect with the following formula:

```gdscript
result = a / (vec3(1.0) - b);
```

Operator OP_BURN = 6

Produce a burn effect with the following formula:

```gdscript
result = vec3(1.0) - (vec3(1.0) - a) / b;
```

Operator OP_SOFT_LIGHT = 7

Produce a soft light effect with the following formula:

```gdscript
for (int i = 0; i < 3; i++) {
    float base = a[i];
    float blend = b[i];
    if (base < 0.5) {
        result[i] = base * (blend + 0.5);
    } else {
        result[i] = 1.0 - (1.0 - base) * (1.0 - (blend - 0.5));
    }
}
```

Operator OP_HARD_LIGHT = 8

Produce a hard light effect with the following formula:

```gdscript
for (int i = 0; i < 3; i++) {
    float base = a[i];
    float blend = b[i];
    if (base < 0.5) {
        result[i] = base * (2.0 * blend);
    } else {
        result[i] = 1.0 - (1.0 - base) * (1.0 - 2.0 * (blend - 0.5));
    }
}
```

Operator OP_MAX = 9

Represents the size of the Operator enum.

---

## Property Descriptions

Operator operator = 0 

- void set_operator(value: Operator)
- Operator get_operator()

An operator to be applied to the inputs.
