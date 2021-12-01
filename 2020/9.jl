lines = readlines("9.txt")
numbers = parse.(Int, lines)
function findfirstincorrect(numbers)
    for i in 26:length(numbers)
        goaln, prevn = numbers[i], numbers[i-25:i-1]
        if goaln ∉ prevn .+ prevn'
            return numbers[i]
        end
    end
end
invalid_number = findfirstincorrect(numbers)



# find a contiguous set of at least two numbers which sum to invalid_number
function part2(numbers)
    summed_numbers = copy(numbers)
    for i in 1:length(numbers)
        summed_numbers[1:end-i] .+= numbers[1+i:end]
        if invalid_number ∈ summed_numbers
            @info "Found result" i invalid_number
            idx = findfirst(x -> x==invalid_number, summed_numbers)
            crange = numbers[idx:idx+i]
            return minimum(crange)+maximum(crange)
        end
    end
end
part2(numbers)
