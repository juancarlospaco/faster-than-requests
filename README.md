<meta name='keywords' content='python, requests, faster, speed, benchmark, pycurl, wget, urllib, rapido, velocidad, optimizacion, cython, pypy, urllib3, urllib2, urllib4, urllib5, urllib6, urllib7, urllib8, urllib9, pywget, cpython, http, httpclient, curl, libcurl, ssl, docker, json, ndjson, https, rapido, veloz, performance, critical, compiled, module, modulo, loc, minimalismo, minimalism, simple, small, tiny, argentina, spanish, compare, mejora, scraper, scrapy'>


# Faster-than-Requests

[![screenshot](https://source.unsplash.com/eH_ftJYhaTY/800x402 "Please Star this repo on GitHub!")](https://youtu.be/QiKwnlyhKrk?t=5)

![screenshot](temp.jpg "Please Star this repo on GitHub!")

| Library                       | Speed    | Files | LOC  | Dependencies          | Developers |
|-------------------------------|----------|-------|------|-----------------------|------------|
| PyWGET                        | `152.39` | 1     | 338  | Wget                  | >17        |
| Requests                      | `15.58`  | >20   | 2558 | >=7                   | >527       |
| Requests (cached object)      |  `5.50`  | >20   | 2558 | >=7                   | >527       |
| Urllib                        |  `4.00`  | ???   | 1200 | 0 (std lib)           | ???        |
| Urllib3                       |  `3.55`  | >40   | 5242 | 0 (No SSL), >=5 (SSL) | >188       |
| PyCurl                        |  `0.75`  | >15   | 5932 | Curl, LibCurl         | >50        |
| PyCurl (no SSL)               |  `0.68`  | >15   | 5932 | Curl, LibCurl         | >50        |
| Faster_than_requests          |  `0.45`  | 1     | 75   | 0                     | 1          |

<details>

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
- Developers counted from the Contributors list of Git.
- Speed is IRL time to complete 10000 HTTP local requests.
- Stats as of year 2019.
- x86_64 64Bit, SSD.

</details>


# Use

```python
import faster_than_requests as requests

print(requests.get("http://httpbin.org/get"))                      # GET
print(requests.post("http://httpbin.org/post", "Some Data Here"))  # POST
requests.downloads("http://example.com/foo.jpg", "output.jpg")     # See Docs for more info.
```


# API

### get()
<details>

**Description:**
Takes an URL string, makes an HTTP GET and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### post()
<details>

**Description:**
Takes an URL string, makes an HTTP POST and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### put()
<details>

**Description:**
Takes an URL string, makes an HTTP PUT and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### delete()
<details>

**Description:**
Takes an URL string, makes an HTTP DELETE and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### patch()
<details>

**Description:**
Takes an URL string, makes an HTTP PATCH and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### get2str()
<details>

**Description:**
Takes an URL string, makes an HTTP GET and returns a string with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response body, `string` type, can be empty string.

</details>

### get2str_list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, and returns a list of strings with the response Body.

**Arguments:**
- `list_of_urls` A list of the remote URLs, list type, required. Objects inside the list must be string type.

**Returns:**
List of response bodies, `list` type, values of the list are string type,
values of the list can be empty string, can be empty list.

</details>

### get2ndjson_list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of strings with the response, and writes the responses to a NDJSON file, it can accumulate several JSON responses into a single file.

**Arguments:**
- `list_of_urls` A list of the remote URLs, list type, required. Objects inside the list must be string type.
- `ndjson_file_path` Full path to a local writable NDJSON file, string type, required, file can be non-existent and it will be created, if it exists it will the overwritten.

**Returns:** None.

</details>

### get2dict()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns a dict with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### get2json()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns a Minified Computer-friendly single-line JSON with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response Body, Minified JSON, on a single line.

</details>

### get2json_pretty()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns a Pretty-Printed Human-friendly Multi-line JSON with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response Body, Pretty-Printed JSON, multi-line.

</details>

### get2assert()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns nothing, makes an assertion, useful for Unittest and Debug purposes.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `expected` Response expected content, string type, required, can be empty string.

**Returns:** None.

</details>

### getlist2list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `list_of_urls` the remote URLS, list type, required, the objects inside the list must be string type.

**Returns:**
List of response bodies, `list` type, values of the list are string type,
values of the list can be empty string, can be empty list.

</details>

### post2str()
<details>

**Description:**
Takes an URL, makes an HTTP POST, returns the response Body as string type.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response body, `string` type, can be empty string.

</details>

### post2dict()
<details>

**Description:**
Takes an URL, makes a HTTP POST on that URL, returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>

### post2json()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response, string type.

</details>

### post2json_pretty()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** Response, string type.

</details>

### post2assert()
<details>

**Description:**
Takes an URL, makes an HTTP POST on that URL, returns a response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `expected` Response expected content, string type, required, can be empty string.

**Returns:** None.

</details>

### post2list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP POST for each URL, returns a list of responses.

**Arguments:**
- `list_of_urls` the remote URLS, list type, required, the objects inside the list must be string type.

**Returns:**
List of response bodies, `list` type, values of the list are string type,
values of the list can be empty string, can be empty list.

</details>

### downloads()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.

**Returns:** None.

</details>

### downloads_list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET Download for each URL of the list.

**Arguments:**
- `list_of_urls` the remote URLS, list type, required, the objects inside the list must be string type.

**Returns:** None.

</details>

### downloads_list_delay()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET Download for each URL of the list of with a delay, optional randomized delay.

**Arguments:**
- `list_of_urls` the remote URLS, list type, required, the objects inside the list must be string type.

**Returns:** None.

</details>

[**For more Examples check the Examples.**](https://github.com/juancarlospaco/faster-than-requests/blob/master/example/example.py)

Instead of having a pair of functions with a lot of arguments that you should provide to make it work,
we have tiny functions with very few arguments that do one thing and do it as fast as possible.

A lot of functions are oriented to Data Science, Big Data, Open Data, Web Scrapping for HTTP REST JSON APIs.

<details>
  <summary>Low Level API Extras</summary>

To control the default values the following environment variables are available:
- `requests_timeout` `int` type, must be a non-zero positive value, milliseconds precision.
- `requests_maxredirects` `int` type, must be a non-zero positive value.
- `requests_useragent` `str` type, can be empty string.
- `requests_debugprogress` `bool` type, slows down performance, not recommended for general use.

Functions do not have internal `try: except:` blocks,
so you can wrap them inside `try: except:` blocks if you need very resilient code.

</details>


# Install

- `pip install faster_than_requests`


# Docker

- Make a quick test drive on Docker!.

```bash
$ ./build-docker.sh
$ ./run-docker.sh
$ ./server4benchmarks &  # Inside Docker.
$ python3 benchmark.py   # Inside Docker.
```


# Platforms

- ✅ Linux
- ✅ Windows
- ✅ Mac
- ✅ Android
- ✅ Raspberry Pi
- ✅ BSD


# Extras

More Faster Libraries...

- https://github.com/juancarlospaco/faster-than-csv#faster-than-csv
- https://github.com/juancarlospaco/faster-than-walk#faster-than-walk
- We want to make Open Source faster, better, stronger.


# Requisites

- Python 3.
- GCC.
- 64 Bit.


# FAQ

- Whats the idea, inspiration, reason, etc ?.

[Feel free to Fork, Clone, Download, Improve, Reimplement, Play with this Open Source. Make it 10 times faster, 10 times smaller.](http://tonsky.me/blog/disenchantment)

- This works with SSL ?.

Yes.

- This works without SSL ?.

Yes.

- This requires Cython ?.

No.

- This runs on PyPy ?.

No.

- This runs on Python2 ?.

I dunno. (Not supported)

- This runs on 32Bit ?.

No.

- This runs with Clang ?.

No.

- How can I Install it ?.

`pip install faster_than_requests`

- Developer Documentation ?.

[Yes.](https://github.com/juancarlospaco/faster-than-requests/raw/master/faster_than_requests_DOCS.zip)
(Zip because GitHub marks the Repo as being JavaScript)

- Where to get help ?.

https://github.com/juancarlospaco/faster-than-requests/issues

- How to set the URL ?.

`url="http://example.com"` (1st argument always).

- How to set the HTTP Method ?.

`http_method="get"` for GET.

`http_method="post"` for POST.

`http_method="put"` for PUT.

`http_method="patch"` for PATCH.

- How to set the HTTP Body ?.

`body="my body"`

- How to set an HTTP Header key=value ?.

`("key", "value")`

- How to set HTTP Proxy ?.

`export https_proxy = "http://yourProxyUrl:8080"`

`export http_proxy =  "http://yourProxyUrl:8080"`

Standard Linux Bash environment variables for proxy.

It will be automatically read from the environment variables.

- Whats NDJSON ?.

https://github.com/ndjson/ndjson-spec

- How can be faster than PyCurl ?.

I dunno.
