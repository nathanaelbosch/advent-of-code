lines = readlines("7.txt")

# Part 1
stripnumbers(bagdesc) = join(split(bagdesc)[2:end], " ")
stripbags(bagdesc) = join(split(bagdesc)[1:end-1], " ")
function make_rules_part1(lines)
    rules = []
    for line in lines
        outside, inside = strip.(split(line[1:end-1], "contain"))
        if inside == "no other bags"
            continue
        end
        inside = split(inside, ", ")
        inside = stripbags.(stripnumbers.(inside))
        outside = stripbags(outside)
        push!(rules, (outside, inside))
    end
    rules
end

function count_outsidepossibilities(bag, rules)
    possible_bags = Set([bag])
    prevlength = 0
    while prevlength != length(possible_bags)
        prevlength = length(possible_bags)
        for r in rules
            outbag, inbags = r
            for i in inbags
                if i in possible_bags
                    push!(possible_bags, outbag)
                    continue
                end
            end
        end
    end
    return length(possible_bags) - 1  # The bag itself does not count
end
count_outsidepossibilities("shiny gold", make_rules_part1(lines))


# Part 2
function getoutinrules(lines)
    # A bit different from part 1: Keep the numbers, and return a Dict
    outinrules = []
    for line in lines
        outside, inside = strip.(split(line[1:end-1], "contain"))
        inside = split(inside, ", ")
        stripbags(bagdesc) = join(split(bagdesc)[1:end-1], " ")
        inside = stripbags.(inside)
        outside = stripbags(outside)
        push!(outinrules, (outside, inside))
    end
    return Dict(outinrules)
end


number_color_split(bagstr) = (_s = split(bagstr); (_s[1], join(_s[2:end], " ")))
function multiply_bag(inside, nbags)
    nstr, c = number_color_split(inside)
    nnew = parse(Int, nstr) * nbags
    newin = join(["$nnew", c], " ")
    return newin
end


function count_insidebags(bag, outinrules)
    tofill = [bag]
    ntotal = -parse(Int, number_color_split(bag)[1])
    while !isempty(tofill)
        curr = pop!(tofill)
        if curr == "no other"
            continue
        end
        nstr, color = number_color_split(curr)
        nbags = parse(Int, nstr)
        ntotal += nbags

        insides = outinrules[color]

        if insides != ["no other"]
            insides = multiply_bag.(insides, nbags)
            append!(tofill, insides)
        end
    end
    return ntotal
end
count_insidebags("1 shiny gold", getoutinrules(lines))
