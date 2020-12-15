using BenchmarkTools

function part1(jolts)
    push!(jolts, 0)
    sort!(jolts)
    push!(jolts, jolts[end]+3)
    diffs = diff(jolts)
    return count(diffs.==1) * count(diffs.==3)
end

@btime part1(jolts) setup=(jolts=parse.(Int, readlines("10.txt")))

jolts = parse.(Int, readlines("10.txt"));
println("Part 1: $(part1(jolts))")



# Part 2: Note that diffs==1 or diffs==3, but not diffs==2!
# Insight: We can not skip any adapter in a 3-diff pair
# Ok, so it comes down to figuring out what to do for each chain of diff==1's
function d1chain_possibilities(N)
    if N == 0
        return 1 # Nothing else to do
    elseif N == 1
        return 1 # Nothing else to do
    elseif N == 2
        return 2 # Original + middle skip; Borders are fixed
    elseif N == 3
        return 4
    elseif N == 4
        return 2*d1chain_possibilities(3) - 1 # otherwise we count the "stay the same" twice
    elseif N >4
        error("We're not prepared for this")
    end
end

function getchains(d1)
    chain_lengths = [0]
    for i in 1:length(d1)
        if d1[i]
            chain_lengths[end] += 1
        else
            if chain_lengths[end] != 0
                push!(chain_lengths, 0)
            end
        end
    end
    return chain_lengths
end
@assert maximum(getchains(diff(jolts) .== 1)) <= 4

@btime prod(d1chain_possibilities.(getchains(diff(jolts) .== 1)))

part2 = prod(d1chain_possibilities.(getchains(diffs .== 1)))
println("Part 2: $part2")
