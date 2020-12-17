
function find_nth(init_list,len)
    last_said_dict = Dict{Int,Int}()
    for i = 1:length(init_list)-1
        last_said_dict[init_list[i]] = i
    end
    last_nbr = init_list[end]
    for t = (length(init_list)):(len-1)
        last_spoken = get(last_said_dict,last_nbr,-1)
        last_said_dict[last_nbr] = t
        if last_spoken == -1
            last_nbr = 0
        else
            last_nbr = t-last_spoken
        end
    end
    return last_nbr
end