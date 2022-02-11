import std/[net,  macros, strutils, times, json, httpcore, importutils, parseutils, uri]

proc fetch*(url: string; metod: string;
    headers: seq[(string, string)] = @[("User-Agent", "x")];
    body: string = ""; timeout: int = -1; port: int = 80; portSsl: int = 443;
    parseHeader: bool = true; parseStatus: bool = true; parseBody: bool = true; bodyOnly: static[bool] = false): auto =
  var
    res: string
    chunked: bool
    contentLength: int
    chunks: seq[string]
    url: Uri = parseUri(url)
    socket: Socket = newSocket()
    port: Port = port.Port
    portSsl: Port = portSsl.Port

  template parseHttpCode(s: string): int {.used.} =
    when defined(danger):
      template char2Int(c: '0'..'9'; pos: static int): int =
        case c
        of '1': static(1 * pos)
        of '2': static(2 * pos)
        of '3': static(3 * pos)
        of '4': static(4 * pos)
        of '5': static(5 * pos)
        of '6': static(6 * pos)
        of '7': static(7 * pos)
        of '8': static(8 * pos)
        of '9': static(9 * pos)
        else:   0
      char2Int(s[9], 100) + char2Int(s[10], 10) + char2Int(s[11], 1)
    else: parseInt(s[9..11])

  func parseHeaders(data: string): seq[(string, string)] {.inline, used, raises: [].} =
    var i = 0
    while data[i] != '\l': inc i
    inc i
    var value = false
    var current: (string, string)
    while i < data.len:
      case data[i]
      of ':':
        if value: current[1].add ':'
        value = true
      of ' ':
        if value:
          if current[1].len != 0: current[1].add data[i]
        else: current[0].add(data[i])
      of '\c': discard
      of '\l':
        if current[0].len == 0: return result
        result.add current
        value = false
        current = ("", "")
      else:
        if value: current[1].add data[i] else: current[0].add data[i]
      inc i
    return

  func toString(url: Uri; metod: string; headers: openArray[(string, string)]; body: string): string {.raises: [].} =
    var it: char
    var temp: string = url.path
    macro unrollStringOps(x: ForLoopStmt) =
      result = newStmtList()
      for chara in x[^2][^2].strVal:
        result.add nnkAsgn.newTree(x[^2][^1], chara.newLit)
        result.add x[^1]
    if unlikely(temp.len == 0): temp = "/"
    if url.query.len > 0:
      temp.add '?'
      temp.add url.query
    for _ in unrollStringOps(metod, it): result.add it
    result.add ' '
    result.add temp
    for _ in unrollStringOps(" HTTP/1.1\r\nHost: ", it): result.add it
    result.add url.hostname
    for _ in unrollStringOps("\r\n", it): result.add it
    temp.setLen 0
    for header in headers:
      temp.add header[0]
      for _ in unrollStringOps(": ", it):   temp.add it
      temp.add header[1]
      for _ in unrollStringOps("\r\n", it): temp.add it
    for _ in unrollStringOps("\r\n", it):   temp.add it
    result.add temp
    result.add body

  if likely(url.scheme == "https"):
    var ctx =
      try:    newContext(verifyMode = CVerifyNone)
      except: raise newException(IOError, getCurrentExceptionMsg())
    socket.connect(url.hostname, portSsl, timeout)
    try:    ctx.wrapConnectedSocket(socket, handshakeAsClient, url.hostname)
    except: raise newException(IOError, getCurrentExceptionMsg())
  else: socket.connect(url.hostname, port, timeout)
  socket.send(toString(url, metod, headers, body))
  while true:
    let line = socket.recvLine(timeout)
    res.add line
    res.add '\r'
    res.add '\n'
    let lineLower = line.toLowerAscii()
    if line == "\r\n":                              break
    elif lineLower.startsWith("content-length:"):   contentLength = parseInt(line.split(' ')[1])
    elif lineLower == "transfer-encoding: chunked": chunked = true
  if chunked:
    while true:
      var chunkLenStr: string
      while true:
        var readChar: char
        let readLen = socket.recv(readChar.addr, 1, timeout)
        doAssert readLen == 1
        chunkLenStr.add(readChar)
        if chunkLenStr.endsWith("\r\n"): break
      if chunkLenStr == "\r\n": break
      var chunkLen: int
      discard parseHex(chunkLenStr, chunkLen)
      if chunkLen == 0: break
      var chunk = newString(chunkLen)
      let readLen = socket.recv(chunk[0].addr, chunkLen, timeout)
      doAssert readLen == chunkLen
      chunks.add(chunk)
      var endStr = newString(2)
      let readLen2 {.used.} = socket.recv(endStr[0].addr, 2, timeout)
  else:
    var chunk = newString(contentLength)
    let readLen {.used.} = socket.recv(chunk[0].addr, contentLength, timeout)
    chunks.add chunk
  when bodyOnly: result = chunks
  else:
    privateAccess url.type
    result = (url: url, metod: metod, isIpv6: url.isIpv6,
              headers: if parseHeader: parseHeaders(res)  else: @[],
              code:    if parseStatus: parseHttpCode(res) else: 0,
              body:    if parseBody:   chunks             else: @[])
  close socket


