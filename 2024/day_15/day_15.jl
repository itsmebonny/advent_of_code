function input_parser(filename)::Tuple{Dict{Tuple{Int,Int}, Char}, String}
    input_map = Dict{Tuple{Int,Int}, Char}()
    string = read(filename, String)
    map, instructions = split(string, "\n\n")

    for (y, line) in enumerate(split(map, "\n"))
        for (x, c) in enumerate(line)
            input_map[(x,y)] = c
        end
    end
    
    return input_map, instructions
end
println("============STARTING DAY 15============")
input_map, instructions = input_parser("day_15/input.txt")

function print_map(map::Dict{Tuple{Int,Int}, Char})
    x_max = maximum([k[1] for k in keys(map)])
    y_max = maximum([k[2] for k in keys(map)])
    for y in 1:y_max
        for x in 1:x_max
            print(map[(x,y)])
        end
        println()
    end
end

### Part 1

robot_positions = [k for (k,v) in input_map if v == '@'][1]

println("The robot positions are: ", robot_positions)
print_map(input_map)
println("=====================================")

function update_map(map::Dict{Tuple{Int,Int}, Char}, robot_positions::Tuple{Int,Int}, instructions::Char)::Dict{Tuple{Int,Int}, Char}
    map = deepcopy(map)
    x, y = robot_positions
    
    # Calculate next position based on direction
    next_pos = if instructions == '^'
        (x, y-1)
    elseif instructions == 'v'
        (x, y+1)
    elseif instructions == '<'
        (x-1, y)
    elseif instructions == '>'
        (x+1, y)
    end
    
    # Handle wall collision
    if !haskey(map, next_pos) || map[next_pos] == '#'
        return map
    end
    
    # Handle box movement
    if map[next_pos] == 'O'
        box_count = encountered_box(map, next_pos, instructions)
        if box_count > 0
            # Calculate positions for entire chain
            box_positions = []
            current = next_pos
            for i in 1:box_count
                push!(box_positions, current)
                current = if instructions == '^'
                    (current[1], current[2]-1)
                elseif instructions == 'v'
                    (current[1], current[2]+1)
                elseif instructions == '<'
                    (current[1]-1, current[2])
                else # '>'
                    (current[1]+1, current[2])
                end
            end
            
            # Clear old box positions
            for pos in box_positions
                map[pos] = '.'
            end
            
            # Place boxes in new positions
            for i in 1:box_count
                new_pos = if instructions == '^'
                    (next_pos[1], next_pos[2]-i)
                elseif instructions == 'v'
                    (next_pos[1], next_pos[2]+i)
                elseif instructions == '<'
                    (next_pos[1]-i, next_pos[2])
                else # '>'
                    (next_pos[1]+i, next_pos[2])
                end
                map[new_pos] = 'O'
            end
            
            # Move robot
            map[robot_positions] = '.'
            map[next_pos] = '@'
        end
    else
        # Move robot to empty space
        map[robot_positions] = '.'
        map[next_pos] = '@'
    end
    
    return map
end

function move_robot(map::Dict{Tuple{Int,Int}, Char}, robot_positions::Tuple{Int,Int}, instructions::String)
    current_map = deepcopy(map)
    current_pos = robot_positions
    
    for instruction in instructions
        current_map = update_map(current_map, current_pos, instruction)
        # Update robot position
        current_pos = [k for (k,v) in current_map if v == '@'][1]
    end
    
    return current_map
end
function encountered_box(map::Dict{Tuple{Int,Int}, Char}, box_positions::Tuple{Int,Int}, instructions::Char)::Int
    x, y = box_positions
    
    # Calculate next position based on direction
    next_pos = if instructions == '^'
        (x, y-1)
    elseif instructions == 'v'
        (x, y+1)
    elseif instructions == '<'
        (x-1, y)
    elseif instructions == '>'
        (x+1, y)
    else
        return 0
    end
    
    # Check bounds and walls first
    if !haskey(map, next_pos) || map[next_pos] == '#'
        return 0
    end
    
    # If next position is a box, continue checking chain
    if map[next_pos] == 'O'
        chain_length = encountered_box(map, next_pos, instructions)
        return chain_length == 0 ? 0 : chain_length + 1
    end
    
    # Empty space found at end of chain
    if map[next_pos] == '.'
        return 1
    end
    
    return 0
end

new_map = move_robot(input_map, robot_positions, instructions)

function count_boxes(map::Dict{Tuple{Int,Int}, Char})
    count = 0
    for (k, v) in map
        if v == 'O'
            count += 100 * (k[2] - 1) + (k[1] - 1)
        end
    end
    return count
end

println("The sum of the coordinates of the boxes is: ", count_boxes(new_map))

