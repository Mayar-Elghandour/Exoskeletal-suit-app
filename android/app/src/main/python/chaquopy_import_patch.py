# chaquopy_import_patch.py
import sys
import os

lib_path = os.path.join(sys.exec_prefix, "Lib")
if lib_path not in sys.path:
    sys.path.append(lib_path)

# Optional: test import to force detection
try:
    import xml.etree.ElementTree as ET
except ImportError as e:
    print("ETREE ERROR:", e)
