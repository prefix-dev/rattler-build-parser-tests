robocopy . %PREFIX%/Library/bin/ vswhere.exe
if %ERRORLEVEL% GEQ 8 exit 1