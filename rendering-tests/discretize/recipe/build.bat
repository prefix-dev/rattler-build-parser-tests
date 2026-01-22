@echo on
%PYTHON% -m build --wheel --no-isolation --skip-dependency-check -Csetup-args="--vsenv"

FOR %%i in (dist\discretize*.whl) DO %PYTHON% -m pip install %%i