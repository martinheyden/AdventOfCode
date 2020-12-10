include("prob10functions.jl")

nbrs = sort(map(x->parse(Int,x),readlines("input.txt")))
nbrs = [0;nbrs;nbrs[end]+3]
diff_array = [0,0,0];
find_differences!(nbrs,diff_array,length(nbrs))
println(diff_array[1]*diff_array[3])

nbr_path = Array{Integer,1}(undef,length(nbrs))
nbr_path[1] = 1;
find_configurations!(nbrs,nbr_path,2)
println(nbr_path[end])

