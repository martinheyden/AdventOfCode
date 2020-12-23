mutable struct Element
    prev::Union{Int,Element}
    next::Union{Int,Element}
    minus_one::Union{Int,Element}
    value::Int
end

function convert_to_array(element)
    ar = Array{Int,1}()
    push!(ar,element.value)
    cur = element.next
    while cur.value!=element.value
        push!(ar,cur.value)
        cur = cur.next
    end
    return ar
end

function my_mod(x::Int,y)
    if x<1
        return my_mod(x+y,y)
    elseif x>y
        return my_mod(x-y,y)
    else
        return x
    end  
end

function get_initial_config(str,nbr_el)
    e1 = Element(-1,-1,-1,parse(Int,str[1]))
    prev = e1
    one = Element(-10,-10,-10,1)
    e = Element(-1,-1,-1,1)
    defined_by_str = Array{Element,1}(undef,length(str))
    defined_by_str[parse(Int,str[1])] = e1
    for i =2:length(str)
        e= Element(prev,-1,-1,parse(Int,str[i]))
        prev.next = e
        prev = e
        if e.value==1
            one = e
        end
        defined_by_str[parse(Int,str[i])] = e
    end
    for i = length(str)+1:nbr_el
        e= Element(prev,-1,prev,i) #will be wrong for node 10, but we fix later
        prev.next = e
        prev = e
    end
    e.next = e1
    e1.prev = e
    e_end = e;
    e = e1
    for i = 1:(9+(nbr_el>length(str)))
        if e.value == 1
            e.minus_one = e_end
        else
            e.minus_one = defined_by_str[e.value-1]
        end
        if e.minus_one == -1
            error("problem ", e.value)
        end
        e = e.next
    end
    return e1,one
end

function update_config(current::Element,len)
    first_move = current.next
    middle_move = first_move.next
    last_move = middle_move.next
    pick_up_cup = [first_move.value, middle_move.value, last_move.value]
    dest_node = current.minus_one
    while true
        if !(dest_node.value in pick_up_cup)
            break
        end
        if dest_node.value == current.value
            error("couldnt find destination cup")
        end
        dest_node = dest_node.minus_one
    end
    current.next = last_move.next
    last_move.next.prev = current
    first_move.prev = dest_node
    last_move.next = dest_node.next
    dest_node.next = first_move
    last_move.next.prev=last_move
    return current.next 
end

function do_n_steps(first_curr::Element,len,max_step)
    curr = first_curr
    for i = 1:max_step
        # if i%10000 == 0
        #     println(i)
        # end
        update_config(curr,len)
        curr = curr.next

    end
end