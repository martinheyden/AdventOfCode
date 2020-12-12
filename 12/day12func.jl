#Stores data as an array of (Char,Int) Tuples
read_data(file) =  map(str-> (str[1],parse(Int,str[2:end])),readlines(file))

#Dir 0 -> east, Dir 2 = north, dir 3 = west, dir 4 = south
function move_ship(actions,posx,posy,dir)
    dirs = ['E','N','W','S']
    if length(actions) ==0
        return (posx,posy)
    end
    (cmd,val) = popfirst!(actions)
    if cmd == 'F'#Corresdponds to one of E N W S
        cmd = dirs[dir+1]
    end
    if cmd == 'N'
        return move_ship(actions,posx,posy+val,dir)
    elseif cmd == 'S'
        return move_ship(actions,posx,posy-val,dir)
    elseif cmd == 'E'
        return move_ship(actions,posx+val,posy,dir)
    elseif cmd == 'W'
        return move_ship(actions,posx-val,posy,dir)
    elseif cmd == 'L'
        return move_ship(actions,posx,posy,mod(dir+div(val,90),4))
    elseif cmd == 'R'
        return move_ship(actions,posx,posy,mod(dir-div(val,90),4))
    end
end

function move_ship2(actions,posx,posy,wx,wy)
    if length(actions) ==0
        return (posx,posy)
    end
    (cmd,val) = popfirst!(actions)
    if cmd == 'R'
        val = 360-val
        cmd = 'L'
    end
    if cmd == 'N'
        return move_ship2(actions,posx,posy,wx,wy+val)
    elseif cmd == 'S'
        return move_ship2(actions,posx,posy,wx,wy-val,)
    elseif cmd == 'E'
        return move_ship2(actions,posx,posy,wx+val,wy)
    elseif cmd == 'W'
        return move_ship2(actions,posx,posy,wx-val,wy)
    elseif cmd == 'L'
        (wx,wy) = turn_left(wx,wy,val) 
        return move_ship2(actions,posx,posy,wx,wy)
    elseif cmd == 'F'
        return move_ship2(actions,posx+wx*val,posy+wy*val,wx,wy)
    end
end


#We can consider (wx,wy) = r(cos(a),sin(a))
#Noting that (cos(a + 90) = -sin(a)) and sin(a+90) = cos(a)
#Gives the following
function turn_left(wx,wy,val)
    if val == 180
        return (-wx,-wy)
    elseif val == 90
        (-wy,wx)
    elseif val == 270
        return (wy,-wx)
    else
        error("undefined behaviour")
    end
end
