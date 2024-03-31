// SPDX-FileCopyrightText: 2024 Denis Danilov
// SPDX-License-Identifier: GPL-3.0-only

#include "lrm.hpp"

#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest/doctest.h>

TEST_CASE("reading input data")
{
  std::istringstream input;
  REQUIRE(input.view().empty());

  SUBCASE("empty input")
  {
    const auto data = read_data(input);
    CHECK(data.first == 0);
    CHECK(data.second.empty());
  }

  SUBCASE("single party")
  {
    input.str("party_A 10");
    const auto data = read_data(input);

    CHECK(data.first == 0);
    CHECK(data.second.size() == 1);

    CHECK(data.second.at(0) == std::pair(std::string("party_A"), 10));
  }

  SUBCASE("two parties with seats")
  {
    input.str("seats 123\n"
              "party_A 10\n"
              "party_B 11\n");
    const auto data = read_data(input);

    CHECK(data.first == 123);
    CHECK(data.second.size() == 2);

    CHECK(data.second.at(0) == std::pair(std::string("party_A"), 10));
    CHECK(data.second.at(1) == std::pair(std::string("party_B"), 11));
  }
}
