// SPDX-FileCopyrightText: 2024 Denis Danilov
// SPDX-License-Identifier: GPL-3.0-only

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
