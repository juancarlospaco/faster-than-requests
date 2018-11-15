## Faster than requests
## ====================
##
## - ``gets()`` HTTP GET.
## - ``posts()`` HTTP POST.
## - ``puts()`` HTTP PUT.
## - ``deletes()`` HTTP DELETE.
## - ``patchs()`` HTTP PATCH.
## - ``get2str()`` HTTP GET body only to string response.
## - ``get2str_list()`` HTTP GET body to string from a list.
## - ``get2ndjson_list()`` HTTP GET body to NDJSON file from a list.
## - ``get2dict()`` HTTP GET body only to dictionary response.
## - ``get2json()`` HTTP GET body only to JSON response.
## - ``get2json_pretty()`` HTTP GET body only to Pretty-Printed JSON response.
## - ``get2assert()`` HTTP GET body only to assert from expected argument for unittests.
## - ``post2str()`` HTTP POST data only to string response.
## - ``post2dict()`` HTTP POST data only to dictionary response.
## - ``post2json()`` HTTP POST data to JSON response.
## - ``post2json_pretty()`` HTTP POST data to Pretty-Printed JSON response.
## - ``post2assert()`` HTTP POST body only to assert from expected argument for unittests.
## - ``requests()`` HTTP GET/POST/PUT/DELETE/PATCH,Headers,etc.
## - ``downloads()`` HTTP GET Download 1 file.
## - ``downloads_list()`` HTTP GET Download a list of files.
## - ``downloads_list_delay()`` HTTP GET Download a list of files with delay.
## - Recommended way of importing is ``import faster_than_requests as requests``
## - SSL & Non-SSL versions available (Non-SSL is smaller but no HTTPS)
import httpclient, json, tables, strutils, os, random, nimpy
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

proc requests*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]],
               debugs: bool = false): Table[string, string] {.inline, exportpy.} =
  ## HTTP Requests low level function to dictionary.
  let headerss = newHttpHeaders(http_headers)
  if unlikely(debugs): echo url, "\n", http_method, "\n", body, "\n", headerss
  let r = client.request(url, http_method, body, headerss)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable

# Extra HTTP Functions, go beyond the ones from Requests/PyCurl.

proc get2str*(url: string): string {.inline, exportpy.} =
  ## HTTP GET body to string.
  client.getContent(url)

proc get2str_list*(list_of_urls: openArray[string]): seq[string] {.inline, exportpy.} =
  ## HTTP GET body to string from a list of URLs.
  for url in list_of_urls:
    result.add client.getContent(url)

proc get2ndjson_list*(list_of_urls: openArray[string], ndjson_file_path: string) {.inline, discardable, exportpy.} =
  ## HTTP GET body to NDJSON file from a list of URLs.
  var
    temp: string
    ndjson = open(ndjson_file_path, fmWrite)
  for url in list_of_urls:
    temp = ""
    temp.toUgly client.getContent(url).parseJson
    ndjson.writeLine temp
  ndjson.close()

proc get2json*(url: string): string {.inline, exportpy.} =
  ## HTTP GET body to JSON.
  result.toUgly client.getContent(url).parseJson

proc get2json_pretty*(url: string): string {.inline, exportpy.} =
  ## HTTP GET body to pretty-printed JSON.
  client.getContent(url).parseJson.pretty

proc get2dict*(url: string): seq[Table[string, string]] {.inline, exportpy.} =
  ## HTTP GET body to dictionary.
  for i in client.getContent(url).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable

proc get2assert*(url, expected: string) {.inline, discardable, exportpy.} =
  ## HTTP GET body to assert.
  doAssert client.getContent(url).strip == expected.strip

proc post2str*(url, body: string): string {.inline, exportpy.} =
  ## HTTP POST body to string.
  client.postContent(url, body)

proc post2json*(url, body: string): string {.inline, exportpy.} =
  ## HTTP POST body to JSON.
  result.toUgly client.postContent(url, body).parseJson

proc post2json_pretty*(url, body: string): string {.inline, exportpy.} =
  ## HTTP POST body to pretty-printed JSON.
  client.postContent(url, body).parseJson.pretty

proc post2dict*(url, body: string): seq[Table[string, string]] {.inline, exportpy.} =
  ## HTTP POST body to dictionary.
  for i in client.postContent(url, body).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable

proc post2assert*(url, body, expected: string) {.inline, discardable, exportpy.} =
  ## HTTP POST body to assert.
  doAssert client.postContent(url, body).strip == expected.strip

proc downloads*(url, filename: string) {.inline, discardable, exportpy.} =
  ## Download a file ASAP, from url, filename arguments.
  client.downloadFile(url, filename)

proc downloads_list*(list_of_files: openArray[tuple[url: string, filename: string]]) {.inline, discardable, exportpy.} =
  ## Download a list of files ASAP, like [(url, filename), (url, filename), ...]
  for item in list_of_files:
    client.downloadFile(item[0], item[1])

proc downloads_list_delay*(list_of_files: openArray[tuple[url: string, filename: string]],
                           delay: int, randoms: bool = false, debugs: bool = false) {.inline, discardable, exportpy.} =
  ## Download a list of files with delay, like [(url, filename), (url, filename), ...]
  var espera = delay * 1000
  if randoms: randomize()
  for item in list_of_files:
    if debugs: echo item
    sleep(if randoms: espera.rand else: espera)
    client.downloadFile(item[0], item[1])
