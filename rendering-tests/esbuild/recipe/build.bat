make esbuild 
IF NOT EXIST "%LIBRARY_BIN%" MKDIR "%LIBRARY_BIN%"
COPY esbuild.exe "%LIBRARY_BIN%\esbuild.exe"
