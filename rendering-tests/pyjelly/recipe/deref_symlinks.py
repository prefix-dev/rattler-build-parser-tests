from __future__ import annotations
import os
import shutil
import sys
from pathlib import Path
from pprint import pformat

SRC_DIR = Path(os.environ["SRC_DIR"])
SRC = SRC_DIR / "src"
DIST = SRC_DIR / "dist"

KNOWN_SYMLINKS = {
    SRC / "tests/conformance_tests/grpc": DIST / "submodules/protobuf/test/grpc",
    SRC / "tests/conformance_tests/rdf": DIST / "submodules/protobuf/test/rdf",
}


def main() -> int:
    for link, real in KNOWN_SYMLINKS.items():
        sys.stderr.write(f"""
        dereferencing {real}
                 with {link}
        """)
        link.unlink()
        shutil.copytree(real, link)
    symlinks = [p for p in sorted(SRC.glob("tests/**")) if p.is_symlink()]
    sys.stderr.write(f"""
        {len(symlinks)} symlinks remaining:
        {pformat(symlinks)}
    """)
    return len(symlinks)


if __name__ == "__main__":
    sys.exit(main())
