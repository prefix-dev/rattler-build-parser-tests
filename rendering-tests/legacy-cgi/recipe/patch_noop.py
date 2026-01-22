"""Patch the build system to ship a no-op package."""

import sys
from pathlib import Path
import tomli
import tomli_w

PPT = Path("pyproject.toml")
UTF8 = {"encoding": "utf-8"}
LEGACY_BUILD_SYSTEM = {
    "requires": ["setuptools"],
    "build-backend": "setuptools.build_meta",
}
UNLINK = ["cgitb.py", "cgi.py"]


def main() -> int:
    print("... removing implementations")
    for unlink in UNLINK:
        print("   ...", unlink)
        Path(unlink).unlink()
    print("... patching pyproject.toml", flush=True)
    old_toml = tomli.loads(PPT.read_text(**UTF8))
    old_toml["build-system"] = LEGACY_BUILD_SYSTEM
    old_toml["project"]["license"] = {"text": old_toml["project"]["license"]}
    PPT.write_text(tomli_w.dumps(old_toml), **UTF8)
    return 0


if __name__ == "__main__":
    sys.exit(main())
