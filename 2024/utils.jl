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

end



