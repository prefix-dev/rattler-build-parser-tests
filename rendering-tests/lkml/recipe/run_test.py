import sys
from subprocess import call

FAIL_UNDER = "89"
COV = ["coverage"]
RUN = ["run", "--source=lkml", "--branch", "-m"]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long"]
REPORT = ["report", "--show-missing", "--skip-covered", f"--fail-under={FAIL_UNDER}"]

SKIPS = [
    "absence_of_debug_flag_is_parsed_to_log_level_warn",
    "block_with_multiple_quoted_fields",
    "block_with_nested_block",
    "block_with_single_quoted_field",
    "debug_flag_is_parsed_to_log_level_debug",
    "duplicate_non_top_level_keys",
    "duplicate_top_level_keys",
    "lists_with_comma_configurations",
    "model_with_all_fields",
    "reserved_dimension_names",
    "view_with_all_fields",
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
