@echo on
md %LIBRARY_PREFIX%\share\vega-lite-cli
pushd %LIBRARY_PREFIX%\share\vega-lite-cli

md node_modules
cmd /c "npm install vega-lite@%PKG_VERSION%"
if errorlevel 1 exit 1

cmd /c "npm install --save vega@5.22.0"
if errorlevel 1 exit 1

pushd %LIBRARY_PREFIX%\bin
for %%c in (vl2pdf vl2png vl2svg vl2vg) do (
  echo @echo on >> %%c.bat
  echo node %LIBRARY_PREFIX%\share\vega-lite-cli\node_modules\vega-lite\bin\%%c "%%*" >> %%c.bat
)

copy %LIBRARY_PREFIX%\share\vega-lite-cli\node_modules\vega-lite\LICENSE %SRC_DIR%
if errorlevel 1 exit 1
