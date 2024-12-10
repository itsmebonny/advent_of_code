### Day 9 - Helping the amphipods

string_input = read("day_9/input.txt", String)


function separe_input(input::String)::Tuple{Vector{Char}, Vector{Char}}
    memory = Vector{Char}()
    free_space = Vector{Char}()
    for i in 1:length(input)
        if i % 2 == 0
            push!(free_space, input[i])
        else
            push!(memory, input[i])
        end
    end
    return memory, free_space
end

memory, free_space = separe_input(string_input)


function expand_memory(memory::Vector{Char}, free_space::Vector{Char})::Dict{Int, Int}
    memory_dict = Dict{Int, Int}()
    current_index = 1
    
    for i in 1:length(memory)
        # Convert Char to Int for repetitions
        repetitions = parse(Int, string(memory[i]))
        
        # Add index repeated times
        for _ in 1:repetitions
            memory_dict[current_index] = i - 1
            current_index += 1
        end
        
        # Add free spaces if available
        if i <= length(free_space)
            free_count = parse(Int, string(free_space[i]))
            for _ in 1:free_count
                memory_dict[current_index] = -1
                current_index += 1
            end
        end
    end
    
    return memory_dict
end

memory_dict = expand_memory(memory, free_space)


function check_memory(memory_dict::Dict{Int, Int}, key1::Int, key2::Int)::Bool
    #check if between key1 and key2 there are only free spaces
    for i in key1:key2
        if memory_dict[i] != -1
            return false
        end
    end
    return true
end


function compress_memory(memory_dict::Dict{Int, Int})::Dict{Int, Int}
    sorted_keys = sort(collect(keys(memory_dict)))
    
    # Find first free space and last non-free space
    function find_key_positions()
        key1 = nothing
        key2 = nothing
        
        # Find first free space (-1)
        for k in sorted_keys
            if memory_dict[k] == -1
                key1 = k
                break
            end
        end
        
        # Find last non-free space (not -1)
        for k in reverse(sorted_keys)
            if memory_dict[k] != -1
                key2 = k
                break
            end
        end
        
        return key1, key2
    end

    key1, key2 = find_key_positions()

    while !check_memory(memory_dict, key1, key2)
        #swap key1 and key2
        memory_dict[key1], memory_dict[key2] = memory_dict[key2], memory_dict[key1]
        key1, key2 = find_key_positions()
    end
    return memory_dict
end

compressed_memory = compress_memory(memory_dict)

function compute_checksum(compressed_memory::Dict{Int, Int})::Int
    checksum = 0
    #change all the free spaces to 0
    for (key, value) in compressed_memory
        if value == -1
            compressed_memory[key] = 0
        end
    end
    #compute the checksum
    for (key, value) in compressed_memory
        checksum += value * (key - 1)
    end
    return checksum
end

checksum = compute_checksum(compressed_memory)

println("The checksum is: ", checksum)
    

### Part 2

memory_dict = expand_memory(memory, free_space)




function efficient_compress_memory(memory_dict::Dict{Int, Int})::Dict{Int, Int}
    # Create a copy of the input dictionary
    memory_dict = copy(memory_dict)
    
    function list_free_spaces(memory_dict::Dict{Int, Int})::Dict{Int, Int}
        # Initialize sorted keys first
        sorted_keys = sort(collect(keys(memory_dict)))
        free_spaces = Dict{Int, Int}()
        current_free_space = 1
        free_count = 0
        
        for i in sorted_keys
            if haskey(memory_dict, i)  # Check if key exists
                if memory_dict[i] == -1
                    if free_count == 0
                        current_free_space = i  # Mark start of free space
                    end
                    free_count += 1
                else  # Non-free space found
                    if free_count > 0
                        free_spaces[current_free_space] = free_count
                        free_count = 0
                    end
                end
            end
        end
        
        # Handle case where free spaces end at last position
        if free_count > 0
            free_spaces[current_free_space] = free_count
        end
        
        return free_spaces
    end

    function compute_file_size(memory_dict::Dict{Int, Int}, value::Int)::Int
        file_size = 0
        for (_, val) in memory_dict
            if val == value
                file_size += 1
            end
        end
        return file_size
    end

    free_spaces = list_free_spaces(memory_dict)
    sorted_free_spaces = sort(collect(keys(free_spaces)))

    file_checked = maximum(collect(values(memory_dict))) 

    while file_checked >  0
        file_size = compute_file_size(memory_dict, file_checked)
        
        key = nothing
        for i in 1:length(memory_dict)
            if memory_dict[i] == file_checked
                key = i
                break
            end
        end
        println("====================================")
        println("Trying to compress file ", file_checked, " with size ", file_size, " starting at key ", key)
        #we start from the first free space
        for free_space in sorted_free_spaces
            if haskey(free_spaces, free_space) && free_spaces[free_space] >= file_size && free_space < key 
                for i in free_space:free_space + file_size - 1
                    memory_dict[i] = file_checked
                    memory_dict[key + i - free_space] = -1
                end
                free_space_size = free_spaces[free_space]
                free_space_key = free_space
                #delete free space 
                delete!(free_spaces, free_space)
                #add the new free space
                free_spaces[free_space + file_size] = free_space_size - file_size

                sorted_free_spaces = sort(collect(keys(free_spaces)))
                break
            end
        end
        file_checked -= 1
    end
    return memory_dict
end

x_limit = maximum(collect(keys(memory_dict)))
for i in 1:x_limit
    print(memory_dict[i])
end
println()

efficient_compressed_memory = efficient_compress_memory(memory_dict)

x_lim = maximum(collect(keys(efficient_compressed_memory)))
for i in 1:x_lim
    print(efficient_compressed_memory[i])
end
println()
efficient_checksum = compute_checksum(efficient_compressed_memory)



println("The efficient checksum is: ", efficient_checksum)



