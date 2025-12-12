@echo on

cd packages/parser
if errorlevel 1 exit 1

call yarn install
if errorlevel 1 exit 1

call pnpm install --prod
if errorlevel 1 exit 1

call pnpm licenses list --json | pnpm-licenses generate-disclaimer --json-input --output-file=ThirdPartyLicenses.txt
if errorlevel 1 exit 1

call pnpm pack
if errorlevel 1 exit 1

call npm config set prefix %BUILD_PREFIX%
if errorlevel 1 exit 1

call npm install --userconfig nonexistentrc --global %PKG_NAME%-%PKG_VERSION%.tgz
if errorlevel 1 exit 1

