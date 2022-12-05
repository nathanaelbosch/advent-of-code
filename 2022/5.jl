input = read("5.txt", String)
crates, instructions = split(input, "\n\n")
_mat = hcat(collect.(split(crates, "\n"))...)
crate_mat = _mat[2:4:end, end-1:-1:begin]
crate_mat[1, :]
stacks = [[i for i in s if i != ' ']
          for s in eachrow(crate_mat)]

function move!(stacks, from, to)
    push!(stacks[to], pop!(stacks[from]))
end
instructions = split(instructions, "\n")[1:end-1]

"""
    parse_instruction(instruction::String)

Parse the instruction
Example:
parse_instruction("move 7 from 6 to 8")
should return
(7, 6, 8)
"""
function parse_instruction(instruction::AbstractString)
    m = match(r"move (\d+) from (\d+) to (\d+)", instruction)
    return parse.(Int, m.captures)
end
part1stacks = deepcopy(stacks)
for inst in instructions
    n, from, to = parse_instruction(inst)
    for _ in 1:n
        move!(part1stacks, from, to)
    end
end
get_top_crates(stacks) = [s[end] for s in stacks]
result = get_top_crates(part1stacks) |> join
@info "Part 1" result



function move_multiple_at_once!(stacks, from, to, n)
    # get the top n crates from the from stack:
    crates = [pop!(stacks[from]) for _ in 1:n]
    append!(stacks[to], reverse(crates))
end

part2stacks = deepcopy(stacks)
for inst in instructions
    n, from, to = parse_instruction(inst)
    move_multiple_at_once!(part2stacks, from, to, n)
end
result = get_top_crates(part2stacks) |> join
@info "Part 2" result
