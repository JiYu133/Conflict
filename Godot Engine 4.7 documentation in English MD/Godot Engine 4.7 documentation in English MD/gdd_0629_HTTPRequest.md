# HTTPRequest

Inherits: Node < Object

A node with the ability to send HTTP(S) requests.

## Description

A node with the ability to send HTTP requests. Uses HTTPClient internally.

Can be used to make HTTP requests, i.e. download or upload files or web content via HTTP.

Warning: See the notes and warnings on HTTPClient for limitations, especially regarding TLS security.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

Example: Contact a REST API and print one of its returned fields:

```
func _ready():
    # Create an HTTP request node and connect its completion signal.
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(self._http_request_completed)
    # Perform a GET request. The URL below returns JSON as of writing.
    var error = http_request.request("https://httpbin.org/get")
    if error != OK:
        push_error("An error occurred in the HTTP request.")
    # Perform a POST request. The URL below returns JSON as of writing.
    # Note: Don't make simultaneous requests using a single HTTPRequest node.
    # The snippet below is provided for reference only.
    var body = JSON.stringify({"name": "Godette"})
    error = http_request.request("https://httpbin.org/post", [], HTTPClient.METHOD_POST, body)
    if error != OK:
        push_error("An error occurred in the HTTP request.")
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    var response = json.get_data()
    # Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
    print(response.headers["User-Agent"])
```

```
public override void _Ready()
{
    // Create an HTTP request node and connect its completion signal.
    var httpRequest = new HttpRequest();
    AddChild(httpRequest);
    httpRequest.RequestCompleted += HttpRequestCompleted;
    // Perform a GET request. The URL below returns JSON as of writing.
    Error error = httpRequest.Request("https://httpbin.org/get");
    if (error != Error.Ok)
    {
        GD.PushError("An error occurred in the HTTP request.");
    }
    // Perform a POST request. The URL below returns JSON as of writing.
    // Note: Don't make simultaneous requests using a single HTTPRequest node.
    // The snippet below is provided for reference only.
    string body = Json.Stringify(new Godot.Collections.Dictionary
    {
        { "name", "Godette" }
    });
    error = httpRequest.Request("https://httpbin.org/post", null, HttpClient.Method.Post, body);
    if (error != Error.Ok)
    {
        GD.PushError("An error occurred in the HTTP request.");
    }
}
// Called when the HTTP request is completed.
private void HttpRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
{
    var json = new Json();
    json.Parse(body.GetStringFromUtf8());
    var response = json.GetData().AsGodotDictionary();
    // Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
    GD.Print((response["headers"].AsGodotDictionary())["User-Agent"]);
}
```

Example: Load an image using HTTPRequest and display it:

```
func _ready():
    # Create an HTTP request node and connect its completion signal.
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(self._http_request_completed)
    # Perform the HTTP request. The URL below returns a PNG image as of writing.
    var error = http_request.request("https://placehold.co/512.png")
    if error != OK:
        push_error("An error occurred in the HTTP request.")
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
    if result != HTTPRequest.RESULT_SUCCESS:
        push_error("Image couldn't be downloaded. Try a different image.")
    var image = Image.new()
    var error = image.load_png_from_buffer(body)
    if error != OK:
        push_error("Couldn't load the image.")
    var texture = ImageTexture.create_from_image(image)
    # Display the image in a TextureRect node.
    var texture_rect = TextureRect.new()
    add_child(texture_rect)
    texture_rect.texture = texture
```

```
public override void _Ready()
{
    // Create an HTTP request node and connect its completion signal.
    var httpRequest = new HttpRequest();
    AddChild(httpRequest);
    httpRequest.RequestCompleted += HttpRequestCompleted;
    // Perform the HTTP request. The URL below returns a PNG image as of writing.
    Error error = httpRequest.Request("https://placehold.co/512.png");
    if (error != Error.Ok)
    {
        GD.PushError("An error occurred in the HTTP request.");
    }
}
// Called when the HTTP request is completed.
private void HttpRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
{
    if (result != (long)HttpRequest.Result.Success)
    {
        GD.PushError("Image couldn't be downloaded. Try a different image.");
    }
    var image = new Image();
    Error error = image.LoadPngFromBuffer(body);
    if (error != Error.Ok)
    {
        GD.PushError("Couldn't load the image.");
    }
    var texture = ImageTexture.CreateFromImage(image);
    // Display the image in a TextureRect node.
    var textureRect = new TextureRect();
    AddChild(textureRect);
    textureRect.Texture = texture;
}
```

