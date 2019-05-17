#!/bin/bash
rm --verbose --force dist/*.zip
python3 setup.py --verbose sdist --formats=zip
rm --verbose --force --recursive faster_than_requests.egg-info/
rm --verbose --force *.c
rm --verbose --force nimbase.h
