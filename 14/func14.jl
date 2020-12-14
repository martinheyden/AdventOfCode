### Same convention as in mask, i.e bigest bit first

function to_binary!(nbr,vec)
    x = 2^35
    for i = 1:length(vec)
        vec[i] = floor(nbr/x)
        nbr = mod(nbr,x)
        x = x/2
    end
end

function from_binary(vec)
    x = 2^35
    nbr = 0
    for i = 1:length(vec)
        nbr += x*vec[i]
        x = x/2
    end
    return nbr
end

function read_map_nbr(str)
    second_bracket = findnext(']',str,5)
    mem_slot = parse(Int,str[5:second_bracket-1])
    eq_in = findfirst('=',str)
    nbr = parse(Int,str[eq_in+2:end])
    return mem_slot,nbr
end

function generate_mask_map(str)
    function map_fun(vec_enum)#Lexical scope (hopefully...)
        if str[vec_enum[1]] == 'X'
            return vec_enum[2]
        else
            return parse(Int,str[vec_enum[1]])
        end
    end
    return map_fun
end

function parse_data(str_list)
    mem = Dict{Int64,Int64}() #dont really understand how large mem can be...
    mask_map = nothing
    vec1 = zeros(36)
    vec2 = zeros(36) #TODO this preallocation does nothing
    for i = 1:length(str_list)
        if str_list[i][1:4] == "mask"
            mask_map = generate_mask_map(str_list[i][8:end])
        else
            mem_slot, nbr = read_map_nbr(str_list[i])
            to_binary!(nbr,vec)
            vec2 = map(mask_map,enumerate(vec)) #cant get this to work using map!()
            mem[mem_slot] = from_binary(vec2)
        end
    end
    return mem
end

function generate_mask_map2(str)
    function map_fun(vec_enum)#Lexical scope (hopefully...)
        if str[vec_enum[1]] == 'X'
            return -1 #encodes floating bit
        elseif str[vec_enum[1]] == '1'
            return 1
        else
            vec_enum[2]
        end
    end
    return map_fun
end

function find_mem(vec)
    x = 2^35
    nbrs = [0]
    for i = 1:length(vec)
        for j = 1:length(nbrs)
            if vec[i] == -1
                append!(nbrs,nbrs[j]) #corresponds to zero bit
                nbrs[j] += x*1 #corresponds to one bit
            else
                nbrs[j] += x*vec[i]
            end
        end
        x = x/2
    end
    return nbrs
end


function parse_data2(str_list)
    mem = Dict{Int64,Int64}()#zeros(Int,100000) #dont really understand how large mem can be...
    mask_map = nothing
    vec1 = zeros(36)
    vec2 = zeros(36) #TODO this preallocation does nothing
    for i = 1:length(str_list)
        if str_list[i][1:4] == "mask"
            mask_map = generate_mask_map2(str_list[i][8:end])
        else
            mem_slot, nbr = read_map_nbr(str_list[i])
            to_binary!(mem_slot,vec)
            vec2 = map(mask_map,enumerate(vec))
            for i in find_mem(vec2)
                mem[i] = nbr
            end
        end
    end
    return mem
end

        

