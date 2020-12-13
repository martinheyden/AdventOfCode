#using LinearAlgebra, Primes, DataStructures

include("func13.jl")
time, busnbrs,time_vec = read_data("input.txt")
(wait,nbr) = time_to_wait(time,copy(busnbrs),typemax(Int64),-1)
println(wait*nbr)
println(merge(busnbrs,time_vec))

