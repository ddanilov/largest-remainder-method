# SPDX-FileCopyrightText: 2026 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

using LargestRemainder

using Printf

function print_results(data)
    idx = sortperm(data, by = p -> p.quota, rev = true)
    println(@sprintf("%-10s %10s %10s", "name", "result", "remainder"))
    for i in idx
        p = data[i]
        println(@sprintf("%-10s %10d %10d", p.name, p.quota, p.remainder))
    end
end

if length(ARGS) != 1
    println("wrong number of arguments: $(length(ARGS))")
    exit(1)
end

seats, votes = read_data(ARGS[1])

rest, quotas = distribute_quota(seats, votes)
println("============ QUOTA =============")
print_results(quotas)
println("rest: $rest")

println("============ FINAL =============")
results = distribute_rest(rest, quotas)
print_results(results)
