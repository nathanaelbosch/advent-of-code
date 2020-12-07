
code = "FBFBBFFRLR"

function getrow(code)
    rowcode = code[1:7]
    rowtrans = Dict('F' => '0', 'B' => '1')
    row = parse(Int, map(c -> rowtrans[c], rowcode), base=2)
    return row
end
function getcol(code)
    colcode = code[8:10]
    coltrans = Dict('L' => '0', 'R' => '1')
    col = parse(Int, map(c -> coltrans[c], colcode), base=2)
    return col
end
seatid(row, col) = row * 8 + col
row, col = getrow(code), getcol(code)
id = seatid(row, col)
println("Seat $code: row $row, col $col, ID $id")


# Part 1:
seatid(code) = seatid(getrow(code), getcol(code))
maxid = maximum(seatid.(eachline("5.txt")))
println("Max ID in the data: $maxid")


# Part 2:
all_ids = seatid.(eachline("5.txt"))
myseat = setdiff(minimum(all_ids):1:maximum(all_ids), all_ids)[1]
println("My seat: $myseat")
