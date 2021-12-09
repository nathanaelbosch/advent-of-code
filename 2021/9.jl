using BenchmarkTools, Images

input = split("""2199943210
3987894921
9856789892
8767896789
9899965678""", "\n")
input = readlines("9.txt")
heightmat = parse.(Int, hcat(collect.(input)...))

function get_minima(heightmat)
    padded_heightmat = padarray(heightmat, Fill(9, (1, 1)))
    minima = ((padded_heightmat[1:end-1, 1:end-1] .< padded_heightmat[0:end-2, 1:end-1])
              .&& (padded_heightmat[1:end-1, 1:end-1] .< padded_heightmat[2:end, 1:end-1])
              .&& (padded_heightmat[1:end-1, 1:end-1] .< padded_heightmat[1:end-1, 0:end-2])
              .&& (padded_heightmat[1:end-1, 1:end-1] .< padded_heightmat[1:end-1, 2:end]))
    return minima
end
function ex1(heightmat)
    minima = get_minima(heightmat)
    return sum(heightmat[minima] .+ 1)
end
@btime ex1(heightmat)

D1, D2 = size(heightmat)

function get_neighbors(loc)
    neighbors = [loc]
    (loc[1] != 1) && push!(neighbors, loc .+ (-1,0))
    (loc[1] != D1) && push!(neighbors, loc .+ (1,0))
    (loc[2] != 1) && push!(neighbors, loc .+ (0,-1))
    (loc[2] != D2) && push!(neighbors, loc .+ (0,1))
    return neighbors
end
function count_basin(heightmat, loc)
    new = Set([loc])
    counted = Set([loc])

    while !isempty(new)
        tocount = Set(vcat([get_neighbors(l) for l in new]...))
        notnine = [l for l in tocount if heightmat[l...] != 9]
        new = setdiff(notnine, counted)
        counted = union(counted, notnine)
    end
    return length(counted)
end

function ex2(heightmat)
    minima = get_minima(heightmat)

    basin_sizes = Int[]
    for i in 1:D1, j in 1:D2
        (minima[i,j] != 1) && continue
        basin_size = count_basin(heightmat, (i,j))
        push!(basin_sizes, basin_size)
    end

    output = 1
    for i in 1:3
        maxsize, idx = findmax(basin_sizes)
        output *= maxsize
        deleteat!(basin_sizes, idx)
    end
    return output
end
@btime ex2(heightmat)
