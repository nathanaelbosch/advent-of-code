example1 = """
noop
addx 3
addx -5"""

example2 = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop"""

function run_program(program; verbose=false)
    instructions = split(program, "\n")
    X = 1
    Xs = []
    signal_strengths = []

    occupied = false
    local inst
    for cycle in 1:240
        verbose && @info "[Cycle $cycle] START"

        push!(Xs, X)
        signal_strength = cycle * X
        verbose && @info "[Cycle $cycle] STATUS: X=$X, signal_strength=$signal_strength"

        if !occupied && !isempty(instructions)
            inst = popfirst!(instructions)
            verbose && @info "[Cycle $cycle] begin `$inst`"
            occupied = inst == "noop" ? false : true
        elseif occupied
            verbose && @info "[Cycle $cycle] finish `$inst`"
            if inst[1:4] == "addx"
                X += parse(Int, inst[5:end])
            end
            occupied = false
        end

        verbose && @info "[Cycle $cycle] END"
    end
    return Xs
end

function get_score(program)
    Xs = run_program(program)
    return (Xs.*(1:length(Xs)))[[20, 60, 100, 140, 180, 220]] |> sum
end
score = get_score(read("10.txt", String))
score = get_score(example2)
@info "Part 1" score

function make_drawing(program; verbose=false)
    Xs = run_program(program, verbose=verbose)
    screen = fill(' ', 6, 40)
    sprite = (1, 3) # covers pixels 1-3
    for row in 1:6
        for col in 1:40
            X = popfirst!(Xs)
            sprite = (X, X+2)
            if sprite[1] <= col <= sprite[2]
                screen[row, col] = '#'
            end
        end
    end
    return screen
end

screen = make_drawing(read("10.txt", String))
heatmap(screen[end:-1:begin, :] .!= '#', size=(4000, 600), colorbar=false)
