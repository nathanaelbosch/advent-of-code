input = split("""[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]""", "\n")
input = readlines("10.txt")

const points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
const open_brackets = Set(['(', '{', '[', '<'])
const match_bracket = Dict('(' => ')', '{' => '}', '[' => ']', '<' => '>')

matches(a, b) = (a=='(' && b==')') || (a=='[' && b==']') || (a=='{' && b=='}') || (a=='<' && b=='>')

function get_illegal_char(line)
    open_bracket_stack = Char[]
    for char in line
        if char in open_brackets
            push!(open_bracket_stack, char)
        else
            if matches(open_bracket_stack[end], char)
                pop!(open_bracket_stack)
            else
                return char
            end
        end
    end
    return open_bracket_stack
end

function ex1(input)
    illegal_chars = [c for c in get_illegal_char.(input) if c isa Char]
    illegal_char_countmap = countmap(illegal_chars)
    score = 0
    for (k, v) in illegal_char_countmap
        score += v * points[k]
    end
    return score
end
ex1(input)


function get_score(closing_brackets)
    score = 0
    for c in closing_brackets
        score *= 5
        score += c == ')' ? 1 : c == ']' ? 2 : c == '}' ? 3 : 4
    end
    return score
end
function ex2(input)
    incomplete_brackets = [b for b in get_illegal_char.(input) if !(b isa Char)]
    get_matching_brackets(open_brackets) = [match_bracket[c] for c in reverse(open_brackets)]
    scores = get_score.(get_matching_brackets.(incomplete_brackets))
    sort!(scores)
    return scores[(length(scores)+1)÷2]
end
ex2(input)
