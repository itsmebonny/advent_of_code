include("../utils.jl")

## Input parsing

function parse_and_divide_input(input::String)::Tuple{ Vector{Vector{Int}} , Vector{Vector{Int}}}
    # Initialize empty arrays
    rules = Vector{Vector{Int}}()
    matrix = Vector{Vector{Int}}()
    
    lines = split(input, "\n")
    flag = true
    for line in lines
        if flag
            if line == ""
                flag = false
            else
                x, y = parse.(Int, split(line, "|"))
                push!(rules, [x, y])
            end
        else
            push!(matrix, parse.(Int, split(line, ",")))
        end
    end

    return rules, matrix


end

function parse_file(file_name::String)::String
    # read the input file without using any function from utils.jl
    file = open(file_name)
    lines = readlines(file)
    close(file)
    return join(lines, "\n")
end

## Test

input_test = parse_file("day_5/input.txt")
rules_test, matrix_test = parse_and_divide_input(input_test)

## Part 1

function check_line(line::Vector{Int}, rules::Vector{Vector{Int}})::Bool
    result = true
    for number in line
        number_index = findfirst(x -> x == number, line)
        #println("Checking number ", number, " at index ", number_index, "...")
        for rule in rules
            if rule[2] in line && rule[1] == number
                #println("Checking if ", rule[2], " is after ", rule[1], "...")
                if number_index <= length(line) && !in(rule[2] , line[number_index:end])
                    #println("Sadly, ", rule[2], " is not after ", rule[1], "...")
                    return false
                end
            end
        end

    end
    #println("Line ", line, " is valid!")
    return result
end

function check_matrix(matrix::Vector{Vector{Int}}, rules::Vector{Vector{Int}})::Int
    result = 0
    for line in matrix
        if check_line(line, rules)
            # take middle element of the line with odd length
            result += line[div(length(line), 2) + 1]
        end
    end
    return result
end

function part1(file_name::String)::Int
    input = parse_file(file_name)
    rules, matrix = parse_and_divide_input(input)
    return check_matrix(matrix, rules)
end

# test_result = part1("day_5/input.txt")

# println("Test result: ", test_result)

## Part 2

# we create a new submatrix with only the lines that are not valid
function get_submatrix(matrix::Vector{Vector{Int}}, rules::Vector{Vector{Int}})::Vector{Vector{Int}}
    submatrix = Vector{Vector{Int}}()
    for line in matrix
        if !check_line(line, rules)
            push!(submatrix, line)
        end
    end
    return submatrix
end

matrix_p2 = get_submatrix(matrix_test, rules_test)
#pretty print the submatrix
# for line in matrix_p2
#     println(line)
# end

function check_rule(rule::Vector{Int}, line::Vector{Int})::Bool
    x, y = rule
    x_index = findfirst(e -> e == x, line)
    y_index = findfirst(e -> e == y, line)
    return x_index < y_index
end

function check_rules(rules::Vector{Vector{Int}}, line::Vector{Int})::Bool
    for rule in rules
        x, y = rule
        if x in line && y in line
            #println("Checking that ", x, " is before ", y, "...")
            if !check_rule(rule, line)
                #println("Rule ", rule, " is not respected!")
                return false
            end
        end
    end
    return true
end



#Thanks to cbrnr for posting his solution on the Advent of Code subreddit and helping me found the problem in my code

function fix_line(line::Vector{Int}, rules::Vector{Vector{Int}})::Vector{Int}
    while !check_rules(rules, line)
        for rule in rules
            if all(i -> i in line, rule) && !check_rule(rule, line)
                x, y = rule
                x_index = findfirst(e -> e == x, line)
                y_index = findfirst(e -> e == y, line)
                line[x_index], line[y_index] = line[y_index], line[x_index]
            end
        end
    end
    return line
end

                

function fix_matrix(matrix::Vector{Vector{Int}}, rules::Vector{Vector{Int}})::Vector{Vector{Int}}
    new_matrix = Vector{Vector{Int}}()
    for line in matrix
        fixed_line = fix_line(line, rules)
        push!(new_matrix, fixed_line)
        if !check_line(fixed_line, rules)
            println("Line ", fixed_line, " is still not valid!")
        end
    end
    return new_matrix
end

graph = build_rules_graph(rules_test)



new_matrix = fix_matrix(matrix_p2, rules_test)
println("Let's check the new matrix...")
result = check_matrix(new_matrix, rules_test)

println("Result: ", result)
    

