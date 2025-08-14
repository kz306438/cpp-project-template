cmake_minimum_required(VERSION 3.21)

get_filename_component(PROJECT_NAME_RAW ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" PROJECT_NAME_SANITIZED ${PROJECT_NAME_RAW})
project(${PROJECT_NAME_SANITIZED} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    add_compile_options(/W4 /permissive-)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Указываем, что Conan сгенерировал Find*.cmake в build/
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}")

find_package(GTest REQUIRED)
find_package(Boost REQUIRED)

add_executable(${PROJECT_NAME_SANITIZED} src/main.cpp)
target_link_libraries(${PROJECT_NAME_SANITIZED} PRIVATE GTest::gtest Boost::boost)
