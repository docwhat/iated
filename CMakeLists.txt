cmake_minimum_required(VERSION 2.0)
project(IATD)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_SOURCE_DIR}/cmake)

find_package(Event REQUIRED)
message("EDIR is '${Event_INCLUDE_DIRS}'")
include_directories(SYSTEM ${Event_INCLUDE_DIRS} )


# Executable
add_executable(executable main.c server.c)
set_target_properties(executable PROPERTIES OUTPUT_NAME "iatd")
target_link_libraries(executable ${Event_LIBRARIES})

