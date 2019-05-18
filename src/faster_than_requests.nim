import httpclient, json, tables, nimpy, strutils

from os import sleep
from ospaths import getEnv
from random import randomize, rand


const debugCfg = pretty(%*{
  "proxyUrl":     getEnv("https_proxy", getEnv"http_proxy"),
  "timeout":      getEnv"requests_timeout",
  "userAgent":    getEnv"requests_useragent",
  "maxRedirects": getEnv"requests_maxredirects",
  "nimVersion":   NimVersion,
  "httpCore":     defUserAgent,
  "compileDate":  CompileDate & "T" & CompileTime,
  "cpu":          hostCPU,
  "os":           hostOS,
  "endian":       cpuEndian,
  "release":      defined(release),
  "biggestInt":   int.high
})

let
  proxyUrl = getEnv("https_proxy", getEnv"http_proxy").strip
  proxyAuth = getEnv("https_proxy_auth", getEnv"http_proxy_auth").strip
  proxi = if proxyUrl.len > 1: newProxy(proxyUrl, proxyAuth) else: nil

var client = newHttpClient(timeout=getEnv("requests_timeout", "-1").parseInt,
                           userAgent=getEnv("requests_useragent", ""), proxy=proxi,
                           maxRedirects=getEnv("requests_maxredirects", "9").parseInt)


proc debugConfig*() {. discardable, exportpy .} =
  ## Get the Config and print it to the terminal, for debug purposes only, human friendly.
  echo debugCfg


proc setHeaders*(headers: openArray[tuple[key: string, val: string]] = @[("dnt", "1")]) {. exportpy .} =
  ## Set the HTTP Headers to the HTTP client.
  client.headers = newHttpHeaders(headers)


proc gets*(url: string): Table[string, string] {. exportpy .} =
  ## HTTP GET an URL to dictionary.
  let r = client.get(url)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc posts*(url, body: string): Table[string, string] {. exportpy .} =
  ## HTTP POST an URL to dictionary.
  let r = client.post(url, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc put*(url, body: string): Table[string, string] {. exportpy .} =
  ## HTTP PUT an URL to dictionary.
  let r = client.request(url, HttpPut, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc patch*(url, body: string): Table[string, string] {. exportpy .} =
  ## HTTP PATCH an URL to dictionary.
  let r = client.request(url, HttpPatch, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc deletes*(url: string): Table[string, string] {. exportpy .} =
  ## HTTP DELETE an URL to dictionary.
  let r = client.request(url, HttpDelete)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc requests*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]],
               debugs: bool = false): Table[string, string] {. exportpy .} =
  ## HTTP requests low level function to dictionary.
  let headerss = newHttpHeaders(http_headers)
  if unlikely(debugs): echo url, "\n", http_method, "\n", body, "\n", headerss
  let r = client.request(url, http_method, body, headerss)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
   "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


proc requests2*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]],
                proxyUrl: string = "", proxyAuth: string = "", userAgent: string = "",
                timeout: int =  -1, maxRedirects: int = 9): Table[string, string] {. exportpy .} =
  ## HTTP requests low level function to dictionary with extra options.
  let
    proxxi = if proxyUrl.len > 1: newProxy(proxyUrl.strip, proxyAuth.strip) else: nil
    client = newHttpClient(timeout=timeout, userAgent=userAgent, proxy=proxxi, maxRedirects=maxRedirects)
    r = client.request(url, http_method, body, newHttpHeaders(http_headers))
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version,
  "content-length": $r.contentLength, "headers": replace($r.headers," @[", " [")}.toTable


########## Extra HTTP Functions, go beyond the ones from requests #############


proc get2str*(url: string): string {. exportpy .} =
  ## HTTP GET body to string.
  client.getContent(url)


proc getlist2list*(list_of_urls: openArray[string]): seq[seq[string]] {. exportpy .} =
  ## HTTP GET body from a list of urls to a list of lowercased strings (this is designed for quick web scrapping).
  for url in list_of_urls:
    result.add client.getContent(url).strip.toLowerAscii.splitlines


proc get2str_list*(list_of_urls: openArray[string]): seq[string] {. exportpy .} =
  ## HTTP GET body to string from a list of URLs.
  for url in list_of_urls:
    result.add client.getContent(url)


proc get2ndjson_list*(list_of_urls: openArray[string], ndjson_file_path: string) {. discardable, exportpy .} =
  ## HTTP GET body to NDJSON file from a list of URLs.
  var
    temp: string
    ndjson = open(ndjson_file_path, fmWrite)
  for url in list_of_urls:
    temp = ""
    temp.toUgly client.getContent(url).parseJson
    ndjson.writeLine temp
  ndjson.close()


proc get2json*(url: string): string {. exportpy .} =
  ## HTTP GET body to JSON.
  result.toUgly client.getContent(url).parseJson


proc get2json_pretty*(url: string): string {. exportpy .} =
  ## HTTP GET body to pretty-printed JSON.
  client.getContent(url).parseJson.pretty


proc get2dict*(url: string): seq[Table[string, string]] {. exportpy .} =
  ## HTTP GET body to dictionary.
  for i in client.getContent(url).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable


proc get2assert*(url, expected: string) {. discardable, exportpy .} =
  ## HTTP GET body to assert.
  doAssert client.getContent(url).strip == expected.strip


proc post2str*(url, body: string): string {. exportpy .} =
  ## HTTP POST body to string.
  client.postContent(url, body)


proc post2list*(url, body: string): seq[string] {. exportpy .} =
  ## HTTP POST body to list of lowercased strings (this is designed for quick web scrapping).
  client.postContent(url).strip.toLowerAscii.splitlines


proc post2json*(url, body: string): string {. exportpy .} =
  ## HTTP POST body to JSON.
  result.toUgly client.postContent(url, body).parseJson


proc post2json_pretty*(url, body: string): string {. exportpy .} =
  ## HTTP POST body to pretty-printed JSON.
  client.postContent(url, body).parseJson.pretty


proc post2dict*(url, body: string): seq[Table[string, string]] {. exportpy .} =
  ## HTTP POST body to dictionary.
  for i in client.postContent(url, body).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable


proc post2assert*(url, body, expected: string) {. discardable, exportpy .} =
  ## HTTP POST body to assert.
  doAssert client.postContent(url, body).strip == expected.strip


proc downloads*(url, filename: string) {. discardable, exportpy .} =
  ## Download a file ASAP, from url, filename arguments.
  client.downloadFile(url, filename)


proc downloads_list*(list_of_files: openArray[tuple[url: string, filename: string]]) {. discardable, exportpy .} =
  ## Download a list of files ASAP, like [(url, filename), (url, filename), ...]
  for item in list_of_files:
    client.downloadFile(item[0], item[1])


proc downloads_list_delay*(list_of_files: openArray[tuple[url: string, filename: string]],
                           delay: int, randoms: bool = false, debugs: bool = false) {. discardable, exportpy .} =
  ## Download a list of files with delay, like [(url, filename), (url, filename), ...]
  var espera = delay * 1000
  if randoms: randomize()
  for item in list_of_files:
    if debugs: echo item
    sleep(if randoms: espera.rand else: espera)
    client.downloadFile(item[0], item[1])