Note: HTTPRequest nodes will automatically handle decompression of response bodies. An Accept-Encoding header will be automatically added to each of your requests, unless one is already specified. Any response with a Content-Encoding: gzip header will automatically be decompressed and delivered to you as uncompressed bytes.

## Tutorials

- Making HTTP requests
- TLS certificates

## Properties

bool | accept_gzip | true
int | body_size_limit | -1
int | download_chunk_size | 65536
String | download_file | ""
int | max_redirects | 8
float | timeout | 0.0
bool | use_threads | false

## Methods

void | cancel_request()
int | get_body_size() const
int | get_downloaded_bytes() const
Status | get_http_client_status() const
Error | request(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: Method = 0, request_data: String = "")
Error | request_raw(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: Method = 0, request_data_raw: PackedByteArray = PackedByteArray())
void | set_http_proxy(host: String, port: int)
void | set_https_proxy(host: String, port: int)
void | set_tls_options(client_options: TLSOptions)

---

## Signals

request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) 

Emitted when a request is completed.

---

## Enumerations

enum Result
Result RESULT_SUCCESS = 0

Request successful.

Result RESULT_CHUNKED_BODY_SIZE_MISMATCH = 1

Request failed due to a mismatch between the expected and actual chunked body size during transfer. Possible causes include network errors, server misconfiguration, or issues with chunked encoding.

Result RESULT_CANT_CONNECT = 2

Request failed while connecting.

Result RESULT_CANT_RESOLVE = 3

Request failed while resolving.

Result RESULT_CONNECTION_ERROR = 4

Request failed due to connection (read/write) error.

Result RESULT_TLS_HANDSHAKE_ERROR = 5

Request failed on TLS handshake.

Result RESULT_NO_RESPONSE = 6

Request does not have a response (yet).

Result RESULT_BODY_SIZE_LIMIT_EXCEEDED = 7

Request exceeded its maximum size limit, see body_size_limit.

Result RESULT_BODY_DECOMPRESS_FAILED = 8

Request failed due to an error while decompressing the response body. Possible causes include unsupported or incorrect compression format, corrupted data, or incomplete transfer.

Result RESULT_REQUEST_FAILED = 9

Request failed (currently unused).

Result RESULT_DOWNLOAD_FILE_CANT_OPEN = 10

HTTPRequest couldn't open the download file.

Result RESULT_DOWNLOAD_FILE_WRITE_ERROR = 11

HTTPRequest couldn't write to the download file.

Result RESULT_REDIRECT_LIMIT_REACHED = 12

Request reached its maximum redirect limit, see max_redirects.

Result RESULT_TIMEOUT = 13

Request failed due to a timeout. If you expect requests to take a long time, try increasing the value of timeout or setting it to 0.0 to remove the timeout completely.

---

## Property Descriptions

bool accept_gzip = true 

- void set_accept_gzip(value: bool)
- bool is_accepting_gzip()

If true, this header will be added to each request: Accept-Encoding: gzip, deflate telling servers that it's okay to compress response bodies.

Any Response body declaring a Content-Encoding of either gzip or deflate will then be automatically decompressed, and the uncompressed bytes will be delivered via request_completed.

If the user has specified their own Accept-Encoding header, then no header will be added regardless of accept_gzip.

If false no header will be added, and no decompression will be performed on response bodies. The raw bytes of the response body will be returned via request_completed.

---

int body_size_limit = -1 

- void set_body_size_limit(value: int)
- int get_body_size_limit()

Maximum allowed size for response bodies. If the response body is compressed, this will be used as the maximum allowed size for the decompressed body.

---

int download_chunk_size = 65536 

