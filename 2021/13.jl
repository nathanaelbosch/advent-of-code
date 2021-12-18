input = split("""6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5""", "\n")
input = readlines("13.txt")
empty_line_idx = findfirst(input .== "")
coordinate_strings = input[1:empty_line_idx-1]
folds = input[empty_line_idx+1:end]

indices = [CartesianIndex((parse.(Int, split(c, ",")) .+ 1)...) for c in coordinate_strings]
xmax, ymax = maximum(hcat([collect(i.I) for i in indices]...), dims=2)

paper = zeros(Bool, xmax, ymax)
paper[indices] .= true
paper


function fold_paper(paper, fold_str)
    _d, _v = split(split(fold_str)[end], "=")
    v = parse(Int, _v) + 1
    if _d == "x"
        return paper[1:v-1, :] .| paper[end:-1:v+1, :]
    else
        return paper[:, 1:v-1] .| paper[:, end:-1:v+1]
    end
end


function ex1(paper, folds)
    return sum(fold_paper(paper, folds[1]))
end
ex1(paper, folds)


function ex2(paper, folds)
    for fold in folds
        paper = fold_paper(paper, fold)
    end
    display(map(b -> b ? "#" : " ", paper'))
end
ex2(paper, folds)
