cmake_minimum_required(VERSION 3.0.0)

set(CMAKE_CXX_STANDARD 17)

if("$ENV{ENABLE_LIBCPP}" STREQUAL "true")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")
endif()

# if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
#   set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
#       CACHE STRING "")

#   message("------- test")
# endif()


project(test CXX)

enable_testing()
add_subdirectory(src)

