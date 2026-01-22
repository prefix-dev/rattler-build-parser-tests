import sys
from subprocess import call

FAIL_UNDER = 79
SKIPS = [
    # 0.28.0 non-basic locales used in tests not available in CI docker image
    "get_locale",
    "backend_locale",
    "backend_locale_extension",
    "get_installed_language_pack_locales_passes",
    "get_installed_package_locales",
    "get_installed_packages_locale",
    "get_language_packs",
    "get_language_pack",
]

TEST = [
    "coverage",
    "run",
    "--source=jupyterlab_server",
    "--branch",
    "-m",
    "pytest",
    "-vv",
    "--tb=long",
    "--color=yes",
    "-k",
    f"""not ({" or ".join(SKIPS)})""",
]
REPORT = [
    "coverage",
    "report",
    "--show-missing",
    "--skip-covered",
    f"--fail-under={FAIL_UNDER}",
]


def do(args: list[str]) -> int:
    print(">>>", *args, flush=True)
    return call(args, cwd="tests")


if __name__ == "__main__":
    sys.exit(do(TEST) or do(REPORT))
