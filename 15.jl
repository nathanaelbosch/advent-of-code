using ProgressMeter

myinput = [1,20,8,12,0,14]
testinput = [0,3,6]

function memory_game(input, N)
    list = zeros(Int, N)
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
# @btime memory_game([0,3,6], N÷100)
# memory_game([0,3,6], N)
# Should be 175594
memory_game(myinput, N)
