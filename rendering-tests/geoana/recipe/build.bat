@echo on

%PYTHON% -m build --wheel --no-isolation --skip-dependency-check -Csetup-args="-Dwith_extensions=true" -Csetup-args="--vsenv"

FOR %%i in (dist\geoana*.whl) DO %PYTHON% -m pip install %%i