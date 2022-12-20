#=
--- Day 20: Grove Positioning System ---

It's finally time to meet back up with the Elves. When you try to contact them, however, you get no reply. Perhaps you're out of range?

You know they're headed to the grove where the star fruit grows, so if you can figure out where that is, you should be able to meet back up with them.

Fortunately, your handheld device has a file (your puzzle input) that contains the grove's coordinates! Unfortunately, the file is encrypted - just in case the device were to fall into the wrong hands.

Maybe you can decrypt it?

When you were still back at the camp, you overheard some Elves talking about coordinate file encryption. The main operation involved in decrypting the file is called mixing.

The encrypted file is a list of numbers. To mix the file, move each number forward or backward in the file a number of positions equal to the value of the number being moved. The list is circular, so moving a number off one end of the list wraps back around to the other end as if the ends were connected.

For example, to move the 1 in a sequence like 4, 5, 6, 1, 7, 8, 9, the 1 moves one position forward: 4, 5, 6, 7, 1, 8, 9. To move the -2 in a sequence like 4, -2, 5, 6, 7, 8, 9, the -2 moves two positions backward, wrapping around: 4, 5, 6, 7, 8, -2, 9.

The numbers should be moved in the order they originally appear in the encrypted file. Numbers moving around during the mixing process do not change the order in which the numbers are moved.

Consider this encrypted file:

1
2
-3
3
-2
0
4

Mixing this file proceeds as follows:

Initial arrangement:
1, 2, -3, 3, -2, 0, 4

1 moves between 2 and -3:
2, 1, -3, 3, -2, 0, 4

2 moves between -3 and 3:
1, -3, 2, 3, -2, 0, 4

-3 moves between -2 and 0:
1, 2, 3, -2, -3, 0, 4

3 moves between 0 and 4:
1, 2, -2, -3, 0, 3, 4

-2 moves between 4 and 1:
1, 2, -3, 0, 3, 4, -2

0 does not move:
1, 2, -3, 0, 3, 4, -2

4 moves between -3 and 0:
1, 2, -3, 4, 0, 3, -2

Then, the grove coordinates can be found by looking at the 1000th, 2000th, and 3000th numbers after the value 0, wrapping around the list as necessary. In the above example, the 1000th number after 0 is 4, the 2000th is -3, and the 3000th is 2; adding these together produces 3.

Mix your encrypted file exactly once. What is the sum of the three numbers that form the grove coordinates?
=#

example = """
1
2
-3
3
-2
0
4"""


mutable struct Element
    number::Int64
    mixed::Bool
end
Element(a::Int) = Element(a, false)
ismixed(e::Element) = e.mixed

struct NewElement
    number::Int64
    id::Int64
end


function mix!(_elements)
    elements = Element.(_elements)
    N = length(elements)
    while !all(ismixed, elements)
        i = findfirst(!ismixed, elements)
        e = popat!(elements, i)
        e.mixed = true
        insert_index = mod1(i + e.number, length(elements))
        insert!(elements, insert_index, e)
        # @info "$(e.number) moves from $i to $insert_index"
    end
    _elements .= [e.number for e in elements]
    return _elements
end

function mix2!(elements)
    N = length(elements)
    for id in 1:N
        i = findfirst(e -> e.id == id, elements)
        e = popat!(elements, i)
        insert_index = mod1(i + e.number, N-1)
        insert!(elements, insert_index, e)
        # @info "$e moves from $i to $insert_index"
    end
    return elements
end

function get_score(elements)
    N = length(elements)
    i = findfirst(==(0), elements)
    return elements[mod1(i + 1000, N)] + elements[mod1(i + 2000, N)] + elements[mod1(i + 3000, N)]
end

function part1(lines)
    elements = parse.(Int, lines)
    mix!(elements)
    return get_score(elements)
end
function part12(lines)
    elements = parse.(Int, lines)
    elements = NewElement.(elements, 1:length(elements))
    mix2!(elements)
    return get_score([e.number for e in elements])
end

part1(split(example, "\n"))
part1(readlines("20.txt"))
part12(readlines("20.txt"))


# Part 2
const DECRYPTION_KEY = 811589153

function part2(lines)
    elements = parse.(Int, lines)
    elements .*= DECRYPTION_KEY
    elements = NewElement.(elements, 1:length(elements))
    for _ in 1:10
        mix2!(elements)
    end
    return get_score([e.number for e in elements])
end
part2(split(example, "\n"))
part2(readlines("20.txt"))
