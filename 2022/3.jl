# test_input = """
# vJrwpWtwJgWrhcsFMMfFFhFp
# jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
# PmmdzqPrVvPwwTWBwg
# wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
# ttgJtRGJQctTZtZT
# CrZsJsPPZsGzwwsLwLmpwMDw
# """
# data = split(test_input)
data = readlines("3.txt")
rucksacks = map(d -> [d[1:length(d)÷2], d[length(d)÷2+1:end]], data)
in_both = map(d -> intersect(d[1], d[2]), rucksacks)

item_to_priority(i::Char) = if i in 'A':'Z' i - 'A' + 27 else i - 'a' + 1 end
score = map(b -> sum(item_to_priority.(b)), in_both) |> sum
@info "Exercise 1" score


########################################################################################
# Part 2
########################################################################################
groups = reshape(data, 3, :) |> eachcol |> collect
in_all = map(d -> intersect(d[1], d[2], d[3]), groups)
score = map(b -> sum(item_to_priority.(b)), in_all) |> sum
@info "Exercise 2" score
