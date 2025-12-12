import sys
from subprocess import call

FAIL_UNDER = "89"
COV = ["coverage"]
RUN = ["run", "--source=ariadne_codegen", "--branch", "-m"]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long", "src/tests"]
REPORT = ["report", "--show-missing", "--skip-covered", f"--fail-under={FAIL_UNDER}"]

SKIPS = [
    # doesn't handle windows slashes
    "not_invalid_file",
    # https://github.com/conda-forge/ariadne-codegen-feedstock/pull/4
    "main_generates_correct_schema_file",
]

SKIP_OR = " or ".join(SKIPS)
K = ["-k", f"not ({SKIP_OR})"]


if __name__ == "__main__":
    sys.exit(
        # run the tests
        call([*COV, *RUN, *PYTEST, *K])
        # maybe run coverage
        or call([*COV, *REPORT])
    )
