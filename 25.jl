using ProgressMeter
using BenchmarkTools
# card_pub = 5764801
# door_pub = 17807724



# "Transforming a subject number"
# start with the value 1
# for i in 1:nloops
# value = value * usbject number
# value = value % 20201227
function transform_subject(subject_number, loop_size)
    value = 1
    for i in 1:loop_size
        value = transform(value, subject_number)
    end
    return value
end
transform(value, subject_number) = (value * subject_number) % 20201227
@assert transform_subject(17807724, 8) == 14897079
@btime transform_subject(17807724, 8)



# Cryptographic Handshake:
# card_pub = transform_subject(7, ?)
# door_pub = transform_subject(7, ?)
function find_loopsize(pubkey, max=100_000_000)
    key = 1
    for l in 1:max
        key = transform(key, 7)
        if pubkey == key
            return l
        end
    end
end
@assert find_loopsize(5764801) == 8
@assert find_loopsize(17807724) == 11



# Part 1:
card_pub = 8458505
door_pub = 16050997
card_loop = find_loopsize(card_pub)
door_loop = find_loopsize(door_pub)
@assert transform_subject(door_pub, card_loop) == transform_subject(card_pub, door_loop)
key = transform_subject(door_pub, card_loop)
