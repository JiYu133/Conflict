# HashingContext

Inherits: RefCounted < Object

Provides functionality for computing cryptographic hashes chunk by chunk.

## Description

The HashingContext class provides an interface for computing cryptographic hashes over multiple iterations. Useful for computing hashes of big files (so you don't have to load them all in memory), network streams, and data streams in general (so you don't have to hold buffers).

The HashType enum shows the supported hashing algorithms.

```
const CHUNK_SIZE = 1024
func hash_file(path):
    # Check that file exists.
    if not FileAccess.file_exists(path):
        return
    # Start an SHA-256 context.
    var ctx = HashingContext.new()
    ctx.start(HashingContext.HASH_SHA256)
    # Open the file to hash.
    var file = FileAccess.open(path, FileAccess.READ)
    # Update the context after reading each chunk.
    while file.get_position() < file.get_length():
        var remaining = file.get_length() - file.get_position()
        ctx.update(file.get_buffer(min(remaining, CHUNK_SIZE)))
    # Get the computed hash.
    var res = ctx.finish()
    # Print the result as hex string and array.
    printt(res.hex_encode(), Array(res))
```

```
public const int ChunkSize = 1024;
public void HashFile(string path)
{
    // Check that file exists.
    if (!FileAccess.FileExists(path))
    {
        return;
    }
    // Start an SHA-256 context.
    var ctx = new HashingContext();
    ctx.Start(HashingContext.HashType.Sha256);
    // Open the file to hash.
    using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
    // Update the context after reading each chunk.
    while (file.GetPosition() < file.GetLength())
    {
        int remaining = (int)(file.GetLength() - file.GetPosition());
        ctx.Update(file.GetBuffer(Mathf.Min(remaining, ChunkSize)));
    }
    // Get the computed hash.
    byte[] res = ctx.Finish();
    // Print the result as hex string and array.
    GD.PrintT(res.HexEncode(), (Variant)res);
}
```

## Methods

PackedByteArray | finish()
Error | start(type: HashType)
Error | update(chunk: PackedByteArray)

---

## Enumerations

enum HashType
HashType HASH_MD5 = 0

Hashing algorithm: MD5.

HashType HASH_SHA1 = 1

Hashing algorithm: SHA-1.

HashType HASH_SHA256 = 2

Hashing algorithm: SHA-256.

---

## Method Descriptions

PackedByteArray finish() 

Closes the current context, and return the computed hash.

---

Error start(type: HashType) 

Starts a new hash computation of the given type (e.g. HASH_SHA256 to start computation of an SHA-256).

---

Error update(chunk: PackedByteArray) 

Updates the computation with the given chunk of data.
