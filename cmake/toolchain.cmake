# ==============================================================================
# Universal toolchain file
# Supports GCC, Clang, MSVC, MinGW, Conan, sanitizers, profiling
# ==============================================================================

message(STATUS "Toolchain: Target system is ${CMAKE_SYSTEM_NAME}")

# --- Default C++ standard ---
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# --- Allowed build types (Conan-compatible) ---
set(allowed_build_types Debug Release RelWithDebInfo MinSizeRel)
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose build type" FORCE)
endif()
set(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "Choose build type" FORCE)
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${allowed_build_types})

# --- Base warnings ---
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-Wall -Wextra -Wpedantic -Wshadow -Wconversion)
elseif (MSVC)
    add_compile_options(/W4 /permissive- /Zc:__cplusplus)
endif()

# --- Per-config flags ---
if (MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "/Zi /Od /RTC1")
    set(CMAKE_CXX_FLAGS_RELEASE "/O2 /DNDEBUG")
else()
    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -ggdb")
    set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG")
endif()

# --- Optional sanitizers ---
if (SANITIZER AND NOT MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer")
    if (SANITIZER STREQUAL "address")
        add_compile_options(-fsanitize=address)
        add_link_options(-fsanitize=address)
    elseif (SANITIZER STREQUAL "undefined")
        add_compile_options(-fsanitize=undefined)
        add_link_options(-fsanitize=undefined)
    elseif (SANITIZER STREQUAL "thread")
        add_compile_options(-fsanitize=thread)
        add_link_options(-fsanitize=thread)
    elseif (SANITIZER STREQUAL "memory")
        add_compile_options(-fsanitize=memory)
        add_link_options(-fsanitize=memory)
    else()
        message(FATAL_ERROR "Unknown SANITIZER type: ${SANITIZER}")
    endif()
endif()

# --- MinGW static linking ---
if (MINGW)
    add_link_options(-static -static-libgcc -static-libstdc++)
endif()

# --- Profiling ---
if (ENABLE_PROFILING AND NOT MSVC)
    add_compile_options(-pg)
    add_link_options(-pg)
endif()

# --- Colored diagnostics ---
if (NOT MSVC)
    add_compile_options(-fdiagnostics-color=always)
endif()

# --- VSCode / Debugger ---
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# --- Conan integration ---
if (EXISTS "${CMAKE_BINARY_DIR}/conan/conan_toolchain.cmake")
    set(CONAN_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/conan/conan_toolchain.cmake")
elseif (EXISTS "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
    set(CONAN_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
endif()

if (CONAN_TOOLCHAIN_FILE)
    message(STATUS "Including Conan toolchain: ${CONAN_TOOLCHAIN_FILE}")
    include(${CONAN_TOOLCHAIN_FILE})
endif()


# --- Summary ---
message(STATUS "Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "Compiler path: ${CMAKE_CXX_COMPILER}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
if (SANITIZER)
    message(STATUS "Sanitizer type: ${SANITIZER}")
endif()
