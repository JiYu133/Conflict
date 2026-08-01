# X509Certificate

Inherits: Resource < RefCounted < Object

An X509 certificate (e.g. for TLS).

## Description

The X509Certificate class represents an X509 certificate. Certificates can be loaded and saved like any other Resource.

They can be used as the server certificate in StreamPeerTLS.accept_stream() (along with the proper CryptoKey), and to specify the only certificate that should be accepted when connecting to a TLS server via StreamPeerTLS.connect_to_stream().

## Tutorials

- SSL certificates

## Methods

Error | load(path: String)
Error | load_from_string(string: String)
Error | save(path: String)
String | save_to_string()

---

## Method Descriptions

Error load(path: String) 

Loads a certificate from path ("*.crt" file).

---

Error load_from_string(string: String) 

Loads a certificate from the given string.

---

Error save(path: String) 

Saves a certificate to the given path (should be a "*.crt" file).

---

String save_to_string() 

Returns a string representation of the certificate, or an empty string if the certificate is invalid.
