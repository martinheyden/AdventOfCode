#Returns seat_matrix wich is a boolean matrix describing where there are seats
#And occupation_matrix which starts 0 (so maybe unecessary?)
function read_input(file)
    lines = readlines(file);
    columns = length(lines[1])
    rows = length(lines)
    seat_matrix = Array{Bool,2}(undef,rows,columns)
    occupation_matrix = zeros(Int,rows,columns)
    for i = 1:rows, j =1:columns
            seat_matrix[i,j] = (lines[i][j] =='L')
    end
    return seat_matrix, occupation_matrix
end

function find_equilibrium!(old_seating,new_seating,neighbours,limit)
    changes = update_seatings!(old_seating,new_seating,neighbours,limit);
    if changes
        find_equilibrium!(new_seating,old_seating,neighbours,limit)
    end
end

function update_seatings!(old_seating,new_seating,neighbour_list,limit)
    (rows,cols) = size(old_seating)
    changes = false
    for ((i,j),neighbours) in neighbour_list
        new_seating[i,j] = get_new_seat(i,j,old_seating,neighbours,limit)
        if (!changes &&new_seating[i,j]!=old_seating[i,j])
            changes = true
        end
    end
    return changes
end

function get_new_seat(i,j,old_seating,neighbours,limit)
    n = sum(map(p->old_seating[p[1],p[2]],neighbours)) #number of occupied neighbours
    if (old_seating[i,j] == 0 && n ==0)
        return 1
    elseif (old_seating[i,j] == 1 && n>= limit)
        return 0
    else
        return old_seating[i,j]
    end
end

function find_neighbours(seat_mat,neighbour_func)
    (rows,cols) = size(seat_mat)
    neighbours = Array{Tuple{Tuple,Array},1}()
    for i = 1:rows, j = 1:cols
        if  seat_mat[i,j]
            push!(neighbours,((i,j) ,Array{Tuple{Int,Int},1}()))
            for di = -1:1, dj = -1:1
                if (di !=0 || dj != 0) 
                    neighbour = neighbour_func(seat_mat,i,j,di,dj);
                    if !(neighbour === nothing)
                        push!(neighbours[end][2],neighbour)
                    end
                end
            end
        end
    end
    return neighbours;
end

function adjacent_neighbour(seat_mat,i,j,di,dj)
    (rows,cols) = size(seat_mat)
    if (i+di>0 &&i+di<=rows && j+dj>0 && j+dj<=cols)
        if seat_mat[i+di,j+dj] == true
            return(i+di,j+dj)
        end
    else
        return nothing
    end
end

function direction_neighbour(seat_mat,i,j,di,dj)
    (rows,cols) = size(seat_mat)
    if (i+di>0 &&i+di<=rows && j+dj>0 && j+dj<=cols)
        if seat_mat[i+di,j+dj] == true #If seat is found
            return(i+di,j+dj)
        else #Else continue in same direction
            return direction_neighbour(seat_mat,i+di,j+dj,di,dj)
        end
    else#Reached an edge.
        return nothing
    end
end