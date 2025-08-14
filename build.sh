#!/usr/bin/env bash
set -e

GENERATOR="${1:-Ninja}"
BUILD_TYPE="${2:-Release}"
BUILD_DIR="build"

mkdir -p "$BUILD_DIR"

# Устанавливаем зависимости в папку сборки
conan install . \
    --build=missing \
    -s build_type=$BUILD_TYPE \
    --output-folder="$BUILD_DIR"

# Если в корне появились пресеты — переносим в build
if [ -f "CMakePresets.json" ]; then
    mv -f CMakePresets.json "$BUILD_DIR"/
fi

if [ -f "CMakeUserPresets.json" ]; then
    mv -f CMakeUserPresets.json "$BUILD_DIR"/
fi

cd "$BUILD_DIR"

cmake .. -G "$GENERATOR" \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_TOOLCHAIN_FILE="$BUILD_DIR/conan_toolchain.cmake"

cmake --build .
