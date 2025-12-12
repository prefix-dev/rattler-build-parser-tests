@echo on

set "GOPATH=%SRC_DIR%"
set CGO_ENABLED=0

cd "src\github.com\ipfs\kubo" ^
    || exit 2

go build ^
    -o "%PREFIX%\Library\bin\ipfs.exe" ^
    .\cmd\ipfs ^
    || exit 3

go-licenses save ./cmd/ipfs ^
    --save_path "%SRC_DIR%\library_licenses" ^
    || exit 4
