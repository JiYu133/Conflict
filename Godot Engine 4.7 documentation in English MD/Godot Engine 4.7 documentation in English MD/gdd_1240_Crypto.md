# Crypto

Inherits: RefCounted < Object

Provides access to advanced cryptographic functionalities.

## Description

The Crypto class provides access to advanced cryptographic functionalities.

Currently, this includes asymmetric key encryption/decryption, signing/verification, and generating cryptographically secure random bytes, RSA keys, HMAC digests, and self-signed X509Certificates.

```
var crypto = Crypto.new()
# Generate new RSA key.
var key = crypto.generate_rsa(4096)
# Generate new self-signed certificate with the given key.
var cert = crypto.generate_self_signed_certificate(key, "CN=mydomain.com,O=My Game Company,C=IT")
# Save key and certificate in the user folder.
key.save("user://generated.key")
cert.save("user://generated.crt")
# Encryption
var data = "Some data"
var encrypted = crypto.encrypt(key, data.to_utf8_buffer())
# Decryption
var decrypted = crypto.decrypt(key, encrypted)
# Signing
var signature = crypto.sign(HashingContext.HASH_SHA256, data.sha256_buffer(), key)
# Verifying
var verified = crypto.verify(HashingContext.HASH_SHA256, data.sha256_buffer(), signature, key)
# Checks
assert(verified)
assert(data.to_utf8_buffer() == decrypted)
```

```
using Godot;
using System.Diagnostics;
Crypto crypto = new Crypto();
// Generate new RSA key.
CryptoKey key = crypto.GenerateRsa(4096);
// Generate new self-signed certificate with the given key.
X509Certificate cert = crypto.GenerateSelfSignedCertificate(key, "CN=mydomain.com,O=My Game Company,C=IT");
// Save key and certificate in the user folder.
key.Save("user://generated.key");
cert.Save("user://generated.crt");
// Encryption
string data = "Some data";
byte[] encrypted = crypto.Encrypt(key, data.ToUtf8Buffer());
// Decryption
byte[] decrypted = crypto.Decrypt(key, encrypted);
// Signing
byte[] signature = crypto.Sign(HashingContext.HashType.Sha256, Data.Sha256Buffer(), key);
// Verifying
bool verified = crypto.Verify(HashingContext.HashType.Sha256, Data.Sha256Buffer(), signature, key);
// Checks
Debug.Assert(verified);
Debug.Assert(data.ToUtf8Buffer() == decrypted);
```

## Methods

bool | constant_time_compare(trusted: PackedByteArray, received: PackedByteArray)
PackedByteArray | decrypt(key: CryptoKey, ciphertext: PackedByteArray)
PackedByteArray | encrypt(key: CryptoKey, plaintext: PackedByteArray)
PackedByteArray | generate_random_bytes(size: int)
CryptoKey | generate_rsa(size: int)
X509Certificate | generate_self_signed_certificate(key: CryptoKey, issuer_name: String = "CN=myserver,O=myorganisation,C=IT", not_before: String = "20140101000000", not_after: String = "20340101000000")
PackedByteArray | hmac_digest(hash_type: HashType, key: PackedByteArray, msg: PackedByteArray)
PackedByteArray | sign(hash_type: HashType, hash: PackedByteArray, key: CryptoKey)
bool | verify(hash_type: HashType, hash: PackedByteArray, signature: PackedByteArray, key: CryptoKey)

---

## Method Descriptions

bool constant_time_compare(trusted: PackedByteArray, received: PackedByteArray) 

Compares two PackedByteArrays for equality without leaking timing information in order to prevent timing attacks.

See this blog post [https://paragonie.com/blog/2015/11/preventing-timing-attacks-on-string-comparison-with-double-hmac-strategy] for more information.

---

PackedByteArray decrypt(key: CryptoKey, ciphertext: PackedByteArray) 

Decrypt the given ciphertext with the provided private key.

Note: The maximum size of accepted ciphertext is limited by the key size.

---

PackedByteArray encrypt(key: CryptoKey, plaintext: PackedByteArray) 

Encrypt the given plaintext with the provided public key.

Note: The maximum size of accepted plaintext is limited by the key size.

---

PackedByteArray generate_random_bytes(size: int) 

Generates a PackedByteArray of cryptographically secure random bytes with given size.

---

CryptoKey generate_rsa(size: int) 

Generates an RSA CryptoKey that can be used for creating self-signed certificates and passed to StreamPeerTLS.accept_stream().

---

X509Certificate generate_self_signed_certificate(key: CryptoKey, issuer_name: String = "CN=myserver,O=myorganisation,C=IT", not_before: String = "20140101000000", not_after: String = "20340101000000") 

Generates a self-signed X509Certificate from the given CryptoKey and issuer_name. The certificate validity will be defined by not_before and not_after (first valid date and last valid date). The issuer_name must contain at least "CN=" (common name, i.e. the domain name), "O=" (organization, i.e. your company name), "C=" (country, i.e. 2 lettered ISO-3166 code of the country the organization is based in).

A small example to generate an RSA key and an X509 self-signed certificate.

```
var crypto = Crypto.new()
# Generate 4096 bits RSA key.
var key = crypto.generate_rsa(4096)
# Generate self-signed certificate using the given key.
var cert = crypto.generate_self_signed_certificate(key, "CN=example.com,O=A Game Company,C=IT")
```

```
var crypto = new Crypto();
// Generate 4096 bits RSA key.
CryptoKey key = crypto.GenerateRsa(4096);
// Generate self-signed certificate using the given key.
X509Certificate cert = crypto.GenerateSelfSignedCertificate(key, "CN=mydomain.com,O=My Game Company,C=IT");
```

---

PackedByteArray hmac_digest(hash_type: HashType, key: PackedByteArray, msg: PackedByteArray) 

Generates an HMAC [https://en.wikipedia.org/wiki/HMAC] digest of msg using key. The hash_type parameter is the hashing algorithm that is used for the inner and outer hashes.

Currently, only HashingContext.HASH_SHA256 and HashingContext.HASH_SHA1 are supported.

---

PackedByteArray sign(hash_type: HashType, hash: PackedByteArray, key: CryptoKey) 

Sign a given hash of type hash_type with the provided private key.

---

bool verify(hash_type: HashType, hash: PackedByteArray, signature: PackedByteArray, key: CryptoKey) 

Verify that a given signature for hash of type hash_type against the provided public key.
