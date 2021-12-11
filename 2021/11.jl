input = split("""5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526""", "\n")
input = readlines("11.txt")

energy_mat = hcat(map(l -> parse.(Int, collect(l)), input)...)
N = size(energy_mat)[1]

# first, the energy level of each octopus increases by 1
function step!(energy_mat)
    energy_mat .+= 1

    toflash = Set(findall(energy_mat .> 9))
    flashed = empty(toflash)

    offsets = [(-1,-1), (0,-1), (1,-1), (-1,0), (1,0), (-1,1), (0,1), (1,1)]
    while !isempty(toflash)
        for idx in toflash
            push!(flashed, idx)
            for o in offsets
                _idx = idx - CartesianIndex(o)
                if any(_idx.I .< 1) || any(_idx.I .> N)
                    continue
                end
                energy_mat[_idx] += 1
            end
        end
        toflash = setdiff(findall(energy_mat .> 9), flashed)
    end

    for idx in flashed
        energy_mat[idx] = 0
    end

    return length(flashed)
end


function simulate(energy_mat; tmax=100, visualize=false, sleeptime=0.01)
    flashes = 0
    for i in 1:tmax
        flashes += step!(energy_mat)
        if visualize
            display(heatmap(energy_mat))
            sleep(sleeptime)
        end
    end
    return flashes
end
# energy_mat = hcat(map(l -> parse.(Int, collect(l)), input)...)
# simulate(energy_mat; visualize=true, tmax=1000)

ex1() = simulate(hcat(map(l -> parse.(Int, collect(l)), input)...))
ex1()

function ex2()
    energy_mat = hcat(map(l -> parse.(Int, collect(l)), input)...)
    i = 0
    while length(unique(energy_mat)) > 1
        i += 1
        step!(energy_mat)
    end
    return i
end
ex2()
