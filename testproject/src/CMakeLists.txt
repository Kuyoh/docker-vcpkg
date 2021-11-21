
# include(CTest)
# enable_testing()

# set(CPACK_PROJECT_NAME ${PROJECT_NAME})
# set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
# include(CPack)

find_package(fmt REQUIRED)
find_package(GTest REQUIRED)

add_executable(fmt-tests fmt-tests.cpp)
target_compile_features(fmt-tests PRIVATE cxx_std_17)
target_link_libraries(fmt-tests PRIVATE fmt::fmt GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(fmt-tests)