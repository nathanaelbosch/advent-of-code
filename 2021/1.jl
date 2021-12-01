test_lines = [
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
]
lines = parse.(Int, readlines("1.txt"))

function part1(lines)
    last_line = lines[1]
    counter = 0
    for i in 2:length(lines)
        l = lines[i]
        if l > last_line
            counter += 1
        end
        last_line = l
    end
    return counter
end
part1(lines)

part2(lines) = part1(lines[1:end-2] + lines[2:end-1] + lines[3:end])
part2(lines)
