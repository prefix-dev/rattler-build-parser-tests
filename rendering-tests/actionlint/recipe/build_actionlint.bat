@echo on

set GOPATH=%SRC_DIR%

cd "src\github.com\rhysd\actionlint" ^
    || exit 2

dir

go build ^
    -ldflags "-s -w -X github.com/rhysd/actionlint.version=%PKG_VERSION%" ^
    -o "%PREFIX%\bin\%PKG_NAME%.exe" ^
    ".\cmd\%PKG_NAME%" ^
    || exit 3

go-licenses save ".\cmd\%PKG_NAME%" ^
    --save_path "%SRC_DIR%/license-files" ^
    --ignore=bufio ^
    --ignore=bytes ^
    --ignore=cmp ^
    --ignore=container/list ^
    --ignore=context ^
    --ignore=encoding ^
    --ignore=encoding/base64 ^
    --ignore=errors ^
    --ignore=flag ^
    --ignore=fmt ^
    --ignore=internal/abi ^
    --ignore=internal/asan ^
    --ignore=internal/bisect ^
    --ignore=internal/bytealg ^
    --ignore=internal/byteorder ^
    --ignore=internal/chacha8rand ^
    --ignore=internal/concurrent ^
    --ignore=internal/coverage/rtcov ^
    --ignore=internal/cpu ^
    --ignore=internal/filepathlite ^
    --ignore=internal/fmtsort ^
    --ignore=internal/goarch ^
    --ignore=internal/godebug ^
    --ignore=internal/goexperiment ^
    --ignore=internal/goos ^
    --ignore=internal/intern ^
    --ignore=internal/itoa ^
    --ignore=internal/msan ^
    --ignore=internal/nettrace ^
    --ignore=internal/oserror ^
    --ignore=internal/poll ^
    --ignore=internal/profilerecord ^
    --ignore=internal/race ^
    --ignore=internal/reflectlite ^
    --ignore=internal/runtime/atomic ^
    --ignore=internal/runtime/exithook ^
    --ignore=internal/runtime/maps ^
    --ignore=internal/runtime/math ^
    --ignore=internal/runtime/sys ^
    --ignore=internal/safefilepath ^
    --ignore=internal/singleflight ^
    --ignore=internal/stringslite ^
    --ignore=internal/sync ^
    --ignore=internal/syscall/execenv ^
    --ignore=internal/syscall/windows ^
    --ignore=internal/syscall/windows/registry ^
    --ignore=internal/syscall/windows/sysdll ^
    --ignore=internal/testlog ^
    --ignore=internal/unsafeheader ^
    --ignore=internal/weak  ^
    --ignore=io ^
    --ignore=io/fs ^
    --ignore=io/ioutil ^
    --ignore=iter ^
    --ignore=log ^
    --ignore=maps ^
    --ignore=math ^
    --ignore=math/bits ^
    --ignore=net ^
    --ignore=net/url ^
    --ignore=os ^
    --ignore=os/exec ^
    --ignore=path ^
    --ignore=path/filepath ^
    --ignore=reflect ^
    --ignore=regexp ^
    --ignore=runtime ^
    --ignore=runtime/debug ^
    --ignore=slices ^
    --ignore=sort ^
    --ignore=strconv ^
    --ignore=strings ^
    --ignore=sync ^
    --ignore=sync/atomic ^
    --ignore=syscall ^
    --ignore=text/scanner ^
    --ignore=text/template ^
    --ignore=time ^
    --ignore=unicode ^
    --ignore=unicode/utf8 ^
    --ignore=unique ^
    --ignore=vendor/golang.org/x/net/dns/dnsmessage ^
    --ignore=weak ^
    || exit 4
