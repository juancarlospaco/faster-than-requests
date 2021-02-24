# Allow tests/ directory to see faster_than_requests/ package on PYTHONPATH
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent.parent))
