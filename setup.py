#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
from glob import glob
from os.path import dirname
from os.path import join
from os.path import relpath
from os.path import splitext
from setuptools import Extension
from setuptools import setup

setup(
  ext_modules = [
      Extension(
          splitext(relpath(path, 'src').replace(os.sep, '.'))[0],
          sources=[path],
          include_dirs=[dirname(path)]
      )
        for root, _, _ in os.walk('src')
        for path in glob(join(root, '*.c'))
  ],
)
