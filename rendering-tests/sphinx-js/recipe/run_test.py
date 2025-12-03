from os.path import join, dirname
from subprocess import check_call
import json
import re
import shutil
import tempfile


NPM = shutil.which("npm")
HERE = dirname(__file__)
TESTS = join(HERE, "tests")

# TODO: hoist these to the recipe
PKG = {
    "devDependencies": {
        "jsdoc": "4.*",
        "typedoc": "0.28.*",
    },
    "scripts": {"test": "python -m pytest -vv --tb=long --color=yes"},
}


def test_in_tmp(tmp):
    print("- creating package.json to ensure js/tsdoc are installed/on path...")
    with open(join(tmp, "package.json"), "w+") as fp:
        json.dump(PKG, fp)

    print("- installing npm packages...")
    check_call([NPM, "install"], cwd=tmp)

    print("- copying tests...")
    shutil.copytree(TESTS, join(tmp, "tests"))

    print("- running pytest inside npm...")
    check_call([NPM, "run", "test"], cwd=tmp)


if __name__ == "__main__":
    print("- creating tmp directory...")
    TMP = tempfile.mkdtemp()

    try:
        print("- ensuring no parent paths of tests start with _")
        assert not re.findall("[\\/]_", TMP), (
            "!!! path probably contains a child with an underscore: {}".format(TMP)
        )
        test_in_tmp(TMP)
        print("SUCCESS")
    finally:
        print("cleaning tmp directory")
        shutil.rmtree(TMP)
