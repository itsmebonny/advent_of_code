module AdventUtils


export read_input, modify_input


"""
    Create a function that modifies the input file by reducing the whitespaces between elements to only one whitespace, but keeping the newlines.

    # Arguments
    - `directory::String`: The path to the input file.

    # Returns
    - `String`: The path to the modified input file.
"""

function modify_input(directory::String)
    # get file name 
    file_name = split(directory, "/")[end]
    # create file_name for the modified file
    new_file_name =  split(file_name, ".")[1] * "_modified." * split(file_name, ".")[2]
    # create the path to the modified file
    new_directory = split(directory, "/")[1] * "/" * new_file_name

    # Read the input file
    file = open(directory)
    lines = readlines(file)
    close(file)

    # Modify the input file keeping the newlines but reducing the whitespaces between elements to only one whitespace
    new_file = open(new_directory, "w")
    for line in lines
        elements = split(line)
        new_line = join(elements, ' ')
        write(new_file, new_line * "\n")
    end
    close(new_file)

    return new_directory

end





"""
    Read the input file and return a matrix of the elements in the file.

    # Arguments
    - `directory::String`: The path to the input file.
    - `delimiter::Char`: The delimiter used to separate the elements in the input file.
    - `type`::Type: The type of the elements in the matrix.

    # Returns
    - `Array{Array{type, 1}, 1}`: A matrix of the elements in the input file.
"""

function read_input(directory::String, delimiter::Char=' ', type::Type=Int)
    # Read the modified input file
    file = open(directory)
    lines = readlines(file)
    close(file)

    # Create a matrix of the type of the elements in the input file
    matrix = Array{Array{type, 1}, 1}()

    for line in lines
        elements = split(line, delimiter)
        push!(matrix, map(x -> parse(type, x), elements))
    end

    return matrix

end



using Dates

export extract_numbers

"""
    Extract the two numbers from the input string that match the pattern "mul(digit, digit)".

    # Arguments
    - `input_string::String`: The input string.

    # Returns
    - `Array{Array{Int, 1}, 1}`: A vector of vectors containing the two numbers extracted from the input string.
"""

function extract_numbers(input_string)
    # Regular expression pattern to match "mul(digit, digit)"
    pattern = r"mul\((\d+),\s*(\d+)\)"
    
    # Use the regular expression to find all matches
    matches = collect(eachmatch(pattern, input_string))
    
    # Extract the two digits from each match and store them in a vector
    result = [[parse(Int, m.captures[1]), parse(Int, m.captures[2])] for m in matches]
    
    return result
end

export create_map

"""
    Create a map structure where the key are the x and y coordinates and the value is character at that position.

    # Arguments
    - `input_string::String`: The input string.

    # Returns
    - `Dict{Tuple{Int64, Int64}, Char}`: A map structure where the key are the x and y coordinates and the value is character at that position.
"""

function create_map(input_string::String)
    #create a map structure where the key are the x and y coordinates and the value is character at that position
    map = Dict{Tuple{Int64, Int64}, Char}()
    for (i, line) in enumerate(split(input_string, "\n"))
        for (j, char) in enumerate(line)
            map[(i, j)] = char
        end
    end

    return map

end

end