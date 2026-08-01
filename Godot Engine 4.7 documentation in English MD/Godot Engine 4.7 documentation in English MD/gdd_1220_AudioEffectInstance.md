# AudioEffectInstance

Inherits: RefCounted < Object

Inherited By: AudioEffectSpectrumAnalyzerInstance

Manipulates the audio it receives for a given effect.

## Description

An audio effect instance manipulates the audio it receives for a given effect. This instance is automatically created by an AudioEffect when it is added to a bus, and should usually not be created directly. If necessary, it can be fetched at run-time with AudioServer.get_bus_effect_instance().

## Tutorials

- Audio buses
- Audio effects

## Methods

void | _process(src_buffer: const void*, r_dst_buffer: AudioFrame*, frame_count: int) virtual required
bool | _process_silence() virtual const

---

## Method Descriptions

void _process(src_buffer: const void*, r_dst_buffer: AudioFrame*, frame_count: int) virtual required 

Called by the AudioServer to process this effect. When _process_silence() is not overridden or it returns false, this method is called only when the bus is active.

Note: It is not useful to override this method in GDScript or C#. Only GDExtension can take advantage of it.

---

bool _process_silence() virtual const 

Override this method to customize the processing behavior of this effect instance.

Should return true to force the AudioServer to always call _process(), even if the bus has been muted or cannot otherwise be heard.
