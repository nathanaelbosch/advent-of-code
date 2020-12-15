lines = readlines("14.txt")


int2bin(int) = Base.bin(Unsigned(int), 36, false)

elapplymask1(v::Char, m::Char) = m == 'X' ? v : m
applymask1(val::AbstractString, mask::AbstractString) =
    join(elapplymask1.(collect.((val, mask))...))
function part1(lines)
    mem = Dict(0=>0)
    mask = ""
    for l in lines
        lhs, _, rhs = split(l)
        if lhs == "mask"
            mask = rhs
        else
            mem_val = parse(Int, rhs)
            mem_idx = parse(Int, split(lhs, "[")[2][1:end-1])
            mem[mem_idx] = parse(Int, applymask1(int2bin(mem_val), mask), base=2)
        end
    end
    return sum(values(mem))
end


elapplymask2(v::Char, m::Char) = m == '0' ? v : m
applymask2(val::AbstractString, mask::AbstractString) =
    join(elapplymask2.(collect.((val, mask))...))
function get_addresses(address_bitmask::AbstractArray{Char})
    i = findfirst(==('X'), address_bitmask)
    if !isnothing(i)
        b1 = copy(address_bitmask)
        b1[i] = '0'
        b2 = copy(address_bitmask)
        b2[i] = '1'
        return (get_addresses(b1)..., get_addresses(b2)...)
    else
        return parse(Int, join(address_bitmask), base=2)
    end
end


function part2(lines)
    mem = Dict(0=>0)
    mask = ""
    for l in lines
        lhs, _, rhs = split(l)
        if lhs == "mask"
            mask = rhs
        else
            mem_val = parse(Int, rhs)
            mem_idx = parse(Int, split(lhs, "[")[2][1:end-1])
            address_bitmask = applymask2(int2bin(mem_idx), mask)
            addresses = get_addresses(collect(address_bitmask))
            for a in addresses
                mem[a] = mem_val
            end
        end
    end
    return sum(values(mem))
end
