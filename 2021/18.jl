input = split("""[1,2]
[[1,2],3]
[9,[8,7]]
[[1,9],[8,5]]
[[[[1,2],[3,4]],[[5,6],[7,8]]],9]
[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]""", "\n")

parse_sn(s::AbstractVector) = s
function parse_sn(s::AbstractString)
    depth = -1
    out = Tuple{Int,Int}[]
    number = ""
    for i in eachindex(s)
        c = s[i]
        if c == ','
            continue
        elseif c == '['
            depth += 1
        elseif c == ']'
            depth -= 1
        else
            number *= c
            if s[i+1] in ['[',']',',']
                push!(out, (parse(Int, number), depth))
                number = ""
            end
        end
    end
    @assert depth == -1
    return out
end

s1 = parse_sn(input[1])
s2 = parse_sn(input[2])
s = parse_sn("[[[[[9,8],1],2],3],4]")


function explode(s)
    i = findfirst(map(p -> p[2] >= 4, s))
    (isnothing(i)) && return s, false
    @assert s[i][2] == 4 && s[i+1][2] == 4
    left = s[1:i-1]
    middle = (0, 3)
    right = s[i+2:end]
    (length(left) > 0) && (left[end] = (left[end][1] + s[i][1], left[end][2]))
    (length(right) > 0) && (right[1] = (right[1][1] + s[i+1][1], right[1][2]))
    return [left..., middle, right...], true
end

function sn_split(s)
    i = findfirst(map(p -> p[1] >= 10, s))
    (isnothing(i)) && return s, false
    val, depth = s[i]
    s[i] = (val ÷ 2, depth + 1)
    insert!(s, i+1, ((val+1) ÷ 2, depth + 1))
    return s, true
end

function sn_add(s1, s2)
    s = [[(v, d + 1) for (v, d) in s1]..., [(v, d + 1) for (v, d) in s2]...]
    while true
        s, did_explode = explode(s)
        did_explode && continue
        s, did_split = sn_split(s)
        did_split && continue
        break
    end
    return s
end


s = sn_add(parse_sn("[[[[4,3],4],4],[7,[[8,4],9]]]"), parse_sn("[1,1]"))
input = split("""[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]""", "\n")
add_all(input) = foldl((a,b) -> sn_add(parse_sn(a), parse_sn(b)), input)
function magnitude(s)
    # magnitude of a pair: three times left + 2 times right
    @assert unique([d for (v, d) in s])

end
function to_tree_str(s)
    out = ""
    depth = -1
    for i in eachindex(s)
        v, d = s[i]
        while depth < d
            out += '['
        end
        out *= string(v)
    end
end
unique([d for (v, d) in s])

depth(s, i) = s[i][2]
val(s, i) = s[i][1]
function magnitude(_s)
    s = copy(_s)
    while true
        stop = true
        for i in 2:length(s)
            if depth(s, i-1) == depth(s, i)
                v = 3*val(s, i-1) + 2*val(s, i)
                d = depth(s, i) - 1
                splice!(s, i-1:i, ((v, d),))
                stop = false; break
            end
        end
        stop && return first(s[1])
    end
end
@assert magnitude(parse_sn("[[1,2],[[3,4],5]]")) == 143
@assert magnitude(parse_sn("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")) == 1384
@assert magnitude(parse_sn("[[[[1,1],[2,2]],[3,3]],[4,4]]")) == 445
@assert magnitude(parse_sn("[[[[3,0],[5,3]],[4,4]],[5,5]]")) == 791
@assert magnitude(parse_sn("[[[[5,0],[7,4]],[5,5]],[6,6]]")) == 1137
@assert magnitude(parse_sn("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488





ex1(input) = magnitude(add_all(input))
ex1(input)




sn_input = parse_sn.(input)
xs = 1:length(sn_input)
f(i, j, sn_input=sn_input) = magnitude(sn_add(sn_input[i], sn_input[j]))
possible_magnitudes = f.(xs, xs')
using LinearAlgebra
possible_magnitudes -= Diagonal(possible_magnitudes)
maximum(possible_magnitudes)
