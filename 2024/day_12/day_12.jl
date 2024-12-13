include("../utils.jl")

input_map = AdventUtils.read_input_as_map("day_12/input.txt")

x_lim, y_lim = maximum(collect(keys(input_map)))

# for i in 1:x_lim
#     for j in 1:y_lim
#         print(input_map[(i, j)], " ")
#     end
#     println()
# end

println("==============================================================")

## Part 1

function isinside(input_map::Dict{Tuple{Int, Int}, Char}, x::Int, y::Int, value::Char)::Bool
    x_lim, y_lim = maximum(collect(keys(input_map)))
    # we need to check if at least one of the neighbors has the same value
    if x > 1 && input_map[(x-1, y)] == value
        return true
    end
    if x < x_lim && input_map[(x+1, y)] == value
        return true
    end
    if y > 1 && input_map[(x, y-1)] == value
        return true
    end
    if y < y_lim && input_map[(x, y+1)] == value
        return true
    end
    return false
end
        

function find_region(input_map::Dict{Tuple{Int, Int}, Char}, x::Int, y::Int)::Vector{Tuple{Int, Int}}
    # Initialize variables
    region = Set{Tuple{Int, Int}}()
    value = input_map[(x, y)]
    x_lim, y_lim = maximum(collect(keys(input_map)))
    
    # Add starting point
    push!(region, (x, y))
    
    # Expand region until no new points found
    while true
        new_region = Set{Tuple{Int, Int}}()
        
        # Check neighbors of each point in region
        for point in region
            x, y = point
            # Check all four directions
            for (dx, dy) in [(-1,0), (1,0), (0,-1), (0,1)]
                new_x, new_y = x + dx, y + dy
                if 1 <= new_x <= x_lim && 
                   1 <= new_y <= y_lim && 
                   input_map[(new_x, new_y)] == value && 
                   !in((new_x, new_y), region)
                    push!(new_region, (new_x, new_y))
                end
            end
        end
        
        # If no new points found, we're done
        if isempty(new_region)
            break
        end
        
        # Add new points to region
        union!(region, new_region)
    end
    
    return collect(region)
end

function find_all_regions(input_map::Dict{Tuple{Int, Int}, Char})::Vector{Vector{Tuple{Int, Int}}}
    x_lim, y_lim = maximum(collect(keys(input_map)))
    seen = Set{Tuple{Int, Int}}()
    regions = Vector{Vector{Tuple{Int, Int}}}()
    
    for i in 1:x_lim
        for j in 1:y_lim
            if !in((i, j), seen)
                region = find_region(input_map, i, j)
                push!(regions, region)
                union!(seen, region)
            end
        end
    end
    return regions
end

# ANSI color codes mapping
const COLOURS = Dict(
    "black" => "\033[0;30m",
    "red" => "\033[0;31m",
    "green" => "\033[0;32m",
    "yellow" => "\033[0;33m",
    "blue" => "\033[0;34m",
    "magenta" => "\033[0;35m",
    "cyan" => "\033[0;36m",
    "white" => "\033[0;37m",
    "bright_black" => "\033[1;30m",
    "bright_red" => "\033[1;31m",
    "bright_green" => "\033[1;32m",
    "bright_yellow" => "\033[1;33m",
    "bright_blue" => "\033[1;34m",
    "bright_magenta" => "\033[1;35m",
    "bright_cyan" => "\033[1;36m",
    "bright_white" => "\033[1;37m"
)

regions = find_all_regions(input_map)
colors = Dict{Vector{Tuple{Int, Int}}, String}()

# Assign colors using modulo
for (i, region) in enumerate(regions)
    color_idx = ((i-1) % length(COLOURS)) + 1
    colors[region] = collect(keys(COLOURS))[color_idx]
end

# Print colored map
for i in 1:x_lim
    for j in 1:y_lim
        color_found = false
        for (region, color) in colors
            if in((i, j), region)
                print(COLOURS[color], input_map[(i, j)], " ")
                color_found = true
                break
            end
        end
        if !color_found
            print("\033[0m", input_map[(i, j)], " ")  # Default color
        end
    end
    println("\033[0m")  # Reset color at end of line
end

function compute_area(input_map::Dict{Tuple{Int, Int}, Char}, region::Vector{Tuple{Int, Int}})::Int
    return length(region)
