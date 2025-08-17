cmake_minimum_required(VERSION 3.21)
# ----------------------------------------------------------------------
# Project setup
# ----------------------------------------------------------------------
get_filename_component(PROJECT_NAME_RAW ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" PROJECT_NAME_SANITIZED ${PROJECT_NAME_RAW})
project(${PROJECT_NAME_SANITIZED} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ----------------------------------------------------------------------
# Conan / dependencies
# ----------------------------------------------------------------------
list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/build/conan")
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/build/conan")

find_package(GTest REQUIRED)
find_package(Boost REQUIRED) 

add_subdirectory(src)

# ----------------------------------------------------------------------
# Executable
# ----------------------------------------------------------------------
add_executable(${PROJECT_NAME_SANITIZED} src/main.cpp)

# target_include_directories(${PROJECT_NAME_SANITIZED}
#     PRIVATE
#         ${Boost_INCLUDE_DIRS} 
#         ${GTest_INCLUDE_DIRS}
# )

target_link_libraries(${PROJECT_NAME_SANITIZED} 
    PRIVATE
        EmailValidator
)


# ----------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------
enable_testing()
add_subdirectory(tests)
