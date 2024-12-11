include("../utils.jl")


function expand_input(file_name::String)::String
    # Create new file name for modified content
    new_file_name = replace(file_name, ".txt" => "_modified.txt")
    
    # Read original and write to new file
    open(file_name, "r") do input_file
        open(new_file_name, "w") do output_file
            for line in eachline(input_file)
                # Add space between each character and newline
                println(output_file, join(collect(line), " "))
            end
        end
    end
    
    return new_file_name
end

expand_input("day_10/input.txt")
function read_input_as_matrix(file_name::String)::Matrix{Int}
    # Read the modified input file
    lines = readlines(file_name)
    
    # Create a matrix of the type of the elements in the input file
    matrix = Matrix{Int}(undef, length(lines), length(split(lines[1])))
    
    for (i, line) in enumerate(lines)
        matrix[i, :] = parse.(Int, split(line))
    end
    
    return matrix
end

input_matrix = read_input_as_matrix("day_10/input_modified.txt")
### Part 1



function find_starting_pos(matrix::Matrix{Int})::Vector{Tuple{Int, Int}}
    starting_pos = Vector{Tuple{Int, Int}}()
    rows, cols = size(matrix)
    
    # Check each position in matrix using proper dimensions
    for i in 1:rows
        for j in 1:cols
            # Assuming starting position is marked with value 1
            if matrix[i, j] == 0
                push!(starting_pos, (i, j))
            end
        end
    end
    
    # Verify we found starting position
    if isempty(starting_pos)
        error("No starting position (value 0) found in matrix")
    end
    
    return starting_pos
end

function find_next_pos(matrix::Matrix{Int}, pos::Tuple{Int, Int}, visited::Set{Tuple{Int, Int}})::Tuple{Int, Int}
    i, j = pos
    rows, cols = size(matrix)
    
    # Check boundaries and next values using matrix dimensions
    if i > 1 && (i-1, j) ∉ visited && matrix[i-1, j] == matrix[i, j] + 1
        return (i-1, j)
    elseif i < rows && (i+1, j) ∉ visited && matrix[i+1, j] == matrix[i, j] + 1
        return (i+1, j)
    elseif j > 1 && (i, j-1) ∉ visited && matrix[i, j-1] == matrix[i, j] + 1
        return (i, j-1)
    elseif j < cols && (i, j+1) ∉ visited && matrix[i, j+1] == matrix[i, j] + 1
        return (i, j+1)
    else
        return (0, 0)
    end
end

function find_path(matrix::Matrix{Int}, starting_pos::Tuple{Int, Int})::Int
    ## find all the paths that from starting pos reach matrix[i,j] == 9, so keep track of the paths already visited. In the end return the number of possible paths
    paths = 0
    visited = Set{Tuple{Int, Int}}()
    current_path = [starting_pos]
    while !isempty(current_path)
        current_pos = current_path[end]
        next_pos = find_next_pos(matrix, current_pos, visited)
        if next_pos == (0, 0)
            visited = visited ∪ Set([current_pos])
            # remove last element from current path
            pop!(current_path)
        else
            push!(current_path, next_pos)
            if matrix[next_pos[1], next_pos[2]] == 9
                paths += 1
                visited = visited ∪ Set(current_path)
                pop!(current_path)
            end
        end
    end
    return paths
end

starting_pos = find_starting_pos(input_matrix)
##print the matrix with starting pos in red color
println("Matrix with starting positions in red:") 
for i in 1:size(input_matrix, 1)
    for j in 1:size(input_matrix, 2)
        if (i, j) in starting_pos
            print("\033[31m", input_matrix[i, j], "\033[0m ")
        else
            print(input_matrix[i, j], " ")
        end
    end
    println()
end

paths = 0

for pos in starting_pos
    global paths += find_path(input_matrix, pos)
end
    
println("Number of paths: ", paths)


### Part 2

input_matrix = read_input_as_matrix("day_10/input_modified.txt")



function find_ending_positions(matrix::Matrix{Int})::Vector{Tuple{Int, Int}}
    ending_pos = Vector{Tuple{Int, Int}}()
    rows, cols = size(matrix)
    
    for i in 1:rows
        for j in 1:cols
            if matrix[i, j] == 9
                push!(ending_pos, (i, j))
            end
        end
    end
    
    return ending_pos
end

function rate_trailhead(matrix::Matrix{Int}, starting_pos::Tuple{Int, Int})::Int
    ending_positions = find_ending_positions(matrix)
    distinct_paths = Set{Vector{Tuple{Int, Int}}}()
    
    # Stack elements: (current_pos, visited_set, path_taken)
    stack = [(starting_pos, Set([starting_pos]), [starting_pos])]
    
    while !isempty(stack)
        current_pos, visited, path = pop!(stack)
        
        # Check if we reached an ending position
        if current_pos in ending_positions
            if !(path in distinct_paths)
                push!(distinct_paths, path)
            end
            continue
        end
        
        # Get current value and check all neighbors
        current_val = matrix[current_pos...]
        i, j = current_pos
        rows, cols = size(matrix)
        
        # Check all adjacent positions
        for (di, dj) in [(-1,0), (0,1), (1,0), (0,-1)]
            new_i, new_j = i + di, j + dj
            if 1 <= new_i <= rows && 1 <= new_j <= cols
                next_pos = (new_i, new_j)
                if next_pos ∉ visited && matrix[next_pos...] == (current_val + 1) % 10
                    new_visited = copy(visited)
                    push!(new_visited, next_pos)
                    new_path = copy(path)
                    push!(new_path, next_pos)
                    push!(stack, (next_pos, new_visited, new_path))
                end
            end
        end
    end
    
    return length(distinct_paths)
end

starting_pos = find_starting_pos(input_matrix)
paths = 0

for pos in starting_pos
    global paths += rate_trailhead(input_matrix, pos)
end

println("Number of distinct paths: ", paths)