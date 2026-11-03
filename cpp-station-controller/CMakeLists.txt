cmake_minimum_required(VERSION 3.20)
project(LockerStationController
    VERSION 1.0.0
    DESCRIPTION "Edge Station Controller and Hardware Simulator"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/W4 /permissive-)
else()
    add_compile_options(-Wall -Wextra -Wpedantic -Wconversion)
endif()

include_directories(include)

file(GLOB_RECURSE CONTROLLER_SOURCES "src/*.cpp")

add_library(station_core STATIC ${CONTROLLER_SOURCES})
target_include_directories(station_core PUBLIC include)

add_executable(station_app src/main.cpp)
target_link_libraries(station_app PRIVATE station_core)

find_package(Threads REQUIRED)
target_link_libraries(station_app PRIVATE Threads::Threads)
target_link_libraries(station_core PRIVATE Threads::Threads)