### Part 2

mutable struct Warehouse
    map::Dict{Tuple{Int,Int}, Char}
    box_positions::Array{Tuple{Tuple{Int,Int}, Int}, 1}
    robot_position::Tuple{Int,Int}
end
function new_warehouse(map::Dict{Tuple{Int,Int}, Char})
    box_positions = []
    robot_position = [k for (k,v) in map if v == '@'][1]
    new_map = Dict{Tuple{Int,Int}, Char}()
    
    # Get map dimensions
    x_coords = [k[1] for k in keys(map)]
    y_coords = [k[2] for k in keys(map)]
    x_max = maximum(x_coords)
    y_max = maximum(y_coords)
    
    # Create doubled map
    for y in 1:y_max
        for x in 1:x_max
            orig_pos = (x,y)
            new_x = 2x - 1  # Convert x to doubled coordinates
            
            if !haskey(map, orig_pos)
                new_map[(new_x, y)] = '.'
                new_map[(new_x + 1, y)] = '.'
                continue
            end
            
            # Handle each character type
            v = map[orig_pos]
            if v == '@'
                new_map[(new_x, y)] = '@'
                new_map[(new_x + 1, y)] = '.'
                robot_position = (new_x, y)
            elseif v == 'O'
                new_map[(new_x, y)] = '['
                new_map[(new_x + 1, y)] = ']'
                push!(box_positions, ((new_x, new_x + 1), y))
            elseif v == '#'
                new_map[(new_x, y)] = '#'
                new_map[(new_x + 1, y)] = '#'
            elseif v == '.'
                new_map[(new_x, y)] = '.'
                new_map[(new_x + 1, y)] = '.'
            else
                println("Unknown character: ", v)
            end
        end
    end
    
    return Warehouse(new_map, box_positions, robot_position)
end

function print_warehouse(warehouse::Warehouse)
    x_max = maximum([k[1] for k in keys(warehouse.map)])
    y_max = maximum([k[2] for k in keys(warehouse.map)])
    for y in 1:y_max
        for x in 1:x_max
            print(warehouse.map[(x,y)])
        end
        println()
    end
end

old_map, instructions = input_parser("day_15/input.txt")
warehouse = new_warehouse(old_map)

print_warehouse(warehouse)

function update_warehouse(warehouse::Warehouse, instructions::String)::Warehouse
    current_warehouse = deepcopy(warehouse)
    current_pos = warehouse.robot_position
    map = current_warehouse.map

    for instruction in instructions
        map = update_warehouse_map(map, current_pos, instruction)
        current_pos = [k for (k,v) in map if v == '@'][1]
    end

    return Warehouse(map, current_warehouse.box_positions, current_pos)
end

function update_warehouse_map(
    map::Dict{Tuple{Int,Int}, Char},
    robot_position::Tuple{Int,Int},
    box_positions::Vector{Tuple{Tuple{Int,Int}, Int}},
    instructions::Char
)::Dict{Tuple{Int,Int}, Char}
    map = deepcopy(map)
    x, y = robot_position
    
    next_pos = if instructions == '^'
        (x, y-1)
    elseif instructions == 'v'
        (x, y+1)
    elseif instructions == '<'
        (x-1, y)
    elseif instructions == '>'
        (x+1, y)
    else
        return map
    end
    
    next_x, next_y = next_pos
    next_x_plus = next_x + 1
    
    # Check bounds and walls
    if !haskey(map, (next_x, next_y)) || !haskey(map, (next_x_plus, next_y)) ||
       map[(next_x, next_y)] == '#' || map[(next_x_plus, next_y)] == '#'
        return map
    end
    
    # Handle box movement from either side
    is_box_left = map[(next_x, next_y)] == '[' && map[(next_x_plus, next_y)] == ']'
    is_box_right = map[(next_x, next_y)] == ']' && map[(next_x - 1, next_y)] == '['
    is_box_vertical = (map[(next_x, next_y)] == '[' && map[(next_x + 1, next_y)] == ']') ||
                (map[(next_x, next_y)] == ']' && map[(next_x - 1, next_y)] == '[')

    if is_box_vertical
        box_start_x = if instructions == '^'
            next_x
    
    if is_box_left || is_box_right
        box_start_x = is_box_left ? next_x : (next_x - 1)
        box_count = encountered_box_warehouse(map, box_positions, ((box_start_x, box_start_x + 1), next_y), instructions)
        println("Box count: ", box_count)
        
        if box_count > 0
            # Collect all boxes in chain
            boxes = []
            curr_x = box_start_x
            for i in 1:box_count
                push!(boxes, (curr_x, next_y))
                curr_x = if instructions == '<'
                    curr_x - 2
                elseif instructions == '>'
                    curr_x + 2
                else
                    curr_x
                end
            end
            
            # Clear all old box positions
            for (bx, by) in boxes
                map[(bx, by)] = '.'
                map[(bx + 1, by)] = '.'
            end
            
            # Move all boxes
            shift = 1
            for (i, (bx, by)) in enumerate(boxes)
                new_x = if instructions == '<'
                    bx - shift
                elseif instructions == '>'
                    bx + shift
                else
                    bx
                end
                new_y = if instructions == '^'
                    by - shift
                elseif instructions == 'v'
                    by + shift
                else
                    by
                end
                map[(new_x, new_y)] = '['
                map[(new_x + 1, new_y)] = ']'
            end
            
            # Move robot
            map[(x, y)] = '.'
            map[(next_x, next_y)] = '@'
        end
    else
        # Move robot
        map[(x, y)] = '.'
        map[(next_x, next_y)] = '@'
    end
    
    return map
