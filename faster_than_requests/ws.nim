import asyncdispatch, asynchttpserver, asyncnet, base64, httpclient, httpcore,
    nativesockets, net, random, std/sha1, streams, strformat, strutils, uri

type
  ReadyState* = enum
    Connecting = 0 # The connection is not yet open.
    Open = 1       # The connection is open and ready to communicate.
    Closing = 2    # The connection is in the process of closing.
    Closed = 3     # The connection is closed or couldn't be opened.

  WebSocket* = ref object
    tcpSocket*: AsyncSocket
    version*: int
    key*: string
    protocol*: string
    readyState*: ReadyState
    masked*: bool # send masked packets

  WebSocketError* = object of IOError

template `[]`(value: uint8, index: int): bool =
  ## Get bits from uint8, uint8[2] gets 2nd bit.
  (value and (1 shl (7 - index))) != 0

proc nibbleFromChar(c: char): int =
  ## Converts hex chars like `0` to 0 and `F` to 15.
  case c:
    of '0'..'9': (ord(c) - ord('0'))
    of 'a'..'f': (ord(c) - ord('a') + 10)
    of 'A'..'F': (ord(c) - ord('A') + 10)
    else: 255

proc nibbleToChar(value: int): char =
  ## Converts number like 0 to `0` and 15 to `fg`.
  case value:
    of 0..9: char(value + ord('0'))
    else: char(value + ord('a') - 10)

proc decodeBase16*(str: string): string =
  ## Base16 decode a string.
  result = newString(str.len div 2)
  for i in 0 ..< result.len:
    result[i] = chr(
      (nibbleFromChar(str[2 * i]) shl 4) or
      nibbleFromChar(str[2 * i + 1]))

proc encodeBase16*(str: string): string =
  ## Base61 encode a string.
  result = newString(str.len * 2)
  for i, c in str:
    result[i * 2] = nibbleToChar(ord(c) shr 4)
    result[i * 2 + 1] = nibbleToChar(ord(c) and 0x0f)

proc genMaskKey(): array[4, char] =
  ## Generates a random key of 4 random chars.
  proc r(): char = char(rand(255))
  [r(), r(), r(), r()]

proc toSeq*(hv: HttpHeaderValues): seq[string] =
  ## Casts HttpHeaderValues to seq of strings.
  cast[seq[string]](hv)

