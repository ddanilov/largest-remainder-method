# SPDX-FileCopyrightText: 2026 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

module LargestRemainder

export Party, read_data, distribute_quota, distribute_rest

mutable struct Party
    name::String
    votes::Int
    quota::Int
    remainder::Int
end

Party(name, votes) = Party(name, votes, 0, 0)

function read_data(filename)
    seats = 0
    votes = Party[]
    open(filename) do f
        for line in eachline(f)
            parts = split(line)
            length(parts) == 2 || continue
            key, val = parts[1], parse(Int, parts[2])
            if key == "seats"
                seats = val
            else
                push!(votes, Party(key, val))
            end
        end
    end
    return seats, votes
end

function distribute_quota(seats, votes)
    total = sum(p.votes for p in votes; init=0)
    names = getfield.(votes, :name)
    vote_counts = getfield.(votes, :votes)

    if total == 0
        quotas = Party.(names, vote_counts, 0, 0)
    else
        x = vote_counts .* seats
        quotas = Party.(names, vote_counts, x .÷ total, mod.(x, total))
    end

    rest = seats - sum(getfield.(quotas, :quota); init=0)
    return rest, quotas
end

function distribute_rest(rest, quotas)
    result = deepcopy(quotas)
    perm = sortperm(result, by=p -> p.remainder, rev=true)
    for i in perm[1:rest]
        result[i].quota += 1
    end
    return result
end

end
