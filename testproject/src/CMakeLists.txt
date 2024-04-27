find_package(fmt REQUIRED)
find_package(GTest REQUIRED)
find_package(Python3 COMPONENTS Development REQUIRED)

add_executable(tests fmt-tests.cpp)
target_compile_features(tests PRIVATE cxx_std_17)
target_link_libraries(tests
    PRIVATE
        fmt::fmt
        Python3::Python
        GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(tests)