import
  asyncdispatch, db_sqlite, htmlparser, httpclient, json, nimpy, os, sequtils,
  pegs, re, strtabs, strutils, tables, threadpool, uri, ws, sequtils, xmltree


template clientify(url: string; userAgent: string; maxRedirects: int; proxyUrl: string; proxyAuth: string;
  timeout: int; http_headers: openArray[tuple[key: string; val: string]]; code: untyped): array[7, string] =
  var
    respons {.inject.}: Response
    cliente {.inject.} = createU HttpClient
  try:
    cliente[] = newHttpClient(
      timeout = timeout,
      userAgent = userAgent,
      maxRedirects = maxRedirects,
      headers = newHttpHeaders(http_headers),
      proxy = (if unlikely(proxyUrl.len > 1): newProxy(proxyUrl, proxyAuth) else: nil),
    )
    {.push, experimental: "implicitDeref".}
    code
    {.pop.}
  finally:
    cliente[].close()
    if cliente != nil:
      dealloc cliente
  [$respons.body, respons.contentType, respons.status, respons.version, url, try: $respons.contentLength except: "0", $respons.headers]


proc to_dict*(ftr_response: array[7, string]): Table[string, string] {.exportpy, noinit.} =
  ## From `["body", "content-type", "status", "version", "content-length", "headers"]` to dict.
  result = toTable({
    "body": ftr_response[0],
    "content-type": ftr_response[1],
    "status": ftr_response[2],
    "version": ftr_response[3],
    "url": ftr_response[4],
    "content-length": ftr_response[5],
    "headers": ftr_response[6],
  })


proc to_json*(ftr_response: array[7, string]): string {.exportpy, noinit.} =
  ## From `["body", "content-type", "status", "version", "content-length", "headers"]` to JSON.
  result = pretty(%*{
    "body": %ftr_response[0],
    "content-type": %ftr_response[1],
    "status": %ftr_response[2],
    "version": %ftr_response[3],
    "url": %ftr_response[4],
    "content-length": %ftr_response[5],
    "headers": %ftr_response[6],
  })


proc to_tuples*(ftr_response: array[7, string]): array[7, (string, string)] {.exportpy, noinit.} =
  ## From `["body", "content-type", "status", "version", "content-length", "headers"]` to array of tuples.
  result = [
    ("body", ftr_response[0]),
    ("content-type", ftr_response[1]),
    ("status", ftr_response[2]),
    ("version", ftr_response[3]),
    ("url", ftr_response[4]),
    ("content-length", ftr_response[5]),
    ("headers", ftr_response[6]),
  ]


