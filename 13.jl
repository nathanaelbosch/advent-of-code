lines = readlines("13.txt")
earliest_timestamp = parse(Int, lines[1])
ids = split(lines[2], ",")

earliest_timestamp = 939
ids = ["7", "13", "x", "x", "59", "31", "19"]

# Part 1
function part1(earliest_timestamp, ids)
    ids_servicing = parse.(Int, filter(!=("x"), ids))
    waittimes = ids_servicing - earliest_timestamp .% ids_servicing
    return minimum(waittimes) * ids_servicing[argmin(waittimes)]
end
part1(earliest_timestamp, ids)

# Part 2
function part2(ids)
    offset, id = collect.(zip([(i-1, parse(Int, id)) for (i, id) in enumerate(ids) if id != "x"]...))

    step = 1
    k = 0
    tocheck = 2

    while true
        k += step
        t = k * id[1]
        if (t + offset[tocheck]) % id[tocheck] == 0
            step = lcm(id[1:tocheck])
            tocheck += 1
        end
        if tocheck > length(id)
            break
        end
    end
    return k*id[1]
end
