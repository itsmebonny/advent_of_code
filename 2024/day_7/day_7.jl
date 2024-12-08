using .AdventUtils
using Combinatorics

function split_input(input_string::String)::Tuple{Vector{Int}, Vector{Vector{Int}}}
    results = Vector{Int}()
    operands = Vector{Vector{Int}}()

    for line in split(input_string, "\n")
        parts = split(line, ":")
        parts[2] = parts[2][2:end]
        push!(results, parse(Int, parts[1]))
        push!(operands, parse.(Int, split(parts[2], " ")))
    end

    return results, operands
end

file_input = read("day_7/input.txt", String)

results, operands = split_input(file_input)

### Part 1

function create_possible_permutations(n::Int)::Vector{Vector{Char}}
    all_perms = Vector{Vector{Char}}()
    
    # For each possible number of '+'
    for plus_count in 0:n
        mult_count = n - plus_count  # Remaining spots filled with '*'
        
        # Create operator array with current combination
        ops = vcat(repeat(['+'], plus_count), repeat(['*'], mult_count))
        
        # Get unique permutations
        unique_perms = collect(multiset_permutations(ops, n))
        append!(all_perms, unique_perms)
    end
    
    return unique(all_perms)
end



function verify_results(results::Vector{Int}, operands::Vector{Vector{Int}})::Int
    ok_results = Set{Int}()
    for i in 1:length(results)
        result = results[i]
        permutations = create_possible_permutations(length(operands[i]) - 1)
        for operator in permutations
            partial_result = operands[i][1]
            expression = string(operands[i][1])
            for j in 1:length(operands[i]) - 1
                expression *= operator[j] * string(operands[i][j + 1])
                if operator[j] == '+'
                    partial_result += operands[i][j + 1]
                elseif operator[j] == '*'
                    partial_result *= operands[i][j + 1]
                elseif operator[j] == '|'
                    partial_result_string = string(partial_result)
                    partial_result_string *= string(operands[i][j + 1])
                    partial_result = parse(Int, partial_result_string)
                end
            end
            #println("The expression is: ", expression)
            if partial_result == result
                push!(ok_results, i)
            end
        end
    end
    sum = 0
    for i in ok_results
        sum += results[i]
    end
    return sum
end

result = verify_results(results, operands)

println("The sum of the results that are correct is: ", result)


### Part 2

function possible_permutations(n::Int)::Vector{Vector{Char}}
    all_perms = Vector{Vector{Char}}()
    
    # For each possible number of '+'
    for plus_count in 0:n
        for mult_count in 0:(n - plus_count)
            par_count = n - plus_count - mult_count  # Remaining spots filled with '*'
            
            # Create operator array with current combination
            ops = vcat(repeat(['+'], plus_count), repeat(['*'], mult_count), repeat(['|'], par_count))
            
            # Get unique permutations
            unique_perms = collect(multiset_permutations(ops, n))
            append!(all_perms, unique_perms)
        end
    end
    return unique(all_perms)
end

function verify_results_2(results::Vector{Int}, operands::Vector{Vector{Int}})::Int
    ok_results = Set{Int}()
    for i in 1:length(results)
        result = results[i]
        permutations = possible_permutations(length(operands[i]) - 1)
        for operator in permutations
            partial_result = operands[i][1]
            expression = string(operands[i][1])
            for j in 1:length(operands[i]) - 1
                expression *= operator[j] * string(operands[i][j + 1])
                if operator[j] == '+'
                    partial_result += operands[i][j + 1]
                elseif operator[j] == '*'
                    partial_result *= operands[i][j + 1]
                elseif operator[j] == '|'
                    partial_result_string = string(partial_result)
                    partial_result_string *= string(operands[i][j + 1])
                    partial_result = parse(Int, partial_result_string)
                end
            end
            #println("The expression is: ", expression)
            if partial_result == result
                push!(ok_results, i)
            end
        end
    end
    sum = 0
    for i in ok_results
        sum += results[i]
    end
    return sum
end

result = verify_results_2(results, operands)

println("The sum of the results that are correct is: ", result)