- void set_download_chunk_size(value: int)
- int get_download_chunk_size()

The size of the buffer used and maximum bytes to read per iteration. See HTTPClient.read_chunk_size.

Set this to a lower value (e.g. 4096 for 4 KiB) when downloading small files to decrease memory usage at the cost of download speeds.

---

String download_file = "" 

- void set_download_file(value: String)
- String get_download_file()

The file to download into. Will output any received file into it.

---

int max_redirects = 8 

- void set_max_redirects(value: int)
- int get_max_redirects()

Maximum number of allowed redirects.

---

float timeout = 0.0 

- void set_timeout(value: float)
- float get_timeout()

The duration to wait before a request times out, in seconds (independent of Engine.time_scale). If timeout is set to 0.0, the request will never time out.

For simple requests, such as communication with a REST API, it is recommended to set timeout to a value suitable for the server response time (commonly between 1.0 and 10.0). This will help prevent unwanted timeouts caused by variation in response times while still allowing the application to detect when a request has timed out. For larger requests such as file downloads, it is recommended to set timeout to 0.0, disabling the timeout functionality. This will help prevent large transfers from failing due to exceeding the timeout value.

---

bool use_threads = false 

- void set_use_threads(value: bool)
- bool is_using_threads()

If true, multithreading is used to improve performance.

---

## Method Descriptions

void cancel_request() 

Cancels the current request.

---

int get_body_size() const 

Returns the response body length.

Note: Some Web servers may not send a body length. In this case, the value returned will be -1. If using chunked transfer encoding, the body length will also be -1.

---

int get_downloaded_bytes() const 

Returns the number of bytes this HTTPRequest downloaded.

---

Status get_http_client_status() const 

Returns the current status of the underlying HTTPClient.

---

Error request(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: Method = 0, request_data: String = "") 

Creates request on the underlying HTTPClient. If there is no configuration errors, it tries to connect using HTTPClient.connect_to_host() and passes parameters onto HTTPClient.request().

Returns @GlobalScope.OK if request is successfully created. (Does not imply that the server has responded), @GlobalScope.ERR_UNCONFIGURED if not in the tree, @GlobalScope.ERR_BUSY if still processing previous request, @GlobalScope.ERR_INVALID_PARAMETER if given string is not a valid URL format, or @GlobalScope.ERR_CANT_CONNECT if not using thread and the HTTPClient cannot connect to host.

Note: When method is HTTPClient.METHOD_GET, the payload sent via request_data might be ignored by the server or even cause the server to reject the request (check RFC 7231 section 4.3.1 [https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.1] for more details). As a workaround, you can send data as a query string in the URL (see String.uri_encode() for an example).

Note: It's recommended to use transport encryption (TLS) and to avoid sending sensitive information (such as login credentials) in HTTP GET URL parameters. Consider using HTTP POST requests or HTTP headers for such information instead.

---

Error request_raw(url: String, custom_headers: PackedStringArray = PackedStringArray(), method: Method = 0, request_data_raw: PackedByteArray = PackedByteArray()) 

Creates request on the underlying HTTPClient using a raw array of bytes for the request body. If there is no configuration errors, it tries to connect using HTTPClient.connect_to_host() and passes parameters onto HTTPClient.request().

Returns @GlobalScope.OK if request is successfully created. (Does not imply that the server has responded), @GlobalScope.ERR_UNCONFIGURED if not in the tree, @GlobalScope.ERR_BUSY if still processing previous request, @GlobalScope.ERR_INVALID_PARAMETER if given string is not a valid URL format, or @GlobalScope.ERR_CANT_CONNECT if not using thread and the HTTPClient cannot connect to host.

---

void set_http_proxy(host: String, port: int) 

Sets the proxy server for HTTP requests.

The proxy server is unset if host is empty or port is -1.

---

void set_https_proxy(host: String, port: int) 

Sets the proxy server for HTTPS requests.

The proxy server is unset if host is empty or port is -1.

---

void set_tls_options(client_options: TLSOptions) 

Sets the TLSOptions to be used when connecting to an HTTPS server. See TLSOptions.client().
