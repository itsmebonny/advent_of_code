include("../utils.jl")

input_map = AdventUtils.read_input_as_map("day_8/input.txt")

# x_lim, y_lim = maximum(keys(input_map))

# for i in 1:x_lim
#     for j in 1:y_lim
#         print(input_map[(i, j)])
#     end
#     println()
# end

### Part 1

function compute_l_infty_distance(pos1::Tuple{Int64, Int64}, pos2::Tuple{Int64, Int64})::Tuple{Int64, Int64}
    #compute the L_infty distance between two positions
    x1, y1 = pos1
    x2, y2 = pos2
    return (x1 - x2, y1 - y2)
end

function find_symmetric_positions(map::Dict{Tuple{Int64, Int64}, Char}, pos::Tuple{Int64, Int64}, pos2::Tuple{Int64, Int64})::Vector{Tuple{Int64, Int64}}
    #find the positions that are on the same line that connects pos and pos2 and also inside the bounds of the map
    # these at most two positions must be at the same distance from one position as the other
    x1, y1 = pos
    x2, y2 = pos2
    x_lim, y_lim = maximum(keys(map))
    positions = Vector{Tuple{Int64, Int64}}()

    distance = compute_l_infty_distance(pos, pos2)


    if x1 + distance[1] == x2 && y1 + distance[2] == y2
        x_symmetric = x1 - distance[1]
        y_symmetric = y1 - distance[2]
        if x_symmetric > 0 && x_symmetric <= x_lim && y_symmetric > 0 && y_symmetric <= y_lim
            push!(positions, (x_symmetric, y_symmetric))
        end
    elseif x1 - distance[1] == x2 && y1 - distance[2] == y2
        x_symmetric = x1 + distance[1]
        y_symmetric = y1 + distance[2]
        if x_symmetric > 0 && x_symmetric <= x_lim && y_symmetric > 0 && y_symmetric <= y_lim
            push!(positions, (x_symmetric, y_symmetric))
        end
    end
    # do the same for the other position
    if x2 + distance[1] == x1 && y2 + distance[2] == y1
        x_symmetric = x2 - distance[1]
        y_symmetric = y2 - distance[2]
        if x_symmetric > 0 && x_symmetric <= x_lim && y_symmetric > 0 && y_symmetric <= y_lim
            push!(positions, (x_symmetric, y_symmetric))
        end
    elseif x2 - distance[1] == x1 && y2 - distance[2] == y1
        x_symmetric = x2 + distance[1]
        y_symmetric = y2 + distance[2]
        if x_symmetric > 0 && x_symmetric <= x_lim && y_symmetric > 0 && y_symmetric <= y_lim
            push!(positions, (x_symmetric, y_symmetric))
        end
    end


    return positions
end
    

function find_all_symmetric_positions(map::Dict{Tuple{Int64, Int64}, Char}, type::Char)::Vector{Vector{Tuple{Int64, Int64}}}
    #find all the symmetric positions for the given type
    positions = Vector{Vector{Tuple{Int64, Int64}}}()
    visited_pairs = Set{Set{Tuple{Int64, Int64}}}()
    for (pos, value) in map
        if value == type
            for (pos2, value2) in map
                if value2 == type && pos != pos2
                    pair = Set([pos, pos2])
                    if !(pair in visited_pairs)
                        push!(visited_pairs, pair)
                        push!(positions, find_symmetric_positions(map, pos, pos2))
                    end
                end
            end
        end
    end
    
    return positions

end

function find_antinodes(map::Dict{Tuple{Int64, Int64}, Char})::Set{Tuple{Int64, Int64}}
    antinodes = Vector{Vector{Vector{Tuple{Int64, Int64}}}}()
    for (pos, value) in map
        if value != '.'
            push!(antinodes, find_all_symmetric_positions(map, value))
        end
    end
    antinode_set = Set{Tuple{Int64, Int64}}()
    for node in antinodes
        for pair in node
            for pos in pair
                push!(antinode_set, pos)
            end
        end
    end
    return antinode_set
end


antinodes = find_antinodes(input_map)

println("The number of antinodes is: ", length(antinodes))

### Part 2

