# Add . to path so that the DLLs can be imported on Windows
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))

import nimporter

from . faster_than_requests import *
