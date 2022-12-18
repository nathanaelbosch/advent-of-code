#=
--- Day 18: Boiling Boulders ---

You and the elephants finally reach fresh air. You've emerged near the base of a large volcano that seems to be actively erupting! Fortunately, the lava seems to be flowing away from you and toward the ocean.

Bits of lava are still being ejected toward you, so you're sheltering in the cavern exit a little longer. Outside the cave, you can see the lava landing in a pond and hear it loudly hissing as it solidifies.

Depending on the specific compounds in the lava and speed at which it cools, it might be forming obsidian! The cooling rate should be based on the surface area of the lava droplets, so you take a quick scan of a droplet as it flies past you (your puzzle input).

Because of how quickly the lava is moving, the scan isn't very good; its resolution is quite low and, as a result, it approximates the shape of the lava droplet with 1x1x1 cubes on a 3D grid, each given as its x,y,z position.

To approximate the surface area, count the number of sides of each cube that are not immediately connected to another cube. So, if your scan were only two adjacent cubes like 1,1,1 and 2,1,1, each cube would have a single side covered and five sides exposed, a total surface area of 10 sides.

Here's a larger example:

2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5

In the above example, after counting up all the sides that aren't connected to another cube, the total surface area is 64.

What is the surface area of your scanned lava droplet?
=#

example = """
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"""
lines = split(example, "\n")
lines = readlines("18.txt")
droplets = map(l -> parse.(Int, split(l, ",")), lines)

get_neighbors(x, y, z) = [
    [x - 1, y, z],
    [x + 1, y, z],
    [x, y - 1, z],
    [x, y + 1, z],
    [x, y, z - 1],
    [x, y, z + 1],
]
get_neighbors(cube) = get_neighbors(cube...)

count_surfaces(droplet, droplets) = [!(n in droplets) for n in get_neighbors(droplet)] |> sum

score = count_surfaces.(droplets, Ref(droplets)) |> sum
@info "Part 1" score


#=
--- Part Two ---

Something seems off about your calculation. The cooling rate depends on exterior surface area, but your calculation also included the surface area of air pockets trapped in the lava droplet.

Instead, consider only cube sides that could be reached by the water and steam as the lava droplet tumbles into the pond. The steam will expand to reach as much as possible, completely displacing any air on the outside of the lava droplet but never expanding diagonally.

In the larger example above, exactly one cube of air is trapped within the lava droplet (at 2,2,5), so the exterior surface area of the lava droplet is 58.

What is the exterior surface area of your scanned lava droplet?
=#

using OffsetArrays

const UNKNOWN = 0
const LAVA = 1
const OUTSIDE = 2
const INSIDE = 3

function make_mat(droplets)

    # Initialize an OffsetArray to then fill with integers
    xs, ys, zs = eachrow(reduce(hcat, droplets)) |> collect
    x_min, x_max = minimum(xs), maximum(xs)
    y_min, y_max = minimum(ys), maximum(ys)
    z_min, z_max = minimum(zs), maximum(zs)

    mat = OffsetArray{Int}(undef, x_min:x_max, y_min:y_max, z_min:z_max)

    mat .= UNKNOWN

    mat[begin, :, :] .= OUTSIDE
    mat[end, :, :] .= OUTSIDE
    mat[:, begin, :] .= OUTSIDE
    mat[:, end, :] .= OUTSIDE
    mat[:, :, begin] .= OUTSIDE
    mat[:, :, end] .= OUTSIDE

    for droplet in droplets
        mat[droplet...] = LAVA
    end

    return mat
end

function do_one_sweep!(mat)
    x_min, y_min, z_min = first.(axes(mat))
    x_max, y_max, z_max = last.(axes(mat))

    for x in x_min+1:x_max-1, y in y_min+1:y_max-1, z in z_min+1:z_max-1
        if mat[x, y, z] == UNKNOWN
            # if any neighbor is OUTSIDE then this is OUTSIDE
            if any(mat[a, b, c] == OUTSIDE for (a, b, c) in get_neighbors(x, y, z))
                mat[x, y, z] = OUTSIDE
            end
        end
    end
    return mat
end
count_unknown(mat) = count(mat .== UNKNOWN)

function mark_inside!(mat)
    c = 0
    while c != count_unknown(mat)
        c = count_unknown(mat)
        do_one_sweep!(mat)
    end
    mat[mat.==UNKNOWN] .= INSIDE
    return mat
end

function check_outside(mat, x, y, z)
    if x in axes(mat, 1) && y in axes(mat, 2) && z in axes(mat, 3)
        return mat[x, y, z] == OUTSIDE
    else
        return true
    end
end

function count_surfaces2(droplet, mat)
    @assert mat[droplet...] == LAVA
    neighbors = get_neighbors(droplet)
    return [check_outside(mat, n...) for n in neighbors] |> sum
end

function part2(droplets)
    mat = make_mat(droplets)
    mat = mark_inside!(mat)
    return count_surfaces2.(droplets, Ref(mat)) |> sum
end

part2(droplets)
