@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_BIN%\%PKG_NAME%.exe -ldflags="-s -w -X github.com/cube2222/octosql/cmd.VERSION=%PKG_VERSION%" || goto :error
go-licenses save . --save_path=license-files --ignore github.com/cube2222/octosql --ignore github.com/xi2/xz --ignore github.com/inconshreveable/mousetrap || goto :error

:: Manually copy licenses that go-licenses could not download
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
