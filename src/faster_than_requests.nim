import httpclient, json, tables, strutils, os, threadpool, htmlparser, xmltree, sequtils, db_sqlite, nimpy


let proxyUrl = getEnv("HTTPS_PROXY", getEnv"HTTP_PROXY").strip
var client = newHttpClient(timeout = getEnv("requests_timeout", "-1").parseInt, userAgent = defUserAgent,
  proxy = (if unlikely(proxyUrl.len > 1): newProxy(proxyUrl, getEnv("HTTPS_PROXY_AUTH", getEnv"HTTP_PROXY_AUTH").strip) else: nil),
  maxRedirects = getEnv("requests_maxredirects", "9").parseInt)


proc get*(url: string): Table[string, string] {.exportpy.} =
  ## HTTP GET an URL to dictionary.
  let r = client.get(url)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc post*(url, body: string, multipart_data: seq[tuple[name: string, content: string]] = @[]): Table[string, string] {.exportpy.} =
  ## HTTP POST an URL to dictionary.
  let r = client.post(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc put*(url, body: string): Table[string, string] {.exportpy.} =
  ## HTTP PUT an URL to dictionary.
  let r = client.request(url, HttpPut, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc patch*(url, body: string): Table[string, string] {.exportpy.} =
  ## HTTP PATCH an URL to dictionary.
  let r = client.request(url, HttpPatch, body)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc delete*(url: string): Table[string, string] {.exportpy.} =
  ## HTTP DELETE an URL to dictionary.
  let r = client.request(url, HttpDelete)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc requests*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]], debugs: bool = false): Table[string, string] {.exportpy.} =
  ## HTTP requests low level function to dictionary.
  let headerss = newHttpHeaders(http_headers)
  if unlikely(debugs): echo url, "\n", http_method, "\n", body, "\n", headerss
  let r = client.request(url, http_method, body, headerss)
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc requests2*(url, http_method, body: string, http_headers: openArray[tuple[key: string, val: string]], proxyUrl: string = "",
    proxyAuth: string = "", userAgent: string = "", timeout: int = -1, maxRedirects: int = 9): Table[string, string] {.exportpy.} =
  ## HTTP requests low level function to dictionary with extra options.
  let
    proxxi = if unlikely(proxyUrl.len > 1): newProxy(proxyUrl.strip, proxyAuth.strip) else: nil
    client = newHttpClient(timeout = timeout, userAgent = userAgent, proxy = proxxi, maxRedirects = maxRedirects)
    r = client.request(url, http_method, body, newHttpHeaders(http_headers))
  {"body": r.body, "content-type": r.contentType, "status": r.status, "version": r.version, "content-length": $r.contentLength, "headers": replace($r.headers, " @[", " [")}.toTable


proc set_headers*(headers: openArray[tuple[key: string, val: string]] = @[("dnt", "1")]) {.exportpy.} =
  ## Set the HTTP Headers to the HTTP client.
  client.headers = newHttpHeaders(headers)


# ^ Basic HTTP Functions ########### V Extra HTTP Functions, go beyond requests


proc debugs*() {.discardable, exportpy.} =
  ## Get the Config and print it to the terminal, for debug purposes only, human friendly.
  echo static(pretty(%*{
    "proxyUrl": getEnv("HTTPS_PROXY", getEnv"HTTP_PROXY"), "timeout": getEnv"requests_timeout", "userAgent": getEnv"requests_useragent",
    "maxRedirects": getEnv"requests_maxredirects", "nimVersion": NimVersion, "httpCore": defUserAgent, "cpu": hostCPU, "os": hostOS,
    "endian": cpuEndian, "release": defined(release), "danger": defined(danger), "CompileDate": CompileDate,  "CompileTime": CompileTime,
    "tempDir": getTempDir(), "ssl": defined(ssl), "currentCompilerExe": getCurrentCompilerExe(), "int.high": int.high
  }))


proc tuples2json*(tuples: openArray[tuple[key: string, val: string]], pretty_print: bool = false): string {.exportpy.} =
  ## Convert Tuples to JSON Minified.
  if unlikely(pretty_print):
    var temp = parseJson("{}")
    for item in tuples: temp.add(item[0], %item[1])
    result.toUgly(temp)
  else:
    var temp = parseJson("{}")
    for item in tuples: temp.add(item[0], %item[1])
    result = temp.pretty


proc get2str*(url: string): string {.exportpy.} =
  ## HTTP GET body to string.
  client.getContent(url)


proc get2str2*(list_of_urls: openArray[string], threads: bool = false): seq[string] {.exportpy.} =
  ## HTTP GET body to string from a list of URLs.
  if threads:
    result = newSeq[string](list_of_urls.len)
    for i, url in list_of_urls: result[i] = ^ spawn client.getContent(url)
  else:
    for url in list_of_urls: result.add client.getContent(url)


