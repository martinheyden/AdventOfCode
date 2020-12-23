include("func23_2.jl")

# e,ett = get_initial_config("12345",5)
# @time do_n_steps(e, 3, 100)
e,ett = get_initial_config("624397158",9)
@time do_n_steps(e, 9, 100)
println(convert_to_array(e))

e,ett = get_initial_config("624397158",Int(1e6))
@time do_n_steps(e, Int(1e6), Int(1e7))
println(ett.next.value*ett.next.next.value)