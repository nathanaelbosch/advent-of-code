lines = readlines("8.txt")

function parseline(line)
    op, argstr = split(line)
    arg = parse(Int, argstr)
    return op, arg
end
getarg(line) = parse(Int, split(line)[2])

function part1(lines)
    accumulator = 0
    i = 1
    visited = repeat([false], length(lines))
    loop = false
    while true
        if i == length(lines)+1
            loop = false
            break
        end
        if visited[i]
            loop = true
            break
        end
        visited[i] = true
        line = lines[i]

        if startswith(line, "nop")
            i += 1
        elseif startswith(line, "jmp")
            i += getarg(line)
        elseif startswith(line, "acc")
            accumulator += getarg(line)
            i += 1
        end
    end
    return loop, accumulator
end
@btime part1(lines)


function part2(lines)
    for i in 1:length(lines)
        line = lines[i]
        if startswith(line, "acc")
            continue
        elseif startswith(line, "jmp")
            modline = replace(line, "jmp" => "nop")
        elseif startswith(line, "nop")
            modline = replace(line, "nop" => "jmp")
        end

        lines[i] = modline
        loop, acc = part1(lines)
        if !loop
            return acc
        end
        lines[i] = line
    end
end
part2(lines)


@btime part2(lines)