proc get*(url: string; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.get(url)


proc post*(url: string; body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.post(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)


proc put*(url: string; body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.put(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)


proc patch*(url: string; body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.patch(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)


proc delete*(url: string; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.delete(url)


proc head*(url: string; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): array[7, string] {.exportpy, noinit.} =
  ## HTTP HEAD an URL to dictionary. HEAD do NOT have body by definition. May NOT have contentLength sometimes.
  clientify(url, user_agent, max_redirects, proxy_url, proxy_auth, timeout, http_headers):
    respons = cliente.head(url)


# ^ Basic HTTP Functions ########### V Extra HTTP Functions, go beyond requests


var client: HttpClient


proc init_client(timeout: int = -1; max_redirects: int = 9; user_agent: string = defUserAgent;
  headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]) {.exportpy.} =
  client = newHttpClient(timeout = timeout, userAgent = user_agent,
    maxRedirects = max_redirects, headers = newHttpHeaders(headers))


proc close_client() {.exportpy.} =
  client.close()


proc set_headers*(headers: openArray[tuple[key: string; val: string]]) {.exportpy.} =
  ## Set the HTTP Headers to the HTTP client.
  doAssert headers.len > 0, "HTTP Headers must not be empty list"
  client.headers = newHttpHeaders(headers)


proc set_timeout*(timeout: Positive) {.exportpy.} =
  ## Set the Timeout for the HTTP client.
  client.timeout = timeout


proc show_progress*() {.exportpy.} =
  client.onProgressChanged = (proc (t, p, s: BiggestInt) = echo(
    "{\"speed\": ", s div 1000, ",\t\"progress\": ", p, ",\t\"remaining\": ", t - p, ",\t\"total\": ", t, "}"))


proc multipartdata2str*(multipart_data: seq[tuple[name: string; content: string]]): string {.exportpy, noinit.} =
  result = $newMultipartData(multipart_data)


proc urlparse*(url: string): array[9, string] {.exportpy, noinit.} =
  let u = createU Uri
  u[] = uri.parseUri(url)
  result = [u[].scheme, u[].username, u[].password, u[].hostname, u[].port, u[].path, u[].query, u[].anchor, $u[].opaque]
  if u != nil:
    dealloc u


proc urlencode*(url: string; use_plus: bool = true): string {.exportpy, noinit.} =
  result = uri.encodeUrl(url, use_plus)


proc urldecode*(url: string; use_plus: bool = true): string {.exportpy, noinit.} =
  result = uri.decodeUrl(url, use_plus)


proc encodequery*(query: openArray[(string, string)]; use_plus: bool = true; omit_eq: bool = true): string {.exportpy, noinit.} =
  result = uri.encodeQuery(query, use_plus, omit_eq)


proc encodexml*(s: string): string {.exportpy, noinit.} =
  result = newStringOfCap(s.len + s.len shr 2)
  for i in 0 .. len(s) - 1:
    result.add(case s[i]
    of '&': "&amp;"
    of '<': "&lt;"
    of '>': "&gt;"
    of '\"': "&quot;"
    else: $s[i])


proc minifyhtml(html: string): string {.exportpy, noinit.} =
  result = html.strip.unindent.replace(re">\s+<", "> <")


proc datauri*(data: string; mime: string; encoding: string = "utf-8"): string {.exportpy, noinit.} =
  result = uri.getDataUri(data, mime, encoding)


proc debugs*() {.discardable, exportpy.} =
  ## Get the Config and print it to the terminal, for debug purposes only, human friendly.
  echo static(pretty(%*{
    "nimVersion": NimVersion, "httpCore": defUserAgent, "cpu": hostCPU, "os": hostOS,
    "endian": cpuEndian, "release": defined(release), "danger": defined(danger), "CompileDate": CompileDate, "CompileTime": CompileTime,
    "tempDir": getTempDir(), "ssl": defined(ssl), "currentCompilerExe": getCurrentCompilerExe(), "int.high": int.high
  }))


proc get2str*(url: string): string {.exportpy, noinit.} =
  ## HTTP GET body to string.
  result = client.getContent(url)


proc get2json*(url: string): string {.exportpy, noinit.} =
  ## HTTP GET body to JSON.
  result = client.getContent(url).parseJson.pretty


proc get2dict*(url: string): seq[Table[string, string]] {.exportpy.} =
  ## HTTP GET body to dictionary.
  for i in client.getContent(url).parseJson.pairs: result.add {i[0]: i[1].pretty}.toTable


proc post2str*(url, body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]): string {.exportpy, noinit.} =
  ## HTTP POST body to string.
  result = client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil)


proc post2list*(url, body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]): seq[string] {.exportpy, noinit.} =
  ## HTTP POST body to list of strings (this is designed for quick web scrapping).
  result = client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).strip.splitLines


proc post2json*(url, body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]): string {.exportpy, noinit.} =
  ## HTTP POST body to JSON.
  result = client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).parseJson.pretty


proc post2dict*(url, body: string; multipart_data: seq[tuple[name: string; content: string]] = @[]): seq[Table[string, string]] {.exportpy.} =
  ## HTTP POST body to dictionary.
  for i in client.postContent(url, body, multipart = if unlikely(multipart_data.len > 0): newMultipartData(multipart_data) else: nil).parseJson.pairs:
    result.add {i[0]: i[1].pretty}.toTable


