using DelimitedFiles

function parse_input(filename)
        m = readdlm("../inputs/"*filename*".txt", '\t', String, '\n', header=false) 
    return m[1:end]
end
global max = 0
inp = parse_input("input_1")
for i in axes(inp, 1)
    if length(inp[i]) > max
        global max = length(inp[i])
    end
end
s = Vector{Int64}(undef, length(inp))
for i in eachindex(inp)
    number = String("")
    for j in inp[i]
        if isdigit(j) == true
            println(j)
            number = number*j
        end
    
    end
    s[i] = parse(Int64,number[1]*number[end])
end

println("Part 1: ", sum(s))