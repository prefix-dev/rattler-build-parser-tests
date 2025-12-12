import sys
import shutil
from pathlib import Path
from importlib.metadata import version

from subprocess import call

NPM = shutil.which("npm") or shutil.which("npm.exe")

if not NPM:
    raise RuntimeError("npm not on path")

HERE = Path(__file__)

FAIL_UNDER = 98
COV = ["coverage"]
RUN = ["run", "--source=lunr", "--branch", "-m"]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long"]
REPORT = ["report", "--show-missing", "--skip-covered", f"--fail-under={FAIL_UNDER}"]

SKIPS: list[str] = []

if SKIPS:
    SKIP_OR = " or ".join(SKIPS)
    PYTEST += ["-k", f"not {SKIPS[0]}" if len(SKIPS) == 1 else f"not ({SKIP_OR})"]


def test_version_metadata() -> None:
    """Check the versions."""
    from_meta = version("lunr")
    from_py = __import__("lunr").__VERSION__
    assert from_meta == from_py, "versions in metadata and runtime do not match"


if __name__ == "__main__":
    sys.exit(
        # install node stuff
        call([NPM, "install"], cwd="tests/acceptance_tests/javascript")
        # run the tests
        or call([*COV, *RUN, *PYTEST, __file__, "tests"])
        # maybe run coverage
        or call([*COV, *REPORT])
    )
