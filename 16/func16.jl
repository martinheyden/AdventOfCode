
#Returns    - rules as an Array of Array of Tuples
#           - My ticket as an Array
#           - nearby tickets as Array of Arrays
function read_data(filename)
    lines = readlines(filename)
    #Rules
    rules_array = Array{Array{Tuple,1},1}();
    line = 1;
    rule = ((0,0),(0,0))
    while !(lines[line] == "")
        ind = findfirst(':',lines[line])
        ranges = split(lines[line][ind+2:end]," or ")
        rule_array = Array{Tuple,1}()
        for i = 1:2
            nbrs = split(ranges[i],"-")
            push!(rule_array,(parse(Int,nbrs[1]),parse(Int,nbrs[2])))
        end
        push!(rules_array,rule_array)
        line = line+1
    end
    #My ticket
    line = line+2
    my_ticket_array  = map(x->parse(Int,x),split(lines[line],","))
    #Nearby tickets
    tickets_array = Array{Array{Int,1},1}();
    line = line+3
    while line <= length(lines)
        push!(tickets_array,map(x->parse(Int,x),split(lines[line],",")))
        line+=1
    end
    return rules_array, my_ticket_array, tickets_array
end

function in_range(i,range_touples)
    if ((i>= (range_touples[1][1]) && i<= (range_touples[1][2])) ||
        (i>= (range_touples[2][1]) && i<= (range_touples[2][2])))
        return true
    else
        return false
    end
end

function in_range_of_rules(i,rules)
    for range_touples in rules
        if in_range(i,range_touples)
            return true
        end
    end
    return false
end

#Checks if each ticket field is at least valid for one rule
#returns the sum of all values that doesnt satisfy a rule
function check_ticket(ticket,rules)
    sum = 0
    for nbr in ticket
        if !in_range_of_rules(nbr,rules)
            sum+=nbr
        end
    end
    return sum
end

function check_tickets(tickets,rules)
    return sum(map(x->check_ticket(x,rules),tickets))
end

function get_valid_tickets(tickets,rules)
    valid_tickets = Array{Array{Int,1},1}()
    for ticket in tickets
        if check_ticket(ticket,rules) == 0
            push!(valid_tickets,ticket)
        end
    end
    return valid_tickets
end

#Get all possible fields for each rule
function get_possible_field_maps(tickets,rules)
    rules_map = Array{Array{Int,1},1}()#from rule to field
    for r = 1:length(rules)
        rule_map = Array{Int,1}()
        for pos = 1:length(tickets[1])
            rule_pos = -1
            found = true
            for ticket in tickets
                if !in_range(ticket[pos],rules[r])
                    found = false; 
                    break #Break for ticket loop
                end
            end
            if found
                push!(rule_map,pos)
            end
        end #end for pos
        push!(rules_map,rule_map)
    end 
    return rules_map
end


#Assigns a field to a rule if that is the only possible field for that rule.
#THen remove the field from all other rules, and tries fo find new rule
#Should find all if the solution is unique
function get_uniques!(rules_map,unique_map)
    go_on =true
    while go_on
        go_on = false
        for i =1:length(unique_map)
            if unique_map[i] == 0 
                if length(rules_map[i]) == 1
                    go_on = true
                    unique_map[i] = rules_map[i][1]
                    println(rules_map[i])
                    remove_i!(rules_map,rules_map[i][1])
                    break
                end
            end
        end
    end
end

function remove_i!(rules_map,val)
    for i = 1:length(rules_map)
        rule_map = rules_map[i]
        i_ind = findnext(x->x==val,rule_map,1)
        if !(i_ind===nothing)
            deleteat!(rule_map,i_ind)
        end
    end
end


function get_depart_prod(my_ticket,rule_map)
    prod = 1
    for i =1:6
        prod *= my_ticket[rule_map[i]]
    end
    return prod
end
        




        
            
