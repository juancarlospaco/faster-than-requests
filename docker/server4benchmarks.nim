import asynchttpserver, asyncdispatch

proc callback(req: Request) {.async.} =
  await req.respond(Http200, """{"foo": "bar", "baz": true}""")

echo " STARTING BENCHMARK TESTING SERVER "
waitFor newAsyncHttpServer().serve(Port(5000), callback)
