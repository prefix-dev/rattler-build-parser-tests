import sys
import os
from pathlib import Path

SP_DIR = Path(os.environ["SP_DIR"])
REMOVE_FROM_SP_DIR = [
    "CHANGELOG.md",
    "CONTRIBUTING.md",
    "CONTRIBUTORS.md",
    "FEATURES.md",
    "LICENSE.txt",
    "README.md",
]


def main() -> int:
    print("cleaning site-packages...", flush=True)
    for name in REMOVE_FROM_SP_DIR:
        path = SP_DIR / name
        if path.exists():
            print(f"... removing {name} from {path}", flush=True)
            path.unlink()
    return 0


if __name__ == "__main__":
    sys.exit(main())
