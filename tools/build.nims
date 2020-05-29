#!/usr/bin/env nim
selfExec "compileToC --compileOnly -f -d:release -d:danger -d:ssl --threads:on --app:lib --opt:speed -d:noSignalHandler --listFullPaths:off --excessiveStackTrace:off --tlsEmulation:off --exceptions:goto --gc:markAndSweep --nimcache:. --out:faster_than_requests.so src/faster_than_requests.nim"
cpFile getEnv"HOME" & "/.choosenim/toolchains/nim-" & NimVersion & "/lib/nimbase.h", "nimbase.h"
rmFile "faster_than_requests.json"
