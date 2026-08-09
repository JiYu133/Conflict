# HMACContext

Inherits: RefCounted < Object

Used to create an HMAC for a message using a key.

## Description

The HMACContext class is useful for advanced HMAC use cases, such as streaming the message as it supports creating the message over time rather than providing it all at once.

```
extends Node
var ctx = HMACContext.new()
func _ready():
    var key = "supersecret".to_utf8_buffer()
    var err = ctx.start(HashingContext.HASH_SHA256, key)
    assert(err == OK)
    var msg1 = "this is ".to_utf8_buffer()
    var msg2 = "super duper secret".to_utf8_buffer()
    err = ctx.update(msg1)
    assert(err == OK)
    err = ctx.update(msg2)
    assert(err == OK)
    var hmac = ctx.finish()
    print(hmac.hex_encode())
```

```
using Godot;
using System.Diagnostics;
public partial class MyNode : Node
{
    private HmacContext _ctx = new HmacContext();
    public override void _Ready()
    {
        byte[] key = "supersecret".ToUtf8Buffer();
        Error err = _ctx.Start(HashingContext.HashType.Sha256, key);
        Debug.Assert(err == Error.Ok);
        byte[] msg1 = "this is ".ToUtf8Buffer();
        byte[] msg2 = "super duper secret".ToUtf8Buffer();
        err = _ctx.Update(msg1);
        Debug.Assert(err == Error.Ok);
        err = _ctx.Update(msg2);
        Debug.Assert(err == Error.Ok);
        byte[] hmac = _ctx.Finish();
        GD.Print(hmac.HexEncode());
    }
}
```

## Methods

PackedByteArray | finish()
Error | start(hash_type: HashType, key: PackedByteArray)
Error | update(data: PackedByteArray)

---

## Method Descriptions

PackedByteArray finish() 

Returns the resulting HMAC. If the HMAC failed, an empty PackedByteArray is returned.

---

Error start(hash_type: HashType, key: PackedByteArray) 

Initializes the HMACContext. This method cannot be called again on the same HMACContext until finish() has been called.

---

Error update(data: PackedByteArray) 

Updates the message to be HMACed. This can be called multiple times before finish() is called to append data to the message, but cannot be called until start() has been called.
