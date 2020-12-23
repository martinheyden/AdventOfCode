using DataStructures
include("func22.jl")
deck1,deck2 = generate_decks("input.txt")
res = play_game(deck1,deck2)
println(count_score(res))
deck1,deck2 = generate_decks_array("input.txt")
winner = play_game2(deck1,deck2,Array{Tuple{Array{Int,1},Array{Int,1}},1}())
if winner == 1
    println(count_score(deck1))
else
    println(count_score(deck2))
end