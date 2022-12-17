const WIDTH = 7
const MAXHEIGHT = 80
function make_chamber()
    chamber = Matrix{Char}(undef, MAXHEIGHT, WIDTH + 2)
    chamber .= ' '
    chamber[begin:end, begin] .= '|'
    chamber[begin:end, end] .= '|'
    chamber[begin, begin:end] .= '-'
    chamber[begin, begin] = '+'
    chamber[begin, end] = '+'
    return chamber
end
get_border(chamber) = chamber .== '|'
get_floor(chamber) = chamber .== '-'
get_rock(chamber) = chamber .== '#'

abstract type Rocks end
"""
####
"""
struct HLine <: Rocks end

"""
.#.
###
.#.
"""
struct Plus <: Rocks end

"""
..#
..#
###
"""
struct Angle <: Rocks end

"""
#
#
#
#
"""
struct VLine <: Rocks end

"""
##
##
"""
struct Block <: Rocks end

rockchoice = Dict(
    1 => HLine(),
    2 => Plus(),
    3 => Angle(),
    4 => VLine(),
    5 => Block(),
)

add_rock!(chamber, ::HLine, spawn_row, spawn_col) =
    chamber[spawn_row, spawn_col:spawn_col+3] .= '@'

add_rock!(chamber, ::Plus, spawn_row, spawn_col) = begin
    chamber[spawn_row+1, spawn_col:spawn_col+2] .= '@'
    chamber[spawn_row, spawn_col+1] = '@'
    chamber[spawn_row+2, spawn_col+1] = '@'
end
add_rock!(chamber, ::Angle, spawn_row, spawn_col) = begin
    chamber[spawn_row, spawn_col:spawn_col+2] .= '@'
    chamber[spawn_row:spawn_row+2, spawn_col+2] .= '@'
end
add_rock!(chamber, ::VLine, spawn_row, spawn_col) =
    chamber[spawn_row:spawn_row+3, spawn_col] .= '@'
add_rock!(chamber, ::Block, spawn_row, spawn_col) = begin
    chamber[spawn_row, spawn_col:spawn_col+1] .= '@'
    chamber[spawn_row+1, spawn_col:spawn_col+1] .= '@'
end

function add_new_rock!(chamber, r)
    highest_row = findlast(r -> '#' in r, eachrow(chamber))
    if isnothing(highest_row)
        highest_row = 1
    end
    spawn_row = highest_row + 4
    spawn_col = 4

    rock = rockchoice[(r%5)+1]
    add_rock!(chamber, rock, spawn_row, spawn_col)
    return chamber
end


function apply_input!(chamber, input::Char)
    falling_rock = chamber .== '@'
    non_space = get_rock(chamber) .| get_border(chamber)
    if input == '>'
        would_collide = any(
            (@view falling_rock[:, begin:end-1]) .&& (@view non_space[:, begin+1:end])
        )
        if would_collide
            return chamber
        else
            chamber[falling_rock] .= ' '
            (@view chamber[:, begin+1:end])[falling_rock[:, begin:end-1]] .= '@'
            return chamber
        end
    elseif input == '<'
        would_collide = any(
            (@view falling_rock[:, begin+1:end]) .&& (@view non_space[:, begin:end-1])
        )
        if would_collide
            return chamber
        else
            chamber[falling_rock] .= ' '
            (@view chamber[:, begin:end-1])[falling_rock[:, begin+1:end]] .= '@'
            return chamber
        end
    end
end

function rock_fall!(chamber)
    falling_rock = chamber .== '@'
    non_space = (chamber .== '#') .| get_floor(chamber)
    would_collide = any(
        (@view falling_rock[begin+1:end, :]) .&& (@view non_space[begin:end-1, :])
    )
    if would_collide
        return chamber, true
    else
        chamber[falling_rock] .= ' '
        (@view chamber[begin:end-1, :])[falling_rock[begin+1:end, :]] .= '@'
        return chamber, false
    end
end

function game_loop(chamber, input; until_rock=2022)
    add_new_rock!(chamber, 0)
    rock_number = 1
    done = false
    while !done
        for c in input
            apply_input!(chamber, c)
            _, stopped = rock_fall!(chamber)
            if stopped
                chamber[chamber.=='@'] .= '#'
                try
                    add_new_rock!(chamber, rock_number)
                catch BoundsError
                    chamber = resize_chamber(chamber)
                    add_new_rock!(chamber, rock_number)
                end
                if rock_number % 1000 == 0
                    @info "Rock $rock_number"
                end
                rock_number += 1
            end
            if rock_number > until_rock
                done = true
                break
            end
        end
    end
    return chamber
end

"""
The rocks make a new floor, so there os a lot we can just forget now!
"""
function resize_chamber(chamber)
    new_chamber = make_chamber()
    max_forgettable_row = [findlast(r -> '#' in r, c) for c in eachcol(chamber)][begin+1:end-1] |> minimum
    height = size(chamber)[1] - max_forgettable_row + 1
    new_chamber[begin+1:height+1, begin+1:end-1] .= chamber[max_forgettable_row:end, begin+1:end-1]
    return new_chamber
end


testinput = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
chamber = make_chamber()
game_loop(chamber, testinput)

getheight(chamber) = findlast(r -> '#' in r, eachrow(chamber)) - 1
getheight(chamber)

# Part 1
input = readlines("17.txt")[1]
chamber = make_chamber()
game_loop(chamber, input)
score = getheight(chamber)
@info "Part 1" score

# Part 2
chamber = make_chamber()
game_loop(chamber, testinput; until_rock=1000000000000)
score = getheight(chamber)
@info "Part 2" score
