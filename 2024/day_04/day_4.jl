
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

function count_xmas(map::Dict{Tuple{Int64, Int64}, Char})
    #count the number of time xmas appears in the map
    count = 0
    limits = maximum(keys(map))
    for (i, j) in keys(map)
        if map[(i, j)] == 'X'
            if i + 3 <= limits[1] && map[(i + 1, j)] == 'M' && map[(i + 2, j)] == 'A' && map[(i + 3, j)] == 'S'
                count += 1
            end
            if i - 3 >= 1 && map[(i - 1, j)] == 'M' && map[(i - 2, j)] == 'A' && map[(i - 3, j)] == 'S'
                count += 1
            end
            if j + 3 <= limits[2] && map[(i, j + 1)] == 'M' && map[(i, j + 2)] == 'A' && map[(i, j + 3)] == 'S'
                count += 1
            end
            if j - 3 >= 1 && map[(i, j - 1)] == 'M' && map[(i, j - 2)] == 'A' && map[(i, j - 3)] == 'S'
                count += 1
            end
            if i + 3 <= limits[1] && j + 3 <= limits[2] && map[(i + 1, j + 1)] == 'M' && map[(i + 2, j + 2)] == 'A' && map[(i + 3, j + 3)] == 'S'
                count += 1
            end
            if i - 3 >= 1 && j - 3 >= 1 && map[(i - 1, j - 1)] == 'M' && map[(i - 2, j - 2)] == 'A' && map[(i - 3, j - 3)] == 'S'
                count += 1
            end
            if i + 3 <= limits[1] && j - 3 >= 1 && map[(i + 1, j - 1)] == 'M' && map[(i + 2, j - 2)] == 'A' && map[(i + 3, j - 3)] == 'S'
                count += 1
            end
            if i - 3 >= 1 && j + 3 <= limits[2] && map[(i - 1, j + 1)] == 'M' && map[(i - 2, j + 2)] == 'A' && map[(i - 3, j + 3)] == 'S'
                count += 1
            end
        end
    end

    return count

end

### Part 1

input_string = read("day_4/input.txt", String)

map = create_map(input_string)

xmases = count_xmas(map)


println("The number of times xmas appears in the map is: ", xmases)

### Part 2

function find_mas_mas(map::Dict{Tuple{Int64, Int64}, Char})
    #find the number of times mas appears in the map
    count = 0
    limits = maximum(keys(map))
    # we need to find an A that is the middle of the cross of two MAS 
    for (i, j) in keys(map)
        if map[(i, j)] == 'A'
  
            #we need 8 if statements to check all the possible combinations of MAS diagonally
            if i + 1 <= limits[1] && j + 1 <= limits[2] && i - 1 >= 1 && j - 1 >= 1 && map[(i + 1, j + 1)] == 'M' && map[(i - 1, j - 1)] == 'S' && map[(i + 1, j - 1)] == 'M' && map[(i - 1, j + 1)] == 'S'
                count += 1
            elseif i + 1 <= limits[1] && j + 1 <= limits[2] && i - 1 >= 1 && j - 1 >= 1 && map[(i + 1, j + 1)] == 'S' && map[(i - 1, j - 1)] == 'M' && map[(i + 1, j - 1)] == 'S' && map[(i - 1, j + 1)] == 'M'
                count += 1
            elseif i + 1 <= limits[1] && j + 1 <= limits[2] && i - 1 >= 1 && j - 1 >= 1 && map[(i + 1, j + 1)] == 'M' && map[(i - 1, j - 1)] == 'S' && map[(i + 1, j - 1)] == 'S' && map[(i - 1, j + 1)] == 'M'
                count += 1
            elseif i + 1 <= limits[1] && j + 1 <= limits[2] && i - 1 >= 1 && j - 1 >= 1 && map[(i + 1, j + 1)] == 'S' && map[(i - 1, j - 1)] == 'M' && map[(i + 1, j - 1)] == 'M' && map[(i - 1, j + 1)] == 'S'
                count += 1
            end
        end
    end

                
    return count



end

mas_mas = find_mas_mas(map)

println("The number of times mas mas appears in the map is: ", mas_mas)