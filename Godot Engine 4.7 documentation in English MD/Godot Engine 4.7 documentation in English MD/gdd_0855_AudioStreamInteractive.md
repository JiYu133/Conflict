# AudioStreamInteractive

Inherits: AudioStream < Resource < RefCounted < Object

Audio stream that can playback music interactively, combining clips and a transition table.

## Description

This is an audio stream that can playback music interactively, combining clips and a transition table. Clips must be added first, and then the transition rules via the add_transition(). Additionally, this stream exports a property parameter to control the playback via AudioStreamPlayer, AudioStreamPlayer2D, or AudioStreamPlayer3D.

The way this is used is by filling a number of clips, then configuring the transition table. From there, clips are selected for playback and the music will smoothly go from the current to the new one while using the corresponding transition rule defined in the transition table.

## Tutorials

- Audio streams

## Properties

int | clip_count | 0
int | initial_clip | 0

## Methods

void | add_transition(from_clip: int, to_clip: int, from_time: TransitionFromTime, to_time: TransitionToTime, fade_mode: FadeMode, fade_beats: float, use_filler_clip: bool = false, filler_clip: int = -1, hold_previous: bool = false)
void | erase_transition(from_clip: int, to_clip: int)
AutoAdvanceMode | get_clip_auto_advance(clip_index: int) const
int | get_clip_auto_advance_next_clip(clip_index: int) const
StringName | get_clip_name(clip_index: int) const
AudioStream | get_clip_stream(clip_index: int) const
float | get_transition_fade_beats(from_clip: int, to_clip: int) const
FadeMode | get_transition_fade_mode(from_clip: int, to_clip: int) const
int | get_transition_filler_clip(from_clip: int, to_clip: int) const
TransitionFromTime | get_transition_from_time(from_clip: int, to_clip: int) const
PackedInt32Array | get_transition_list() const
TransitionToTime | get_transition_to_time(from_clip: int, to_clip: int) const
bool | has_transition(from_clip: int, to_clip: int) const
bool | is_transition_holding_previous(from_clip: int, to_clip: int) const
bool | is_transition_using_filler_clip(from_clip: int, to_clip: int) const
void | set_clip_auto_advance(clip_index: int, mode: AutoAdvanceMode)
void | set_clip_auto_advance_next_clip(clip_index: int, auto_advance_next_clip: int)
void | set_clip_name(clip_index: int, name: StringName)
void | set_clip_stream(clip_index: int, stream: AudioStream)

---

## Enumerations

enum TransitionFromTime
TransitionFromTime TRANSITION_FROM_TIME_IMMEDIATE = 0

Start transition as soon as possible, don't wait for any specific time position.

TransitionFromTime TRANSITION_FROM_TIME_NEXT_BEAT = 1

Transition when the clip playback position reaches the next beat.

TransitionFromTime TRANSITION_FROM_TIME_NEXT_BAR = 2

Transition when the clip playback position reaches the next bar.

TransitionFromTime TRANSITION_FROM_TIME_END = 3

Transition when the current clip finished playing.

---

enum TransitionToTime
TransitionToTime TRANSITION_TO_TIME_SAME_POSITION = 0

Transition to the same position in the destination clip. This is useful when both clips have exactly the same length and the music should fade between them.

TransitionToTime TRANSITION_TO_TIME_START = 1

Transition to the start of the destination clip.

TransitionToTime TRANSITION_TO_TIME_PREVIOUS_POSITION = 2

Transition to the last played position in the destination clip, if there was a previous transition from that clip. Otherwise, plays from the start of the destination clip.

---

enum FadeMode
FadeMode FADE_DISABLED = 0

Do not use fade for the transition. This is useful when transitioning from a clip-end to clip-beginning, and each clip has their begin/end.

FadeMode FADE_IN = 1

Use a fade-in in the next clip, let the current clip finish.

FadeMode FADE_OUT = 2

Use a fade-out in the current clip, the next clip will start by itself.

FadeMode FADE_CROSS = 3

Use a cross-fade between clips.

FadeMode FADE_AUTOMATIC = 4

Use automatic fade logic depending on the transition from/to. It is recommended to use this by default.

---

enum AutoAdvanceMode
AutoAdvanceMode AUTO_ADVANCE_DISABLED = 0

