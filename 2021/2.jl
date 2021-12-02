lines = [
    "forward 5"
    "down 5"
    "forward 8"
    "up 3"
    "down 8"
    "forward 2"
]
lines = readlines("2.txt")
parse_line(l) = begin
    direction, distance = split(l)
    return direction, parse(Int, distance)
end
function ex1(lines)
    l2vec(l) = begin
        dir, dist = l
        if dir=="forward"
            return [dist, 0]
        elseif dir=="down"
            return [0, dist]
        elseif dir=="up"
            return [0, -dist]
        end
    end
    return prod(sum(map(l2vec ∘ parse_line, lines)))
end
ex1(lines)

function ex2(lines)
    horizontal_position = depth = aim = 0
    for (command, x) in parse_line.(lines)
        if command == "down"
            aim += x
        elseif command == "up"
            aim -= x
        elseif command == "forward"
            horizontal_position += x
            depth += aim * x
        end
    end
    return horizontal_position * depth
end
ex2(lines)