function find_resonant_positions(map::Dict{Tuple{Int64, Int64}, Char}, pos::Tuple{Int64, Int64}, pos2::Tuple{Int64, Int64})::Vector{Tuple{Int64, Int64}}
    #find the positions that are on the same line that connects pos and pos2 and also inside the bounds of the map
    # these at most two positions must be at the same distance from one position as the other
    x1, y1 = pos
    x2, y2 = pos2
    x_lim, y_lim = maximum(keys(map))
    positions = Vector{Tuple{Int64, Int64}}()

    push!(positions, pos)
    push!(positions, pos2)

    distance = compute_l_infty_distance(pos, pos2)
    d1 = '+'
    d2 = '+'
    

    if x1 + distance[1] == x2 && y1 + distance[2] == y2
        x1_symmetric = x1 - distance[1]
        y1_symmetric = y1 - distance[2]
        if x1_symmetric > 0 && x1_symmetric <= x_lim && y1_symmetric > 0 && y1_symmetric <= y_lim
            push!(positions, (x1_symmetric, y1_symmetric))
            d1 = '-'
        end
    elseif x1 - distance[1] == x2 && y1 - distance[2] == y2
        x1_symmetric = x1 + distance[1]
        y1_symmetric = y1 + distance[2]
        if x1_symmetric > 0 && x1_symmetric <= x_lim && y1_symmetric > 0 && y1_symmetric <= y_lim
            push!(positions, (x1_symmetric, y1_symmetric))
            d1 = '+'
        end
    end
    # do the same for the other position
    if x2 + distance[1] == x1 && y2 + distance[2] == y1
        x2_symmetric = x2 - distance[1]
        y2_symmetric = y2 - distance[2]
        if x2_symmetric > 0 && x2_symmetric <= x_lim && y2_symmetric > 0 && y2_symmetric <= y_lim
            push!(positions, (x2_symmetric, y2_symmetric))
            d2 = '-'
        end
    elseif x2 - distance[1] == x1 && y2 - distance[2] == y1
        x2_symmetric = x2 + distance[1]
        y2_symmetric = y2 + distance[2]
        if x2_symmetric > 0 && x2_symmetric <= x_lim && y2_symmetric > 0 && y2_symmetric <= y_lim
            push!(positions, (x2_symmetric, y2_symmetric))
            d2 = '+'
        end
    end

    while x1_symmetric > 0 && x1_symmetric <= x_lim && y1_symmetric > 0 && y1_symmetric <= y_lim
        if d1 == '+'
            x1_symmetric += distance[1]
            y1_symmetric += distance[2]
        else
            x1_symmetric -= distance[1]
            y1_symmetric -= distance[2]
        end
        if x1_symmetric > 0 && x1_symmetric <= x_lim && y1_symmetric > 0 && y1_symmetric <= y_lim
            push!(positions, (x1_symmetric, y1_symmetric))
        end
    end
    while x2_symmetric > 0 && x2_symmetric <= x_lim && y2_symmetric > 0 && y2_symmetric <= y_lim
        if d2 == '+'
            x2_symmetric += distance[1]
            y2_symmetric += distance[2]
        else
            x2_symmetric -= distance[1]
            y2_symmetric -= distance[2]
        end
        if x2_symmetric > 0 && x2_symmetric <= x_lim && y2_symmetric > 0 && y2_symmetric <= y_lim
            push!(positions, (x2_symmetric, y2_symmetric))
        end
    end


    return positions
end
    

function find_all_resonant_positions(map::Dict{Tuple{Int64, Int64}, Char}, type::Char)::Vector{Vector{Tuple{Int64, Int64}}}
    #find all the symmetric positions for the given type
    positions = Vector{Vector{Tuple{Int64, Int64}}}()
    visited_pairs = Set{Set{Tuple{Int64, Int64}}}()
    for (pos, value) in map
        if value == type
            for (pos2, value2) in map
                if value2 == type && pos != pos2
                    pair = Set([pos, pos2])
                    if !(pair in visited_pairs)
                        push!(visited_pairs, pair)
                        push!(positions, find_resonant_positions(map, pos, pos2))
                    end
                end
            end
        end
    end
    
    return positions

end

function find_resonant_nodes(map::Dict{Tuple{Int64, Int64}, Char})::Set{Tuple{Int64, Int64}}
    resonant_nodes = Vector{Vector{Vector{Tuple{Int64, Int64}}}}()
    for (pos, value) in map
        if value != '.'
            push!(resonant_nodes, find_all_resonant_positions(map, value))
        end
    end
    resonant_node_set = Set{Tuple{Int64, Int64}}()
    for node in resonant_nodes
        for pair in node
            for pos in pair
                push!(resonant_node_set, pos)
            end
        end
    end
    return resonant_node_set
end
x_lim, y_lim = maximum(keys(input_map))
#pretty print the resonant nodes
resonant_nodes = find_resonant_nodes(input_map)

println("The number of resonant nodes is: ", length(resonant_nodes))