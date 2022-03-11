cmake_minimum_required(VERSION 3.0.0)

set(CMAKE_CXX_STANDARD 17)

if("$ENV{ENABLE_LIBCPP}" STREQUAL "true")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")
endif()

project(test CXX)

enable_testing()
add_subdirectory(src)

