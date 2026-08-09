# ZIPPacker

Inherits: RefCounted < Object

Allows the creation of ZIP files.

## Description

This class implements a writer that allows storing the multiple blobs in a ZIP archive. See also ZIPReader and PCKPacker.

```gdscript
# Create a ZIP archive with a single file at its root.
func write_zip_file():
    var writer = ZIPPacker.new()
    var err = writer.open("user://archive.zip")
    if err != OK:
        return err
    writer.start_file("hello.txt")
    writer.write_file("Hello World".to_utf8_buffer())
    writer.close_file()
    writer.close()
    return OK
```

## Properties

int | compression_level | -1

## Methods

Error | add_directory(path: String, permissions: BitField[UnixPermissionFlags] = 493, modified_time: int = 0)
Error | close()
Error | close_file()
Error | open(path: String, append: ZipAppend = 0)
Error | start_file(path: String, permissions: BitField[UnixPermissionFlags] = 420, modified_time: int = 0)
Error | write_file(data: PackedByteArray)

---

## Enumerations

enum ZipAppend
ZipAppend APPEND_CREATE = 0

Create a new zip archive at the given path.

ZipAppend APPEND_CREATEAFTER = 1

Append a new zip archive to the end of the already existing file at the given path.

ZipAppend APPEND_ADDINZIP = 2

Add new files to the existing zip archive at the given path.

---

enum CompressionLevel
CompressionLevel COMPRESSION_DEFAULT = -1

Start a file with the default Deflate compression level (6). This is a good compromise between speed and file size.

CompressionLevel COMPRESSION_NONE = 0

Start a file with no compression. This is also known as the "Store" compression mode and is the fastest method of packing files inside a ZIP archive. Consider using this mode for files that are already compressed (such as JPEG, PNG, MP3, or Ogg Vorbis files).

CompressionLevel COMPRESSION_FAST = 1

Start a file with the fastest Deflate compression level (1). This is fast to compress, but results in larger file sizes than COMPRESSION_DEFAULT. Decompression speed is generally unaffected by the chosen compression level.

CompressionLevel COMPRESSION_BEST = 9

Start a file with the best Deflate compression level (9). This is slow to compress, but results in smaller file sizes than COMPRESSION_DEFAULT. Decompression speed is generally unaffected by the chosen compression level.

---

## Property Descriptions

int compression_level = -1 

- void set_compression_level(value: int)
- int get_compression_level()

The compression level used when start_file() is called. Use CompressionLevel as a reference.

---

## Method Descriptions

Error add_directory(path: String, permissions: BitField[UnixPermissionFlags] = 493, modified_time: int = 0) 

Adds directory to the archive. If modified_time is set to 0, current system time is used.

Note: Directories are automatically created when start_file() is called, use this function before adding files to create directories with custom permissions and modification time.

---

Error close() 

Closes the underlying resources used by this instance.

---

Error close_file() 

Stops writing to a file within the archive.

It will fail if there is no open file.

---

Error open(path: String, append: ZipAppend = 0) 

Opens a zip file for writing at the given path using the specified write mode.

This must be called before everything else.

---

Error start_file(path: String, permissions: BitField[UnixPermissionFlags] = 420, modified_time: int = 0) 

Starts writing to a file within the archive. Only one file can be written at the same time. If modified_time is set to 0, current system time is used.

Must be called after open().

---

Error write_file(data: PackedByteArray) 

Write the given data to the file.

Needs to be called after start_file().
