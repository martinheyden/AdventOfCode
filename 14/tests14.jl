## Part 1 ##
include("func14.jl")
mask =  generate_mask_map("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
vec = zeros(36)
vec2 = zeros(36)
to_binary!(11,vec)
@assert(from_binary(vec) == 11)
vec2 = map(mask,enumerate(vec))
@assert(from_binary(vec2)==73)

to_binary!(101,vec)
@assert(from_binary(vec) == 101)
vec2 = map(mask,enumerate(vec))
@assert(from_binary(vec2)==101)

to_binary!(0,vec)
@assert(from_binary(vec) == 0)
vec2 = map(mask,enumerate(vec))
@assert(from_binary(vec2)==64)


## Part 2 ##
mask = generate_mask_map2("000000000000000000000000000000X1001X")
to_binary!(42,vec)
vec2 = map(mask,enumerate(vec))
@assert(sort(find_mem(vec2)) == [26, 27, 58, 59])
