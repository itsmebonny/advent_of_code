using DelimitedFiles

function parse_input(filename)
        m = readdlm("../inputs/"*filename*".txt", ',', String, '\n', header=false) 
    return m
end

s = parse_input("input_02")
display(s)