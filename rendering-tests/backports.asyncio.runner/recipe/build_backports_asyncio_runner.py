import sys
import subprocess

if __name__ == "__main__":
    if sys.version_info > (3, 11):
        print("Noop on", sys.version)
        sys.exit(0)
    subprocess.call(
        [
            sys.executable,
            "-m",
            "pip",
            "install",
            ".",
            "-vv",
            "--no-deps",
            "--no-build-isolation",
            "--disable-pip-version-check",
        ]
    )
