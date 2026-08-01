# TLSOptions

Inherits: RefCounted < Object

TLS configuration for clients and servers.

## Description

TLSOptions abstracts the configuration options for the StreamPeerTLS and PacketPeerDTLS classes.

Objects of this class cannot be instantiated directly, and one of the static methods client(), client_unsafe(), or server() should be used instead.

```
# Create a TLS client configuration which uses our custom trusted CA chain.
var client_trusted_cas = load("res://my_trusted_cas.crt")
var client_tls_options = TLSOptions.client(client_trusted_cas)
# Create a TLS server configuration.
var server_certs = load("res://my_server_cas.crt")
var server_key = load("res://my_server_key.key")
var server_tls_options = TLSOptions.server(server_key, server_certs)
```

## Methods

TLSOptions | client(trusted_chain: X509Certificate = null, common_name_override: String = "") static
TLSOptions | client_unsafe(trusted_chain: X509Certificate = null) static
String | get_common_name_override() const
X509Certificate | get_own_certificate() const
CryptoKey | get_private_key() const
X509Certificate | get_trusted_ca_chain() const
bool | is_server() const
bool | is_unsafe_client() const
TLSOptions | server(key: CryptoKey, certificate: X509Certificate) static

---

## Method Descriptions

TLSOptions client(trusted_chain: X509Certificate = null, common_name_override: String = "") static 

Creates a TLS client configuration which validates certificates and their common names (fully qualified domain names).

You can specify a custom trusted_chain of certification authorities (the default CA list will be used if null), and optionally provide a common_name_override if you expect the certificate to have a common name other than the server FQDN.

Note: On the Web platform, TLS verification is always enforced against the CA list of the web browser. This is considered a security feature.

---

TLSOptions client_unsafe(trusted_chain: X509Certificate = null) static 

Creates an unsafe TLS client configuration where certificate validation is optional. You can optionally provide a valid trusted_chain, but the common name of the certificates will never be checked. Using this configuration for purposes other than testing is not recommended.

Note: On the Web platform, TLS verification is always enforced against the CA list of the web browser. This is considered a security feature.

---

String get_common_name_override() const 

Returns the common name (domain name) override specified when creating with client().

---

X509Certificate get_own_certificate() const 

Returns the X509Certificate specified when creating with server().

---

CryptoKey get_private_key() const 

Returns the CryptoKey specified when creating with server().

---

X509Certificate get_trusted_ca_chain() const 

Returns the CA X509Certificate chain specified when creating with client() or client_unsafe().

---

bool is_server() const 

Returns true if created with server(), false otherwise.

---

bool is_unsafe_client() const 

Returns true if created with client_unsafe(), false otherwise.

---

TLSOptions server(key: CryptoKey, certificate: X509Certificate) static 

Creates a TLS server configuration using the provided key and certificate.

Note: The certificate should include the full certificate chain up to the signing CA (certificates file can be concatenated using a general purpose text editor).
