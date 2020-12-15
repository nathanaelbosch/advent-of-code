

lines = readlines("12.txt")
ROTMAT_R = [0 1; -1 0]
ROTMAT_S = [0 -1; 1 0]

function part1(lines)
    position = [0,0]  # [East,North]
    facing = [1,0]

    # lines = ["F10", "N3", "F7", "R90", "F11"]

    for l in lines
        N = parse(Int, l[2:end])
        if startswith(l, "N")
            position[2] += N
        elseif startswith(l, "S")
            position[2] -= N
        elseif startswith(l, "E")
            position[1] += N
        elseif startswith(l, "W")
            position[1] -= N
        elseif startswith(l, "R")
            @assert N % 90 == 0
            facing = ROTMAT_R^(N ÷ 90) * facing
        elseif startswith(l, "L")
            @assert N % 90 == 0
            facing = ROTMAT_S^(N ÷ 90) * facing
        elseif startswith(l, "F")
            position += N*facing
        end
    end

    return sum(abs.(position))
end


function part2(lines)
    position = [0, 0]  # [East,North]
    waypoint = [10, 1]

    # lines = ["F10", "N3", "F7", "R90", "F11"]

    for l in lines
        N = parse(Int, l[2:end])
        if startswith(l, "N")
            waypoint[2] += N
        elseif startswith(l, "S")
            waypoint[2] -= N
        elseif startswith(l, "E")
            waypoint[1] += N
        elseif startswith(l, "W")
            waypoint[1] -= N
        elseif startswith(l, "R")
            @assert N % 90 == 0
            waypoint = ROTMAT_R^(N ÷ 90) * waypoint
        elseif startswith(l, "L")
            @assert N % 90 == 0
            waypoint = ROTMAT_S^(N ÷ 90) * waypoint
        elseif startswith(l, "F")
            position += N*waypoint
        end
    end

    return sum(abs.(position))
end
