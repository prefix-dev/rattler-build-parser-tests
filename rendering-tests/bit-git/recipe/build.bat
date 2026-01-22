@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_BIN%\%PKG_NAME%.exe -ldflags="-s -X main.version=v%PKG_VERSION%" || goto :error
go-licenses save . --save_path=license-files --ignore github.com/tj/go-update --ignore github.com/inconshreveable/mousetrap || goto :error

:: Manually copy licenses that go-licenses could not download
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
