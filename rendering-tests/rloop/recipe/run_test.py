import sys
from subprocess import call

FAIL_UNDER = "33"
COV = ["coverage"]
RUN = ["run", "--source=rloop", "--branch", "-m"]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long"]
REPORT = ["report", "--show-missing", "--skip-covered", f"--fail-under={FAIL_UNDER}"]

SKIPS = [
    # times out
    # https://github.com/conda-forge/rloop-feedstock/pull/1
    "test_tcp_connection_send",
    "test_tcp_server_recv_send",
]

if SKIPS:
    SKIP_OR = " or ".join(SKIPS)
    PYTEST += ["-k", f"not ({SKIP_OR})"]


if __name__ == "__main__":
    sys.exit(
        # run the tests
        call([*COV, *RUN, *PYTEST])
        # maybe run coverage
        or call([*COV, *REPORT])
    )