proc handshake*(ws: WebSocket, headers: HttpHeaders) {.async.} =
  ## Handles the websocket handshake.
  ws.version = parseInt(headers["Sec-WebSocket-Version"])
  ws.key = headers["Sec-WebSocket-Key"].strip()
  if headers.hasKey("Sec-WebSocket-Protocol"):
    let wantProtocol = headers["Sec-WebSocket-Protocol"].strip()
    if ws.protocol != wantProtocol:
      raise newException(WebSocketError,
        &"Protocol mismatch (expected: {ws.protocol}, got: {wantProtocol})")

  let
    sh = secureHash(ws.key & "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
    acceptKey = base64.encode(decodeBase16($sh))

  var response = "HTTP/1.1 101 Web Socket Protocol Handshake\c\L"
  response.add("Sec-WebSocket-Accept: " & acceptKey & "\c\L")
  response.add("Connection: Upgrade\c\L")
  response.add("Upgrade: webSocket\c\L")

  if ws.protocol != "":
    response.add("Sec-WebSocket-Protocol: " & ws.protocol & "\c\L")
  response.add "\c\L"

  await ws.tcpSocket.send(response)
  ws.readyState = Open

proc newWebSocket*(req: Request, protocol: string = ""): Future[WebSocket] {.async.} =
  ## Creates a new socket from a request.
  try:
    if not req.headers.hasKey("Sec-WebSocket-Version"):
      raise newException(WebSocketError, "Invalid WebSocket handshake")

    var ws = WebSocket()
    ws.masked = false
    ws.tcpSocket = req.client
    ws.protocol = protocol
    await ws.handshake(req.headers)
    return ws

  except ValueError, KeyError:
    # Wrap all exceptions in a WebSocketError so its easy to catch.
    raise newException(
      WebSocketError,
      "Failed to create WebSocket from request: " & getCurrentExceptionMsg()
    )

proc newWebSocket*(url: string, protocols: seq[string] = @[]):
    Future[WebSocket] {.async.} =
  ## Creates a new WebSocket connection,
  ## protocol is optional, "" means no protocol.
  var ws = WebSocket()
  ws.masked = true
  ws.tcpSocket = newAsyncSocket()

  var uri = parseUri(url)
  var port = Port(9001)
  case uri.scheme
    of "wss":
      uri.scheme = "https"
      port = Port(443)
    of "ws":
      uri.scheme = "http"
      port = Port(80)
    else:
      raise newException(WebSocketError,
          &"Scheme {uri.scheme} not supported yet")
  if uri.port.len > 0:
    port = Port(parseInt(uri.port))

  var client = newAsyncHttpClient()

  # Generate secure key.
  var secStr = newString(16)
  for i in 0 ..< secStr.len:
    secStr[i] = char rand(255)
  let secKey = base64.encode(secStr)

  client.headers = newHttpHeaders({
    "Connection": "Upgrade",
    "Upgrade": "websocket",
    "Sec-WebSocket-Version": "13",
    "Sec-WebSocket-Key": secKey,
    # TODO: implement extra extensions
    # "Sec-WebSocket-Extensions": "permessage-deflate; client_max_window_bits"
  })
  if protocols.len > 0:
    client.headers["Sec-WebSocket-Protocol"] = protocols.join(", ")
  var res = await client.get($uri)
  let hasUpgrade = res.headers.getOrDefault("Upgrade")
  if hasUpgrade.toLowerAscii() != "websocket":
    raise newException(WebSocketError,
        &"Failed to Upgrade (Possibly Connected to non-WebSocket url)")
  if protocols.len > 0:
    var resProtocol = res.headers.getOrDefault("Sec-WebSocket-Protocol")
    if resProtocol in protocols:
      ws.protocol = resProtocol
    else:
      raise newException(WebSocketError,
        &"Protocol mismatch (expected: {protocols}, got: {resProtocol})")
  ws.tcpSocket = client.getSocket()

  ws.readyState = Open
  return ws

proc newWebSocket*(url: string, protocol: string):
    Future[WebSocket] {.async.} =
  return await newWebSocket(url, @[protocol])

type
  Opcode* = enum
    ## 4 bits. Defines the interpretation of the "Payload data".
    Cont = 0x0   ## Denotes a continuation frame.
    Text = 0x1   ## Denotes a text frame.
    Binary = 0x2 ## Denotes a binary frame.
    # 3-7 are reserved for further non-control frames.
    Close = 0x8  ## Denotes a connection close.
    Ping = 0x9   ## Denotes a ping.
    Pong = 0xa   ## Denotes a pong.
    # B-F are reserved for further control frames.

  #[
  +---------------------------------------------------------------+
  |0                   1                   2                   3  |
  |0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1|
  +-+-+-+-+-------+-+-------------+-------------------------------+
  |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
  |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
  |N|V|V|V|       |S|             |   (if payload len==126/127)   |
  | |1|2|3|       |K|             |                               |
  +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
  |     Extended payload length continued, if payload len == 127  |
  + - - - - - - - - - - - - - - - +-------------------------------+
  |                               |Masking-key, if MASK set to 1  |
  +-------------------------------+-------------------------------+
  | Masking-key (continued)       |          Payload Data         |
  +-------------------------------- - - - - - - - - - - - - - - - +
  :                     Payload Data continued ...                :
  + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
  |                     Payload Data continued ...                |
  +---------------------------------------------------------------+
  ]#
  Frame = tuple
    fin: bool ## Indicates that this is the final fragment in a message.
    rsv1: bool ## MUST be 0 unless negotiated that defines meanings
    rsv2: bool ## MUST be 0
    rsv3: bool ## MUST be 0
    opcode: Opcode ## Defines the interpretation of the "Payload data".
    mask: bool ## Defines whether the "Payload data" is masked.
    data: string ## Payload data

