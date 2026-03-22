# SPDX-FileCopyrightText: 2026 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

using LargestRemainder

using Test

@testset "LargestRemainder" begin

    @testset "read_data" begin

        @testset "empty input" begin
            mktemp() do path, io
                close(io)

                seats, votes = read_data(path)

                @test seats == 0
                @test length(votes) == 0
            end
        end

        @testset "seats only" begin
            mktemp() do path, io
                println(io, "seats   123")
                close(io)

                seats, votes = read_data(path)

                @test seats == 123
                @test length(votes) == 0
            end
        end

        @testset "single party" begin
            mktemp() do path, io
                println(io, "party_A 10")
                close(io)

                seats, votes = read_data(path)

                @test seats == 0
                @test length(votes) == 1

                @test votes[1].name == "party_A"
                @test votes[1].votes == 10
            end
        end

        @testset "two parties with seats" begin
            mktemp() do path, io
                println(io, "seats   123")
                println(io, "party_A 10")
                println(io, "party_B 11")
                close(io)

                seats, votes = read_data(path)

                @test seats == 123
                @test length(votes) == 2

                @test votes[1].name == "party_A"
                @test votes[1].votes == 10

                @test votes[2].name == "party_B"
                @test votes[2].votes == 11
            end
        end

        @testset "large data" begin
            mktemp() do path, io
                num_items = 100
                for i in 1:num_items
                    println(io, "data_$(lpad(i, 3, '0')) $(i)")
                end
                close(io)

                seats, votes = read_data(path)

                @test seats == 0
                @test length(votes) == num_items

                @test votes[1].name == "data_001"
                @test votes[1].votes == 1

                @test votes[2].name == "data_002"
                @test votes[2].votes == 2

                @test votes[num_items].name == "data_100"
                @test votes[num_items].votes == num_items
            end
        end
    end

end
