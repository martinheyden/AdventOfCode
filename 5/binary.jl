function read_data()
    lines = readlines("input.txt")
    seatings = Array{Tuple{Integer,Integer},1}(undef,length(lines))
    for i = 1:length(lines)
        seatings[i] = (parse_binary(lines[i][1:7],'B'),parse_binary(lines[i][8:10],'R'))
    end
    return seatings
end

function parse_binary(str,one_char)
    len = length(str)
    base = 2^(len-1)
    nbr = 0
    for i = 1:len
        if str[i] == one_char
            nbr = nbr+base
        end
        base = base/2
    end
    return nbr
end

function find_max_seat_id(seatings::Array{Tuple{Integer,Integer}})
    max = 0
    function comp(seat1,seat2)
        if seat1[1]*8+seat1[2]>seat2[1]*8+seat2[2]
            return seat1
        else
            return seat2
        end
    end
    return foldl(comp,seatings)
end

function find_max_seat_id2(seatings::Array{Tuple{Integer,Integer}})
   return mapreduce(x->x[1]*8+x[2],(x,y)->max(x,y) ,seatings)
end

function find_missing_seat_id(seatings)
    ids = map(x->x[1]*8+x[2],seatings);
    sort!(ids)
    for i = ids[1]:ids[end-1]
        if ids[i+1]-ids[i] != 1
            return ids[i]+1
        end
    end
end

println(find_max_seat_id2(read_data()))
println(find_missing_seat_id(read_data()))