proc get*(url: string): auto =
  fetch(url, "GET")


proc getContent*(url: string): seq[string] =
  fetch(url, "GET", bodyOnly = true)


proc post*(url: string; body: string): auto =
  fetch(url, "POST", body = body)


proc postContent*(url: string; body: string): seq[string] =
  fetch(url, "POST", body = body, bodyOnly = true)


proc put*(url: string; body: string): auto =
  fetch(url, "PUT", body = body)


proc putContent*(url: string; body: string): seq[string] =
  fetch(url, "PUT", body = body, bodyOnly = true)


proc patch*(url: string; body: string): auto =
  fetch(url, "PATCH", body = body)


proc patchContent*(url: string; body: string): seq[string] =
  fetch(url, "PATCH", body = body, bodyOnly = true)


proc delete*(url: string): auto =
  fetch(url, "DELETE")


proc deleteContent*(url: string): seq[string] =
  fetch(url, "DELETE", bodyOnly = true)


proc downloadFile*(url: string; filename: string) =
  writeFile(filename, fetch(url, "GET", bodyOnly = true).join)


proc downloadFile*(files: seq[tuple[url: string; path: string]]) =
  for url_file in files:
    writeFile(url_file.path, fetch(url_file.url, "GET", bodyOnly = true).join)


runnableExamples"--gc:orc --experimental:strictFuncs -d:ssl -d:nimStressOrc --import:std/httpcore":
  import std/json               # GET and POST from JSON to JSON directly.
  from std/uri import parseUri  # To use Uri.
  block:
    doAssert get(parseUri"http://httpbin.org/get").code == Http200
    doAssert getContent(parseUri"http://httpbin.org/get").len > 0
  block:
    doAssert post(parseUri"http://httpbin.org/post", "data here").code == Http200
    doAssert postContent(parseUri"http://httpbin.org/post", "data here").len > 0
  block:
    doAssert delete(parseUri"http://httpbin.org/delete").code == Http200
    doAssert deleteContent(parseUri"http://httpbin.org/delete").len > 0
  block:
    doAssert put(parseUri"http://httpbin.org/put", "data here").code == Http200
    doAssert putContent(parseUri"http://httpbin.org/put", "data here").len > 0
  block:
    doAssert patch(parseUri"http://httpbin.org/patch", "data here").code == Http200
    doAssert patchContent(parseUri"http://httpbin.org/patch", "data here").len > 0
  block:
    let jsonData: JsonNode = %*{"key": "value", "other": 42} # GET and POST from JSON to JSON
    doAssert getJson(parseUri"http://httpbin.org/get") is JsonNode
    doAssert postJson(parseUri"http://httpbin.org/post", jsonData) is JsonNode
  block:
    downloadFile parseUri"http://httpbin.org/image/png", "temp.png" # Download 1 or multiple files
    downloadFile [(url: parseUri"http://httpbin.org/image/png", path: "temp.png"), (url: parseUri"http://httpbin.org/image/jpg", path: "temp.jpg")]
    doAssert default_headers(body = "data here", proxyUser = "root", proxyPassword = "password") is array[5, (string, string)]
