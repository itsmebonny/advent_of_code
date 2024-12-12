include("../utils.jl")

using Base.Threads 

function read_stones(file_name::String)::Dict{Int, Int}
    stones = Dict{Int, Int}()
    
    open(file_name, "r") do file
        position = 1
        for line in eachline(file)
            for stone in split(line, ' ')
                stone = parse(Int, stone)
                stones[position] = stone
                position += 1
            end
        end
    end
    return stones
end

input = read_stones("day_11/input.txt")

println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
function shift_keys(input::Dict{Int, Int}, position::Int)::Dict{Int, Int}
    ### add a place after position and shift all keys after position by 1
    new_input = Dict{Int, Int}()
    sorted_keys = sort(collect(keys(input)))
    for key in sorted_keys
        if key <= position
            new_input[key] = input[key]
        else
            new_input[key + 1] = input[key]
        end
    end
    return new_input
end
    
function blink(input::Dict{Int, Int})::Dict{Int, Int}
    new_input = Dict{Int, Int}()
    input = copy(input)
    sorted_keys = sort(collect(keys(input)))
    shift = 0
    for key in sorted_keys
        value = input[key]
        value_string = string(value)
        no_digits = length(value_string)
        if value == 0
            new_input[key + shift] = 1
        elseif no_digits % 2 == 0
            value_string_1 = value_string[1:Int(no_digits/2)]
            value_string_2 = value_string[Int(no_digits/2)+1:end]
            shift_keys(input, key)
            new_input[key + shift] = parse(Int, value_string_1)
            new_input[key + shift + 1] = parse(Int, value_string_2)
            shift += 1
        else
            new_input[key + shift] = value * 2024
        end
    end
    return new_input
end

function parallel_blink(input::Dict{Int, Int})::Dict{Int, Int}
    # Split keys into chunks for each thread
    sorted_keys = sort(collect(keys(input)))
    chunk_size = max(1, ceil(Int, length(sorted_keys) / nthreads()))
    chunks = [sorted_keys[i:min(i+chunk_size-1, end)] for i in 1:chunk_size:length(sorted_keys)]
    
    # Create result containers
    results = Vector{Dict{Int, Int}}(undef, length(chunks))
    shifts = zeros(Int, length(chunks))
    
    # Process chunks in parallel
    @threads for i in 1:length(chunks)
        chunk_dict = Dict(k => input[k] for k in chunks[i])
        local_shift = 0
        results[i] = Dict{Int, Int}()
        
        for key in chunks[i]
            value = chunk_dict[key]
            value_string = string(value)
            no_digits = length(value_string)
            
            if value == 0
                results[i][key + local_shift] = 1
            elseif no_digits % 2 == 0
                value_string_1 = value_string[1:Int(no_digits/2)]
                value_string_2 = value_string[Int(no_digits/2)+1:end]
                results[i][key + local_shift] = parse(Int, value_string_1)
                results[i][key + local_shift + 1] = parse(Int, value_string_2)
                local_shift += 1
            else
                results[i][key + local_shift] = value * 2024
            end
        end
        shifts[i] = local_shift
    end
    
    # Merge results with proper key offsets
    final_result = Dict{Int, Int}()
    cumulative_shift = 0
    for i in 1:length(results)
        for (k, v) in results[i]
            final_result[k + cumulative_shift] = v
        end
        cumulative_shift += shifts[i]
    end
    
    return final_result
end

function parallel_blink_better(input::Dict{Int, Int})::Dict{Int, Int}
    # Pre-allocate result dictionary
    final_result = Dict{Int, Int}()
    
    # Calculate work distribution
    sorted_keys = sort(collect(keys(input)))
    n_chunks = nthreads()
    chunk_size = ceil(Int, length(sorted_keys) / n_chunks)
    
    # Pre-allocate thread-local results
    local_results = Vector{Dict{Int, Int}}(undef, n_chunks)
    local_shifts = zeros(Int, n_chunks)
    
    # Process chunks in parallel
    @threads for chunk_id in 1:n_chunks
        start_idx = (chunk_id - 1) * chunk_size + 1
        end_idx = min(start_idx + chunk_size - 1, length(sorted_keys))
        chunk_keys = sorted_keys[start_idx:end_idx]
        
        # Pre-allocate thread local storage
        local_dict = Dict{Int, Int}()
        local_shift = 0
        
        # Process each key in chunk
        for key in chunk_keys
            value = input[key]
            value_string = string(value)
            no_digits = length(value_string)
            
            if value == 0
                local_dict[key + local_shift] = 1
            elseif iseven(no_digits)
                mid = div(no_digits, 2)
                local_dict[key + local_shift] = parse(Int, value_string[1:mid])
                local_dict[key + local_shift + 1] = parse(Int, value_string[mid+1:end])
                local_shift += 1
            else
                local_dict[key + local_shift] = value * 2024
            end
        end
        
        local_results[chunk_id] = local_dict
        local_shifts[chunk_id] = local_shift
    end
    
    # Merge results sequentially
    cumulative_shift = 0
    for chunk_id in 1:n_chunks
        for (k, v) in local_results[chunk_id]
            final_result[k + cumulative_shift] = v
        end
        cumulative_shift += local_shifts[chunk_id]
    end
    
    return final_result
end

function blink_n_times(input::Dict{Int, Int}, n::Int)::Dict{Int, Int}
    for i in 1:n
        input = parallel_blink(input)    
    end
    return input
end

input_25 = blink_n_times(input, 25)

println("There are now $(length(input_25)) stones in the list.")


### Part 2

## Wow, thanks reddit for the hint on memoization. This is a lot faster now.

const memo = Dict{Tuple{Int,Int}, Int}()

function solve(stone::Int, blinks::Int)::Int
    # Base case - no more blinks
    if blinks == 0
        return 1
    end
    
    # Check memoization cache
    key = (stone, blinks)
    haskey(memo, key) && return memo[key]
    
    # Calculate value based on rules
    val = if stone == 0
        solve(1, blinks - 1)
    elseif iseven(length(string(stone)))
        str_stone = string(stone)
        mid = div(length(str_stone), 2)
        solve(parse(Int, str_stone[1:mid]), blinks - 1) + 
        solve(parse(Int, str_stone[mid+1:end]), blinks - 1)
    else
        solve(stone * 2024, blinks - 1)
    end
    
    # Cache and return
    memo[key] = val
    return val
end

function blink_n_times(input::Dict{Int, Int}, n::Int)::Int
    empty!(memo)  # Clear memoization cache
    total = 0
    
    # Sum paths for each starting stone
    for stone in values(input)
        total += solve(stone, n)
    end
    
    return total
end

# Test with different blink counts
result_25 = blink_n_times(input, 25)
println("Sum of paths after 25 blinks: $result_25")

empty!(memo)  # Clear cache before next run
result_75 = blink_n_times(input, 75)
println("Sum of paths after 75 blinks: $result_75")