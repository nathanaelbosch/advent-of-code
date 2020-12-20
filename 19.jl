testinput = split(strip("""
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"""), "\n")


myinput = readlines("19.txt")


function input2rulesmessages(_input)
    input = replace.(_input, "\""=>"")
    _i = findfirst(==(""), input)
    rules = input[1:_i-1]
    messages = input[_i+1:end]
    return rules, messages
end

parse_rhs(rhs) =
    rhs == "a" || rhs == "b" ? rhs :
    # map(a -> parse.(Int, a), split.(split(rhs, " | "), " "))
    map(a -> a == "|" ? a : parse.(Int, a), split.(split(rhs, " | "), " "))
rules2ruledict(rules) =
    Dict([[parse(Int, r[1]), parse_rhs(r[2])] for r in split.(rules, ": ")])
rule0 = ruledict[0]

function recursive_replace(rule, ruledict)
    if rule isa AbstractArray
        return recursive_replace.(rule, Ref(ruledict))
    elseif rule isa Integer
        return ruledict[rule]
    elseif rule isa AbstractString
        return rule
    else
        error("Something went wrong")
    end
end

function get_full_rule(rule0, ruledict)
    rule0_before = rule0
    rule0_after = recursive_replace(rule0_before, ruledict)
    while rule0_before != rule0_after
        rule0_before = rule0_after
        rule0_after = recursive_replace(rule0_before, ruledict)
    end
    rule0_full = rule0_after
    return rule0_full
end

rules, messages = input2rulesmessages(testinput)
ruledict = rules2ruledict(rules)
rule0 = ruledict[0]
rule0_full = get_full_rule(rule0, ruledict)

















rules2ruledict(rules) = Dict([
    [r[1], r[2] == "a" || r[2] == "b" ? r[2] : split(r[2], " ")]
    for r in split.(rules, ": ")])

function recursive_replace(rule, ruledict)
    if rule isa AbstractArray
        return recursive_replace.(rule, Ref(ruledict))
    elseif rule in keys(ruledict)
        return ruledict[rule]
    else
        return rule
    end
end

function get_full_rule(rule0, ruledict)
    rule0_before = rule0
    rule0_after = recursive_replace(rule0_before, ruledict)
    while rule0_before != rule0_after
        rule0_before = rule0_after
        rule0_after = recursive_replace(rule0_before, ruledict)
    end
    rule0_full = rule0_after
    return rule0_full
end

rules, messages = input2rulesmessages(myinput)
ruledict = rules2ruledict(rules)
rule0 = ruledict["0"]
rule0_full = get_full_rule(rule0, ruledict)


rule2regex(rule) =
    Regex(join(("^", rule2regex_recursion(rule), "\$")))
rule2regex_recursion(rule) = join(map(a -> a isa AbstractArray ? join(("(", rule2regex_recursion(a), ")")) : a, rule))
final_regex = rule2regex(rule0_full)

part1 = sum(map(m -> !isnothing(match(final_regex, m)), messages))






#####################################################################################
# Part 2:
newrules = copy(ruledict)
rule0 = newrules["0"]

N = 10
COUNT = 0
for i = 1:N, j in 1:N
    try
        newrules["8"] = repeat(["42"], i)
        newrules["11"] = repeat(["42", "31"], inner=j)
        rule0_full = get_full_rule(rule0, newrules)
        final_regex = rule2regex(rule0_full)
        _sum = sum(map(m -> !isnothing(match(final_regex, m)), messages))
        COUNT += _sum
        @info "sum" i j _sum
    catch
        @warn "error"
    end
end
