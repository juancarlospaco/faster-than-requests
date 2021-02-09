import setuptools, nimporter

setuptools.setup(
  install_requires = ["nimporter"],
  ext_modules      = nimporter.build_nim_extensions(danger = True),
)
