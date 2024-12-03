include("../utils.jl")

### Part 1

input_string = read("day_3/input.txt", String)

numbers_extracted = AdventUtils.extract_numbers(input_string)

sum = 0

for numbers in numbers_extracted
    global sum += numbers[1] * numbers[2]
end

println(sum)

### Part 2

using Dates

function extract_pattern(input_string::String)
    """
    Extract the pattern from the input string, can be either "mul(d,d)" or "do()" or "don't()".
    """
    patterns = r"mul\((\d+),\s*(\d+)\)|do\(\)|don't\(\)"

    numbers = []

    flag = true

    for match in eachmatch(patterns, input_string)
        if match.match == "do()"
            flag = true
        elseif match.match == "don't()"
            flag = false
        else
            if flag
                push!(numbers, [parse(Int, match.captures[1]), parse(Int, match.captures[2])])
            end
            
        end
    end

    return numbers
end

numbers_extracted = extract_pattern(input_string)

sum = 0

for numbers in numbers_extracted
    global sum += numbers[1] * numbers[2]
end

println(sum)