end



function encountered_box_warehouse(
    map::Dict{Tuple{Int,Int}, Char},
    box_positions::Vector{Tuple{Tuple{Int,Int}, Int}},
    position::Tuple{Tuple{Int,Int}, Int},
    instructions::Char
)::Int
    ((x, x_plus), y) = position
    
    # Helper function to check if position contains a box (either orientation)
    function is_box_at(x, y)
        return (map[(x, y)] == '[' && map[(x+1, y)] == ']') ||
               (map[(x-1, y)] == '[' && map[(x, y)] == ']')
    end
    
    # Helper function to check if position is empty
    function is_empty_at(x, y)
        return map[(x, y)] == '.' && map[(x+1, y)] == '.'
    end
    
    next_pos = if instructions == '^'
        ((x, x_plus), y-1)
    elseif instructions == 'v'
        ((x, x_plus), y+1)
    elseif instructions == '<'
        ((x-2, x-1), y)
    elseif instructions == '>'
        ((x+2, x+3), y)
    else
        return 0
    end
    
    ((next_x, next_x_plus), next_y) = next_pos
    
    # Check bounds and walls
    if !haskey(map, (next_x, next_y)) || !haskey(map, (next_x_plus, next_y)) ||
       map[(next_x, next_y)] == '#' || map[(next_x_plus, next_y)] == '#'
        return 0
    end
    
    if instructions in ['^', 'v']
        boxes = 0
        check_y = instructions == '^' ? y-1 : y+1
        
        # Check all possible box positions in column
        while check_y >= 1 && check_y <= maximum(k[2] for k in keys(map))
            # Check all 4 possible positions for a box
            found_box = false
            for check_x in [x-1, x, x+1]
                if is_box_at(check_x, check_y)
                    found_box = true
                    break
                end
            end
            
            if !found_box
                # If we find empty space, chain is valid
                if any(is_empty_at(check_x, check_y) for check_x in [x-1, x, x+1])
                    return boxes + 1
                end
                # If we find wall or invalid space, chain is invalid
                return 0
            end
            
            boxes += 1
            check_y = instructions == '^' ? check_y-1 : check_y+1
        end
        return 0
    end
    
    # Horizontal movement remains the same
    if map[(next_x, next_y)] == '[' && map[(next_x_plus, next_y)] == ']'
        chain_length = encountered_box_warehouse(map, box_positions, next_pos, instructions)
        return chain_length == 0 ? 0 : chain_length + 1
    end
    
    if map[(next_x, next_y)] == '.' && map[(next_x_plus, next_y)] == '.'
        return 1
    end
    
    return 0
end

function move_robot_warehouse(warehouse::Warehouse, instructions::String)
    current_warehouse = deepcopy(warehouse)
    current_pos = current_warehouse.robot_position
    current_map = current_warehouse.map
    box_positions = current_warehouse.box_positions

    for instruction in instructions
        current_map = update_warehouse_map(
            current_map, 
            current_pos, 
            box_positions, 
            instruction
        )
        print_warehouse(Warehouse(current_map, box_positions, current_pos))
        current_pos = [k for (k,v) in current_map if v == '@'][1]
    end

    return Warehouse(current_map, box_positions, current_pos)
end



function count_boxes_warehouse(warehouse::Warehouse)
    count = 0
    for (k, v) in warehouse.map
        if v == '['
            count += 100 * (k[2] - 1) + (k[1][1] - 2)
        end
    end
    return count
end

# Use different variable name for result
final_warehouse = move_robot_warehouse(warehouse, instructions)
print_warehouse(final_warehouse)
println("The sum of the coordinates of the boxes in the warehouse is: ", 
        count_boxes_warehouse(final_warehouse))    
    
    
    