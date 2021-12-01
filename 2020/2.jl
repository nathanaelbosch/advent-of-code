lines = readlines("2.txt")


function countvalid1(lines)
    nvalid = 0
    for line in lines
        n, l, p = split(line)
        nmin, nmax = parse.(Int, split(n, "-"))
        letter = l[1]
        occurrences = count(==(letter), p)
        if nmin <= occurrences <= nmax
            nvalid += 1
        end
    end
    return nvalid
end


function countvalid2(lines)
    nvalid = 0
    for line in lines
        n, l, p = split(line)
        i1, i2 = parse.(Int, split(n, "-"))
        letter = l[1]
        if (p[i1] == letter) + (p[i2] == letter) == 1
            nvalid += 1
        end
    end
    return nvalid
end
