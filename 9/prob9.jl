include("../1/problem1.jl")


function find_error(nbrs,curr,mem)
    if (part1(nbrs[curr],sort(nbrs[curr-mem:curr-1])) ==0)
        return nbrs[curr]
    else
        return find_error(nbrs,curr+1,mem)
    end
end

function find_sum(nbrs,target,sum,i1,i2)
    if sum == target
        return minimum(nbrs[i1:i2])+maximum(nbrs[i1:i2])
    elseif sum<target
        return find_sum(nbrs,target,sum+nbrs[i2+1],i1,i2+1)

    else #sum>target
        return find_sum(nbrs,target,sum-nbrs[i1],i1+1,i2)
    end
end

data =  readdata()
err = find_error(data,26,25)
println(err)
println(find_sum(data,err,data[1]+data[2],1,2))