proc encodeFrame(f: Frame): string =
  ## Encodes a frame into a string buffer.
  ## See https://tools.ietf.org/html/rfc6455#section-5.2

  var ret = newStringStream()

  var b0 = (f.opcode.uint8 and 0x0f) # 0th byte: opcodes and flags.
  if f.fin:
    b0 = b0 or 128u8

  ret.write(b0)

  # Payload length can be 7 bits, 7+16 bits, or 7+64 bits.
  # 1st byte: payload len start and mask bit.
  var b1 = 0u8

  if f.data.len <= 125:
    b1 = f.data.len.uint8
  elif f.data.len > 125 and f.data.len <= 0xffff:
    b1 = 126u8
  else:
    b1 = 127u8

  if f.mask:
    b1 = b1 or (1 shl 7)

  ret.write(uint8 b1)

  # Only need more bytes if data len is 7+16 bits, or 7+64 bits.
  if f.data.len > 125 and f.data.len <= 0xffff:
    # Data len is 7+16 bits.
    ret.write(htons(f.data.len.uint16))
  elif f.data.len > 0xffff:
    # Data len is 7+64 bits.
    var len = f.data.len
    ret.write char((len shr 56) and 255)
    ret.write char((len shr 48) and 255)
    ret.write char((len shr 40) and 255)
    ret.write char((len shr 32) and 255)
    ret.write char((len shr 24) and 255)
    ret.write char((len shr 16) and 255)
    ret.write char((len shr 8) and 255)
    ret.write char(len and 255)

  var data = f.data

  if f.mask:
    # If we need to mask it generate random mask key and mask the data.
    let maskKey = genMaskKey()
    for i in 0..<data.len:
      data[i] = (data[i].uint8 xor maskKey[i mod 4].uint8).char
    # Write mask key next.
    ret.write(maskKey)

  # Write the data.
  ret.write(data)
  ret.setPosition(0)
  return ret.readAll()

proc send*(
  ws: WebSocket, text: string, opcode = Opcode.Text
): Future[void] {.async.} =
  ## This is the main method used to send data via this WebSocket.
  try:
    var frame = encodeFrame((
      fin: true,
      rsv1: false,
      rsv2: false,
      rsv3: false,
      opcode: opcode,
      mask: ws.masked,
      data: text
    ))
    const maxSize = 1024*1024
    # Send stuff in 1 megabyte chunks to prevent IOErrors.
    # This really large packets.
    var i = 0
    while i < frame.len:
      let data = frame[i ..< min(frame.len, i + maxSize)]
      await ws.tcpSocket.send(data)
      i += maxSize
      await sleepAsync(1)
  except Defect, IOError, OSError:
    # Wrap all exceptions in a WebSocketError so its easy to catch
    raise newException(
      WebSocketError,
      "Failed to send data: " & getCurrentExceptionMsg()
    )

