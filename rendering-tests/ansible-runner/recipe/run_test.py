import sys
from subprocess import call

FAIL_UNDER = "70"
COV = ["coverage"]
RUN = ["run", "--source=ansible_runner", "--branch", "-m"]
PYTEST = ["pytest", "-vv", "--color=yes", "--tb=long"]
REPORT = ["report", "--show-missing", "--skip-covered", f"--fail-under={FAIL_UNDER}"]

SKIPS = [
    "containerization",
    "env_vars",
    "prepare_env_sshkey",
    "container_volmount",
    "registry_auth_cleanup",
    "prepare_env_directory_isolation_from_settings",
    "multiline_blank_write",
    # https://github.com/conda-forge/ansible-runner-feedstock/pull/28
    "test_playbook_on_stats_summary_fields",
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
