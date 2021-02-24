version     = "9.9.9"
author      = "Juan Carlos"
description = ""
license     = "MIT"

requires "nim >= 1.4.4"
requires "nimpy"

import os, strutils

task setup, "Generating Optimized Native Module":
  const file = when defined(windows): "faster_than_requests.pyd" else: "faster_than_requests.so"
  const path = gorge("python3 -m site --user-site").strip

  try:
    selfExec(
      "compile -d:ssl -d:lto -d:strip -d:danger -d:noSignalHandler -d:nimBinaryStdFiles -d:nimDisableCertificateValidation " &
      "--app:lib --gc:arc --threads:on --listFullPaths:off --excessiveStackTrace:off --exceptions:goto --passL:'-ffast-math -fsingle-precision-constant -march=native'"
      "--out:" & path / file &  " src/faster_than_requests.nim"
    )
  except:
    echo "Failed to install library at: " & path

  when defined(windows):
    echo "Please reboot the computer before using the module."


before install:
  setupTask()
