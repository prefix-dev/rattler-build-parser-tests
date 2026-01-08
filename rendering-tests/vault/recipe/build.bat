go build -buildmode=pie -trimpath -modcacherw -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" || goto :error
go-licenses save . --save_path=license-files ^
    --ignore github.com/hashicorp/vault ^
    --ignore github.com/aliyun/aliyun-oss-go-sdk ^
    --ignore github.com/couchbase/goprotostellar ^
    --ignore github.com/hashicorp/vic/pkg ^
    --ignore github.com/apache/thrift/lib || goto :error
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
