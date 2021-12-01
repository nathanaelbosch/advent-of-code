data = reduce(hcat, collect.(eachline("3.txt")))
data = Char.(Int.(data)')

function check_slope(data, slope)
    A, B = size(data)
    trees_encountered = 0
    pos = CartesianIndex(1, 1)
    slope = CartesianIndex(slope...)
    while pos[1] <= A
        if pos[2] > B
            pos = CartesianIndex(pos[1], pos[2] % B)
        end
        trees_encountered += data[pos] == '#'
        pos += slope
    end
    return trees_encountered
end


# Part 1:
@btime check_slope(data, (1, 3))

# Part 2:
@btime prod(check_slope.(Ref(data), [(1,1), (1,3), (1,5), (1,7), (2,1)]))
