function read_data(file)
    lines = readlines(file)
    time = parse(Int,lines[1])
    time_vec = Array{Integer,1}()
    busnbr = Array{Integer,1}()
    prev_c = 0
    next_c = findnext(',',lines[2],1)
    t = 0
    while !(next_c===nothing)
        if !(lines[2][prev_c+1] == 'x')
            push!(busnbr,parse(Int,lines[2][prev_c+1:next_c-1]))
            push!(time_vec,t)
        end
        prev_c = next_c
        next_c = findnext(',',lines[2],prev_c+1)
        t= t+1
    end
    if !(lines[2][prev_c+1] == 'x')
        push!(busnbr,parse(Int,lines[2][prev_c+1:end]))
        push!(time_vec,t)
    end
    return time, busnbr,time_vec
end

function time_to_wait(time,busnbrs,cur_wait,cur_nbr)
    if length(busnbrs)== 0
        return(cur_wait,cur_nbr)
    else
        bus = pop!(busnbrs)
        wait = bus-mod(time,bus)
        if wait<cur_wait
            return time_to_wait(time,busnbrs,wait,bus)
        else
            return time_to_wait(time,busnbrs,cur_wait,cur_nbr)
        end
    end
end

function merge(nbrs,timevec)
    start_agg = nbrs[1]
    period_agg = nbrs[1]
    for i = 2:length(nbrs)
        s2 = floor(start_agg/nbrs[i])*nbrs[i]
        while start_agg!=s2-timevec[i]
            if start_agg<s2-timevec[i]
                start_agg += period_agg
            else
                s2 += ceil((start_agg-(s2-timevec[i]))/nbrs[i])*nbrs[i]
            end
        end
        period_agg = lcm(period_agg,nbrs[i])
    end
    return start_agg
end


