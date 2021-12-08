input = split("""
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7""", "\n")
input = readlines("4.txt")

numbers = parse.(Int, split(input[1], ","))
nboards = (length(input)-1) ÷ 6
boards = [
    (start_idx = 2+1+(i-1)*6;
     input[start_idx:start_idx+4])
    for i in 1:nboards
]
board2mat(board) = hcat(split.(board)...)
boards = parse.(Int, cat(board2mat.(boards)..., dims=3))


function ex1(boards, numbers)
    marked = zeros(Bool, size(boards)...)
    for n in numbers
        marked[boards .== n] .= true
        won_boards = (any(prod(marked, dims=2), dims=1) .||
                      any(prod(marked, dims=1), dims=2))
        if any(won_boards)
            win_id = findall(won_boards)[1][3]
            win_board = boards[:, :, win_id]
            win_marked = marked[:, :, win_id]
            return sum(win_board[.!win_marked]) * n
        end
    end
end
ex1(boards, numbers)

function ex2(boards, numbers)
    marked = zeros(Bool, 5, 5, nboards)
    won_boards_lastround = zeros(Bool, 1, 1, nboards)
    for n in numbers
        marked[boards .== n] .= true
        won_boards = (any(prod(marked, dims=2), dims=1) .||
            any(prod(marked, dims=1), dims=2))
        if all(won_boards)
            lose_id = findall(.!won_boards_lastround)[1][3]
            lose_board = boards[:, :, lose_id]
            lose_marked = marked[:, :, lose_id]
            return sum(lose_board[.!lose_marked]) * n
        end
        won_boards_lastround = won_boards
    end
end
ex2(boards, numbers)
