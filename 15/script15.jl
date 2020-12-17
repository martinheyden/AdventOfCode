include("functions15.jl")
println(find_nth(map(x->parse(Int,x),split("19,0,5,1,10,13",',')),2020))
println(find_nth(map(x->parse(Int,x),split("19,0,5,1,10,13",',')),30000000))