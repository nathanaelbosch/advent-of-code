data = reduce(hcat, collect.(eachline("11.txt")))
data = Char.(Int.(data)')
M, N = size(data)

function get_neighbors(i, j)
    neighbors = [
        (i-1, j-1)
        (i-1, j)
        (i-1, j+1)
        (i, j-1)
        (i, j+1)
        (i+1, j-1)
        (i+1, j)
        (i+1, j+1)
    ]
    filter!(n -> !(0 ∈ n || n[1] > M || n[2] > N), neighbors)
    return neighbors
end


isfree(data, loc) = data[loc...] == 'L'
isoccupied(data, loc) = data[loc...] == '#'


function getnextseating(data)
    next_seating = copy(data)
    change = false
    for i=1:M, j=1:N
        loc = (i, j)
        neighbors = get_neighbors(i, j)
        if isfree(data, loc) && !any(isoccupied.(Ref(data), neighbors))
            next_seating[i, j] = '#'
            change = true
        elseif isoccupied(data, loc) && sum(isoccupied.(Ref(data), neighbors))>=4
            next_seating[i, j] = 'L'
            change = true
        end
    end
    return next_seating, change
end

function part1(data)
    change = true
    while change
        data, change = getnextseating(data)
    end
    return sum(data .== '#')
end



# Part 2



function count_visible_occupied(data, loc::Tuple{Int,Int})
    M, N = size(data)
    directions = [
        (-1,-1)
        (-1,0)
        (-1,1)
        (0,-1)
        (0,1)
        (1,-1)
        (1,0)
        (1,1)
    ]
    occupied = 0
    for d in directions
        n = loc .+ d
        while all((1,1) .<= n .<= (M,N))
            if data[n...] == '#'
                occupied += 1
                break
            elseif data[n...] == 'L'
                break
            end
            n = n .+ d
        end
    end
    return occupied
end

function getnextseating2(data)
    next_seating = copy(data)
    change = false
    for i=1:M, j=1:N
        loc = (i, j)
        if data[loc...] == '.'
            continue
        end

        occ = count_visible_occupied(data, loc)
        if isfree(data, loc) && occ == 0
            next_seating[i, j] = '#'
            change = true
        elseif isoccupied(data, loc) && occ >= 5
            next_seating[i, j] = 'L'
            change = true
        end
    end
    return next_seating, change
end

function part2(data)
    change = true
    while change
        data, change = getnextseating2(data)
    end
    return sum(data .== '#')
end