proc download*(url, filename: string) {.discardable, exportpy.} =
  ## Download a file ASAP, from url, filename arguments.
  client.downloadFile(url, filename)


# ^ Extra HTTP Functions ################################# V Experimental stuff


proc get2str2*(list_of_urls: openArray[string]; threads: bool = false): seq[string] {.exportpy.} =
  ## HTTP GET body to string from a list of URLs.
  if threads:
    result = newSeq[string](list_of_urls.len)
    for i, url in list_of_urls: result[i] = ^ spawn client.getContent(url)
  else:
    for url in list_of_urls: result.add client.getContent(url)


proc download2*(list_of_files: openArray[tuple[url: string; filename: string]]; threads: bool = false; delay: Natural = 0) {.discardable, exportpy.} =
  ## Download a list of files ASAP, like ``[(url, filename), (url, filename), ...],``, ``threads=True`` will use multi-threading.
  if likely(delay == 0):
    if likely(threads):
      for item in list_of_files: spawn client.downloadFile(item[0], item[1])
    else:
      for item in list_of_files: client.downloadFile(item[0], item[1])
  else:
    for item in list_of_files:
      sleep delay
      client.downloadFile(item[0], item[1])


proc download3*(list_of_files: openArray[tuple[url: string; filename: string]]; delay: Positive = 1; tries: Positive = 9; backoff: Positive = 2; jitter: Positive = 2; verbose: bool = true) {.discardable, exportpy.} =
  ## Download a list of files ASAP, but if fails, retry again and again.
  let mdelay = createU(int)
  mdelay[] = delay
  let mtries = createU(int)
  mtries[] = tries
  while mtries[] > 1:
    try:
      if likely(verbose): echo "Retry " & $mtries[] & " of " & $tries
      for item in list_of_files:
        sleep mdelay[]
        if likely(verbose): echo item
        client.downloadFile(item[0], item[1])
      return
    except:
      if likely(verbose):
        echo getCurrentExceptionMsg()
        echo "Retrying in " & $mdelay[] & " microseconds" & (if mtries[] < 3: " (Warning: This is the last Retry!)." else: "...")
      sleep mdelay[] + mtries[] mod jitter * 100
      dec mtries[]
      mdelay[] *= backoff
  if mdelay != nil:
    dealloc mdelay
  if mtries != nil:
    dealloc mtries


proc scraper*(list_of_urls: openArray[string]; html_tag: string = "a"; case_insensitive: bool = true; deduplicate_urls: bool = false; threads: bool = false): seq[string] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  result = newSeq[string](urls.len)
  if likely(threads):
    for i, url in urls: result[i] = ^ spawn $findAll(parseHtml(client.getContent(url)), html_tag, case_insensitive)
  else:
    for i, url in urls: result[i] = $findAll(parseHtml(client.getContent(url)), html_tag, case_insensitive)


proc scraper2*(list_of_urls: seq[string]; list_of_tags: seq[string] = @["a"]; verbose: bool = true; case_insensitive: bool = true; deduplicate_urls: bool = false; threads: bool = false; delay: Natural = 0; timeout: int = -1; agent: string = defUserAgent; redirects: Positive = 5; header: seq[(string, string)] = @[("DNT", "1")]; proxy_url: string = ""; proxy_auth: string = ""): seq[seq[string]] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  var cliente = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  result = newSeq[seq[string]](urls.len)
  if likely(threads):
    for i, url in urls:
      for tag in list_of_tags: result[i] = ^ spawn map(findAll(parseHtml(cliente.getContent(url)), tag, case_insensitive), proc(s: any): string = $s )
  else:
    for i, url in urls:
      if likely(verbose): echo i, "\t", url
      for tag in list_of_tags:
        result[i] = map(findAll(parseHtml(cliente.getContent(url)), tag, case_insensitive), proc(s: any): string = $s)
        sleep delay


