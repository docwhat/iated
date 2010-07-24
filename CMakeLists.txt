cmake_minimum_required(VERSION 2.0)
project(IATD)

# My cmake modules.
set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_SOURCE_DIR}/cmake)

# Figure out the build type.
IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING
      "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
      FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)

# We need libevent.
find_package(Event REQUIRED)
include_directories(SYSTEM ${Event_INCLUDE_DIRS} )

# Executable
add_executable(executable src/main.c src/server.c src/sqlite3.c src/token.c)
set_target_properties(executable PROPERTIES OUTPUT_NAME "iatd")
target_link_libraries(executable ${Event_LIBRARIES})

