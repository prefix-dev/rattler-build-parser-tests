import sys
import subprocess
import inspect
import shlex
import importlib

python_min = sys.argv[1].strip()
cmd = [
    sys.executable,
    "-m",
    "abi3audit",
    "--summary",
    "--verbose",
    "--assume-minimum-abi3",
    python_min,
    inspect.getfile(importlib.import_module("adrt._adrt_cdefs")),
]
print(shlex.join(cmd))
subprocess.run(cmd, check=True)
