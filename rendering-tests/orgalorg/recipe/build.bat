@echo on
@setlocal EnableDelayedExpansion

go build -mod=mod -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -w -X main.version=%PKG_VERSION%" || goto :error
go-licenses save . --save_path=license-files ^
	--ignore github.com/kovetskiy/lorg ^
	--ignore github.com/reconquest/nopio-go ^
	--ignore github.com/reconquest/prefixwriter-go ^
	--ignore github.com/reconquest/runcmd ^
	--ignore github.com/zazab/zhash || goto :error

:: Manually copy licenses that go-licenses could not download
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
