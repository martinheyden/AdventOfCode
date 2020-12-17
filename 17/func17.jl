#First coordinate is x, second y third z
function read_input(file_name)
    lines = readlines(file_name)
    nbr_rows = length(lines)
    nbr_cols = length(lines[1])
    slice = zeros(Int,nbr_rows,nbr_cols);
    for x = 1:nbr_rows, y = 1:nbr_cols
        if lines[x][y] == '#'
            slice[x,y] = 1
        end
    end
    return slice
end

# Returns touple (x0,y0,z0 (w0)) desrcribing the position of the origin in the data array
#Initialized data array (dims dim) of sufficient size to never have to worry about initial cases
function init_grid(slice,dims = 3)
    (x0_size,y0_size) = size(slice) 
    z0_size = 1;
    config_size =  (x0_size+8*2,y0_size+8*2, (ntuple(i->0,dims-2) .+8 .*2)...)
    config = zeros(config_size)
    p0 = Int.( map(floor,config_size./2) .- (floor(x0_size/2),floor(y0_size/2),ntuple(i->0,dims-2)...))
    #third (and possible forth) coordinate are always zero
    for cord in Iterators.product(0:(x0_size-1),0:(y0_size-1),ntuple(i->0,dims-2)...)
        config[(p0 .+ cord)...] = slice[(cord[1:2].+[1,1])...]
    end
    return config,p0,ntuple(i->-1,dims),(x0_size+1,y0_size+1,ntuple(i->1,dims-2)...)
end

#Assumes pos is not at the boundary of config
function get_new_state(pos,config,dims = 3)
    #Count neighbours (including self)
    count = 0
    ss = [-1,0,1]
    #Loop over ss in each dim
    for dp = Iterators.product(ntuple(i->ss, dims)...)
        count += config[(pos .+dp)...]
    end
    #Check if should be active
    if (config[pos...] == 1 && (count==3 || count ==4)) #Countint itself.
        return 1
    end
    if (config[pos...] == 0 && count ==3)
        return 1
    end
    #Otherwise inactive
    return 0
end


function update!(old_config, new_config, p0, pmin, pmax,dims = 3)
    #Loop from pmin to pmax in each dimension
    for pos in Iterators.product(ntuple(i->collect(pmin[i]:pmax[i]),dims)...)
        pos = p0.+pos
        new_config[pos...] = get_new_state(pos,old_config,dims)
    end
end

function simulate_cycles(file_name,dims = 3)
    config,p0,pmin,pmax = init_grid(read_input(file_name),dims)
    new_config = copy(config)
    for i = 1:6
        update!(config,new_config,p0,pmin,pmax,dims)
        pmin = map(x->x-1,pmin)#Pmin and pmax increased every loop
        pmax = map(x->x+1,pmax)
        tmp = new_config
        new_config = config
        config = tmp
    end
    return sum(config)
end
