git_repo = "https://github.com/juancarlospaco/faster-than-requests.git"




import sys, subprocess, setuptools, platform
from setuptools.command.install import install
assert platform.architecture()[0] == "64bit", "ERROR: Python must be 64 Bit!. OS must be 64 Bit!."
assert sys.version_info > (3, 5, 0), "ERROR: Python version must be > 3.5!."
class X(install):
  def run(self):
    install.run(self)
    subprocess.run(f"nimble --accept install '{git_repo}@#master'", shell=1, check=1, timeout=999)

setuptools.setup(cmdclass = {"install": X})
