function prob6(f)
    lines = readlines("input.txt")
    total_answers = 0 #Either all answer in group (part a) or same for all in group(part b)
    id_answers = Set(split(lines[1],"")) #The identified answers for a group
    i = 2;
    while i <=length(lines)
        line = lines[i]
        if length(line) == 0 #New group
            total_answers = total_answers + length(id_answers)
            i = i +1
            id_answers = Set(split(lines[i],""))
        else
            f(id_answers,Set(split(line,"")))
        end
        i = i + 1;
    end
    total_answers = total_answers + length(id_answers) #Not a blankspace after last group
    return total_answers
end


println(prob6(union!))
println(prob6(intersect!))