Disable auto-advance (default).

AutoAdvanceMode AUTO_ADVANCE_ENABLED = 1

Enable auto-advance, a clip must be specified.

AutoAdvanceMode AUTO_ADVANCE_RETURN_TO_HOLD = 2

Enable auto-advance, but instead of specifying a clip, the playback will return to hold (see add_transition()).

---

## Constants

CLIP_ANY = -1 

This constant describes that any clip is valid for a specific transition as either source or destination.

---

## Property Descriptions

int clip_count = 0 

- void set_clip_count(value: int)
- int get_clip_count()

Amount of clips contained in this interactive player.

---

int initial_clip = 0 

- void set_initial_clip(value: int)
- int get_initial_clip()

Index of the initial clip, which will be played first when this stream is played.

---

## Method Descriptions

void add_transition(from_clip: int, to_clip: int, from_time: TransitionFromTime, to_time: TransitionToTime, fade_mode: FadeMode, fade_beats: float, use_filler_clip: bool = false, filler_clip: int = -1, hold_previous: bool = false) 

Add a transition between two clips. Provide the indices of the source and destination clips, or use the CLIP_ANY constant to indicate that transition happens to/from any clip to this one.

* from_time indicates the moment in the current clip the transition will begin after triggered.

* to_time indicates the time in the next clip that the playback will start from.

* fade_mode indicates how the fade will happen between clips. If unsure, just use FADE_AUTOMATIC which uses the most common type of fade for each situation.

* fade_beats indicates how many beats the fade will take. Using decimals is allowed.

* use_filler_clip indicates that there will be a filler clip used between the source and destination clips.

* filler_clip the index of the filler clip.

* If hold_previous is used, then this clip will be remembered. This can be used together with AUTO_ADVANCE_RETURN_TO_HOLD to return to this clip after another is done playing.

---

void erase_transition(from_clip: int, to_clip: int) 

Erase a transition by providing from_clip and to_clip clip indices. CLIP_ANY can be used for either argument or both.

---

AutoAdvanceMode get_clip_auto_advance(clip_index: int) const 

Return whether a clip has auto-advance enabled. See set_clip_auto_advance().

---

int get_clip_auto_advance_next_clip(clip_index: int) const 

Return the clip towards which the clip referenced by clip_index will auto-advance to.

---

StringName get_clip_name(clip_index: int) const 

Return the name of a clip.

---

AudioStream get_clip_stream(clip_index: int) const 

Return the AudioStream associated with a clip.

---

float get_transition_fade_beats(from_clip: int, to_clip: int) const 

Return the time (in beats) for a transition (see add_transition()).

---

FadeMode get_transition_fade_mode(from_clip: int, to_clip: int) const 

Return the mode for a transition (see add_transition()).

---

int get_transition_filler_clip(from_clip: int, to_clip: int) const 

Return the filler clip for a transition (see add_transition()).

---

TransitionFromTime get_transition_from_time(from_clip: int, to_clip: int) const 

Return the source time position for a transition (see add_transition()).

---

PackedInt32Array get_transition_list() const 

Return the list of transitions (from, to interleaved).

---

TransitionToTime get_transition_to_time(from_clip: int, to_clip: int) const 

Return the destination time position for a transition (see add_transition()).

---

bool has_transition(from_clip: int, to_clip: int) const 

Returns true if a given transition exists (was added via add_transition()).

---

bool is_transition_holding_previous(from_clip: int, to_clip: int) const 

Return whether a transition uses the hold previous functionality (see add_transition()).

---

bool is_transition_using_filler_clip(from_clip: int, to_clip: int) const 

Return whether a transition uses the filler clip functionality (see add_transition()).

---

void set_clip_auto_advance(clip_index: int, mode: AutoAdvanceMode) 

Set whether a clip will auto-advance by changing the auto-advance mode.

---

void set_clip_auto_advance_next_clip(clip_index: int, auto_advance_next_clip: int) 

Set the index of the next clip towards which this clip will auto advance to when finished. If the clip being played loops, then auto-advance will be ignored.

---

void set_clip_name(clip_index: int, name: StringName) 

Set the name of the current clip (for easier identification).

---

void set_clip_stream(clip_index: int, stream: AudioStream) 

Set the AudioStream associated with the current clip.
