# UPNPDevice

Inherits: RefCounted < Object

Universal Plug and Play (UPnP) device.

## Description

Universal Plug and Play (UPnP) device. See UPNP for UPnP discovery and utility functions. Provides low-level access to UPNP control commands. Allows to manage port mappings (port forwarding) and to query network information of the device (like local and external IP address and status). Note that methods on this class are synchronous and block the calling thread.

## Properties

String | description_url | ""
String | igd_control_url | ""
String | igd_our_addr | ""
String | igd_service_type | ""
IGDStatus | igd_status | 9
String | service_type | ""

## Methods

int | add_port_mapping(port: int, port_internal: int = 0, desc: String = "", proto: String = "UDP", duration: int = 0) const
int | delete_port_mapping(port: int, proto: String = "UDP") const
bool | is_valid_gateway() const
String | query_external_address() const

---

## Enumerations

enum IGDStatus
IGDStatus IGD_STATUS_OK = 0

OK.

IGDStatus IGD_STATUS_HTTP_ERROR = 1

HTTP error.

IGDStatus IGD_STATUS_HTTP_EMPTY = 2

Empty HTTP response.

IGDStatus IGD_STATUS_NO_URLS = 3

Deprecated: This value is no longer used.

Returned response contained no URLs.

IGDStatus IGD_STATUS_NO_IGD = 4

Not a valid IGD.

IGDStatus IGD_STATUS_DISCONNECTED = 5

Disconnected.

IGDStatus IGD_STATUS_UNKNOWN_DEVICE = 6

Unknown device.

IGDStatus IGD_STATUS_INVALID_CONTROL = 7

Invalid control.

IGDStatus IGD_STATUS_MALLOC_ERROR = 8

Deprecated: This value is no longer used.

Memory allocation error.

IGDStatus IGD_STATUS_UNKNOWN_ERROR = 9

Unknown error.

---

## Property Descriptions

String description_url = "" 

- void set_description_url(value: String)
- String get_description_url()

URL to the device description.

---

String igd_control_url = "" 

- void set_igd_control_url(value: String)
- String get_igd_control_url()

IDG control URL.

---

String igd_our_addr = "" 

- void set_igd_our_addr(value: String)
- String get_igd_our_addr()

Address of the local machine in the network connecting it to this UPNPDevice.

---

String igd_service_type = "" 

- void set_igd_service_type(value: String)
- String get_igd_service_type()

IGD service type.

---

IGDStatus igd_status = 9 

- void set_igd_status(value: IGDStatus)
- IGDStatus get_igd_status()

IGD status.

---

String service_type = "" 

- void set_service_type(value: String)
- String get_service_type()

Service type.

---

## Method Descriptions

int add_port_mapping(port: int, port_internal: int = 0, desc: String = "", proto: String = "UDP", duration: int = 0) const 

Adds a port mapping to forward the given external port on this UPNPDevice for the given protocol to the local machine. See UPNP.add_port_mapping().

---

int delete_port_mapping(port: int, proto: String = "UDP") const 

Deletes the port mapping identified by the given port and protocol combination on this device. See UPNP.delete_port_mapping().

---

bool is_valid_gateway() const 

Returns true if this is a valid IGD (InternetGatewayDevice) which potentially supports port forwarding.

---

String query_external_address() const 

Returns the external IP address of this UPNPDevice or an empty string.
