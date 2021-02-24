import setuptools

setuptools.setup(
  packages     = ["faster_than_requests"],
  package_data = {"": ["*.nim", "*.nims", "*.cfg", "*.dll", "*.so"]},
)
