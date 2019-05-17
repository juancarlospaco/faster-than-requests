#!/bin/bash
nim compileToC -d:release -d:ssl --opt:speed --gc:markAndSweep --noMain --compileOnly --nimcache:. src/faster_than_requests.nim
cp --verbose --force ~/.choosenim/toolchains/nim-0.19.6/lib/nimbase.h nimbase.h
rm --verbose --force faster_than_requests.json
