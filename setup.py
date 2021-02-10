import setuptools, nimporter

setuptools.setup(
  name                 = "faster_than_requests",
  version              = "0.0.1",
  include_package_data = True,
  install_requires     = ["nimporter"],
  ext_modules          = nimporter.build_nim_extensions(danger = True),
)
