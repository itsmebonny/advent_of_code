include("../utils.jl")

### Part 1

directory = "day_2/input.txt"

# Read the modified input file
delimiter = ' '
matrix = AdventUtils.read_input(directory)

function check_monotonicity_row(row::Array{Int, 1})
    """
    Check if the elements in the row are either strictly increasing or strictly decreasing.
    """
    sorted_row = sort(row)
    reversed_row = reverse(sorted_row)
    unique_row = unique(row)
    return (row == sorted_row || row == reversed_row) && length(unique_row) == length(row)
end

function check_max_min_diff(row::Array{Int, 1}, max_diff::Int=3, min_diff::Int=1)
    """
    Check if the difference between two adjacent elements in the row is between min_diff and max_diff.
    """
    for i in 1:length(row) - 1
        if !(min_diff <= abs(row[i] - row[i + 1]) <= max_diff)
            return false
        end
    end
    return true
end

count = 0
for row in matrix
    if check_monotonicity_row(row) && check_max_min_diff(row)
        global count += 1
    end
end

println(count)

### Part 2

function save_row(row::Array{Int, 1})
    """
    Takes as input a row and returns true if by removing one element from the row, the two checks are satisfied.
    """
    for i in 1:length(row)
        new_row = copy(row)
        deleteat!(new_row, i)
        if check_monotonicity_row(new_row) && check_max_min_diff(new_row)
            return true
        end
    end
    return false
end

count = 0
for row in matrix
    if check_monotonicity_row(row) && check_max_min_diff(row)
        global count += 1
    elseif save_row(row)
        global count += 1
    end
end

println(count)