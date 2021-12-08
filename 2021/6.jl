using ProgressBars

input = "3,4,3,1,2"
input = readline("6.txt")
parse_input(input) = parse.(Int, split(input, ","))

decrease_timers!(timers) = timers .-= 1
adjust_population!(timers) = begin
    for i in eachindex(timers)
        if timers[i] == -1
            timers[i] = 6
            push!(timers, 8)
        end
    end
end
simulate_day!(timers) = begin
    decrease_timers!(timers)
    adjust_population!(timers)
end

function simulate_fish!(timers; days=80)
    for i in 1:days
        simulate_day!(timers)
    end
    return timers
end
ex1(input) = length(simulate_fish!(parse_input(input)))
ex1(input)


timers = parse_input(input)
timers2newformat(timers) = begin
    new_timers = zeros(Int, 9)
    for i in 1:9
        new_timers[i] = sum(timers .== i-1)
    end
    return new_timers
end
timers = timers2newformat(timers)

function new_simulate_day!(timers)
    new_fish = timers[1]
    timers[1:end-1] .= timers[2:end] # time passes
    timers[7] += new_fish # fish get reset to 6 days
    timers[end] = new_fish # new fish get created
end
function new_simulate!(timers; days=80)
    for i in 1:days
        new_simulate_day!(timers)
    end
    return timers
end

ex2(input; days=256) = sum(new_simulate!(timers2newformat(parse_input(input)); days=days))
@assert ex1(input) == ex2(input; days=80)
ex2(input)
