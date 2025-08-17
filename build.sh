#!/usr/bin/env bash
set -euo pipefail

# ==============================
# Defaults
# ==============================
BUILD_TYPE="Debug"
GENERATOR="Ninja"
SANITIZER=""
BUILD_DIR=""
CONAN_DIR="build/conan"

# ==============================
# Help message
# ==============================
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --type <Debug|Release|RelWithDebInfo|MinSizeRel>   Build type (default: Debug)"
    echo "  --gen <Ninja|Unix Makefiles|Visual Studio 17 2022> Generator (default: Ninja)"
    echo "  --san <address|undefined|thread|memory>            Sanitizer (Linux/Clang/GCC only)"
    echo "  --help                                             Show this help"
    exit 1
}

# ==============================
# Parse arguments
# ==============================
while [[ $# -gt 0 ]]; do
    case "$1" in
        --type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        --gen)
            GENERATOR="$2"
            shift 2
            ;;
        --san)
            SANITIZER="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# ==============================
# Derived build dir name
# ==============================
BUILD_DIR="build/$(echo "${GENERATOR}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')-$(echo "${BUILD_TYPE}" | tr '[:upper:]' '[:lower:]')"
if [[ -n "$SANITIZER" ]]; then
    BUILD_DIR="${BUILD_DIR}-${SANITIZER}"
fi

mkdir -p "$BUILD_DIR"
mkdir -p "$CONAN_DIR"

# ==============================
# Conan install
# ==============================
echo ">>> Running Conan install..."
conan install . \
    --output-folder="$CONAN_DIR" \
    --build=missing

# ==============================
# Configure with CMake
# ==============================
echo ">>> Configuring build:"
echo "    Type:      ${BUILD_TYPE}"
echo "    Generator: ${GENERATOR}"
echo "    Sanitizer: ${SANITIZER:-none}"
echo "    Build dir: ${BUILD_DIR}"
echo "    Conan dir: ${CONAN_DIR}"

cmake -S . -B "$BUILD_DIR" \
    -G "${GENERATOR}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DCMAKE_TOOLCHAIN_FILE="$(pwd)/cmake/toolchain.cmake" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    ${SANITIZER:+-DSANITIZER=${SANITIZER}}

# ==============================
# Build
# ==============================
echo ">>> Building..."
cmake --build "$BUILD_DIR" --parallel

# ==============================
# Copy compile_commands.json
# ==============================
if [[ -f "$BUILD_DIR/compile_commands.json" ]]; then
    echo ">>> Copying compile_commands.json to project root..."
    cp "$BUILD_DIR/compile_commands.json" .
fi

echo ">>> Build finished successfully!"
