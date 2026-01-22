from __future__ import annotations
import sys
import os
import re
from subprocess import Popen, PIPE, STDOUT, call

PKG_NAME = os.environ["PKG_NAME"]

TEST_SKIPS = ["serverextension", "start_known", "listeners", "substitute_env"]

CHECKS: list[tuple[str, list[str]]] = [
    ("No broken requirements found", [sys.executable, "-m", "pip", "check"]),
]

if PKG_NAME != "jupyter-lsp-r":
    TEST_SKIPS += ["r_package_detection"]

if PKG_NAME == "jupyterlab-lsp":
    CHECKS += [
        (r"jupyterlab-lsp.*enabled.*OK", ["jupyter", "labextension", "list", "--debug"])
    ]

if PKG_NAME in ["jupyterlab-lsp", "jupyter-lsp"]:
    CHECKS += [
        (r"jupyter_lsp.*OK", ["jupyter", "server", "extension", "list", "--debug"])
    ]

RUN_PYTEST = PKG_NAME in [
    "jupyter-lsp-latex",
    "jupyter-lsp-python",
    "jupyter-lsp-python-plugins",
    "jupyter-lsp-r",
]
PYTEST = [
    "pytest",
    "-vv",
    "--tb=long",
    "--color=yes",
    "-p",
    "no:warnings",
    "--pyargs",
    "jupyter_lsp",
]


def main() -> int:
    for pattern, cmd in CHECKS:
        print(f"[{PKG_NAME}] >>>", *cmd)
        proc = Popen(cmd, stdout=PIPE, stderr=STDOUT, encoding="utf-8")
        stdout = proc.communicate()[0]
        print(stdout)
        matches = re.findall(pattern, stdout)
        print(f"[{PKG_NAME}] matches", matches)

        if not matches:
            print(f"[{PKG_NAME}] !!! not found", pattern)
            return 1

    if not RUN_PYTEST:
        return 0
    pytest_args = [*PYTEST, "-k", f"""not ({" or ".join(TEST_SKIPS)})"""]
    print(f"[{PKG_NAME}] >>>", *pytest_args)
    return call(pytest_args)


if __name__ == "__main__":
    sys.exit(main())
