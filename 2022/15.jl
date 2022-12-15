using Plots, OffsetArrays, ProgressBars, Polyester

example = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"""

beacon_y = 10

function parse_line(line)
    m = match(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)", line)
    x, y, bx, by = parse.(Int, m.captures)
    return (x=x, y=y), (x=bx, y=by)
end

function parse_input(lines)
    parsed_lines = []
    for line in lines
        sensor, beacon = parse_line(line)
        push!(parsed_lines, (sensor=sensor, beacon=beacon))
    end
    return parsed_lines
end

function find_border_coordinates(parsed_lines)
    min_x = min(
        minimum([line.sensor.x for line in parsed_lines]),
        minimum([line.beacon.x for line in parsed_lines]),
    )
    max_x = max(
        maximum([line.sensor.x for line in parsed_lines]),
        maximum([line.beacon.x for line in parsed_lines]),
    )
    min_y = min(
        minimum([line.sensor.y for line in parsed_lines]),
        minimum([line.beacon.y for line in parsed_lines]),
    )
    max_y = max(
        maximum([line.sensor.y for line in parsed_lines]),
        maximum([line.beacon.y for line in parsed_lines]),
    )
    return min_x, max_x, min_y, max_y
end

dist(x1, y1, x2, y2) = abs(x1 - x2) + abs(y1 - y2)

function part1(lines; beacon_y)
    parsed_lines = parse_input(lines)
    min_x, max_x, min_y, max_y = find_border_coordinates(parsed_lines)
    # min_x, max_x = -10000, 10000

    xs = OffsetArray{Bool}(undef, 2min_x:2max_x)
    xs .= false
    for x in ProgressBar(eachindex(xs))
            for (sensor, beacon) in parsed_lines
            sb_dist = dist(sensor.x, sensor.y, beacon.x, beacon.y)
            x_dist = dist(sensor.x, sensor.y, x, beacon_y)

            if x_dist <= sb_dist
                xs[x] = true
                break
            end
        end
    end

    score = xs |> sum

    beacons = unique([b for (s, b) in parsed_lines])
    for beacon in beacons
        if beacon.y == beacon_y
            score -= 1
        end
    end

    return score
end
# lines = split(example, "\n");
# solve(lines; beacon_y=10);
lines = readlines("15.txt");
score = part1(lines, beacon_y = 2_000_000);

const NT{T} = NamedTuple{(:x, :y), Tuple{T, T}}
"""
    get_border(sensor::Tuple{Int,Int}, beacon::Tuple{Int,Int})

Compute the coordinates of locations that have a distance one larger than the distance between the sensor and the beacon.
"""
function get_border(sensor::NT{T}, beacon::NT{T}) where T
    sx, sy = sensor
    bx, by = beacon
    d = dist(sx, sy, bx, by)

    # start at the top, and go clockwise
    locs = Tuple{T,T}[]
    sizehint!(locs, 4d)

    for i in 1:d
        loc = (sx + i, sy + d + i - 1)
        push!(locs, loc)
    end
    for i in 1:d
        loc = (sx + d - i + 1, sy - i)
        push!(locs, loc)
    end
    for i in 1:d
        loc = (sx - i, sy - d + i - 1)
        push!(locs, loc)
    end
    for i in 1:d
        loc = (sx - d + i - 1, sy + i)
        push!(locs, loc)
    end
    return locs
end
get_border(line) = get_border(line...)

function part2(lines; min=0, max=4000000)
    parsed_lines = parse_input(lines)

    found = false
    Nlines = length(parsed_lines)
    local beacon_loc
    for i in eachindex(parsed_lines)
        @info "Line $(i)/$(Nlines)"
        (sensor, beacon) = parsed_lines[end-i]
        for loc in ProgressBar(get_border(sensor, beacon))
            x, y = loc
            if x < min || x > max || y < min || y > max
                continue
            end

            covered = false
            for (sensor2, beacon2) in parsed_lines
                if sensor2 == sensor
                    continue
                end
                d = dist(sensor2.x, sensor2.y, beacon2.x, beacon2.y)
                dx = dist(sensor2.x, sensor2.y, x, y)
                if dx <= d
                    covered = true
                    break
                end
            end

            if !covered
                @info "Found the beacon!" loc
                found = true
                beacon_loc = loc
                break
            end
        end

        if found
            break
        end
    end

    return beacon_loc[1] * 4000000 + beacon_loc[2]
end
part2(split(example, "\n"); min=0, max=20);
part2(readlines("15.txt"));
