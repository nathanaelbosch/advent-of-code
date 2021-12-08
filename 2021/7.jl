# input = "16,1,2,0,4,2,7,1,2,14"
input = readline("7.txt")
parse_input(input) = parse.(Int, split(input, ","))
positions = parse_input(input)
ex1(input) = input |> parse_input |> pos -> abs.(pos .- median(pos)) |> sum
ex1(input)

fuel_per_distance(d::Int) = (d+1) * d ÷ 2
total_fuel(x::Int, positions=positions) = sum(fuel_per_distance.(abs.(positions .- x)))
min_fuel(positions) = minimum(total_fuel.(minimum(positions):maximum(positions)))
ex2(input) = input |> parse_input |> min_fuel
ex2(input)
