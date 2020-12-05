function read_data()
    passports = Array{Array,1}(undef,0)
    lines = readlines("input.txt")
    passport = Array{Tuple{String,String},1}(undef,0)
    for line_ind = 1:length(lines)
        line = lines[line_ind]
        if length(line) ==0 # New passport
            push!(passports,sort!(passport))
            passport = Array{Tuple{String,String},1}(undef,0)
        else
            go_on = true
            ind = 1;
            while go_on
                ind_col = findnext(isequal(':'),line,ind)
                ind_blank = findnext(isequal(' '),line,ind_col)
                if ind_blank === nothing #If last element
                    ind_blank = length(line)+1
                    go_on = false
                end
                field_name = line[ind:ind_col-1]
                field_val = line[ind_col+1:ind_blank-1]
                if field_name != "cid" #We will never look at cid, so lets not store it
                    push!(passport,(field_name,field_val));
                end
                ind = ind_blank+1
            end
        end
    end
    return passports
end

function get_valid_wrt_fields(passports)
    valid = Array{Integer}(undef,0);
    size_7 = ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"]
    for i = 1:length(passports)
        passport = passports[i]
        fields = map(x->x[1],passport)
        if length(fields) == 7
            if fields == size_7
                push!(valid,i)
            end
        end
    end
    return valid
end

function get_valid_wrt_values(passports)
    count = 0;
    valid = get_valid_wrt_fields(passports);
    for i = 1:length(valid)
        passport = passports[valid[i]]
        ### Birth Year ###
        birth_year = parse(Int,passport[1][2])
        if !(birth_year >1919 && birth_year <2003)
            continue
        end
        ### eye color ### 
        if findfirst(isequal(passport[2][2]),["amb","blu","brn","gry","grn","hzl","oth"]) === nothing
            continue
        end
        ### Expiration Year ###
        exp_year = parse(Int,passport[3][2])
        if !(exp_year>=2020 && exp_year <=2030)
            continue
        end
        ### Hair Color ###
        str = passport[4][2]
        if str[1] != '#' || length(str)!=7
            continue
        end
        for i = 2:7
            if !('0' <= str[i] <= '9' || 'a'<= str[i]<= 'f')
                continue
            end
        end
        ### Height ###
        str = passport[5][2]
        len = length(str)
        unit = str[len-1:len]
        if !(unit == "cm" || unit == "in")
            continue
        end
        val = parse(Int,str[1:len-2])
        if unit == "cm"
            if !( val>=150 && val<= 193)
                continue
            end
        else
            if !(val>=59 && val <=76)
                continue
            end
        end
        ### Issue year ###
        issue_year = parse(Int,passport[6][2])
        if !(issue_year >=2010 && issue_year <=2020)
            continue
        end
        ### Passport ID ###
        str = passport[7][2]
        if (length(str) != 9)
            continue
        end
        for i = 1:4
            if !('0'<=str[i]<='9')
                continue
            end
        end
        count = count + 1
    end
    return count

end

println(length(get_valid_wrt_fields(read_data())))

println(get_valid_wrt_values(read_data()))