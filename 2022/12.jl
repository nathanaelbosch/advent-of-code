#=
--- Day 12: Hill Climbing Algorithm ---

You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to the highest elevation, z.

Also included on the heightmap are marks for your current position (S) and the location that should get the best signal (E). Your current position (S) has elevation a, and the location that should get the best signal (E) has elevation z.

You'd like to reach E, but to save energy, you should do it in as few steps as possible. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be at most one higher than the elevation of your current square; that is, if your current elevation is m, you could step to elevation n, but not to elevation o. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)

For example:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi

Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the e at the bottom. From there, you can spiral around to the goal:

v..v<<<<
>v.vv<<^
.>vv>E^^
..v>>>^^
..>>>>>^

In the above diagram, the symbols indicate whether the path exits each square moving up (^), down (v), left (<), or right (>). The location that should get the best signal is still E, and . marks unvisited squares.

This path reaches the goal in 31 steps, the fewest possible.

What is the fewest steps required to move from your current position to the location that should get the best signal?
=#

example = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

function parse_input(input)
    lines = split(input, '\n')[begin:end-1]
    mat = hcat(collect.(lines)...) |> permutedims
    return mat
end
_mat = parse_input(example)
# _mat = parse_input(read("12.txt", String))
using Plots
mat = Int.(_mat)
heatmap(mat[end:-1:begin, :], aspect_ratio=:equal, legend=false, title="Example")

# Find the shortest path from start to goal using A* search
using DataStructures

function heuristic(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function neighbors(current, mat)
    x, y = current.I
    n = []
    if x > 1 && mat[x-1, y] <= mat[x, y] + 1
        push!(n, (x - 1, y))
    end
    if x < size(mat, 1) && mat[x+1, y] <= mat[x, y] + 1
        push!(n, (x + 1, y))
    end
    if y > 1 && mat[x, y-1] <= mat[x, y] + 1
        push!(n, (x, y - 1))
    end
    if y < size(mat, 2) && mat[x, y+1] <= mat[x, y] + 1
        push!(n, (x, y + 1))
    end
    return CartesianIndex.(n)
end

function astar(start, goal, mat)
    frontier = PriorityQueue()
    frontier[start] = 0
    came_from = Dict{CartesianIndex{2},Union{Nothing,CartesianIndex{2}}}()
    cost_so_far = Dict{CartesianIndex{2},Int64}()
    came_from[start] = nothing
    cost_so_far[start] = 0

    while !isempty(frontier)
        current = dequeue!(frontier)
        if current == goal
            break
        end
        for next in neighbors(current, mat)
            new_cost = cost_so_far[current] + 1
            if !haskey(cost_so_far, next) || new_cost < cost_so_far[next]
                cost_so_far[next] = new_cost
                priority = new_cost + heuristic(goal, next)
                frontier[next] = priority
                came_from[next] = current
            end
        end
    end
    return came_from, cost_so_far
end

function reconstruct_path(came_from, start, goal)
    current = goal
    path = [current]
    while current != start
        current = came_from[current]
        push!(path, current)
    end
    return reverse(path)
end

function shortest_path(start, goal, mat)
    came_from, cost_so_far = astar(start, goal, mat)
    return reconstruct_path(came_from, start, goal)
end

shortest_path_length(start, goal, mat) = length(shortest_path(start, goal, mat)) - 1

# Part 1
_mat = parse_input(read("12.txt", String))
# _mat = parse_input(example)
mat = Int.(_mat)
mat[_mat.=='S'.||_mat.=='E'] .= 123
start = findall(_mat .== 'S')[1]
goal = findall(_mat .== 'E')[1]
path = shortest_path(start, goal, mat)
steps = length(path) - 1
@info "Part 1: $steps steps"

function plot_path(mat, path)
    # plotmat = copy(mat)
    # plotmat[path] .= 123
    # heatmap(plotmat[end:-1:begin, :], aspect_ratio=:equal, legend=false, title="Part 1")

    pth = hcat(collect.(Tuple.(path))...)
    p = heatmap(mat[end:-1:begin, :], aspect_ratio=:equal, legend=false, ticks=false, xaxis=false)
    plot!(pth[2, :], size(mat, 1) .- pth[1, :] .+ 1, color=:blue)
    title!("Day 12")
    return p
end
plot_path(mat, path)

# Part 2: Find the location a that has the shortest path to E
# For this we will use a breadth-first search
function reverse_neighbors(current, mat)
    x, y = current.I
    n = []
    if x > 1 && mat[x-1, y] >= mat[x, y] - 1
        push!(n, (x - 1, y))
    end
    if x < size(mat, 1) && mat[x+1, y] >= mat[x, y] - 1
        push!(n, (x + 1, y))
    end
    if y > 1 && mat[x, y-1] >= mat[x, y] - 1
        push!(n, (x, y - 1))
    end
    if y < size(mat, 2) && mat[x, y+1] >= mat[x, y] - 1
        push!(n, (x, y + 1))
    end
    return CartesianIndex.(n)
end

function bfs(start, mat)
    frontier = Queue{CartesianIndex{2}}()
    frontier = enqueue!(frontier, start)
    came_from = Dict{CartesianIndex{2},Union{Nothing,CartesianIndex{2}}}()
    came_from[start] = nothing

    while !isempty(frontier)
        current = dequeue!(frontier)
        for next in reverse_neighbors(current, mat)
            if !haskey(came_from, next)
                frontier = enqueue!(frontier, next)
                came_from[next] = current
            end
        end
    end
    return came_from
end

came_from = bfs(goal, mat)
as = findall(_mat .== 'a')
reachable_as = as[map(a -> haskey(came_from, a), as)]
score = map(a -> length(reconstruct_path(came_from, goal, a)) - 1, reachable_as) |> minimum
@info "Part 2: $score steps"

# visualize the path
min_a = reachable_as[argmin(map(a -> length(reconstruct_path(came_from, goal, a)) - 1, reachable_as))]
path = reconstruct_path(came_from, goal, min_a)
plot_path(mat, path)

# visualize the a locations
p0 = heatmap(mat[end:-1:begin, :], aspect_ratio=:equal, legend=false, ticks=false, xaxis=false)
plotmat = copy(mat)
plotmat[_mat.=='a'] .= maximum(mat)
p1 = heatmap(plotmat[end:-1:begin, :], aspect_ratio=:equal, legend=false, title="'a' locations", ticks=false, xaxis=false)
plotmat = copy(mat)
plotmat[reachable_as] .= maximum(mat)
p2 = heatmap(plotmat[end:-1:begin, :], aspect_ratio=:equal, legend=false, title="reachable 'a' locations", ticks=false, xaxis=false)
plot(p0, p1, p2, layout=(3, 1), size=(600, 800))
