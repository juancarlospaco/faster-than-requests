import os, sys, pathlib, setuptools, sysconfig, platform
from setuptools.command.build_ext import build_ext

assert platform.architecture()[0] == "64bit", "ERROR: Python must be 64 Bit!. OS must be 64 Bit!."

if sys.platform.startswith("lin"):
  folder = "lin" # OS is Linux
elif sys.platform.startswith("win"):
  folder = "win" # OS is Windows
else:
  folder = "mac" # OS is Mac

sources = []
for c_source_file in os.listdir(folder): # Walk the folder with C files.
  if c_source_file.endswith(".c"):       # Collect all C files.
    sources.append(str(pathlib.Path(folder) / c_source_file))

class NoSuffixBuilder(build_ext):
  def get_ext_filename(self, ext_name): # NO Suffix
    filename = super().get_ext_filename(ext_name)
    return filename.replace(sysconfig.get_config_var('EXT_SUFFIX'), "") + pathlib.Path(filename).suffix

setuptools.setup(
  cmdclass = {"build_ext": NoSuffixBuilder},
  ext_modules = [
    setuptools.Extension(
      name = "faster_than_requests",
      sources = sources,
      include_dirs = [folder],
      extra_link_args = ["-s"],
      extra_compile_args = ["-flto", "-ffast-math", "-march=native", "-mtune=native", "-O3", "-fsingle-precision-constant"],
    )
  ]
)
