testinput = """Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10"""
myinput = read("22.txt", String)
input = testinput

function makedecks(input)
    _p1, _p2 = map(i -> parse.(Int, split(split(i,":\n")[2])), split(input, "\n\n"))
    # p1, p2 = Queue{Int}(), Queue{Int}()
    # enqueue!.(Ref(p1), _p1)
    # enqueue!.(Ref(p2), _p2)
    return _p1, _p2
end

function play!(p1, p2)
    while length(p1) > 0 && length(p2) > 0
        # c1, c2 = dequeue!(p1), dequeue!(p2)
        c1, c2 = popfirst!(p1), popfirst!(p2)
        c1>c2 ? append!(p1, [c1,c2]) : append!(p2, [c2,c1])
    end
end

p1, p2 = makedecks(input)
play!(p1, p2)
winner = length(p1) > 0 ? p1 : p2
sum(reverse(1:length(winner)) .* winner)



# Part 2

function play2!(p1, p2)
    i = 1
    history = UInt64[]
    while length(p1) > 0 && length(p2) > 0
        # 1. If there was a previous round with the same constellation, P1 wins
        # 2. Players draw cards as normal
        # println("-- Round $i --")
        # println("Player 1's deck: $p1")
        # println("Player 2's deck: $p2")
        h = hash((p1,p2))
        if h in history return true end
        push!(history, h)
        c1, c2 = popfirst!(p1), popfirst!(p2)
        # println("Player 1 plays: $c1")
        # println("Player 2 plays: $c2")
        # 3. If there are at least as many cards remaining as on the card, determine the winner by playing revursive combat
        # 4. Otherwsise, standard rules
        c1won = length(p1) >= c1 && length(p2) >= c2 ? (play2!(p1[1:c1], p2[1:c2])) : c1>c2
        c1won ? append!(p1, (c1,c2)) : append!(p2, (c2,c1))
        # println("Player $(c1won ? 1 : 2) wins round $i")
        # println("")
        i += 1
    end
    return length(p1) > length(p2)
end
p1, p2 = makedecks(myinput)
winner = play2!(p1, p2) ? p1 : p2
sum(reverse(1:length(winner)) .* winner)
