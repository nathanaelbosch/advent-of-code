using StatsBase: countmap


data = readlines("2.txt") |> v -> split.(v)

const rock = 1
const paper = 2
const scissors = 3

SCORING = [
    3 0 6
    6 3 0
    0 6 3
]

OPPONENT_CODE = Dict(
    "A" => rock,
    "B" => paper,
    "C" => scissors,
)

PLAYER_CODE = Dict(
    "X" => rock,
    "Y" => paper,
    "Z" => scissors,
)

points = 0
for d in data
    opponent = OPPONENT_CODE[d[1]]
    player = PLAYER_CODE[d[2]]
    points += player
    points += SCORING[player, opponent]
end
@info "Result part 1:" points

PLAYER_CODE = Dict(
    "X" => 0,
    "Y" => 3,
    "Z" => 6,
)

points = 0
for d in data
    opponent = OPPONENT_CODE[d[1]]
    desired_result = PLAYER_CODE[d[2]]
    player = findfirst(x -> x==desired_result, SCORING[:, opponent])
    points += player
    points += desired_result
end
@info "Result part 2:" points