end
function count_neighbours(input_map::Dict{Tuple{Int, Int}, Char}, x::Int, y::Int, value::Char)::Int
    x_lim, y_lim = maximum(collect(keys(input_map)))
    count = 0
    if x > 1 && input_map[(x-1, y)] != value
        count += 1
    end
    if x < x_lim && input_map[(x+1, y)] != value
        count += 1
    end
    if y > 1 && input_map[(x, y-1)] != value
        count += 1
    end
    if y < y_lim && input_map[(x, y+1)] != value
        count += 1
    end
    if !haskey(input_map, (x-1, y))
        count += 1
    end
    if !haskey(input_map, (x+1, y))
        count += 1
    end
    if !haskey(input_map, (x, y-1))
        count += 1
    end
    if !haskey(input_map, (x, y+1))
        count += 1
    end
    return count
end

function compute_perimeter(input_map::Dict{Tuple{Int, Int}, Char}, region::Vector{Tuple{Int, Int}})::Int
    perimeter = 0
    for (x, y) in region
        perimeter += count_neighbours(input_map, x, y, input_map[(x, y)])
    end
    return perimeter
end

function compute_price(input_map::Dict{Tuple{Int, Int}, Char}, region::Vector{Tuple{Int, Int}})::Int
    area = compute_area(input_map, region)
    perimeter = compute_perimeter(input_map, region)
    return area * perimeter
end

function compute_total_price(input_map::Dict{Tuple{Int, Int}, Char}, regions::Vector{Vector{Tuple{Int, Int}}})::Int
    total_price = 0
    for region in regions
        total_price += compute_price(input_map, region)
    end
    return total_price
end

total_price = compute_total_price(input_map, regions)

println("Total price: ", total_price)

### Part 2

### For part two we need to count how many sides are present on each region. A side is composed of one or more cells that are on the edge. When the edge changes direction, we have a new side. We can count the number of sides by counting the number of times the edge changes direction.

struct Plot
    positions::Set{Tuple{Int,Int}}
end

function calculate_corners(region::Vector{Tuple{Int,Int}})::Int
    positions = Set(region)
    corners = 0
    
    for pos in region
        x, y = pos
        # Define all 8 neighboring positions
        neighbors = Dict(
            "u"  => (x-1, y),
            "ur" => (x-1, y+1),
            "r"  => (x, y+1),
            "dr" => (x+1, y+1),
            "d"  => (x+1, y),
            "dl" => (x+1, y-1),
            "l"  => (x, y-1),
            "ul" => (x-1, y-1)
        )
        
        # Check all corner cases
        # Outer corners
        if all(!in(neighbors[d], positions) for d in ["u","ur","r"])
            corners += 1
        end
        if all(!in(neighbors[d], positions) for d in ["u","ul","l"])
            corners += 1
        end
        if all(!in(neighbors[d], positions) for d in ["d","dl","l"])
            corners += 1
        end
        if all(!in(neighbors[d], positions) for d in ["d","dr","r"])
            corners += 1
        end
        
        # Inner corners
        for (p1, p2, corner) in [
            ("u","r","ur"), ("u","l","ul"), 
            ("d","l","dl"), ("d","r","dr")
        ]
            if in(neighbors[p1], positions) && 
               in(neighbors[p2], positions) && 
               !in(neighbors[corner], positions)
                corners += 1
            end
            if !in(neighbors[p1], positions) && 
               !in(neighbors[p2], positions) && 
               in(neighbors[corner], positions)
                corners += 1
            end
        end
    end
    
    return corners
end

# Usage
function count_sides(region::Vector{Tuple{Int,Int}})::Int
    return calculate_corners(region)
end

function compute_bulk_price(input_map::Dict{Tuple{Int, Int}, Char}, region::Vector{Tuple{Int, Int}})::Int
    area = compute_area(input_map, region)
    sides = count_sides(region)
    return area * sides
end

function compute_total_bulk_price(input_map::Dict{Tuple{Int, Int}, Char}, regions::Vector{Vector{Tuple{Int, Int}}})::Int
    total_price = 0
    for region in regions
        total_price += compute_bulk_price(input_map, region)
    end
    return total_price
end

total_bulk_price = compute_total_bulk_price(input_map, regions)

println("Total bulk price: ", total_bulk_price)