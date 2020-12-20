input = readlines("16.txt")
testinput = split("""class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12""", "\n")
testinput2 = split(strip("""
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""), "\n")

lines = input


rules = []
i = 1
while i < length(lines)
    l = lines[i]
    if l == "" break end
    name, rangestr = strip.(split(l, ":"))
    ranges = [parse.(Int, split(r, "-")) for r in split(rangestr, " or ")]
    push!(rules, (name, ranges))
    i += 1
end
i += 2
myticket = parse.(Int, split(lines[i], ","))

i += 3
tickets = []
for j=i:length(lines)
    push!(tickets, parse.(Int, split(lines[j], ",")))
end

rules
myticket
tickets


# Part 1: Check each value, and check if it is valid for ANY field
isinrange(value, range) = range[1] <= value <= range[2]
checkrule(value, rule) = any(isinrange.(value, rule[2]))
error = 0
valid_tickets = []
for t in tickets
    for v in t
        # Check if it fits into ANY rule. If not, add to error
        if !any(checkrule.(v, rules))
            error += v
        end
    end
end
error


# Part 2
valid_tickets = [t for t in tickets if !any([!any(checkrule.(v, rules)) for v in t])]
possible_rules = repeat([[r[1] for r in rules]], length(rules))
rules = Dict(rules)
checkrule2(value, rule) = any(isinrange.(value, rule))
for t in valid_tickets
    for i in 1:length(rules)
        possible_rules[i] = [r for r in possible_rules[i] if checkrule2(t[i], rules[r])]
    end
end
possible_rules

# clean up this mess
length.(possible_rules)


# possible_rules[length.(possible_rules) .== 1]
found = []
final_rules = Vector{String}(undef, 20)

while any(length.(possible_rules) .> 0)
    idx = length.(possible_rules) .== 1
    @assert sum(idx) == 1
    push!(found, possible_rules[idx][1][1])

    final_rules[idx] = possible_rules[idx][1]

    possible_rules = [[r for r in rs if r ∉ found] for rs in possible_rules]
end
final_rules
startswith.(final_rules, "departure")

departure_indices = [4,7,14,15,16,19]
final_rules[departure_indices]
prod(myticket[departure_indices])
