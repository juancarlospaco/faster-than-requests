import os, sys, subprocess, setuptools, platform

assert platform.architecture()[0] == "64bit", "ERROR: Python must be 64 Bit!. OS must be 64 Bit!."
assert sys.version_info > (3, 6, 0), "ERROR: Python version must be > 3.5!."

class CustomInstall(install):
  def run(self):
    install.run(self)
    subprocess.call("nimble --accept --noSSLCheck install https://github.com/juancarlospaco/faster-than-requests.git")

setup(cmdclass={"install": CustomInstall})
