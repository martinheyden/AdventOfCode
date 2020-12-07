
#Returns a graph (i.e a set of directed un-weighted edges). golden bag is always the first node.
#If a blue bag can be inside a red one then there is an edge from the blue bag to the red.
function readdata(dirr)
    lines = readlines("input.txt")
    dictionary = Dict{String,Integer}()
    graph = Array{Array{Tuple{Integer,Integer},1},1}();  #First is node, second is weight
    push!(dictionary, "shiny gold" => 1)
    push!(graph,Array{Integer,1}())
    nbr_nodes = 1
    for i = 1:length(lines)
        inds = findnext(" bags",lines[i],1)
        dest_name = lines[i][1:inds[1]-1];
        dest, nbr_nodes = getkey!(dictionary,dest_name,nbr_nodes,graph)
        go_on = true
        while go_on
            next_number = findnext(r"\d",lines[i],inds[end]+1)
            if next_number === nothing
                go_on = false;
            else
                weight = parse(Int,lines[i][next_number])
                inds = findnext(" bag",lines[i],next_number[1])
                source_name = lines[i][next_number[1]+2:inds[1]-1]
                source,nbr_nodes = getkey!(dictionary,source_name,nbr_nodes,graph)
                if dirr == 0
                    push!(graph[source],(dest,1)) #no risk of duplicates.
                else
                    push!(graph[dest],(source,weight))
                end
            end
        end
    end

    return graph

end

function getkey!(dict,key,nbr_nodes,graph)
    node = get(dict,key,-1)
    if node >0
        return node, nbr_nodes
    else
        nbr_nodes = nbr_nodes+1
        push!(dict, key => nbr_nodes)
        push!(graph,Array{Integer,1}())
        return nbr_nodes, nbr_nodes
    end
    
end

#Part a, dont count duplicates
function find_ancestors!(graph, node, node_list)
    count = 0
    for i = 1:length(graph[node])
        new_node = pop!(graph[node])[1]
        node_list[new_node] = 1 
        find_ancestors!(graph,new_node,node_list) #Can handle cycles, i think
    end
end
        
#Part b, "count" duplicates
#Have to assume no cycles
function find_internal(graph, node)
    count = 0
    children = graph[node]

    for i = 1:length(children)
        child = children[i][1]
        weight = children[i][2]
        count = count + find_internal(graph,child)*weight
    end
    return 1+count #NOTE counts the golden bag aswell

end

graph = readdata(0)
node_list = zeros(length(graph))
find_ancestors!(graph,1,node_list)
println(sum(node_list))

graph2 = readdata(1)
println(find_internal(graph2,1)-1)