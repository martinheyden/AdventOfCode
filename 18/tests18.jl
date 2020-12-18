include("func18.jl")
op0 = split("1 + 2 + 3 + 4"," ")
@assert evaluate_operators!(copy(op0),0,+)==10
op0 = split("1 * 2 * 3 * 4"," ")
@assert evaluate_operators!(copy(op0),0,+)==24
op1 = split("1 + 2 * 3 + 4 * 5 + 6"," ")
@assert evaluate_operators!(copy(op1),0,+)==71
op2 = split(improve_string("1 + (2 * 3) + (4 * (5 + 6))"))
@assert evaluate_operators!(copy(op2),0,+)==51

@assert evaluate_operators2!(copy(op1),0,+)==231