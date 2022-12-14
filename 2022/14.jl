using OffsetArrays, Plots, ProfileView

example = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"""

# lines = split(example, "\n");
lines = readlines("14.txt");

const air = ' '
const rock = 'X'
const source = '+'
const sand_falling = 's'
const sand = 'S'
# const air = 0
# const rock = 1
# const source = 2
# const sand_falling = 3
# const sand = 4

getrangestepsign(from, to) = (from < to) ? 1 : -1

const CI = CartesianIndex
const source_loc = CartesianIndex(500, 0)

add_source!(M) = M[source_loc] = source
function add_paths!(M, paths)
    for path in paths
        xprev, yprev = path[1]
        M[xprev, yprev] = rock
        for (x, y) in path[2:end]
            M[xprev:getrangestepsign(xprev, x):x, yprev:getrangestepsign(yprev, y):y] .= 'X'
            xprev, yprev = x, y
        end
    end
    return M
end

function plotM(M)
    Mplot = parse.(Int, replace(
        OffsetArrays.no_offset_view(M),
        'X' => '0', ' ' => '9', '+' => '1', 's' => '2', 'S' => '3'
    ))
    Mplot = Mplot |> reverse |> permutedims
    heatmap(Mplot, aspect_ratio=:equal, legend=false, ticks=false, xaxis=false)
    plot!(size=10 .* size(M))
end

function step!(M, falling_sand_loc)
    loc = falling_sand_loc
    down = CI(0, 1)
    downright = CI(-1, 1)
    downleft = CI(1, 1)
    for newloc in (loc + down, loc + downright, loc + downleft)
        try
            if M[newloc] == air
                M[newloc] = sand_falling
                M[loc] = loc == source_loc ? source : air
                return false, newloc
            end
        catch BoundsError
            return true, newloc
        end
    end
    M[loc] = sand
    if loc == source_loc
        return true, loc
    end
    return false, source_loc
end

getpaths(lines) = map(l -> map(t -> parse.(Int, split(t, ",")), split(l, " -> ")), lines)

function getM(lines)
    paths = getpaths(lines)

    minx = minimum.(x -> x[1], paths) |> minimum
    maxx = maximum.(x -> x[1], paths) |> maximum
    miny = min(0, minimum.(x -> x[2], paths) |> minimum)
    maxy = maximum.(x -> x[2], paths) |> maximum

    M = OffsetArray(fill(air, maxx - minx + 1, maxy - miny + 1), minx:maxx, miny:maxy)
    add_source!(M)
    add_paths!(M, paths)
    return M
end

function simulate!(M)
    nsteps = 0
    loc = first_sand_loc = source_loc
    stop = false
    while !stop
        stop, loc = step!(M, loc)
        nsteps += 1
    end
    return M, nsteps
end
function part1(lines)
    M = getM(lines)
    M, nsteps = simulate!(M)
    return sum(M .== sand), nsteps
end
score, nsteps1 = part1(lines)

function makeanim(lines; nsteps, every_n=1000, part=1)
    M = part == 1 ? getM(lines) : getM2(lines)
    loc = source_loc
    anim = @animate for _ in 1:nsteps
        _, loc = step!(M, loc)
        plotM(M)
    end every every_n
    return anim
end
every1 = 500
anim1 = makeanim(lines; nsteps=nsteps1+30every1, every_n=every1)
gif(anim1, "14.gif", fps=60)

function getM2(lines)
    paths = getpaths(lines)
    miny = 0
    maxy = (maximum.(x -> x[2], paths) |> maximum) + 2
    minx = 500 - maxy
    maxx = 500 + maxy

    M = OffsetArray(fill(air, maxx - minx + 1, maxy - miny + 1), minx:maxx, miny:maxy)
    add_source!(M)
    add_paths!(M, paths)
    add_paths!(M, [[(minx, maxy), (maxx, maxy)]])
    return M
end
function part2(lines)
    M = getM2(lines)
    M, nsteps = simulate!(M)
    return sum(M .== sand), nsteps
end
score, nsteps2 = part2(lines)

every2 = 10_000
anim2 = makeanim(lines; nsteps=nsteps2+30*every2, every_n=every2, part=2)
gif(anim2, "14_2.gif", fps=30)
