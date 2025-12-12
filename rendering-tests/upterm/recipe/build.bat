@echo on

cd %SRC_DIR%

set "LDFLAGS=-s -w -X github.com/owenthereal/upterm/internal/version.Version=%PKG_VERSION%"

go build -ldflags "%LDFLAGS%" -o %LIBRARY_PREFIX%\bin\upterm.exe .\cmd\upterm || exit 1
go build -ldflags "%LDFLAGS%" -o %LIBRARY_PREFIX%\bin\uptermd.exe .\cmd\uptermd || exit 1

go-licenses save .\cmd\upterm .\cmd\uptermd --save_path=%SRC_DIR%\license-files || exit 0
