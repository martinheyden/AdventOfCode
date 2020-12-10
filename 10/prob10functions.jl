
#Find the difference between each consecutive element in nbrs. Assume that the maximum difference is equal to the size of diff_array
function find_differences!(nbrs,diff_array,ind)
    diff_array[nbrs[ind]-nbrs[ind-1]] = diff_array[nbrs[ind]-nbrs[ind-1]] +1
    if ind >2
        find_differences!(nbrs,diff_array,ind-1)
    end
end

#Fin all possible ways from each number to 0, given that the max difference is max_diff
# (Basically dynamic programming)
function find_configurations!(nbrs,nbr_path,index,max_diff = 3)
    nbr_path[index] = sum(map(ind-> (nbrs[index] - nbrs[index-ind] <= max_diff)*nbr_path[index-ind],
        Array(1:min(max_diff,index-1)))) #For the first max_diff nodes we only check until the first node to avoid out of bounds errors.
    if index < length(nbrs)
        find_configurations!(nbrs,nbr_path,index+1)
    end
end