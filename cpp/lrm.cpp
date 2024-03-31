// SPDX-FileCopyrightText: 2024 Denis Danilov
// SPDX-License-Identifier: GPL-3.0-only

#include "lrm.hpp"

#include <fstream>
#include <print>

template <size_t index = 1>
void print_results(const auto& results)
{
  auto r = results;
  reverse_sort_by<index>(r);

  auto print_line = [](const auto& v1, const auto& v2, const auto& v3) {
    std::println("{:<10} {:>10} {:>10}", v1, v2, v3);
  };
  print_line("name", "result", "remainder");
  for (const auto& x : r) { print_line(std::get<0>(x), std::get<1>(x), std::get<2>(x)); }
}

int main(int argc, char** argv)
{
  if (argc != 2)
  {
    std::println("wrong number of arguments: {}", argc);
    for (int i = 0; i < argc; ++i)
    {
      std::println("argv[{}]: {}", i, argv[i]);
    }
    return EXIT_FAILURE;
  }

  const std::string file_name(argv[1]);
  std::ifstream input_file(file_name, std::ios::in);
  auto [seats, votes] = read_data(input_file);

  auto [rest, quotas] = distribute_quota(seats, votes);
  std::println("{:=^32}", " QUOTA ");
  print_results(quotas);
  std::println("rest: {}", rest);

  std::println("{:=^32}", " FINAL ");
  auto results = distribute_rest(rest, quotas);
  print_results(results);
}
