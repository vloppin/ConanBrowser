cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(ConanBrowser)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Quick REQUIRED)

add_executable(${PROJECT_NAME} main.cpp conanhelper.cpp conanhelper.h qml.qrc)

target_link_libraries(${PROJECT_NAME} Qt5::Quick)
