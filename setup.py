import sys, platform, setuptools, nimporter

assert platform.architecture()[0] == "64bit", "ERROR: Python must be 64 Bit!. OS must be 64 Bit!."
assert sys.version_info > (3, 6, 0), "ERROR: Python version must be > 3.5!."
# atexit.register(lambda: print(importlib.metadata.distribution(package_name).files))

setuptools.setup(
  package_data         = {"": ["*.nim"]},
  include_package_data = True,
  install_requires     = ["nimporter"],
  ext_modules          = nimporter.build_nim_extensions(danger = True),
)