proc scraper3*(list_of_urls: seq[string]; list_of_tags: seq[string] = @["a"]; start_with: string = ""; end_with: string = ""; line_start: Natural = 0; line_end: Positive = 1; verbose: bool = true; case_insensitive: bool = true; deduplicate_urls: bool = false; delay: Natural = 0; header: seq[(string, string)] = @[("DNT", "1")]; pre_replacements: seq[(string, string)] = @[]; post_replacements: seq[(string, string)] = @[]; timeout: int = -1; agent: string = defUserAgent; redirects: Positive = 5; proxy_url: string = ""; proxy_auth: string = ""): seq[seq[string]] {.exportpy.} =
  let urls = createU(seq[string])
  urls[] = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let cliente = createU(HttpClient)
  cliente[] = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = (if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil), timeout = timeout, headers = newHttpHeaders(header))
  result = newSeq[seq[string]](urls[].len)
  for i, url in urls[]:
    if likely(verbose): echo i, "\t", url
    for tag in list_of_tags:
      sleep delay
      for item in findAll(parseHtml(if pre_replacements.len > 0: cliente[].getContent(url).multiReplace(pre_replacements) else: cliente[].getContent(url)), tag, case_insensitive):
        if start_with.len > 0 and end_with.len > 0:
          if strip($item).startsWith(start_with) and strip($item).endsWith(end_with): result[i].add(if post_replacements.len > 0: strip($item).multiReplace(post_replacements)[line_start..^line_end] else: strip($item)[line_start..^line_end])
          else: continue
        else: result[i].add(if post_replacements.len > 0: strip($item).multiReplace(post_replacements)[line_start..^line_end] else: strip($item)[line_start..^line_end])
  if cliente != nil:
    dealloc cliente
  if urls != nil:
    dealloc urls


proc scraper4*(list_of_urls: seq[string]; folder: string = getCurrentDir(); force_extension: string = ".jpg"; https_only: bool = false; print_alt: bool = false; picture: bool = false; case_insensitive: bool = true; deduplicate_urls: bool = false; visited_urls: bool = true; html_output: bool = true; csv_output: bool = true; verbose: bool = true; delay: Natural = 0; timeout: int = -1; agent: string = defUserAgent; redirects: Positive = 5; header: seq[(string, string)] = @[("DNT", "1")]; proxy_url: string = ""; proxy_auth: string = "") {.exportpy, discardable.} =
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
      if likely(verbose): echo i, "\t", dir / $i & ".html"
      writeFile(dir / $i & ".html", htmls)
    if likely(csv_output):
      if likely(verbose): echo i, "\t", dir / $i & ".csv"
      writeFile(dir / $i & ".csv", visited.join",")


proc scraper5*(list_of_urls: seq[string]; sqlite_file_path: string; skip_ends_with: seq[string] = @[".jpg", ".png", ".pdf"]; https_only: bool = false; case_insensitive: bool = true; deduplicate_urls: bool = false; visited_urls: bool = true; verbose: bool = true; delay: Natural = 0; timeout: int = -1; max_loops: uint16 = uint16.high; max_deep: byte = byte.high; only200: bool = false; agent: string = defUserAgent; redirects: byte = 5.byte; header: seq[(string, string)] = @[("DNT", "1")]; proxy_url: string = ""; proxy_auth: string = "") {.discardable, exportpy, noreturn.} =
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


