#include <gtest/gtest.h>
#include <fmt/core.h>

TEST(FmtTest, Format_ShouldProduceCorrectOutput_WhenInsertingInteger) {
    EXPECT_EQ(fmt::format("hello x{}!", 3), "hello x3!");
}

TEST(FmtTest, Format_ShouldProduceCorrectOutput_WhenInsertingStdString) {
    EXPECT_EQ(fmt::format("hello {}!", std::string{"x3"}), "hello x3!");
}

