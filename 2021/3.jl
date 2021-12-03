input = [
    "00100"
    "11110"
    "10110"
    "10111"
    "10101"
    "01111"
    "00111"
    "11100"
    "10000"
    "11001"
    "00010"
    "01010"
]
input2intmat(input) = parse.(Int, reduce(hcat, collect.(input)))
function ex1(input)
    mat = input2intmat(input)
    n_digits, n_numbers = size(mat)
    gamma_binary_string = join(Int.(round.(sum(mat, dims=2) / n_numbers)))
    gamma = parse(Int, gamma_binary_string, base=2)
    epsilon = xor(gamma, parse(Int, '1'^n_digits, base=2))
    return gamma * epsilon
end
ex1(eachline("3.txt"))


# Start with the full list
# Consider only the first bit

oxygen_bit_criterium(v) = Int(round(sum(v) / length(v) + eps(1.0)))
co2_bit_criterium(v) = xor(oxygen_bit_criterium(v), 1)
function find_rating(candidates, criterium)
    n_digits = length(candidates[1])
    for i in 1:n_digits
        d = criterium([m[i] for m in candidates])
        candidates = filter(v->v[i]==d, candidates)
        if length(candidates) == 1
            break
        end
    end
    return parse(Int, join(candidates[1]), base=2)
end

function ex2(input)
    candidates = map(r -> parse.(Int, r), collect.(input))
    oxygen = find_rating(candidates, oxygen_bit_criterium)
    co2 = find_rating(candidates, co2_bit_criterium)
    return oxygen * co2
end
ex2(eachline("3.txt"))
