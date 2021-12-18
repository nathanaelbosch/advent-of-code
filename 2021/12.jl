# input = split("""start-A
# start-b
# A-c
# A-b
# b-d
# A-end
# b-end""", "\n")
# input = split("""dc-end
# HN-start
# start-kj
# dc-start
# dc-HN
# LN-dc
# HN-end
# kj-sa
# kj-HN
# kj-dc""", "\n")
# input = split("""fs-end
# he-DX
# fs-he
# start-DX
# pj-DX
# end-zg
# zg-sl
# zg-pj
# pj-he
# RW-he
# fs-DX
# pj-RW
# zg-RW
# start-pj
# he-WI
# zg-he
# pj-fs
# start-RW""", "\n")
input = readlines("12.txt")
edges = split.(input, "-")
nodes = unique(vcat(edges...))


# idea: do a breadth-first search
function bfs(edges)
    fullpaths = Set{Vector{String}}()
    paths = Set([["start"]])
    while !isempty(paths)
        newpaths = Vector{String}[]
        for path in paths
            endnode = path[end]
            possible_next_nodes = [e[2] for e in edges if e[1] == endnode] ∪ [e[1] for e in edges if e[2] == endnode]
            for n in possible_next_nodes
                if n == "start"
                    continue
                elseif n == "end"
                    push!(fullpaths, [path..., n])
                elseif lowercase(n) == n && n in path
                    continue
                else
                    push!(newpaths, [path..., n])
                end
            end
        end
        paths = Set(newpaths)
    end
    return fullpaths
end
ex1(edges) = length(bfs(edges))
ex1(edges)


function bfs2(edges)
    fullpaths = Set{Vector{String}}()
    paths = Set([["T", "start"]])
    while !isempty(paths)
        newpaths = Vector{String}[]
        for path in paths
            endnode = path[end]
            possible_next_nodes = [e[2] for e in edges if e[1] == endnode] ∪ [e[1] for e in edges if e[2] == endnode]
            for n in possible_next_nodes
                if n == "start"
                    continue
                elseif n == "end"
                    push!(fullpaths, [path..., n])
                elseif lowercase(n) == n && n in path
                    if path[1] == "T"
                        push!(newpaths, ["F", path[2:end]..., n])
                    else
                        continue
                    end
                else
                    push!(newpaths, [path..., n])
                end
            end
        end
        paths = Set(newpaths)
    end
    return fullpaths
end
ex2(edges) = length(bfs2(edges))
ex2(edges)
