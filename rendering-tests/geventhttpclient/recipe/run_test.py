from subprocess import call
import os
from typing import Any

FAIL_UNDER = 72
SKIPS = ["brotli_response", "online"]

WIN = os.name == "nt"
COV = ["coverage"]
RUN = ["run", "--source=geventhttpclient", "--branch"]
REPORT = ["report", "--show-missing", "--skip-covered", "--fail-under", FAIL_UNDER]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long"]
PYTEST += ["-k", f"not ({' or '.join(SKIPS)})"]


def do(*args: Any) -> int:
    str_args = list(map(str, args))
    print(">>>", *str_args, flush=True)
    if WIN:
        print("... skipping on windows")
        return 0
    return call(str_args, cwd="src")


if __name__ == "__main__":
    exit(max([do(*COV, *RUN, "-m", *PYTEST), do(*COV, *REPORT)]))