proc scraper6*(list_of_urls: seq[string]; list_of_regex: seq[string]; multiline: bool = false; dot: bool = false; extended: bool = false; case_insensitive: bool = true; post_replacement_regex: string = "";
  post_replacement_by: string = ""; re_start: Natural = 0; start_with: string = ""; end_with: string = ""; verbose: bool = true; deduplicate_urls: bool = false; delay: Natural = 0;
  header: seq[(string, string)] = @[("DNT", "1")]; timeout: int = -1; agent: string = defUserAgent; redirects: Positive = 5; proxy_url: string = ""; proxy_auth: string = ""): seq[seq[string]] {.exportpy.} =
  let urls = if unlikely(deduplicate_urls): deduplicate(list_of_urls) else: @(list_of_urls)
  let proxi = if unlikely(proxy_url.len > 0): newProxy(proxy_url, proxy_auth) else: nil
  var cliente = newHttpClient(userAgent = agent, maxRedirects = redirects, proxy = proxi, timeout = timeout)
  cliente.headers = newHttpHeaders(header)
  result = newSeq[seq[string]](urls.len)
  var reflags = {reStudy}
  if case_insensitive: incl(reflags, reIgnoreCase)
  if multiline: incl(reflags, reMultiLine)
  if dot: incl(reflags, reDotAll)
  if extended: incl(reflags, reExtended)
  for i, url in urls:
    if likely(verbose): echo i, "\t", url
    for rege in list_of_regex:
      sleep delay
      for item in findAll(cliente.getContent(url), re(rege, reflags), re_start):
        if start_with.len > 0 and end_with.len > 0:
          if item.startsWith(re(start_with, reflags)) and item.endsWith(re(end_with, reflags)):
            result[i].add(if post_replacement_regex.len > 0 and post_replacement_by.len > 0: replacef(item, re(post_replacement_regex, reflags), post_replacement_by) else: item)
          else: continue
        else: result[i].add(if post_replacement_regex.len > 0 and post_replacement_by.len > 0: replacef(item, re(post_replacement_regex, reflags), post_replacement_by) else: item)


func match(n: XmlNode; s: tuple[id: string; tag: string; combi: char; class: seq[string]]): bool =
  result = (s.tag.len == 0 or s.tag == n.tag)
  if result and s.id.len > 0: result = s.id == n.attr"id"
  if result and s.class.len > 0:
    for class in s.class: result = n.attr("class").len > 0 and class in n.attr("class").split

func find(parent: XmlNode; selector: tuple[id: string; tag: string; combi: char; class: seq[string]]; found: var seq[XmlNode]) =
  for child in parent.items:
    if child.kind == xnElement:
      if match(child, selector): found.add(child)
      if selector.combi != '>': child.find(selector, found)

proc find(parents: var seq[XmlNode]; selector: tuple[id: string; tag: string; combi: char; class: seq[string]]) =
  var found: seq[XmlNode]
  for p in parents: find(p, selector, found)
  parents = found

proc multiFind(parent: XmlNode; selectors: seq[tuple[id: string; tag: string; combi: char; class: seq[string]]]; found: var seq[XmlNode]) =
  var matches: seq[int]
  var start: seq[int]
  start = @[0]
  for i in 0 ..< selectors.len:
    var selector = selectors[i]
    matches = @[]
    for j in start:
      for k in j ..< parent.len:
        var child = parent[k]
        if child.kind == xnElement and match(child, selector):
          if i < selectors.len - 1: matches.add(k + 1)
          else: found.add(child)
          if selector.combi == '+': break
    start = matches

proc multiFind(parents: var seq[XmlNode]; selectors: seq[tuple[id: string; tag: string; combi: char; class: seq[string]]]) =
  var found: seq[XmlNode]
  for p in parents: multiFind(p, selectors, found)
  parents = found

proc parseSelector(token: string): tuple[id: string; tag: string; combi: char; class: seq[string]] =
  result = (id: "", tag: "", combi: ' ', class: @[])
  if token == "*": result.tag = "*"
  elif token =~ peg"""\s*{\ident}?({'#'\ident})? ({\.[a-zA-Z0-9_][a-zA-Z0-9_\-]*})* {\[[a-zA-Z][a-zA-Z0-9_\-]*\s*([\*\^\$\~]?\=\s*[\'""]?(\s*\ident\s*)+[\'""]?)?\]}*""":
    for i in 0 ..< matches.len:
      if matches[i].len == 0: continue
      case matches[i][0]:
      of '#': result.id = matches[i][1..^1]
      of '.': result.class.add(matches[i][1..^1])
      else: result.tag = matches[i]

