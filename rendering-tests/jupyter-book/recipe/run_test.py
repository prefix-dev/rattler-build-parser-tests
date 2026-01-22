import subprocess
import sys
import os

from importlib.metadata import version


def do(args: list[str], expect_stdout: str = "") -> int:
    print(">>>", *args, flush=True)
    proc = subprocess.Popen(
        args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding="utf-8"
    )
    stdout, stderr = proc.communicate()
    print("STDOUT")
    print(stdout)
    print("STDERR")
    print(stderr)
    if expect_stdout and expect_stdout not in stdout:
        print("!!! missing", expect_stdout)
        return 2
    return proc.returncode


def check_versions() -> int:
    out = subprocess.check_output(["jupyter-book", "--version"], encoding="utf-8")
    versions = {
        out.strip().replace("v", ""),
        version("jupyter-book"),
        os.environ["PKG_VERSION"],
    }
    print(versions)
    assert len(versions) == 1, f"expected one version, got: {versions}"
    return 0


if __name__ == "__main__":
    sys.exit(
        do(["jupyter-book", "--version"])
        or do(["jupyter-book", "--help"])
        or check_versions()
    )
