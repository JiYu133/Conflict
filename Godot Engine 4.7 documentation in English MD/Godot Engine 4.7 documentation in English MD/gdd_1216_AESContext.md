# AESContext

Inherits: RefCounted < Object

Provides access to AES encryption/decryption of raw data.

## Description

This class holds the context information required for encryption and decryption operations with AES (Advanced Encryption Standard). Both AES-ECB and AES-CBC modes are supported.

```
extends Node
var aes = AESContext.new()
func _ready():
    var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
    var data = "My secret text!!" # Data size must be multiple of 16 bytes, apply padding if needed.
    # Encrypt ECB
    aes.start(AESContext.MODE_ECB_ENCRYPT, key.to_utf8_buffer())
    var encrypted = aes.update(data.to_utf8_buffer())
    aes.finish()
    # Decrypt ECB
    aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8_buffer())
    var decrypted = aes.update(encrypted)
    aes.finish()
    # Check ECB
    assert(decrypted == data.to_utf8_buffer())
    var iv = "My secret iv!!!!" # IV must be of exactly 16 bytes.
    # Encrypt CBC
    aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
    encrypted = aes.update(data.to_utf8_buffer())
    aes.finish()
    # Decrypt CBC
    aes.start(AESContext.MODE_CBC_DECRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
    decrypted = aes.update(encrypted)
    aes.finish()
    # Check CBC
    assert(decrypted == data.to_utf8_buffer())
```

```
using Godot;
using System.Diagnostics;
public partial class MyNode : Node
{
    private AesContext _aes = new AesContext();
    public override void _Ready()
    {
        string key = "My secret key!!!"; // Key must be either 16 or 32 bytes.
        string data = "My secret text!!"; // Data size must be multiple of 16 bytes, apply padding if needed.
        // Encrypt ECB
        _aes.Start(AesContext.Mode.EcbEncrypt, key.ToUtf8Buffer());
        byte[] encrypted = _aes.Update(data.ToUtf8Buffer());
        _aes.Finish();
        // Decrypt ECB
        _aes.Start(AesContext.Mode.EcbDecrypt, key.ToUtf8Buffer());
        byte[] decrypted = _aes.Update(encrypted);
        _aes.Finish();
        // Check ECB
        Debug.Assert(decrypted == data.ToUtf8Buffer());
        string iv = "My secret iv!!!!"; // IV must be of exactly 16 bytes.
        // Encrypt CBC
        _aes.Start(AesContext.Mode.EcbEncrypt, key.ToUtf8Buffer(), iv.ToUtf8Buffer());
        encrypted = _aes.Update(data.ToUtf8Buffer());
        _aes.Finish();
        // Decrypt CBC
        _aes.Start(AesContext.Mode.EcbDecrypt, key.ToUtf8Buffer(), iv.ToUtf8Buffer());
        decrypted = _aes.Update(encrypted);
        _aes.Finish();
        // Check CBC
        Debug.Assert(decrypted == data.ToUtf8Buffer());
    }
}
```

## Methods

void | finish()
PackedByteArray | get_iv_state()
Error | start(mode: Mode, key: PackedByteArray, iv: PackedByteArray = PackedByteArray())
PackedByteArray | update(src: PackedByteArray)

---

## Enumerations

enum Mode
Mode MODE_ECB_ENCRYPT = 0

AES electronic codebook encryption mode.

Mode MODE_ECB_DECRYPT = 1

AES electronic codebook decryption mode.

Mode MODE_CBC_ENCRYPT = 2

AES cipher block chaining encryption mode.

Mode MODE_CBC_DECRYPT = 3

AES cipher block chaining decryption mode.

Mode MODE_MAX = 4

Maximum value for the mode enum.

---

## Method Descriptions

void finish() 

Close this AES context so it can be started again. See start().

---

PackedByteArray get_iv_state() 

Get the current IV state for this context (IV gets updated when calling update()). You normally don't need this function.

Note: This function only makes sense when the context is started with MODE_CBC_ENCRYPT or MODE_CBC_DECRYPT.

---

Error start(mode: Mode, key: PackedByteArray, iv: PackedByteArray = PackedByteArray()) 

Start the AES context in the given mode. A key of either 16 or 32 bytes must always be provided, while an iv (initialization vector) of exactly 16 bytes, is only needed when mode is either MODE_CBC_ENCRYPT or MODE_CBC_DECRYPT.

---

PackedByteArray update(src: PackedByteArray) 

Run the desired operation for this AES context. Will return a PackedByteArray containing the result of encrypting (or decrypting) the given src. See start() for mode of operation.

Note: The size of src must be a multiple of 16. Apply some padding if needed.
