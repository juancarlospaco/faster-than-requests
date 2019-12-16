#!/usr/bin/env nim
selfExec "compileToC --compileOnly -d:release -d:ssl --app:lib --opt:speed --gc:markAndSweep --nimcache:. --out:faster_than_requests.so src/faster_than_requests.nim"
cpFile getEnv"HOME" & "/.choosenim/toolchains/nim-" & NimVersion & "/lib/nimbase.h", "nimbase.h"
rmFile "faster_than_requests.json"
