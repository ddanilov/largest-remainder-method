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

    @testset "distribute_quota" begin

        @testset "empty votes" begin
            rest, quotas = distribute_quota(0, Party[])
            @test rest == 0
            @test isempty(quotas)

            rest, quotas = distribute_quota(1, Party[])
            @test rest == 1
            @test isempty(quotas)
        end

        @testset "zero seats" begin
            votes = [Party("A", 1), Party("B", 2), Party("C", 3)]
            rest, quotas = distribute_quota(0, votes)
            @test rest == 0
            @test all(p.quota == 0 for p in quotas)
        end

        @testset "equal distribution" begin
            votes = [Party("A", 10), Party("B", 10), Party("C", 10)]
            rest, quotas = distribute_quota(300, votes)
            @test rest == 0
            @test quotas[1].quota == 100
            @test quotas[1].remainder == 0
            @test quotas[2].quota == 100
            @test quotas[2].remainder == 0
            @test quotas[3].quota == 100
            @test quotas[3].remainder == 0
        end

        @testset "proportional distribution" begin
            votes = [Party("A", 1), Party("B", 2), Party("C", 3)]
            rest, quotas = distribute_quota(300, votes)
            @test rest == 0
            @test quotas[1].quota == 50
            @test quotas[1].remainder == 0
            @test quotas[2].quota == 100
            @test quotas[2].remainder == 0
            @test quotas[3].quota == 150
            @test quotas[3].remainder == 0
        end

        @testset "with rest 301" begin
            votes = [Party("A", 1), Party("B", 2), Party("C", 3)]
            rest, quotas = distribute_quota(301, votes)
            @test rest == 1
            @test quotas[1].quota == 50
            @test quotas[1].remainder == 1
            @test quotas[2].quota == 100
            @test quotas[2].remainder == 2
            @test quotas[3].quota == 150
            @test quotas[3].remainder == 3
        end

    end

    @testset "distribute_rest" begin

        @testset "one" begin
            data = [Party("A", 0, 300, 1), Party("B", 0, 200, 2), Party("C", 0, 100, 3)]
            result = distribute_rest(1, data)
            @test result[1].quota == 300
            @test result[2].quota == 200
            @test result[3].quota == 101
        end

        @testset "two" begin
            data = [Party("A", 0, 300, 1), Party("B", 0, 200, 2), Party("C", 0, 100, 3)]
            result = distribute_rest(2, data)
            @test result[1].quota == 300
            @test result[2].quota == 201
            @test result[3].quota == 101
        end

        @testset "three" begin
            data = [Party("A", 0, 300, 1), Party("B", 0, 200, 2), Party("C", 0, 100, 3)]
            result = distribute_rest(3, data)
            @test result[1].quota == 301
            @test result[2].quota == 201
            @test result[3].quota == 101
        end

    end

end
