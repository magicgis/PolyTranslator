@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ============================================
echo   poly-translator Publisher
echo ============================================
echo.

set "CARGO_TOML=%~dp0Cargo.toml"

set "CURRENT_VERSION="
for /f "usebackq tokens=1,* delims==" %%a in ("%CARGO_TOML%") do (
    echo %%a | findstr /i "version" >nul
    if !errorlevel! equ 0 (
        if not defined CURRENT_VERSION (
            set "line=%%b"
            set "line=!line:"=!"
            set "line=!line: =!"
            for /f "tokens=* delims= " %%v in ("!line!") do set "CURRENT_VERSION=%%v"
        )
    )
)

if not defined CURRENT_VERSION set "CURRENT_VERSION=1.0.1"

echo poly-translator version: %CURRENT_VERSION%
echo.

findstr /c:"publish = false" "%CARGO_TOML%" >nul
if !errorlevel! equ 0 (
    echo WARNING: Found publish = false in Cargo.toml
    echo Remove temporarily? (y/n)
    set /p "confirm=> "
    if /i "!confirm!"=="y" (
        echo.
        echo Backing up Cargo.toml...
        copy "%CARGO_TOML%" "%CARGO_TOML%.backup" >nul
        echo Removing publish = false...
        powershell -Command "(Get-Content '%CARGO_TOML%') -replace 'publish = false', '# publish = false' | Set-Content '%CARGO_TOML%'"
        set "NEED_RESTORE=true"
    ) else (
        echo Cancelled
        exit /b 1
    )
) else (
    set "NEED_RESTORE=false"
)

echo.
echo ============================================
echo   Pre-publish Checks
echo ============================================
echo.

echo 1. Checking cargo...
cargo login --help >nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: cargo not available
    if "!NEED_RESTORE!"=="true" (
        copy "%CARGO_TOML%.backup" "%CARGO_TOML%" >nul
        del "%CARGO_TOML%.backup" >nul
    )
    exit /b 1
)
echo NOTE: Ensure cargo login is done
echo.

echo 2. Running cargo check...
cargo check --all-features
if !errorlevel! neq 0 (
    echo Build FAILED
    if "!NEED_RESTORE!"=="true" (
        copy "%CARGO_TOML%.backup" "%CARGO_TOML%" >nul
        del "%CARGO_TOML%.backup" >nul
    )
    exit /b 1
)
echo Build OK
echo.

echo 3. Running tests (skip integration tests without env vars)...
cargo test --all-features -- --skip "poly_translator::caiyun_translator" --skip "poly_translator::baidu_translator" --skip "test_create_baidu_translator"
if !errorlevel! neq 0 (
    echo Tests FAILED
    if "!NEED_RESTORE!"=="true" (
        copy "%CARGO_TOML%.backup" "%CARGO_TOML%" >nul
        del "%CARGO_TOML%.backup" >nul
    )
    exit /b 1
)
echo Tests OK
echo.
echo NOTE: Integration tests skipped (require CAIYUN_TOKEN, BAIDU_APP_ID)
echo.

echo ============================================
echo   Publish Confirmation
echo ============================================
echo.
echo Package to publish:
echo   - poly-translator v%CURRENT_VERSION%
echo.
echo Confirm publish to crates.io? (y/n)
set /p "confirm=> "
if /i not "!confirm!"=="y" (
    echo Cancelled
    if "!NEED_RESTORE!"=="true" (
        copy "%CARGO_TOML%.backup" "%CARGO_TOML%" >nul
        del "%CARGO_TOML%.backup" >nul
    )
    exit /b 1
)

echo.
echo 4. Publishing poly-translator v%CURRENT_VERSION%...
echo NOTE: This may take a moment...
cargo publish
if !errorlevel! neq 0 (
    echo Publish FAILED
    if "!NEED_RESTORE!"=="true" (
        copy "%CARGO_TOML%.backup" "%CARGO_TOML%" >nul
        del "%CARGO_TOML%.backup" >nul
    )
    exit /b 1
)

echo.
echo ============================================
echo   Success!
echo ============================================
echo.
echo Published package:
echo   - poly-translator v%CURRENT_VERSION%
echo     https://crates.io/crates/poly-translator
echo     https://docs.rs/poly-translator/%CURRENT_VERSION%
echo.

if "!NEED_RESTORE!"=="true" (
    del "%CARGO_TOML%.backup" >nul 2>&1
)

pause