proc recvFrame(ws: WebSocket): Future[Frame] {.async.} =
  ## Gets a frame from the WebSocket.
  ## See https://tools.ietf.org/html/rfc6455#section-5.2

  if cast[int](ws.tcpSocket.getFd) == -1:
    ws.readyState = Closed
    raise newException(WebSocketError, "Socket closed")

  # Grab the header.
  var header: string
  try:
    header = await ws.tcpSocket.recv(2)
  except:
    raise newException(WebSocketError, "Socket closed")

  if header.len != 2:
    ws.readyState = Closed
    raise newException(WebSocketError, "Socket closed")

  let b0 = header[0].uint8
  let b1 = header[1].uint8

  # Read the flags and fin from the header.
  result.fin = b0[0]
  result.rsv1 = b0[1]
  result.rsv2 = b0[2]
  result.rsv3 = b0[3]
  result.opcode = (b0 and 0x0f).Opcode

  # If any of the rsv are set close the socket.
  if result.rsv1 or result.rsv2 or result.rsv3:
    ws.readyState = Closed
    raise newException(WebSocketError, "WebSocket rsv mismatch")

  # Payload length can be 7 bits, 7+16 bits, or 7+64 bits.
  var finalLen: uint = 0

  let headerLen = uint(b1 and 0x7f)
  if headerLen == 0x7e:
    # Length must be 7+16 bits.
    var length = await ws.tcpSocket.recv(2)
    if length.len != 2:
      raise newException(WebSocketError, "Socket closed")
    finalLen = cast[ptr uint16](length[0].addr)[].htons

  elif headerLen == 0x7f:
    # Length must be 7+64 bits.
    var length = await ws.tcpSocket.recv(8)
    if length.len != 8:
      raise newException(WebSocketError, "Socket closed")
    finalLen = cast[ptr uint32](length[4].addr)[].htonl

  else:
    # Length must be 7 bits.
    finalLen = headerLen

  # Do we need to apply mask?
  result.mask = (b1 and 0x80) == 0x80

  if ws.masked == result.mask:
    # Server sends unmasked but accepts only masked.
    # Client sends masked but accepts only unmasked.
    raise newException(WebSocketError, "Socket mask mismatch")

  var maskKey = ""
  if result.mask:
    # Read the mask.
    maskKey = await ws.tcpSocket.recv(4)
    if maskKey.len != 4:
      raise newException(WebSocketError, "Socket closed")

  # Read the data.
  result.data = await ws.tcpSocket.recv(int finalLen)
  if result.data.len != int finalLen:
    raise newException(WebSocketError, "Socket closed")

  if result.mask:
    # Apply mask, if we need too.
    for i in 0 ..< result.data.len:
      result.data[i] = (result.data[i].uint8 xor maskKey[i mod 4].uint8).char

proc receivePacket*(ws: WebSocket): Future[(Opcode, string)] {.async.} =
  ## Wait for a string or binary packet to come in.
  var frame = await ws.recvFrame()
  result[0] = frame.opcode
  result[1] = frame.data
  # If there are more parts read and wait for them
  while frame.fin != true:
    frame = await ws.recvFrame()
    if frame.opcode != Cont:
      raise newException(WebSocketError, "Socket closed")
    result[1].add frame.data
  return

proc receiveStrPacket*(ws: WebSocket): Future[string] {.async.} =
  ## Wait only for a string packet to come. Errors out on Binary packets.
  let (opcode, data) = await ws.receivePacket()
  case opcode:
    of Text:
      return data
    of Binary:
      raise newException(WebSocketError,
        "Expected string packet, received binary packet")
    of Ping:
      await ws.send(data, Pong)
    of Pong:
      discard
    of Cont:
      discard
    of Close:
      ws.readyState = Closed
      raise newException(WebSocketError, "Socket closed")

proc receiveBinaryPacket*(ws: WebSocket): Future[seq[byte]] {.async.} =
  ## Wait only for a binary packet to come. Errors out on string packets.
  let (opcode, data) = await ws.receivePacket()
  case opcode:
    of Text:
      raise newException(WebSocketError,
        "Expected binary packet, received string packet")
    of Binary:
      return cast[seq[byte]](data)
    of Ping:
      await ws.send(data, Pong)
    of Pong:
      discard
    of Cont:
      discard
    of Close:
      ws.readyState = Closed
      raise newException(WebSocketError, "Socket closed")

proc ping*(ws: WebSocket, data = "") {.async.} =
  ## Sends a ping to the other end, both server and client can send a ping.
  ## Data is optional.
  await ws.send(data, Ping)

proc setupPings*(ws: WebSocket, seconds: float) =
  ## Sets a delay on when to send pings.
  proc pingLoop() {.async.} =
    while ws.readyState != Closed:
      await ws.ping()
      await sleepAsync(1000.0 * seconds)
  asyncCheck pingLoop()

proc hangup*(ws: WebSocket) =
  ## Closes the Socket without sending a close packet.
  ws.readyState = Closed
  try:
    ws.tcpSocket.close()
  except:
    raise newException(
      WebSocketError,
      "Failed to hangup socket " & getCurrentExceptionMsg()
    )

proc close*(ws: WebSocket) =
  ## Close the Socket, sends close packet.
  ws.readyState = Closed
  proc close() {.async.} =
    await ws.send("", Close)
    ws.tcpSocket.close()
  asyncCheck close()
