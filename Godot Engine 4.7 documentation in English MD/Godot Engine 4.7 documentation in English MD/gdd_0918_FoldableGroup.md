# FoldableGroup

Inherits: Resource < RefCounted < Object

A group of foldable containers that doesn't allow more than one container to be expanded at a time.

## Description

A group of FoldableContainer-derived nodes. Only one container can be expanded at a time.

## Properties

bool | allow_folding_all | false
bool | resource_local_to_scene | true (overrides Resource)

## Methods

Array[FoldableContainer] | get_containers() const
FoldableContainer | get_expanded_container() const

---

## Signals

expanded(container: FoldableContainer) 

Emitted when one of the containers of the group is expanded.

---

## Property Descriptions

bool allow_folding_all = false 

- void set_allow_folding_all(value: bool)
- bool is_allow_folding_all()

If true, it is possible to fold all containers in this FoldableGroup.

---

## Method Descriptions

Array[FoldableContainer] get_containers() const 

Returns an Array of FoldableContainers that have this as their FoldableGroup (see FoldableContainer.foldable_group). This is equivalent to ButtonGroup but for FoldableContainers.

---

FoldableContainer get_expanded_container() const 

Returns the current expanded container.
