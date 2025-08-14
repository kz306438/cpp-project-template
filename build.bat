@echo off
setlocal enabledelayedexpansion

REM Параметры по умолчанию
set "GENERATOR=%~1"
if "%GENERATOR%"=="" set "GENERATOR=Ninja"

set "BUILD_TYPE=%~2"
if "%BUILD_TYPE%"=="" set "BUILD_TYPE=Release"

set "BUILD_DIR=build"

REM Создаём папку сборки
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Устанавливаем зависимости в папку сборки
conan install . --build=missing -s build_type=%BUILD_TYPE% --output-folder="%BUILD_DIR%"
if errorlevel 1 exit /b 1

REM Если в корне сгенерировались пресеты — переносим в build
if exist "CMakePresets.json" move /Y "CMakePresets.json" "%BUILD_DIR%" >nul
if exist "CMakeUserPresets.json" move /Y "CMakeUserPresets.json" "%BUILD_DIR%" >nul

REM Переходим в папку сборки
cd "%BUILD_DIR%"

REM Генерация CMake проекта
cmake .. -G "%GENERATOR%" ^
    -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
    -DCMAKE_TOOLCHAIN_FILE="%BUILD_DIR%\conan_toolchain.cmake"
if errorlevel 1 exit /b 1

REM Сборка проекта
cmake --build .
if errorlevel 1 exit /b 1

cd ..
endlocal
