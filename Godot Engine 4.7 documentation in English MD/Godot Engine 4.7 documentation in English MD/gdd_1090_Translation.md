# Translation

Inherits: Resource < RefCounted < Object

Inherited By: OptimizedTranslation

A language translation that maps a collection of strings to their individual translations.

## Description

Translation maps a collection of strings to their individual translations, and also provides convenience methods for pluralization.

A Translation consists of messages. A message is identified by its context and untranslated string. Unlike gettext [https://www.gnu.org/software/gettext/], using an empty context string in Godot means not using any context.

## Tutorials

- Internationalizing games
- Localization using gettext
- Locales

## Properties

String | locale | "en"
String | plural_rules_override | ""

## Methods

StringName | _get_message(src_message: StringName, context: StringName) virtual const
StringName | _get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName) virtual const
void | add_message(src_message: StringName, xlated_message: StringName, context: StringName = &"")
void | add_plural_message(src_message: StringName, xlated_messages: PackedStringArray, context: StringName = &"")
void | erase_message(src_message: StringName, context: StringName = &"")
StringName | get_message(src_message: StringName, context: StringName = &"") const
int | get_message_count() const
PackedStringArray | get_message_list() const
StringName | get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName = &"") const
PackedStringArray | get_translated_message_list() const

---

## Property Descriptions

String locale = "en" 

- void set_locale(value: String)
- String get_locale()

The locale of the translation.

---

String plural_rules_override = "" 

- void set_plural_rules_override(value: String)
- String get_plural_rules_override()

The plural rules string to enforce. See GNU gettext [https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html] for examples and more info.

If empty or invalid, default plural rules from TranslationServer.get_plural_rules() are used. The English plural rules are used as a fallback.

---

## Method Descriptions

StringName _get_message(src_message: StringName, context: StringName) virtual const 

Virtual method to override get_message().

---

StringName _get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName) virtual const 

Virtual method to override get_plural_message().

---

void add_message(src_message: StringName, xlated_message: StringName, context: StringName = &"") 

Adds a message if nonexistent, followed by its translation.

An additional context could be used to specify the translation context or differentiate polysemic words.

---

void add_plural_message(src_message: StringName, xlated_messages: PackedStringArray, context: StringName = &"") 

Adds a message involving plural translation if nonexistent, followed by its translation.

An additional context could be used to specify the translation context or differentiate polysemic words.

---

void erase_message(src_message: StringName, context: StringName = &"") 

Erases a message.

---

StringName get_message(src_message: StringName, context: StringName = &"") const 

Returns a message's translation.

---

int get_message_count() const 

Returns the number of existing messages.

---

PackedStringArray get_message_list() const 

Returns the keys of all messages, that is, the context and untranslated strings of each message.

Note: If a message does not use a context, the corresponding element is the untranslated string. Otherwise, the corresponding element is the context and untranslated string separated by the EOT character (U+0004). This is done for compatibility purposes.

```gdscript
for key in translation.get_message_list():
    var p = key.find("\u0004")
    if p == -1:
        var untranslated = key
        print("Message %s" % untranslated)
    else:
        var context = key.substr(0, p)
        var untranslated = key.substr(p + 1)
        print("Message %s with context %s" % [untranslated, context])
```

---

StringName get_plural_message(src_message: StringName, src_plural_message: StringName, n: int, context: StringName = &"") const 

Returns a message's translation involving plurals.

The number n is the number or quantity of the plural object. It will be used to guide the translation system to fetch the correct plural form for the selected language.

Note: Plurals are only supported in gettext-based translations (PO), not CSV.

---

PackedStringArray get_translated_message_list() const 

Returns all the translated strings.