proc get2ndjson*(list_of_urls: openArray[string], ndjson_file_path: string) {.discardable, exportpy.} =
  ## HTTP GET body to NDJSON file from a list of URLs.
  var
    temp: string
    ndjson = open(ndjson_file_path, fmWrite)
  for url in list_of_urls:
    temp = ""
    temp.toUgly client.getContent(url).parseJson
    ndjson.writeLine temp
  ndjson.close()


proc get2json*(url: string, pretty_print: bool = false): string {.exportpy.} =
  ## HTTP GET body to JSON.
  if unlikely(pretty_print): result = client.getContent(url).parseJson.pretty else: result.toUgly client.getContent(url).parseJson


proc get2dict*(url: string): seq[Table[string, string]] {.exportpy.} =
  ## HTTP GET body to dictionary.
  for i in client.getContent(url).parseJson.pairs: result.add {i[0]: i[1].pretty}.toTable


proc post2str*(url, body: string, multipart_data: seq[tuple[name: string, content: string]] = @[]): string {.exportpy.} =
  ## HTTP POST body to string.
  client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)


proc post2list*(url, body: string, multipart_data: seq[tuple[name: string, content: string]] = @[]): seq[string] {.exportpy.} =
  ## HTTP POST body to list of strings (this is designed for quick web scrapping).
  client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).strip.splitLines


proc post2json*(url, body: string, multipart_data: seq[tuple[name: string, content: string]] = @[], pretty_print: bool = false): string {.exportpy.} =
  ## HTTP POST body to JSON.
  if unlikely(pretty_print):
    result = client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).parseJson.pretty
  else:
    result.toUgly client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).parseJson


proc post2dict*(url, body: string, multipart_data: seq[tuple[name: string, content: string]] = @[]): seq[Table[string, string]] {.exportpy.} =
  ## HTTP POST body to dictionary.
  for i in client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable


proc download*(url, filename: string) {.discardable, exportpy.} =
  ## Download a file ASAP, from url, filename arguments.
  client.downloadFile(url, filename)


proc download2*(list_of_files: openArray[tuple[url: string, filename: string]], threads: bool = false, delay: Natural = 0) {.discardable, exportpy.} =
  ## Download a list of files ASAP, like [(url, filename), (url, filename), ...], threads=True will use multi-threading.
  if likely(delay == 0):
    if likely(threads):
      for item in list_of_files: spawn client.downloadFile(item[0], item[1])
    else:
      for item in list_of_files: client.downloadFile(item[0], item[1])
  else:
    for item in list_of_files:
      sleep delay
      client.downloadFile(item[0], item[1])


proc scraper*(list_of_urls: openArray[string], html_tag: string = "a", case_insensitive: bool = true, deduplicate_urls: bool = false, threads: bool = false): seq[string] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  result = newSeq[string](urls.len)
  if likely(threads):
    for i, url in urls: result[i] = ^ spawn $findAll(parseHtml(client.getContent(url)), html_tag, case_insensitive)
  else:
    for i, url in urls: result[i] = $findAll(parseHtml(client.getContent(url)), html_tag, case_insensitive)


proc scraper2*(list_of_urls: seq[string], list_of_tags: seq[string] = @["a"], verbose: bool = true, case_insensitive: bool = true, deduplicate_urls: bool = false, threads: bool = false, delay: Natural = 0, timeout: int = -1, agent: string = defUserAgent, redirects: Positive = 5, header: seq[(string, string)] = @[("DNT", "1")], proxy_url: string = "", proxy_auth: string = ""): seq[seq[XmlNode]] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  var cliente = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  result = newSeq[seq[XmlNode]](urls.len)
  if likely(threads):
    for i, url in urls:
      for tag in list_of_tags: result[i] = ^ spawn findAll(parseHtml(cliente.getContent(url)), tag, case_insensitive)
  else:
    for i, url in urls:
      if likely(verbose): echo i, "\t", url
      for tag in list_of_tags:
        result[i] = findAll(parseHtml(cliente.getContent(url)), tag, case_insensitive)
        sleep delay


proc scraper3*(list_of_urls: seq[string], list_of_tags: seq[string] = @["a"], start_with: string = "", end_with: string = "", line_start: Natural = 0, line_end: Positive = 1, verbose: bool = true, case_insensitive: bool = true, deduplicate_urls: bool = false, delay: Natural = 0, header: seq[(string, string)] = @[("DNT", "1")], pre_replacements: seq[(string, string)] = @[], post_replacements: seq[(string, string)] = @[], timeout: int = -1, agent: string = defUserAgent, redirects: Positive = 5, proxy_url: string = "", proxy_auth: string = ""): seq[seq[string]] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  var cliente = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  result = newSeq[seq[string]](urls.len)
  for i, url in urls:
    if likely(verbose): echo i, "\t", url
    for tag in list_of_tags:
      sleep delay
      for item in findAll(parseHtml(if pre_replacements.len > 0: cliente.getContent(url).multiReplace(pre_replacements) else: cliente.getContent(url)), tag, case_insensitive):
        if start_with.len > 0 and end_with.len > 0:
          if strip($item).startsWith(start_with) and strip($item).endsWith(end_with): result[i].add(if post_replacements.len > 0: strip($item).multiReplace(post_replacements)[line_start..^line_end] else: strip($item)[line_start..^line_end])
          else: continue
        else: result[i].add(if post_replacements.len > 0: strip($item).multiReplace(post_replacements)[line_start..^line_end] else: strip($item)[line_start..^line_end])


