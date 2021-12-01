testinput = split("""mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)""", "\n")
myinput = readlines("21.txt")
input = myinput

function parseline(l)
    _ing, _allergens = split(l, " (contains ")
    ing = split(_ing)
    allergens = split(strip(_allergens, ')'), ", ")
    return ing, allergens
end
foodlist = parseline.(input)

_ings, _alls = zip(foodlist...)
all_alls = Set(vcat(_alls...))
all_ings = Set(vcat(_ings...))

a2i = [a => Set(f[1]) for f in foodlist for a in f[2]]
better_a2i = Dict([A => reduce(intersect, [i for (a, i) in a2i if a==A]) for A in all_alls])
safe_ings = setdiff(all_ings, reduce(union, values(better_a2i)))


counter = 0
for I in safe_ings
    counter += sum(map(f -> I in f[1], foodlist))
end
counter
part1 = counter



# Now, identify the allergens
# canonical dangerous ingredient list:
_a2i = copy(better_a2i)
# @assert sum(length.(values(_a2i)).==1)==1
cdil = Dict([k=>v for (k, v) in _a2i if length(v)==1])
function update_a2i!(_a2i, cdil)
    for (k, v) in _a2i
        _a2i[k] = intersect([setdiff(v, s) for s in values(cdil)]...)
    end
end
update_a2i!(_a2i, cdil)
while any(length.(values(_a2i)) .> 0)
    cdil = Dict(union(cdil, Dict([k=>v for (k, v) in _a2i if length(v)==1])))
    update_a2i!(_a2i, cdil)
end

[values(v) for (k, v) in sort(collect(cdil), by=x->x[1])]
part2 = join(reduce(vcat, [collect(v) for (k, v) in sort(collect(cdil), by=x->x[1])]), ",")
