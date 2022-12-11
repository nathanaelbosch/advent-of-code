example = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

parse_operation(operation) = eval(Meta.parse("old -> " * operation[6:end]))

function parse_input(input)
    lines = split(input, "\n")
    n_monkeys = length(lines) ÷ 7

    monkeys = Dict{Int,Dict}()
    for id in 0:n_monkeys-1
        monkey = Dict{Symbol,Any}()
        monkey[:id] = id
        monkey[:items] = parse.(BigInt, split(split(lines[7*id+2], ": ")[2], ", "))
        monkey[:operation] = parse_operation(split(lines[7*id+3], ": ")[2])
        monkey[:test_divisable] = parse(Int, split(split(lines[7*id+4], ": ")[2], " ")[3])
        monkey[:if_true_throw_to] = parse(Int, split(lines[7*id+5], " ")[end])
        monkey[:if_false_throw_to] = parse(Int, split(lines[7*id+6], " ")[end])
        monkey[:n_inspected] = 0
        monkeys[id] = monkey
    end
    return monkeys
end
# monkeys = parse_input(example)

function round!(monkeys; div3=true)
    divisors = [m[:test_divisable] for (k, m) in monkeys]
    D = lcm(divisors...)
    for id in 0:length(monkeys)-1
        monkey = monkeys[id]
        while !isempty(monkey[:items])
            monkey[:n_inspected] += 1
            item = popfirst!(monkey[:items])
            new_item = monkey[:operation](item)
            if div3
                new_item = floor(new_item / 3)
            end
            new_item = new_item % D
            if new_item % monkey[:test_divisable] == 0
                push!(monkeys[monkey[:if_true_throw_to]][:items], new_item)
            else
                push!(monkeys[monkey[:if_false_throw_to]][:items], new_item)
            end
        end
    end
end
# round!(monkeys)
# [k => m[:items] for (k, m) in monkeys]
# [k => m[:n_inspected] for (k, m) in monkeys]

# Part 1
monkeys = parse_input(example)
# monkeys = parse_input(read("11.txt", String))
for _ in 1:20
    round!(monkeys)
end
score = [m[:n_inspected] for (k, m) in monkeys] |> sort |> reverse |> x -> first(x, 2) |> prod


# Part 2
# monkeys = parse_input(example)
monkeys = parse_input(read("11.txt", String))
for _ in 1:10000
    round!(monkeys; div3=false)
    # @info "" [k => m[:items] for (k, m) in monkeys]
end
score = [m[:n_inspected] for (k, m) in monkeys] |> sort |> reverse |> x -> first(x, 2) |> prod
