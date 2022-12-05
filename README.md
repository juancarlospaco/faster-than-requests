<meta name='keywords' content='python, requests, faster, speed, benchmark, pycurl, wget, urllib, rapido, velocidad, optimizacion, cython, pypy, urllib3, urllib2, urllib4, urllib5, urllib6, urllib7, urllib8, urllib9, pywget, cpython, http, httpclient, curl, libcurl, ssl, docker, json, ndjson, https, rapido, veloz, performance, critical, compiled, module, modulo, loc, minimalismo, minimalism, simple, small, tiny, argentina, spanish, compare, mejora, scraper, scrapy, data science, open data, open api'>


# Faster-than-Requests

[![screenshot](https://source.unsplash.com/eH_ftJYhaTY/800x402 "Please Star this repo on GitHub!")](https://youtu.be/QiKwnlyhKrk?t=5)

![screenshot](https://raw.githubusercontent.com/juancarlospaco/faster-than-requests/master/img/temp.png "Please Star this repo on GitHub!")

![](https://img.shields.io/github/languages/top/juancarlospaco/faster-than-requests?style=for-the-badge)
![](https://img.shields.io/github/stars/juancarlospaco/faster-than-requests?style=for-the-badge "Star faster-than-requests on GitHub!")
![](https://img.shields.io/maintenance/yes/2022?style=for-the-badge)
![](https://img.shields.io/github/languages/code-size/juancarlospaco/faster-than-requests?style=for-the-badge)
![](https://img.shields.io/github/issues-raw/juancarlospaco/faster-than-requests?style=for-the-badge "Bugs")
![](https://img.shields.io/github/issues-pr-raw/juancarlospaco/faster-than-requests?style=for-the-badge "PRs")
![](https://img.shields.io/github/last-commit/juancarlospaco/faster-than-requests?style=for-the-badge "Commits")

<img src="http://feeds.feedburner.com/RecentCommitsToFaster-than-requestsmaster.1.gif" title="Recent Commits to Faster Than Requests" width="99%" height="75px">

| Library                       | Speed    | Files | LOC  | Dependencies          | Developers | WebSockets                    | Multi-Threaded Web Scraper Built-in |
|-------------------------------|----------|-------|------|-----------------------|------------|-------------------------------|-------------------------------------|
| PyWGET                        | `152.39` | 1     | 338  | Wget                  | >17        | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| Requests                      | `15.58`  | >20   | 2558 | >=7                   | >527       | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| Requests (cached object)      |  `5.50`  | >20   | 2558 | >=7                   | >527       | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| Urllib                        |  `4.00`  | ???   | 1200 | 0 (std lib)           | ???        | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| Urllib3                       |  `3.55`  | >40   | 5242 | 0 (No SSL), >=5 (SSL) | >188       | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| PyCurl                        |  `0.75`  | >15   | 5932 | Curl, LibCurl         | >50        | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| PyCurl (no SSL)               |  `0.68`  | >15   | 5932 | Curl, LibCurl         | >50        | :negative_squared_cross_mark: | :negative_squared_cross_mark:       |
| Faster_than_requests          |  `0.40`  | 1     | 999  | 0                     | 1          | :heavy_check_mark:            | :heavy_check_mark: 7, [One-Liner](https://github.com/juancarlospaco/faster-than-requests/blob/master/examples/multithread_web_scraper.py#L2) |

<details>

- Lines Of Code counted using [CLOC](https://github.com/AlDanial/cloc).
- Direct dependencies of the package when ready to run.
- Benchmarks run on Docker from Dockerfile on this repo.
- Developers counted from the Contributors list of Git.
- Speed is IRL time to complete 10000 HTTP local requests.
- Stats as of year 2020.
- x86_64 64Bit AMD, SSD, Arch Linux.

</details>


# Use

```python
import faster_than_requests as requests

requests.get("http://httpbin.org/get")                                      # GET
requests.post("http://httpbin.org/post", "Some Data Here")                  # POST
requests.download("http://example.com/foo.jpg", "out.jpg")                  # Download a file
requests.scraper(["http://foo.io", "http://bar.io"], threads=True)          # Multi-Threaded Web Scraper
requests.scraper5(["http://foo.io"], sqlite_file_path="database.db")        # URL-to-SQLite Web Scraper
requests.scraper6(["http://python.org"], ["(www|http:|https:)+[^\s]+[\w]"]) # Regex-powered Web Scraper
requests.scraper7("http://python.org", "body > div.someclass a#someid"])    # CSS Selector Web Scraper
requests.websocket_send("ws://echo.websocket.org", "data here")             # WebSockets Binary/Text
```

# Table Of Contents

|                         |                             |                               |                           |
|:-----------------------:|:---------------------------:|:-----------------------------:|:-------------------------:|
| [**get()**](#get)       | [**post()**](#post)         | [**put()**](#put)             | [**head()**](#head)       |
| [**patch()**](#patch)   | [**delete()**](#delete)     | [download()](#download)       | [download2()](#download2) |
| [scraper()](#scraper)   | [scraper2()](#scraper2)     | [scraper3()](#scraper3)       | [scraper4()](#scraper4)   |
| [scraper5()](#scraper5) | [scraper6()](#scraper6)     | [scraper7()](#scraper7)       | [get2str()](#get2str)     |
| [get2str2()](#get2str2) |                             | [get2dict()](#get2dict)       | [get2json()](#get2json)   |
| [post2str()](#post2str) | [post2dict()](#post2dict)   | [post2json()](#post2json)     | [post2list()](#post2list) |
| [download3()](#download3) | [tuples2json()](#tuples2json) | [set_headers()](#set_headers) | [multipartdata2str()](#multipartdata2str) |
| [datauri()](#datauri)   | [urlparse()](#urlparse)     | [urlencode()](#urlencode)     | [urldecode()](#urldecode) |
| [encodequery()](#encodequery) | [encodexml()](#encodexml) | [debugs()](#debugs)       | [minifyhtml()](#minifyhtml) |
| [How to set DEBUG mode](#how-to-set-debug-mode) | [websocket_send()](#websocket_send) | [websocket_ping()](#websocket_ping) | |
| [How to Install](#install) | [How to Windows](#windows) | [FAQ](#faq) | [Get Help](https://github.com/juancarlospaco/faster-than-requests/issues/new/choose) |
| [PyPI](https://pypi.org/project/faster-than-requests) | [GitHub Actions / CI](https://github.com/juancarlospaco/faster-than-requests/actions?query=workflow%3APYTHON) | [Examples](https://github.com/juancarlospaco/faster-than-requests/tree/master/examples) | [Sponsors](#sponsors) |


# get()
<details>

**Description:**
Takes an URL string, makes an HTTP GET and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://dev.to`.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.get("http://example.com")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


**See Also:**
[get2str()](https://github.com/juancarlospaco/faster-than-requests#get2str) and [get2str2()](https://github.com/juancarlospaco/faster-than-requests#get2str2)

</details>



# post()
<details>

**Description:**
Takes an URL string, makes an HTTP POST and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://dev.to`.
- `body` the Body data, string type, required, can be empty string. To Post Files use this too.
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.post("http://httpbin.org/post", "Some Data Here")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


</details>



# put()
<details>

**Description:**
Takes an URL string, makes an HTTP PUT and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://nim-lang.org`.
- `body` the Body data, string type, required, can be empty string.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.put("http://httpbin.org/post", "Some Data Here")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


</details>



# delete()
<details>

**Description:**
Takes an URL string, makes an HTTP DELETE and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://nim-lang.org`.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.delete("http://example.com/api/something")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


</details>



# patch()
<details>

**Description:**
Takes an URL string, makes an HTTP PATCH and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://archlinux.org`.
- `body` the Body data, string type, required, can be empty string.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.patch("http://example.com", "My Body Data Here")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


</details>


# head()
<details>

**Description:**
Takes an URL string, makes an HTTP HEAD and returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://nim-lang.org`.
- `user_agent` User Agent, string type, optional, should not be empty string.
- `max_redirects` Maximum Redirects, int type, optional, defaults to `9`, example `5`, example `1`.
- `proxy_url` Proxy URL, string type, optional, if is `""` then NO Proxy is used, defaults to `""`, example `172.15.256.1:666`.
- `proxy_auth` Proxy Auth, string type, optional, if `proxy_url` is `""` then is ignored, defaults to `""`.
- `timeout` Timeout, int type, optional, Milliseconds precision, defaults to `-1`, example `9999`, example `666`.
- `http_headers` HTTP Headers, List of Tuples type, optional, example `[("key", "value")]`, example `[("DNT", "1")]`.

Examples:

```python
import faster_than_requests as requests
requests.head("http://example.com/api/something")
```

**Returns:**
Response, `list` type, values of the list are string type,
values of the list can be empty string, the lenght of the list is always 7 items,
the values are like `[body, type, status, version, url, length, headers]`,
you can use `to_json()` to get JSON or `to_dict()` to get a dict or `to_tuples()` to get a tuples.


</details>


# to_dict()
<details>

**Description:** Convert the response to dict.

**Arguments:**
- `ftr_response` Response from any of the functions that return a response.

**Returns:** Response, `dict` type.

</details>


# to_json()
<details>

**Description:** Convert the response to Pretty-Printed JSON.

**Arguments:**
- `ftr_response` Response from any of the functions that return a response.

**Returns:** Response, Pretty-Printed JSON.

</details>


# to_tuples()
<details>

**Description:** Convert the response to a list of tuples.

**Arguments:**
- `ftr_response` Response from any of the functions that return a response.

**Returns:** Response, list of tuples.

</details>


# Extras: Go beyond requests

## scraper()
<details>

**Description:**
Multi-Threaded Ready-Made URL-Deduplicating Web Scraper from a list of URLs.

![](misc/multithread-scraper.png)

All arguments are optional, it only needs the URL to get to work.
Scraper is designed to be like a 2-Step Web Scraper, that makes a first pass collecting all URL Links and then a second pass actually fetching those URLs.
Requests are processed asynchronously. This means that it doesn’t need to wait for a request to be finished to be processed.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["http://example.io"]`.
- `html_tag` HTML Tag to parse, string type, optional, defaults to `"a"` being Links, example `"h1"`.
- `case_insensitive` Case Insensitive, `True` for Case Insensitive, boolean type, optional, defaults to `True`, example `True`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `threads` Passing `threads = True` uses Multi-Threading, `threads = False` will Not use Multi-Threading, boolean type, optional, omitting it will Not use Multi-Threading.

Examples:

```python
import faster_than_requests as requests
requests.scraper(["https://nim-lang.org", "http://example.com"], threads=True)
```

**Returns:** Scraped Webs.

</details>



## scraper2()
<details>

**Description:**
Multi-Tag Ready-Made URL-Deduplicating Web Scraper from a list of URLs.
All arguments are optional, it only needs the URL to get to work.
Scraper is designed to be like a 2-Step Web Scraper, that makes a first pass collecting all URL Links and then a second pass actually fetching those URLs.
Requests are processed asynchronously. This means that it doesn’t need to wait for a request to be finished to be processed.
You can think of this scraper as a parallel evolution of the original scraper.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["http://example.io"]`.
- `list_of_tags` List of HTML Tags to parse, List type, optional, defaults to `["a"]` being Links, example `["h1", "h2"]`.
- `case_insensitive` Case Insensitive, `True` for Case Insensitive, boolean type, optional, defaults to `True`, example `True`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `verbose` Verbose, print to terminal console the progress, bool type, optional, defaults to `True`, example `False`.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value, example `42`.
- `threads` Passing `threads = True` uses Multi-Threading, `threads = False` will Not use Multi-Threading, boolean type, optional, omitting it will Not use Multi-Threading.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `5`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.

Examples:

```python
import faster_than_requests as requests
requests.scraper2(["https://nim-lang.org", "http://example.com"], list_of_tags=["h1", "h2"], case_insensitive=False)
```

**Returns:** Scraped Webs.

</details>


## scraper3()
<details>

**Description:**
Multi-Tag Ready-Made URL-Deduplicating Web Scraper from a list of URLs.

![](misc/multitag-scraper.png)

This Scraper is designed with lots of extra options on the arguments.
All arguments are optional, it only needs the URL to get to work.
Scraper is designed to be like a 2-Step Web Scraper, that makes a first pass collecting all URL Links and then a second pass actually fetching those URLs.
You can think of this scraper as a parallel evolution of the original scraper.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["http://example.io"]`.
- `list_of_tags` List of HTML Tags to parse, List type, optional, defaults to `["a"]` being Links, example `["h1", "h2"]`.
- `case_insensitive` Case Insensitive, `True` for Case Insensitive, boolean type, optional, defaults to `True`, example `True`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `start_with` Match at the start of the line, similar to `str().startswith()`, string type, optional, example `"<cite "`.
- `ends_with` Match at the end of the line, similar to `str().endswith()`,  string type, optional, example `"</cite>"`.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value, example `42`.
- `line_start` Slice the line at the start by this index, integer type, optional, defaults to `0` meaning no slicing since string start at index 0, example `3` cuts off 3 letters of the line at the start.
- `line_end` Slice the line at the end by this *reverse* index, integer type, optional, defaults to `1` meaning no slicing since string ends at reverse index 1, example `9` cuts off 9 letters of the line at the end.
- `pre_replacements` List of tuples of strings to replace *before* parsing, replacements are in parallel, List type, optional, example `[("old", "new"), ("red", "blue")]` will replace `"old"` with `"new"` and will replace `"red"` with `"blue"`.
- `post_replacements` List of tuples of strings to replace *after* parsing, replacements are in parallel, List type, optional, example `[("old", "new"), ("red", "blue")]` will replace `"old"` with `"new"` and will replace `"red"` with `"blue"`.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `5`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.
- `verbose` Verbose, print to terminal console the progress, bool type, optional, defaults to `True`, example `False`.

Examples:

```python
import faster_than_requests as requests
requests.scraper3(["https://nim-lang.org", "http://example.com"], list_of_tags=["h1", "h2"], case_insensitive=False)
```

**Returns:** Scraped Webs.

</details>


## scraper4()
<details>

**Description:**
Images and Photos Ready-Made Web Scraper from a list of URLs.

![](misc/photo-scraper.png)

The Images and Photos scraped from the first URL will be put into a new sub-folder named `0`,
Images and Photos scraped from the second URL will be put into a new sub-folder named `1`, and so on.
All arguments are optional, it only needs the URL to get to work.
You can think of this scraper as a parallel evolution of the original scraper.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["https://unsplash.com/s/photos/cat", "https://unsplash.com/s/photos/dog"]`.
- `case_insensitive` Case Insensitive, `True` for Case Insensitive, boolean type, optional, defaults to `True`, example `True`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `visited_urls` Do not visit same URL twice, even if redirected into, keeps track of visited URLs, bool type, optional, defaults to `True`.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value, example `42`.
- `folder` Directory to download Images and Photos, string type, optional, defaults to current folder, must not be empty string, example `/tmp`.
- `force_extension` Force file extension to be this file extension, string type, optional, defaults to `".jpg"`, must not be empty string, example `".png"`.
- `https_only` Force to download images on Secure HTTPS only ignoring plain HTTP, sometimes HTTPS may redirect to HTTP, bool type, optional, defaults to `False`, example `True`.
- `html_output` Collect all scraped Images and Photos into 1 HTML file with all elements scraped, bool type, optional, defaults to `True`, example `False`.
- `csv_output` Collect all scraped URLs into 1 CSV file with all links scraped, bool type, optional, defaults to `True`, example `False`.
- `verbose` Verbose, print to terminal console the progress, bool type, optional, defaults to `True`, example `False`.
- `print_alt` print to terminal console the `alt` attribute of the Images and Photos, bool type, optional, defaults to `False`, example `True`.
- `picture` Scrap images from the new HTML5 `<picture>` tags instead of `<img>` tags, `<picture>` are Responsive images for several resolutions but also you get duplicated images, bool type, optional, defaults to `False`, example `True`.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `5`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.

Examples:

```python
import faster_than_requests as requests
requests.scraper4(["https://unsplash.com/s/photos/cat", "https://unsplash.com/s/photos/dog"])
```

**Returns:** None.

</details>


## scraper5()
<details>

**Description:**
Recursive Web Scraper to SQLite Database, you give it an URL, it gives back an SQLite.

![](misc/sqlite-scraper.png)

SQLite database can be visualized with any SQLite WYSIWYG, like https://sqlitebrowser.org
If the script gets interrupted like with CTRL+C it will try its best to keep data consistent.
Additionally it will create a CSV file with all the scraped URLs.
HTTP Headers are stored as Pretty-Printed JSON.
Date and Time are stored as Unix Timestamps.
All arguments are optional, it only needs the URL and SQLite file path to get to work.
You can think of this scraper as a parallel evolution of the original scraper.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["https://unsplash.com/s/photos/cat", "https://unsplash.com/s/photos/dog"]`.
- `sqlite_file_path` Full file path to a new SQLite Database, must be `.db` file extension, string type, required, must not be empty string, example `"scraped_data.db"`.
- `skip_ends_with` Skip the URL if ends with this pattern, list type, optional, must not be empty list, example `[".jpg", ".pdf"]`.
- `case_insensitive` Case Insensitive, `True` for Case Insensitive, boolean type, optional, defaults to `True`, example `True`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `visited_urls` Do not visit same URL twice, even if redirected into, keeps track of visited URLs, bool type, optional, defaults to `True`.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value, example `42`.
- `https_only` Force to download images on Secure HTTPS only ignoring plain HTTP, sometimes HTTPS may redirect to HTTP, bool type, optional, defaults to `False`, example `True`.
- `only200` Only commit to Database the successful scraping pages, ignore all errors, bool type, optional, example `True`.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `5`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `max_loops` Maximum total Loops to do while scraping, like a global guard for infinite redirections, integer type, optional, example `999`.
- `max_deep` Maximum total scraping Recursive Deep, like a global guard for infinite deep recursivity, integer type, optional, example `999`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.

Examples:

```python
import faster_than_requests as requests
requests.scraper5(["https://example.com"], "scraped_data.db")
```

**Returns:** None.

</details>


## scraper6()
<details>

**Description:**
Regex powered Web Scraper from a list of URLs.
Scrap web content using a list of Perl Compatible Regular Expressions (PCRE standard).
You can configure the Regular Expressions to be case insensitive or multiline or extended.

This Scraper is designed for developers that know Regular Expressions.
[Learn Regular Expressions.](https://github.com/ziishaned/learn-regex#translations)

All arguments are optional, it only needs the URL and the Regex to get to work.
You can think of this scraper as a parallel evolution of the original scraper.

**Regex Arguments:**
(Arguments focused on Regular Expression parsing and matching)

- `list_of_regex` List of Perl Compatible Regular Expressions (PCRE standard) to match the URL against, List type, required, example `["(www|http:|https:)+[^\s]+[\w]"]`.
- `case_insensitive` Case Insensitive Regular Expressions, do caseless matching, `True` for Case Insensitive, boolean type, optional, defaults to `False`, example `True`.
- `multiline` Multi-Line Regular Expressions, `^` and `$` match newlines within data, boolean type, optional, defaults to `False`, example `True`.
- `extended` Extended Regular Expressions, ignore all whitespaces and `#` comments, boolean type, optional, defaults to `False`, example `True`.
- `dot` Dot `.` matches anything, including new lines, boolean type, optional, defaults to `False`, example `True`.
- `start_with` Perl Compatible Regular Expression to match at the start of the line, similar to `str().startswith()` but with Regular Expressions, string type, optional.
- `ends_with`  Perl Compatible Regular Expression to match at the end of the line,  similar to `str().endswith()` but with Regular Expressions, string type, optional.
- `post_replacement_regex` Perl Compatible Regular Expressions (PCRE standard) to replace *after* parsing, string type, optional, this option works with `post_replacement_by`, this is like a Regex post-processing, this option is for experts on Regular Expressions.
- `post_replacement_by` string **to replace by** *after* parsing, string type, optional, this option works with `post_replacement_regex`, this is like a Regex post-processing, this option is for experts on Regular Expressions.
- `re_start` Perl Compatible Regular Expression matchs start at this index, positive integer type, optional, defaults to `0`, this option is for experts on Regular Expressions.

**Arguments:**
- `list_of_urls` List of URLs, URL must be string type, required, must not be empty list, example `["http://example.io"]`.
- `deduplicate_urls` Deduplicate `list_of_urls` removing repeated URLs, boolean type, optional, defaults to `False`, example `False`.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value, example `42`.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `5`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.
- `verbose` Verbose, print to terminal console the progress, bool type, optional, defaults to `True`, example `False`.

Examples:

```python
import faster_than_requests as requests
requests.scraper6(["http://nim-lang.org", "http://python.org"], ["(www|http:|https:)+[^\s]+[\w]"])
```

**Returns:** Scraped Webs.

</details>


## scraper7()
<details>

![](https://raw.githubusercontent.com/juancarlospaco/faster-than-requests/master/css_selectors.png)

**Description:**
CSS Selector powered Web Scraper. Scrap web content using a CSS Selector.
The CSS Syntax does NOT take Regex nor Regex-like syntax nor literal tag attribute values.

All arguments are optional, it only needs the URL and CSS Selector to get to work.
You can think of this scraper as a parallel evolution of the original scraper.

**Arguments:**
- `url` The URL, string type, required, must not be empty string, example `"http://python.org"`.
- `css_selector` CSS Selector, string type, required, must not be empty string, example `"body nav.class ul.menu > li > a"`.
- `agent` User Agent, string type, optional, must not be empty string.
- `redirects` Maximum Redirects, integer type, optional, defaults to `9`, must be positive integer.
- `timeout` Timeout, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `-1`, must be a positive integer value, example `42`.
- `header` HTTP Header, any HTTP Headers can be put here, list type, optional, example `[("key", "value")]`.
- `proxy_url` HTTPS Proxy Full URL, string type, optional, must not be empty string.
- `proxy_auth` HTTPS Proxy Authentication, string type, optional, defaults to `""`, empty string is ignored.

Examples:

```python
import faster_than_requests as requests
requests.scraper7("http://python.org", "body > div.class a#someid")
```

```python
import faster_than_requests as requests
requests.scraper7("https://nim-lang.org", "a.pure-menu-link")

[
  '<a class="pure-menu-link" href="/blog.html">Blog</a>',
  '<a class="pure-menu-link" href="/features.html">Features</a>',
  '<a class="pure-menu-link" href="/install.html">Download</a>',
  '<a class="pure-menu-link" href="/learn.html">Learn</a>',
  '<a class="pure-menu-link" href="/documentation.html">Documentation</a>',
  '<a class="pure-menu-link" href="https://forum.nim-lang.org">Forum</a>',
  '<a class="pure-menu-link" href="https://github.com/nim-lang/Nim">Source</a>'
]
```

More examples:
https://github.com/juancarlospaco/faster-than-requests/blob/master/examples/web_scraper_via_css_selectors.py

**Returns:** Scraped Webs.

</details>


## websocket_ping()
<details>

**Description:**
WebSocket Ping.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `"ws://echo.websocket.org"`.
- `data` data to send, string type, optional, can be empty string, default is empty string, example `""`.
- `hangup` Close the Socket without sending a close packet, optional, default is `False`, not sending close packet can be faster.

Examples:

```python
import faster_than_requests as requests
requests.websocket_ping("ws://echo.websocket.org")
```

**Returns:** Response, `string` type, can be empty string.

</details>


## websocket_send()
<details>

**Description:**
WebSocket send data, binary or text.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `"ws://echo.websocket.org"`.
- `data` data to send, string type, optional, can be empty string, default is empty string, example `""`.
- `is_text` if `True` data is sent as Text else as Binary, optional, default is `False`.
- `hangup` Close the Socket without sending a close packet, optional, default is `False`, not sending close packet can be faster.

Examples:

```python
import faster_than_requests as requests
requests.websocket_send("ws://echo.websocket.org", "data here")
```

**Returns:** Response, `string` type.

</details>


## get2str()
<details>

**Description:**
Takes an URL string, makes an HTTP GET and returns a string with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://archlinux.org`.

Examples:

```python
import faster_than_requests as requests
requests.get2str("http://example.com")
```

**Returns:** Response body, `string` type, can be empty string.

</details>



## get2str2()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, and returns a list of strings with the response Body.
This makes all `GET` fully parallel, in a single Thread, in a single Process.

**Arguments:**
- `list_of_urls` A list of the remote URLs, list type, required. Objects inside the list must be string type.

Examples:

```python
import faster_than_requests as requests
requests.get2str2(["http://example.com/foo", "http://example.com/bar"]) # Parallel GET
```

**Returns:**
List of response bodies, `list` type, values of the list are string type,
values of the list can be empty string, can be empty list.

</details>


## get2dict()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns a dict with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://alpinelinux.org`.

Examples:

```python
import faster_than_requests as requests
requests.get2dict("http://example.com")
```

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>



## get2json()
<details>

**Description:**
Takes an URL, makes an HTTP GET, returns a Minified Computer-friendly single-line JSON with the response Body.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string, example `https://alpinelinux.org`.
- `pretty_print` Pretty Printed JSON, optional, defaults to `False`.

Examples:

```python
import faster_than_requests as requests
requests.get2json("http://example.com", pretty_print=True)
```

**Returns:** Response Body, Pretty-Printed JSON.

</details>



## post2str()
<details>

**Description:**
Takes an URL, makes an HTTP POST, returns the response Body as string type.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.

Examples:

```python
import faster_than_requests as requests
requests.post2str("http://example.com/api/foo", "My Body Data Here")
```

**Returns:** Response body, `string` type, can be empty string.

</details>



## post2dict()
<details>

**Description:**
Takes an URL, makes a HTTP POST on that URL, returns a dict with the response.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.

Examples:

```python
import faster_than_requests as requests
requests.post2dict("http://example.com/api/foo", "My Body Data Here")
```

**Returns:**
Response, `dict` type, values of the dict are string type,
values of the dict can be empty string, but keys are always consistent.

</details>



## post2json()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `body` the Body data, string type, required, can be empty string.
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.
- `pretty_print` Pretty Printed JSON, optional, defaults to `False`.

Examples:

```python
import faster_than_requests as requests
requests.post2json("http://example.com/api/foo", "My Body Data Here")
```

**Returns:** Response, string type.

</details>



## post2list()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP POST for each URL, returns a list of responses.

**Arguments:**
- `list_of_urls` the remote URLS, list type, required, the objects inside the list must be string type.
- `body` the Body data, string type, required, can be empty string.
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.

Examples:

```python
import faster_than_requests as requests
requests.post2list("http://example.com/api/foo", "My Body Data Here")
```

**Returns:**
List of response bodies, `list` type, values of the list are string type,
values of the list can be empty string, can be empty list.

</details>



## download()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET for each URL, returns a list of responses.

**Arguments:**
- `url` the remote URL, string type, required, must not be empty string.
- `filename` the local filename, string type, required, must not be empty string, full path recommended, can be relative path, includes file extension.

Examples:

```python
import faster_than_requests as requests
requests.download("http://example.com/api/foo", "my_file.ext")
```

**Returns:** None.

</details>



## download2()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET Download for each URL of the list.

**Arguments:**
- `list_of_files` list of tuples, tuples must be 2 items long, first item is URL and second item is filename.
The remote URL, string type, required, must not be empty string, is the first item on the tuple.
The local filename, string type, required, must not be empty string, can be full path, can be relative path, must include file extension.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value.
- `threads` Passing `threads = True` uses Multi-Threading, `threads = False` will Not use Multi-Threading, omitting it will Not use Multi-Threading.

Examples:

```python
import faster_than_requests as requests
requests.download2([("http://example.com/cat.jpg", "kitten.jpg"), ("http://example.com/dog.jpg", "doge.jpg")])
```

**Returns:** None.

</details>


## download3()
<details>

**Description:**
Takes a list of URLs, makes 1 HTTP GET Download for each URL of the list.
It will Retry again and again in loop until the file is downloaded or `tries` is `0`, whatever happens first.
If all retries have failed and `tries` is `0` it will error out.

**Arguments:**
- `list_of_files` list of tuples, tuples must be 2 items long, first item is URL and second item is filename.
The remote URL, string type, required, must not be empty string, is the first item on the tuple.
The local filename, string type, required, must not be empty string, can be full path, can be relative path, must include file extension.
- `delay` Delay between a download and the next one, MicroSeconds precision (1000 = 1 Second), integer type, optional, defaults to `0`, must be a positive integer value.
- `tries` how many Retries to try, positive integer type, optional, defaults to `9`, must be a positive integer value.
- `backoff` Back-Off between retries, positive integer type, optional, defaults to `2`, must be a positive integer value.
- `jitter` Jitter applied to the Back-Off between retries (Modulo math operation), positive integer type, optional, defaults to `2`, must be a positive integer value.
- `verbose` be Verbose, bool type, optional, defaults to `True`.

**Returns:** None.

Examples:

```python
import faster_than_requests as requests
requests.download3(
  [("http://INVALID/cat.jpg", "kitten.jpg"), ("http://INVALID/dog.jpg", "doge.jpg")],
  delay = 1, tries = 9, backoff = 2, jitter = 2, verbose = True,
)
```

Examples of Failed download output (intended):

```console
$ python3 example_fail_all_retry.py

Retry: 3 of 3
(url: "http://NONEXISTENT", filename: "a.json")
No such file or directory
Additional info: "Name or service not known"
Retrying in 64 microseconds...
Retry: 2 of 3
(url: "http://NONEXISTENT", filename: "a.json")
No such file or directory
Additional info: "Name or service not known"
Retrying in 128 microseconds (Warning: This is the last Retry!).
Retry: 1 of 3
(url: "http://NONEXISTENT", filename: "a.json")
No such file or directory
Additional info: "Name or service not known"
Retrying in 256 microseconds (Warning: This is the last Retry!).
Traceback (most recent call last):
  File "example_fail_all_retry.py", line 3, in <module>
    downloader.download3()
  ...

$
```

</details>


## set_headers()
<details>

**Description:**
Set the HTTP Headers from the arguments.
**This is for the functions that NOT allow `http_headers` as argument.**

**Arguments:**
- `http_headers` HTTP Headers, List of Tuples type, required, example `[("key", "value")]`, example `[("DNT", "1")]`.
  List of tuples, tuples must be 2 items long, must not be empty list, must not be empty tuple,
  the first item of the tuple is the key and second item of the tuple is value,
  keys must not be empty string, values can be empty string, both must the stripped.

Examples:

```python
import faster_than_requests as requests
requests.set_headers(headers = [("key", "value")])
```

```python
import faster_than_requests as requests
requests.set_headers([("key0", "value0"), ("key1", "value1")])
```

```python
import faster_than_requests as requests
requests.set_headers([("content-type", "text/plain"), ("dnt", "1")])
```

**Returns:** None.

</details>


## multipartdata2str()
<details>

**Description:**
Takes MultiPart Data and returns a string representation. Converts MultipartData to 1 human readable string.
The human-friendly representation is not machine-friendly, so is not Serialization nor Stringification, just for humans.
It is faster and different than stdlib `parse_multipart`.

**Arguments:**
- `multipart_data` MultiPart data, optional, list of tupes type, must not be empty list, example `[("key", "value")]`.

Examples:

```python
import faster_than_requests as requests
requests.multipartdata2str([("key", "value")])
```

**Returns:** string.

</details>


## datauri()
<details>

**Description:**
Takes data and returns a [standard Base64 Data URI (RFC-2397).](https://tools.ietf.org/html/rfc2397)
At the time of writing Python stdlib does not have a function that returns Data URI (RFC-2397) on `base64` module.
This can be used as URL on HTML/CSS/JS. It is faster and different than stdlib `base64`.

**Arguments:**
- `data` Arbitrary Data, string type, required.
- `mime` MIME Type of `data`, string type, required, example `"text/plain"`.
- `encoding` Encoding, string type, required, defaults to `"utf-8"`, example `"utf-8"`, `"utf-8"` is recommended.

Examples:

```python
import faster_than_requests as requests
requests.datauri("Nim", "text/plain")
```

**Returns:** string.

</details>


## urlparse()
<details>

**Description:**
Parse any URL and return parsed primitive values like
`scheme`, `username`, `password`, `hostname`, `port`, `path`, `query`, `anchor`, `opaque`, etc.
It is faster and different than stdlib `urlparse`.

**Arguments:**
- `url` The URL, string type, required.

Examples:

```python
import faster_than_requests as requests
requests.urlparse("https://nim-lang.org")
```

**Returns:** `scheme`, `username`, `password`, `hostname`, `port`, `path`, `query`, `anchor`, `opaque`, etc.

</details>


## urlencode()
<details>

**Description:**
Encodes a URL according to RFC-3986, string to string.
It is faster and different than stdlib `urlencode`.

**Arguments:**
- `url` The URL, string type, required.
- `use_plus` When `use_plus` is `true`, spaces are encoded as `+` instead of `%20`.

Examples:

```python
import faster_than_requests as requests
requests.urlparse("https://nim-lang.org", use_plus = True)
```

**Returns:** string.

</details>


## urldecode()
<details>

**Description:**
Decodes a URL according to RFC-3986, string to string.
It is faster and different than stdlib `unquote`.

**Arguments:**
- `url` The URL, string type, required.
- `use_plus` When `use_plus` is `true`, spaces are decoded as `+` instead of `%20`.

Examples:

```python
import faster_than_requests as requests
requests.urldecode(r"https%3A%2F%2Fnim-lang.org", use_plus = False)
```

**Returns:** string.

</details>


## encodequery()
<details>

**Description:**
Encode a URL according to RFC-3986, string to string.
It is faster and different than stdlib `quote_plus`.

**Arguments:**
- `query` List of Tuples, required, example `[("key", "value")]`, example `[("DNT", "1")]`.
- `omit_eq` If the value is an empty string then the `=""` is omitted, unless `omit_eq` is `false`.
- `use_plus` When `use_plus` is `true`, spaces are decoded as `+` instead of `%20`.

Examples:

```python
import faster_than_requests as requests
requests.encodequery([("key", "value")], use_plus = True, omit_eq = True)
```

**Returns:** string.

</details>


## encodexml()
<details>

**Description:**
Convert the characters `&`, `<`, `>`, `"` in a string to an HTML-safe string, output is Valid XML.
Use this if you need to display text that might contain such characters in HTML, SVG or XML.
It is faster and different than stdlib `html.escape`.

**Arguments:**
- `s` Arbitrary string, required.

Examples:

```python
import faster_than_requests as requests
requests.encodexml("<h1>Hello World</h1>")
```

**Returns:** string.

</details>


## minifyhtml()
<details>

**Description:**
Fast HTML and SVG Minifier. Not Obfuscator.

**Arguments:**
- `html` HTML string, required.

Examples:

```python
import faster_than_requests as requests
requests.minifyhtml("<h1>Hello</h1>          <h1>World</h1>")
```

**Returns:** string.

</details>


## gen_auth_header()
<details>

**Description:**
Helper for HTTP Authentication headers.

Returns 1 string kinda like "Basic base64(username):base64(username)",
so it can be used like `[ ("Authorization": gen_auth_header("username", "password") ) ]`.
See https://github.com/juancarlospaco/faster-than-requests/issues/168#issuecomment-858999317

**Arguments:**
- `username` Username string, must not be empty string, required.
- `password` Password string, must not be empty string, required.

**Returns:** string.

</details>


## debugs
<details>
**Description:**
Debug the internal Configuration of the library, takes no arguments, returns nothing,
prints the pretty-printed human-friendly multi-line JSON Configuration to standard output terminal.


Examples:

```python
import faster_than_requests as requests
requests.debugs()
```

**Arguments:** None.

**Returns:** None.

</details>


## optimizeGC()
<details>

**Description:**
This module uses compile-time deterministic memory management GC (kinda like Rust, but for Python).
Python at run-time makes a pause, runs a Garbage Collector, and resumes again after the pause.

`gctricks.optimizeGC` allows you to omit the Python GC pauses at run-time temporarily on a context manager block,
this is the proper way to use this module for Benchmarks!, this is optional but recommended,
we did not invent this, this is inspired from work from Instagram Engineering team and battle tested by them:

- https://instagram-engineering.com/dismissing-python-garbage-collection-at-instagram-4dca40b29172

This is NOT a function, it is a context manager, it takes no arguments and wont return.

This calls `init_client()` at start and `close_client()` at end automatically.

Examples:

```python
from gctricks import optmizeGC

with optmizeGC:
  # All your HTTP code here. Chill the GC. Calls init_client() and close_client() automatically.

# GC run-time pauses enabled again.
```

</details>


## init_client()
<details>

**Description:**
Instantiate the HTTP Client object, for deferred initialization, call it before the start of all HTTP operations.

`get()`, `post()`, `put()`, `patch()`, `delete()`, `head()` do NOT need this, because they auto-init,
this exist for performance reasons to defer the initialization and was requested by the community.

This is optional but recommended.

Read `optimizeGC` documentation before using.

**Arguments:** None.

Examples:

```python
import faster_than_requests as requests
requests.init_client()
# All your HTTP code here.
```

**Returns:** None.

</details>


## close_client()
<details>

**Description:**
Tear down the HTTP Client object, for deferred de-initialization, call it after the end of all HTTP operations.

`get()`, `post()`, `put()`, `patch()`, `delete()`, `head()` do NOT need this, because they auto-init,
this exist for performance reasons to defer the de-initialization and was requested by the community.

This is optional but recommended.

Read `optimizeGC` documentation before using.

**Arguments:** None.

Examples:

```python
import faster_than_requests as requests
# All your HTTP code here.
requests.close_client()
```

**Returns:** None.

</details>


[**For more Examples check the Examples and Tests.**](https://github.com/juancarlospaco/faster-than-requests/blob/master/examples/example.py)

Instead of having a pair of functions with a lot of arguments that you should provide to make it work,
we have tiny functions with very few arguments that do one thing and do it as fast as possible.

A lot of functions are oriented to Data Science, Big Data, Open Data, Web Scrapping, working with HTTP REST JSON APIs.


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


# Dependencies

- **None**


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
- 64 Bit.


# Windows

- Documentation assumes experience with Git, GitHub, cmd, Compiled software, PC with Administrator.
- If installation fails on Windows, just use the Source Code:

![win-compile](https://user-images.githubusercontent.com/1189414/63147831-b8bf6100-bfd5-11e9-9e6e-91d61040f139.png "Git Clone and Compile on Windows 10 with only Git and Nim installed, just 2 commands!")

**The only software needed is [Git for Windows](https://github.com/git-for-windows/git/releases/latest) and [Nim](https://github.com/dom96/choosenim#windows).**

Reboot after install. Administrator required for install. Everything must be 64Bit.

If that fails too, dont waste time and go directly for [Docker for Windows.](https://docs.docker.com/docker-for-windows).

For info about how to install [Git for Windows](https://github.com/git-for-windows/git/releases/latest), read [Git for Windows](https://github.com/git-for-windows/git/releases/latest) Documentation.

[For info about how to install Nim, read Nim Documentation.](https://nim-lang.org/install.html)

For info about how to install [Docker for Windows.](https://docs.docker.com/docker-for-windows), read [Docker for Windows.](https://docs.docker.com/docker-for-windows) Documentation.

[GitHub Actions Build everything from zero on each push, use it as guidance too.](https://github.com/juancarlospaco/faster-than-requests/actions?query=workflow%3APYTHON)

- Git Clone and Compile on Windows 10 on just 2 commands!.
- [Alternatively you can try Docker for Windows.](https://docs.docker.com/docker-for-windows)
- [Alternatively you can try WSL for Windows.](https://docs.microsoft.com/en-us/windows/wsl/about)
- **The file extension must be `.pyd`, NOT `.dll`. Compile with `-d:ssl` to use HTTPS.**

```
nimble install nimpy
nim c -d:ssl -d:danger --app:lib --tlsEmulation:on --out:faster_than_requests.pyd faster_than_requests.nim
```


# Sponsors

- **Become a Sponsor and help improve this library with the features you want!, we need Sponsors!.**

<details> 
<summary title="Send Bitcoin"><kbd> Bitcoin BTC </kbd></summary>

**BEP20 Binance Smart Chain Network BSC**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**BTC Bitcoin Network**
```
1Pnf45MgGgY32X4KDNJbutnpx96E4FxqVi
```
</details>

<details> 
<summary><kbd> Ethereum ETH </kbd> <kbd> Dai DAI </kbd> <kbd> Uniswap UNI </kbd> <kbd> Axie Infinity AXS </kbd> <kbd> Smooth Love Potion SLP </kbd> </summary>

**BEP20 Binance Smart Chain Network BSC**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**ERC20 Ethereum Network**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
</details>
<details> 
<summary title="Send Tether"><kbd> Tether USDT </kbd></summary>

**BEP20 Binance Smart Chain Network BSC**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**ERC20 Ethereum Network**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**TRC20 Tron Network**
```
TWGft53WgWvH2mnqR8ZUXq1GD8M4gZ4Yfu
```
</details>
<details> 
<summary title="Send Solana"><kbd> Solana SOL </kbd></summary>

**BEP20 Binance Smart Chain Network BSC**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**SOL Solana Network**
```
FKaPSd8kTUpH7Q76d77toy1jjPGpZSxR4xbhQHyCMSGq
```
</details>
<details> 
<summary title="Send Cardano"><kbd> Cardano ADA </kbd></summary>

**BEP20 Binance Smart Chain Network BSC**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
**ADA Cardano Network**
```
DdzFFzCqrht9Y1r4Yx7ouqG9yJNWeXFt69xavLdaeXdu4cQi2yXgNWagzh52o9k9YRh3ussHnBnDrg7v7W2hSXWXfBhbo2ooUKRFMieM
```
</details>
<details> 
<summary title="Send Sandbox"><kbd> Sandbox SAND </kbd> <kbd> Decentraland MANA </kbd></summary>

**ERC20 Ethereum Network**
```
0xb78c4cf63274bb22f83481986157d234105ac17e
```
</details>
<details> 
<summary title="Send Algorand"><kbd> Algorand ALGO </kbd></summary>

**ALGO Algorand Network**
```
WM54DHVZQIQDVTHMPOH6FEZ4U2AU3OBPGAFTHSCYWMFE7ETKCUUOYAW24Q
```
</details>

<details> 
<summary title="Send via Binance Pay"> Binance </summary>
  
https://pay.binance.com/en/checkout/e92e536210fd4f62b426ea7ee65b49c3
</details>


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

- Where to get help ?.

https://github.com/juancarlospaco/faster-than-requests/issues

- How to set the URL ?.

`url="http://example.com"` (1st argument always).

- How to set the HTTP Body ?.

`body="my body"`

- How to set an HTTP Header key=value ?.

[set_headers()](https://github.com/juancarlospaco/faster-than-requests#set_headers)

- How can be faster than PyCurl ?.

I dunno.

- Why use Tuple instead of Dict for HTTP Headers ?.

For speed performance reasons, `dict` is slower, bigger, heavier and mutable compared to `tuple`.

- Why needs 64Bit ?.

Maybe it works on 32Bit, but is not supported, integer sizes are too small, and performance can be worse.

- Why needs Python 3 ?.

Maybe it works on Python 2, but is not supported, and performance can be worse, we suggest to migrate to Python3.

- Can I wrap the functions on a `try: except:` block ?.

Functions do not have internal `try: except:` blocks,
so you can wrap them inside `try: except:` blocks if you need very resilient code.

- PIP fails to install or fails build the wheel ?.

Add at the end of the PIP install command:

` --isolated --disable-pip-version-check --no-cache-dir --no-binary :all: `

Not my Bug.

- How to Build the project ?.

`build.sh` or `build.nims`

- How to Package the project ?.

`package.sh` or `package.nims`

- This requires Nimble ?.

No.

- Whats the unit of measurement for speed ?.

Unmmodified raw output of Python `timeit` module.

Please send Pull Request to Python to improve the output of `timeit`.

- The LoC is a lie, not counting the lines of code of the Compiler ?.

Projects that use Cython wont count the whole Cython on the LoC, so we wont neither.


# Stars

![](https://starchart.cc/juancarlospaco/faster-than-requests.svg "Star faster-than-requests on GitHub!")
:star: [@juancarlospaco](https://github.com/juancarlospaco '2022-02-15')	
:star: [@nikitavoloboev](https://github.com/nikitavoloboev '2022-02-15')	
:star: [@5u4](https://github.com/5u4 '2022-02-16')	
:star: [@CKristensen](https://github.com/CKristensen '2022-02-16')	
:star: [@Lips7](https://github.com/Lips7 '2022-02-17')	
:star: [@zeandrade](https://github.com/zeandrade '2022-02-17')	
:star: [@SoloDevOG](https://github.com/SoloDevOG '2022-02-18')	
:star: [@AM-I-Human](https://github.com/AM-I-Human '2022-02-19')	
:star: [@pauldevos](https://github.com/pauldevos '2022-02-20')	
:star: [@divanovGH](https://github.com/divanovGH '2022-02-21')	
:star: [@ali-sajjad-rizavi](https://github.com/ali-sajjad-rizavi '2022-02-23')	
:star: [@George2901](https://github.com/George2901 '2022-03-01')	
:star: [@jeaps17](https://github.com/jeaps17 '2022-03-01')	
:star: [@TeeWallz](https://github.com/TeeWallz '2022-03-04')	
:star: [@Shinji-Mimura](https://github.com/Shinji-Mimura '2022-03-18')	
:star: [@oozdemir83](https://github.com/oozdemir83 '2022-03-18')	
:star: [@aaman007](https://github.com/aaman007 '2022-03-18')	
:star: [@dungtq](https://github.com/dungtq '2022-03-19')	
:star: [@bonginkosi0607](https://github.com/bonginkosi0607 '2022-03-20')	
:star: [@4nzor](https://github.com/4nzor '2022-03-20')	
:star: [@CyberLionsNFT](https://github.com/CyberLionsNFT '2022-03-24')	
:star: [@Lyapsus](https://github.com/Lyapsus '2022-03-24')	
:star: [@boskuv](https://github.com/boskuv '2022-03-28')	
:star: [@jckli](https://github.com/jckli '2022-03-28')	
:star: [@VitSimon](https://github.com/VitSimon '2022-03-29')	
:star: [@zjmdp](https://github.com/zjmdp '2022-03-30')	
:star: [@maxclac](https://github.com/maxclac '2022-03-31')	
:star: [@krishna2206](https://github.com/krishna2206 '2022-03-31')	
:star: [@KhushC-03](https://github.com/KhushC-03 '2022-03-31')	
:star: [@nicksnell](https://github.com/nicksnell '2022-04-01')	
:star: [@skandix](https://github.com/skandix '2022-04-02')	
:star: [@gioleppe](https://github.com/gioleppe '2022-04-08')	
:star: [@mvandermeulen](https://github.com/mvandermeulen '2022-04-11')	
:star: [@Vexarr](https://github.com/Vexarr '2022-04-13')	
:star: [@baajarmeh](https://github.com/baajarmeh '2022-04-13')	
:star: [@znel2002](https://github.com/znel2002 '2022-04-13')	
:star: [@matkuki](https://github.com/matkuki '2022-04-14')	
:star: [@SmartManoj](https://github.com/SmartManoj '2022-04-16')	
:star: [@SmartManoj](https://github.com/SmartManoj '2022-04-21')	
:star: [@Zardex1337](https://github.com/Zardex1337 '2022-05-08')	
:star: [@jocago](https://github.com/jocago '2022-05-09')	
:star: [@gnimmel](https://github.com/gnimmel '2022-05-11')	
:star: [@sting8k](https://github.com/sting8k '2022-05-13')	
:star: [@c4p-n1ck](https://github.com/c4p-n1ck '2022-05-13')	
:star: [@w0xi](https://github.com/w0xi '2022-05-15')	
:star: [@Bing-su](https://github.com/Bing-su '2022-05-16')	
:star: [@AdrianCert](https://github.com/AdrianCert '2022-05-18')	
:star: [@asanoop24](https://github.com/asanoop24 '2022-05-18')	
:star: [@zaphodfortytwo](https://github.com/zaphodfortytwo '2022-05-19')	
:star: [@Ozerioss](https://github.com/Ozerioss '2022-05-20')	
:star: [@nkot56297](https://github.com/nkot56297 '2022-05-21')	
:star: [@sendyputra](https://github.com/sendyputra '2022-05-22')	
:star: [@thedrow](https://github.com/thedrow '2022-05-23')	
:star: [@MinhHuyDev](https://github.com/MinhHuyDev '2022-05-24')	
:star: [@rapjul](https://github.com/rapjul '2022-05-27')	
:star: [@Arthavruksha](https://github.com/Arthavruksha '2022-05-31')	
:star: [@xdroff](https://github.com/xdroff '2022-05-31')	
:star: [@ShodhArthavruksha](https://github.com/ShodhArthavruksha '2022-06-01')	
:star: [@aziddddd](https://github.com/aziddddd '2022-06-01')	
:star: [@breezechen](https://github.com/breezechen '2022-06-02')	
:star: [@TobeTek](https://github.com/TobeTek '2022-06-07')	
:star: [@antonpetrov145](https://github.com/antonpetrov145 '2022-06-09')	
:star: [@MartianDominic](https://github.com/MartianDominic '2022-06-14')	
:star: [@sk37025](https://github.com/sk37025 '2022-06-15')	
:star: [@Alexb309](https://github.com/Alexb309 '2022-06-16')	
:star: [@alimp5](https://github.com/alimp5 '2022-06-17')	
:star: [@oldhroft](https://github.com/oldhroft '2022-06-25')	
:star: [@davidcralph](https://github.com/davidcralph '2022-06-25')	
:star: [@rainmana](https://github.com/rainmana '2022-06-25')	
:star: [@amitdo](https://github.com/amitdo '2022-07-03')	
:star: [@atlassion](https://github.com/atlassion '2022-07-04')	
:star: [@cytsai1008](https://github.com/cytsai1008 '2022-07-05')	
:star: [@bsouthern](https://github.com/bsouthern '2022-07-07')	
:star: [@techrattt](https://github.com/techrattt '2022-07-09')	
:star: [@vnicetn](https://github.com/vnicetn '2022-07-11')	
:star: [@Perry-xD](https://github.com/Perry-xD '2022-07-12')	
:star: [@israelvf](https://github.com/israelvf '2022-07-13')	
:star: [@BernardoOlisan](https://github.com/BernardoOlisan '2022-07-14')	
:star: [@ZenoMilk12](https://github.com/ZenoMilk12 '2022-07-19')	
:star: [@rundef](https://github.com/rundef '2022-07-20')	
:star: [@semihyesilyurt](https://github.com/semihyesilyurt '2022-07-20')	
:star: [@dunaevv](https://github.com/dunaevv '2022-07-21')	
:star: [@mlueckl](https://github.com/mlueckl '2022-07-21')	
:star: [@johnrlive](https://github.com/johnrlive '2022-07-24')	
:star: [@CrazyBonze](https://github.com/CrazyBonze '2022-07-28')	
:star: [@v-JiangNan](https://github.com/v-JiangNan '2022-07-31')	
:star: [@justfly50](https://github.com/justfly50 '2022-07-31')	
:star: [@mamert](https://github.com/mamert '2022-08-03')	
:star: [@ccamateur](https://github.com/ccamateur '2022-08-07')	
:star: [@5l1v3r1](https://github.com/5l1v3r1 '2022-08-07')	
:star: [@Wykiki](https://github.com/Wykiki '2022-08-08')	
:star: [@Kladdkaka](https://github.com/Kladdkaka '2022-08-09')	
:star: [@giubaru](https://github.com/giubaru '2022-08-10')	
:star: [@eamigo86](https://github.com/eamigo86 '2022-08-12')	
:star: [@eadwinCode](https://github.com/eadwinCode '2022-08-12')	
:star: [@s4ke](https://github.com/s4ke '2022-08-13')	
:star: [@DG4MES](https://github.com/DG4MES '2022-08-14')	
:star: [@AlexJupiterian](https://github.com/AlexJupiterian '2022-08-16')	
:star: [@baodinhaaa](https://github.com/baodinhaaa '2022-08-19')	
:star: [@a-golda](https://github.com/a-golda '2022-08-23')	
:star: [@Furkan-izgi](https://github.com/Furkan-izgi '2022-08-25')	
:star: [@Abdulvoris101](https://github.com/Abdulvoris101 '2022-08-31')	
:star: [@devlenni](https://github.com/devlenni '2022-09-12')	
:star: [@kasahh](https://github.com/kasahh '2022-09-15')	
:star: [@vishaltanwar96](https://github.com/vishaltanwar96 '2022-09-16')	
:star: [@codehangen](https://github.com/codehangen '2022-09-16')	
:star: [@svenko99](https://github.com/svenko99 '2022-09-20')	
:star: [@kb1900](https://github.com/kb1900 '2022-09-27')	
:star: [@lusteroak](https://github.com/lusteroak '2022-10-03')	
:star: [@nitheesh-cpu](https://github.com/nitheesh-cpu '2022-10-06')	
:star: [@techpixel](https://github.com/techpixel '2022-10-06')	
:star: [@tk-iitd](https://github.com/tk-iitd '2022-10-07')	
:star: [@smartniz](https://github.com/smartniz '2022-10-13')	
:star: [@popcrocks](https://github.com/popcrocks '2022-10-13')	
:star: [@senic35](https://github.com/senic35 '2022-10-14')	
:star: [@NychetheAwesome](https://github.com/NychetheAwesome '2022-10-17')	
:star: [@rafalohaki](https://github.com/rafalohaki '2022-10-17')	
:star: [@Danipulok](https://github.com/Danipulok '2022-10-19')	
:star: [@lwinkelm](https://github.com/lwinkelm '2022-10-20')	
:star: [@sunlei](https://github.com/sunlei '2022-10-21')	
:star: [@Minnikeswar](https://github.com/Minnikeswar '2022-10-25')	
:star: [@theol-git](https://github.com/theol-git '2022-10-27')	
:star: [@Mohammad-Mohsen](https://github.com/Mohammad-Mohsen '2022-10-28')	
:star: [@neeksor](https://github.com/neeksor '2022-10-28')	
:star: [@0xNev](https://github.com/0xNev '2022-11-01')	
:star: [@imvast](https://github.com/imvast '2022-11-02')	
:star: [@daweedkob](https://github.com/daweedkob '2022-11-02')	
:star: [@Landcruiser87](https://github.com/Landcruiser87 '2022-11-02')	
:star: [@kirillzhosul](https://github.com/kirillzhosul '2022-11-02')	
:star: [@FurkanEdizkan](https://github.com/FurkanEdizkan '2022-11-03')	
:star: [@sodinokibi](https://github.com/sodinokibi '2022-11-04')	
:star: [@stepan-zubkov](https://github.com/stepan-zubkov '2022-11-04')	
:star: [@Nexlab-One](https://github.com/Nexlab-One '2022-11-05')	
:star: [@PApostol](https://github.com/PApostol '2022-11-06')	
:star: [@callmeAsadUllah](https://github.com/callmeAsadUllah '2022-11-12')	
:star: [@jaredv1](https://github.com/jaredv1 '2022-11-13')	
:star: [@Goblin80](https://github.com/Goblin80 '2022-11-14')	
:star: [@michikxd](https://github.com/michikxd '2022-11-17')	
:star: [@babywyrm](https://github.com/babywyrm '2022-11-19')	
:star: [@MooneDrJune](https://github.com/MooneDrJune '2022-11-21')	
:star: [@grknbyk](https://github.com/grknbyk '2022-11-24')	
:star: [@francomerendan](https://github.com/francomerendan '2022-11-24')	
:star: [@noudin-ledger](https://github.com/noudin-ledger '2022-11-24')	
:star: [@chip-felton-montage](https://github.com/chip-felton-montage '2022-11-24')	
:star: [@Ruddy35](https://github.com/Ruddy35 '2022-11-25')	
:star: [@xilicode](https://github.com/xilicode '2022-11-25')	
:star: [@BrianTurza](https://github.com/BrianTurza '2022-11-25')	
:star: [@oguh43](https://github.com/oguh43 '2022-11-26')	
:star: [@oyoxo](https://github.com/oyoxo '2022-11-26')	
:star: [@encoreshao](https://github.com/encoreshao '2022-11-27')	
:star: [@peter279k](https://github.com/peter279k '2022-11-28')	
:star: [@xalien10](https://github.com/xalien10 '2022-11-28')	
:star: [@DahnJ](https://github.com/DahnJ '2022-11-29')	
:star: [@ld909](https://github.com/ld909 '2022-11-30')	
:star: [@lafabo](https://github.com/lafabo '2022-11-30')	
:star: [@AndrewGPU](https://github.com/AndrewGPU '2022-12-04')	
:star: [@jerheff](https://github.com/jerheff '2022-12-05')	
:star: [@wtv-piyush](https://github.com/wtv-piyush '2022-12-05')	
