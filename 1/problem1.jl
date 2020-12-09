function readdata()
    words = readlines("input.txt")
    vec = Vector{Integer}(undef,length(words))
    for i = 1:length(words)
        vec[i] = parse(Int,words[i])
    end
    return vec
end


function part1(target,vec)
    low_i = 1
    high_i = length(vec)
    done = false
    while !done && low_i <= high_i
        low = vec[low_i]
        high = vec[high_i]
        if low+high == target
            return (low*high)
            done = true
        elseif low+high <target
            low_i = low_i + 1
        else
            high_i = high_i-1
        end
    end
    return 0;
end

function part2(vec)
    for i = 1:length(vec)-2
        res = 0;
        if i == 1
            res = part1(2020-vec[i],vec[2:length(vec)])
        else
            res = part1(2020-vec[i],vec[1:i-1,i+1:length(vec)])
        end
        if res != 0
            return res*vec[i]
        end
    end
end