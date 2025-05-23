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
    const auto [seats, data] = read_data(input);
    CHECK(seats == 0);
    CHECK(data.empty());
  }

  SUBCASE("single party")
  {
    input.str("party_A 10");
    const auto [seats, data] = read_data(input);

    CHECK(seats == 0);
    CHECK(data.size() == 1);

    CHECK(data.at(0) == std::pair(std::string("party_A"), 10));
  }

  SUBCASE("two parties with seats")
  {
    input.str("seats 123\n"
              "party_A 10\n"
              "party_B 11\n");
    const auto [seats, data] = read_data(input);

    CHECK(seats == 123);
    CHECK(data.size() == 2);

    CHECK(data.at(0) == std::pair(std::string("party_A"), 10));
    CHECK(data.at(1) == std::pair(std::string("party_B"), 11));
  }
}

TEST_CASE("distributing votes")
{
  using V = std::vector<std::pair<std::string, int>>;

  SUBCASE("trivial cases")
  {
    SUBCASE("no votes")
    {
      V votes;
      auto [rest, quotas] = distribute_quota(1, votes);
      CHECK(rest == 1);
      CHECK(quotas.empty());
    }

    SUBCASE("no seats")
    {
      V votes = {{"A", 1},
                 {"B", 2},
                 {"C", 3}};
      auto [rest, quotas] = distribute_quota(0, votes);
      CHECK(rest == 0);
      CHECK(quotas.size() == votes.size());
      for (const auto& [name, number, rem] : quotas)
      {
        CHECK(number == 0);
      }
    }
  }

  SUBCASE("without rest")
  {
    SUBCASE("equal distribution")
    {
      V votes = {{"A", 10},
                 {"B", 10},
                 {"C", 10}};
      auto [rest, quotas] = distribute_quota(300, votes);
      CHECK(rest == 0);
      CHECK(quotas.at(0) == std::tuple(std::string("A"), 100, 0));
      CHECK(quotas.at(1) == std::tuple(std::string("B"), 100, 0));
      CHECK(quotas.at(2) == std::tuple(std::string("C"), 100, 0));
    }

    SUBCASE("proportional distribution")
    {
      V votes = {{"A", 1},
                 {"B", 2},
                 {"C", 3}};
      auto [rest, quotas] = distribute_quota(300, votes);
      CHECK(rest == 0);
      CHECK(quotas.at(0) == std::tuple(std::string("A"), 50, 0));
      CHECK(quotas.at(1) == std::tuple(std::string("B"), 100, 0));
      CHECK(quotas.at(2) == std::tuple(std::string("C"), 150, 0));
    }
  }

  SUBCASE("with rest")
  {
    SUBCASE("301")
    {
      V votes = {{"A", 1},
                 {"B", 2},
                 {"C", 3}};
      auto [rest, quotas] = distribute_quota(300 + 1, votes);
      CHECK(rest == 1);
      CHECK(quotas.at(0) == std::tuple(std::string("A"), 50, 1));
      CHECK(quotas.at(1) == std::tuple(std::string("B"), 100, 2));
      CHECK(quotas.at(2) == std::tuple(std::string("C"), 150, 3));
      auto result = distribute_rest(rest, quotas);
      CHECK(result.at(0) == std::tuple(std::string("C"), 150 + 1, 3));
      CHECK(result.at(1) == std::tuple(std::string("B"), 100, 2));
      CHECK(result.at(2) == std::tuple(std::string("A"), 50, 1));
    }

    SUBCASE("302")
    {
      V votes = {{"A", 1},
                 {"B", 2},
                 {"C", 3}};
      auto [rest, quotas] = distribute_quota(300 + 2, votes);
      CHECK(rest == 1);
      CHECK(quotas.at(0) == std::tuple(std::string("A"), 50, 2));
      CHECK(quotas.at(1) == std::tuple(std::string("B"), 100, 4));
      CHECK(quotas.at(2) == std::tuple(std::string("C"), 151, 0));
      auto result = distribute_rest(rest, quotas);
      CHECK(result.at(0) == std::tuple(std::string("B"), 100 + 1, 4));
      CHECK(result.at(1) == std::tuple(std::string("A"), 50, 2));
      CHECK(result.at(2) == std::tuple(std::string("C"), 151, 0));
    }

    SUBCASE("303a")
    {
      V votes = {{"A", 1},
                 {"B", 2},
                 {"C", 3}};
      auto [rest, quotas] = distribute_quota(300 + 3, votes);
      CHECK(rest == 1);
      CHECK(quotas.at(0) == std::tuple(std::string("A"), 50, 3));
      CHECK(quotas.at(1) == std::tuple(std::string("B"), 101, 0));
      CHECK(quotas.at(2) == std::tuple(std::string("C"), 151, 3));
      auto result = distribute_rest(rest, quotas);
      CHECK(result.at(0) == std::tuple(std::string("A"), 50 + 1, 3));
      CHECK(result.at(1) == std::tuple(std::string("C"), 151, 3));
      CHECK(result.at(2) == std::tuple(std::string("B"), 101, 0));
    }

    SUBCASE("303c")
    {
      V votes = {{"C", 3},
                 {"A", 1},
                 {"B", 2}};
      auto [rest, quotas] = distribute_quota(300 + 3, votes);
      CHECK(quotas.at(0) == std::tuple(std::string("C"), 151, 3));
      CHECK(quotas.at(1) == std::tuple(std::string("A"), 50, 3));
      CHECK(quotas.at(2) == std::tuple(std::string("B"), 101, 0));
      auto result = distribute_rest(rest, quotas);
      CHECK(result.at(0) == std::tuple(std::string("C"), 151 + 1, 3));
      CHECK(result.at(1) == std::tuple(std::string("A"), 50, 3));
      CHECK(result.at(2) == std::tuple(std::string("B"), 101, 0));
    }
  }
}
