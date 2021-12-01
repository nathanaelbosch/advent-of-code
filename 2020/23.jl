using ProgressMeter
using Profile, ProfileView, BenchmarkTools

testinput = [3,8,9,1,2,5,4,6,7]
input = [6,4,3,7,1,9,2,5,8]
cups = copy(input)


function get_dest_label(current, pickup, maxlabel)
    # what about current - 1?
    for diff = 1:4
        _dest = current-diff
        dest = _dest<1 ? _dest+maxlabel : _dest
        if !(dest in pickup)
            return dest
        end
    end
end
function play(cups; nrounds=100, verbose=false)
    cc1 = copy(cups)
    cc2 = copy(cups)
    maxlabel = maximum(cups)
    # @showprogress for i in 1:nrounds
    for i in 1:nrounds
        current, pickup, rest = cc1[1], (@view cc1[2:4]), (@view cc1[5:end])
        verbose && @info "Status" current pickup rest
        # destination =
        dest = get_dest_label(current, pickup, maxlabel)

        # _, dest_idx = findmin((current-1) .- map(x -> x>current-1 ? x-9 : x, rest))
        dest_idx = findfirst(==(dest), rest)
        rest_before, dest, rest_after = (@view rest[1:dest_idx-1]), rest[dest_idx], (@view rest[dest_idx+1:end])
        # cups = vcat(rest_before, [dest], pickup, rest_after, [current])
        cc2[1:dest_idx-1] = rest_before
        cc2[dest_idx] = dest
        cc2[dest_idx+1:dest_idx+3] = pickup
        cc2[dest_idx+4:end-1] = rest_after
        cc2[end] = current

        cc1, cc2 = cc2, cc1
    end
    return cc1
end
# function part1eval(cups)
#     one_idx = findfirst(==(1), cups)
#     return parse(Int, join(vcat(cups[one_idx+1:end], cups[1:one_idx-1])))
# end
# part1eval(play(input))





cups2 = vcat(input, maximum(input)+1:1_000_000)
function part2eval(cups)
    one_idx = findfirst(==(1), cups)
    return cups[one_idx+1]*cups[one_idx+2]
end
part2eval(play(cups2, nrounds=100))

Profile.clear_malloc_data()

part2eval(play(cups2, nrounds=100))




# using Profile, ProfileView, BenchmarkTools





function play2(cups; nrounds=100)
    cups = copy(cups)
    maxlabel = maximum(cups)
    @showprogress for i in 1:nrounds
    # for i in 1:nrounds
        current = popfirst!(cups)
        pickup = splice!(cups, 1:3)
        rest = cups

        dest = get_dest_label(current, pickup, maxlabel)
        dest_idx = findfirst(==(dest), rest)

        splice!(rest, dest_idx+1:dest_idx, pickup)
        push!(rest, current)
    end
    return cups
end

function play3(cups; nrounds=100, verbose=false)
    cups = copy(cups)
    maxlabel = maximum(cups)
    curr_idx = 1
    @showprogress for i in 1:nrounds
        # for i in 1:nrounds
        verbose && @info "start round with" cups curr_idx
        current = cups[curr_idx]
        if curr_idx+3 <= maxlabel
            pickup = splice!(cups, curr_idx+1:curr_idx+3)
        elseif curr_idx+2 == maxlabel
            pickup = vcat(splice!(cups, curr_idx+1:curr_idx+2), [popfirst!(cups)])
        elseif curr_idx+1 == maxlabel
            pickup = vcat([pop!(cups)], splice!(cups, 1:2))
        elseif curr_idx == maxlabel
            pickup = splice!(cups, 1:3)
        end
        # rest = @view cups[2:end]

        dest = get_dest_label(current, pickup, maxlabel)
        dest_idx = findfirst(==(dest), cups)

        verbose && @info "status" current pickup cups dest dest_idx

        splice!(cups, dest_idx+1:dest_idx, pickup)
        # push!(cups, current)
        (dest_idx < curr_idx) && (curr_idx += 3)
        curr_idx += 1
        (curr_idx > maxlabel) && (curr_idx = 1)
    end
    return cups
end
