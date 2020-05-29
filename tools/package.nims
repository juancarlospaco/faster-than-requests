#!/usr/bin/env nim
rmFile "dist/*.zip"
exec "python3 setup.py --verbose sdist --formats=zip"
rmdir "faster_than_requests.egg-info/"
rmFile "*.c"
rmFile "nimbase.h"
