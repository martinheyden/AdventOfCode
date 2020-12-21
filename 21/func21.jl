# Returns dicts maping the allergens and ingr to integers
# And a tuple(ingr,all) coding eacn line in the data using the maping
function parse_data(lines)
    allergy_dict = Dict{String,Int}()
    ingr_dict = Dict{String,Int}()
    data = Array{Tuple{Array{Int,1},Array{Int,1}},1}()
    for line in lines
        ingr_vec = Array{Int,1}()
        alergy_vec = Array{Int,1}()
        s1, s2 = split(line," (")
        ingridients = split(s1," ")
        for ingr in ingridients
            ingr_num = get(ingr_dict,ingr,-1)
            if ingr_num == -1
                ingr_num = length(ingr_dict)+1
                ingr_dict[ingr] = ingr_num
            end
            push!(ingr_vec,ingr_num)
        end
        alergens = split(s2[length("contains  "):end-1],", ")
        for alerg in alergens
            alerg_num = get(allergy_dict,alerg,-1)
            if alerg_num == -1
                alerg_num = length(allergy_dict)+1
                allergy_dict[alerg] = alerg_num
            end
            push!(alergy_vec,alerg_num)
        end
        push!(data,(ingr_vec,alergy_vec))
    end
    return data,allergy_dict,ingr_dict
end

# Returns the possible sources for each allergens.
function find_possible_sources(data, nbr_ingr, nbr_allerg)
    alergs_set_array = Array{Set{Int},1}(undef,nbr_allerg)
    for i = 1:nbr_allerg
        alergs_set_array[i] = Set{Int}(1:nbr_ingr)
    end
    for d in data
        for alerg in d[2]
            intersect!(alergs_set_array[alerg],d[1])
        end
    end
    return alergs_set_array
end

# Returns all ingredients that can not be allergens
function find_safe_ingr(nbr_ingr, alergs_set_array)
    safe_set = Set{Int}(1:nbr_ingr)
    for unsafe in alergs_set_array
        setdiff!(safe_set,unsafe)
    end
    return safe_set
end

# Task 1...
function count_safe_occurance(data,safe_set)
    count = 0;
    for d in data
        for ingr in safe_set
            if ingr in d[1]
                count = count+1
            end
        end
    end
    return count
end

# Find the possible sources of each allergens (as a map from alergens to ingredients)
# Will give the unique sulotion if it exists.
function find_possible_allergs(alergs_set_array)
    alergs_set_array = copy(alergs_set_array)
    unique_map = Dict{Int,Int}()
    while true
        unique_index,unique_key = find_unique(alergs_set_array)
        if unique_index == -1
            break
        else
            unique_map[unique_index] = unique_key
            for set in alergs_set_array
                setdiff!(set,unique_key)
            end
        end
    end
    return unique_map, alergs_set_array
end

# Finds the element in alergs_set_array that has a set of size 1
function find_unique(alergs_set_array)
    for i = 1:length(alergs_set_array)
        if length(alergs_set_array[i])==1
            return i,first(alergs_set_array[i])
        end
    end
    return -1,-1
end

# Problem 2
function generate_canonical_list(unique_map,ingr_map,alerg_map)
    # Reverse the dicts
    ingr_map = Dict(ingr_map[k] => k for k in keys(ingr_map))
    alerg_map = Dict(alerg_map[k] => k for k in keys(alerg_map))
    ar = Array{Tuple{String,String},1}()
    for key in keys(unique_map)
        push!(ar,(alerg_map[key],ingr_map[unique_map[key]]))
    end
    sort!(ar) #Sorts on first argument(allergens)
    mes = mapreduce(i->i[2],(i,j) ->string(i,",",j),ar)
    return mes
end
        