using BenchmarkTools
using StaticArrays

data = reduce(hcat, collect.(eachline("17.txt")))
cells = [@SVector [i, j, 0] for i in 1:size(data)[1] for j in 1:size(data)[2] if data[i,j] == '#']

# testdata = reduce(hcat, collect.(split(".#.\n..#\n###")))
# cells = [[i, j, 0] for i in 1:size(testdata)[1] for j in 1:size(testdata)[2] if testdata[i,j] == '#']


#################################################################################
# Copied from a previous game of life implementation, then modified:
import StatsBase: countmap


function get_dim_neighbors(cell, dim)
    e = @SVector [i == dim ? 1 : 0 for i in 1:3]
    return [cell, cell .+ e, cell .- e]
end
function get_neighbors(cell)
    ndims = length(cell)
    neighbors = get_dim_neighbors(cell, 1)
    for i in 2:ndims
        neighbors = reduce(vcat, get_dim_neighbors.(neighbors, i))
    end
    filter!(!=(cell), neighbors)
    return neighbors
end


"""Count the occurrence of each neighbor
This is equivalent to counting the next living cells for each neighbor!
`StatsBase.countmap` does all the magic and counts occurrences of items in a collection.
"""
get_neighbor_counts(living_cells) =
    countmap(vcat(get_neighbors.(living_cells)...))


"""Compute the next population
The neighbor_counts include all potential living cells.
1. If a cell is not in there, it will not live!
2. If a cell has 3 neighbors, it lives!
3. If a cell has 2 neighbors and is alive, it survives!
"""
function next_population(current_population)
    neighbor_counts = get_neighbor_counts(current_population)

    return filter(neighbor_counts) do (k, v)
        v == 3 || (k in current_population && v == 2)
    end |> keys
end


function simulate(cells, N=6)
    living_cells = cells
    for i in 1:N
        living_cells = next_population(living_cells)
    end
    # @info "Done!" living_cells length(living_cells)
    return living_cells
end
out = simulate(cells)



# Part 2:
function get_dim_neighbors(cell, dim)
    e = @SVector [i == dim ? 1 : 0 for i in 1:4]
    return [cell, cell .+ e, cell .- e]
end
cells4d = [@SVector [i, j, 0, 0] for i in 1:size(data)[1] for j in 1:size(data)[2] if data[i,j] == '#']
@benchmark simulate(cells4d)
