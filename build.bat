@echo off
setlocal enabledelayedexpansion

:: ==============================
:: Defaults
:: ==============================
set BUILD_TYPE=Debug
set GENERATOR=Ninja
set SANITIZER=
set CONAN_DIR=build\conan
set BUILD_DIR=

:: ==============================
:: Help message
:: ==============================
:usage
echo Usage: %~nx0 [options]
echo.
echo Options:
echo   --type ^<Debug^|Release^|RelWithDebInfo^|MinSizeRel^>   Build type (default: Debug)
echo   --gen  ^<Ninja^|Unix Makefiles^|Visual Studio 17 2022^> Generator (default: Ninja)
echo   --san  ^<address^|undefined^|thread^|memory^>           Sanitizer (Linux/Clang/GCC only)
echo   --help                                                 Show this help
exit /b 1

:: ==============================
:: Parse arguments
:: ==============================
:parse_args
if "%~1"=="" goto after_parse

if "%~1"=="--type" (
    set BUILD_TYPE=%~2
    shift
    shift
    goto parse_args
)

if "%~1"=="--gen" (
    set GENERATOR=%~2
    shift
    shift
    goto parse_args
)

if "%~1"=="--san" (
    set SANITIZER=%~2
    shift
    shift
    goto parse_args
)

if "%~1"=="--help" (
    goto usage
)

echo Unknown option: %~1
goto usage

:after_parse

:: ==============================
:: Derived build dir name
:: ==============================
set "GENERATOR_SANITIZED=%GENERATOR: =-%"
set "GENERATOR_SANITIZED=%GENERATOR_SANITIZED:"=%"
set "GENERATOR_SANITIZED=%GENERATOR_SANITIZED:~0,64%"

set "BUILD_DIR=build\%GENERATOR_SANITIZED%-%BUILD_TYPE%"
if not "%SANITIZER%"=="" (
    set "BUILD_DIR=%BUILD_DIR%-%SANITIZER%"
)

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%CONAN_DIR%" mkdir "%CONAN_DIR%"

:: ==============================
:: Conan install
:: ==============================
echo >>> Running Conan install...
conan install . ^
    --output-folder="%CONAN_DIR%" ^
    --build=missing

:: ==============================
:: Configure with CMake
:: ==============================
echo >>> Configuring build:
echo     Type:      %BUILD_TYPE%
echo     Generator: %GENERATOR%
echo     Sanitizer: %SANITIZER%
echo     Build dir: %BUILD_DIR%
echo     Conan dir: %CONAN_DIR%

cmake -S . -B "%BUILD_DIR%" ^
    -G "%GENERATOR%" ^
    -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
    -DCMAKE_TOOLCHAIN_FILE=%cd%\cmake\toolchain.cmake ^
    %SANITIZER:^=-DSANITIZER=%SANITIZER%%

:: ==============================
:: Build
:: ==============================
echo >>> Building...
cmake --build "%BUILD_DIR%" --parallel
