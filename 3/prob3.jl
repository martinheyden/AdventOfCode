function read_data()
    lines = readlines("input.txt")
    nbr_lines = length(lines)
    width = length(lines[1])
    tree_mat = Array{Bool,2}(undef,nbr_lines,width)
    for i = 1:nbr_lines
        line = lines[i]
        for j  = 1:width
            if isequal('#',line[j])
                tree_mat[i,j] = true
            else
                tree_mat[i,j] = false
            end
        end
    end
    return tree_mat
    
end

function part1(map,dx,dy)
    (length, width)  = size(map)
    x = 1
    y = 1
    count = 0
    while y <length
        y = y+dy;
        x = x + dx
        if x > width
            x = mod(x,width)
        end
        if map[y,x]
            count = count+1
        end
    end
    return count
end

function part2(map,d_vec)
    prod = 1;
    for i = 1:length(d_vec)
        (dx,dy) = d_vec[i]
        prod = prod*part1(map,dx,dy)
    end
    return prod
end

print("part1: ")
println(part1(read_data(),3,1))
d_vec = [(1,1),(3,1),(5,1),(7,1),(1,2)]
print("Part 2: ")
println(part2(read_data(),d_vec))
