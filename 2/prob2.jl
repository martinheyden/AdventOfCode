function readdata()
    lines = readlines("input.txt")
    nbr_pw = length(lines)
    pw_vec = Vector{String}(undef,nbr_pw)
    low_vec = Vector{Integer}(undef,nbr_pw)
    high_vec = Vector{Integer}(undef,nbr_pw)
    char_vec = Vector{Char}(undef,nbr_pw)
    for i = 1 :nbr_pw
        line = lines[i];
        dash_index = findfirst(isequal('-'),lines[i])
        first_space_index = findfirst(isequal(' '),lines[i])
        second_space_index = findnext(isequal(' '),lines[i],first_space_index+1)
        low_vec[i] = parse(Int,line[1:dash_index-1]);
        high_vec[i] = parse(Int,line[dash_index+1:first_space_index-1])
        char_vec[i] = line[first_space_index+1];
        pw_vec[i] = line[second_space_index+1:end]
    end
    
    return low_vec, high_vec, char_vec, pw_vec

end

function part1(low_vec::Vector{Integer},high_vec::Vector{Integer},char_vec::Vector{Char},pw_vec::Vector{String})
    count = 0;
    for i = 1:length(low_vec)
        nbr_char = length(findall(isequal(char_vec[i]),pw_vec[i]));
        if nbr_char >= low_vec[i] && nbr_char <= high_vec[i]
            count = count +1;
        end
    end
    return count
end

function part2(low_vec::Vector{Integer},high_vec::Vector{Integer},char_vec::Vector{Char},pw_vec::Vector{String})
    count = 0
    for i = 1:length(low_vec)
        pw = pw_vec[i]
        b1 = isequal(pw[low_vec[i]],char_vec[i])
        b2 = isequal(pw[high_vec[i]],char_vec[i])
        if (b1 && !b2) || (!b1 && b2)
            count = count+1;
        end
    end
    return count
end

println(part1(readdata()...))
println(part2(readdata()...))


