// SPDX-FileCopyrightText: 2024-2025 Denis Danilov
// SPDX-License-Identifier: GPL-3.0-only

#pragma once

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
    auto key = std::string_view(key_value.front());
    auto value = std::string_view((key_value | std::views::drop(1)).front());
    auto number = std::stoi(value.data());
    if (key == "seats") { seats = number; }
    else { data.emplace_back(key, number); }
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

template <size_t index>
void reverse_sort_by(auto& seq)
{
  std::ranges::sort(seq, [](const auto& x, const auto& y) { return std::get<index>(x) > std::get<index>(y); });
}

auto distribute_rest(const int rest, const auto& quotas)
{
  auto result = quotas;
  reverse_sort_by<2>(result);
  std::ranges::for_each(result | std::ranges::views::take(rest), [](auto& x) { ++std::get<1>(x); });
  return result;
}
