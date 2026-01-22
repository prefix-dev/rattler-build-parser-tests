import sys
import pytest
import shutil
from subprocess import check_output, call
from pathlib import Path
import os

PKG_VERSION = os.environ["PKG_VERSION"]


@pytest.fixture
def yarn() -> str:
    exe = shutil.which("yarn") or shutil.which("yarn.cmd")
    assert exe is not None, "couldn't find yarn at all"
    assert exe.startswith(sys.prefix), "this is not the yarn you are looking for"
    return exe


def test_version(yarn: str) -> None:
    observed = check_output([yarn, "--version"], encoding="utf-8").strip()
    assert observed.startswith(PKG_VERSION)


def test_help(yarn: str) -> None:
    assert call([yarn, "--help"]) == 0


def test_basic_workflow(yarn: str, tmp_path: Path):
    commands = [
        [yarn, "init"],
        [yarn, "add", "lodash"],
        [yarn, "install", "--immutable", "--immutable-cache"],
    ]

    for cmd in commands:
        print("\n", ">>>", *cmd, "\n", flush=True)
        assert call(cmd, cwd=str(tmp_path)) == 0

    assert (tmp_path / "yarn.lock").exists()


if __name__ == "__main__":
    sys.exit(pytest.main(["-svv", "--tb=long", "--color=yes", __file__]))
