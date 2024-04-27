#include <gtest/gtest.h>
#include <fmt/core.h>
#include <Python.h>

TEST(FmtTest, Format_ShouldProduceCorrectOutput_WhenInsertingInteger)
{
    EXPECT_EQ(fmt::format("hello x{}!", 3), "hello x3!");
}

TEST(FmtTest, Format_ShouldProduceCorrectOutput_WhenInsertingStdString)
{
    EXPECT_EQ(fmt::format("hello {}!", std::string{"x3"}), "hello x3!");
}

TEST(FmtTest, Format_ShouldProduceCorrectOutput_WhenInsertingFloat)
{
    EXPECT_EQ(fmt::format("hello {}!", 3.14), "hello 3.14!");
}

TEST(PythonTest, MyStriCmp_ShouldReturnZero_WhenPassingEmptyStrings)
{
    EXPECT_EQ(PyOS_mystrnicmp("", "", 0), 0);
}
