import os
import subprocess
import sys
from os.path import join, dirname

import openmdao

# don't test the code_review stuff
TESTFLO = """[testflo]
skip_dirs =
  code_review
"""


def main() -> int:
    with open(".testflo", "w") as fp:
        fp.write(TESTFLO)

    test_files_to_delete = [
        # can't test these, yet, because of playwright
        ["visualization", "n2_viewer", "tests", "test_gui.py"],
        ["docs", "openmdao_book", "tests", "test_jupyter_gui_test.py"],
        # needs full cuda
        ["jax", "tests", "test_jax.py"],
        ["utils", "tests", "test_jax_utils.py"],
        ["components", "tests", "test_explicit_func_comp.py"],
        ["components", "tests", "test_implicit_func_comp.py"],
        ["core", "tests", "test_partial_color.py"],
    ]

    for tf2d in test_files_to_delete:
        os.unlink(join(dirname(openmdao.__file__), *tf2d))

    return subprocess.call(
        [
            "testflo",
            "--config",
            ".testflo",
            "--stop",
            "-v",
            "--pre_announce",
            "--numprocs",
            os.environ["CPU_COUNT"],
            "openmdao",
            "--exclude",
            "*test_simple_paraboloid_desvar_indices_COBYQA*",
        ]
    )


if __name__ == "__main__":
    sys.exit(main())
