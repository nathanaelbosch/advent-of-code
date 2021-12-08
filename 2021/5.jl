input = split("""0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2""", "\n")
input = eachline("5.txt")

f(l) = map(i -> parse.(Int, i) .+ 1, split.(split(l, " -> "), ","))
vents = f.(input)

function map_horizontal_vents!(mat, vents)
    for ((x1, y1), (x2, y2)) in vents
        if x1 != x2 && y1 != y2
            continue
        end
        mat[min(x1,x2):max(x1,x2), min(y1,y2):max(y1,y2)] .+= 1
    end
end

function ex1(vents)
    m = maximum(vcat(map(i -> vcat(i...), vents)...))
    mat = zeros(Int, m, m)
    map_horizontal_vents!(mat, vents)
    return sum(mat .>= 2)
end
ex1(vents)

function map_diagonal_vents!(mat, vents)
    for ((x1, y1), (x2, y2)) in vents
        if x1 != x2 && y1 != y2
            submat = @view mat[x1:(x1>x2 ? -1 : 1):x2, y1:(y1>y2 ? -1 : 1):y2]
            submat[diagind(submat)] .+= 1
        end
    end
end

function ex2(vents)
    m = maximum(vcat(map(i -> vcat(i...), vents)...))
    mat = zeros(Int, m, m)
    map_horizontal_vents!(mat, vents)
    map_diagonal_vents!(mat, vents)
    return sum(mat .>= 2)
end
ex2(vents)
