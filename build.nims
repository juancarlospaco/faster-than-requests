#!/usr/bin/env nim
import os

rmDir("dist")
mkDir("dist")

const version = "1.0"
const packageName = "faster_than_requests"
const gccWin32 = system.findExe("x86_64-w64-mingw32-gcc")
assert gccWin32.len > 0, "x86_64-w64-mingw32-gcc not found"
const zipExe = system.findExe("zip")
assert zipExe.len > 0, "zip command not found"
const nimbaseH = getHomeDir() / ".choosenim/toolchains/nim-" & NimVersion / "lib/nimbase.h"
const rootFolder = system.getCurrentDir()

--app:lib
--opt:speed
--cpu:amd64
--forceBuild
--threads:on
--compileOnly
--define:danger
--define:release
--define:ssl
--exceptions:goto
--gc:markAndSweep
--tlsEmulation:off
--define:noSignalHandler
--excessiveStackTrace:off
--define:nimDisableCertificateValidation
--outdir:getTempDir() # Save the *.so to /tmp, so is not on the package

# writeFile("upload2pypi.sh", "twine upload --verbose --repository-url 'https://test.pypi.org/legacy/' --comment 'Powered by https://Nim-lang.org' dist/*.zip\n")
# writeFile("package4pypi.sh", "cd dist && zip -9 -T -v -r " & packageName & ".zip *\n")
# writeFile("install2local4testing.sh", "sudo pip --verbose install dist/*.zip --no-binary :all:\nsudo pip uninstall " & packageName)

cpFile(rootFolder / "setup.cfg", "dist/setup.cfg")
cpFile(rootFolder / "setup.py", "dist/setup.py")

withDir("dist"):

  selfExec "c -d:release --os:windows --out:faster_than_requests.pyd --gcc.exe:" & gccWin32 & " --gcc.linkerexe:" & gccWin32 & " " & rootFolder / "src/faster_than_requests.nim"

  selfExec "c -d:release --out:faster_than_requests.so " & rootFolder / "src/faster_than_requests.nim"

  mkDir("lin") # C for Linux, compile for Linux, save C files to lin/*.c
  mkDir("win") # C for Windows, compile for Windows, save C files to win/*.c
  mkDir("mac") # C for Mac OSX, manual compile, manual copy C files to mac/*.c
  mkDir(packageName & ".egg-info")
  cpFile(rootFolder / "PKG-INFO", packageName & ".egg-info/PKG-INFO")

  withDir(packageName & ".egg-info"): # Old and weird metadata format of Python packages
    writeFile("top_level.txt", "")  # Serializes data as empty files(?), because reasons
    writeFile("dependency_links.txt", "")
    writeFile("requires.txt", "")
    writeFile("zip-safe", "")

  withDir("lin"):
    selfExec "compileToC --nimcache:. " & rootFolder / "src/faster_than_requests.nim"
    rmFile(packageName & ".json")
    cpFile(nimbaseH, "nimbase.h")

  withDir("win"):
    selfExec "compileToC --nimcache:. --os:windows --gcc.exe:" & gccWin32 & " --gcc.linkerexe:" & gccWin32 & " " & rootFolder / "src/faster_than_requests.nim"
    rmFile(packageName & ".json")
    cpFile(nimbaseH, "nimbase.h")

  withDir("mac"):
    cpFile(nimbaseH, "nimbase.h")

  exec "zip -9 -T -v -r " & packageName & "-" & version & ".zip *"
  echo "Apple Mac OSX: Compile manually and copy all the .c files to 'mac/' folder, see https://github.com/foxlet/macOS-Simple-KVM"

selfExec "c -d:release --os:windows --out:faster_than_requests.pyd --gcc.exe:" & gccWin32 & " --gcc.linkerexe:" & gccWin32 & " " & rootFolder / "src/faster_than_requests.nim"
