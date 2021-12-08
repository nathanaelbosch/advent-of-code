input = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
input = split("""be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce""", "\n")
input = readlines("8.txt")

get_rhs_strings(inputline) = split(split(inputline, " | ")[2])
sort_string(s) = join.(sort.(collect.(s)))
rhs_strings = get_rhs_strings.(input)
# sorted_rhs_strings = map(strings -> sort_string.(strings), rhs_strings)


unique_lengths = values(Dict(
    1 => 2,
    7 => 3,
    4 => 4,
    8 => 7,
))


function ex1(input)
    rhs_strings = map(l -> split(split(l, " | ")[2]), input)
    lengths = map(l -> length.(l), rhs_strings)
    is_in_unique_lengths = map(l -> l in unique_lengths, hcat(lengths...))
    return sum(is_in_unique_lengths)
end
ex1(input)

sortstring(s) = join(sort(collect(s)))
function figure_out_translation_table(d1)
    _7 = d1[length.(d1) .== 3][1]
    _1 = d1[length.(d1) .== 2][1]
    _4 = d1[length.(d1) .== 4][1]
    _8 = d1[length.(d1) .== 7][1]

    cf = collect(_1)
    a = setdiff(_7, _1)[1]
    bd = setdiff(_4, _1)

    _6_candidates = unique(d1[length.(d1) .== 6])
    _6 = _6_candidates[map(c -> !(cf[1] in c && cf[2] in c), _6_candidates)][1]

    _3_candidates = unique(d1[length.(d1) .== 5])
    _3 = _3_candidates[map(c -> (cf[1] in c && cf[2] in c), _3_candidates)][1]

    b = [c for c in _4 if !(c in _3)][1]
    d = setdiff(bd, b)[1]

    _5_candidates = _3_candidates
    _5 = _5_candidates[map(c -> (b in c), _5_candidates)][1]

    _2_candidates = _3_candidates
    _2 = [c for c in _2_candidates if (c != _3 && c != _5)][1]

    _9 = [c for c in _6_candidates if (c != _6 && d in c)][1]
    _0 = [c for c in _6_candidates if (c != _6 && c != _9)][1]

    translation_table = Dict(
        _0 => "0",
        _1 => "1",
        _2 => "2",
        _3 => "3",
        _4 => "4",
        _5 => "5",
        _6 => "6",
        _7 => "7",
        _8 => "8",
        _9 => "9",
    )
    return translation_table
end
translate_rhs(d1, translation_table) = parse(Int, join([translation_table[s] for s in d1[end-3:end]]))

function ex2(input)
    data = hcat(map(l -> split(l), input)...)
    data = sortstring.(data)
    return sum([translate_rhs(d, figure_out_translation_table(d)) for d in eachcol(data)])
end
ex2(input)