proc findCssImpl(node: var seq[XmlNode]; cssSelector: string) {.noinline.} =
  assert cssSelector.len > 0, "cssSelector must not be empty string"
  var tokens = cssSelector.strip.split
  for pos in 0 ..< tokens.len:
    var isSimple = true
    if pos > 0 and (tokens[pos - 1] == "+" or tokens[pos - 1] == "~"): continue
    if tokens[pos] in [">", "~", "+"]: continue
    var selector = parseSelector(tokens[pos])
    if pos > 0 and tokens[pos-1] == ">": selector.combi = '>'
    var selectors = @[selector]
    var i = 1
    while true:
      if pos + i >= tokens.len: break
      var nextCombi = tokens[pos + i]
      if nextCombi == "+" or nextCombi == "~":
        if pos + i + 1 >= tokens.len: assert false, "Selector not found"
      else: break
      isSimple = false
      var nextToken = tokens[pos + i + 1]
      inc i, 2
      var temp = parseSelector(nextToken)
      temp.combi = nextCombi[0]
      selectors.add(temp)
    if isSimple: node.find(selectors[0]) else: node.multiFind(selectors)

proc scraper7*(url: string; css_selector: string; user_agent: string = defUserAgent; max_redirects: int = 9; proxy_url: string = ""; proxy_auth: string = ""; timeout: int = -1; http_headers: openArray[tuple[key: string; val: string]] = @[("dnt", "1")]): seq[string] {.exportpy.} =
  assert url.len > 0, "url must not be empty string"
  var clien = createU HttpClient
  var temp = create(seq[XmlNode])
  try:
    clien[] = newHttpClient(
        timeout = timeout,
        userAgent = userAgent,
        maxRedirects = maxRedirects,
        headers = newHttpHeaders(http_headers),
        proxy = (if unlikely(proxyUrl.len > 1): newProxy(proxyUrl, proxyAuth) else: nil),
      )
    temp[] = @[htmlparser.parseHtml(clien[].getContent(url))]
    findCssImpl(temp[], cssSelector)
    for item in temp[]:
      result.add $item
  finally:
    if temp != nil:
      dealloc temp
    clien[].close()
    if clien != nil:
      dealloc clien


proc websocket_ping*(url: string; data: string = ""; hangup: bool = false): string {.exportpy.} =
  assert url.len > 0, "url must not be empty string"
  result = waitFor (proc (url, data: string; hangup: bool): Future[string] {.async, inline.} =
    let soquetito = create(WebSocket)
    soquetito[] = await newWebSocket(url)
    echo "WebSocket ", soquetito[].readyState
    await soquetito[].send(data, Opcode.Ping)
    result = await(soquetito[].receivePacket())[1]
    if hangup: soquetito[].hangup() else: soquetito[].close()
    if soquetito != nil:
      dealloc soquetito
  )(url, data, hangup)


proc websocket_send*(url: string; data: string; is_text: bool = true; hangup: bool = false): string {.exportpy.} =
  assert url.len > 0, "url must not be empty string"
  assert data.len > 0, "data must not be empty string"
  result = waitFor (proc (url, data: string; is_text: bool; hangup: bool): Future[string] {.async, inline.} =
    let soquetito = create(WebSocket)
    soquetito[] = await newWebSocket(url)
    echo "WebSocket ", soquetito[].readyState
    await soquetito[].send(data, (if is_text: Opcode.Text else: Opcode.Binary))
    result = await(soquetito[].receivePacket())[1]
    if hangup: soquetito[].hangup() else: soquetito[].close()
    if soquetito != nil:
      dealloc soquetito
  )(url, data, is_text, hangup)
