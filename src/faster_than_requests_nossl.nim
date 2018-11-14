## Faster Than Requests
## ====================
##
## - Faster & simpler Requests & PyCurl replacement for Python, less options & more speed.
##
## API
## ---
##
## - ``faster_than_requests.gets()`` HTTP GET.
## - ``faster_than_requests.posts()`` HTTP POST.
## - ``faster_than_requests.puts()`` HTTP PUT.
## - ``faster_than_requests.deletes()`` HTTP DELETE.
## - ``faster_than_requests.patchs()`` HTTP PATCH.
## - ``faster_than_requests.get2str()`` HTTP GET body only to string response.
## - ``faster_than_requests.get2str_list()`` HTTP GET body to string from a list.
## - ``faster_than_requests.get2dict()`` HTTP GET body only to dictionary response.
## - ``faster_than_requests.get2json()`` HTTP GET body only to JSON response.
## - ``faster_than_requests.post2str()`` HTTP POST data only to string response.
## - ``faster_than_requests.post2dict()`` HTTP POST data only to dictionary response.
## - ``faster_than_requests.post2json()`` HTTP POST data to JSON response.
## - ``faster_than_requests.requests()`` HTTP GET/POST/PUT/DELETE/PATCH,Headers,etc.
## - ``faster_than_requests.downloads()`` HTTP GET Download 1 file.
## - ``faster_than_requests.downloads_list()`` HTTP GET Download a list of files.
## - Recommended way of importing is ``import faster_than_requests as requests``
## - SSL & Non-SSL versions available (Non-SSL is smaller & Faster but no HTTPS)
import httpclient, json, tables, strutils, os, nimpy
{.passL: "-s", passC: "-flto -ffast-math", optimization: speed.}
var client = newHttpClient(userAgent="")

proc gets*(url: string): Table[string, string] {.inline, exportpy.} =
  ## HTTP GET an URL to dictionary.
  let r = client.get(url)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

proc posts*(url, body: string): Table[string, string] {.inline, exportpy.} =
  ## HTTP POST an URL to dictionary.
  let r = client.post(url, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

proc puts*(url, body: string): Table[string, string] {.inline, exportpy.} =
  ## HTTP PUT an URL to dictionary.
  let r = client.request(url, HttpPut, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

proc patchs*(url, body: string): Table[string, string] {.inline, exportpy.} =
  ## HTTP PATCH an URL to dictionary.
  let r = client.request(url, HttpPatch, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

proc deletes*(url: string): Table[string, string] {.inline, exportpy.} =
  ## HTTP DELETE an URL to dictionary.
  let r = client.request(url, HttpDelete)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

proc requests*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]]): Table[string, string] {.inline, exportpy.} =
  ## HTTP Requests low level function to dictionary.
  let
    headerss = newHttpHeaders(http_headers)
    r = client.request(url, http_method, body, headerss)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

# Extra HTTP Functions, go beyond the ones from Requests.

proc get2str*(url: string): string {.inline, exportpy.} =
  ## HTTP GET body to string.
  client.getContent(url)

proc get2str_list*(list_of_urls: openArray[string]): seq[string] {.inline, exportpy.} =
  ## HTTP GET body to string from a list of URLs.
  for url in list_of_urls:
    result.add client.getContent(url)

proc get2json*(url: string): string {.inline, exportpy.} =
  ## HTTP GET body to pretty-printed JSON.
  client.getContent(url).parseJson.pretty

proc get2dict*(url: string): seq[Table[string, string]] {.inline, exportpy.} =
  ## HTTP GET body to dictionary.
  for i in client.getContent(url).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable

proc post2str*(url, body: string): string {.inline, exportpy.} =
  ## HTTP POST body to string.
  client.postContent(url, body)

proc post2json*(url, body: string): string {.inline, exportpy.} =
  ## HTTP POST body to pretty-printed JSON.
  client.postContent(url, body).parseJson.pretty

proc post2dict*(url, body: string): seq[Table[string, string]] {.inline, exportpy.} =
  ## HTTP POST body to dictionary.
  for i in client.postContent(url, body).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable

proc downloads*(url, filename: string) {.inline, discardable, exportpy.} =
  ## Download a file ASAP, from url, filename arguments.
  client.downloadFile(url, filename)

proc downloads_list*(list_of_files: openArray[tuple[url: string, filename: string]]) {.inline, discardable, exportpy.} =
  ## Download a list of files ASAP, like [(url, filename), (url, filename), ...]
  for item in list_of_files:
    client.downloadFile(item[0], item[1])
