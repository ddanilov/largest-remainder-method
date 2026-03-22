# SPDX-FileCopyrightText: 2026 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

module LargestRemainder

export Party, read_data

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

end
