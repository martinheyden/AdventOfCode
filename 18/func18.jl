#To be able to use split for everything
function improve_string(str)
    return replace(replace(str,"("=>"( "),")"=>" )")
end

function find_sum(file_name,plusprio)
    lines = readlines(file_name)
    sum = 0
    for l in lines
        sum += evaluate_operators!(split(improve_string(l)," "),0,+,plusprio)
    end
    return sum
end
#Takes a list of operators (array of string)
#f either + or *. Should be + for first call so that a number result in nbr+0 = nbr
function evaluate_operators!(operators,current,f,plusprio)
    if length(operators) == 0
        return current
    end
    op = popfirst!(operators)
    if op == "+"
        return evaluate_operators!(operators,current,+,plusprio)
    elseif op == "*"
        if plusprio #Then evaluate each side first
            return  current * evaluate_operators!(operators,0,+,plusprio)
        else #Otherwise keep going
            return  evaluate_operators!(operators,current,*,plusprio)
        end
    elseif op == "("#Evaluate expression inside parenthesis
        sub_expr = evaluate_operators!(operators,0,+,plusprio)
        evaluate_operators!(operators,f(current,sub_expr),nothing,plusprio)
    elseif op == ")"
        return current
    else #Apply stores f (either + or *) to current and the number 
        return  evaluate_operators!(operators,f(parse(Int,op),current),nothing,plusprio)
    end
end
