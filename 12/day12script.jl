include("day12func.jl")
(x,y) = move_ship(read_data("input.txt"),0,0,0)
println(abs(x)+abs(y))

(x,y) = move_ship2(read_data("input.txt"),0,0,10,1)
println(abs(x)+abs(y))