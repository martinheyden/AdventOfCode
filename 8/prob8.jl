#Checks if there is a loop
#visits keeps track of nodes that has been visited. Last element is true if no cycle
#Return accumulator value at first cycle, or when finished
function find_loop!(instructions, pos, visits)
    (d_acc,acc_sign,d_line,line_sign) = read_instr(instructions[pos])
    new_pos = line_sign(pos,d_line);
    if new_pos ==length(instructions) +1
        visits[end] = true #No cycle
        return acc_sign(0,d_acc)
    elseif new_pos >length(instructions)+1#Non valid set of instructions
        return 0;
    elseif visits[new_pos] == true #Cycle detected
        return acc_sign(0,d_acc);
    else
        visits[new_pos] = true
        return acc_sign(0,d_acc) + find_loop!(instructions,new_pos,visits)
    end
end

#Find the order of the commands in the original loop
#(A bit overkill, could just loop over all instructions...)
function find_first_loop!(instructions,order,pos)
    (d_acc,acc_sign,d_line,line_sign) = read_instr(instructions[pos])
    new_pos = line_sign(pos,d_line);
    if !(new_pos in order)
        push!(order,new_pos)
        find_first_loop!(instructions,order,new_pos)
    end
end

function fix_loop_setup(instructions)
    order = [1];
    visits = Array{Bool,1}(undef,length(instructions)+1) #To only allocate it once
    find_first_loop!(instructions,order,1);
    fix_loop(instructions,order,visits)
end

function fix_loop(instructions,order,visits)
    if length(order) == 0
        error("could not fix loop")
    else
        instr = pop!(order) #Change the instructions that was in the loop
        if instructions[instr][1:3] == "acc"
            return fix_loop(instructions,order,visits)
        else
            map!(x->false,visits,visits) #Wierd syntax?
            updated_instructions = copy(instructions)
            old_instr = instructions[instr]
            if instructions[instr][1:3] == "jmp"
                instructions[instr] = string("nop", instructions[instr][4:end])
            else
                instructions[instr] = string("jmp", instructions[instr][4:end])
            end
            acc = find_loop!(instructions,1,visits)
            if visits[end] == true
                return acc
            else
                instructions[instr] = old_instr
                return fix_loop(instructions,order,visits)
            end
        end
    end
end

function read_instr(str)
    d_acc = 0
    acc_sign = +
    d_line = 1
    line_sign = +
    if str[5] == '+'
        opp = +
    else
        opp = -
    end
    if str[1:3] == "acc"
        acc_sign = opp;
        d_acc = parse(Int,str[6:end])
    elseif str[1:3] == "jmp"
        line_sign = opp;
        d_line = parse(Int,str[6:end])
    end#Already initialized correctly for  nop
    return (d_acc,acc_sign,d_line,line_sign)
end



lines = readlines("input.txt");
visits = map(x -> false, Array{Bool,1}(undef,length(lines)+1))
println(find_loop!(lines,1,visits))
println(fix_loop_setup(lines))