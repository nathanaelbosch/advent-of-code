testinput = split(strip("""
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
"""))
myinput = readlines("24.txt")


function process_line(l)
    s = l |>
        s -> replace(s, "se"=>"SE") |>
        s -> replace(s, "ne"=>"NE") |>
        s -> replace(s, "sw"=>"SW") |>
        s -> replace(s, "nw"=>"NW") |>
        s -> replace(s, "e"=>"EE") |>
        s -> replace(s, "w"=>"WW") |>
        lowercase
    @assert length(s) % 2 == 0
    p = [s[2i-1:2i] for i in 1:length(s)÷2]
    return p
end

# coordinate system: east and north east
# ee => e+=1
# ww => e-=1
# ne => ne+=1
# sw => ne-=1
# se => ne-=1 e+=2
# nw => ne+=1 e-=2
function path2coord(path)
    loc = (0,0)  # (east, nort-east)
    for dir in path
        if dir == "ee"
            loc = loc .+ (1, 0)
        elseif dir == "ww"
            loc = loc .+ (-1, 0)
        elseif dir == "ne"
            loc = loc .+ (0, 1)
        elseif dir == "sw"
            loc = loc .+ (0, -1)
        elseif dir == "se"
            loc = loc .+ (1, -1)
        elseif dir == "nw"
            loc = loc .+ (-1, 1)
        end
    end
    return loc
end

input = myinput
# input = testinput
coords = path2coord.(process_line.(input))
using StatsBase: countmap
black = [k for (k,v) in countmap(coords) if v % 2 == 1]
part1 = length(black)


# part2
function get_neighbors(loc)
    return [loc.+(0,1),
            loc.+(0,-1),
            loc.+(1,0),
            loc.+(-1,0),
            loc.+(1,-1),
            loc.+(-1,1)]
end

# Rules:
# If tile is black, then flip it to white if it has either zero, or >=2 black neighbors
# If tile is white, then flip it if it has exactly two black neighbors
function nextday(black)
    ndict = countmap(reduce(vcat, get_neighbors.(black)))
    # Dict from tile, o how many black neighbors it has
    white = collect(setdiff(keys(ndict), black))
    black[get.(Ref(ndict), black, 0) .== 1]
    white[get.(Ref(ndict), white, 0) .== 2]
    next_black = vcat(black[0 .< get.(Ref(ndict), black, 0) .<= 2],
                      white[get.(Ref(ndict), white, 0) .== 2])
    return next_black
end
_b = black
for i in 1:100
    _b = nextday(_b)
end
length(_b)
