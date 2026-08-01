# JavaClassWrapper

Inherits: Object

Provides access to the Java Native Interface.

## Description

The JavaClassWrapper singleton provides a way for the Godot application to send and receive data through the Java Native Interface [https://developer.android.com/training/articles/perf-jni] (JNI).

Note: This singleton is only available in Android builds.

```gdscript
var LocalDateTime = JavaClassWrapper.wrap("java.time.LocalDateTime")
var DateTimeFormatter = JavaClassWrapper.wrap("java.time.format.DateTimeFormatter")
var datetime = LocalDateTime.now()
var formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")
print(datetime.format(formatter))
```

Warning: When calling Java methods, be sure to check get_exception() to check if the method threw an exception.

## Tutorials

- Integrating with Android APIs

## Methods

JavaObject | create_proxy(object: Object, interfaces: PackedStringArray)
JavaObject | create_sam_callback(sam_interface: String, callable: Callable)
JavaObject | get_exception()
JavaClass | wrap(name: String)

---

## Method Descriptions

JavaObject create_proxy(object: Object, interfaces: PackedStringArray) 

Creates a JavaObject implementing the given Java interfaces using the given Object as the implementation.

The object must contain methods signatures matching the methods signatures from the passed Java interfaces. Invoking methods from the Java interfaces will route to the matching object method.

```gdscript
class PrintProxy:
    func println(content: String) -> void:
        print(content)
var print_proxy = PrintProxy.new()
var printer_object = JavaClassWrapper.create_proxy(print_proxy, ["android.util.Printer"])
printer_object.println("Hello Godot World!")
```

Note: This method only works on Android. On every other platform, this method will always return null.

---

JavaObject create_sam_callback(sam_interface: String, callable: Callable) 

Creates a JavaObject implementing the Java Single Abstract Method (SAM) interface using the Godot Callable as the implementation.

The sam_interface must be a Java SAM interface, meaning it must only have a single abstract method to implement.

The callable must be able to handle the same parameter types as the SAM interface method, and must provide the same return type. The callable will be invoked as a callback, passing the arguments from the Java SAM interface method.

```gdscript
var cb = func (content: String) -> void:
    print(content)
var callback = JavaClassWrapper.create_sam_callback("android.util.Printer", cb)
callback.println("Hello Godot World!")
```

Note: This method only works on Android. On every other platform, this method will always return null.

---

JavaObject get_exception() 

Returns the Java exception from the last call into a Java class. If there was no exception, it will return null.

Note: This method only works on Android. On every other platform, this method will always return null.

---

JavaClass wrap(name: String) 

Wraps a class defined in Java, and returns it as a JavaClass Object type that Godot can interact with.

When wrapping inner (nested) classes, use $ instead of . to separate them. For example, JavaClassWrapper.wrap("android.view.WindowManager$LayoutParams") wraps the WindowManager.LayoutParams class.

Note: To invoke a constructor, call a method with the same name as the class. For example:

```gdscript
var Intent = JavaClassWrapper.wrap("android.content.Intent")
var intent = Intent.Intent()
```

Note: This method only works on Android. On every other platform, this method does nothing and returns an empty JavaClass.
