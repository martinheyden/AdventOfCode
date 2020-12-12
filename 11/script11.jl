include("func11.jl")

seats,occ = read_input("input.txt")
occ2 = copy(occ)
new_occ = copy(occ)
neighbours = find_neighbours(seats,adjacent_neighbour)
find_equilibrium!(occ,new_occ,neighbours,4)
println(sum(new_occ))

neighbours = find_neighbours(seats,direction_neighbour)
find_equilibrium!(occ2,new_occ,neighbours,5)
println(sum(new_occ))