proc scraper4*(list_of_urls: seq[string], folder: string = getCurrentDir(), force_extension: string = ".jpg", https_only: bool = false, print_alt: bool = false, picture: bool = false, case_insensitive: bool = true, deduplicate_urls: bool = false, visited_urls: bool = true, html_output: bool = true, csv_output: bool = true, verbose: bool = true, delay: Natural = 0, timeout: int = -1, agent: string = defUserAgent, redirects: Positive = 5, header: seq[(string, string)] = @[("DNT", "1")], proxy_url: string = "", proxy_auth: string = "") {.exportpy, discardable.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  var
    visited: seq[string]
    src, dir, htmls: string
    cliente = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  for i, url in urls:
    if likely(verbose): echo i, "\t", url
    dir = folder / $i
    if not existsOrCreateDir(dir) and verbose: echo i, "\t", dir
    for i2, img_tag in findAll(parseHtml(cliente.getContent(url)), if picture: "source" else: "img", case_insensitive):
      src = img_tag.attr(if picture: "srcset" else: "src")
      if src.len < 2 or https_only and not src.normalize.startsWith("https:") or visited_urls and src in visited: continue
      if unlikely(print_alt): echo img_tag.attr("alt")
      if likely(verbose): echo dir / $i & "_" & $i2 & force_extension, "\t", src
      cliente.downloadFile(src, dir / $i & "_" & $i2 & force_extension)
      visited.add src
      htmls &= img_tag
      sleep delay
    if likely(html_output):
      if likely(verbose): echo  i, "\t", dir / $i & ".html"
      writeFile(dir / $i & ".html", htmls)
    if likely(csv_output):
      if likely(verbose): echo  i, "\t", dir / $i & ".csv"
      writeFile(dir / $i & ".csv", visited.join",")


proc scraper5*(list_of_urls: seq[string], sqlite_file_path: string, skip_ends_with: seq[string] = @[".jpg", ".png", ".pdf"], https_only: bool = false, case_insensitive: bool = true, deduplicate_urls: bool = false, visited_urls: bool = true, verbose: bool = true, delay: Natural = 0, timeout: int = -1, max_loops: uint16 = uint16.high, max_deep: byte = byte.high, only200: bool = false, agent: string = defUserAgent, redirects: byte = 5.byte, header: seq[(string, string)] = @[("DNT", "1")], proxy_url: string = "", proxy_auth: string = "") {.discardable, exportpy, noreturn.} =
  const table = sql"""create table if not exists web(
    id          integer   primary key,
    date        timestamp not null     default (strftime('%s', 'now')),
    url         text      not null,
    body        text      not null,
    headers     text      not null,
    status      text      not null,
    contenttype text      not null,
    deep        integer   not null
  ); """
  doAssert sqlite_file_path.endsWith".db", "sqlite_file_path must be *.db file extension: " & sqlite_file_path
  let
    db = db_sqlite.open(sqlite_file_path, "", "", "")
    proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  doAssert db.tryExec(table), "Error creating SQLite table or database: " & sqlite_file_path
  var
    deep: byte
    loop: uint16
    visited, tempLinks: seq[string]
    href, links: string
    urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
    cliente = newHttpClient(userAgent = agent, maxRedirects = redirects.int16, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  while urls.len > 0:
    if loop > max_loops: break
    loop = 0.uint16
    for i, url in urls:
      if deep > max_deep: break
      deep = 0.byte
      if likely(verbose): echo i, "\t", url
      for i2, link in findAll(parseHtml(cliente.getContent(url)), "a", case_insensitive):
        links &= $link & ",\n"
        href = link.attr("href")
        if likely(href.len > 1):
          for to_skip in skip_ends_with:
            if href.endsWith(to_skip): continue
          if href.startsWith("/"): href = url & href
          if visited_urls and href in visited: continue
          visited.add href
          tempLinks.add href
          if https_only and not href.normalize.startsWith("https:"): continue
          if likely(verbose): echo i2, "\t", href
          let req = cliente.get(href)
          if only200 and req.status != "200 OK": continue
          if not db.tryExec(sql"""INSERT INTO web(
            url,  body,             headers,              status,     contenttype,     deep) VALUES (?,?,?,?,?,?)""",
            href, req.body.strip(), pretty(%req.headers), req.status, req.contentType, deep): continue
        sleep delay
      inc deep
      inc loop
    urls = deduplicate(tempLinks)
  db.close()
  writeFile(sqlite_file_path.replace(".db", ".csv"), links)
