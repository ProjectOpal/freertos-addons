# This is an example script for use with CMake projects for locating and
# configuring the FreeRTOS C++ library.

# Make a really good guess regarding location of FREERTOS_SRC_ROOT_FOLDER
if(NOT DEFINED FREERTOS_SRC_ROOT_FOLDER)
  get_filename_component(FREERTOS_SRC_ROOT_FOLDER
                         ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
endif()

# Find all FreeRTOS sources and headers
set(FREERTOS_SRC_DIR ${FREERTOS_SRC_ROOT_FOLDER}/FreeRTOS/Source)
set(FREERTOS_INC_DIR ${FREERTOS_SRC_ROOT_FOLDER}/FreeRTOS/Source/include)
set(PORTABLE_SRC_DIR ${FREERTOS_SRC_ROOT_FOLDER}/Linux/portable/GCC/Linux)
set(PORTABLE_SRC_MEM_MANG_DIR
    ${FREERTOS_SRC_ROOT_FOLDER}/FreeRTOS/Source/portable/MemMang)
set(FREERTOS_CPP_SRC_DIR ${FREERTOS_SRC_ROOT_FOLDER}/c++/Source)
set(FREERTOS_CPP_INC_DIR ${FREERTOS_SRC_ROOT_FOLDER}/c++/Source/include)

# Find all files needed for both native and cross builds

# Find all the .c freertos files
file(GLOB FREERTOS_SRC
        "${FREERTOS_SRC_DIR}/*.c")
# Find all freertos CPP files from freertos-addons
file(GLOB FREERTOS_CPP_SRC
          "${FREERTOS_CPP_SRC_DIR}/*.cpp")

# Include all FreeRTOS header files
file(GLOB FREERTOS_SRC_HDRS
     "${FREERTOS_INC_DIR}/*.h"
     "${FREERTOS_CPP_INC_DIR}/*.hpp")

# Find all files needed for native build
if (NOT ${CMAKE_CROSSCOMPILING})
  message(STATUS "NOTE: Not performing cross compilation build!")
  # Choose the memory managment alogorithm
  set(FREERTOS_SRC ${FREERTOS_SRC}
                   "${PORTABLE_SRC_MEM_MANG_DIR}/heap_3.c")
  # Choose port mapping
  set(FREERTOS_SRC ${FREERTOS_SRC} "${PORTABLE_SRC_DIR}/port.c")

    # Include port mapping
  set(FREERTOS_SRC_HDRS ${FREERTOS_SRC_HDRS}
      "${PORTABLE_SRC_DIR}/portmacro.h")

  # Include the FreeRTOSConfig file
  set(FREERTOS_SRC_HDRS ${FREERTOS_SRC_HDRS}
      "${CMAKE_CURRENT_SOURCE_DIR}/src/SHIL/FreeRTOSConfig.h")

  # Include Linux Macros
  set (FREERTOS_SRC_HDRS ${FREERTOS_SRC_HDRS}
       "${CMAKE_CURRENT_SOURCE_DIR}/src/SHIL/FreeRTOSmacros.hpp")

  set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}
    "-std=c++11 -Wall -Werror -Wextra -Wpedantic -pthread -O0 -g")
endif(NOT ${CMAKE_CROSSCOMPILING})

# Include .h and .hpp files to the build
include_directories(${FREERTOS_INC_DIR})
include_directories(${FREERTOS_CPP_INC_DIR})
include_directories(${PORTABLE_SRC_DIR})

message(STATUS "Loaded FreeRTOS and FreeRTOSCPP files")
