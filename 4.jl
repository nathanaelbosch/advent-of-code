
function part1(textfile)
    nvalid = 0
    nfields = 0
    cid = false
    for l in eachline(textfile)
        if l == ""
            valid = nfields == 8 || (nfields == 7 && !cid)
            if valid
                nvalid += 1
            end

            # Reset
            nfields = 0
            cid = false
        else
            nfields += length(split(l))
            cid = cid || occursin("cid", l)
        end
    end
    if nfields == 8 || (nfields == 7 && !cid)
        nvalid += 1
    end
end
nvalid1 = part1("4.txt")
println("Part 1: $nvalid1")



function part2(textfile)
    nvalid = 0
    lines = readlines(textfile)
    entry = ""
    for l in lines
        if l != ""
            if entry != ""
                entry *= " "
            end
            entry *= l
        else
            # process entry
            nvalid += isvalid(entry)
            entry = ""
        end
    end
    nvalid += isvalid(entry)
    return nvalid
end


todict(entry) = Dict(split.(split(entry), ':'))
function isvalid(entry)
    d = todict(entry)
    delete!(d, "cid")
    return length(d) < 7 ? false : (
        validbyr(d["byr"])
        && validiyr(d["iyr"])
        && valideyr(d["eyr"])
        && validhgt(d["hgt"])
        && validhcl(d["hcl"])
        && validecl(d["ecl"])
        && validpid(d["pid"]))
end

safeparseint(str::AbstractString) = try; return parse(Int, str); catch ArgumentError; return -1; end

validbyr(byr) = 1920 <= safeparseint(byr) <= 2002
validiyr(iyr) = 2010 <= safeparseint(iyr) <= 2020
valideyr(eyr) = 2020 <= safeparseint(eyr) <= 2030

validhgt(hgt) =
    endswith(hgt, "cm") ? (length(hgt) == 5 && 150 <= safeparseint(hgt[1:3]) <= 193) :
    endswith(hgt, "in") ? (length(hgt) == 4 && 59 <= safeparseint(hgt[1:2]) <= 76) :
    false
validhcl(hcl) = startswith(hcl, "#") && length(hcl) == 7 && all([c in 'a':'f' || c in '0':'9' for c in hcl[2:end]])
validecl(ecl) = ecl in ("amb", "blu", "brn", "gry", "grn", "hzl", "oth")
validpid(pid) = length(pid) == 9 && all('0' .<= collect(pid) .<= '9')


nvalid2 = part2("4.txt")
println("Part 2: $nvalid2")
