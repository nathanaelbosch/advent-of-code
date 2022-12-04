example_input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""
data = split(example_input)
data = readlines("4.txt")

using Intervals
intervals = [[Interval(parse.(Int, split(a, "-"))...) for a in p] for p in split.(data, ",")]

sets_contain_each_other((a, b)) = a == b || a ⊆ b || b ⊆ a
score = sets_contain_each_other.(intervals) |> sum
@info "Part 1: $score"

sets_overlap((a, b)) = !isempty(a ∩ b)
score = sets_overlap.(intervals) |> sum
@info "Part 2: $score"
