# IP

Inherits: Object

Internet protocol (IP) support functions such as DNS resolution.

## Description

IP contains support functions for the Internet Protocol (IP). TCP/IP support is in different classes (see StreamPeerTCP and TCPServer). IP provides DNS hostname resolution support, both blocking and threaded.

## Methods

void | clear_cache(hostname: String = "")
void | erase_resolve_item(id: int)
PackedStringArray | get_local_addresses() const
Array[Dictionary] | get_local_interfaces() const
String | get_resolve_item_address(id: int) const
Array | get_resolve_item_addresses(id: int) const
ResolverStatus | get_resolve_item_status(id: int) const
String | resolve_hostname(host: String, ip_type: Type = 3)
PackedStringArray | resolve_hostname_addresses(host: String, ip_type: Type = 3)
int | resolve_hostname_queue_item(host: String, ip_type: Type = 3)

---

## Enumerations

enum ResolverStatus
ResolverStatus RESOLVER_STATUS_NONE = 0

DNS hostname resolver status: No status.

ResolverStatus RESOLVER_STATUS_WAITING = 1

DNS hostname resolver status: Waiting.

ResolverStatus RESOLVER_STATUS_DONE = 2

DNS hostname resolver status: Done.

ResolverStatus RESOLVER_STATUS_ERROR = 3

DNS hostname resolver status: Error.

---

enum Type
Type TYPE_NONE = 0

Address type: None.

Type TYPE_IPV4 = 1

Address type: Internet protocol version 4 (IPv4).

Type TYPE_IPV6 = 2

Address type: Internet protocol version 6 (IPv6).

Type TYPE_ANY = 3

Address type: Any.

---

## Constants

RESOLVER_MAX_QUERIES = 256 

Maximum number of concurrent DNS resolver queries allowed, RESOLVER_INVALID_ID is returned if exceeded.

RESOLVER_INVALID_ID = -1 

Invalid ID constant. Returned if RESOLVER_MAX_QUERIES is exceeded.

---

## Method Descriptions

void clear_cache(hostname: String = "") 

Removes all of a hostname's cached references. If no hostname is given, all cached IP addresses are removed.

---

void erase_resolve_item(id: int) 

Removes a given item id from the queue. This should be used to free a queue after it has completed to enable more queries to happen.

---

PackedStringArray get_local_addresses() const 

Returns all the user's current IPv4 and IPv6 addresses as an array.

---

Array[Dictionary] get_local_interfaces() const 

Returns all network adapters as an array.

Each adapter is a dictionary of the form:

```gdscript
{
    "index": "1", # Interface index.
    "name": "eth0", # Interface name.
    "friendly": "Ethernet One", # A friendly name (might be empty).
    "addresses": ["192.168.1.101"], # An array of IP addresses associated to this interface.
}
```

---

String get_resolve_item_address(id: int) const 

Returns a queued hostname's IP address, given its queue id. Returns an empty string on error or if resolution hasn't happened yet (see get_resolve_item_status()).

---

Array get_resolve_item_addresses(id: int) const 

Returns resolved addresses, or an empty array if an error happened or resolution didn't happen yet (see get_resolve_item_status()).

---

ResolverStatus get_resolve_item_status(id: int) const 

Returns a queued hostname's status as a ResolverStatus constant, given its queue id.

---

String resolve_hostname(host: String, ip_type: Type = 3) 

Returns a given hostname's IPv4 or IPv6 address when resolved (blocking-type method). The address type returned depends on the Type constant given as ip_type.

---

PackedStringArray resolve_hostname_addresses(host: String, ip_type: Type = 3) 

Resolves a given hostname in a blocking way. Addresses are returned as an Array of IPv4 or IPv6 addresses depending on ip_type.

---

int resolve_hostname_queue_item(host: String, ip_type: Type = 3) 

Creates a queue item to resolve a hostname to an IPv4 or IPv6 address depending on the Type constant given as ip_type. Returns the queue ID if successful, or RESOLVER_INVALID_ID on error.
