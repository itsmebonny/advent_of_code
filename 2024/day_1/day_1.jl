include("../utils.jl")

### Part 1

directory = "day_1/input.txt"

# Modify the input file
new_directory = AdventUtils.modify_input(directory)

# Read the modified input file
delimiter = ' '
matrix = AdventUtils.read_input(new_directory)

println(matrix[3, 1])

first_column = [row[1] for row in matrix]
second_column = [row[2] for row in matrix]

first_column = sort(first_column)
second_column = sort(second_column)

sorted_matrix = hcat(first_column, second_column)


diffs = zeros(Int, size(sorted_matrix, 1))
#compute the absolute difference between the first and last element of each column
for i in 1:size(sorted_matrix, 1)
    diffs[i] = Int(abs(sorted_matrix[i, 1] - sorted_matrix[i, 2]))
end


# compute the sum of the differences
println(IOContext(stdout, :compact=>false), sum(diffs))


### Part 2


#create dictionary with the unique elements of the second_column as keys and the number of times they appear as values
dict = Dict{Int, Int}()
for element in second_column
    if haskey(dict, element)
        dict[element] += 1
    else
        dict[element] = 1
    end
end

sums = Vector{Int}()
for element in first_column
    if !(element in keys(dict))
        push!(sums, 0)
    else
        push!(sums, element * dict[element])
    end
end

println(sum(sums))