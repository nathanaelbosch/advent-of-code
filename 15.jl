using BenchmarkTools
using ProgressMeter

myinput = [1,20,8,12,0,14]
testinput = [0,3,6]

function memory_game(input, N)
    list = zeros(eltype(input), N)
    list[1:length(input)] = input
    @showprogress for i in (length(input)+1):N
        # @show N - i
        last_spoken = list[i-1]
        prev_idx = findlast(==(last_spoken), @view list[1:i-2])
        next_number = isnothing(prev_idx) ? 0 : i - prev_idx - 1
        list[i] = next_number
    end
    return list[end]
end

part1 = memory_game(myinput, 2020)

# part 2
N = 30000000
@btime memory_game(testinput, N÷100)
# memory_game([0,3,6], N)
# Should be 175594



# THE ABOVE IS TOO SLOW! `findlast` gets really slow when the array gets large
# Alternative approach: Save a dict: number => last spoken
input = testinput
function memory_game2(input, N)
    table = Dict(zip(input[1:end-1], 1:length(input)-1))
    lastspoken = input[end]
    # @show table
    @showprogress for idx_lastspoken in (length(input)):N-1
        # @show N - i
        try
            prev_idx = table[lastspoken]
            age = idx_lastspoken - prev_idx
            table[lastspoken] = idx_lastspoken
            lastspoken = age
        catch
            table[lastspoken] = idx_lastspoken
            lastspoken = 0
        end
        # @show lastspoken
    end
    return lastspoken
end
# BLAZING FAST!
@btime memory_game2(testinput, N)
part2 = memory_game2(testinput, N)
