version     = "9.9.9"
author      = "Nim"
description = "Python compiled native module"
license     = "MIT"
const name = "faster_than_requests"  # Module name and file name (Must be the same).




requires "nim >= 1.4.2"
requires "nimpy"

import os, strutils

task setup, "Generating Optimized Native Module":
  const file =  name & (when defined(windows): ".pyd" else: ".so")
  const py3 = findExe"python3"
  const pyX = findExe"python"
  const py2 = findExe"python2"
  var pyexe = py3
  if pyexe.len == 0:
    pyexe = pyX
  elif pyexe.len == 0:
    pyexe = py2
    echo "WARNING: Can not find Python3 executable, using legacy Python2 as fallback."
  else:
    echo "ERROR: Can not find Python executable."
  var path = gorge(pyexe & " -m site --user-site").strip
  if path.len == 0:
    path = "."

  try:
    selfExec("compile -d:ssl -d:lto -d:strip -d:danger -d:noSignalHandler -d:nimBinaryStdFiles -d:nimDisableCertificateValidation --app:lib --gc:arc --threads:on --forceBuild --panics:on --listFullPaths:off --excessiveStackTrace:off --exceptions:goto --passL:'-ffast-math -fsingle-precision-constant -march=native' --out:'$1' '$2'".format(
      path / file, "src" / name & ".nim"
    ))
    echo path / file
  except:
    echo "Failed to install library at:\t" & path

  when defined(windows):
    echo "Please reboot the computer before using the module."


before install:
  setupTask()
