@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" cli/main.go || goto :error
go-licenses save ./cli --save_path=license-files --ignore github.com/inconshreveable/go-update || goto :error

:: Manually copy licenses that go-licenses could not download
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
