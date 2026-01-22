%PYTHON% setup.py build_ext --generator=Ninja --symengine-dir=%LIBRARY_PREFIX% bdist_wheel -vv

for %%f in (dist\*.whl) do (
  %PYTHON% -m pip install %%f -vv
)
