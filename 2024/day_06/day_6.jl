include("../utils.jl")

input_string = read("day_6/input.txt", String)

input_map = AdventUtils.create_map(input_string)

x_lim, y_lim = maximum(keys(input_map))

#pretty print the map
# for i in 1:x_lim
#     for j in 1:y_lim
#         print(input_map[(i, j)])
#     end
#     println()
# end

### Part 1

#Find the position of the character '^'

x, y = first(key for (key, val) in input_map if val == '^')


function path_find(input_map::Dict{Tuple{Int64, Int64}, Char}, x::Int, y::Int)::Int
    #initialize the number of steps
    steps = 1
    visited = Set{Tuple{Int, Int}}()
    #initialize the direction
    direction = 'U'
    #initialize the position
    x_pos, y_pos = x, y
    #initialize the map
    map = copy(input_map)

    map[(x_pos, y_pos)] = '.'
   
    x_lim, y_lim = maximum(keys(map))

    while x_pos > 0 && x_pos <= x_lim && y_pos > 0 && y_pos <= y_lim
        push!(visited, (x_pos, y_pos))
        #rintln("The number of unique positions visited is: ", length(visited))
        # print("Current steps = ", steps, " at position (", x_pos, ", ", y_pos, ")...\n")
        # print_updated_map(map, x_pos, y_pos)
        # #check if we can move in the current direction
        if direction == 'U'
            if x_pos - 1 > 0
                if map[(x_pos - 1, y_pos)] == '#'
                    #change direction to the right
                    direction = 'R'
                elseif map[(x_pos - 1, y_pos)] == '.'
                    #move up
                    x_pos -= 1
                    steps += 1
                elseif map[(x_pos - 1, y_pos)] == 'X'
                    #move up
                    x_pos -= 1
                end
            else
                return length(visited)
            end
        elseif direction == 'R'
            if y_pos + 1 <= y_lim
                if map[(x_pos, y_pos + 1)] == '#'
                    #change direction to the down
                    direction = 'D'
                elseif map[(x_pos, y_pos + 1)] == '.'
                    #move right
                    y_pos += 1
                    steps += 1
                elseif map[(x_pos, y_pos + 1)] == 'X'
                    #move right
                    y_pos += 1
                end
            else
                return length(visited)
            end
        elseif direction == 'D'
            if x_pos + 1 <= x_lim
                if map[(x_pos + 1, y_pos)] == '#'
                    #change direction to the left
                    direction = 'L'
                elseif map[(x_pos + 1, y_pos)] == '.'
                    #move down
                    x_pos += 1
                    steps += 1
                elseif map[(x_pos + 1, y_pos)] == 'X'
                    #move down
                    x_pos += 1
                end
            else
                return length(visited)
            end
        elseif direction == 'L'
            if y_pos - 1 > 0
                if map[(x_pos, y_pos - 1)] == '#'
                    #change direction to the up
                    direction = 'U'
                elseif map[(x_pos, y_pos - 1)] == '.'
                    #move left
                    y_pos -= 1
                    steps += 1
                elseif map[(x_pos, y_pos - 1)] == 'X'
                    #move left
                    y_pos -= 1
                end
            else
                return length(visited)
            end
        end
    end
    
end


function print_updated_map(map::Dict{Tuple{Int64, Int64}, Char}, x::Int, y::Int)
    x_lim, y_lim = maximum(keys(map))
    println("================ UPDATED MAP ================")
    for i in 1:x_lim
        for j in 1:y_lim
            if i == x && j == y
                map[(i, j)] = 'X'
                #print a colored X
                print("\e[31m", map[(i, j)], "\e[0m")
            else
                print(map[(i, j)])
            end
        end
        println()
    end
    println("=============================================")
end

steps = path_find(input_map, x, y)

println("The number of steps is: ", steps)

### Part 2

function is_guard_looping(input_map::Dict{Tuple{Int64, Int64}, Char}, x::Int, y::Int)::Bool
    # function to check if the guard is looping given the current position
    visited_directed = Set{Tuple{Tuple{Int, Int}, Char}}()
    second_visited = Set{Tuple{Tuple{Int, Int}, Char}}()
    x_lim, y_lim = maximum(keys(input_map))

    direction = 'U'

    x_pos, y_pos = x, y

    while x_pos > 0 && x_pos <= x_lim && y_pos > 0 && y_pos <= y_lim
        if ((x_pos, y_pos), direction) in visited_directed
            if ((x_pos, y_pos), direction) in second_visited
                return true
            else
                push!(second_visited, ((x_pos, y_pos), direction))
            end
        end
        push!(visited_directed, ((x_pos, y_pos), direction))
        # print("Current steps = ", steps, " at position (", x_pos, ", ", y_pos, ")...\n")
        # print_updated_map(map, x_pos, y_pos)
        # #check if we can move in the current direction
        if direction == 'U'
            if x_pos - 1 > 0
                if input_map[(x_pos - 1, y_pos)] == '#'
                    #change direction to the right
                    direction = 'R'
                elseif input_map[(x_pos - 1, y_pos)] == '.'
                    #move up
                    x_pos -= 1
                elseif input_map[(x_pos - 1, y_pos)] == 'X'
                    #move up
                    x_pos -= 1
                end
            else
                return false
            end
        elseif direction == 'R'
            if y_pos + 1 <= y_lim
                if input_map[(x_pos, y_pos + 1)] == '#'
                    #change direction to the down
                    direction = 'D'
                elseif input_map[(x_pos, y_pos + 1)] == '.'
                    #move right
                    y_pos += 1
                elseif input_map[(x_pos, y_pos + 1)] == 'X'
                    #move right
                    y_pos += 1
                end
            else
                return false
            end
        elseif direction == 'D'
            if x_pos + 1 <= x_lim
                if input_map[(x_pos + 1, y_pos)] == '#'
                    #change direction to the left
                    direction = 'L'
                elseif input_map[(x_pos + 1, y_pos)] == '.'
                    #move down
                    x_pos += 1
                elseif input_map[(x_pos + 1, y_pos)] == 'X'
                    #move down
                    x_pos += 1
                end
            else
                return false
            end
        elseif direction == 'L'
            if y_pos - 1 > 0
                if input_map[(x_pos, y_pos - 1)] == '#'
                    #change direction to the up
                    direction = 'U'
                elseif input_map[(x_pos, y_pos - 1)] == '.'
                    #move left
                    y_pos -= 1
                elseif input_map[(x_pos, y_pos - 1)] == 'X'
                    #move left
                    y_pos -= 1
                end
            else
                return false
            end
        end
    end
    return false
end

function find_possible_loops(input_map::Dict{Tuple{Int64, Int64}, Char})::Int
    # function to find the number of possible loops
    loops = 0
    x_pos, y_pos = first(key for (key, val) in input_map if val == '^')
    x_lim, y_lim = maximum(keys(input_map))
    
    for (key, val) in input_map
        map = copy(input_map)
        map[(x_pos, y_pos)] = '.'
        if val == '.'
            map[key] = '#'
            #print("Testing position (", key[1], ", ", key[2], ")...\n")
            if is_guard_looping(map, x_pos, y_pos)
                loops += 1
            end
        end
    end
    return loops
end

#time to find the number of possible loops

@time loops = find_possible_loops(input_map)

println("The number of possible loops is: ", loops)

     