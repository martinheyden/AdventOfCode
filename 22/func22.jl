function generate_decks(filename)
    lines = readlines(filename)
    deck1 = Queue{Int}()
    deck2 = Queue{Int}()
    i = 2
    while lines[i]!= ""
        enqueue!(deck1,parse(Int,lines[i]))
        i = i+1
    end
    i = i+2
    while  i<= length(lines)
        enqueue!(deck2,parse(Int,lines[i]))
        i = i+1
    end
    return deck1,deck2
end

function generate_decks_array(filename)
    lines = readlines(filename)
    deck1 = Array{Int,1}()
    deck2 = Array{Int,1}()
    i = 2
    while lines[i]!= ""
        push!(deck1,parse(Int,lines[i]))
        i = i+1
    end
    i = i+2
    while  i<= length(lines)
        push!(deck2,parse(Int,lines[i]))
        i = i+1
    end
    return deck1,deck2
end

function play_game(deck1, deck2)
    while !isempty(deck1) && !isempty(deck2)
        c1 = dequeue!(deck1)
        c2 = dequeue!(deck2)

        if c1>c2
            enqueue!(deck1,c1)
            enqueue!(deck1,c2)
        elseif c2>c1
            enqueue!(deck2,c2)
            enqueue!(deck2,c1)
        else
            error("unexpected behaviour")
        end
    end
    if isempty(deck1)
        return deck2
    else
        return deck1
    end
end

#Assume deck is an array, Queue had some problems
function play_game2(deck1,deck2,mem)
    # println("New game")
    while true
        #println("deck1 ", deck1)
        #println("deck2 ", deck2)
        #Check win condition
        if has_happened(deck1,deck2,mem)
            return 1
        end
        if isempty(deck1)
            return 2
        end
        if isempty(deck2)
            return 1
        end
        #Update memory
        push!(mem,(copy(deck1),copy(deck2)))
        #Play round
        c1 = popfirst!(deck1)
        c2 = popfirst!(deck2)
        if length(deck1)>= c1 && length(deck2)>= c2 #Subround
            winner = play_game2(deck1[1:c1],deck2[1:c2],copy(mem))
        else #Normal Round
            if c1>c2
                winner = 1
            else
                winner = 2
            end
        end
        if winner == 1
            push!(deck1,c1)
            push!(deck1,c2)
        else
            push!(deck2,c2)
            push!(deck2,c1)
        end
    end
end

function has_happened(deck1, deck2, mem)
    for entry in mem
        if deck1 == entry[1] && deck2 == entry[2]
            return true
        end
    end
    return false
end

function count_score(deck::Queue{Int})
    score = 0
    len = length(deck)
    while !isempty(deck)
        score += len*dequeue!(deck)
        len -= 1
    end
    return score
end

function count_score(deck::Array{Int,1})
    score = 0
    len = length(deck)
    for i = 1:len
        score += len*deck[i]
        len -= 1
    end
    return score
end