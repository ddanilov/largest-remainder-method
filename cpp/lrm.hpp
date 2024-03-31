// SPDX-FileCopyrightText: 2024 Denis Danilov
// SPDX-License-Identifier: GPL-3.0-only

#include <algorithm>
#include <istream>
#include <ranges>
#include <vector>

auto read_data(std::istream& input)
{
  std::string line;
  int seats = 0;
  std::vector<std::pair<std::string, int>> data;
  while (std::getline(input, line))
  {
    auto key_value = std::views::split(line, ' ');
    auto key = std::string_view(*key_value.cbegin());
    auto value = std::stoi((*std::next(key_value.cbegin())).data());
    if (key == "seats") { seats = value; }
    else { data.emplace_back(key, value); }
  }
  return std::make_pair(seats, data);
}

auto distribute_quota(const int seats, const auto& votes)
{
  const auto total = std::ranges::fold_left(votes | std::ranges::views::values, 0, std::plus());
  auto rest = seats;
  std::vector<std::tuple<std::string, int, int>> result;
  for (const auto& [name, vote] : votes)
  {
    const auto x = seats * vote;
    const auto division = std::div(x, total);
    result.emplace_back(name, division.quot, division.rem);
    rest -= division.quot;
  }
  return std::make_pair(rest, result);
}
