using Plots

# lines = readlines("20test.txt"); SIZE = 3
lines = readlines("20.txt"); SIZE = 12
_tileids = parse.(Int, map(l -> split(strip(l, ':'), " ")[2], lines[1:12:end]))
_tiles = [hcat(collect.(lines[i:i+9])...) for i in 2:12:length(lines)]
borders(tile) = [
    tile[1, :],
    tile[:, end],
    reverse(tile[end, :]),
    reverse(tile[:, 1]),
]  # top right bottom left
flip(tile) = reverse(tile, dims=1)
allborders(tile) = reduce(vcat, (borders(tile), borders(flip(tile))))
@assert Set(allborders(rotr90(_tiles[1]))) == Set(allborders(_tiles[1])) == Set(allborders(rot180(_tiles[1]))) == Set(allborders(rotl90(_tiles[1])))



struct Tile
    id
    tile
    borders
end
Tile(id, tile) = Tile(id, tile, allborders(tile))
borders(tile::Tile) = borders(tile.tile)
tiles = Tile.(_tileids, _tiles)

tile = tiles[1]
get_nneighbors(tile, tiles) =
    sum([sum([b in t.borders for t in tiles])-1 for b in tile.borders]) ÷ 2

nneighbors = get_nneighbors.(tiles, Ref(tiles))
@assert sum(nneighbors.==2) == 4
@assert length(tiles) == SIZE*SIZE
@assert sum(nneighbors.==2) == 4
@assert sum(nneighbors.==3) == 4*(SIZE-2)

part1 = prod([t.id for t in tiles[nneighbors.==2]])




#########
# part2
# Step 1: For each tile, find it's neighbors (IDs!)
# Step 2: Assemble
# Start with some corner tile
# Look at the neighbors
# Put the tile such that it is in the top left
# Rotate such that the neighbors are right and down
# Go through everything line by line, left to right
# Fill some big matrix


# Get one of the corners to start with
get_neighbor_ids(tile, tiles) =
    tile.id => Set([t.id for b in tile.borders for t in tiles if t.id != tile.id && b in t.borders])
tiledict = Dict([t.id => t for t in tiles])
neighbor_ids = Dict(get_neighbor_ids.(tiles, Ref(tiles)))
startid = [k for (k, v) in neighbor_ids if length(v)==2][1]

# Canvas
canvas = Matrix{Char}(undef, 8*SIZE, 8*SIZE)
canvas .= ' '
function fill_in!(canvas, tile, loc)
    i, j = loc
    canvas[(i-1)*8+1:8i, (j-1)*8+1:8j] .= tile.tile[2:end-1, 2:end-1]
end

# Find the correct orientation of the start tile
function correct_start_orientation!(startid, tiledict, neighbor_ids)
    neighbors = neighbor_ids[startid]
    neighbors_per_border = [sum([b in tiledict[n].borders for n in neighbors]) for b in borders(tiledict[startid])]
    while neighbors_per_border != [0,1,1,0]
        tiledict[startid] = Tile(startid, rotr90(tiledict[startid].tile))
        neighbors_per_border = [sum([b in tiledict[n].borders for n in neighbors]) for b in borders(tiledict[startid])]
    end
end
correct_start_orientation!(startid, tiledict, neighbor_ids)
# fill_in!(canvas, tiledict[startid], (1,1))


# Find the neighbors at each side
# Right neighbor:
function find_neighbor(id, tiledict, neighbor_ids, side)
    # side == 2 => right; side == 3 => bottom
    neighbors = neighbor_ids[id]
    directional_border = borders(tiledict[id])[side]
    directional_neighbor = [n for n in neighbors if directional_border in tiledict[n].borders]
    @assert length(directional_neighbor) == 1
    nid = directional_neighbor[1]
    return nid
end
rnid = find_neighbor(startid, tiledict, neighbor_ids, 2)
function orient_neighbor!(initial_id, neighbor_id, tiledict, side)
    # side == 2 => right; side == 3 => bottom
    iid = initial_id
    nid = neighbor_id
    directional_border = borders(tiledict[iid])[side]
    # Need to flip?
    if !(reverse(directional_border) in borders(tiledict[nid]))
        tiledict[nid] = Tile(nid, flip(tiledict[nid].tile))
    end
    # Rotations?
    opposite_side = ((side+1)%4)+1
    nborder = borders(tiledict[nid])[opposite_side]
    while reverse(directional_border) != nborder
        tiledict[nid] = Tile(nid, rotr90(tiledict[nid].tile))
        nborder = borders(tiledict[nid])[opposite_side]
    end
    @assert reverse(borders(tiledict[iid])[side]) == borders(tiledict[nid])[opposite_side]
end
orient_neighbor!(startid, rnid, tiledict, 2)


canvas = Matrix{Char}(undef, 8*SIZE, 8*SIZE)
canvas .= ' '
col_id = startid
for j in 1:SIZE
    @info "filling id" col_id
    fill_in!(canvas, tiledict[col_id], (j, 1))
    row_id = col_id
    for i in 1:(SIZE-1)
        fill_in!(canvas, tiledict[col_id], (j, 1))
        next_id = find_neighbor(row_id, tiledict, neighbor_ids, 2)
        orient_neighbor!(row_id, next_id, tiledict, 2)
        fill_in!(canvas, tiledict[next_id], (j, i+1))
        row_id = next_id
    end
    if j < SIZE
        next_id = find_neighbor(col_id, tiledict, neighbor_ids, 3)
        orient_neighbor!(col_id, next_id, tiledict, 3)
        col_id = next_id
    end
end
# WE BUILT THE FULL IMAGE!
canvas
heatmap(canvas .== '#')


seamonster = permutedims(reduce(hcat, collect.(split("                  # \n#    ##    ##    ###\n #  #  #  #  #  #   ", "\n"))))

mymatch(cc, mc) = mc == ' ' ? true : mc == cc
function count_monsters(canvas, seamonster)
    msize = size(seamonster)
    csize = size(canvas)
    nmonsters = 0
    for i in 1:csize[1]-msize[1], j in 1:csize[2]-msize[2]
        nmonsters += all(mymatch.(canvas[i:i+msize[1]-1, j:j+msize[2]-1], seamonster))
    end
    return nmonsters
end

monstercount = 0
for i in 1:2
    for i in 1:4
        monstercount += count_monsters(canvas, seamonster)
        canvas = rotr90(canvas)
    end
    canvas = flip(canvas)
end
monstercount

part2 = sum(canvas .== '#') - monstercount * sum(seamonster .== '#')
