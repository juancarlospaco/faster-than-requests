import faster_than_requests as requests

print(requests.get("http://httpbin.org/get"))              # HTTP GET.

print(requests.post("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))      # HTTP POST.

print(requests.put("http://httpbin.org/put", """{"foo": "bar", "baz": true}"""))        # HTTP PUT.

print(requests.delete("http://httpbin.org/delete"))        # HTTP DELETE.

print(requests.patch("http://httpbin.org/patch", """{"foo": "bar", "baz": true}"""))    # HTTP PATCH.

print(requests.get2str("http://httpbin.org/get"))          # HTTP GET body only to string response.

print(requests.get2dict("http://httpbin.org/get"))         # HTTP GET body only to dictionary response.

print(requests.get2json("http://httpbin.org/get"))         # HTTP GET body only to JSON response.

print(requests.get2json_pretty("http://httpbin.org/get"))  # HTTP GET body only to Pretty-Printed JSON response.

print(requests.post2str("http://httpbin.org/post", """{"foo": "bar", "baz": true}"""))  # HTTP POST data only to string response.

print(requests.post2dict("http://httpbin.org/post", """{"foo": "bar", "baz": true}""")) # HTTP POST data only to dictionary response.

print(requests.post2json("http://httpbin.org/post", """{"foo": "bar", "baz": true}""")) # HTTP POST data to JSON response.

print(requests.post2json_pretty("http://httpbin.org/post", """{"foo": "bar", "baz": true}""")) # HTTP POST data to Pretty-Printed JSON response.

print(requests.requests("http://httpbin.org/get", "get", "", [("key", "value")]))       # HTTP GET/POST/PUT/DELETE/PATCH,Headers,etc.

print(requests.downloads("http://httpbin.org/image/jpeg", "foo.jpeg"))                  # HTTP GET Download 1 file.

print(requests.get2str_list(["http://httpbin.org/json", "http://httpbin.org/xml"]))     # HTTP GET body to string from a list.

print(requests.get2ndjson_list(["http://httpbin.org/json",
                                "http://httpbin.org/json"], "output.ndjson"))           # HTTP GET body to NDJSON file from a list.

print(requests.downloads_list([("http://httpbin.org/image/jpeg", "foo.jpg"),            # HTTP GET Download a list of files.
                               ("http://httpbin.org/image/svg",  "bar.svg")]))

print(requests.downloads_list_delay([("http://httpbin.org/image/jpeg", "foo.jpg"),      # HTTP GET Download a list of files.
                                     ("http://httpbin.org/image/svg",  "bar.svg")],
                                    3))  # 3 Seconds Delay

print(requests.setHeaders([("key", "value")]))             # Set HTTP Headers example.
